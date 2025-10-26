--[[
  Extracted from: ServerScriptService.Services.EventService.Events.Snow
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

local SnowEvent = {}
SnowEvent.__index = SnowEvent

function SnowEvent.new(eventService)
	local self = setmetatable({}, SnowEvent)
	self._eventService = eventService
	self._synchronizer = eventService._synchronizer
	self._snowSynchronizer = Synchronizer:Create("SnowEvent", {
		IsActive = false
	})

	for _, player in pairs(Players:GetPlayers()) do
		self._snowSynchronizer:AddListener(player)
	end

	Players.PlayerAdded:Connect(function(player)
		self._snowSynchronizer:AddListener(player)
	end)

	Players.PlayerRemoving:Connect(function(player)
		self._snowSynchronizer:RemoveListener(player)
	end)

	self._isActive = false

	local frigginmodulename = script.Parent.Name
	self._snowHitRemote = Net:RemoteEvent((("EventService/%*/Hit"):format(frigginmodulename)))

	self._recentlyTargeted = {}
	self._snowPiles = nil

	return self
end

function SnowEvent:Start(eventEntry)
	if self._isActive then
		return
	end

	self._isActive = true
	ReplicatedStorage:SetAttribute("SnowEvent", true)
	self._snowSynchronizer:Set("IsActive", true)

	self:_spawnSnowPiles()
	self:_startSnowLoop()

end

function SnowEvent:_spawnSnowPiles()
	local pileTemplate = ReplicatedStorage:FindFirstChild("Models")
		and ReplicatedStorage.Models:FindFirstChild("Events")
		and ReplicatedStorage.Models.Events:FindFirstChild("Snow")
		and ReplicatedStorage.Models.Events.Snow:FindFirstChild("Piles")

	if pileTemplate then
		self._snowPiles = pileTemplate:Clone()
		self._snowPiles.Parent = workspace
	end
end

function SnowEvent:_startSnowLoop()
	if self._snowTask then
		task.cancel(self._snowTask)
	end

	self._snowTask = task.spawn(function()
		task.wait(math.random(2.5, 4))

		while self._isActive do
			task.wait(math.random(3, 6))

			local targetAnimal = self:_pickTargetAnimal()
			if targetAnimal then
				self:_applySnowTrait(targetAnimal)
				self._snowHitRemote:FireAllClients(targetAnimal.Name)
			end
		end
	end)
end

function SnowEvent:_findNearestSnowPile(position)
	if not self._snowPiles then
		return nil
	end

	local nearestPile = nil
	local nearestDistance = math.huge

	for _, pile in pairs(self._snowPiles:GetChildren()) do
		if pile:IsA("BasePart") then
			local distance = (pile.Position - position).Magnitude
			if distance < nearestDistance then
				nearestDistance = distance
				nearestPile = pile
			end
		elseif pile:IsA("Model") and pile.PrimaryPart then
			local distance = (pile.PrimaryPart.Position - position).Magnitude
			if distance < nearestDistance then
				nearestDistance = distance
				nearestPile = pile.PrimaryPart
			end
		end
	end

	return nearestPile
end

function SnowEvent:Stop(eventEntry)
	if not self._isActive then
		return
	end

	self._isActive = false
	ReplicatedStorage:SetAttribute("SnowEvent", false)
	self._snowSynchronizer:Set("IsActive", false)

	if self._snowTask then
		task.cancel(self._snowTask)
		self._snowTask = nil
	end

	if self._snowPiles then
		self._snowPiles:Destroy()
		self._snowPiles = nil
	end
end

function SnowEvent:_pickTargetAnimal()
	local roadAnimals = CollectionService:GetTagged("Animal")
	local movingAnimalsFolder = workspace:FindFirstChild("MovingAnimals")
	local currentTime = workspace:GetServerTimeNow()

	for animalName, lastTime in pairs(self._recentlyTargeted) do
		if (currentTime - lastTime) > 25 then
			self._recentlyTargeted[animalName] = nil
		end
	end

	local candidates = {}
	for _, animal in ipairs(roadAnimals) do
		if animal.Parent == movingAnimalsFolder and animal.PrimaryPart and string.find(animal.Name, "RoadAnimal_") then
			if not self._recentlyTargeted[animal.Name] and not self:_hasSnowTrait(animal) then
				table.insert(candidates, animal)
			end
		end
	end

	if #candidates == 0 then return nil end
	return candidates[math.random(1, #candidates)]
end

function SnowEvent:_hasSnowTrait(animalTemplate)
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
		if trait == "Snowy" then
			return true
		end
	end

	return false
end

function SnowEvent:_applySnowTrait(animalTemplate)
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
		if trait == "Snowy" then
			return
		end
	end

	table.insert(currentTraits, "Snowy")
	animalTemplate:SetAttribute("Traits", HttpService:JSONEncode(currentTraits))
end

return SnowEvent