--[[
  Extracted from: ReplicatedStorage.Items.Laser Gun.LaserController
  Class: Script
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage:WaitForChild("Packages")
local Net = require(Packages.Net)
local Players = game:GetService("Players")
local Debris = game:GetService("Debris")
local Net = require(ReplicatedStorage.Packages.Net)
local CombatController = Net:RemoteEvent("CombatService/ApplyImpulse")

local Speed = 100
local Duration = 9999999
local NozzleOffset = Vector3.new(0, 0.4, -1.1)

local RagdollModule = require(Packages.Ragdoll)

local function FindCharacterAncestor(Parent)
	if Parent and Parent ~= game:GetService("Workspace") then
		local humanoid = Parent:FindFirstChild("Humanoid")
		if humanoid then
			return Parent, humanoid
		else
			return FindCharacterAncestor(Parent.Parent)
		end
	end
	return nil
end

local function SelectionBoxify(Object)
	local SelectionBox = Instance.new("SelectionBox")
	SelectionBox.Adornee = Object
	SelectionBox.Color = BrickColor.new("Neon orange")
	SelectionBox.Parent = Object
	return SelectionBox
end

local function Light(Object)
	local PointLight = Instance.new("PointLight")
	PointLight.Range = 12
	PointLight.Color = Color3.new(1, 0.5, 0)
	PointLight.Parent = Object
end

local function TagHumanoid(humanoid, player)
	local Creator_Tag = Instance.new("ObjectValue")
	Creator_Tag.Name = "creator"
	Creator_Tag.Value = player
	Debris:AddItem(Creator_Tag, 2)
	Creator_Tag.Parent = humanoid
end

Net:RemoteEvent("LaserGun/ShotPlayer").OnServerEvent:Connect(function(player, hitPosition, handle)
	if not player.Character or not hitPosition or not handle then
		return
	end
	local tool = player.Character:FindFirstChildWhichIsA("Tool")
	if not tool or tool.Name ~= "Laser Gun" then
		return
	end
	if not tool.Enabled then
		return
	end
	tool.Enabled = false
	local handleCFrame = handle.CFrame
	local firingPoint = handleCFrame.p + handleCFrame:vectorToWorldSpace(NozzleOffset)
	local shotCFrame = CFrame.new(firingPoint, hitPosition.p)
	local laserShot = Instance.new("Part")
	laserShot.Name = "Effect"
	laserShot.BrickColor = BrickColor.new("Really red")
	laserShot.Material = Enum.Material.Neon
	laserShot.Shape = Enum.PartType.Cylinder
	laserShot.Size = Vector3.new(0.3, 2, 0.3)
	laserShot.CanCollide = false
	laserShot.Locked = true
	laserShot.CFrame = shotCFrame + (shotCFrame.lookVector * (laserShot.Size.Y / 2))
	SelectionBoxify(laserShot)
	Light(laserShot)
	local bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.Velocity = shotCFrame.lookVector * Speed
	bodyVelocity.Parent = laserShot
	laserShot.Touched:Connect(function(hit)
		if not hit or not hit.Parent then
			return
		end
		local character, humanoid = FindCharacterAncestor(hit)
		if character and humanoid and character ~= player.Character then
			local forceFieldExists = false
			for _, v in pairs(character:GetChildren()) do
				if v:IsA("ForceField") then
					forceFieldExists = true
					break
				end
			end
			if not forceFieldExists then
				TagHumanoid(humanoid, player)
				local root = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso")
				local direction = (hit.Position - firingPoint).Unit

				local targetPlayer = Players:GetPlayerFromCharacter(character)
				if targetPlayer then
					targetPlayer:SetAttribute("Stealing", false)
				end
				CombatController:FireClient(targetPlayer, 1500, direction)

				RagdollModule.TimedRagdoll(character, 5)

			end
			if laserShot and laserShot.Parent then
				laserShot:Destroy()
			end
		end
	end)
	Debris:AddItem(laserShot, Duration)
	laserShot.Parent = game:GetService("Workspace")
	task.wait(0)
	if handle:FindFirstChild("Fire") then
		handle.Fire:Play()
	end
	task.wait(0)
	if handle:FindFirstChild("Reload") then
		handle.Reload:Play()
	end
	tool.Enabled = true
end)
local tool = script.Parent
tool.Equipped:Connect(function()
	local player = script:FindFirstAncestorWhichIsA("Player") or Players:GetPlayerFromCharacter(script.Parent.Parent)
	if player and player:GetAttribute("Stealing") then
		tool.Parent = player.Backpack
	end
end)