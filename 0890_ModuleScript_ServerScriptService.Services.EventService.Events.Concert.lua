--[[
  Extracted from: ServerScriptService.Services.EventService.Events.Concert
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local CollectionService = game:GetService("CollectionService")
local Workspace = game:GetService("Workspace")

local Packages = ReplicatedStorage:WaitForChild("Packages")
local Net = require(Packages.Net)
local Synchronizer = require(Packages.Synchronizer)

local DataManagment = require(ServerScriptService.Services.DataManagment)
local RoadAnimalService = require(ServerScriptService.Services.RoadAnimalService)
local Animals = require(ReplicatedStorage.Datas.Animals)

local ConcertEvent = {}
ConcertEvent.__index = ConcertEvent

function ConcertEvent.new(eventService)
	local self = setmetatable({}, ConcertEvent)
	self._eventService = eventService
	self._synchronizer = eventService._synchronizer
	self._concertSynchronizer = Synchronizer:Create("ConcertEvent", { IsActive = false })

	for _, player in pairs(Players:GetPlayers()) do
		self._concertSynchronizer:AddListener(player)
	end
	Players.PlayerAdded:Connect(function(player)
		self._concertSynchronizer:AddListener(player)
	end)
	Players.PlayerRemoving:Connect(function(player)
		self._concertSynchronizer:RemoveListener(player)
	end)

	self._isActive = false
	self._shootRemote = Net:RemoteEvent("EventService/Concert/Shoot")
	self._recentlyTargeted = {}

	self._shootRemote.OnServerEvent:Connect(function(player, rigIndex, animalName, hitTime)
		self:_handleAnimalHit(player, rigIndex, animalName, hitTime)
	end)

	return self
end

function ConcertEvent:Start(eventEntry)
	if self._isActive then
		return
	end
	self._isActive = true
	ReplicatedStorage:SetAttribute("ConcertEvent", true)
	self._concertSynchronizer:Set("IsActive", true)

	self:_startShootingLoop()
end

function ConcertEvent:Stop(eventEntry)
	if not self._isActive then
		return
	end
	self._isActive = false
	ReplicatedStorage:SetAttribute("ConcertEvent", false)
	self._concertSynchronizer:Set("IsActive", false)

	if self._shootTask then
		task.cancel(self._shootTask)
		self._shootTask = nil
	end
end

function ConcertEvent:_startShootingLoop()
	if self._shootTask then
		task.cancel(self._shootTask)
	end

	self._shootTask = task.spawn(function()
		while self._isActive do
			local waitTime = math.random(1.5, 5)
			task.wait(waitTime)

			local targetAnimal = self:_pickTargetAnimal()
			if targetAnimal then
				local rigIndex = math.random(1,3)
				local currentTime = Workspace:GetServerTimeNow()
				self._shootRemote:FireAllClients(rigIndex, targetAnimal.Name, currentTime + 3)
				self._recentlyTargeted[targetAnimal.Name] = currentTime
			end
		end
	end)
end

function ConcertEvent:_pickTargetAnimal()
	local roadAnimals = CollectionService:GetTagged("Animal")
	local movingAnimalsFolder = Workspace:FindFirstChild("MovingAnimals")
	if not movingAnimalsFolder then
		return nil
	end

	local currentTime = Workspace:GetServerTimeNow()
	for animalName, lastTime in pairs(self._recentlyTargeted) do
		if (currentTime - lastTime) > 10 then
			self._recentlyTargeted[animalName] = nil
		end
	end

	local candidates = {}
	for _, animal in ipairs(roadAnimals) do
		if animal.Parent == movingAnimalsFolder and animal.PrimaryPart and string.find(animal.Name, "RoadAnimal_") then
			if not self._recentlyTargeted[animal.Name] and not self:_hasDiscoTrait(animal) then
				table.insert(candidates, animal)
			end
		end
	end

	if #candidates == 0 then
		return nil
	end

	return candidates[math.random(1,#candidates)]
end

function ConcertEvent:_handleAnimalHit(player, rigIndex, animalName, hitTime)
	if not self._isActive then
		return
	end
	local movingAnimalsFolder = Workspace:FindFirstChild("MovingAnimals")
	if not movingAnimalsFolder then
		return
	end

	local targetAnimal = movingAnimalsFolder:FindFirstChild(animalName)

	if targetAnimal then
		self:_applyDiscoTrait(targetAnimal)
	end
end

function ConcertEvent:_hasDiscoTrait(animal)
	if not animal or not animal.Parent then return false end
	local traitsJson = animal:GetAttribute("Traits")
	if not traitsJson then return false end
	local success, decoded = pcall(function()
		return HttpService:JSONDecode(traitsJson)
	end)
	if not success or type(decoded) ~= "table" then return false end
	for _, trait in ipairs(decoded) do
		if trait == "Disco" then return true end
	end
	return false
end

function ConcertEvent:_applyDiscoTrait(animal)
	if not animal or not animal.Parent then
		return
	end

	local traitsJson = animal:GetAttribute("Traits")
	local traits = {}

	if traitsJson then
		local success, decoded = pcall(function()
			return HttpService:JSONDecode(traitsJson)
		end)
		if success and type(decoded) == "table" then
			traits = decoded
		end
	end

	for _, trait in ipairs(traits) do
		if trait == "Disco" then
			return
		end
	end

	table.insert(traits, "Disco")
	local encoded = HttpService:JSONEncode(traits)
	animal:SetAttribute("Traits", encoded)
end

return ConcertEvent