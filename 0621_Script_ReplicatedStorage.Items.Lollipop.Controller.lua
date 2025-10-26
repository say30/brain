--[[
  Extracted from: ReplicatedStorage.Items.Lollipop.Controller
  Class: Script
  Source file: rickdev.rbxlx
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RagdollModule = require(ReplicatedStorage.Packages.Ragdoll)
local Net = require(ReplicatedStorage.Packages.Net)
local CombatController = Net:RemoteEvent("CombatService/ApplyImpulse")

local tool = script.Parent
local cooldowns = {}

local attackAnimation = Instance.new("Animation")
attackAnimation.AnimationId = "rbxassetid://134240231214407"
local attackAnimationTrack

local idleAnimation = Instance.new("Animation")
idleAnimation.AnimationId = "rbxassetid://124662737459345"
local idleAnimationTrack

local slashSound = tool:WaitForChild("Slash")
local hitSound = tool:WaitForChild("Hit")

local humanoid

local function createHitbox(character)
	local root = character:FindFirstChild("HumanoidRootPart")
	if not root then return end
	local size = Vector3.new(5, 5, 5)
	local cframe = root.CFrame * CFrame.new(0, 0, -3)
	return Region3.new(cframe.Position - size/2, cframe.Position + size/2)
end

local function getTargets(character)
	local region = createHitbox(character)
	if not region then return {} end
	local parts = workspace:FindPartsInRegion3(region, character, 10)
	local t = {}
	for _, part in ipairs(parts) do
		local char = part.Parent
		local h = char:FindFirstChild("Humanoid")
		if h and h.Health > 0 and char ~= character and not t[char] then
			t[char] = h
		end
	end
	return t
end

local function applySlap(player, target, direction)
	local h = target:FindFirstChild("Humanoid")
	local root = target:FindFirstChild("HumanoidRootPart")
	if not h or not root or h.Health <= 0 then return end

	local targetPlayer = Players:GetPlayerFromCharacter(target)
	if targetPlayer then
		targetPlayer:SetAttribute("Stealing", false)
	end
	CombatController:FireClient(targetPlayer, 450, direction)
	RagdollModule.TimedRagdoll(target, 1.5)
	hitSound:Play()
end

tool.Equipped:Connect(function()
	local char = tool.Parent
	humanoid = char:FindFirstChild("Humanoid")
	if humanoid then
		idleAnimationTrack = humanoid:LoadAnimation(idleAnimation)
		idleAnimationTrack:Play()
	end
end)

tool.Unequipped:Connect(function()
	if idleAnimationTrack then
		idleAnimationTrack:Stop()
		idleAnimationTrack = nil
	end
	if attackAnimationTrack then
		attackAnimationTrack:Stop()
		attackAnimationTrack = nil
	end
	humanoid = nil
end)

tool.Activated:Connect(function()
	local char = tool.Parent
	local player = Players:GetPlayerFromCharacter(char)
	if not player or not char:FindFirstChild("HumanoidRootPart") then return end
	local last = cooldowns[player.UserId] or 0
	if os.clock() - last < 0.5 then return end
	cooldowns[player.UserId] = os.clock()

	if idleAnimationTrack then
		idleAnimationTrack:Stop()
	end

	if humanoid then
		attackAnimationTrack = humanoid:LoadAnimation(attackAnimation)
		attackAnimationTrack:Play()
		slashSound:Play()
		attackAnimationTrack.Stopped:Connect(function()
			if humanoid and idleAnimationTrack then
				idleAnimationTrack:Play()
			end
		end)
	end

	local dir = char.HumanoidRootPart.CFrame.LookVector
	for target in pairs(getTargets(char)) do
		applySlap(player, target, dir)
	end
end)

tool.Equipped:Connect(function()
	local player = script:FindFirstAncestorWhichIsA("Player") or Players:GetPlayerFromCharacter(script.Parent.Parent)
	if player and player:GetAttribute("Stealing") then
		tool.Parent = player.Backpack
	end
end)