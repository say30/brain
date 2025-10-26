--[[
  Extracted from: ServerScriptService.Services.Plots
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")

local PlotConstants = require(script.PlotConstants)
local PlotManager = require(script.PlotManager)
local PlotSynchronizer = require(script.PlotSynchronizer)
local AnimalStealing = require(script.AnimalStealing)
local AnimalGrabbing = require(script.AnimalGrab)
local LuckyBlockTimerManager = require(script.LuckyBlockTimerManager)

local DataManagement = require(ServerScriptService.Services.DataManagment)
local Net = require(ReplicatedStorage.Packages.Net)
local Synchronizer = require(ReplicatedStorage.Packages.Synchronizer)
local Rebirths = require(ReplicatedStorage.Datas.Rebirth)
local Animals = require(ReplicatedStorage.Shared.Animals)

local BaseLockController = require(ServerScriptService.Controllers.BaseLockController)
BaseLockController:Start()

local PlotsService = {}

local plotSynchronizer = nil
local plotManager = nil
local animalStealing = nil
local animalGrabbing = nil
local luckyBlockTimerManager = nil

local ToggleFriends = Net:RemoteEvent("PlotService/ToggleFriends")
local Claim = Net:RemoteEvent("PlotService/ClaimCoins")
local CashCollected = Net:RemoteEvent("PlotService/CashCollected")
local Sell = Net:RemoteEvent("PlotService/Sell")
local RebirthRemote = Net:RemoteFunction("Rebirth/RequestRebirth")

function PlotsService.Initialize()
	plotSynchronizer = PlotSynchronizer.new()
	plotManager = PlotManager.new(plotSynchronizer)
	animalStealing = AnimalStealing.new(plotManager)
	animalGrabbing = AnimalGrabbing.new(plotManager)
	luckyBlockTimerManager = LuckyBlockTimerManager.new(plotManager)

	luckyBlockTimerManager:Start()

	PlotsService._setupRemoteHandlers()
end

function PlotsService._setupRemoteHandlers()
	ToggleFriends.OnServerEvent:Connect(function(player)
		local success, newState = pcall(function()
			local plot = plotManager:GetPlayerPlot(player)
			if not plot then
				warn("[PlotsService] No plot found for ToggleFriends: " .. player.Name)
				return false
			end

			local security = plotManager:GetSecurityManager(plot)
			if not security then
				warn("[PlotsService] No security manager found for plot: " .. plot:GetUUID())
				return false
			end

			return security:ToggleFriendsAccess()
		end)

		if success then
			print("[PlotsService] Friends access toggled for " .. player.Name .. ": " .. tostring(newState))
		else
			warn("[PlotsService] Failed to toggle friends for " .. player.Name .. ": " .. tostring(newState))
		end
	end)

	Claim.OnServerEvent:Connect(function(player, slot)
		if not DataManagement.isDataReady(player) then
			warn("[PlotsService] Player data not ready for claim: " .. player.Name)
			return
		end

		local success, totalCoins = pcall(function()
			local plot = plotManager:GetPlayerPlot(player)
			if not plot then
				warn("[PlotsService] No plot found for claim: " .. player.Name)
				return 0
			end

			if plot:GetOwner() ~= player then
				warn("[PlotsService] Player " .. player.Name .. " trying to claim from non-owned plot")
				return 0
			end

			local animalManager = plotManager:GetAnimalManager(plot)
			if not animalManager then
				warn("[PlotsService] No animal manager found for plot: " .. plot:GetUUID())
				return 0
			end

			local claimSuccess, coins = animalManager:ClaimCoins(slot)
			if claimSuccess then
				CashCollected:FireClient(player)
				return coins
			end

			return 0
		end)

		if success and totalCoins > 0 then

		elseif not success then
			warn("[PlotsService] Error in claim process: " .. tostring(totalCoins))
		end
	end)

	Sell.OnServerEvent:Connect(function(player, slot)
		if not DataManagement.isDataReady(player) then
			warn("[PlotsService] Player data not ready for sell: " .. player.Name)
			return
		end

		local success, sellValue = pcall(function()
			local plot = plotManager:GetPlayerPlot(player)
			if not plot then
				warn("[PlotsService] No plot found for sell: " .. player.Name)
				return 0
			end

			if plot:GetOwner() ~= player then
				warn("[PlotsService] Player " .. player.Name .. " trying to sell from non-owned plot")
				return 0
			end

			local animalManager = plotManager:GetAnimalManager(plot)
			if not animalManager then
				warn("[PlotsService] No animal manager found for plot: " .. plot:GetUUID())
				return 0
			end

			local sellSuccess, value = animalManager:SellAnimal(slot)
			return sellSuccess and value or 0
		end)

		if success and sellValue > 0 then

		elseif not success then
			warn("[PlotsService] Error in sell process: " .. tostring(sellValue))
		end
	end)

	RebirthRemote.OnServerInvoke = function(player)
		return PlotsService._handleRebirth(player)
	end
end

function PlotsService._handleRebirth(player)
	local success, result, message = pcall(function()
		local data = DataManagement.GetDataMan(player)
		if not data then
			return false, "There was an error loading your data, Please rejoin."
		end

		local playerSync = Synchronizer:Get(player)
		if not playerSync then
			return false, "Failed to get player synchronizer"
		end

		local currentRebirth = data.Rebirths or 0
		local nextRebirth = currentRebirth + 1

		if not Rebirths[nextRebirth] then
			return false, "You are already at the highest rebirth level."
		end

		local requirements = Rebirths[nextRebirth].Requirements

		if data.Coins < requirements.Cash then
			return false, "You need to meet all requirements before you can rebirth!"
		end

		local ownedAnimals = data.AnimalList

		for _, requiredAnimal in ipairs(requirements.RequiredCharacters) do
			local found = false
			for _, animal in ipairs(ownedAnimals) do
				if animal.Index == requiredAnimal then
					found = true
					break
				end
			end
			if not found then
				return false, "You need to meet all requirements before you can rebirth!"
			end
		end

		data.Coins = data.Coins - requirements.Cash	
		data.Rebirths = data.Rebirths + 1

		local Bases = require(ReplicatedStorage.Datas.Bases)
		local maxAnimals = Bases[data.Rebirths].MaxAnimals

		for i = 1, maxAnimals do
			data.AnimalList[i] = PlotConstants.STATES.EMPTY
		end

		local plotUpdateSuccess = plotManager:HandlePlayerRebirth(player, data.Rebirths)

		if not plotUpdateSuccess then
			warn("[PlotsService] Failed to update plot for rebirth - reverting data changes")
			data.Coins = data.Coins + requirements.Cash
			data.Rebirths = data.Rebirths - 1
			return false, "Plot update failed during rebirth"
		end

		if playerSync then
			playerSync:Set("Rebirth", data.Rebirths)
			playerSync:Set("Coins", data.Coins)

			task.spawn(function()
				task.wait(0.1)
				playerSync:Set("AnimalAddedOrRemoved", data.AnimalList)
				task.wait(0.05)
				playerSync:Set("AnimalPodiums", data.AnimalList)
			end)
		end

		return true, PlotConstants.SUCCESS.REBIRTH_SUCCESS .. " " .. data.Rebirths
	end)

	if success then
		return result, message
	else
		warn("[PlotsService] Rebirth error for " .. player.Name .. ": " .. tostring(result))
		return false, "Rebirth failed due to server error"
	end
end

function PlotsService.HandlePlayerRebirth(player, rebirthLevel)
	if not plotManager then
		warn("[PlotsService] PlotManager not initialized")
		return false
	end

	return plotManager:HandlePlayerRebirth(player, rebirthLevel)
end

function PlotsService.getPlotManager()
	return plotManager
end

function PlotsService.CreatePlot(player)
	if not plotManager then
		warn("[PlotsService] PlotManager not initialized")
		return nil
	end

	return plotManager:CreatePlayerPlot(player)
end

function PlotsService.getPlot(player)
	if not plotManager then
		return nil
	end

	return plotManager:GetPlayerPlot(player)
end

function PlotsService.getPlotModel(player)
	if not plotManager then
		return nil
	end

	return plotManager:GetPlayerPlotModel(player)
end

function PlotsService.getPlotByUUID(uuid)
	if not plotManager then
		return nil
	end

	return plotManager:GetPlotByUUID(uuid)
end

function PlotsService.PlayerHasFreeAnimalSlot(player)
	if not plotManager then
		warn("[PlotsService] PlotManager not initialized")
		return false
	end

	local plot = plotManager:GetPlayerPlot(player)
	if not plot then
		warn("[PlotsService] No plot found for player: " .. player.Name)
		return false
	end

	local animalManager = plotManager:GetAnimalManager(plot)
	if not animalManager then
		warn("[PlotsService] No animal manager found for plot: " .. plot:GetUUID())
		return false
	end

	local animalList = animalManager:GetAnimalList() -- should return player's animals

	for _, slot in ipairs(animalList) do
		if slot == PlotConstants.STATES.EMPTY then
			return true -- found a free slot
		end
	end

	return false -- no free slots
end

function PlotsService.GetStats()
	local stats = {
		initialized = plotManager ~= nil,
		plotManager = nil,
		plotSynchronizer = nil,
		animalStealing = nil,
		luckyBlockTimerManager = luckyBlockTimerManager ~= nil
	}

	if plotManager then
		stats.plotManager = plotManager:GetStats()
	end

	if plotSynchronizer then
		stats.plotSynchronizer = plotSynchronizer:GetStats()
	end

	return stats
end

function PlotsService.ValidateAll()
	local report = {
		components = {
			plotManager = false,
			plotSynchronizer = false,
			animalStealing = false,
			luckyBlockTimerManager = false
		},
		plotValidation = nil,
		issues = {}
	}

	report.components.plotManager = plotManager ~= nil
	report.components.plotSynchronizer = plotSynchronizer ~= nil
	report.components.animalStealing = animalStealing ~= nil
	report.components.luckyBlockTimerManager = luckyBlockTimerManager ~= nil

	if plotManager then
		report.plotValidation = plotManager:ValidateAllPlots()
	else
		table.insert(report.issues, "PlotManager not initialized")
	end

	return report
end

function PlotsService.EmergencyCleanup()
	local report = {
		plotManagerCleanup = nil,
		synchronizerCleanup = nil,
		luckyBlockTimerCleanup = nil,
		reinitialized = false
	}

	if plotManager then
		report.plotManagerCleanup = plotManager:EmergencyRepair()
	end

	if plotSynchronizer then
		local syncStats = plotSynchronizer:GetStats()
		plotSynchronizer:Cleanup()
		report.synchronizerCleanup = {
			cleanedPlots = syncStats.activePlots
		}
	end

	if luckyBlockTimerManager then
		luckyBlockTimerManager:Stop()
		report.luckyBlockTimerCleanup = true
	end

	if not plotManager or not plotSynchronizer then
		PlotsService.Initialize()
		report.reinitialized = true
	end

	return report
end

function PlotsService.GetLuckyBlockTimerManager()
	return luckyBlockTimerManager
end

function PlotsService.IsLuckyBlockReady(player, slot)
	if not luckyBlockTimerManager then
		return false
	end
	return luckyBlockTimerManager:IsLuckyBlockReady(player, slot)
end

function PlotsService.GetLuckyBlockTimer(player, slot)
	if not luckyBlockTimerManager then
		return nil
	end
	return luckyBlockTimerManager:GetLuckyBlockTimer(player, slot)
end

PlotsService.new = PlotsService.CreatePlot

PlotsService.Initialize()

return PlotsService