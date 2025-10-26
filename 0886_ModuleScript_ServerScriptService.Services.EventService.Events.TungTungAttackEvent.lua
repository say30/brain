--[[
  Extracted from: ServerScriptService.Services.EventService.Events.TungTungAttackEvent
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local CollectionService = game:GetService("CollectionService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local Packages = ReplicatedStorage:WaitForChild("Packages")
local Net = require(Packages.Net)
local SimplePath = require(Packages.SimplePath)

local TungTungAttackEvent = {}
TungTungAttackEvent.__index = TungTungAttackEvent

local SCAN_RADIUS = 25
local TRAIT_NAME = "Zombie"
local COOLDOWN_HIT = 2
local MOVE_INTERVAL = {4, 7} 
local BABY_COUNT = math.random(20, 30)

function TungTungAttackEvent.new(eventService)
	local self = setmetatable({}, TungTungAttackEvent)

	self._eventService = eventService
	self._babies = {}
	self._activePaths = {}
	self._recentlyHit = {}
	self._moveConnections = {}

	return self
end

function TungTungAttackEvent:Start()
	local eventsFolder = workspace:FindFirstChild("Events")
	if not eventsFolder then
		warn("[TungTungAttackEvent] Events folder not found in workspace")
		return
	end

	local eventFolder = eventsFolder:FindFirstChild("Tung Tung Attack")
	if not eventFolder then
		warn("[TungTungAttackEvent] Tung Tung Attack event folder not found")
		return
	end

	self._eventFolder = eventFolder
	self._babies = {}
	self._activePaths = {}
	self._recentlyHit = {}
	self._moveConnections = {}

	local wanderPoints = {}
	for _, child in ipairs(eventFolder:GetChildren()) do
		if child:IsA("BasePart") then
			table.insert(wanderPoints, child)
		end
	end

	if #wanderPoints == 0 then
		warn("[TungTungAttackEvent] No wander points found")
		return
	end

	local currentTime = workspace:GetServerTimeNow()
	local activeEvents = self._eventService:GetActiveEvents()
	local eventData = activeEvents["Tung Tung Attack"]
	if not eventData then
		warn("[TungTungAttackEvent] Event data not found")
		return
	end
	local eventStartTime = eventData.startTime
	local caveDelay = eventStartTime + 10 - currentTime

	task.spawn(function()
		task.wait(math.max(0, caveDelay))

		local babiesFolder = Instance.new("Folder")
		babiesFolder.Name = "BabyTungTungs"
		babiesFolder.Parent = workspace

		for i = 1, math.min(BABY_COUNT, #wanderPoints) do
			local wanderPoint = wanderPoints[i]
			self:_spawnBaby(wanderPoint, babiesFolder, wanderPoints)
		end

		self:_startScanning()
	end)
end

function TungTungAttackEvent:_spawnBaby(wanderPoint, babiesFolder, allWanderPoints)
	local babyModel = self:_getBabyModel()
	if not babyModel then
		warn("[TungTungAttackEvent] Failed to get baby model")
		return
	end

	for _, part in babyModel:GetDescendants() do
		if part:IsA("BasePart") then
			part.CanCollide = false
			part.CanQuery = false
			part.CanTouch = false
			part.Massless = true
			part.Anchored = false
		end
	end

	babyModel.Parent = babiesFolder

	local humanoidRootPart = babyModel:FindFirstChild("HumanoidRootPart")
	if humanoidRootPart then
		local spawnPosition = wanderPoint.Position + Vector3.new(0, wanderPoint.Size.Y/2 + humanoidRootPart.Size.Y/2, 0)
		humanoidRootPart.CFrame = CFrame.new(spawnPosition)
	end

	self:_setupBabyAnimations(babyModel)

	CollectionService:AddTag(babyModel, "BabyTungTung")
	table.insert(self._babies, babyModel)

	self:_setupBabyMovement(babyModel, allWanderPoints)
end

function TungTungAttackEvent:_getBabyModel()
	local babyTungTung = script:FindFirstChild("BabyTungTung")
	if babyTungTung then
		return babyTungTung:Clone()
	else
		warn("[TungTungAttackEvent] BabyTungTung model not found in script")
		return nil
	end
end

function TungTungAttackEvent:_scaleBabyModel(model, scale)
	for _, part in model:GetDescendants() do
		if part:IsA("BasePart") then
			part.Size = part.Size * scale
		end
	end
end

function TungTungAttackEvent:_setupBabyAnimations(babyModel)
	local humanoid = babyModel:FindFirstChild("Humanoid")
	if not humanoid then
		warn("[TungTungAttackEvent] No Humanoid found in baby model")
		return
	end

	local animator = humanoid:FindFirstChild("Animator")
	if not animator then
		animator = Instance.new("Animator")
		animator.Parent = humanoid
	end

	local walkAnim = babyModel:FindFirstChild("BabyTungWalk")
	local idleAnim = babyModel:FindFirstChild("BabyTungIdle")

	if not walkAnim or not idleAnim then
		local animationsFolder = ReplicatedStorage:FindFirstChild("Animations")
		if animationsFolder then
			local animalsFolder = animationsFolder:FindFirstChild("Animals")
			if animalsFolder then
				local tungAnimFolder = animalsFolder:FindFirstChild("Tung Tung Tung Sahur")
				if tungAnimFolder then
					walkAnim = walkAnim or tungAnimFolder:FindFirstChild("Walk")
					idleAnim = idleAnim or tungAnimFolder:FindFirstChild("Idle")
				end
			end
		end
	end

	if walkAnim and idleAnim then
		local walkTrack = animator:LoadAnimation(walkAnim)
		local idleTrack = animator:LoadAnimation(idleAnim)

		walkTrack.Looped = true
		walkTrack.Priority = Enum.AnimationPriority.Movement
		idleTrack.Looped = true
		idleTrack.Priority = Enum.AnimationPriority.Idle

		self._babyAnimations = self._babyAnimations or {}
		self._babyAnimations[babyModel] = {
			walkTrack = walkTrack,
			idleTrack = idleTrack,
			isWalking = false
		}

		idleTrack:Play()

		local runConnection = humanoid.Running:Connect(function(speed)
			local animData = self._babyAnimations[babyModel]
			if not animData then return end

			if speed > 0 then
				if not animData.isWalking then
					animData.isWalking = true
					animData.idleTrack:Stop()
					animData.walkTrack:Play()
					animData.walkTrack:AdjustSpeed(1.5)
				end
			else
				if animData.isWalking then
					animData.isWalking = false
					animData.walkTrack:Stop()
					animData.idleTrack:Play()
				end
			end
		end)

		self._animationConnections = self._animationConnections or {}
		self._animationConnections[babyModel] = runConnection
	else
		warn("[TungTungAttackEvent] Could not find walk or idle animations")
	end
end

function TungTungAttackEvent:_setupBabyMovement(babyModel, wanderPoints)
	local humanoid = babyModel:FindFirstChild("Humanoid")
	local humanoidRootPart = babyModel:FindFirstChild("HumanoidRootPart")

	if not humanoid or not humanoidRootPart then
		warn("[TungTungAttackEvent] Baby model missing Humanoid or HumanoidRootPart")
		return
	end

	local pathConfig = {
		WaypointSpacing = 4,
		AgentRadius = 2,
		AgentHeight = 5,
		AgentCanJump = true,
		AgentCanClimb = false,
		Costs = {
			Water = 20,
			DangerousLava = math.huge
		}
	}

	local path = SimplePath.new(babyModel, pathConfig)
	self._activePaths[babyModel] = path

	local function moveToRandomPoint()
		if not babyModel.Parent then
			return
		end

		local targetPoint = wanderPoints[math.random(1, #wanderPoints)]
		local targetPosition = targetPoint.Position

		path:Run(targetPosition)
	end

	moveToRandomPoint()

	local moveConnection
	moveConnection = path.Reached:Connect(function()
		local waitTime = math.random(MOVE_INTERVAL[1], MOVE_INTERVAL[2])
		task.wait(waitTime)
		moveToRandomPoint()
	end)

	self._moveConnections[babyModel] = moveConnection
end

function TungTungAttackEvent:_startScanning()
	local function scanForAnimals()
		for _, baby in ipairs(self._babies) do
			local humanoidRootPart = baby:FindFirstChild("HumanoidRootPart")
			if baby.Parent and humanoidRootPart then
				local babiesPosition = humanoidRootPart.Position

				local animalsInRange = {}
				for _, obj in ipairs(workspace:GetPartBoundsInBox(humanoidRootPart.CFrame, Vector3.new(SCAN_RADIUS, SCAN_RADIUS, SCAN_RADIUS))) do
					local model = obj.Parent
					if model and CollectionService:HasTag(model, "Animal") then
						table.insert(animalsInRange, model)
					end
				end

				for _, animal in ipairs(animalsInRange) do
					if animal:GetAttribute("Index") and not self._recentlyHit[animal] then
						self:_applyZombieTrait(animal)
						self._recentlyHit[animal] = tick()
					end
				end
			end
		end

		for animal, hitTime in pairs(self._recentlyHit) do
			if tick() - hitTime > COOLDOWN_HIT then
				self._recentlyHit[animal] = nil
			end
		end
	end

	self._scanConnection = RunService.Heartbeat:Connect(scanForAnimals)
end

function TungTungAttackEvent:_applyZombieTrait(animal)
	local currentTraits = animal:GetAttribute("Traits")
	local traitsTable = {}

	if currentTraits then
		local success, decoded = pcall(HttpService.JSONDecode, HttpService, currentTraits)
		if success and type(decoded) == "table" then
			traitsTable = decoded
		end
	end

	local hasZombie = false
	for _, trait in ipairs(traitsTable) do
		if trait == TRAIT_NAME then
			hasZombie = true
			break
		end
	end

	if not hasZombie then
		table.insert(traitsTable, TRAIT_NAME)
		animal:SetAttribute("Traits", HttpService:JSONEncode(traitsTable))
	end
end

function TungTungAttackEvent:Stop()
	if self._scanConnection then
		self._scanConnection:Disconnect()
		self._scanConnection = nil
	end

	if self._animationConnections then
		for babyModel, connection in pairs(self._animationConnections) do
			if connection then
				connection:Disconnect()
			end
		end
		self._animationConnections = {}
	end

	if self._babyAnimations then
		self._babyAnimations = {}
	end

	for baby, connection in pairs(self._moveConnections) do
		if connection then
			connection:Disconnect()
		end
	end
	self._moveConnections = {}

	for baby, path in pairs(self._activePaths) do
		if path and path.Stop then
			local success, err = pcall(function()
				if path.Status ~= Enum.PathStatus.Idle then
					path:Stop()
				end
			end)
			if not success then
			end
		end
	end
	self._activePaths = {}

	for _, baby in ipairs(self._babies) do
		if baby and baby.Parent then
			baby:Destroy()
		end
	end
	self._babies = {}
	self._recentlyHit = {}

	local babiesFolder = workspace:FindFirstChild("BabyTungTungs")
	if babiesFolder then
		babiesFolder:Destroy()
	end
end

return TungTungAttackEvent