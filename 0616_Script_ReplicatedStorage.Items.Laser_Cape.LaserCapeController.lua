--[[
  Extracted from: ReplicatedStorage.Items.Laser Cape.LaserCapeController
  Class: Script
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage:WaitForChild("Packages")
local Net = require(Packages.Net)
local Players = game:GetService("Players")
local Debris = game:GetService("Debris")
local RagdollModule = require(Packages.Ragdoll)
local Net = require(ReplicatedStorage.Packages.Net)
local CombatController = Net:RemoteEvent("CombatService/ApplyImpulse")

local function FindCharacterAncestor(Parent)
	if Parent and Parent ~= workspace then
		local humanoid = Parent:FindFirstChild("Humanoid")
		if humanoid then
			return Parent, humanoid
		else
			return FindCharacterAncestor(Parent.Parent)
		end
	end
	return nil
end

local function CreateBeam(startPos, endPos)
	local beam = Instance.new("Part")
	beam.Name = "LaserBeam"
	beam.BrickColor = BrickColor.new("Really red")
	beam.Material = Enum.Material.Neon
	beam.Anchored = true
	beam.CanCollide = false
	beam.Transparency = 0.2
	local distance = (endPos - startPos).Magnitude
	beam.Size = Vector3.new(0.2, 0.2, distance)
	beam.CFrame = CFrame.new(startPos, endPos) * CFrame.new(0, 0, -distance / 2)
	beam.Parent = workspace
	Debris:AddItem(beam, 0.5)
	return beam
end

local function TagHumanoid(humanoid, player)
	local Creator_Tag = Instance.new("ObjectValue")
	Creator_Tag.Name = "creator"
	Creator_Tag.Value = player
	Debris:AddItem(Creator_Tag, 2)
	Creator_Tag.Parent = humanoid
end

Net:RemoteEvent("SuperCape/LaserEyes").OnServerEvent:Connect(function(player, hitCFrame, targetPart)
	if not player.Character or not hitCFrame then return end
	local tool = player.Character:FindFirstChildWhichIsA("Tool")
	if not tool or tool.Name ~= "Laser Cape" or not tool.Enabled then return end
	tool.Enabled = false

	local head = player.Character:FindFirstChild("Head")
	if not head then
		tool.Enabled = true
		return
	end

	local root = player.Character:FindFirstChild("HumanoidRootPart")
	if not root then
		tool.Enabled = true
		return
	end

	local upperTorso = player.Character:FindFirstChild("UpperTorso")
	local neck = upperTorso and upperTorso:FindFirstChild("Neck")

	local targetPos = hitCFrame.Position
	local targetCharacter, targetHumanoid = nil, nil

	if targetPart then
		targetCharacter, targetHumanoid = FindCharacterAncestor(targetPart)
		if targetCharacter then
			local targetHead = targetCharacter:FindFirstChild("Head")
			if targetHead then
				targetPos = targetHead.Position
			end
		end
	end

	local startPos = head.Position
	local direction = (targetPos - startPos).Unit
	local lookVector = root.CFrame.LookVector
	local dot = lookVector:Dot(direction)
	if dot < 0.3 then
		direction = lookVector
	end

	

	local endPos = startPos + direction * 100
	
	CreateBeam(startPos, endPos)

	if targetCharacter and targetHumanoid and targetCharacter ~= player.Character then
		local hasForceField = targetCharacter:FindFirstChildWhichIsA("ForceField") ~= nil
		if not hasForceField then
			TagHumanoid(targetHumanoid, player)
			local root = targetCharacter:FindFirstChild("HumanoidRootPart") or targetCharacter:FindFirstChild("Torso")
			if root then

			end
			local targetPlayer = Players:GetPlayerFromCharacter(targetCharacter)
			if targetPlayer then
				targetPlayer:SetAttribute("Stealing", false)
			end
			CombatController:FireClient(targetPlayer, 900, direction)

			RagdollModule.TimedRagdoll(targetCharacter, 2)
		end
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