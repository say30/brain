--[[
  Extracted from: ServerScriptService.Main.Player.CoinShop
  Class: Script
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")
local Packages = ReplicatedStorage:WaitForChild("Packages")
local Data = ReplicatedStorage:WaitForChild("Datas")

local DataManagment = require(ServerScriptService.Services.DataManagment)
local Net = require(Packages.Net)
local Synchronizer = require(Packages.Synchronizer)
local ShopItems = require(ReplicatedStorage.Datas.ShopItems)

local Remotefunction = Net:RemoteFunction("CoinsShopService/RequestBuy")
local ToggleAutoBuyRemote = Net:RemoteFunction("CoinsShopService/ToggleAutoBuy")

local SessionInventories = {}

local PurchaseCooldown = {}
local COOLDOWN_TIME = 1

local function ProcessAutoBuy(player)
	local Data = DataManagment.GetDataMan(player)
	if not Data then
		return
	end

	local autoBuySettings = Data.AutoBuySettings or {}

	for itemName, isEnabled in pairs(autoBuySettings) do
		if isEnabled then
			local itemData = ShopItems[itemName]
			if itemData then
				local canBuy = true

				if itemData.IsEnabled and type(itemData.IsEnabled) == "function" then
					local success, isItemEnabled = pcall(itemData.IsEnabled)
					if not success or not isItemEnabled then
						canBuy = false
					end
				end

				if canBuy and itemData.RebirthRequired then
					local playerRebirths = Data.Rebirths or 0
					if playerRebirths < itemData.RebirthRequired then
						canBuy = false
					end
				end

				if canBuy and (type(Data.Coins) ~= "number" or Data.Coins < itemData.Price) then
					canBuy = false
				end

				local itemTool = ReplicatedStorage.Items:FindFirstChild(itemName)
				if canBuy and not itemTool then
					canBuy = false
				end

				if canBuy then
					local currentQuantity = 0

					for _, tool in pairs(player.Backpack:GetChildren()) do
						if tool:IsA("Tool") and tool.Name == itemName then
							currentQuantity = currentQuantity + 1
						end
					end

					if player.Character then
						for _, tool in pairs(player.Character:GetChildren()) do
							if tool:IsA("Tool") and tool.Name == itemName then
								currentQuantity = currentQuantity + 1
							end
						end
					end

					local maxQuantity = 1
					if itemName == "Trap" then
						maxQuantity = 5
					end

					if currentQuantity >= maxQuantity then
						canBuy = false
					end
				end

				if canBuy then
					Data.Coins = Data.Coins - itemData.Price

					local playerSync = Synchronizer:Get(player)
					if playerSync then
						playerSync:Set("Coins", Data.Coins)
					end

					if not SessionInventories[player.UserId] then
						SessionInventories[player.UserId] = {}
					end

					table.insert(SessionInventories[player.UserId], itemName)

					local ToolClone = itemTool:Clone()
					ToolClone.Parent = player.Backpack

					if itemName == "Trap" then
						local currentCount = player:GetAttribute("TrapCount") or 0
						currentCount = currentCount + 1
						player:SetAttribute("TrapCount", currentCount)
					end
				end
			end
		end
	end
end

local function RestoreInventory(player)
	local sessionInventory = SessionInventories[player.UserId]
	if not sessionInventory then
		return
	end

	for _, itemName in sessionInventory do
		local item = ReplicatedStorage.Items:FindFirstChild(itemName)
		if item then
			local ToolClone = item:Clone()
			ToolClone.Parent = player.Backpack
		end
	end
end

ToggleAutoBuyRemote.OnServerInvoke = function(player, itemName, enabled)
	local Data = DataManagment.GetDataMan(player)
	if not Data then
		return false, "Failed to load player data"
	end

	if type(itemName) ~= "string" or itemName == "" then
		return false, "Invalid item specified"
	end

	local itemData = ShopItems[itemName]
	if not itemData then
		return false, "Item not found in shop"
	end

	if not Data.AutoBuySettings then
		Data.AutoBuySettings = {}
	end

	if enabled == nil then
		Data.AutoBuySettings[itemName] = not Data.AutoBuySettings[itemName]
	else
		Data.AutoBuySettings[itemName] = enabled
	end

	local playerSync = Synchronizer:Get(player)
	if playerSync then
		local autoBuyTable = playerSync:Get("AutoBuy")
		if not autoBuyTable then
			playerSync:Set("AutoBuy", {})
		end
		playerSync:Set("AutoBuy." .. itemName, Data.AutoBuySettings[itemName])
	end

	if Data.AutoBuySettings[itemName] then
		ProcessAutoBuy(player)
	end

	return true, "Auto-buy setting updated"
end

Remotefunction.OnServerInvoke = function(player, itemName)
	local now = tick()
	local lastTime = PurchaseCooldown[player.UserId] or 0

	if now - lastTime < COOLDOWN_TIME then
		return false, "Hold on! You need to wait a bit before doing that again."
	end

	PurchaseCooldown[player.UserId] = now

	local Data = DataManagment.GetDataMan(player)
	if not Data then
		return false, "Failed to load player data"
	end

	if type(itemName) ~= "string" or itemName == "" then
		return false, "Invalid item specified"
	end

	local itemData = ShopItems[itemName]
	if not itemData then
		return false, "Item not found in shop"
	end

	if type(itemData.Price) ~= "number" or itemData.Price <= 0 then
		return false, "Invalid item price"
	end

	if itemData.IsEnabled and type(itemData.IsEnabled) == "function" then
		local success, isEnabled = pcall(itemData.IsEnabled)
		if not success or not isEnabled then
			return false, "Item is currently disabled"
		end
	end

	if itemData.RebirthRequired then
		local playerRebirths = Data.Rebirths or 0
		if playerRebirths < itemData.RebirthRequired then
			return false, "Rebirth " .. itemData.RebirthRequired .. " required"
		end
	end

	if type(Data.Coins) ~= "number" or Data.Coins < itemData.Price then
		return false, "Purchase failed! You don't have enough Coins!"
	end

	local itemTool = ReplicatedStorage.Items:FindFirstChild(itemName)
	if not itemTool then
		return false, "Item tool not found"
	end

	local currentQuantity = 0
	for _, tool in pairs(player.Backpack:GetChildren()) do
		if tool:IsA("Tool") and tool.Name == itemName then
			currentQuantity = currentQuantity + 1
		end
	end

	if player.Character then
		for _, tool in pairs(player.Character:GetChildren()) do
			if tool:IsA("Tool") and tool.Name == itemName then
				currentQuantity = currentQuantity + 1
			end
		end
	end

	local maxQuantity = 1
	if itemName == "Trap" then
		maxQuantity = 5
	end

	if currentQuantity >= maxQuantity then
		if maxQuantity == 1 then
			return false, string.format("Purchase failed! You already own this item: %s.", itemName)
		else
			return false, "You already own the maximum amount of this item! (" .. maxQuantity .. " max)"
		end
	end

	Data.Coins = Data.Coins - itemData.Price

	local playerSync = Synchronizer:Get(player)
	if playerSync then
		playerSync:Set("Coins", Data.Coins)
	end

	if not SessionInventories[player.UserId] then
		SessionInventories[player.UserId] = {}
	end

	table.insert(SessionInventories[player.UserId], itemName)

	local ToolClone = itemTool:Clone()
	if itemName == "Trap" then
		local currentCount = player:GetAttribute("TrapCount") or 0
		currentCount = currentCount + 1
		player:SetAttribute("TrapCount", currentCount)
	end

	ToolClone.Parent = player.Backpack

	return true, string.format("Purchase successful! You bought %s.", itemName)
end

Players.PlayerAdded:Connect(function(player)
	SessionInventories[player.UserId] = {} 
	task.spawn(function()
		task.wait(5)

		local Data = DataManagment.GetDataMan(player)
		if Data and Data.AutoBuySettings then
			local playerSync = Synchronizer:Get(player)
			if playerSync then
				local autoBuyTable = playerSync:Get("AutoBuy")
				if not autoBuyTable then
					playerSync:Set("AutoBuy", {})
				end
				for itemName, isEnabled in pairs(Data.AutoBuySettings) do
					playerSync:Set("AutoBuy." .. itemName, isEnabled)
				end
			end
		end

		if not table.find(SessionInventories[player.UserId], "Tung Bat") then
			table.insert(SessionInventories[player.UserId], "Tung Bat")
			local Bat = ReplicatedStorage.Items["Tung Bat"]:Clone()
			Bat.Parent = player.Backpack
		end

		RestoreInventory(player)

		local backpack = player:WaitForChild("Backpack")
		local tungBatTool = backpack:FindFirstChild("Tung Bat")
		if not tungBatTool then
			backpack.ChildAdded:Wait()
			repeat
				tungBatTool = backpack:FindFirstChild("Tung Bat")
				task.wait()
			until tungBatTool
		end

		ProcessAutoBuy(player)
	end)

	player.CharacterAdded:Connect(function()
		task.wait(2)
		RestoreInventory(player)
	end)
end)

Players.PlayerRemoving:Connect(function(player)
	SessionInventories[player.UserId] = nil 
end)

task.spawn(function()
	for _, player in pairs(Players:GetPlayers()) do
		if player and player.Parent then
			local Data = DataManagment.GetDataMan(player)
			if Data and Data.AutoBuySettings then
				local playerSync = Synchronizer:Get(player)
				if playerSync then
					local autoBuyTable = playerSync:Get("AutoBuy")
					if not autoBuyTable then
						playerSync:Set("AutoBuy", {})
					end
					for itemName, isEnabled in pairs(Data.AutoBuySettings) do
						playerSync:Set("AutoBuy." .. itemName, isEnabled)
					end
				end
			end

			ProcessAutoBuy(player)
		end
	end
end)