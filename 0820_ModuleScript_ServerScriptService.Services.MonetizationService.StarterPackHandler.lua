--[[
  Extracted from: ServerScriptService.Services.MonetizationService.StarterPackHandler
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")

local Packages = ReplicatedStorage.Packages
local Data = ReplicatedStorage.Datas
local Net = require(Packages.Net)
local ShopData = require(Data.Shop)

local StarterPackHandler = {}
StarterPackHandler.__index = StarterPackHandler

function StarterPackHandler.new(monetizationService)
	local self = setmetatable({}, StarterPackHandler)

	self._monetizationService = monetizationService
	self._purchaseRemote = Net:RemoteEvent("ShopService/Purchase")

	self:_setupRemoteEvents()

	return self
end

function StarterPackHandler:_setupRemoteEvents()
	self._purchaseRemote.OnServerEvent:Connect(function(player, productId)
		if self:_isStarterPackProduct(productId) then
			self:PromptPurchase(player, productId)
		end
	end)
end

function StarterPackHandler:_isStarterPackProduct(productId)
	local productInfo = ShopData[tonumber(productId)]
	return productInfo and productInfo.Type == "StarterPack"
end

function StarterPackHandler:PromptPurchase(player, productId)
	if not self._monetizationService:IsDataReady(player) then
		warn("[StarterPackHandler] Player data not ready for purchase:", player.Name)
		return false
	end

	local data = self._monetizationService:GetPlayerData(player)
	if not data then
		warn("[StarterPackHandler] No data found for player:", player.Name)
		return false
	end

	local productInfo = ShopData[tonumber(productId)]
	if not productInfo then
		warn("[StarterPackHandler] Product not found:", productId)
		return false
	end

	if data.BoughtStarterPack then
		warn("[StarterPackHandler] Player already owns starter pack:", player.Name)
		return false
	end

	if productInfo.Rewards and productInfo.Rewards.Items then
		local hasAllItems = true
		for _, itemName in pairs(productInfo.Rewards.Items) do
			if not (data.Inventory and data.Inventory[itemName]) then
				hasAllItems = false
				break
			end
		end
		if hasAllItems then
			data.BoughtStarterPack = true
			local playerPlot = self._monetizationService:GetPlayerSynchronizer(player)
			if playerPlot then
				playerPlot:Set("BoughtStarterPack", true)
			end
			return false
		end
	end

	local marketplaceInfo = self._monetizationService:GetProductInfo(tonumber(productId))
	if not marketplaceInfo then
		warn("[StarterPackHandler] Failed to get marketplace info for:", productId)
		return false
	end

	return self._monetizationService:PromptProductPurchase(player, tonumber(productId))
end

function StarterPackHandler:ProcessPurchase(player, productId, receiptInfo)
	if not self._monetizationService:IsDataReady(player) then
		warn("[StarterPackHandler] Player data not ready for processing:", player.Name)
		return false
	end

	local playerPlot = self._monetizationService:GetPlayerSynchronizer(player)
	if not playerPlot then
		warn("[StarterPackHandler] No player synchronizer found for:", player.Name)
		return false
	end

	local data = self._monetizationService:GetPlayerData(player)
	if not data then
		warn("[StarterPackHandler] No data found for player:", player.Name)
		return false
	end

	local productInfo = ShopData[productId]
	if not productInfo or productInfo.Type ~= "StarterPack" then
		warn("[StarterPackHandler] Invalid starter pack product:", productId)
		return false
	end

	if productInfo.Rewards and productInfo.Rewards.Items then
		local hasAllItems = true
		for _, itemName in pairs(productInfo.Rewards.Items) do
			if not (data.Inventory and data.Inventory[itemName]) then
				hasAllItems = false
				break
			end
		end
		if hasAllItems then
		--	print("[StarterPackHandler] Player already has all starter pack items:", player.Name)
			return true
		end
	end

	data.Inventory = data.Inventory or {}
	data.Items = data.Items or {}

	if productInfo.Rewards and productInfo.Rewards.Items then
		for _, itemName in pairs(productInfo.Rewards.Items) do
			data.Inventory[itemName] = true
			data.Items[itemName] = true
			playerPlot:InsertOnDictionary("Items", itemName, true)
			playerPlot:InsertOnDictionary("Inventory", itemName, true)
		end

		playerPlot:Set("Items", data.Items)
		playerPlot:Set("Inventory", data.Inventory)
	end

	if productInfo.Rewards and productInfo.Rewards.Animals then
		local DataManagement = require(game.ServerScriptService.Services.DataManagment)
		for _, animalName in pairs(productInfo.Rewards.Animals) do
			DataManagement.addAnimal(player, animalName)
		end
	end

	if productInfo.Rewards and productInfo.Rewards.Coins then
		data.Coins = (data.Coins or 0) + productInfo.Rewards.Coins
		playerPlot:Set("Coins", data.Coins)
	end

	data.BoughtStarterPack = true
	playerPlot:Set("BoughtStarterPack", true)

	self._monetizationService:LogPurchase(player, productId, "StarterPack", "Starter Pack purchased")

	return true
end

function StarterPackHandler:OnPurchaseFinished(player, productId, isPurchased)
	if not isPurchased then
	--	print("[StarterPackHandler] Purchase was cancelled for player:", player.Name, "Product:", productId)
		return
	end

	task.wait(1)

	local data = self._monetizationService:GetPlayerData(player)
	if data and data.BoughtStarterPack then
		local productInfo = ShopData[3373926350]
		if productInfo and productInfo.Rewards and productInfo.Rewards.Items then
			if player.Character and player.Backpack then
				for _, itemName in pairs(productInfo.Rewards.Items) do
					local hasToolInBackpack = player.Backpack:FindFirstChild(itemName) ~= nil
					if not hasToolInBackpack then
						local tool = ReplicatedStorage.Items:FindFirstChild(itemName)
						if tool and tool:IsA("Tool") then
							local clonedTool = tool:Clone()
							clonedTool.Parent = player.Backpack
						end
					end
				end
			end
		end
	end
end

function StarterPackHandler:_giveToolsToPlayer(player, itemNames)
	if not player.Character or not player.Backpack then
		warn("[StarterPackHandler] Player character or backpack not available:", player.Name)
		return false
	end

	local toolsGiven = 0
	for _, itemName in pairs(itemNames) do
		local tool = ReplicatedStorage.Items:FindFirstChild(itemName)
		if tool and tool:IsA("Tool") then
			local existingTool = player.Backpack:FindFirstChild(itemName)
			if not existingTool then
				local clonedTool = tool:Clone()
				clonedTool.Parent = player.Backpack
				toolsGiven = toolsGiven + 1
			end
		else
			warn("[StarterPackHandler] Tool not found or invalid:", itemName)
		end
	end

	return toolsGiven > 0
end

function StarterPackHandler:CheckAndUpdateOwnership(player)
	if not self._monetizationService:IsDataReady(player) then
		return false
	end

	local data = self._monetizationService:GetPlayerData(player)
	if not data then
		return false
	end

	local isOwned = data.BoughtStarterPack or false

	if not isOwned and data.Items then
		local productInfo = ShopData[3373926350]
		if productInfo and productInfo.Rewards and productInfo.Rewards.Items then
			local hasAllItems = true
			for _, itemName in pairs(productInfo.Rewards.Items) do
				if not data.Items[itemName] then
					hasAllItems = false
					break
				end
			end
			if hasAllItems then
				data.BoughtStarterPack = true
				local playerPlot = self._monetizationService:GetPlayerSynchronizer(player)
				if playerPlot then
					playerPlot:Set("BoughtStarterPack", true)
				end
				isOwned = true
			end
		end
	end

	if isOwned and player.Character and player.Backpack then
		local productInfo = ShopData[3373926350]
		if productInfo and productInfo.Rewards and productInfo.Rewards.Items then
			local missingTools = {}
			for _, itemName in pairs(productInfo.Rewards.Items) do
				if not player.Backpack:FindFirstChild(itemName) then
					table.insert(missingTools, itemName)
				end
			end

			if #missingTools > 0 then
				self:_giveToolsToPlayer(player, missingTools)
			end
		end
	end

	return isOwned
end

function StarterPackHandler:SetupOwnershipMonitoring(player)
	if not self._monetizationService:IsDataReady(player) then
		return
	end

	local playerPlot = self._monetizationService:GetPlayerSynchronizer(player)
	if not playerPlot then
		return
	end

	playerPlot:OnDictionaryInserted("Items", function(key, value)
		if value == true then
			local productInfo = ShopData[3373926350]
			if productInfo and productInfo.Rewards and productInfo.Rewards.Items then
				for _, itemName in pairs(productInfo.Rewards.Items) do
					if key == itemName then
						task.wait(0.1) 
						self:CheckAndUpdateOwnership(player)
						break
					end
				end
			end
		end
	end)
end

function StarterPackHandler:IsStarterPackOwned(player)
	if not self._monetizationService:IsDataReady(player) then
		return false
	end

	local data = self._monetizationService:GetPlayerData(player)
	if not data then
		return false
	end

	if data.BoughtStarterPack then
		return true
	end

	if data.Items then
		local productInfo = ShopData[3373926350]
		if productInfo and productInfo.Rewards and productInfo.Rewards.Items then
			for _, itemName in pairs(productInfo.Rewards.Items) do
				if not data.Items[itemName] then
					return false
				end
			end
			return true
		end
	end

	return false
end

return StarterPackHandler