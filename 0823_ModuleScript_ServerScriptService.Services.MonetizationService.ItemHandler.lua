--[[
  Extracted from: ServerScriptService.Services.MonetizationService.ItemHandler
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Packages = ReplicatedStorage.Packages
local Data = ReplicatedStorage.Datas
local Net = require(Packages.Net)
local ShopData = require(Data.Shop)

local ItemHandler = {}
ItemHandler.__index = ItemHandler

function ItemHandler.new(monetizationService)
	local self = setmetatable({}, ItemHandler)
	self._monetizationService = monetizationService
	self._purchaseRemote = Net:RemoteEvent("ShopService/Purchase")

	self:_setupRemoteEvents()
	self:_setupPlayerEvents()

	--print("[ItemHandler] Initialized successfully")
	return self
end

function ItemHandler:_setupRemoteEvents()
	self._purchaseRemote.OnServerEvent:Connect(function(player, productId, giftPlayer)
		if self:_isItemProduct(productId) then
			self:PromptPurchase(player, productId, giftPlayer)
		end
	end)
end

function ItemHandler:_setupPlayerEvents()
	for _, player in pairs(Players:GetPlayers()) do
		self:_onPlayerJoined(player)
	end

	Players.PlayerAdded:Connect(function(player)
		self:_onPlayerJoined(player)
	end)
end

function ItemHandler:_onPlayerJoined(player)
	if player.Character then
		self:_givePlayerItems(player)
	end

	player.CharacterAdded:Connect(function(character)
		self:_givePlayerItems(player)
	end)
end

function ItemHandler:_givePlayerItems(player)
	if not self._monetizationService:IsDataReady(player) then
		task.spawn(function()
			if self._monetizationService:WaitForData(player, 30) then
				self:_givePlayerItems(player)
			end
		end)
		return
	end

	local data = self._monetizationService:GetPlayerData(player)
	if not data then
		return
	end

	data.Items = data.Items or {}

	local itemsGiven = {}
	for itemName, owned in pairs(data.Items) do
		if owned then
			self:_givePlayerItem(player, itemName)
			itemsGiven[itemName] = true
		end
	end

	self:_verifyAndRecoverMissingItems(player, data, itemsGiven)
end

function ItemHandler:_givePlayerItem(player, itemName)
	if self._givingItems and self._givingItems[player.UserId .. "-" .. itemName] then
		return false
	end

	self._givingItems = self._givingItems or {}
	self._givingItems[player.UserId .. "-" .. itemName] = true

	local MAX_RETRIES = 3
	local retryCount = 0

	local function attemptGiveTool()
		if not player.Character then
			warn("[ItemHandler] Player character not found for:", player.Name)
			return false
		end

		local backpack = player:WaitForChild("Backpack", 2)
		if not backpack then
			warn("[ItemHandler] Backpack not found for player:", player.Name)
			return false
		end

		if backpack:FindFirstChild(itemName) or player.Character:FindFirstChild(itemName) then
			return true
		end

		local itemTool = ReplicatedStorage.Items:FindFirstChild(itemName)
		if not itemTool then
			warn("[ItemHandler] Failed to find item in ReplicatedStorage:", itemName)
			return false
		end

		local success, toolClone = pcall(function()
			local newTool = itemTool:Clone()
			newTool.Parent = backpack
			return newTool
		end)

		if success and toolClone then
			task.wait(0.2)
			if backpack:FindFirstChild(itemName) or player.Character:FindFirstChild(itemName) then
				return true
			else
				return false
			end
		else
			warn("[ItemHandler] Failed to give item:", itemName, "Error:", toolClone)
			return false
		end
	end

	local function retryWithBackoff()
		while retryCount < MAX_RETRIES do
			local success = attemptGiveTool()
			if success then
				self._givingItems[player.UserId .. "-" .. itemName] = nil
				return true
			end

			retryCount += 1
			if retryCount < MAX_RETRIES then
				task.wait(0.5 * (2 ^ (retryCount - 1)))
			end
		end

		warn("[ItemHandler] Failed to give item after", MAX_RETRIES, "attempts:", itemName, "to player:", player.Name)
		self._givingItems[player.UserId .. "-" .. itemName] = nil
		return false
	end

	return retryWithBackoff()
end

function ItemHandler:_verifyAndRecoverMissingItems(player, data, itemsAlreadyGiven)
	if not player or not player.Character then return end

	for productId, productInfo in pairs(ShopData) do
		if productInfo.Type == "Item" then
			local itemName = productInfo.Display

			if itemsAlreadyGiven[itemName] then
				continue
			end

			local hasItemInBackpack = player.Backpack and player.Backpack:FindFirstChild(itemName)
			local hasItemInCharacter = player.Character and player.Character:FindFirstChild(itemName)

			if hasItemInBackpack or hasItemInCharacter then
				continue
			end

			local shouldHaveItem = self:_verifyItemOwnership(player, productId, productInfo, data)

			if shouldHaveItem then
				--print("[ItemHandler] Recovering missing item for player:", player.Name, itemName)

				data.Items = data.Items or {}
				data.Items[itemName] = true

				local playerPlot = self._monetizationService:GetPlayerSynchronizer(player)
				if playerPlot then
					playerPlot:InsertOnDictionary("Items", itemName, true)
				end

				task.spawn(function()
					self:_givePlayerItem(player, itemName)
				end)
			end
		end
	end
end

function ItemHandler:_verifyItemOwnership(player, productId, productInfo, data)
	local itemName = productInfo.Display

	if data.Inventory and data.Inventory[itemName] then
		--print("[ItemHandler] Found item in Inventory fallback:", player.Name, itemName)
		return true
	end

	if data.OwnedItems and data.OwnedItems[itemName] then
		--print("[ItemHandler] Found item in OwnedItems fallback:", player.Name, itemName)
		return true
	end

	if self:_checkStarterPackInclusion(player, itemName, data) then
		--print("[ItemHandler] Found item through starter pack inclusion:", player.Name, itemName)
		return true
	end

	if self:_checkPurchaseHistoryIndicators(player, productId, data) then
		--print("[ItemHandler] Found item through purchase history:", player.Name, itemName)
		return true
	end

	return false
end

function ItemHandler:_checkStarterPackInclusion(player, itemName, data)
	if data.BoughtStarterPack then
		for productId, productInfo in pairs(ShopData) do
			if productInfo.Type == "StarterPack" and productInfo.Rewards and productInfo.Rewards.Items then
				for _, includedItem in pairs(productInfo.Rewards.Items) do
					if includedItem == itemName then
						return true
					end
				end
			end
		end
	end
	return false
end

function ItemHandler:_checkPurchaseHistoryIndicators(player, productId, data)
	if data.PurchaseHistory then
		return data.PurchaseHistory[tostring(productId)] ~= nil
	end

	if data.ProductsPurchased then
		return data.ProductsPurchased[tostring(productId)] and data.ProductsPurchased[tostring(productId)] > 0
	end

	return false
end

function ItemHandler:_isItemProduct(productId)
	local productInfo = ShopData[tonumber(productId)]
	return productInfo and productInfo.Type == "Item"
end

function ItemHandler:PromptPurchase(player, productId, giftPlayer)
	if not self._monetizationService:IsDataReady(player) then
		warn("[ItemHandler] Player data not ready for purchase:", player.Name)
		return false
	end

	local productInfo = ShopData[tonumber(productId)]
	if not productInfo then
		warn("[ItemHandler] Invalid product ID:", productId)
		return false
	end

	local data = self._monetizationService:GetPlayerData(player)
	if data and data.Items and data.Items[productInfo.Display] then
		local notificationEvent = Net:RemoteEvent("NotificationService/Notify")
		notificationEvent:FireClient(player, "<font color=\"#FA0103\">You can't purchase this product!</font>", 5, "Sounds.Sfx.Error")
		return false
	end

	if giftPlayer then
		warn("[ItemHandler] Item gifting not implemented yet")
		return false
	end

	local marketplaceInfo = self._monetizationService:GetProductInfo(tonumber(productId))
	if not marketplaceInfo then
		warn("[ItemHandler] Failed to get marketplace info for:", productId)
		return false
	end

	return self._monetizationService:PromptProductPurchase(player, tonumber(productId))
end

function ItemHandler:ProcessPurchase(player, productId, receiptInfo)
	if not self._monetizationService:IsDataReady(player) then
		warn("[ItemHandler] Player data not ready for processing:", player.Name)
		return false
	end

	local playerPlot = self._monetizationService:GetPlayerSynchronizer(player)
	if not playerPlot then
		warn("[ItemHandler] No player synchronizer found for:", player.Name)
		return false
	end

	local data = self._monetizationService:GetPlayerData(player)
	if not data then
		warn("[ItemHandler] No data found for player:", player.Name)
		return false
	end

	local productInfo = ShopData[productId]
	if not productInfo or productInfo.Type ~= "Item" then
		warn("[ItemHandler] Invalid item product:", productId)
		return false
	end

	if data.Items and data.Items[productInfo.Display] then
		print("[ItemHandler] Player already owns item:", player.Name, productInfo.Display)
		return true
	end

	data.Items = data.Items or {}

	data.Items[productInfo.Display] = true
	playerPlot:InsertOnDictionary("Items", productInfo.Display, true)

	local itemTool = ReplicatedStorage.Items:FindFirstChild(productInfo.Display)
	if itemTool then
		local toolClone = itemTool:Clone()
		toolClone.Parent = player.Backpack
	--	print("[ItemHandler] Added item to backpack:", player.Name, productInfo.Display)
	else
	--	warn("[ItemHandler] Item tool not found in ReplicatedStorage.Items:", productInfo.Display)
	end

	self._monetizationService:LogPurchase(player, productId, "Item", productInfo.Display)
--	print("[ItemHandler] Successfully processed item purchase:", player.Name, productInfo.Display)

	return true
end

function ItemHandler:OnPurchaseFinished(player, productId, isPurchased)
	if not isPurchased then
--		print("[ItemHandler] Purchase cancelled for player:", player.Name, "Product:", productId)
		return
	end

	local productInfo = ShopData[productId]
	if productInfo then
	--	print("[ItemHandler] Purchase finished for player:", player.Name, "Item:", productInfo.Display)
	end
end

return ItemHandler 