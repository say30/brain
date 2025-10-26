--[[
  Extracted from: ReplicatedStorage.Items.Jelly Gun.CandyLauncherController
  Class: Script
  Source file: rickdev.rbxlx
]]

local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage:WaitForChild("Packages")
local Net = require(Packages.Net)
local CandyLauncher = Net:RemoteEvent("CandlyLauncher/Launch")
local RagdollModule = require(ReplicatedStorage.Packages.Ragdoll)

local function applyJellyTransform(player, target)
	local h = target:FindFirstChild("Humanoid")
	local root = target:FindFirstChild("HumanoidRootPart")
	if not h or not root or h.Health <= 0 then return end
	if player:GetAttribute("JellyTransform") then return end

	local jellyModel = ServerStorage:FindFirstChild("Jelly")
	if not jellyModel then return end
	local jellyClone = jellyModel:Clone()

	local jellyPrimaryPart = jellyClone:FindFirstChildWhichIsA("BasePart") or jellyClone
	jellyPrimaryPart.CFrame = root.CFrame
	jellyClone.Parent = target

	local originalParts = {}
	for _, part in pairs(target:GetDescendants()) do
		if part:IsA("BasePart") then
			originalParts[part] = { Transparency = part.Transparency, CanCollide = part.CanCollide }
			part.CanCollide = false
		end
	end
	for _, part in pairs(jellyClone:GetDescendants()) do
		if part:IsA("BasePart") then
			part.Anchored = false
			part.CanCollide = (part == jellyPrimaryPart)
		end
	end

	local weld = Instance.new("WeldConstraint")
	weld.Part0 = root
	weld.Part1 = jellyPrimaryPart
	weld.Parent = root

	player:SetAttribute("JellyTransform", true)
	local TargetPlayer = Players:GetPlayerFromCharacter(target)
	RagdollModule.TimedRagdoll(target,5)
	CandyLauncher:FireClient(TargetPlayer,"TurnIntoJelly")

	task.delay(10, function()
		jellyClone:Destroy()
		for part, props in pairs(originalParts) do
			if part.Parent then
				part.Transparency = props.Transparency
				part.CanCollide = props.CanCollide
			end
		end
		player:SetAttribute("JellyTransform", nil)
	end)
end

CandyLauncher.OnServerEvent:Connect(function(player, hit, handle)
	local character = player.Character
	if not character then return end
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	if not humanoidRootPart then return end

	local targetCharacter = hit and hit.Parent
	local targetPlayer = targetCharacter and Players:GetPlayerFromCharacter(targetCharacter)

	if targetPlayer and targetPlayer ~= player then
		applyJellyTransform(targetPlayer, targetCharacter)
	end
end)

local tool = script.Parent
tool.Equipped:Connect(function()
	local player = script:FindFirstAncestorWhichIsA("Player") or Players:GetPlayerFromCharacter(script.Parent.Parent)
	if player and player:GetAttribute("Stealing") then
		tool.Parent = player.Backpack
	end
end)