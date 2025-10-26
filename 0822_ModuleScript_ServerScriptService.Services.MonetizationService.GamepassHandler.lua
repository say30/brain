--[[
  Extracted from: ServerScriptService.Services.MonetizationService.GamepassHandler
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")

local Packages = ReplicatedStorage.Packages
local Data = ReplicatedStorage.Datas
local Net = require(Packages.Net)
local ShopData = require(Data.Shop)

local GamepassHandler = {}
GamepassHandler.__index = GamepassHandler

function GamepassHandler.new(monetizationService)
	local self = setmetatable({}, GamepassHandler)

	self._monetizationService = monetizationService
	self._purchaseRemote = Net:RemoteEvent("ShopService/Purchase")
	self._gamepassOwnershipCache = {}

	self:_setupRemoteEvents()
	self:_setupMarketplaceEvents()

	return self
end

function GamepassHandler:_setupRemoteEvents()
	self._purchaseRemote.OnServerEvent:Connect(function(player, productId)
		if self:_isGamepassProduct(productId) then
			self._monetizationService:PromptGamepassPurchase(player, tonumber(productId))
		end
	end)
end

function GamepassHandler:_getActualGamepassId(productId)
	local numericProductId = tonumber(productId)
	if not numericProductId then
		return nil
	end

	local productInfo = ShopData[numericProductId]

	if productInfo and productInfo.Type == "Gamepass" then
		return numericProductId
	end

	return nil
end

function GamepassHandler:_setupMarketplaceEvents()
	MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(player, gamePassId, wasPurchased)
		if not player or not gamePassId then
			warn("[GamepassHandler] Invalid parameters in marketplace event:", player and player.Name or "nil", gamePassId)
			return
		end

		if player and player.Parent then
			self:OnGamepassPurchaseFinished(player, gamePassId, wasPurchased)
		else
			warn("[GamepassHandler] Player not found or disconnected:", player and player.Name or "nil")
		end
	end)
end

function GamepassHandler:_isGamepassProduct(productId)
	local numericProductId = tonumber(productId)
	if not numericProductId then
		return false
	end

	local productInfo = ShopData[numericProductId]
	return productInfo and productInfo.Type == "Gamepass"
end

function GamepassHandler:ValidateGamepass(productId)
	local actualGamepassId = self:_getActualGamepassId(productId)
	if not actualGamepassId then
		return false, "Product not found or not a gamepass"
	end

	local productInfo = ShopData[tonumber(productId)]
	if not productInfo then
		return false, "Product not found in ShopData"
	end

	if productInfo.Type ~= "Gamepass" then
		return false, "Product is not a gamepass"
	end

	local success, marketplaceInfo = pcall(function()
		return MarketplaceService:GetProductInfo(actualGamepassId, Enum.InfoType.GamePass)
	end)

	if not success then
		local errorMsg = tostring(marketplaceInfo)
		if string.find(errorMsg, "HTTP 404") then
			return false, "Gamepass does not exist in marketplace (ID: " .. actualGamepassId .. ")"
		else
			return false, "Failed to get marketplace info: " .. errorMsg
		end
	end

	if not marketplaceInfo then
		return false, "Gamepass not found in marketplace"
	end

	return true, marketplaceInfo
end

function GamepassHandler:PromptPurchase(player, productId)
	if not self._monetizationService:IsDataReady(player) then
		warn("[GamepassHandler] Player data not ready for purchase:", player.Name)
		return false
	end

	local actualGamepassId = self:_getActualGamepassId(productId)
	if not actualGamepassId then
		warn("[GamepassHandler] Invalid gamepass:", productId, "No matching actual gamepass found")
		return false
	end

	local isValid, result = self:ValidateGamepass(productId)
	if not isValid then
		warn("[GamepassHandler] Invalid gamepass:", productId, "Reason:", result)
		return false
	end

	local productInfo = ShopData[tonumber(productId)]
	local marketplaceInfo = result

	local success, ownsGamepass = pcall(function()
		return MarketplaceService:UserOwnsGamePassAsync(player.UserId, actualGamepassId)
	end)

	if not success then
		warn("[GamepassHandler] Failed to check gamepass ownership for prompt:", player.Name, productId)
		ownsGamepass = self:PlayerOwnsGamepass(player, actualGamepassId)
	end

	if ownsGamepass then
		warn("[GamepassHandler] Player already owns gamepass:", player.Name, productId, "Display:", productInfo.Display)
		return false
	end

	if not marketplaceInfo.IsForSale then
		warn("[GamepassHandler] Gamepass is not for sale:", productId, "Display:", productInfo.Display)
		return false
	end

	return self._monetizationService:PromptGamepassPurchase(player, actualGamepassId)
end

function GamepassHandler:ProcessPurchase(player, productId, receiptInfo)
	local DataManagement = require(game:GetService("ServerScriptService").Services.DataManagment)
	local playerPlot = self._monetizationService:GetPlayerSynchronizer(player)

	local numericProductId = tonumber(productId)
	if not numericProductId then
		warn("[GamepassHandler] Invalid productId in ProcessPurchase:", productId, "Type:", typeof(productId))
		return false
	end

	local productInfo = ShopData[numericProductId]
	if not productInfo or productInfo.Type ~= "Gamepass" then
		warn("[GamepassHandler] Invalid gamepass product:", numericProductId)
		return false
	end

	local success = DataManagement.addGamepass(player, productInfo.Display)
	if not success then
		warn("[GamepassHandler] Failed to add gamepass to profile for", player.Name, ":", productInfo.Display)
		return false
	end

	if playerPlot then
		local currentGamepasses = DataManagement.getGamepasses(player)
		playerPlot:Set("Gamepass", currentGamepasses)
		playerPlot:InsertOnDictionary("Gamepass", productInfo.Display, true)
	end

	if productInfo.Display == "Admin Commands" then
		local AdminPanelService = require(game:GetService("ServerScriptService").Services.AdminPanelService)
		AdminPanelService:RefreshAdminStatus(player)
		print("[GamepassHandler] Admin Commands gamepass purchased, updated admin attribute for:", player.Name)
	end

	if self._gamepassOwnershipCache[player.UserId] then
		self._gamepassOwnershipCache[player.UserId] = nil
	end

	self._monetizationService:LogPurchase(player, numericProductId, "Gamepass", productInfo.Display)

	return true
end

function GamepassHandler:OnGamepassPurchaseFinished(player, gamePassId, wasPurchased)
	if wasPurchased then
		if not player or not player.Parent then
			warn("[GamepassHandler] Player no longer valid after purchase:", gamePassId)
			return
		end

		local numericGamePassId = tonumber(gamePassId)
		if not numericGamePassId then
			warn("[GamepassHandler] Invalid gamePassId after purchase:", gamePassId, "Type:", typeof(gamePassId))
			return
		end

		self:ClearCache(player)

		local productInfo = nil
		for productId, info in pairs(ShopData) do
			if tonumber(productId) == numericGamePassId then
				productInfo = info
				break
			end
		end

		if productInfo then
			local success = self:ProcessPurchase(player, numericGamePassId, {})
			if not success then
				warn("[GamepassHandler] Failed to process gamepass purchase for", player.Name, ":", productInfo.Display)
			end
		else
			warn("[GamepassHandler] No product info found for gamepass:", numericGamePassId)
		end
	end
end

function GamepassHandler:PlayerOwnsGamepass(player, productId)
	local actualGamepassId = self:_getActualGamepassId(productId)
	if not actualGamepassId then
		warn("[GamepassHandler] Invalid productId in PlayerOwnsGamepass:", productId, "Type:", typeof(productId))
		return false
	end

	local userId = player.UserId
	local cacheKey = userId

	if not self._gamepassOwnershipCache[cacheKey] then
		self._gamepassOwnershipCache[cacheKey] = {}

		for id, info in pairs(ShopData) do
			if info.Type == "Gamepass" then
				local success, owns = pcall(function()
					return MarketplaceService:UserOwnsGamePassAsync(userId, tonumber(id))
				end)

				if success then
					self._gamepassOwnershipCache[cacheKey][tonumber(id)] = owns
				else
					warn("[GamepassHandler] Failed to check gamepass ownership:", player.Name, id, owns)
					self._gamepassOwnershipCache[cacheKey][tonumber(id)] = false
				end
			end
		end
	end

	return self._gamepassOwnershipCache[cacheKey][actualGamepassId] or false
end

function GamepassHandler:CheckAndUpdateGamepassOwnership(player)
	local DataManagement = require(game:GetService("ServerScriptService").Services.DataManagment)
	local playerPlot = self._monetizationService:GetPlayerSynchronizer(player)

	if not DataManagement.isDataReady(player) then
		return
	end

	local hasChanges = false
	local adminGamepassAdded = false

	for productId, productInfo in pairs(ShopData) do
		if productInfo.Type == "Gamepass" then
			local actualGamepassId = self:_getActualGamepassId(productId)
			if actualGamepassId then
				local ownsGamepass = self:PlayerOwnsGamepass(player, productId)
				local hasInData = DataManagement.hasGamepass(player, productInfo.Display)

				if ownsGamepass and not hasInData then
					local success = DataManagement.addGamepass(player, productInfo.Display)
					if success and playerPlot then
						playerPlot:InsertOnDictionary("Gamepass", productInfo.Display, true)
						hasChanges = true

						if productInfo.Display == "Admin Commands" then
							adminGamepassAdded = true
						end
					end
				end
			end
		end
	end

	if adminGamepassAdded then
		local AdminPanelService = require(game:GetService("ServerScriptService").Services.AdminPanelService)
		AdminPanelService:RefreshAdminStatus(player)
		print("[GamepassHandler] Admin Commands gamepass detected and added, updated admin attribute for:", player.Name)
	end

	if hasChanges and playerPlot then
		local currentGamepasses = DataManagement.getGamepasses(player)
		playerPlot:Set("Gamepass", currentGamepasses)
	end

	if self._gamepassOwnershipCache[player.UserId] then
		self._gamepassOwnershipCache[player.UserId] = nil
	end
end

function GamepassHandler:SetupOwnershipMonitoring(player)
	if not self._monetizationService:IsDataReady(player) then
		return
	end

	task.spawn(function()
		while player and player.Parent do
			self:CheckAndUpdateGamepassOwnership(player)
			task.wait(30)
		end
	end)
end

function GamepassHandler:GetPlayerGamepasses(player)
	local data = self._monetizationService:GetPlayerData(player)
	if data and data.Gamepass then
		return data.Gamepass
	end
	return {}
end

function GamepassHandler:HasGamepass(player, gamepassName)
	local DataManagement = require(game:GetService("ServerScriptService").Services.DataManagment)
	return DataManagement.hasGamepass(player, gamepassName)
end

function GamepassHandler:GetProductInfo(productId)
	return ShopData[tonumber(productId)]
end

function GamepassHandler:GetAllGamepassProducts()
	local gamepassProducts = {}
	for productId, productInfo in pairs(ShopData) do
		if productInfo.Type == "Gamepass" then
			gamepassProducts[productId] = productInfo
		end
	end
	return gamepassProducts
end

function GamepassHandler:ClearCache(player)
	if player then
		self._gamepassOwnershipCache[player.UserId] = nil
	else
		self._gamepassOwnershipCache = {}
	end
end

return GamepassHandler