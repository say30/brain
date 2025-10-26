--[[
  Extracted from: ServerScriptService.Services.EventService.Events.300K
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local CollectionService = game:GetService("CollectionService")

local Packages = ReplicatedStorage:WaitForChild("Packages")
local Net = require(Packages.Net)
local Synchronizer = require(Packages.Synchronizer)

local DataManagment = require(ServerScriptService.Services.DataManagment)
local RoadAnimalService = require(ServerScriptService.Services.RoadAnimalService)
local Animals = require(ReplicatedStorage.Datas.Animals)

local VisitsEvent = {}
VisitsEvent.__index = VisitsEvent

function VisitsEvent.new(eventService)
	local self = setmetatable({}, VisitsEvent)
	self._eventService = eventService
	self._synchronizer = eventService._synchronizer
	self._visitsSynchronizer = Synchronizer:Create("10BVisitsEvent", {
		IsActive = false
	})

	for _, player in pairs(Players:GetPlayers()) do
		self._visitsSynchronizer:AddListener(player)
	end

	Players.PlayerAdded:Connect(function(player)
		self._visitsSynchronizer:AddListener(player)
	end)

	Players.PlayerRemoving:Connect(function(player)
		self._visitsSynchronizer:RemoveListener(player)
	end)

	self._isActive = false

	-- Remote events for the 10B Visits event
	self._createFireworkRemote = Net:RemoteEvent("EventService/10B Visits/CreateFirework")
	self._explodeTraitEffectRemote = Net:RemoteEvent("EventService/10B Visits/ExplodeTraitEffect")

	self._recentlyTargeted = {}
	self._fireworkQueue = {}

	return self
end

function VisitsEvent:Start(eventEntry)
	if self._isActive then
		return
	end

	self._isActive = true
	print("[10BVisitsEvent] Starting 10B Visits event")

	ReplicatedStorage:SetAttribute("10BVisitsEvent", true)

	self._visitsSynchronizer:Set("IsActive", true)

	self:_startFireworkLoop()

end

function VisitsEvent:_startFireworkLoop()
	if self._fireworkTask then
		task.cancel(self._fireworkTask)
	end

	self._fireworkTask = task.spawn(function()
		while self._isActive do
			task.wait(math.random(8, 15)) -- Fireworks spawn less frequently than UFOs

			local targetAnimals = self:_pickTargetAnimals()
			if #targetAnimals > 0 then
				self:_createFireworkShow(targetAnimals)
			end
		end
	end)
end

function VisitsEvent:_createFireworkShow(targetAnimals)
	local fireworkData = {}

	for i, animal in ipairs(targetAnimals) do
		if animal and animal.PrimaryPart then
			local fireworkEffect = math.random(1, 5) -- Random firework effect type
			local height = math.random(80, 120) -- Random height for variety

			fireworkData[i] = {
				Chosen = i,
				FireworkEffect = fireworkEffect,
				Height = height,
				Falloffs = self:_generateFalloffs(animal)
			}

			-- Mark animal as recently targeted
			self._recentlyTargeted[animal.Name] = workspace:GetServerTimeNow()

			-- Apply the 10B trait after a delay (when firework explodes)
			task.spawn(function()
				local travelTime = height / 20 * 0.8 -- Same calculation as client
				task.wait(travelTime + 1) -- Small additional delay

				self:_apply10BTrait(animal)

				-- Fire the trait effect
				self._explodeTraitEffectRemote:FireAllClients(fireworkEffect, animal.Name)
			end)
		end
	end

	-- Send firework data to all clients
	self._createFireworkRemote:FireAllClients(fireworkData)
end

function VisitsEvent:_generateFalloffs(animal)
	local falloffs = {}
	local numFalloffs = math.random(3, 6)

	for i = 1, numFalloffs do
		if i == 1 then
			-- First falloff targets the animal directly
			table.insert(falloffs, animal.Name)
		else
			-- Other falloffs are random positions around the animal
			local randomOffset = Vector3.new(
				math.random(-30, 30),
				0,
				math.random(-30, 30)
			)
			table.insert(falloffs, randomOffset)
		end
	end

	return falloffs
end

function VisitsEvent:Stop(eventEntry)
	if not self._isActive then
		return
	end

	self._isActive = false
	print("[10BVisitsEvent] Stopping 10B Visits event")

	ReplicatedStorage:SetAttribute("10BVisitsEvent", false)

	self._visitsSynchronizer:Set("IsActive", false)

	if self._fireworkTask then
		task.cancel(self._fireworkTask)
		self._fireworkTask = nil
	end

	print("[10BVisitsEvent] 10B Visits event stopped")
end

function VisitsEvent:_pickTargetAnimals()
	local roadAnimals = CollectionService:GetTagged("Animal")
	local movingAnimalsFolder = workspace:FindFirstChild("MovingAnimals")
	local currentTime = workspace:GetServerTimeNow()

	-- Clean up old targets
	for animalName, lastTime in pairs(self._recentlyTargeted) do
		if (currentTime - lastTime) > 60 then -- Longer cooldown for fireworks
			self._recentlyTargeted[animalName] = nil
		end
	end

	local candidates = {}
	for _, animal in ipairs(roadAnimals) do
		if animal.Parent == movingAnimalsFolder and animal.PrimaryPart and string.find(animal.Name, "RoadAnimal_") then
			if not self._recentlyTargeted[animal.Name] and not self:_has10BTrait(animal) then
				table.insert(candidates, animal)
			end
		end
	end

	-- Select multiple animals for firework show (1-3 animals)
	local selectedAnimals = {}
	local numToSelect = math.min(math.random(1, 3), #candidates)

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

function VisitsEvent:_has10BTrait(animalTemplate)
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
		if trait == "10B" then
			return true
		end
	end

	return false
end

function VisitsEvent:_apply10BTrait(animalTemplate)
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

	-- Check if trait already exists
	for _, trait in ipairs(currentTraits) do
		if trait == "10B" then
			return
		end
	end

	-- Add the 10B trait
	table.insert(currentTraits, "10B")
	animalTemplate:SetAttribute("Traits", HttpService:JSONEncode(currentTraits))
end

return VisitsEvent