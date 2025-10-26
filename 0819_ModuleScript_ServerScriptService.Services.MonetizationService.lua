--[[
  Extracted from: ServerScriptService.Services.MonetizationService
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")

local Packages = ReplicatedStorage.Packages
local Data = ReplicatedStorage.Datas
local Net = require(Packages.Net)
local Synchronizer = require(Packages.Synchronizer)
local DataManagement = require(ServerScriptService.Services.DataManagment)
local PlayersModule = require(ServerScriptService.Services.Players)
local ShopData = require(Data.Shop)

local CoinHandler = require(script.CoinHandler)
local StarterPackHandler = require(script.StarterPackHandler)
local ServerLuckHandler = require(script.ServerLuckHandler)
local GamepassHandler = require(script.GamepassHandler)
local ItemHandler = require(script.ItemHandler)
local BaseLockHandler = require(script.BaseLockHandler)
local EventsHandler = require(script.EventsHandler)
local TrollHandler = require(script.TrollHandler)
local SkipTimerHandler = require(script.SkipTimerHandler)
local LuckyBlockHandler = require(script.LuckyBlockHandler)
local MoltenSpinHandler = require(script.MoltenSpinHandler)
local GalaxySpinHandler = require(script.GalaxySpinHandler)

local MonetizationService = {}
MonetizationService.__index = MonetizationService

function MonetizationService.new()
	local self = setmetatable({}, MonetizationService)

	self.CoinHandler = CoinHandler.new(self)
	self.StarterPackHandler = StarterPackHandler.new(self)
	self.ServerLuckHandler = ServerLuckHandler.new(self)
	self.EventsHandler = EventsHandler.new(self)
	self.GamepassHandler = GamepassHandler.new(self)
	self.ItemHandler = ItemHandler.new(self)
	self.BaseLockHandler = BaseLockHandler.new(self)
	self.TrollHandler = TrollHandler.new(self)
	self.SkipTimerHandler = SkipTimerHandler.new(self)
	self.LuckyBlockHandler = LuckyBlockHandler.new(self)
	self.MoltenSpinHandler = MoltenSpinHandler.new(self)
	self.GalaxySpinHandler = GalaxySpinHandler.new(self)

	self._processingReceipts = {}
	self._productRegistry = {}

	self:_setupMarketplaceEvents()
	self:_registerProducts()
	self:_setupPlayerEvents()

	return self
end

function MonetizationService:_setupMarketplaceEvents()
	MarketplaceService.ProcessReceipt = function(receiptInfo)
		return self:_processReceipt(receiptInfo)
	end

	MarketplaceService.PromptProductPurchaseFinished:Connect(function(userId, productId, isPurchased)
		self:_onPurchaseFinished(userId, productId, isPurchased)
	end)
end

function MonetizationService:_processReceipt(receiptInfo)
	local player = Players:GetPlayerByUserId(receiptInfo.PlayerId)
	if not player then 
		return Enum.ProductPurchaseDecision.NotProcessedYet 
	end

	local receiptKey = string.format("%s_%s_%s", receiptInfo.PlayerId, receiptInfo.ProductId, receiptInfo.PurchaseId)
	if self._processingReceipts[receiptKey] then
		return Enum.ProductPurchaseDecision.PurchaseGranted
	end
	self._processingReceipts[receiptKey] = true

	local productHandler = self._productRegistry[receiptInfo.ProductId]
	if not productHandler then
		self._processingReceipts[receiptKey] = nil
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end

	local success, result = pcall(function()
		return productHandler.handler:ProcessPurchase(player, receiptInfo.ProductId, receiptInfo)
	end)

	if success and result then
		self._processingReceipts[receiptKey] = nil
		return Enum.ProductPurchaseDecision.PurchaseGranted
	else
		self._processingReceipts[receiptKey] = nil
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end
end

function MonetizationService:_onPurchaseFinished(userId, productId, isPurchased)
	local player = Players:GetPlayerByUserId(userId)
	if not player then return end

	local productHandler = self._productRegistry[productId]
	if not productHandler then return end

	if productHandler.handler.OnPurchaseFinished then
		local success, err = pcall(function()
			productHandler.handler:OnPurchaseFinished(player, productId, isPurchased)
		end)
		if not success then
			warn("[MonetizationService] Error in OnPurchaseFinished for product: " .. tostring(productId) .. " Error: " .. tostring(err))
		end
	end
end

function MonetizationService:_registerProducts()
	for productId, productInfo in pairs(ShopData) do
		if productInfo.Type == "Coins" then
			self:RegisterProduct(productId, "Coins", self.CoinHandler)
		elseif productInfo.Type == "StarterPack" then
			self:RegisterProduct(productId, "StarterPack", self.StarterPackHandler)
		elseif productInfo.Type == "ServerLuck" then
			self:RegisterProduct(productId, "ServerLuck", self.ServerLuckHandler)
		elseif productInfo.Type == "PaidEvent" then
			self:RegisterProduct(productId, "PaidEvent", self.EventsHandler)
		elseif productInfo.Type == "Item" then
			self:RegisterProduct(productId, "Item", self.ItemHandler)
		elseif productInfo.Type == "Gamepass" then
			local isValid, _ = pcall(function()
				return self.GamepassHandler:ValidateGamepass(productId)
			end)
			if isValid then
				self:RegisterProduct(productId, "Gamepass", self.GamepassHandler)
			else
				warn("[MonetizationService] Skipping invalid gamepass: " .. tostring(productId) .. " " .. tostring(productInfo.Display))
			end
		elseif productInfo.Type == "UnlockBase" then
			self:RegisterProduct(productId, "UnlockBase", self.BaseLockHandler)
		elseif productInfo.Type == "TrollAction" then
			self:RegisterProduct(productId, "TrollAction", self.TrollHandler)
		elseif productInfo.Type == "SkipTimer" then
			self:RegisterProduct(productId, "SkipTimer", self.SkipTimerHandler)
		elseif productInfo.Type == "LuckyBlock" then
			self:RegisterProduct(productId, "LuckyBlock", self.LuckyBlockHandler)
		elseif productInfo.Type == "MoltenWheelSpin" then
			self:RegisterProduct(productId, "MoltenWheelSpin", self.MoltenSpinHandler)
		elseif productInfo.Type == "GalaxySpinWheel" then
			self:RegisterProduct(productId, "GalaxySpinWheel", self.GalaxySpinHandler)
		end
	end
end

function MonetizationService:RegisterProduct(productId, productType, handler)
	self._productRegistry[productId] = {
		type = productType,
		handler = handler
	}
end

function MonetizationService:UnregisterProduct(productId)
	self._productRegistry[productId] = nil
end

function MonetizationService:GetProductRegistry()
	return self._productRegistry
end

function MonetizationService:GetPlayerData(player)
	return DataManagement.GetDataMan(player)
end

function MonetizationService:GetPlayerSynchronizer(player)
	return PlayersModule.getSynchronizer(player)
end

function MonetizationService:IsDataReady(player)
	return DataManagement.isDataReady(player)
end

function MonetizationService:WaitForData(player, timeout)
	return DataManagement.waitForData(player, timeout or 30)
end

function MonetizationService:PromptProductPurchase(player, productId)
	local success, err = pcall(function()
		MarketplaceService:PromptProductPurchase(player, productId)
	end)

	if not success then
		warn("[MonetizationService] Failed to prompt purchase for product: " .. tostring(productId) .. " Player: " .. player.Name .. " Error: " .. tostring(err))
	end

	return success
end

function MonetizationService:GetProductInfo(productId, infoType)
	local success, productInfo = pcall(function()
		if infoType == "Gamepass" then
			return MarketplaceService:GetProductInfo(productId, Enum.InfoType.GamePass)
		else
			return MarketplaceService:GetProductInfo(productId, infoType or Enum.InfoType.Product)
		end
	end)

	if success then
		return productInfo
	else
		warn("[MonetizationService] Failed to get " .. tostring(infoType or "Product") .. " info for: " .. tostring(productId) .. " Error: " .. tostring(productInfo))
		return nil
	end
end

function MonetizationService:LogPurchase(player, productId, productType, value)
	return
end

function MonetizationService:_setupPlayerEvents()
	for _, player in ipairs(Players:GetPlayers()) do
		task.spawn(function()
			if self:WaitForData(player, 30) then
				local success, err = pcall(function()
					self.StarterPackHandler:CheckAndUpdateOwnership(player)
					self.StarterPackHandler:SetupOwnershipMonitoring(player)
					self.GamepassHandler:CheckAndUpdateGamepassOwnership(player)
					self.GamepassHandler:SetupOwnershipMonitoring(player)
				end)
			end
		end)
	end

	Players.PlayerAdded:Connect(function(player)
		task.spawn(function()
			if self:WaitForData(player, 30) then
				local success, err = pcall(function()
					self.StarterPackHandler:CheckAndUpdateOwnership(player)
					self.StarterPackHandler:SetupOwnershipMonitoring(player)
					self.GamepassHandler:CheckAndUpdateGamepassOwnership(player)
					self.GamepassHandler:SetupOwnershipMonitoring(player)
				end)
			end
		end)
	end)

	Players.PlayerRemoving:Connect(function(player)
		local success, err = pcall(function()
			self.GamepassHandler:ClearCache(player)
		end)
		if not success then
			warn("[MonetizationService] Error clearing cache for player: " .. player.Name .. " Error: " .. tostring(err))
		end
	end)
end

function MonetizationService:GetServerLuckSynchronizer()
	return self.ServerLuckHandler:GetSynchronizer()
end

function MonetizationService:PromptGamepassPurchase(player, gamePassId)
	local ownershipSuccess, ownsGamepass = pcall(function()
		return MarketplaceService:UserOwnsGamePassAsync(player.UserId, gamePassId)
	end)

	if ownershipSuccess and ownsGamepass then
		return false
	end

	local data = self:GetPlayerData(player)
	if data and data.Gamepass then
		local productInfo = ShopData[gamePassId]
		if productInfo and data.Gamepass[productInfo.Display] then
			return false
		end
	end

	local success, err = pcall(function()
		MarketplaceService:PromptGamePassPurchase(player, gamePassId)
	end)

	if not success then
		warn("[MonetizationService] Failed to prompt gamepass purchase for: " .. tostring(gamePassId) .. " Player: " .. player.Name .. " Error: " .. tostring(err))
	end

	return success
end

return MonetizationService