--[[
  Extracted from: ServerScriptService.Services.MonetizationService.YinYangSpinHandler
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

---By Mr.Flowers
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")

local Packages = ReplicatedStorage.Packages
local Data = ReplicatedStorage.Datas
local Net = require(Packages.Net)
local ShopData = require(Data.Shop)
local YinYangSpinWheelData = require(Data.YinYangSpinWheel)
local Synchronizer = require(Packages.Synchronizer)

local ServerLuckSynchronizer = Synchronizer:Get("ServerLuck")

local YinYangSpinHandler = {}
YinYangSpinHandler.__index = YinYangSpinHandler

local notificationCooldown = {}
local NOTIFY_COOLDOWN = 0.5

function YinYangSpinHandler.new(monetizationService)
	local self = setmetatable({}, YinYangSpinHandler)

	self._monetizationService = monetizationService
	self._spinRemote = Net:RemoteEvent("YinYangEventService/Spin")
	self._purchaseRemote = Net:RemoteEvent("ShopService/Purchase")

	self:_setupRemoteEvents()

	return self
end

function YinYangSpinHandler:_setupRemoteEvents()
	self._purchaseRemote.OnServerEvent:Connect(function(player, productId)
		if self:_isYinYangSpinProduct(productId) then
			self:PromptPurchase(player, productId)
		end
	end)

	self._spinRemote.OnServerEvent:Connect(function(player)
		pcall(function()
			self:ProcessSpin(player)
		end)
	end)
end

function YinYangSpinHandler:_isYinYangSpinProduct(productId)
	local productInfo = ShopData[tonumber(productId)]
	return productInfo and productInfo.Type == "YinYangWheelSpin"
end

function YinYangSpinHandler:PromptPurchase(player, productId)
	if not self._monetizationService:IsDataReady(player) then return false end

	local productInfo = ShopData[tonumber(productId)]
	if not productInfo then return false end

	local marketplaceInfo = self._monetizationService:GetProductInfo(tonumber(productId))
	if not marketplaceInfo then return false end

	return self._monetizationService:PromptProductPurchase(player, tonumber(productId))
end

function YinYangSpinHandler:ProcessPurchase(player, productId, receiptInfo)
	if not self._monetizationService:IsDataReady(player) then return false end

	local playerPlot = self._monetizationService:GetPlayerSynchronizer(player)
	if not playerPlot then return false end

	local data = self._monetizationService:GetPlayerData(player)
	if not data then return false end

	local productInfo = ShopData[productId]
	if not productInfo or productInfo.Type ~= "YinYangWheelSpin" then return false end

	local spinsToAdd = productInfo.Value or 0
	local isX3Purchase = productInfo.Identifier == "x3"
	local isDiscountPurchase = string.find(productInfo.Display, "DISCOUNT")

	data.YinYangSpinWheel = data.YinYangSpinWheel or {}
	data.YinYangSpinWheel.Spins = (data.YinYangSpinWheel.Spins or 0) + spinsToAdd

	if isX3Purchase then
		data.YinYangSpinWheel.PaidSpins = data.YinYangSpinWheel.PaidSpins or {}
		data.YinYangSpinWheel.PaidSpins.x3 = (data.YinYangSpinWheel.PaidSpins.x3 or 0) + 1
	end

	if isDiscountPurchase then
		data.YinYangSpinWheel.LastDailyDiscount = os.time()
	end

	playerPlot:Set("YinYangSpinWheel", data.YinYangSpinWheel)
	playerPlot:Set("PaidSpins", data.YinYangSpinWheel.PaidSpins)
	if isDiscountPurchase then
		playerPlot:Set("LastDailyDiscount", data.YinYangSpinWheel.LastDailyDiscount)
	end

	self._monetizationService:LogPurchase(player, productId, "YinYangSpin", spinsToAdd .. " spins")

	return true
end

function YinYangSpinHandler:ProcessSpin(player)
	if not self._monetizationService:IsDataReady(player) then return end

	local playerPlot = self._monetizationService:GetPlayerSynchronizer(player)
	if not playerPlot then return end

	local data = self._monetizationService:GetPlayerData(player)
	if not data then return end

	data.YinYangSpinWheel = data.YinYangSpinWheel or {}

	local isFreeSpin = false
	local YinYangEventActive = ReplicatedStorage:GetAttribute("YinYangEvent")

	if YinYangEventActive then
		local lastFreeClaimed = data.YinYangSpinWheel.LastFreeClaimed or 0
		local eventLastTime = ReplicatedStorage:GetAttribute("YinYangEventLastTime")
		if lastFreeClaimed ~= eventLastTime then
			isFreeSpin = true
		end
	end

	local currentSpins = data.YinYangSpinWheel.Spins or 0

	if not isFreeSpin and currentSpins <= 0 then
		local now = os.clock()
		if not notificationCooldown[player] or now - notificationCooldown[player] >= NOTIFY_COOLDOWN then
			notificationCooldown[player] = now
			local notificationEvent = Net:RemoteEvent("NotificationService/Notify")
			notificationEvent:FireClient(player, "<font color=\"#FA0103\">You don't have any spins to spin the wheel!</font>", 5, "Sounds.Sfx.Error")
		end
		return
	end

	if isFreeSpin then
		data.YinYangSpinWheel.LastFreeClaimed = ReplicatedStorage:GetAttribute("YinYangEventLastTime")
	else
		data.YinYangSpinWheel.Spins = data.YinYangSpinWheel.Spins - 1
	end

	local rewardIndex = self:_getRewardIndex()
	if not YinYangSpinWheelData.Rewards[rewardIndex] then
		rewardIndex = 1
	end

	local reward = YinYangSpinWheelData.Rewards[rewardIndex]
	local isAltReward = false

	if reward.Type == "Item" and data.Items and data.Items[reward.Index] then
		if YinYangSpinWheelData.AltRewards and YinYangSpinWheelData.AltRewards[rewardIndex] then
			reward = YinYangSpinWheelData.AltRewards[rewardIndex]
			isAltReward = true
		end
	end

	pcall(function()
		self:_grantReward(player, reward, data, playerPlot)
	end)

	playerPlot:Set("YinYangSpinWheel", data.YinYangSpinWheel)
	pcall(function()
		self._spinRemote:FireClient(player, rewardIndex, isAltReward)
	end)
end

function YinYangSpinHandler:_getRewardIndex()
	local totalWeight = 0
	for _, reward in ipairs(YinYangSpinWheelData.Rewards) do
		totalWeight += reward.Weight
	end

	local randomWeight = math.random() * totalWeight
	local currentWeight = 0

	for index, reward in ipairs(YinYangSpinWheelData.Rewards) do
		currentWeight += reward.Weight
		if randomWeight <= currentWeight then
			return index
		end
	end
	return 1
end

function YinYangSpinHandler:_grantReward(player, reward, data, playerPlot)
	if reward.Type == "Cash-Pack" then
		local cashValue = ShopData[reward.Index] and ShopData[reward.Index].Value or 0
		local rebirthLevel = data.Rebirths or 0
		if rebirthLevel > 0 then
			cashValue = cashValue * (rebirthLevel <= 1 and 1.5 or rebirthLevel)
		end
		data.Coins = (data.Coins or 0) + cashValue
		playerPlot:Set("Coins", data.Coins)

	elseif reward.Type == "Item" then
		data.Items = data.Items or {}
		data.Items[reward.Index] = true
		local toolClone = ReplicatedStorage.Items:FindFirstChild(reward.Index)
		if toolClone then
			toolClone:Clone().Parent = player.Backpack
		end
		playerPlot:Set("Items", data.Items)

	elseif reward.Type == "Animal" then
		local success, result = pcall(function()
			local DataManagement = require(game:GetService("ServerScriptService").Services.DataManagment)
			return DataManagement.addAnimal(player, reward.Index, reward.Mutation)
		end)
		if success and result then
			pcall(function()
				local DataManagement = require(game:GetService("ServerScriptService").Services.DataManagment)
				DataManagement.addToIndex(player, reward.Index, reward.Mutation)
			end)
		else
			local alternativeCoinValue = 1000
			data.Coins = (data.Coins or 0) + alternativeCoinValue
			playerPlot:Set("Coins", data.Coins)
		end

	elseif reward.Type == "Server-Luck" then
		local MULTIPLIER = 8
		local DURATION = 900
		local now = os.time()
		local endTime = now + DURATION

		if ServerLuckSynchronizer then
			ServerLuckSynchronizer:Set("Index", MULTIPLIER)
			ServerLuckSynchronizer:Set("EndTime", endTime)
		end

		ReplicatedStorage:SetAttribute("ServerLuckMultiplier", MULTIPLIER)
		ReplicatedStorage:SetAttribute("ServerLuckEndTime", endTime)
	end
end

function YinYangSpinHandler:OnPurchaseFinished(player, productId, isPurchased)
end

function YinYangSpinHandler:GetPlayerSpins(player)
	local data = self._monetizationService:GetPlayerData(player)
	if data and data.YinYangSpinWheel then
		return data.YinYangSpinWheel.Spins or 0
	end
	return 0
end

function YinYangSpinHandler:GetProductInfo(productId)
	return ShopData[tonumber(productId)]
end

Players.PlayerRemoving:Connect(function(player)
	notificationCooldown[player] = nil
end)

return YinYangSpinHandler
