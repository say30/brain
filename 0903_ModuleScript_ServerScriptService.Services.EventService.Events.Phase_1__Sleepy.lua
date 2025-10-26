--[[
  Extracted from: ServerScriptService.Services.EventService.Events.Phase 1: Sleepy
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local Packages = ReplicatedStorage:WaitForChild("Packages")
local Net = require(Packages.Net)
local Synchronizer = require(Packages.Synchronizer)

local DataManagment = require(ServerScriptService.Services.DataManagment)
local RoadAnimalService = require(ServerScriptService.Services.RoadAnimalService)
local Animals = require(ReplicatedStorage.Datas.Animals)

local SleepyEvent = {}
SleepyEvent.__index = SleepyEvent

function SleepyEvent.new(eventService)
	local self = setmetatable({}, SleepyEvent)
	self._eventService = eventService
	self._synchronizer = eventService._synchronizer
	self._sleepySynchronizer = Synchronizer:Create("SleepyEvent", {
		IsActive = false
	})

	for _, player in pairs(Players:GetPlayers()) do
		self._sleepySynchronizer:AddListener(player)
	end

	Players.PlayerAdded:Connect(function(player)
		self._sleepySynchronizer:AddListener(player)
	end)

	Players.PlayerRemoving:Connect(function(player)
		self._sleepySynchronizer:RemoveListener(player)
	end)

	self._isActive = false

	self._sleepVFXRemote = Net:RemoteEvent("EventService/Phase 1: Sleepy/PlaySleepVFX")
	self._recentlyTargeted = {}

	return self
end

function SleepyEvent:Start(eventEntry)
	if self._isActive then
		return
	end

	self._isActive = true
	ReplicatedStorage:SetAttribute("Phase1SleepyEvent", true)

	self._sleepySynchronizer:Set("IsActive", true)

	self:_startSleepLoop()
end

function SleepyEvent:_startSleepLoop()
	if self._sleepTask then
		task.cancel(self._sleepTask)
	end

	self._sleepTask = task.spawn(function()
		while self._isActive do
			task.wait(math.random(3, 4.5))

			local targetAnimal = self:_pickTargetAnimal()
			if targetAnimal then
				local currentTime = workspace:GetServerTimeNow()
				self._sleepVFXRemote:FireAllClients(targetAnimal.Name, currentTime)
				self._recentlyTargeted[targetAnimal.Name] = currentTime

				task.delay(0.05, function()
					self:_applySleepyTrait(targetAnimal)
				end)
			end
		end
	end)
end

function SleepyEvent:Stop(eventEntry)
	if not self._isActive then
		return
	end

	self._isActive = false

	ReplicatedStorage:SetAttribute("Phase1SleepyEvent", false)
	self._sleepySynchronizer:Set("IsActive", false)

	if self._sleepTask then
		task.cancel(self._sleepTask)
		self._sleepTask = nil
	end

	self._recentlyTargeted = {}
end

function SleepyEvent:_pickTargetAnimal()
	local CollectionService = game:GetService("CollectionService")
	local roadAnimals = CollectionService:GetTagged("Animal")
	local movingAnimalsFolder = workspace:FindFirstChild("MovingAnimals")
	local currentTime = workspace:GetServerTimeNow()

	for animalName, lastTime in pairs(self._recentlyTargeted) do
		if (currentTime - lastTime) > 15 then
			self._recentlyTargeted[animalName] = nil
		end
	end

	local candidates = {}
	for _, animal in ipairs(roadAnimals) do
		if animal.Parent == movingAnimalsFolder and animal.PrimaryPart and string.find(animal.Name, "RoadAnimal_") then
			if not self._recentlyTargeted[animal.Name] and not self:_hasSleepyTrait(animal) then
				table.insert(candidates, animal)
			end
		end
	end

	if #candidates == 0 then 
		return nil 
	end

	return candidates[math.random(1, #candidates)]
end

function SleepyEvent:_hasSleepyTrait(animalTemplate)
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
		if trait == "Sleepy" then
			return true
		end
	end

	return false
end

function SleepyEvent:_applySleepyTrait(animalTemplate)
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
		if trait == "Sleepy" then
			return
		end
	end

	table.insert(currentTraits, "Sleepy")
	animalTemplate:SetAttribute("Traits", HttpService:JSONEncode(currentTraits))
end

function SleepyEvent:GetSleepyAnimalsCount()
	local CollectionService = game:GetService("CollectionService")
	local roadAnimals = CollectionService:GetTagged("Animal")
	local movingAnimalsFolder = workspace:FindFirstChild("MovingAnimals")
	local count = 0

	for _, animal in ipairs(roadAnimals) do
		if animal.Parent == movingAnimalsFolder and self:_hasSleepyTrait(animal) then
			count = count + 1
		end
	end

	return count
end

return SleepyEvent