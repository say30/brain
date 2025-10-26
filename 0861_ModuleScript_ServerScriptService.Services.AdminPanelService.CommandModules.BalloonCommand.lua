--[[
  Extracted from: ServerScriptService.Services.AdminPanelService.CommandModules.BalloonCommand
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local Players = game:GetService("Players")

local BalloonCommand = {}
BalloonCommand.__index = BalloonCommand

function BalloonCommand.new()
	local self = setmetatable({}, BalloonCommand)
	return self
end

function BalloonCommand:Execute(executor: Player, targetPlayer: Player)
	if not targetPlayer.Character then
		warn("[BalloonCommand] Target player has no character")
		return
	end

	local character = targetPlayer.Character
	local humanoid = character:FindFirstChild("Humanoid")
	local head = character:FindFirstChild("Head")

	if not humanoid or not head then
		warn("[BalloonCommand] Target player missing humanoid or head")
		return
	end

	local originalJumpPower = humanoid.JumpPower
	local originalUseJumpPower = humanoid.UseJumpPower
	local originalHeadScale = humanoid:FindFirstChild("HeadScale") and humanoid.HeadScale.Value or 1

	humanoid.JumpPower = 30
	humanoid.UseJumpPower = true
	if humanoid:FindFirstChild("HeadScale") then
		humanoid.HeadScale.Value = originalHeadScale * 1.5
	end

	task.delay(15, function()
		if humanoid and humanoid.Parent then
			humanoid.JumpPower = originalJumpPower
			humanoid.UseJumpPower = false
			if humanoid:FindFirstChild("HeadScale") then
				humanoid.HeadScale.Value = originalHeadScale
			end
		end
	end)
end

return BalloonCommand.new() 