--[[
  Extracted from: ServerScriptService.Services.TutorialService
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Packages = ReplicatedStorage:WaitForChild("Packages")
local Net = require(Packages.Net)
local Synchronizer = require(Packages.Synchronizer)

local DataManagement = require(script.Parent.DataManagment)

local TutorialService = {}

local FinishTutorialRemote = Net:RemoteEvent("FinishTutorial")
local NotificationEvent = Net:RemoteEvent("NotificationService/Notify")

local TUTORIAL_STEPS = {
	STARTED = 1,
	FIRST_ANIMAL_SPAWNED = 2,
	FIRST_ANIMAL_BOUGHT = 3,
	FIRST_ANIMAL_RETURNED = 4,
	FIRST_CASH_COLLECTED = 5,
	TUTORIAL_COMPLETED = 6
}

FinishTutorialRemote.OnServerEvent:Connect(function(player: Player)
	if not player or not player.Parent then
		return
	end

	if DataManagement.isTutorialFinished(player) then
		return
	end

	local success = DataManagement.finishTutorial(player)

	if success then

		local playerChannel = Synchronizer:Get(player)
		if playerChannel then
			playerChannel:Set("TutorialFinished", true)
		else
			warn(`[DEBUG SERVER] Could not find player channel for {player.Name}`)
		end

		local message = "<font color=\"#92FF67\">Tutorial Complete! You're ready to play!</font>"
		NotificationEvent:FireClient(player, message, 5)
	else
		warn(`[DEBUG SERVER] Failed to finish tutorial for {player.Name}`)
	end
end)

function TutorialService.initializePlayerTutorial(player: Player)
	if not DataManagement.waitForData(player, 10) then
		return
	end

	if DataManagement.isTutorialFinished(player) then
		local playerChannel = Synchronizer:Get(player)
		if playerChannel then
			playerChannel:Set("TutorialFinished", true)
		end
		return
	end

	local progress = DataManagement.getTutorialProgress(player)
	if progress.StartedAt == 0 then
		DataManagement.updateTutorialStep(player, TUTORIAL_STEPS.STARTED)
	end

	local playerChannel = Synchronizer:Get(player)
	if playerChannel then
		playerChannel:Set("TutorialFinished", false)
		playerChannel:Set("TutorialStep", progress.CurrentStep)
	else
		warn(`[DEBUG] No player channel found for {player.Name}`)
	end
end

function TutorialService.playerJoined(player: Player)
	task.spawn(function()
		task.wait(1)
		TutorialService.initializePlayerTutorial(player)
	end)
end

function TutorialService.playerLeft(player: Player)
end

Players.PlayerAdded:Connect(TutorialService.playerJoined)
Players.PlayerRemoving:Connect(TutorialService.playerLeft)

for _, player in ipairs(Players:GetPlayers()) do
	TutorialService.playerJoined(player)
end

TutorialService.STEPS = TUTORIAL_STEPS

return TutorialService 