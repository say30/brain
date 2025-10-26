--[[
  Extracted from: ServerScriptService.Services.Plots.PlotManager
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")

local PlotConstants = require(script.Parent.PlotConstants)
local Plot = require(script.Parent.Plot)
local AnimalManager = require(script.Parent.AnimalManager)
local PlotSecurity = require(script.Parent.PlotSecurity)
local DataManagement = require(ServerScriptService.Services.DataManagment)

local PlotManager = {}
PlotManager.__index = PlotManager

function PlotManager.new(plotSynchronizer)
	local self = setmetatable({}, PlotManager)

	self.plotSynchronizer = plotSynchronizer

	self.playerPlots = {} 
	self.plotsByUUID = {}

	self.animalManagers = {}
	self.securityManagers = {}

	self:_setupPlayerEvents()

	return self
end

function PlotManager:_setupPlayerEvents()
	Players.PlayerRemoving:Connect(function(player)
		self:RemovePlayerPlot(player)
	end)
end

function PlotManager:CreatePlayerPlot(player)
	if self.playerPlots[player] then
		warn("[PlotManager] Player already has a plot: " .. player.Name)
		return self.playerPlots[player]
	end

	if not DataManagement.isDataReady(player) then
		warn("[PlotManager] Player data not ready for plot creation: " .. player.Name .. ", waiting...")
		local success = DataManagement.waitForData(player, PlotConstants.TIMING.DATA_WAIT_TIMEOUT)
		if not success then
			warn("[PlotManager] Failed to get data for plot creation for player: " .. player.Name)
			return nil
		end
	end

	local success, result = pcall(function()
		local playerData = DataManagement.GetDataMan(player)
		if not playerData then
			error("Failed to get player data")
		end

		local animalList = DataManagement.calculateOfflineGains(player)

		for _, animal in pairs(animalList) do
			if animal and typeof(animal) == "table" then
				animal.Steal = false
			end
		end

		local plot = Plot.new(player, playerData.Rebirths, {
			AnimalList = animalList
		})

		local uuid = plot:GetUUID()
		self.playerPlots[player] = plot
		self.plotsByUUID[uuid] = plot

		self.animalManagers[uuid] = AnimalManager.new(plot)
		self.securityManagers[uuid] = PlotSecurity.new(plot)

		self.plotSynchronizer:RegisterPlot(plot)

		self:_setupCharacterSpawning(player)

		if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			plot:TeleportOwnerToSpawn()
		end

		if plot.ApplyAppropriateSkin then
			plot:ApplyAppropriateSkin()
		end

		if plot._ensureBaseRewardsApplied then
			plot:_ensureBaseRewardsApplied()
		end

		task.spawn(function()
			task.wait(2)
			if plot and plot._ensureBaseRewardsApplied then
				plot:_ensureBaseRewardsApplied()
			end
		end)

		return plot
	end)

	if not success then
		warn("[PlotManager] Error creating plot for: " .. player.Name .. " - " .. tostring(result))
		return nil
	end

	return result
end

function PlotManager:RemovePlayerPlot(player)
	local plot = self.playerPlots[player]
	if not plot then
		return
	end

	local uuid = plot:GetUUID()

	self.plotSynchronizer:UnregisterPlot(plot)

	self.animalManagers[uuid] = nil
	self.securityManagers[uuid] = nil

	self.playerPlots[player] = nil
	self.plotsByUUID[uuid] = nil

	plot:Destroy()
end

function PlotManager:GetPlayerPlot(player)
	return self.playerPlots[player]
end

function PlotManager:GetPlotByUUID(uuid)
	return self.plotsByUUID[uuid]
end

function PlotManager:GetPlayerPlotModel(player)
	local plot = self.playerPlots[player]
	return plot and plot:GetPlotModel() or nil
end

function PlotManager:GetAnimalManager(plot)
	local uuid = plot:GetUUID()
	return self.animalManagers[uuid]
end

function PlotManager:GetSecurityManager(plot)
	local uuid = plot:GetUUID()
	return self.securityManagers[uuid]
end

function PlotManager:HandlePlayerRebirth(player, newTier)
	local plot = self.playerPlots[player]
	if not plot then
		return false
	end

	local success, err = pcall(function()
		plot:UpdateForRebirth(newTier)

		local updatedAnimalList = DataManagement.getAnimalList(player)
		plot:SetAnimalList(updatedAnimalList)

		if plot.ApplyAppropriateSkin then
			plot:ApplyAppropriateSkin()
		end

	end)

	if not success then
		return false
	end

	return true
end

function PlotManager:_setupCharacterSpawning(player)
	player.CharacterAdded:Connect(function(character)
		local plot = self.playerPlots[player]
		if plot then
			task.wait(PlotConstants.VISUAL.SPAWN_WAIT_TIME)
			plot:TeleportOwnerToSpawn()
		end
	end)
end

function PlotManager:GetAllPlots()
	local plots = {}
	for _, plot in pairs(self.plotsByUUID) do
		table.insert(plots, plot)
	end
	return plots
end

function PlotManager:GetPlotsByOwner(player)
	local plots = {}
	for _, plot in pairs(self.plotsByUUID) do
		if plot:GetOwner() == player then
			table.insert(plots, plot)
		end
	end
	return plots
end

function PlotManager:GetStats()
	local stats = {
		totalPlots = 0,
		activePlayers = 0,
		plotDetails = {},
		componentManagers = {
			animalManagers = 0,
			securityManagers = 0
		}
	}

	for player, plot in pairs(self.playerPlots) do
		stats.totalPlots = stats.totalPlots + 1
		stats.activePlayers = stats.activePlayers + 1

		local uuid = plot:GetUUID()
		stats.plotDetails[uuid] = {
			owner = player.Name,
			tier = plot.tier,
			isActive = plot:IsActive(),
			isLocked = plot:IsLocked(),
			animalCount = 0
		}

		local animalList = plot:GetAnimalList()
		for _, animal in pairs(aniFirstFlooralList) do
			if animal ~= PlotConstants.STATES.EMPTY and typeof(animal) == "table" then
				stats.plotDetails[uuid].animalCount = stats.plotDetails[uuid].animalCount + 1
			end
		end
	end

	for _ in pairs(self.animalManagers) do
		stats.componentManagers.animalManagers = stats.componentManagers.animalManagers + 1
	end

	for _ in pairs(self.securityManagers) do
		stats.componentManagers.securityManagers = stats.componentManagers.securityManagers + 1
	end

	return stats
end

function PlotManager:ValidateAllPlots()
	local report = {
		total = 0,
		valid = 0,
		issues = {},
		componentIssues = {}
	}

	for uuid, plot in pairs(self.plotsByUUID) do
		report.total = report.total + 1

		local plotValid = true
		local plotIssues = {}

		if not plot:IsActive() then
			table.insert(plotIssues, "Plot is not active")
			plotValid = false
		end

		if not plot:GetOwner() then
			table.insert(plotIssues, "Plot has no owner")
			plotValid = false
		end

		if not plot:GetPlotModel() then
			table.insert(plotIssues, "Plot has no model")
			plotValid = false
		end

		if not plot:GetSynchronizer() then
			table.insert(plotIssues, "Plot has no synchronizer")
			plotValid = false
		end

		if not self.animalManagers[uuid] then
			table.insert(plotIssues, "Missing animal manager")
			plotValid = false
		end

		if not self.securityManagers[uuid] then
			table.insert(plotIssues, "Missing security manager")
			plotValid = false
		end

		if plotValid then
			report.valid = report.valid + 1
		else
			report.issues[uuid] = plotIssues
		end
	end

	return report
end

function PlotManager:Cleanup()
	for player, plot in pairs(self.playerPlots) do
		self:RemovePlayerPlot(player)
	end

	self.playerPlots = {}
	self.plotsByUUID = {}
	self.animalManagers = {}
	self.securityManagers = {}
end

function PlotManager:EmergencyRepair()
	local report = {
		removed = 0,
		repaired = 0,
		issues = {}
	}

	local toRemove = {}
	for uuid, plot in pairs(self.plotsByUUID) do
		local owner = plot:GetOwner()
		if not owner or not owner.Parent then
			table.insert(toRemove, uuid)
		end
	end

	for _, uuid in ipairs(toRemove) do
		local plot = self.plotsByUUID[uuid]
		if plot then
			self.plotSynchronizer:UnregisterPlot(plot)
			plot:Destroy()

			self.plotsByUUID[uuid] = nil
			self.animalManagers[uuid] = nil
			self.securityManagers[uuid] = nil

			report.removed = report.removed + 1
		end
	end

	for player, plot in pairs(self.playerPlots) do
		local uuid = plot:GetUUID()
		if not self.plotsByUUID[uuid] then
			self.plotsByUUID[uuid] = plot
			report.repaired = report.repaired + 1
		end
	end

	return report
end

return PlotManager