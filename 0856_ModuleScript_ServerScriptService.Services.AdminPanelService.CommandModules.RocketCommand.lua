--[[
  Extracted from: ServerScriptService.Services.AdminPanelService.CommandModules.RocketCommand
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local Players = game:GetService("Players")
local Debris = game:GetService("Debris")
local RunService = game:GetService("RunService")

local Ragdoll = require(game:GetService("ReplicatedStorage").Packages.Ragdoll)

local RocketCommand = {}
RocketCommand.__index = RocketCommand

function RocketCommand.new()
	local self = setmetatable({}, RocketCommand)
	return self
end

function RocketCommand:Execute(executor: Player, targetPlayer: Player)
	if not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
		return
	end

	local character = targetPlayer.Character
	local humanoidRootPart = character.HumanoidRootPart
	local humanoid = character:FindFirstChild("Humanoid")

	if not humanoid then return end

	local flame, flameConnection = self:_createFireEffect(character)
	self:_launchPlayer(character, flame, flameConnection)
end

function RocketCommand:_createFireEffect(character)
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	if not humanoidRootPart then return end

	local flame = Instance.new("Part")
	flame.Name = "Flame"
	flame.Size = Vector3.new(1, 4, 1)
	flame.Shape = Enum.PartType.Cylinder
	flame.Material = Enum.Material.Neon
	flame.Color = Color3.new(1, 0.5, 0)
	flame.CanCollide = false
	flame.Anchored = true
	flame.Parent = workspace

	local fire = Instance.new("Fire")
	fire.Size = 8
	fire.Heat = 15
	fire.Parent = flame

	local smoke = Instance.new("Smoke")
	smoke.Size = 5
	smoke.Opacity = 0.7
	smoke.RiseVelocity = 10
	smoke.Parent = flame

	local connection
	connection = RunService.Heartbeat:Connect(function()
		if humanoidRootPart and humanoidRootPart.Parent then
			flame.CFrame = humanoidRootPart.CFrame * CFrame.new(0, -3, 0) * CFrame.Angles(0, 0, math.rad(90))
		else
			connection:Disconnect()
			if flame and flame.Parent then
				flame:Destroy()
			end
		end
	end)

	Debris:AddItem(flame, 6)

	return flame, connection
end

function RocketCommand:_launchPlayer(character, flame, flameConnection)
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	local humanoid = character:FindFirstChild("Humanoid")

	if not humanoidRootPart or not humanoid then return end

	humanoid.PlatformStand = true

	local bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
	bodyVelocity.Velocity = Vector3.new(0, 80, 0)
	bodyVelocity.Parent = humanoidRootPart

	task.delay(1, function()
		if humanoidRootPart and humanoidRootPart.Parent then
			local explosion = Instance.new("Explosion")
			explosion.Position = humanoidRootPart.Position
			explosion.BlastRadius = 6
			explosion.BlastPressure = 0
			explosion.Parent = workspace

			-- Ragdoll.TimedRagdoll(1.5)
		end

		if flameConnection then
			flameConnection:Disconnect()
		end
		if flame and flame.Parent then
			flame:Destroy()
		end

		if bodyVelocity and bodyVelocity.Parent then
			bodyVelocity:Destroy()
		end
		if humanoid and humanoid.Parent then
			humanoid:ChangeState(Enum.HumanoidStateType.Ragdoll)
			humanoid.PlatformStand = false
		end
	end)
end

return RocketCommand.new()
