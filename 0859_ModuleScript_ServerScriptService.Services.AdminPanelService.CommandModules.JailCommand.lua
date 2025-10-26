--[[
  Extracted from: ServerScriptService.Services.AdminPanelService.CommandModules.JailCommand
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local JailCommand = {}
JailCommand.__index = JailCommand

function JailCommand.new()
	local self = setmetatable({}, JailCommand)
	return self
end

function JailCommand:Execute(executor: Player, targetPlayer: Player)
	if not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
		warn("[JailCommand] Target player has no character or HumanoidRootPart")
		return
	end

	local character = targetPlayer.Character
	local humanoidRootPart = character.HumanoidRootPart

	local jail = Instance.new("Model")
	jail.Name = "JailCell_" .. targetPlayer.Name
	jail.Parent = workspace

	local jailSize = Vector3.new(8, 8, 8)
	local jailPosition = humanoidRootPart.Position + Vector3.new(0, jailSize.Y/2, 0)

	local floor = Instance.new("Part")
	floor.Name = "Floor"
	floor.Size = Vector3.new(jailSize.X, 0.5, jailSize.Z)
	floor.Position = jailPosition - Vector3.new(0, jailSize.Y/2, 0)
	floor.Anchored = true
	floor.Material = Enum.Material.Concrete
	floor.Color = Color3.new(0.5, 0.5, 0.5)
	floor.Parent = jail

	local ceiling = floor:Clone()
	ceiling.Name = "Ceiling"
	ceiling.Position = jailPosition + Vector3.new(0, jailSize.Y/2, 0)
	ceiling.Parent = jail

	local barPositions = {
		{Vector3.new(-jailSize.X/2 + 1, 0, jailSize.Z/2), Vector3.new(0.2, jailSize.Y, 0.2)},
		{Vector3.new(-jailSize.X/2 + 3, 0, jailSize.Z/2), Vector3.new(0.2, jailSize.Y, 0.2)},
		{Vector3.new(jailSize.X/2 - 1, 0, jailSize.Z/2), Vector3.new(0.2, jailSize.Y, 0.2)},
		{Vector3.new(jailSize.X/2 - 3, 0, jailSize.Z/2), Vector3.new(0.2, jailSize.Y, 0.2)},

		{Vector3.new(-jailSize.X/2 + 1, 0, -jailSize.Z/2), Vector3.new(0.2, jailSize.Y, 0.2)},
		{Vector3.new(-jailSize.X/2 + 3, 0, -jailSize.Z/2), Vector3.new(0.2, jailSize.Y, 0.2)},
		{Vector3.new(jailSize.X/2 - 1, 0, -jailSize.Z/2), Vector3.new(0.2, jailSize.Y, 0.2)},
		{Vector3.new(jailSize.X/2 - 3, 0, -jailSize.Z/2), Vector3.new(0.2, jailSize.Y, 0.2)},

		{Vector3.new(-jailSize.X/2, 0, -jailSize.Z/2 + 1), Vector3.new(0.2, jailSize.Y, 0.2)},
		{Vector3.new(-jailSize.X/2, 0, -jailSize.Z/2 + 3), Vector3.new(0.2, jailSize.Y, 0.2)},
		{Vector3.new(-jailSize.X/2, 0, jailSize.Z/2 - 1), Vector3.new(0.2, jailSize.Y, 0.2)},
		{Vector3.new(-jailSize.X/2, 0, jailSize.Z/2 - 3), Vector3.new(0.2, jailSize.Y, 0.2)},

		{Vector3.new(jailSize.X/2, 0, -jailSize.Z/2 + 1), Vector3.new(0.2, jailSize.Y, 0.2)},
		{Vector3.new(jailSize.X/2, 0, -jailSize.Z/2 + 3), Vector3.new(0.2, jailSize.Y, 0.2)},
		{Vector3.new(jailSize.X/2, 0, jailSize.Z/2 - 1), Vector3.new(0.2, jailSize.Y, 0.2)},
		{Vector3.new(jailSize.X/2, 0, jailSize.Z/2 - 3), Vector3.new(0.2, jailSize.Y, 0.2)},
	}

	for i, barData in ipairs(barPositions) do
		local bar = Instance.new("Part")
		bar.Name = "Bar" .. i
		bar.Size = barData[2]
		bar.Position = jailPosition + barData[1]
		bar.Anchored = true
		bar.Material = Enum.Material.Metal
		bar.Color = Color3.new(0.2, 0.2, 0.2)
		bar.Parent = jail
	end

	humanoidRootPart.CFrame = CFrame.new(jailPosition)

	local originalPosition = humanoidRootPart.CFrame

	local function createInvisibleWall(position, size)
		local wall = Instance.new("Part")
		wall.Name = "InvisibleWall"
		wall.Size = size
		wall.Position = position
		wall.Anchored = true
		wall.CanCollide = true
		wall.Transparency = 1
		wall.Parent = jail
		return wall
	end

	createInvisibleWall(jailPosition + Vector3.new(0, 0, jailSize.Z/2 + 0.5), Vector3.new(jailSize.X, jailSize.Y, 1))
	createInvisibleWall(jailPosition + Vector3.new(0, 0, -jailSize.Z/2 - 0.5), Vector3.new(jailSize.X, jailSize.Y, 1))
	createInvisibleWall(jailPosition + Vector3.new(jailSize.X/2 + 0.5, 0, 0), Vector3.new(1, jailSize.Y, jailSize.Z))
	createInvisibleWall(jailPosition + Vector3.new(-jailSize.X/2 - 0.5, 0, 0), Vector3.new(1, jailSize.Y, jailSize.Z))
	createInvisibleWall(jailPosition + Vector3.new(0, jailSize.Y/2 + 0.5, 0), Vector3.new(jailSize.X, 1, jailSize.Z))

	print("[JailCommand] Player", targetPlayer.Name, "has been jailed for 10 seconds")

	task.delay(10, function()
		if jail and jail.Parent then
			jail:Destroy()
		end

		if targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
			targetPlayer.Character.HumanoidRootPart.CFrame = originalPosition + Vector3.new(0, 5, 0)
		end
	end)
end

return JailCommand.new()