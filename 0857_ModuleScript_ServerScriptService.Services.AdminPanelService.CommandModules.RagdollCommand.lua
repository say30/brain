--[[
  Extracted from: ServerScriptService.Services.AdminPanelService.CommandModules.RagdollCommand
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RagdollModule = require(ReplicatedStorage.Packages.Ragdoll)

local RagdollCommand = {}
RagdollCommand.__index = RagdollCommand

function RagdollCommand.new()
	local self = setmetatable({}, RagdollCommand)
	return self
end

function RagdollCommand:Execute(executor: Player, targetPlayer: Player)
	if not targetPlayer.Character then
		warn("[RagdollCommand] Target player has no character")
		return
	end

	local character = targetPlayer.Character
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid then
		warn("[RagdollCommand] Target player has no humanoid")
		return
	end

	-- Apply 8 second ragdoll
	RagdollModule.TimedRagdoll(character, 8)

	-- After 3 seconds, listen for jump
	task.delay(3, function()
		if not targetPlayer.Parent then return end
		if not character.Parent then return end
		if not humanoid.Parent then return end

		local connection
		connection = humanoid.Jumping:Connect(function(isActive)
			if isActive then
				-- Unragdoll immediately if they jump
				RagdollModule.Unragdoll(character)
				connection:Disconnect()
			end
		end)

		-- Safety: disconnect after 5 seconds (remaining ragdoll duration)
		task.delay(5, function()
			if connection.Connected then
				connection:Disconnect()
			end
		end)
	end)
end

return RagdollCommand.new()
