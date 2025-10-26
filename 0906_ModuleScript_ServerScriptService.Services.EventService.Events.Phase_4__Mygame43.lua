--[[
  Extracted from: ServerScriptService.Services.EventService.Events.Phase 4: Mygame43
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

local MODEL = game:GetService("ReplicatedStorage").Models.Events["Phase 4: Mygame43"].mygame43

local LightningEvent = {}
LightningEvent.__index = LightningEvent

function LightningEvent.new(eventService)
	local self = setmetatable({}, LightningEvent)
	self._eventService = eventService
	self._synchronizer = eventService._synchronizer
	self._lightningSynchronizer = Synchronizer:Create("LightningEvent", {
		IsActive = false
	})

	for _, player in pairs(Players:GetPlayers()) do
		self._lightningSynchronizer:AddListener(player)
	end

	Players.PlayerAdded:Connect(function(player)
		self._lightningSynchronizer:AddListener(player)
	end)

	Players.PlayerRemoving:Connect(function(player)
		self._lightningSynchronizer:RemoveListener(player)
	end)

	self._isActive = false

	self._createLightningOrbRemote = Net:RemoteEvent("EventService/Phase 4: Mygame43/CreateLightningOrb")

	self._recentlyTargeted = {}
	self._activeOrbs = {}
	self._orbCounter = 0

	self._bossSpawnCFrame = CFrame.new(0, 50, 0)

	return self
end

function LightningEvent:Start(eventEntry)
	if self._isActive then
		return
	end

	local MODEL2 = MODEL:Clone()
	MODEL2.Parent = workspace
	CollectionService:AddTag(MODEL2, "Mygame43")

	self._isActive = true
	ReplicatedStorage:SetAttribute("LightningEvent", true)

	self._lightningSynchronizer:Set("IsActive", true)
	self._lightningBoss = MODEL2

	self:_startLightningLoop()
end

function LightningEvent:_startLightningLoop()
	if self._lightningTask then
		task.cancel(self._lightningTask)
	end

	self._lightningTask = task.spawn(function()
		task.wait(7.7)

		while self._isActive do
			self:_createOrbBarrage()

			task.wait(math.random(5, 8))
		end
	end)
end

function LightningEvent:_createOrbBarrage()
	local targetAnimals = self:_pickTargetAnimals(4)

	if #targetAnimals == 0 then
		return
	end

	for orbPosition = 1, 4 do
		local targetAnimal = targetAnimals[math.random(1, #targetAnimals)]
		if targetAnimal and targetAnimal.PrimaryPart then
			self:_fireOrbAtAnimal(orbPosition, targetAnimal)
		end
	end
end

function LightningEvent:_fireOrbAtAnimal(orbPosition, targetAnimal)
	if not targetAnimal or not targetAnimal.PrimaryPart then
		return
	end

	self._orbCounter = self._orbCounter + 1
	local orbId = self._orbCounter

	local animalPosition = targetAnimal.PrimaryPart.Position

	-- Mark animal as recently targeted
	self._recentlyTargeted[targetAnimal.Name] = workspace:GetServerTimeNow()

	-- Calculate flight time (similar to client script bezier curve timing)
	local flightTime = math.random(2, 4) -- Random flight time

	-- Fire the orb creation event to all clients (matching client script parameters)
	self._createLightningOrbRemote:FireAllClients(
		orbId, -- p50: Seed for random generation
		orbPosition, -- p51: Which orb position (1-4) 
		animalPosition, -- u52: Target position
		flightTime, -- u53: Flight duration
		true -- u54: Hit target (brainrot effect - set to true to apply trait)
	)

	task.spawn(function()
		task.wait(flightTime + 0.5) -- Small delay after impact
		self:_applyLightningTrait(targetAnimal)
	end)
end

function LightningEvent:Stop(eventEntry)
	if not self._isActive then
		return
	end

	self._isActive = false
	ReplicatedStorage:SetAttribute("LightningEvent", false)

	self._lightningSynchronizer:Set("IsActive", false)

	if self._lightningTask then
		task.cancel(self._lightningTask)
		self._lightningTask = nil
	end

	if self._lightningBoss then
		self._lightningBoss:Destroy()
		self._lightningBoss = nil
	end

	self._activeOrbs = {}
end

function LightningEvent:_pickTargetAnimals(maxCount)
	local roadAnimals = CollectionService:GetTagged("Animal")
	local movingAnimalsFolder = workspace:FindFirstChild("MovingAnimals")
	local currentTime = workspace:GetServerTimeNow()

	for animalName, lastTime in pairs(self._recentlyTargeted) do
		if (currentTime - lastTime) > 45 then
			self._recentlyTargeted[animalName] = nil
		end
	end

	local candidates = {}
	for _, animal in ipairs(roadAnimals) do
		if animal.Parent == movingAnimalsFolder and animal.PrimaryPart and string.find(animal.Name, "RoadAnimal_") then
			if not self._recentlyTargeted[animal.Name] and not self:_hasLightningTrait(animal) then
				table.insert(candidates, animal)
			end
		end
	end

	-- Select multiple animals for lightning barrage
	local selectedAnimals = {}
	local numToSelect = math.min(maxCount, #candidates)

	for i = 1, numToSelect do
		if #candidates > 0 then
			local randomIndex = math.random(1, #candidates)
			local selectedAnimal = candidates[randomIndex]
			table.insert(selectedAnimals, selectedAnimal)
			table.remove(candidates, randomIndex)
		end
	end

	return selectedAnimals
end

function LightningEvent:_hasLightningTrait(animalTemplate)
	if not animalTemplate or not animalTemplate.Parent then
		return false
	end

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
		if trait == "Lightning" then
			return true
		end
	end

	return false
end

function LightningEvent:_applyLightningTrait(animalTemplate)
	if not animalTemplate or not animalTemplate.Parent then
		return
	end

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
		if trait == "Lightning" then
			return
		end
	end

	table.insert(currentTraits, "Lightning")
	animalTemplate:SetAttribute("Traits", HttpService:JSONEncode(currentTraits))
end

return LightningEvent