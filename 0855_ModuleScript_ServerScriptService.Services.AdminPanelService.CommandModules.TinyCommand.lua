--[[
  Extracted from: ServerScriptService.Services.AdminPanelService.CommandModules.TinyCommand
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local Players = game:GetService("Players")

local TinyCommand = {}
TinyCommand.__index = TinyCommand

function TinyCommand.new()
	local self = setmetatable({}, TinyCommand)
	return self
end

function TinyCommand:Execute(executor: Player, targetPlayer: Player)
	if not targetPlayer.Character then
		warn("[TinyCommand] Target player has no character")
		return
	end

	local character = targetPlayer.Character
	local humanoid = character:FindFirstChild("Humanoid")

	if not humanoid then
		warn("[TinyCommand] Target player has no humanoid")
		return
	end

	local scale = 0.5

	local originalBodyWidthScale = humanoid.BodyWidthScale.Value
	local originalBodyHeightScale = humanoid.BodyHeightScale.Value
	local originalBodyDepthScale = humanoid.BodyDepthScale.Value
	local originalHeadScale = humanoid.HeadScale.Value

	humanoid.BodyWidthScale.Value = scale
	humanoid.BodyHeightScale.Value = scale
	humanoid.BodyDepthScale.Value = scale
	humanoid.HeadScale.Value = scale

	task.delay(30, function()
		if character and character.Parent and humanoid and humanoid.Parent then
			humanoid.BodyWidthScale.Value = originalBodyWidthScale
			humanoid.BodyHeightScale.Value = originalBodyHeightScale
			humanoid.BodyDepthScale.Value = originalBodyDepthScale
			humanoid.HeadScale.Value = originalHeadScale
		end
	end)
end

return TinyCommand.new()