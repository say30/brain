--[[
  Extracted from: ReplicatedStorage.Items.Gummy Stick.BloodController
  Class: Script
  Source file: rickdev.rbxlx
]]

local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

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

local function applyGummyTransform(player, target)
	local h = target:FindFirstChild("Humanoid")
	local root = target:FindFirstChild("HumanoidRootPart")
	if not h or not root or h.Health <= 0 then return end
	if player:GetAttribute("GummyTransform") then return end

	local gummyModel = ServerStorage:FindFirstChild("Rainbow Gummy Bears")
	if not gummyModel then return end

	local gummyMeshes = gummyModel:GetChildren()
	if #gummyMeshes == 0 then return end
	local randomGummy = gummyMeshes[math.random(1, #gummyMeshes)]:Clone()

	local sphere = Instance.new("Part")
	sphere.Shape = Enum.PartType.Ball
	sphere.Size = Vector3.new(5, 5, 5)
	sphere.Massless = false
	sphere.CanCollide = true
	sphere.Transparency = 1
	sphere.Position = root.Position
	sphere.Material = Enum.Material.SmoothPlastic
	sphere.Friction = 0.4
	sphere.Parent = workspace

	local gummyPrimaryPart = randomGummy:FindFirstChildWhichIsA("BasePart") or randomGummy
	gummyPrimaryPart.CFrame = root.CFrame
	randomGummy.Parent = target

	local weld = Instance.new("WeldConstraint")
	weld.Part0 = sphere
	weld.Part1 = gummyPrimaryPart
	weld.Parent = sphere

	local originalParts = {}
	for _, part in pairs(target:GetDescendants()) do
		if part:IsA("BasePart") then
			originalParts[part] = { Transparency = part.Transparency, CanCollide = part.CanCollide }
			part.CanCollide = false
		end
	end
	for _, part in pairs(randomGummy:GetDescendants()) do
		if part:IsA("BasePart") then
			part.Anchored = false
			part.CanCollide = (part == gummyPrimaryPart)
		end
	end

	root.Anchored = true
	task.wait()
	root.Anchored = false
	root.CFrame = sphere.CFrame
	local weld2 = Instance.new("WeldConstraint")
	weld2.Part0 = root
	weld2.Part1 = sphere
	weld2.Parent = sphere

	player:SetAttribute("GummyTransform", true)
	h.WalkSpeed = 0
	h.JumpPower = 0
	h.PlatformStand = true

	local direction = (root.CFrame.LookVector + Vector3.new(0, 0.5, 0)).Unit
	local bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.Velocity = direction * 20
	bodyVelocity.MaxForce = Vector3.new(math.huge, 5000, math.huge)
	bodyVelocity.Parent = sphere

	local bodyAngularVelocity = Instance.new("BodyAngularVelocity")
	bodyAngularVelocity.AngularVelocity = Vector3.new(0, 0, 3)
	bodyAngularVelocity.MaxTorque = Vector3.new(0, 0, 3000)
	bodyAngularVelocity.Parent = sphere

	task.delay(3, function()
		bodyVelocity:Destroy()
		bodyAngularVelocity:Destroy()
	end)

	task.delay(6, function()
		sphere:Destroy()
		randomGummy:Destroy()
		for part, props in pairs(originalParts) do
			if part.Parent then
				part.Transparency = props.Transparency
				part.CanCollide = props.CanCollide
			end
		end
		player:SetAttribute("GummyTransform", nil)
		if h then
			h.WalkSpeed = 16
			h.JumpPower = 50
			h.PlatformStand = false
		end
	end)
end

tool.Equipped:Connect(function()
	local char = tool.Parent
	humanoid = char:FindFirstChild("Humanoid")
	if humanoid then
		idleAnimationTrack = humanoid:LoadAnimation(idleAnimation)
		idleAnimationTrack:Play()
	end
	local player = Players:GetPlayerFromCharacter(char)
	if player and player:GetAttribute("Stealing") then
		tool.Parent = player.Backpack
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
	if os.clock() - last < 0.7 then return end
	cooldowns[player.UserId] = os.clock()

	if idleAnimationTrack then
		idleAnimationTrack:Stop()
	end

	if humanoid then
		attackAnimationTrack = humanoid:LoadAnimation(attackAnimation)
		attackAnimationTrack:Play()
		attackAnimationTrack.Stopped:Connect(function()
			if humanoid and idleAnimationTrack then
				idleAnimationTrack:Play()
			end
		end)
	end

	for target in pairs(getTargets(char)) do
		local targetPlayer = Players:GetPlayerFromCharacter(target)
		if targetPlayer then
			applyGummyTransform(player, target)
		end
	end
end)