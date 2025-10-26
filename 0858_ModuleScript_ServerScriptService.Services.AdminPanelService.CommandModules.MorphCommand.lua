--[[
  Extracted from: ServerScriptService.Services.AdminPanelService.CommandModules.MorphCommand
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local MorphCommand = {}
MorphCommand.__index = MorphCommand
local activeMorphs = {}

local BRAINROT_GODS = {
	["Tigroligre Frutonni"] = -3.903,
	["Orcalero Orcala"] = -3.135,
	["Tralalero Tralala"] = -3.023,
	["Odin Din Din Dun"] = -3.811,
	["Cocofanto Elefanto"] = -2.471,
	["Gattatino Neonino"] = -2.922,
	["Matteo"] = -1.561,
	["Girafa Celestre"] = -5.349,
	["Trenostruzzo Turbo 3000"] = -2.615,
	["Statutino Libertino"] = -3.958,
}

local BRAINROT_GODS_ROTATION = {
	["Orcalero Orcala"] = math.rad(180),
	["Tigroligre Frutonni"] = 0,
	["Tralalero Tralala"] = math.rad(180),
	["Odin Din Din Dun"] = math.rad(180),
	["Cocofanto Elefanto"] = math.rad(180),
	["Gattatino Neonino"] = 0,
	["Matteo"] = 0,
	["Girafa Celestre"] = 0,
	["Trenostruzzo Turbo 3000"] = 0,
	["Statutino Libertino"] = 0,
}

local function getRandomBrainrotGod()
	local keys = {}
	for k in pairs(BRAINROT_GODS) do
		table.insert(keys, k)
	end
	local randomKey = keys[math.random(1, #keys)]
	return randomKey
end

local function weldAllParts(parent, root)
	for _, v in ipairs(parent:GetChildren()) do
		if v:IsA("BasePart") and v ~= root then
			local w = Instance.new("Weld")
			w.Part0 = root
			w.Part1 = v
			w.C0 = root.CFrame:Inverse() * v.CFrame
			w.Parent = root
		end
	end
end

local function morphIntoBrainrotGod(player, brainrotName)
	local character = player.Character
	if not character then return false end
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid then return false end
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	if not rootPart then return false end
	local modelTemplate = ReplicatedStorage.Models.Animals:FindFirstChild(brainrotName)
	if not modelTemplate then return false end

	local modelClone = modelTemplate:Clone()
	modelClone.Name = player.Name .. "_" .. brainrotName
	modelClone.Parent = Workspace

	local fakeRoot = modelClone:FindFirstChild("FakeRootPart")
	local primary = fakeRoot or modelClone:FindFirstChildWhichIsA("BasePart")
	if not primary then
		primary = Instance.new("Part")
		primary.Name = "RootProxy"
		primary.Anchored = false
		primary.CanCollide = false
		primary.Transparency = 1
		primary.Size = Vector3.new(1, 1, 1)
		primary.Parent = modelClone
	end
	modelClone.PrimaryPart = primary

	weldAllParts(modelClone, primary)

	local targetX, targetZ = rootPart.Position.X, rootPart.Position.Z
	local lookAngle = select(2, rootPart.CFrame:ToEulerAnglesYXZ())
	local rayOrigin = Vector3.new(targetX, rootPart.Position.Y + 10, targetZ)
	local rayDirection = Vector3.new(0, -50000, 0)
	local raycastResult = workspace:Raycast(rayOrigin, rayDirection)
	local groundY = raycastResult and raycastResult.Position.Y or 0

	local newY = groundY + primary.Size.Y / 2
	local rotationOffset = BRAINROT_GODS_ROTATION[brainrotName] or 0
	primary.CFrame = CFrame.new(targetX, newY, targetZ) * CFrame.Angles(0, lookAngle + rotationOffset, 0)

	local lowestY = math.huge
	for _, part in ipairs(modelClone:GetDescendants()) do
		if part:IsA("BasePart") and part.Transparency < 0.9 then
			local partBottomY = part.Position.Y - part.Size.Y/2
			if partBottomY < lowestY then
				lowestY = partBottomY
			end
		end
	end
	local adjustY = groundY - lowestY
	primary.CFrame = primary.CFrame + Vector3.new(0, adjustY, 0)

	local yOffset = BRAINROT_GODS[brainrotName] or 0
	primary.CFrame = primary.CFrame + Vector3.new(0, yOffset, 0)

	local weld = Instance.new("Weld")
	weld.Part0 = rootPart
	weld.Part1 = primary
	weld.C0 = rootPart.CFrame:Inverse() * primary.CFrame
	weld.Parent = primary

	local animController = modelClone:FindFirstChildOfClass("AnimationController")
	local idleTrack, walkTrack
	if animController then
		local folder = ReplicatedStorage.Animations.Animals:FindFirstChild(brainrotName)
		if folder then
			local idleAnim = folder:FindFirstChild("Idle")
			local walkAnim = folder:FindFirstChild("Walk")
			if idleAnim and walkAnim then
				idleTrack = animController:LoadAnimation(idleAnim)
				walkTrack = animController:LoadAnimation(walkAnim)
			end
		end
	end

	local originalTransparencies = {}
	for _, obj in ipairs(character:GetDescendants()) do
		if obj:IsA("BasePart") and obj.Name ~= "HumanoidRootPart" then
			originalTransparencies[obj] = obj.Transparency
			obj.Transparency = 1
		end
	end
	character:SetAttribute("IsBrainrotGod", true)
	character:SetAttribute("BrainrotType", brainrotName)
	character:SetAttribute("MorphStartTime", tick())

	activeMorphs[player.UserId] = {
		brainrotName = brainrotName,
		startTime = tick(),
		duration = 60,
		modelClone = modelClone,
		originalTransparencies = originalTransparencies,
		weld = weld,
		animController = animController,
		idleTrack = idleTrack,
		walkTrack = walkTrack,
		currentTrack = nil
	}

	local function updateAnimation()
		local data = activeMorphs[player.UserId]
		if not data or not data.animController then return end
		local moving = rootPart.Velocity.Magnitude > 0.5
		if moving then
			if data.currentTrack ~= data.walkTrack then
				if data.currentTrack then data.currentTrack:Stop() end
				data.walkTrack:Play()
				data.currentTrack = data.walkTrack
			end
		else
			if data.currentTrack ~= data.idleTrack then
				if data.currentTrack then data.currentTrack:Stop() end
				data.idleTrack:Play()
				data.currentTrack = data.idleTrack
			end
		end
	end

	local animConn = RunService.Heartbeat:Connect(updateAnimation)
	activeMorphs[player.UserId].animationConn = animConn

	local deathConn = humanoid.Died:Connect(function()
		MorphCommand:_cleanupMorph(player)
	end)
	activeMorphs[player.UserId].deathConnection = deathConn

	return true
end

function MorphCommand:_cleanupMorph(player)
	local data = activeMorphs[player.UserId]
	if not data then return end
	local character = player.Character
	if character and character.Parent then
		self:_restoreOriginalAppearance(character)
	end
	if data.animationConn then
		data.animationConn:Disconnect()
	end
	if data.currentTrack then
		data.currentTrack:Stop()
	end
	if data.modelClone then
		data.modelClone:Destroy()
	end
	if data.weld then
		data.weld:Destroy()
	end
	if data.deathConnection then
		data.deathConnection:Disconnect()
	end
	activeMorphs[player.UserId] = nil
	if character then
		character:SetAttribute("IsBrainrotGod", nil)
		character:SetAttribute("BrainrotType", nil)
		character:SetAttribute("MorphStartTime", nil)
	end
end

function MorphCommand:_restoreOriginalAppearance(character)
	local player = Players:GetPlayerFromCharacter(character)
	if not player then return end
	local data = activeMorphs[player.UserId]
	if data and data.originalTransparencies then
		for obj, oldT in pairs(data.originalTransparencies) do
			if obj and obj.Parent then
				obj.Transparency = oldT
			end
		end
	end
end

function MorphCommand.new()
	return setmetatable({}, MorphCommand)
end

function MorphCommand:Execute(executor: Player, targetPlayer: Player)
	if not targetPlayer or not targetPlayer.Character then return end
	local brainrotName = getRandomBrainrotGod()
	if not morphIntoBrainrotGod(targetPlayer, brainrotName) then return end
	task.delay(60, function()
		self:_cleanupMorph(targetPlayer)
	end)
end

return MorphCommand.new()