--[[
  Extracted from: ServerScriptService.Services.EventService.Events.FourthOfJulyEvent
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

local DataManagment = require(ServerScriptService.Services.DataManagment)
local RoadAnimalService = require(ServerScriptService.Services.RoadAnimalService)
local Animals = require(ReplicatedStorage.Datas.Animals)

local FourthOfJulyEvent = {}
FourthOfJulyEvent.__index = FourthOfJulyEvent

function FourthOfJulyEvent.new(eventService)
	local self = setmetatable({}, FourthOfJulyEvent)
	self._eventService = eventService

	self._isActive = false

	self._spawnEffectRemote = Net:RemoteEvent("EventService/4th of July/SpawnEffect")
	self._createFireworkRemote = Net:RemoteEvent("EventService/4th of July/CreateFirework")
	self._explodeTraitEffectRemote = Net:RemoteEvent("EventService/4th of July/ExplodeTraitEffect")

	self._recentlyTargeted = {}
	self._fireworkTask = nil

	return self
end

function FourthOfJulyEvent:Start(eventEntry)
	if self._isActive then
		return
	end

	self._isActive = true

	local spawnTime = workspace:GetServerTimeNow() + 1

	for _, player in pairs(Players:GetPlayers()) do
		self._spawnEffectRemote:FireClient(player, spawnTime)
	end

	self:_startFireworkLoop()

	task.wait(0.5)

	self:_spawnUnclitoSamito()
end

function FourthOfJulyEvent:Stop(eventEntry)
	if not self._isActive then
		return
	end

	self._isActive = false

	if self._fireworkTask then
		task.cancel(self._fireworkTask)
		self._fireworkTask = nil
	end
end

function FourthOfJulyEvent:_spawnUnclitoSamito()
	local success, result = pcall(function()
		local animalData = Animals["Statutino Libertino"]
		if not animalData then
			warn("[FourthOfJulyEvent] Statutino Libertino not found in Animals data")
			return
		end

		_G.RoadAnimalService.Spawner:SpawnSpecificAnimal("Unclito Samito", nil, nil)
	end)

	if not success then
		warn("[FourthOfJulyEvent] Failed to spawn Statutino Libertino on the road:", result)
	end
end

function FourthOfJulyEvent:_startFireworkLoop()
	if self._fireworkTask then
		task.cancel(self._fireworkTask)
	end

	self._fireworkTask = task.spawn(function()
		while self._isActive do
			task.wait(1.5)

			local fireworkData = self:_generateFireworkData()
			if fireworkData and #fireworkData > 0 then
				local currentTime = workspace:GetServerTimeNow()

				for _, firework in ipairs(fireworkData) do
					local explosionDelay = firework.Height / 20 * 0.8
					local falloffCompletionDelay = explosionDelay + 2.3
					firework.ServerStartTime = currentTime
				end

				self._createFireworkRemote:FireAllClients(fireworkData)

				for _, firework in ipairs(fireworkData) do
					local explosionDelay = firework.Height / 20 * 0.8
					local falloffCompletionDelay = explosionDelay + 2.3
					task.delay(falloffCompletionDelay, function()
						self:_handleFireworkFalloffs(firework)
					end)
				end
			end
		end
	end)
end

function FourthOfJulyEvent:_generateFireworkData()
	local fireworkCount = math.random(1, 2)
	local fireworkData = {}

	for i = 1, fireworkCount do
		table.insert(fireworkData, {
			Chosen = math.random(1, 10),
			Height = math.random(20, 70),
			FireworkEffect = math.random(1, 3),
			Falloffs = self:_generateFalloffs()
		})
	end

	return fireworkData
end

function FourthOfJulyEvent:_generateFalloffs()
	local falloffs = {}
	local falloffCount = math.random(3, 8)

	for i = 1, falloffCount do
		table.insert(falloffs, Vector3.new(
			math.random(-50, 50),
			0,
			math.random(-50, 50)
			))
	end

	local targetAnimals = self:_getRandomRoadAnimals(math.random(0, 2))
	for _, animalName in ipairs(targetAnimals) do
		table.insert(falloffs, animalName)
	end

	return falloffs
end

function FourthOfJulyEvent:_getRandomRoadAnimals(count)
	local roadAnimals = CollectionService:GetTagged("Animal")
	local movingAnimalsFolder = workspace:FindFirstChild("MovingAnimals")
	local candidates = {}

	for _, animal in ipairs(roadAnimals) do
		if animal.Parent == movingAnimalsFolder and animal.PrimaryPart and string.find(animal.Name, "RoadAnimal_") then
			table.insert(candidates, animal.Name)
		end
	end

	local selected = {}
	for i = 1, math.min(count, #candidates) do
		local randomIndex = math.random(1, #candidates)
		table.insert(selected, candidates[randomIndex])
		table.remove(candidates, randomIndex)
	end

	return selected
end

function FourthOfJulyEvent:_handleFireworkFalloffs(fireworkData)
	for _, falloff in ipairs(fireworkData.Falloffs) do
		if type(falloff) == "string" then
			self:_applyFireworksTrait(falloff)
		end
	end
end

function FourthOfJulyEvent:_applyFireworksTrait(animalName)
	local roadAnimals = CollectionService:GetTagged("Animal")
	local movingAnimalsFolder = workspace:FindFirstChild("MovingAnimals")

	local targetAnimal = nil
	for _, animal in ipairs(roadAnimals) do
		if animal.Parent == movingAnimalsFolder and animal.Name == animalName then
			targetAnimal = animal
			break
		end
	end

	if not targetAnimal or not targetAnimal.Parent then
		return
	end

	if self:_hasFireworksTrait(targetAnimal) then
		return
	end

	local currentTraitsJson = targetAnimal:GetAttribute("Traits")
	local currentTraits = {}
	if currentTraitsJson then
		local success, decoded = pcall(function()
			return HttpService:JSONDecode(currentTraitsJson)
		end)
		if success and type(decoded) == "table" then
			currentTraits = decoded
		end
	end

	table.insert(currentTraits, "Fireworks")
	targetAnimal:SetAttribute("Traits", HttpService:JSONEncode(currentTraits))

	self._explodeTraitEffectRemote:FireAllClients(animalName)
end

function FourthOfJulyEvent:_hasFireworksTrait(animalTemplate)
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
		if trait == "Fireworks" then
			return true
		end
	end

	return false
end

return FourthOfJulyEvent