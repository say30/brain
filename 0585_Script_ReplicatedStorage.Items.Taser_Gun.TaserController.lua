--[[
  Extracted from: ReplicatedStorage.Items.Taser Gun.TaserController
  Class: Script
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Packages = ReplicatedStorage:WaitForChild("Packages")
local Net = require(Packages.Net)
local Debounce = require(Packages.Debounce)
local RagdollModule = require(Packages.Ragdoll)
local TASER_COOLDOWN = 5
local TASER_RANGE = 50
local taserRemote = Net:RemoteEvent("TaserGun/ShotPlayer")

local function createBeam(startPos, endPos)
	local beamPartStart = Instance.new("Part")
	beamPartStart.Anchored = true
	beamPartStart.CanCollide = false
	beamPartStart.Transparency = 1
	beamPartStart.Size = Vector3.new(0.1, 0.1, 0.1)
	beamPartStart.Position = startPos
	beamPartStart.Parent = workspace

	local beamPartEnd = Instance.new("Part")
	beamPartEnd.Anchored = true
	beamPartEnd.CanCollide = false
	beamPartEnd.Transparency = 1
	beamPartEnd.Size = Vector3.new(0.1, 0.1, 0.1)
	beamPartEnd.Position = endPos
	beamPartEnd.Parent = workspace

	local attachmentStart = Instance.new("Attachment")
	attachmentStart.Position = Vector3.new(0, 0, 0)
	attachmentStart.Parent = beamPartStart

	local attachmentEnd = Instance.new("Attachment")
	attachmentEnd.Position = Vector3.new(0, 0, 0)
	attachmentEnd.Parent = beamPartEnd

	local beam = Instance.new("Beam")
	beam.Attachment0 = attachmentStart
	beam.Attachment1 = attachmentEnd
	beam.Color = ColorSequence.new(Color3.fromRGB(0, 255, 255))
	beam.Width0 = 0.5
	beam.Width1 = 0.5
	beam.Transparency = NumberSequence.new(0)
	beam.Parent = workspace

	game.Debris:AddItem(beamPartStart, 1)
	game.Debris:AddItem(beamPartEnd, 1)
end

local function isValidTarget(player, targetModel, taserPosition)
	if not targetModel or not targetModel:IsA("Model") then
		return false
	end
	local humanoid = targetModel:FindFirstChildOfClass("Humanoid")
	if not humanoid or humanoid.Health <= 0 then
		return false
	end
	local targetPlayer = Players:GetPlayerFromCharacter(targetModel)
	if not targetPlayer then
		return false
	end
	local rootPart = targetModel:FindFirstChild("HumanoidRootPart")
	if not rootPart then
		return false
	end
	local distance = (taserPosition - rootPart.Position).Magnitude
	if distance > TASER_RANGE then
		return false
	end
	return true, targetPlayer, humanoid, rootPart
end

taserRemote.OnServerEvent:Connect(function(player, targetModel)
	if not player or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
		return
	end
	if Debounce(("ServerTaser/%s"):format(player.Name), TASER_COOLDOWN) then
		return
	end
	local taserPosition = player.Character.HumanoidRootPart.Position
	local isValid, targetPlayer, targetHumanoid, targetRootPart = isValidTarget(player, targetModel, taserPosition)
	if not isValid then
		return
	end
	if not targetPlayer.Character then
		return
	end
	createBeam(taserPosition, targetRootPart.Position)
	RagdollModule.TimedRagdoll(targetPlayer.Character, 3)
end)
local tool = script.Parent
tool.Equipped:Connect(function()
	local player = script:FindFirstAncestorWhichIsA("Player") or Players:GetPlayerFromCharacter(script.Parent.Parent)
	if player and player:GetAttribute("Stealing") then
		tool.Parent = player.Backpack
	end
end)