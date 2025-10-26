--[[
  Extracted from: ServerScriptService.Services.MonetizationService.MoltenSpinHandler
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")

local Packages = ReplicatedStorage.Packages
local Data = ReplicatedStorage.Datas
local Net = require(Packages.Net)
local ShopData = require(Data.Shop)
local MoltenSpinWheelData = require(Data.MoltenSpinWheel)
local Synchronizer = require(Packages.Synchronizer)

local ServerLuckSynchronizer = Synchronizer:Get("ServerLuck")

local MoltenSpinHandler = {}
MoltenSpinHandler.__index = MoltenSpinHandler

local notificationCooldown = {}
local NOTIFY_COOLDOWN = 0.5

function MoltenSpinHandler.new(monetizationService)
	local self = setmetatable({}, MoltenSpinHandler)

	self._monetizationService = monetizationService
	self._spinRemote = Net:RemoteEvent("MoltenEventService/Spin")
	self._purchaseRemote = Net:RemoteEvent("ShopService/Purchase")

	self:_setupRemoteEvents()

	return self
end

function MoltenSpinHandler:_setupRemoteEvents()
	self._purchaseRemote.OnServerEvent:Connect(function(player, productId)
		if self:_isMoltenSpinProduct(productId) then
			self:PromptPurchase(player, productId)
		end
	end)

	self._spinRemote.OnServerEvent:Connect(function(player)
		pcall(function()
			self:ProcessSpin(player)
		end)
	end)
end

function MoltenSpinHandler:_isMoltenSpinProduct(productId)
	local productInfo = ShopData[tonumber(productId)]
	return productInfo and productInfo.Type == "MoltenWheelSpin"
end

function MoltenSpinHandler:PromptPurchase(player, productId)
	if not self._monetizationService:IsDataReady(player) then return false end

	local productInfo = ShopData[tonumber(productId)]
	if not productInfo then return false end

	local marketplaceInfo = self._monetizationService:GetProductInfo(tonumber(productId))
	if not marketplaceInfo then return false end

	return self._monetizationService:PromptProductPurchase(player, tonumber(productId))
end

function MoltenSpinHandler:ProcessPurchase(player, productId, receiptInfo)
	if not self._monetizationService:IsDataReady(player) then return false end

	local playerPlot = self._monetizationService:GetPlayerSynchronizer(player)
	if not playerPlot then return false end

	local data = self._monetizationService:GetPlayerData(player)
	if not data then return false end

	local productInfo = ShopData[productId]
	if not productInfo or productInfo.Type ~= "MoltenWheelSpin" then return false end

	local spinsToAdd = productInfo.Value or 0
	local isX3Purchase = productInfo.Identifier == "x3"
	local isDiscountPurchase = string.find(productInfo.Display, "DISCOUNT")

	data.MoltenSpinWheel = data.MoltenSpinWheel or {}
	data.MoltenSpinWheel.Spins = (data.MoltenSpinWheel.Spins or 0) + spinsToAdd

	if isX3Purchase then
		data.MoltenSpinWheel.PaidSpins = data.MoltenSpinWheel.PaidSpins or {}
		data.MoltenSpinWheel.PaidSpins.x3 = (data.MoltenSpinWheel.PaidSpins.x3 or 0) + 1
	end

	if isDiscountPurchase then
		data.MoltenSpinWheel.LastDailyDiscount = os.time()
	end

	playerPlot:Set("MoltenSpinWheel", data.MoltenSpinWheel)
	playerPlot:Set("PaidSpins", data.MoltenSpinWheel.PaidSpins)
	if isDiscountPurchase then
		playerPlot:Set("LastDailyDiscount", data.MoltenSpinWheel.LastDailyDiscount)
	end

	self._monetizationService:LogPurchase(player, productId, "MoltenSpin", spinsToAdd .. " spins")

	return true
end

function MoltenSpinHandler:ProcessSpin(player)
	if not self._monetizationService:IsDataReady(player) then return end

	local playerPlot = self._monetizationService:GetPlayerSynchronizer(player)
	if not playerPlot then return end

	local data = self._monetizationService:GetPlayerData(player)
	if not data then return end

	data.MoltenSpinWheel = data.MoltenSpinWheel or {}

	local isFreeSpin = false
	local MoltenEventActive = ReplicatedStorage:GetAttribute("MoltenEvent")

	if MoltenEventActive then
		local lastFreeClaimed = data.MoltenSpinWheel.LastFreeClaimed or 0
		local eventLastTime = ReplicatedStorage:GetAttribute("MoltenEventLastTime")
		if lastFreeClaimed ~= eventLastTime then
			isFreeSpin = true
		end
	end

	local currentSpins = data.MoltenSpinWheel.Spins or 0

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
		data.MoltenSpinWheel.LastFreeClaimed = ReplicatedStorage:GetAttribute("MoltenEventLastTime")
	else
		data.MoltenSpinWheel.Spins = data.MoltenSpinWheel.Spins - 1
	end

	local rewardIndex = self:_getRewardIndex()
	if not MoltenSpinWheelData.Rewards[rewardIndex] then
		rewardIndex = 1
	end

	local reward = MoltenSpinWheelData.Rewards[rewardIndex]
	local isAltReward = false

	if reward.Type == "Item" and data.Items and data.Items[reward.Index] then
		if MoltenSpinWheelData.AltRewards and MoltenSpinWheelData.AltRewards[rewardIndex] then
			reward = MoltenSpinWheelData.AltRewards[rewardIndex]
			isAltReward = true
		end
	end

	pcall(function()
		self:_grantReward(player, reward, data, playerPlot)
	end)

	playerPlot:Set("MoltenSpinWheel", data.MoltenSpinWheel)
	pcall(function()
		self._spinRemote:FireClient(player, rewardIndex, isAltReward)
	end)
end

function MoltenSpinHandler:_getRewardIndex()
	local totalWeight = 0
	for _, reward in ipairs(MoltenSpinWheelData.Rewards) do
		totalWeight += reward.Weight
	end

	local randomWeight = math.random() * totalWeight
	local currentWeight = 0

	for index, reward in ipairs(MoltenSpinWheelData.Rewards) do
		currentWeight += reward.Weight
		if randomWeight <= currentWeight then
			return index
		end
	end
	return 1
end

function MoltenSpinHandler:_grantReward(player, reward, data, playerPlot)
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
		local MULTIPLIER = 6
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

function MoltenSpinHandler:OnPurchaseFinished(player, productId, isPurchased)
end

function MoltenSpinHandler:GetPlayerSpins(player)
	local data = self._monetizationService:GetPlayerData(player)
	if data and data.MoltenSpinWheel then
		return data.MoltenSpinWheel.Spins or 0
	end
	return 0
end

function MoltenSpinHandler:GetProductInfo(productId)
	return ShopData[tonumber(productId)]
end

Players.PlayerRemoving:Connect(function(player)
	notificationCooldown[player] = nil
end)

return MoltenSpinHandler