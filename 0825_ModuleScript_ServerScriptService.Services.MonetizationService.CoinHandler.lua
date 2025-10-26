--[[
  Extracted from: ServerScriptService.Services.MonetizationService.CoinHandler
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")

local Packages = ReplicatedStorage.Packages
local Data = ReplicatedStorage.Datas
local Net = require(Packages.Net)
local ShopData = require(Data.Shop)

local CoinHandler = {}
CoinHandler.__index = CoinHandler

function CoinHandler.new(monetizationService)
	local self = setmetatable({}, CoinHandler)

	self._monetizationService = monetizationService
	self._purchaseRemote = Net:RemoteEvent("ShopService/Purchase")

	self:_setupRemoteEvents()

--	print("[CoinHandler] Initialized successfully")
	return self
end

function CoinHandler:_setupRemoteEvents()
	self._purchaseRemote.OnServerEvent:Connect(function(player, productId)
		if self:_isCoinProduct(productId) then
			self:PromptPurchase(player, productId)
		end
	end)
end

function CoinHandler:_isCoinProduct(productId)
	local productInfo = ShopData[tonumber(productId)]
	return productInfo and productInfo.Type == "Coins"
end

function CoinHandler:PromptPurchase(player, productId)
	if not self._monetizationService:IsDataReady(player) then
		warn("[CoinHandler] Player data not ready for purchase:", player.Name)
		return false
	end

	local productInfo = ShopData[tonumber(productId)]
	if not productInfo then
		warn("[CoinHandler] Invalid product ID:", productId)
		return false
	end

	local marketplaceInfo = self._monetizationService:GetProductInfo(tonumber(productId))
	if not marketplaceInfo then
		warn("[CoinHandler] Failed to get marketplace info for:", productId)
		return false
	end

	return self._monetizationService:PromptProductPurchase(player, tonumber(productId))
end

function CoinHandler:ProcessPurchase(player, productId, receiptInfo)
	if not self._monetizationService:IsDataReady(player) then
		warn("[CoinHandler] Player data not ready for processing:", player.Name)
		return false
	end

	local playerPlot = self._monetizationService:GetPlayerSynchronizer(player)
	if not playerPlot then
		warn("[CoinHandler] No synchronizer found for player:", player.Name)
		return false
	end

	local data = self._monetizationService:GetPlayerData(player)
	if not data then
		warn("[CoinHandler] No data found for player:", player.Name)
		return false
	end

	local productInfo = ShopData[productId]
	if not productInfo or productInfo.Type ~= "Coins" then
		warn("[CoinHandler] Invalid coin product:", productId)
		return false
	end

	local coinValue = productInfo.Value or 0
	local rebirthLevel = data.Rebirths or 0

	if rebirthLevel > 0 then
		coinValue = coinValue * (rebirthLevel <= 1 and 1.5 or rebirthLevel)
	end

	data.Coins = (data.Coins or 0) + coinValue

	playerPlot:Set("Coins", data.Coins)

	self._monetizationService:LogPurchase(player, productId, "Coins", coinValue .. " coins")

	--print(string.format("[CoinHandler] Granted %d coins to %s (Product: %s)", coinValue, player.Name, productInfo.Display))
	return true
end

function CoinHandler:OnPurchaseFinished(player, productId, isPurchased)
	if isPurchased then
	--	print(string.format("[CoinHandler] Purchase completed for %s: %s", player.Name, productId))
	else
	--	print(string.format("[CoinHandler] Purchase cancelled for %s: %s", player.Name, productId))
	end
end

function CoinHandler:GetPlayerCoins(player)
	local data = self._monetizationService:GetPlayerData(player)
	return data and data.Coins or 0
end

function CoinHandler:AddCoins(player, amount, reason)
	if not self._monetizationService:IsDataReady(player) then
		warn("[CoinHandler] Player data not ready for adding coins:", player.Name)
		return false
	end

	local playerPlot = self._monetizationService:GetPlayerSynchronizer(player)
	if not playerPlot then
		warn("[CoinHandler] No synchronizer found for player:", player.Name)
		return false
	end

	local data = self._monetizationService:GetPlayerData(player)
	if not data then
		warn("[CoinHandler] No data found for player:", player.Name)
		return false
	end

	data.Coins = (data.Coins or 0) + amount
	playerPlot:Set("Coins", data.Coins)

	--print(string.format("[CoinHandler] Added %d coins to %s (Reason: %s)", amount, player.Name, reason or "Unknown"))
	return true
end

function CoinHandler:RemoveCoins(player, amount, reason)
	if not self._monetizationService:IsDataReady(player) then
		warn("[CoinHandler] Player data not ready for removing coins:", player.Name)
		return false
	end

	local playerPlot = self._monetizationService:GetPlayerSynchronizer(player)
	if not playerPlot then
		warn("[CoinHandler] No synchronizer found for player:", player.Name)
		return false
	end

	local data = self._monetizationService:GetPlayerData(player)
	if not data then
		warn("[CoinHandler] No data found for player:", player.Name)
		return false
	end

	local currentCoins = data.Coins or 0
	if currentCoins < amount then
		warn(string.format("[CoinHandler] Player %s doesn't have enough coins. Has: %d, Needs: %d", 
			player.Name, currentCoins, amount))
		return false
	end

	data.Coins = currentCoins - amount
	playerPlot:Set("Coins", data.Coins)

	--print(string.format("[CoinHandler] Removed %d coins from %s (Reason: %s)", amount, player.Name, reason or "Unknown"))
	return true
end

function CoinHandler:GetProductInfo(productId)
	return ShopData[tonumber(productId)]
end

function CoinHandler:GetAllCoinProducts()
	local coinProducts = {}
	for productId, productInfo in pairs(ShopData) do
		if productInfo.Type == "Coins" then
			coinProducts[productId] = productInfo
		end
	end
	return coinProducts
end

return CoinHandler 