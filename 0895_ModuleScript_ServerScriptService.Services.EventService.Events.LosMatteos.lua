--[[
  Extracted from: ServerScriptService.Services.EventService.Events.LosMatteos
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local Packages = ReplicatedStorage:WaitForChild("Packages")
local Net = require(Packages.Net)
local Synchronizer = require(Packages.Synchronizer)

local DataManagment = require(ServerScriptService.Services.DataManagment)
local RoadAnimalService = require(ServerScriptService.Services.RoadAnimalService)
local Animals = require(ReplicatedStorage.Datas.Animals)

local LosMatteosEvent = {}
LosMatteosEvent.__index = LosMatteosEvent

function LosMatteosEvent.new(eventService)
	local self = setmetatable({}, LosMatteosEvent)
	self._eventService = eventService
	self._synchronizer = eventService._synchronizer
	self._losMatteosSynchronizer = Synchronizer:Create("LosMatteosEvent", {
		IsActive = false
	})

	for _, player in pairs(Players:GetPlayers()) do
		self._losMatteosSynchronizer:AddListener(player)
	end

	Players.PlayerAdded:Connect(function(player)
		self._losMatteosSynchronizer:AddListener(player)
	end)

	Players.PlayerRemoving:Connect(function(player)
		self._losMatteosSynchronizer:RemoveListener(player)
	end)

	self._isActive = false
	self._eventStartTime = nil

	self._createLightningBoltRemote = Net:RemoteEvent("EventService/Los Matteos/CreateLightningBolt")

	self._recentlyTargeted = {}
	self._activeLightningStrikes = {}
	self._treeLocation = nil

	return self
end

function LosMatteosEvent:Start(eventEntry)
	if self._isActive then return end

	self._isActive = true
	self._eventStartTime = workspace:GetServerTimeNow()
	
	ReplicatedStorage:SetAttribute("LosMatteosEvent", true)
	self._losMatteosSynchronizer:Set("IsActive", true)

	self:_selectTreeLocation()
	self:_startLosMatteosSequence()
end

function LosMatteosEvent:_selectTreeLocation()
	local treePossibleLocations = workspace:FindFirstChild("Events")
	if treePossibleLocations then
		treePossibleLocations = treePossibleLocations:FindFirstChild("Custom")
		if treePossibleLocations then
			treePossibleLocations = treePossibleLocations:FindFirstChild("TreePossibleLocations")
		end
	end

	if not treePossibleLocations then
		warn("[LosMatteosEvent] TreePossibleLocations not found")
		self._treeLocation = Vector3.new(0, 0, 0)
		return
	end

	local spawnParts = {}
	for _, part in ipairs(treePossibleLocations:GetChildren()) do
		if part.Name == "Spawn" and part:IsA("BasePart") then
			table.insert(spawnParts, part)
		end
	end

	if #spawnParts > 0 then
		local chosenPart = spawnParts[math.random(1, #spawnParts)]
		self._treeLocation = chosenPart.Position
	else
		self._treeLocation = Vector3.new(0, 0, 0)
	end
end

function LosMatteosEvent:_startLosMatteosSequence()
	if self._losMatteosTask then
		task.cancel(self._losMatteosTask)
	end

	self._losMatteosTask = task.spawn(function()
		local eventStartTime = self._eventStartTime

		task.wait(math.max(0, eventStartTime + 3 - workspace:GetServerTimeNow()))
		ReplicatedStorage:SetAttribute("LosMatteosEventNightTime", true)

		task.wait(math.max(0, eventStartTime + 8 - workspace:GetServerTimeNow()))
		self:_startLightningLoop()

		while self._isActive do
			task.wait(1)
		end
	end)
end

function LosMatteosEvent:_startLightningLoop()
	if self._lightningTask then
		task.cancel(self._lightningTask)
	end

	self._lightningTask = task.spawn(function()
		while self._isActive do
			task.wait(math.random(2, 6))

			local shouldTargetAnimal = math.random(1, 100) <= 70
			if shouldTargetAnimal then
				local targetAnimal = self:_pickTargetAnimal()
				if targetAnimal then
					self:_createLightningStrike(targetAnimal.PrimaryPart.Position, true, targetAnimal)
				else
					self:_createRandomLightningStrike()
				end
			else
				self:_createRandomLightningStrike()
			end
		end
	end)
end

function LosMatteosEvent:_createLightningStrike(targetPosition, hitAnimal, targetAnimal)
	if targetAnimal and targetAnimal.PrimaryPart then
		local primary = targetAnimal.PrimaryPart
		targetPosition = Vector3.new(
			primary.Position.X,
			primary.Position.Y + (primary.Size.Y / 2),
			primary.Position.Z
		)
	end

	-- ✅ FIX: Raycast down from sky to ground so the strike hits surface
	local rayOrigin = targetPosition + Vector3.new(0, 200, 0)
	local rayDirection = Vector3.new(0, -500, 0)
	local raycastParams = RaycastParams.new()
	raycastParams.FilterDescendantsInstances = {}
	raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
	local result = Workspace:Raycast(rayOrigin, rayDirection, raycastParams)
	if result then
		targetPosition = result.Position
	else
		targetPosition = Vector3.new(targetPosition.X, 0, targetPosition.Z)
	end

	local lightningSeed = math.random(1, 1000000)
	local skyPosition = targetPosition + Vector3.new(
		math.random(-5, 5),
		math.random(80, 120),
		math.random(-5, 5)
	)

	self._createLightningBoltRemote:FireAllClients(lightningSeed, skyPosition, targetPosition, hitAnimal)

	if hitAnimal and targetAnimal then
		local animalId = targetAnimal.Name
		self._recentlyTargeted[animalId] = workspace:GetServerTimeNow()

		task.delay(0.5, function()
			if targetAnimal and targetAnimal.Parent then
				self:_applyMatteoHatTrait(targetAnimal)
			end
		end)
	end
end

function LosMatteosEvent:_createRandomLightningStrike()
	local losMatteosArea = workspace:FindFirstChild("Events")
	if losMatteosArea then
		losMatteosArea = losMatteosArea:FindFirstChild("Los Matteos")
		if losMatteosArea then
			losMatteosArea = losMatteosArea:FindFirstChild("Areas")
		end
	end

	local randomPosition
	if losMatteosArea then
		local areaParts = losMatteosArea:GetChildren()
		if #areaParts > 0 then
			local randomPart = areaParts[math.random(1, #areaParts)]
			local partPosition = randomPart.Position
			local partSize = randomPart.Size
			randomPosition = Vector3.new(
				partPosition.X + math.random(-partSize.X/2, partSize.X/2),
				partPosition.Y + 100, -- start above ground, raycast will fix
				partPosition.Z + math.random(-partSize.Z/2, partSize.Z/2)
			)
		else
			randomPosition = Vector3.new(math.random(-100, 100), 100, math.random(-100, 100))
		end
	else
		randomPosition = self._treeLocation + Vector3.new(
			math.random(-50, 50),
			100,
			math.random(-50, 50)
		)
	end

	self:_createLightningStrike(randomPosition, false, nil)
end

function LosMatteosEvent:Stop(eventEntry)
	if not self._isActive then return end

	self._isActive = false
	print("[LosMatteosEvent] Stopping Los Matteos event")

	ReplicatedStorage:SetAttribute("LosMatteosEvent", false)
	ReplicatedStorage:SetAttribute("LosMatteosEventNightTime", false)

	self._losMatteosSynchronizer:Set("IsActive", false)

	if self._losMatteosTask then
		task.cancel(self._losMatteosTask)
		self._losMatteosTask = nil
	end

	if self._lightningTask then
		task.cancel(self._lightningTask)
		self._lightningTask = nil
	end

	print("[LosMatteosEvent] Los Matteos event stopped")
end

function LosMatteosEvent:_pickTargetAnimal()
	local roadAnimals = CollectionService:GetTagged("Animal")
	local movingAnimalsFolder = workspace:FindFirstChild("MovingAnimals")
	local currentTime = workspace:GetServerTimeNow()

	for animalId, lastTime in pairs(self._recentlyTargeted) do
		if (currentTime - lastTime) > 12 then
			self._recentlyTargeted[animalId] = nil
		end
	end

	local candidates = {}
	for _, animal in ipairs(roadAnimals) do
		if animal.Parent == movingAnimalsFolder and animal.PrimaryPart and string.find(animal.Name, "RoadAnimal_") then
			local animalId = animal.Name
			if not self._recentlyTargeted[animalId] and not self:_hasMatteoHatTrait(animal) then
				table.insert(candidates, animal)
			end
		end
	end

	if #candidates == 0 then return nil end
	return candidates[math.random(1, #candidates)]
end

function LosMatteosEvent:_hasMatteoHatTrait(animalTemplate)
	if not animalTemplate or not animalTemplate.Parent then return false end

	local currentTraitsJson = animalTemplate:GetAttribute("Traits")
	local currentTraits = {}
	if currentTraitsJson then
		local success, decoded = pcall(function()
			return HttpService:JSONDecode(currentTraitsJson)
		end)
		if success and type(decoded) == "table" then
			currentTraits = decoded
		end
	end

	for _, trait in ipairs(currentTraits) do
		if trait == "Matteo Hat" then
			return true
		end
	end

	return false
end

function LosMatteosEvent:_applyMatteoHatTrait(animalTemplate)
	if not animalTemplate or not animalTemplate.Parent then return end

	local currentTraitsJson = animalTemplate:GetAttribute("Traits")
	local currentTraits = {}
	if currentTraitsJson then
		local success, decoded = pcall(function()
			return HttpService:JSONDecode(currentTraitsJson)
		end)
		if success and type(decoded) == "table" then
			currentTraits = decoded
		end
	end

	for _, trait in ipairs(currentTraits) do
		if trait == "Matteo Hat" then return end
	end

	table.insert(currentTraits, "Matteo Hat")
	animalTemplate:SetAttribute("Traits", HttpService:JSONEncode(currentTraits))
end

return LosMatteosEvent