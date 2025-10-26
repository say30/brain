--[[
  Extracted from: ServerScriptService.Services.RoadAnimalService.RoadAnimalInteraction
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local RoadAnimalInteraction = {}
RoadAnimalInteraction.__index = RoadAnimalInteraction

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")

local Net = require(ReplicatedStorage.Packages.Net)
local NotificationEvent = Net:RemoteEvent("NotificationService/Notify")

local Animals = require(ReplicatedStorage.Datas.Animals)
local NumberUtils = require(ReplicatedStorage.Utils.NumberUtils)
local DataManagement = require(ServerScriptService.Services.DataManagment)

function RoadAnimalInteraction.new(config)
	local self = setmetatable({}, RoadAnimalInteraction)

	self.Config = config
	self.MainService = nil
	self.AnimalPrompts = {}

	return self
end

function RoadAnimalInteraction:SetMainService(mainService)
	self.MainService = mainService
end

function RoadAnimalInteraction:SetupAnimalInteraction(animalTemplate, animalData)
	if not animalTemplate or not animalData then
		warn("Invalid animal or data provided to interaction setup")
		return
	end

	local primaryPart = animalTemplate.PrimaryPart
	if not primaryPart then
		warn("Animal template missing PrimaryPart for interaction")
		return
	end

	local promptAttachment = primaryPart:FindFirstChild("PromptAttachment")
	if not promptAttachment then
		warn("Animal template missing PromptAttachment for interaction")
		return
	end

	local proximityPrompt = promptAttachment:FindFirstChild("ProximityPrompt")
	if not proximityPrompt then
		warn("Animal template missing ProximityPrompt for interaction")
		return
	end

	self:_setupPromptBehavior(proximityPrompt, animalTemplate, animalData)

	self.AnimalPrompts[animalTemplate] = proximityPrompt
end

function RoadAnimalInteraction:CleanupAnimalInteraction(animalTemplate)
	local prompt = self.AnimalPrompts[animalTemplate]
	if prompt then
		self.AnimalPrompts[animalTemplate] = nil
	end
end

function RoadAnimalInteraction:_setupPromptBehavior(proximityPrompt, animalTemplate, animalData)
	proximityPrompt.Triggered:Connect(function(player)
		self:_handleInteraction(player, animalTemplate, animalData)
	end)
end

function RoadAnimalInteraction:_handleInteraction(player, animalTemplate, animalData)
	local basePrice = animalData.Price or 0
	local currentPrice = animalTemplate:GetAttribute("CurrentPrice") or basePrice

	local playerMoney = self:_getPlayerMoney(player)
	if playerMoney < currentPrice then
		local moneyNeeded = currentPrice - playerMoney
		local message = ("You need $%s more to buy this"):format(NumberUtils:ToString(moneyNeeded))
		self:_sendNotification(player, message, "error")
		return
	end

	if not self:_hasSpaceInPlot(player) then
		return
	end

	local success = self:_processPurchase(player, currentPrice)
	if not success then
		self:_sendNotification(player, "Purchase failed. Please try again.", "error")
		return
	end

	local newPrice = currentPrice + math.floor(basePrice * 0.5)
	animalTemplate:SetAttribute("CurrentPrice", newPrice)

	self:_sendAnimalToPlayer(player, animalTemplate, animalData)

	local Sound = game.ReplicatedStorage.Sounds.Animals:FindFirstChild(animalData.DisplayName)
	if Sound then
		Sound:Play()
	end
end

function RoadAnimalInteraction:_getPlayerMoney(player)
	if not DataManagement.isDataReady(player) then
		if self.Config.DEBUG.PRINT_PURCHASE_INFO then
			print(("⚠️ Player data not ready for %s"):format(player.Name))
		end
		return 0
	end

	local coins = DataManagement.GetCoins(player)

	if self.Config.DEBUG.PRINT_PURCHASE_INFO then
		print(("💰 Player %s has %d coins"):format(player.Name, coins))
	end

	return coins
end

function RoadAnimalInteraction:_hasSpaceInPlot(player)
	if not DataManagement.isDataReady(player) then
		if self.Config.DEBUG.PRINT_PURCHASE_INFO then
			print(("⚠️ Player data not ready for space check: %s"):format(player.Name))
		end
		return false
	end

	local ServerScriptService = game:GetService("ServerScriptService")
	local PlotsService = require(ServerScriptService.Services.Plots)
	local playerPlot = PlotsService.getPlotModel(player)

	if not playerPlot then
		if self.Config.DEBUG.PRINT_PURCHASE_INFO then
			print(("⚠️ Player %s doesn't have a plot yet"):format(player.Name))
		end
		return false
	end

	local animalList = DataManagement.getAnimalList(player)
	local maxAnimals = DataManagement.GetMaxAnimals(player)

	local animalCount = 0
	for _, animal in pairs(animalList) do
		if animal ~= "Empty" and animal ~= nil then
			animalCount = animalCount + 1
		end
	end

	local animalsInTransit = self:_countAnimalsInTransit(player)

	local totalAnimals = animalCount + animalsInTransit
	local hasSpace = totalAnimals < maxAnimals

	if self.Config.DEBUG.PRINT_PURCHASE_INFO then
		print(("🏠 Player %s has %d/%d animals (%d in plot + %d in transit) (Space: %s)"):format(
			player.Name, totalAnimals, maxAnimals, animalCount, animalsInTransit, tostring(hasSpace)))
	end

	return hasSpace
end

function RoadAnimalInteraction:_countAnimalsInTransit(player)
	if not self.MainService or not self.MainService.ActiveAnimals then
		return 0
	end

	local count = 0
	local playerUserId = player.UserId

	for animalTemplate, _ in pairs(self.MainService.ActiveAnimals) do
		if animalTemplate and animalTemplate.Parent then
			local proximityPrompt = animalTemplate.PrimaryPart and 
				animalTemplate.PrimaryPart:FindFirstChild("PromptAttachment") and
				animalTemplate.PrimaryPart.PromptAttachment:FindFirstChild("ProximityPrompt")

			if proximityPrompt then
				local targetPlayerId = proximityPrompt:GetAttribute("TargetPlayer")
				if targetPlayerId == playerUserId then
					count = count + 1
				end
			end
		end
	end

	return count
end

function RoadAnimalInteraction:_processPurchase(player, animalPrice)
	if not DataManagement.isDataReady(player) then
		warn(("Player data not ready for purchase: %s"):format(player.Name))
		return false
	end

	local currentMoney = DataManagement.GetCoins(player)
	if currentMoney < animalPrice then
		if self.Config.DEBUG.PRINT_PURCHASE_INFO then
			print(("❌ Insufficient funds at purchase time for %s"):format(player.Name))
		end
		return false
	end

	local deductionSuccess = DataManagement.deductCoins(player, animalPrice)

	if not deductionSuccess then
		warn(("Failed to deduct %d coins from %s"):format(animalPrice, player.Name))
		return false
	end

	if self.Config.DEBUG.PRINT_PURCHASE_INFO then
		print(("💸 Successfully deducted %d coins from %s"):format(animalPrice, player.Name))
	end

	self:_updatePlayerSyncData(player)

	return true
end

function RoadAnimalInteraction:_sendAnimalToPlayer(player, animalTemplate, animalData)
	local proximityPrompt = animalTemplate.PrimaryPart:FindFirstChild("PromptAttachment"):FindFirstChild("ProximityPrompt")
	if proximityPrompt then
		local animalIndex = animalTemplate:GetAttribute("Index")
		proximityPrompt:SetAttribute("TargetPlayer", player.UserId)
		proximityPrompt:SetAttribute("AnimalData", animalIndex)

		if self.Config.DEBUG.PRINT_PURCHASE_INFO then
			print(("🏷️ Set animal data on prompt: Player=%d, Animal=%s"):format(player.UserId, animalIndex or "unknown"))
		end
	else
		warn("Failed to find proximity prompt for animal:", animalTemplate.Name)
	end

	local playerPlot = self:_findPlayerPlot(player)
	if not playerPlot then
		warn("Player plot not found for:", player.Name)
		return
	end

	local animalTarget = playerPlot:FindFirstChild("AnimalTarget")
	if not animalTarget then
		warn("AnimalTarget not found in player plot for:", player.Name)
		return
	end

	if self.MainService and self.MainService.Pathfinder then
		self.MainService.Pathfinder:ChangeTarget(animalTemplate, animalTarget.Position)
	end

	if self.Config.DEBUG.PRINT_PURCHASE_INFO then
		print(("🛒 %s purchased by %s, moving to their plot"):format(animalData.DisplayName, player.Name))
	end
end

function RoadAnimalInteraction:_findPlayerPlot(player)
	local ServerScriptService = game:GetService("ServerScriptService")
	local PlotsService = require(ServerScriptService.Services.Plots)
	local plotModel = PlotsService.getPlotModel(player)

	if plotModel then
		if self.Config.DEBUG.PRINT_PURCHASE_INFO then
			print(("✅ Found plot via Plots service: %s for player %s"):format(plotModel.Name, player.Name))
		end
		return plotModel
	end

	local plotsFolder = workspace:FindFirstChild("Plots")
	if not plotsFolder then
		warn("Plots folder not found in workspace for player:", player.Name)
		return nil
	end

	if self.Config.DEBUG.PRINT_PURCHASE_INFO then
		print(("🔍 Fallback search for plot for player %s (UserId: %d)"):format(player.Name, player.UserId))
		for _, plot in pairs(plotsFolder:GetChildren()) do
			local owner = plot:GetAttribute("Owner")
			print(("  Plot %s has owner: %s"):format(plot.Name, tostring(owner)))
		end
	end

	for _, plot in pairs(plotsFolder:GetChildren()) do
		if plot:GetAttribute("Owner") == player.UserId then
			if self.Config.DEBUG.PRINT_PURCHASE_INFO then
				print(("✅ Found plot via fallback: %s for player %s"):format(plot.Name, player.Name))
			end
			return plot
		end
	end

	warn(("❌ Player plot not found for: %s (UserId: %d)"):format(player.Name, player.UserId))
	return nil
end

function RoadAnimalInteraction:_updatePlayerSyncData(player)
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local Synchronizer = require(ReplicatedStorage.Packages.Synchronizer)

	task.wait(0.2)

	local updatedData = DataManagement.GetDataMan(player)
	local playerSync = Synchronizer:Get(player)

	if updatedData and playerSync then
		local currentSyncCoins = playerSync:Get("Coins") or 0
		local newCoins = updatedData.Coins

		if self.Config.DEBUG.PRINT_PURCHASE_INFO then
			print(("🔄 Coin sync - Before: %d, After: %d, Setting to: %d"):format(
				currentSyncCoins, newCoins, newCoins))
		end

		playerSync:Set("Coins", newCoins)
	else
		warn("Failed to update player sync data - missing data or sync object for:", player.Name)
	end
end

function RoadAnimalInteraction:_sendNotification(player, message, notificationType)
	notificationType = notificationType or "info"

	local formattedMessage = message
	if notificationType == "error" then
		formattedMessage = ("<font color=\"#FA0103\">%s</font>"):format(message)
	elseif notificationType == "success" then
		formattedMessage = ("<font color=\"#00FF00\">%s</font>"):format(message)
	end

	local duration = self.Config.PURCHASE_SETTINGS.NOTIFICATION_DURATION or 3
	NotificationEvent:FireClient(player, formattedMessage, duration)
end

return RoadAnimalInteraction 