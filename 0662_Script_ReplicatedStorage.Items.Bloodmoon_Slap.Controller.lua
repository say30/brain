--[[
  Extracted from: ReplicatedStorage.Items.Bloodmoon Slap.Controller
  Class: Script
  Source file: rickdev.rbxlx
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RagdollModule = require(ReplicatedStorage.Packages.Ragdoll)
local SlapData = require(ReplicatedStorage.Datas.Items)[script.Parent.Name]
local Net = require(ReplicatedStorage.Packages.Net)
local CombatController = Net:RemoteEvent("CombatService/ApplyImpulse")
local tool = script.Parent
local cooldowns = {}

local animation = Instance.new("Animation")
animation.AnimationId = "rbxassetid://127346329932757"
local animationTrack

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
	local params = OverlapParams.new()
	params.FilterDescendantsInstances = {character}
	params.MaxParts = 10
	local parts = workspace:GetPartBoundsInBox(region.CFrame, region.Size, params)
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

	local success, err = pcall(function()
		local targetPlayer = Players:GetPlayerFromCharacter(target)
		if targetPlayer then
			targetPlayer:SetAttribute("Stealing", false)
		end
		CombatController:FireClient(targetPlayer, SlapData.Force, direction)
		RagdollModule.TimedRagdoll(target, SlapData.RagdollDuration)
	end)
	if not success then
		warn("Error applying slap: " .. err)
	end
end

tool.Activated:Connect(function()
	local char = tool.Parent
	local player = Players:GetPlayerFromCharacter(char)
	if player:GetAttribute("Stealing") == true then
		return
	end
	if not player or not char:FindFirstChild("HumanoidRootPart") then return end
	local last = cooldowns[player.UserId] or 0
	if os.clock() - last < SlapData.Cooldown then return end
	cooldowns[player.UserId] = os.clock()

	local humanoid = char:FindFirstChild("Humanoid")
	if humanoid and not animationTrack then
		animationTrack = humanoid:LoadAnimation(animation)
	end
	if animationTrack then
		animationTrack:Play()
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

Players.PlayerRemoving:Connect(function(player)
	cooldowns[player.UserId] = nil
end)