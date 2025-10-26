--[[
  Extracted from: ReplicatedStorage.Items.Tung Bat.Controller
  Class: Script
  Source file: rickdev.rbxlx
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RagdollModule = require(ReplicatedStorage.Packages.Ragdoll)
local Net = require(ReplicatedStorage.Packages.Net)
local CombatController = Net:RemoteEvent("CombatService/ApplyImpulse")

local Tool = script.Parent
local Cooldowns = {}

local AttackAnimation = Instance.new("Animation")
AttackAnimation.AnimationId = "rbxassetid://125104776080776"
local AttackAnimationTrack

local IdleAnimation = Instance.new("Animation")
IdleAnimation.AnimationId = "rbxassetid://124662737459345"
local IdleAnimationTrack

local Humanoid

local function CreateHitbox(Character)
	local Root = Character:FindFirstChild("HumanoidRootPart")
	if not Root then return end
	local Size = Vector3.new(12, 12, 12)
	local CFramePos = Root.CFrame * CFrame.new(0, 0, -3)
	return Region3.new(CFramePos.Position - Size/2, CFramePos.Position + Size/2)
end

local function GetTargets(Character)
	local Region = CreateHitbox(Character)
	if not Region then return {} end
	local Parts = workspace:FindPartsInRegion3(Region, Character, 10)
	local Targets = {}
	for _, Part in ipairs(Parts) do
		local Char = Part.Parent
		local H = Char:FindFirstChild("Humanoid")
		if H and H.Health > 0 and Char ~= Character and not Targets[Char] then
			Targets[Char] = H
		end
	end
	return Targets
end

local function ApplySlap(Player, Target, Direction)
	local H = Target:FindFirstChild("Humanoid")
	local Root = Target:FindFirstChild("HumanoidRootPart")
	if not H or not Root or H.Health <= 0 then return false end

	H:TakeDamage(0)

	local TargetPlayer = Players:GetPlayerFromCharacter(Target)
	if TargetPlayer then
		TargetPlayer:SetAttribute("Stealing", false)
	end
	CombatController:FireClient(TargetPlayer, 450, Direction)
	RagdollModule.TimedRagdoll(Target, 1.5)
	return true
end

Tool.Equipped:Connect(function()
	local Char = Tool.Parent
	Humanoid = Char:FindFirstChild("Humanoid")
	if Humanoid then
		IdleAnimationTrack = Humanoid:LoadAnimation(IdleAnimation)
	end
end)

Tool.Unequipped:Connect(function()
	if IdleAnimationTrack then
		IdleAnimationTrack:Stop()
		IdleAnimationTrack = nil
	end
	if AttackAnimationTrack then
		AttackAnimationTrack:Stop()
		AttackAnimationTrack = nil
	end
	Humanoid = nil
end)

Tool.Activated:Connect(function()
	local Char = Tool.Parent
	local Player = Players:GetPlayerFromCharacter(Char)
	if not Player or not Char:FindFirstChild("HumanoidRootPart") then return end
	local Last = Cooldowns[Player.UserId] or 0
	if os.clock() - Last < 0.5 then return end
	Cooldowns[Player.UserId] = os.clock()

	if IdleAnimationTrack then
		IdleAnimationTrack:Stop()
	end

	if Humanoid then
		AttackAnimationTrack = Humanoid:LoadAnimation(AttackAnimation)
		AttackAnimationTrack:Play()
		AttackAnimationTrack.Stopped:Connect(function()
			if Humanoid and IdleAnimationTrack then
				IdleAnimationTrack:Play()
			end
		end)
	end

	local Dir = Char.HumanoidRootPart.CFrame.LookVector
	local HitSomething = false

	for Target in pairs(GetTargets(Char)) do
		if ApplySlap(Player, Target, Dir) then
			HitSomething = true
		end
	end

	if HitSomething then
		if Tool:FindFirstChild("Hit") then
			Tool.Hit:Play()
		end
	else
		if Tool:FindFirstChild("Slash") then
			Tool.Slash:Play()
		end
	end
end)

Tool.Equipped:Connect(function()
	local Player = script:FindFirstAncestorWhichIsA("Player") or Players:GetPlayerFromCharacter(script.Parent.Parent)
	if Player and Player:GetAttribute("Stealing") then
		Tool.Parent = Player.Backpack
	end
end)
