--[[
  Extracted from: ServerScriptService.Services.Plots.PlotSynchronizer
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Synchronizer = require(ReplicatedStorage.Packages.Synchronizer)

local PlotSynchronizer = {}
PlotSynchronizer.__index = PlotSynchronizer

function PlotSynchronizer.new()
	local self = setmetatable({}, PlotSynchronizer)

	self.activePlots = {}

	self:_setupPlayerManagement()

	return self
end

function PlotSynchronizer:_setupPlayerManagement()
	Players.PlayerAdded:Connect(function(player)
		for uuid, plotSynchronizer in pairs(self.activePlots) do
			plotSynchronizer:AddListener(player)
		end
	end)

	Players.PlayerRemoving:Connect(function(player)
		for uuid, plotSynchronizer in pairs(self.activePlots) do
			plotSynchronizer:RemoveListener(player)
		end
	end)
end

function PlotSynchronizer:RegisterPlot(plot)
	local uuid = plot:GetUUID()
	local synchronizer = plot:GetSynchronizer()

	self.activePlots[uuid] = synchronizer

	for _, player in pairs(Players:GetPlayers()) do
		synchronizer:AddListener(player)
	end
end

function PlotSynchronizer:UnregisterPlot(plot)
	local uuid = plot:GetUUID()
	local synchronizer = plot:GetSynchronizer()

	if not synchronizer then
		return
	end

	for _, player in pairs(Players:GetPlayers()) do
		synchronizer:RemoveListener(player)
	end

	self.activePlots[uuid] = nil
end

function PlotSynchronizer:GetPlotSynchronizer(uuid)
	return self.activePlots[uuid]
end

function PlotSynchronizer:BroadcastToAllPlots(key, value)
	for uuid, synchronizer in pairs(self.activePlots) do
		synchronizer:Set(key, value)
	end
end

function PlotSynchronizer:AddListenerToAllPlots(player)
	for uuid, synchronizer in pairs(self.activePlots) do
		synchronizer:AddListener(player)
	end
end

function PlotSynchronizer:RemoveListenerFromAllPlots(player)
	for uuid, synchronizer in pairs(self.activePlots) do
		synchronizer:RemoveListener(player)
	end
end

function PlotSynchronizer:GetStats()
	local stats = {
		activePlots = 0,
		totalListeners = 0,
		plotDetails = {}
	}

	for uuid, synchronizer in pairs(self.activePlots) do
		stats.activePlots = stats.activePlots + 1

		local listenerCount = 0
		for _, player in pairs(Players:GetPlayers()) do
			listenerCount = listenerCount + 1
		end

		stats.totalListeners = stats.totalListeners + listenerCount
		stats.plotDetails[uuid] = {
			listeners = listenerCount,
			owner = synchronizer:Get("Owner") and synchronizer:Get("Owner").Name or "Unknown",
			animalCount = 0,
		}

		local animalList = synchronizer:Get("AnimalList") or {}
		for _, animal in pairs(animalList) do
			if animal ~= "Empty" and typeof(animal) == "table" then
				stats.plotDetails[uuid].animalCount = stats.plotDetails[uuid].animalCount + 1
			end
		end
	end

	return stats
end

function PlotSynchronizer:ForceSyncPlot(plot)
	local uuid = plot:GetUUID()
	local synchronizer = self.activePlots[uuid]

	local currentData = {
		AnimalList = synchronizer:Get("AnimalList"),
		FriendsAllowed = synchronizer:Get("FriendsAllowed"),
		BlockEndTime = synchronizer:Get("BlockEndTime"),
		BlockedDelayTime = synchronizer:Get("BlockedDelayTime"),
	}

	for key, value in pairs(currentData) do
		synchronizer:Set(key, value)
	end
end

function PlotSynchronizer:Cleanup()
	for uuid, synchronizer in pairs(self.activePlots) do
		for _, player in pairs(Players:GetPlayers()) do
			synchronizer:RemoveListener(player)
		end

		synchronizer:Destroy()
	end

	self.activePlots = {}
end

function PlotSynchronizer:IsPlotSynchronized(plot)
	local uuid = plot:GetUUID()
	local synchronizer = self.activePlots[uuid]

	if not synchronizer then
		return false
	end

	local requiredKeys = {
		"Owner",
		"AnimalList", 
		"FriendsAllowed",
		"BlockEndTime",
		"BlockedDelayTime",
		"BlockEndTimeFirstFloor",
		"BlockEndTimeSecondFloor", 
		"BlockEndTimeThirdFloor"
	}

	for _, key in ipairs(requiredKeys) do
		local success, value = pcall(function()
			return synchronizer:Get(key)
		end)
	end

	return true
end

function PlotSynchronizer:RepairPlotSync(plot)
	local uuid = plot:GetUUID()

	if self.activePlots[uuid] then
		local oldSync = self.activePlots[uuid]

		for _, player in pairs(Players:GetPlayers()) do
			pcall(function()
				oldSync:RemoveListener(player)
			end)
		end

		pcall(function()
			oldSync:Destroy()
		end)

		self.activePlots[uuid] = nil
	end

	self:RegisterPlot(plot)

	return self:IsPlotSynchronized(plot)
end

function PlotSynchronizer:ValidateAllPlots()
	local report = {
		total = 0,
		valid = 0,
		repaired = 0,
		failed = 0,
		details = {}
	}

	local plotsToCheck = {}
	for uuid, _ in pairs(self.activePlots) do
		table.insert(plotsToCheck, uuid)
	end

	report.total = #plotsToCheck

	for _, uuid in ipairs(plotsToCheck) do
		local synchronizer = self.activePlots[uuid]
		if synchronizer then
			local owner = synchronizer:Get("Owner")
			local ownerName = owner and owner.Name or "Unknown"

			local mockPlot = {
				GetUUID = function() return uuid end,
				GetSynchronizer = function() return synchronizer end
			}

			if self:IsPlotSynchronized(mockPlot) then
				report.valid = report.valid + 1
				report.details[uuid] = {
					status = "valid",
					owner = ownerName
				}
			else
				local repairSuccess = self:RepairPlotSync(mockPlot)
				if repairSuccess then
					report.repaired = report.repaired + 1
					report.details[uuid] = {
						status = "repaired",
						owner = ownerName
					}
				else
					report.failed = report.failed + 1
					report.details[uuid] = {
						status = "failed",
						owner = ownerName
					}
				end
			end
		end
	end

	return report
end

return PlotSynchronizer 