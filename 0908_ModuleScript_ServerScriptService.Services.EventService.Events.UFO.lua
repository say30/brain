--[[
  Extracted from: ServerScriptService.Services.EventService.Events.UFO
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")

local Packages = ReplicatedStorage:WaitForChild("Packages")
local Net = require(Packages.Net)
local Synchronizer = require(Packages.Synchronizer)

local DataManagment = require(ServerScriptService.Services.DataManagment)
local RoadAnimalService = require(ServerScriptService.Services.RoadAnimalService)
local Animals = require(ReplicatedStorage.Datas.Animals)

local UFOEvent = {}

-- CONFIGURATION
UFOEvent.UFO_SPEED = 10
UFOEvent.TRAIT_NAME = "UFO"
UFOEvent.COUNTDOWN_EACH_UFO = {min = 2.5, max = 4} -- random interval

UFOEvent.__index = UFOEvent

function UFOEvent.new(eventService)
	local self = setmetatable({}, UFOEvent)
	self._eventService = eventService
	self._synchronizer = eventService._synchronizer
	self._ufoSynchronizer = Synchronizer:Create("UFOEvent", {IsActive = false})

	for _, player in pairs(Players:GetPlayers()) do
		self._ufoSynchronizer:AddListener(player)
	end
	Players.PlayerAdded:Connect(function(player)
		self._ufoSynchronizer:AddListener(player)
	end)
	Players.PlayerRemoving:Connect(function(player)
		self._ufoSynchronizer:RemoveListener(player)
	end)

	self._isActive = false
	self._ufoSpawnedRemote = Net:RemoteEvent("EventService/UFO/Spawned")
	self._ufoAbductionBurstRemote = Net:RemoteEvent("EventService/UFO/AbductionBurst")
	self._recentlyTargeted = {}
	self._activeUFOs = {}
	self._ufoTimers = {}

	return self
end

function UFOEvent:Start(eventEntry)
	if self._isActive then return end
	self._isActive = true

	ReplicatedStorage:SetAttribute("UFOEvent", true)
	self._ufoSpawnedRemote:FireAllClients()
	self._ufoSynchronizer:Set("IsActive", true)
	self:_startUFOLoop()
end

function UFOEvent:_startUFOLoop()
	if self._ufoTask then task.cancel(self._ufoTask) end
	self._ufoTask = task.spawn(function()
		while self._isActive do
			task.wait(math.random(UFOEvent.COUNTDOWN_EACH_UFO.min * 100, UFOEvent.COUNTDOWN_EACH_UFO.max * 100)/100)
			local targetAnimal = self:_pickTargetAnimal()
			if targetAnimal then
				self:_spawnUFOAbduction(targetAnimal)
			end
		end
	end)
end

function UFOEvent:_spawnUFOAbduction(targetAnimal)
	if not targetAnimal or not targetAnimal.PrimaryPart then return end

	local animalPosition = targetAnimal.PrimaryPart.Position
	local originalY = animalPosition.Y
	local ufoTargetPosition = animalPosition + Vector3.new(0, 50, 0)

	local ufoModel = self:_createUFO(ufoTargetPosition + Vector3.new(0, 100, -200), targetAnimal)
	if not ufoModel then return end

	local ufoPart = ufoModel
	if ufoModel:IsA("Model") then
		ufoPart = ufoModel.PrimaryPart or ufoModel:FindFirstChild("Main")
	elseif ufoModel:IsA("BasePart") then
		ufoPart = ufoModel
	end

	if not ufoPart then return end

	self._activeUFOs[targetAnimal.Name] = ufoModel
	self._recentlyTargeted[targetAnimal.Name] = workspace:GetServerTimeNow()
	self._ufoTimers[targetAnimal.Name] = tick()

	task.spawn(function()
		while ufoModel.Parent do
			task.wait(1)
			if tick() - self._ufoTimers[targetAnimal.Name] > 10 then
				self:_removeUFO(targetAnimal.Name)
				break
			end
		end
	end)

	task.spawn(function()
		local spawnDuration = 1.2
		local spawnStartPos = ufoPart.Position
		local spawnStartTime = tick()

		local spawnConnection
		spawnConnection = RunService.Heartbeat:Connect(function()
			local elapsed = tick() - spawnStartTime
			local progress = math.min(elapsed / spawnDuration, 1)
			local easedProgress = 1 - math.cos(progress * math.pi * 0.5)

			local newPos = spawnStartPos:Lerp(ufoTargetPosition, easedProgress)
			ufoPart.CFrame = CFrame.new(newPos)

			if progress >= 1 then
				spawnConnection:Disconnect()
			end
		end)

		task.wait(spawnDuration)

		ufoPart:SetAttribute("BeamState", "down")
		task.wait(0.5)

		local liftDuration = 1
		local liftStartY = targetAnimal.PrimaryPart.Position.Y
		local liftStartTime = tick()

		local liftConnection
		liftConnection = RunService.Heartbeat:Connect(function()
			local elapsed = tick() - liftStartTime
			local progress = math.min(elapsed / liftDuration, 1)
			local easedProgress = 1 - math.cos(progress * math.pi * 0.5)

			if targetAnimal and targetAnimal.PrimaryPart then
				local animalPos = targetAnimal.PrimaryPart.Position
				local targetY = liftStartY + (ufoTargetPosition.Y - 5 - liftStartY) * easedProgress
				targetAnimal:SetPrimaryPartCFrame(CFrame.new(animalPos.X, targetY, animalPos.Z))
				ufoPart.CFrame = CFrame.new(animalPos.X, ufoTargetPosition.Y, animalPos.Z)
			end

			if progress >= 1 or not targetAnimal or not targetAnimal.PrimaryPart then
				liftConnection:Disconnect()
			end
		end)

		task.wait(liftDuration)

		if targetAnimal and targetAnimal.PrimaryPart then
			self._ufoAbductionBurstRemote:FireAllClients(targetAnimal.PrimaryPart.Position)
		end
		self:_applyUFOTrait(targetAnimal)

		task.wait(2)

		local lowerDuration = 2
		local lowerStartTime = tick()
		local startY = targetAnimal.PrimaryPart.Position.Y

		local lowerConnection
		lowerConnection = RunService.Heartbeat:Connect(function()
			local elapsed = tick() - lowerStartTime
			local progress = math.min(elapsed / lowerDuration, 1)
			local easedProgress = math.sin(progress * math.pi * 0.5)

			if targetAnimal and targetAnimal.PrimaryPart then
				local animalPos = targetAnimal.PrimaryPart.Position
				local newY = startY + (originalY - startY) * easedProgress
				targetAnimal:SetPrimaryPartCFrame(CFrame.new(animalPos.X, newY, animalPos.Z))
			end

			if progress >= 1 or not targetAnimal or not targetAnimal.PrimaryPart then
				lowerConnection:Disconnect()
			end
		end)

		task.wait(lowerDuration)

		ufoPart:SetAttribute("BeamState", "off")
		task.wait(0.5)

		local exitDuration = 0.6
		local exitStartTime = tick()
		local startPos = ufoPart.Position
		local exitOffset = Vector3.new(0, 200, 800)

		local exitConnection
		exitConnection = RunService.Heartbeat:Connect(function()
			local elapsed = tick() - exitStartTime
			local progress = math.min(elapsed / exitDuration, 1)
			local easedProgress = 1 - math.cos(progress * math.pi * 0.5)

			local newPos = startPos:Lerp(startPos + exitOffset, easedProgress)
			ufoPart.CFrame = CFrame.new(newPos)

			if progress >= 1 then
				exitConnection:Disconnect()
			end
		end)

		task.wait(exitDuration)

		self:_removeUFO(targetAnimal.Name)
	end)
end

function UFOEvent:_createUFO(position, targetAnimal)
	local ufoBasePart = Instance.new("Part")
	ufoBasePart.Name = "UFO_" .. targetAnimal.Name
	ufoBasePart.Size = Vector3.new(4, 1, 4)
	ufoBasePart.Shape = Enum.PartType.Cylinder
	ufoBasePart.Material = Enum.Material.Neon
	ufoBasePart.BrickColor = BrickColor.new("Lime green")
	ufoBasePart.Anchored = true
	ufoBasePart.CanCollide = false
	ufoBasePart.CFrame = CFrame.new(position)
	CollectionService:AddTag(ufoBasePart, "GalaxyUFO")
	ufoBasePart:SetAttribute("BeamState", "off")
	ufoBasePart.Parent = workspace
	return ufoBasePart
end

function UFOEvent:_removeUFO(animalName)
	local ufoModel = self._activeUFOs[animalName]
	if ufoModel then
		ufoModel:Destroy()
		self._activeUFOs[animalName] = nil
		self._ufoTimers[animalName] = nil
	end
end

function UFOEvent:Stop(eventEntry)
	if not self._isActive then return end
	self._isActive = false

	ReplicatedStorage:SetAttribute("UFOEvent", false)
	self._ufoSynchronizer:Set("IsActive", false)

	if self._ufoTask then
		task.cancel(self._ufoTask)
		self._ufoTask = nil
	end

	for _, ufoModel in pairs(self._activeUFOs) do
		if ufoModel then ufoModel:Destroy() end
	end
	self._activeUFOs = {}
	self._ufoTimers = {}
end

function UFOEvent:_pickTargetAnimal()
	local roadAnimals = CollectionService:GetTagged("Animal")
	local movingAnimalsFolder = workspace:FindFirstChild("MovingAnimals")
	local currentTime = workspace:GetServerTimeNow()

	for animalName, lastTime in pairs(self._recentlyTargeted) do
		if (currentTime - lastTime) > 30 then 
			self._recentlyTargeted[animalName] = nil
		end
	end

	local candidates = {}
	for _, animal in ipairs(roadAnimals) do
		if animal.Parent == movingAnimalsFolder and animal.PrimaryPart and string.find(animal.Name, "RoadAnimal_") then
			if not self._recentlyTargeted[animal.Name] and not self:_hasUFOTrait(animal) and not self._activeUFOs[animal.Name] then
				table.insert(candidates, animal)
			end
		end
	end

	if #candidates == 0 then return nil end
	return candidates[math.random(1, #candidates)]
end

function UFOEvent:_hasUFOTrait(animalTemplate)
	if not animalTemplate or not animalTemplate.Parent then return false end
	local currentTraitsJson = animalTemplate:GetAttribute("Traits")
	local currentTraits = {}
	if currentTraitsJson then
		local success, decoded = pcall(HttpService.JSONDecode, HttpService, currentTraitsJson)
		if success and type(decoded) == "table" then currentTraits = decoded end
	end
	for _, trait in ipairs(currentTraits) do
		if trait == UFOEvent.TRAIT_NAME then return true end
	end
	return false
end

function UFOEvent:_applyUFOTrait(animalTemplate)
	if not animalTemplate or not animalTemplate.Parent then return end
	local currentTraitsJson = animalTemplate:GetAttribute("Traits")
	local currentTraits = {}
	if currentTraitsJson then
		local success, decoded = pcall(HttpService.JSONDecode, HttpService, currentTraitsJson)
		if success and type(decoded) == "table" then currentTraits = decoded end
	end
	for _, trait in ipairs(currentTraits) do
		if trait == UFOEvent.TRAIT_NAME then return end
	end
	table.insert(currentTraits, UFOEvent.TRAIT_NAME)
	animalTemplate:SetAttribute("Traits", HttpService:JSONEncode(currentTraits))
end

return UFOEvent