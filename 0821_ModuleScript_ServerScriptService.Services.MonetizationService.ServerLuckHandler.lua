--[[
  Extracted from: ServerScriptService.Services.MonetizationService.ServerLuckHandler
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Packages = ReplicatedStorage.Packages
local Data = ReplicatedStorage.Datas
local Net = require(Packages.Net)
local ShopData = require(Data.Shop)
local ServerLuckData = require(Data.ServerLuck)
local Synchronizer = require(Packages.Synchronizer)

local ServerLuckHandler = {}
ServerLuckHandler.__index = ServerLuckHandler

function ServerLuckHandler.new(monetizationService)
	local self = setmetatable({}, ServerLuckHandler)

	self._monetizationService = monetizationService
	self._purchaseRemote = Net:RemoteEvent("ShopService/Purchase")
	self._purchaseDebounce = {}

	self._synchronizer = Synchronizer:Create("ServerLuck", {
		Index = 0,
		EndTime = nil
	})

	ReplicatedStorage:SetAttribute("ServerLuckMultiplier", 1)
	ReplicatedStorage:SetAttribute("ServerLuckEndTime", nil)

	self:_setupRemoteEvents()
	self:_startUpdateLoop()
	self:_setupPlayerListeners()

	return self
end

function ServerLuckHandler:_setupRemoteEvents()
	self._purchaseRemote.OnServerEvent:Connect(function(player, productId)
		if self:_isServerLuckProduct(productId) then
			self:PromptPurchase(player, productId)
		end
	end)
end

function ServerLuckHandler:_isServerLuckProduct(productId)
	for _, serverLuckData in pairs(ServerLuckData) do
		if serverLuckData.ProductId == tonumber(productId) then
			return true
		end
	end
	return false
end

function ServerLuckHandler:_startUpdateLoop()
	RunService.Heartbeat:Connect(function()
		local endTime = self._synchronizer:Get("EndTime")
		if endTime and workspace:GetServerTimeNow() >= endTime then
			self._synchronizer:Set("Index", 0)
			self._synchronizer:Set("EndTime", nil)

			ReplicatedStorage:SetAttribute("ServerLuckMultiplier", 1)
			ReplicatedStorage:SetAttribute("ServerLuckEndTime", nil)
		end
	end)
end

function ServerLuckHandler:_setupPlayerListeners()
	for _, player in pairs(Players:GetPlayers()) do
		self._synchronizer:AddListener(player)
	end

	Players.PlayerAdded:Connect(function(player)
		self._synchronizer:AddListener(player)
	end)

	Players.PlayerRemoving:Connect(function(player)
		self._synchronizer:RemoveListener(player)

		local userId = tostring(player.UserId)
		for key, _ in pairs(self._purchaseDebounce) do
			if string.sub(key, 1, #userId) == userId then
				self._purchaseDebounce[key] = nil
			end
		end
	end)
end

function ServerLuckHandler:_canPurchaseServerLuck(player, productId)
	local targetServerLuckInfo = nil
	local targetIndex = 0

	for index, data in pairs(ServerLuckData) do
		if data.ProductId == tonumber(productId) then
			targetServerLuckInfo = data
			targetIndex = index
			break
		end
	end

	if not targetServerLuckInfo then
		warn("[ServerLuckHandler] Invalid server luck product for validation:", productId)
		return false
	end

	local currentIndex = self._synchronizer:Get("Index") or 0
	local currentEndTime = self._synchronizer:Get("EndTime")

	-- allow buying max tier again for extra time
	if currentIndex > targetIndex then
		local Net = require(ReplicatedStorage.Packages.Net)
		local NotificationEvent = Net:RemoteEvent("NotificationService/Notify")
		NotificationEvent:FireClient(player,
			string.format("<font color=\"#FFFF00\">Server luck is already %dx or higher!</font>", targetServerLuckInfo.Multiplier), 3)
		return false
	end

	-- if already at this tier but still active, allow buying again (extends time)
	if currentIndex == targetIndex and currentEndTime and workspace:GetServerTimeNow() < currentEndTime then
		return true
	end

	return true
end

function ServerLuckHandler:PromptPurchase(player, productId)
	local debounceKey = player.UserId .. "_" .. productId
	local currentTime = tick()

	if self._purchaseDebounce[debounceKey] and currentTime - self._purchaseDebounce[debounceKey] < 2 then
		return false
	end

	self._purchaseDebounce[debounceKey] = currentTime

	if not self._monetizationService:IsDataReady(player) then
		warn("[ServerLuckHandler] Player data not ready for purchase:", player.Name)
		return false
	end

	local productInfo = ShopData[tonumber(productId)]
	if not productInfo then
		warn("[ServerLuckHandler] Invalid product ID:", productId)
		return false
	end

	if not self:_canPurchaseServerLuck(player, productId) then
		return false
	end

	local marketplaceInfo = self._monetizationService:GetProductInfo(tonumber(productId))
	if not marketplaceInfo then
		warn("[ServerLuckHandler] Failed to get marketplace info for:", productId)
		return false
	end

	return self._monetizationService:PromptProductPurchase(player, tonumber(productId))
end

function ServerLuckHandler:ProcessPurchase(player, productId, receiptInfo)
	if not self._monetizationService:IsDataReady(player) then
		warn("[ServerLuckHandler] Player data not ready for processing:", player.Name)
		return false
	end

	local serverLuckInfo = nil
	local newIndex = 0

	for index, data in pairs(ServerLuckData) do
		if data.ProductId == productId then
			serverLuckInfo = data
			newIndex = index
			break
		end
	end

	if not serverLuckInfo then
		warn("[ServerLuckHandler] Invalid server luck product:", productId)
		return false
	end

	local currentTime = workspace:GetServerTimeNow()
	local currentEndTime = self._synchronizer:Get("EndTime")

	local newEndTime
	if newIndex == self._synchronizer:Get("Index") and currentEndTime and currentEndTime > currentTime then
		newEndTime = currentEndTime + serverLuckInfo.Duration
	else
		newEndTime = math.max(currentEndTime or 0, currentTime) + serverLuckInfo.Duration
	end

	self._synchronizer:Set("Index", newIndex)
	self._synchronizer:Set("EndTime", newEndTime)

	ReplicatedStorage:SetAttribute("ServerLuckMultiplier", serverLuckInfo.Multiplier)
	ReplicatedStorage:SetAttribute("ServerLuckEndTime", newEndTime)

	self._monetizationService:LogPurchase(player, productId, "ServerLuck", 
		string.format("%dx multiplier for %d seconds", serverLuckInfo.Multiplier, serverLuckInfo.Duration))

	local Net = require(ReplicatedStorage.Packages.Net)
	local NotificationEvent = Net:RemoteEvent("NotificationService/Notify")
	for _, otherPlayer in pairs(Players:GetPlayers()) do
		NotificationEvent:FireClient(otherPlayer, 
			string.format("<font color=\"#92FF67\">%s extended %dx Luck for the server by %d seconds!</font>", 
				player.Name, serverLuckInfo.Multiplier, serverLuckInfo.Duration), 5)
	end

	return true
end

function ServerLuckHandler:OnPurchaseFinished(player, productId, isPurchased)
	if isPurchased then
		-- success log
	else
		-- cancel log
	end
end

function ServerLuckHandler:GetCurrentLuckMultiplier()
	local index = self._synchronizer:Get("Index") or 0
	local endTime = self._synchronizer:Get("EndTime")

	if index > 0 and endTime and workspace:GetServerTimeNow() < endTime then
		local serverLuckInfo = ServerLuckData[index]
		return serverLuckInfo and serverLuckInfo.Multiplier or 1
	end

	return 1
end

function ServerLuckHandler:GetTimeRemaining()
	local endTime = self._synchronizer:Get("EndTime")
	if endTime and workspace:GetServerTimeNow() < endTime then
		return math.max(0, endTime - workspace:GetServerTimeNow())
	end
	return 0
end

function ServerLuckHandler:GetSynchronizer()
	return self._synchronizer
end

return ServerLuckHandler
