--[[
  Extracted from: ServerScriptService.Events.MoltenEvent
  Class: Script
  Source file: rickdev.rbxlx
]]

local RunService = game:GetService("RunService")
local workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Packages = ReplicatedStorage:WaitForChild("Packages")
local Net = require(Packages.Net)
local Synchronizer = require(Packages.Synchronizer)

spawn(function()
	local NotificationRemote = Net:RemoteEvent("NotificationService/Notify")

	local function GetCooldownTime()
		local CurrentTime = workspace:GetServerTimeNow()
		local Wday = os.date("!*t", CurrentTime).wday
		return (((Wday == 1) or (Wday == 7)) and 3600) or 10800
	end

	local function FormatTime(Seconds)
		local H = math.floor(Seconds / 3600)
		local M = math.floor((Seconds % 3600) / 60)
		local S = math.floor(Seconds % 60)
		return string.format("%02d:%02d:%02d", H, M, S)
	end

	local function NotifyAllPlayers()
		for _, Player in ipairs(Players:GetPlayers()) do
			NotificationRemote:FireClient(Player, 'The Molten Event is here! You got a <font color="#ff46f6">free spin</font>', 10, "Sounds.Sfx.Success")
		end
	end

	local function CheckAnyPlayerCanSpin()
		local LastEventTime = ReplicatedStorage:GetAttribute("MoltenEventLastTime") or 0
		for _, Player in pairs(Players:GetPlayers()) do
			local PlayerData = Synchronizer:Wait(Player)
			local LastClaimed = PlayerData:Get("MoltenSpinWheel.LastFreeClaimed") or 0
			if (LastClaimed ~= LastEventTime) then
				return true
			end
		end
		return false
	end

	local function StartMoltenEvent()
		ReplicatedStorage:SetAttribute("MoltenEventLastTime", workspace:GetServerTimeNow())
		_G.EventService:StartEvent("Molten")
		NotifyAllPlayers()
	end

	local lastEventStartTime = 0

	while true do
		local Cooldown = GetCooldownTime()
		local CurrentTime = workspace:GetServerTimeNow()
		local TimeUntilNext = Cooldown - (CurrentTime % Cooldown)
		if ((CurrentTime - lastEventStartTime) < 60) then
			task.wait(1)
			continue
		end

		if ReplicatedStorage:GetAttribute("MoltenEvent") then
			if CheckAnyPlayerCanSpin() then
				StartMoltenEvent()
				lastEventStartTime = CurrentTime
				task.wait(Cooldown)
			else
				while TimeUntilNext > 0 do
					task.wait(1)
					TimeUntilNext = Cooldown - (workspace:GetServerTimeNow() % Cooldown)
				end
			end
		else
			while TimeUntilNext > 0 do
				task.wait(1)
				TimeUntilNext = Cooldown - (workspace:GetServerTimeNow() % Cooldown)
			end
			StartMoltenEvent()
			lastEventStartTime = workspace:GetServerTimeNow()
		end
		task.wait(1)
	end
end)