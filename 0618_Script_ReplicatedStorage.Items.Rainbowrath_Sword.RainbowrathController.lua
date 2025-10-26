--[[
  Extracted from: ReplicatedStorage.Items.Rainbowrath Sword.RainbowrathController
  Class: Script
  Source file: rickdev.rbxlx
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RagdollModule = require(ReplicatedStorage.Packages.Ragdoll)

local tool = script.Parent
local cooldowns = {}

local animation = Instance.new("Animation")
animation.AnimationId = "rbxassetid://105955050323450"
local animationTrack

local function createHitbox(character)
	local root = character:FindFirstChild("HumanoidRootPart")
	if not root then return end
	local size = Vector3.new(5,5,5)
	local cframe = root.CFrame * CFrame.new(0,0,-3)
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

local function applySlap(player: Player, target, direction)
	local h = target:FindFirstChild("Humanoid")
	local root = target:FindFirstChild("HumanoidRootPart")
	if not h or not root or h.Health <= 0 then return end

	h:TakeDamage(0)
	local force = 900 * 0.10
	local upwardForce = Vector3.new(0, 10, 0) 
	local bv = Instance.new("BodyVelocity")
	bv.Velocity = direction.Unit * force + upwardForce 
	bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
	bv.Parent = root
	local targetPlayer = Players:GetPlayerFromCharacter(target)
	if targetPlayer then
		targetPlayer:SetAttribute("Stealing", false)
	end
	game.Debris:AddItem(bv, 0.2)
	RagdollModule.TimedRagdoll(target, 5)
end

tool.Activated:Connect(function()
	local char = tool.Parent
	local player = game:GetService("Players"):GetPlayerFromCharacter(char)
	if not player or not char:FindFirstChild("HumanoidRootPart") then return end
	local last = cooldowns[player.UserId] or 0
	if os.clock() - last < 2 then return end
	cooldowns[player.UserId] = os.clock()

	local humanoid = char:FindFirstChild("Humanoid")
	if humanoid then
		animationTrack = humanoid:LoadAnimation(animation)
		animationTrack:Play()
	end

	local dir = char.HumanoidRootPart.CFrame.LookVector

	local bv = Instance.new("BodyVelocity")
	bv.Velocity = dir * 100
	bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
	bv.Parent = char.HumanoidRootPart
	game.Debris:AddItem(bv, 0.2)

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
