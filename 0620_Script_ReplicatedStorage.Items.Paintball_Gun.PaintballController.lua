--[[
  Extracted from: ReplicatedStorage.Items.Paintball Gun.PaintballController
  Class: Script
  Source file: rickdev.rbxlx
]]

local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local Packages = ReplicatedStorage:WaitForChild("Packages")
local RagdollModule = require(ReplicatedStorage.Packages.Ragdoll)

local Net = require(Packages.Net)
local Debounce = require(Packages.Debounce)
local RemoteEvent = Net:RemoteEvent("Paintball/ShotPlayer")
local Colors = {45, 119, 21, 24, 23, 105, 104}
local CooldownTime = 0.5
local Damage = 2

RemoteEvent.OnServerEvent:Connect(function(player, hit, handle)
	if Debounce(player, CooldownTime) then return end
	local character = player.Character
	if not character then return end
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid then return end
	local spawnPos = handle.Position + (hit.Position - handle.Position).Unit * 8
	local direction = (hit.Position - handle.Position).Unit
	local missile = Instance.new("Part")
	missile.Position = spawnPos
	missile.Size = Vector3.new(1, 1, 1)
	missile.Velocity = direction * 150
	missile.BrickColor = BrickColor.new(Colors[math.random(1, #Colors)])
	missile.Shape = Enum.PartType.Ball
	missile.BottomSurface = Enum.SurfaceType.Smooth
	missile.TopSurface = Enum.SurfaceType.Smooth
	missile.Name = "Paintball"
	missile.Elasticity = 0.2
	missile.Reflectance = 0
	missile.Friction = 0.9
	local angularVelocity = Instance.new("BodyAngularVelocity")
	angularVelocity.MaxTorque = Vector3.new(1000, 1000, 1000)
	angularVelocity.AngularVelocity = Vector3.new(math.random(-5, 5), math.random(-5, 5), math.random(-5, 5))
	angularVelocity.Parent = missile
	local drag = Instance.new("BodyForce")
	drag.Force = -direction * missile:GetMass() * 5
	drag.Parent = missile
	local gravityForce = Instance.new("BodyForce")
	gravityForce.Force = Vector3.new(0, missile:GetMass() * workspace.Gravity, 0)
	gravityForce.Parent = missile
	local creator = Instance.new("ObjectValue")
	creator.Value = player
	creator.Name = "creator"
	creator.Parent = missile
	missile.Parent = workspace
	Debris:AddItem(missile, 8)
	missile.Touched:Connect(function(hit)
		local normal = (hit.Position - missile.Position).Unit
		local faceDirection = normal.Magnitude > 0 and normal or missile.Velocity.Unit
		local square = Instance.new("Part")
		square.Shape = Enum.PartType.Block
		square.Size = Vector3.new(1, 1, 0.1) / 2 
		square.BrickColor = missile.BrickColor
		square.Position = missile.Position
		square.CFrame = CFrame.fromMatrix(missile.Position, Vector3.new(1, 0, 0), Vector3.new(0, 1, 0), faceDirection)
		square.Anchored = true
		square.CanCollide = false
		square.Parent = workspace
		Debris:AddItem(square, 2)
		local humanoid = hit.Parent:FindFirstChildOfClass("Humanoid")
		if humanoid then
			local hitPlayer = Players:GetPlayerFromCharacter(hit.Parent)
			if hitPlayer then
				RemoteEvent:FireClient(hitPlayer, "PaintballHitted", 1)
				local creatorTag = missile:FindFirstChild("creator")
				if creatorTag then
					local newTag = creatorTag:Clone()
					newTag.Parent = humanoid
					Debris:AddItem(newTag, 2)
				end
				RagdollModule.TimedRagdoll(hit.Parent, 3)

			end
		end
		missile:Destroy()
	end)
end)
local tool = script.Parent
tool.Equipped:Connect(function()
	local player = script:FindFirstAncestorWhichIsA("Player") or Players:GetPlayerFromCharacter(script.Parent.Parent)
	if player and player:GetAttribute("Stealing") then
		tool.Parent = player.Backpack
	end
end)