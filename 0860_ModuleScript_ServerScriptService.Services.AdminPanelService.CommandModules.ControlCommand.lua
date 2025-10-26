--[[
  Extracted from: ServerScriptService.Services.AdminPanelService.CommandModules.ControlCommand
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ControlCommand = {}
ControlCommand.__index = ControlCommand

local _activeSessions = {}

function ControlCommand.new()
	local self = setmetatable({}, ControlCommand)
	return self
end

function ControlCommand:Execute(executor, victim)
	if executor == victim then
		return false, "You cannot control yourself!"
	end

	if _activeSessions[executor.UserId] or _activeSessions[victim.UserId] then
		return false, "One of the players is already in a control session!"
	end

	local originalOwnership = self:_transferNetworkOwnership(victim, executor)

	_activeSessions[executor.UserId] = {
		victim = victim,
		originalOwnership = originalOwnership,
		startTime = tick()
	}

	task.delay(10, function()
		self:_endControl(executor)
	end)

	return true, "Control activated for 10 seconds!"
end

function ControlCommand:_transferNetworkOwnership(victim, executor)
	local victimCharacter = victim.Character
	if not victimCharacter then return {} end

	local originalOwnership = {}

	for _, part in pairs(victimCharacter:GetDescendants()) do
		if part:IsA("BasePart") then
			pcall(function()
				originalOwnership[part] = part:GetNetworkOwner()
				part:SetNetworkOwner(executor)
			end)
		end
	end

	return originalOwnership
end

function ControlCommand:_endControl(executor)
	local sessionData = _activeSessions[executor.UserId]
	if not sessionData then return end

	local victim = sessionData.victim
	local originalOwnership = sessionData.originalOwnership

	if victim and victim.Character then
		for part, originalOwner in pairs(originalOwnership) do
			if part and part.Parent then
				pcall(function()
					part:SetNetworkOwner(originalOwner)
				end)
			end
		end
	end

	_activeSessions[executor.UserId] = nil
end

return ControlCommand.new()