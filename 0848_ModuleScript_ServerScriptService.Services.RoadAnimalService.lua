--[[
  Extracted from: ServerScriptService.Services.RoadAnimalService
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local RoadAnimalService = {}
RoadAnimalService.__index = RoadAnimalService

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(script.Configuration.RoadAnimalConfig)
local RoadAnimalSpawner = require(script.RoadAnimalSpawner)
local RoadAnimalPathfinder = require(script.RoadAnimalPathfinder)
local RoadAnimalInteraction = require(script.RoadAnimalInteraction)
local RoadPityDisplay = require(script.RoadPityDisplay)

local Animals = require(ReplicatedStorage.Datas.Animals)

local Net = require(ReplicatedStorage.Packages.Net)
local NumberUtils = require(ReplicatedStorage.Utils.NumberUtils)

function RoadAnimalService.new()
	local self = setmetatable({}, RoadAnimalService)

	self.Config = Config
	self.Spawner = RoadAnimalSpawner.new(Config)
	self.Pathfinder = RoadAnimalPathfinder.new(Config)
	self.Interaction = RoadAnimalInteraction.new(Config)
	self.PityDisplay = RoadPityDisplay.new(Config)

	self.ActiveAnimals = {}
	self.IsRunning = false

	self:_connectModules()
	self:_setupRemotes()

	return self
end

function RoadAnimalService:_connectModules()
	self.Spawner:SetPathfinder(self.Pathfinder)
	self.Interaction:SetMainService(self)

	if self.Pathfinder.Initialize then
		self.Pathfinder:Initialize()
	end

	self.Spawner:SetAnimalSpawnedCallback(function(animalTemplate, animalData)
		self:_onAnimalSpawned(animalTemplate, animalData)
	end)

	self.Pathfinder:SetAnimalReachedEndCallback(function(animalTemplate)
		self:_onAnimalReachedEnd(animalTemplate)
	end)

	self.PityDisplay:Initialize()
	self.Spawner:SetPityDisplay(self.PityDisplay)
end

function RoadAnimalService:_setupRemotes()
	Net:Connect("RoadAnimalService/BuyRoadAnimal", function(player, animalIndex)
		self:HandlePurchaseAttempt(player, animalIndex)
	end)
end

function RoadAnimalService:_onAnimalSpawned(animalTemplate, animalData)
	self.ActiveAnimals[animalTemplate] = {
		Data = animalData,
		SpawnTime = tick()
	}

	self.Interaction:SetupAnimalInteraction(animalTemplate, animalData)

	self.Pathfinder:StartPathfinding(animalTemplate)
end

function RoadAnimalService:_onAnimalReachedEnd(animalTemplate)
	self:_cleanupAnimal(animalTemplate)
end

function RoadAnimalService:_cleanupAnimal(animalTemplate)
	if self.ActiveAnimals[animalTemplate] then
		self.ActiveAnimals[animalTemplate] = nil
	end

	self.Interaction:CleanupAnimalInteraction(animalTemplate)

	if animalTemplate and animalTemplate.Parent then
		animalTemplate:Destroy()
	end
end

function RoadAnimalService:Start()
	if self.IsRunning then
		return
	end

	self.IsRunning = true
	self.Spawner:StartSpawning()
	self.PityDisplay:Start()
end

function RoadAnimalService:Stop()
	if not self.IsRunning then
		return
	end

	self.IsRunning = false
	self.Spawner:StopSpawning()
	self.PityDisplay:Stop()

	for animalTemplate in pairs(self.ActiveAnimals) do
		self:_cleanupAnimal(animalTemplate)
	end
end

function RoadAnimalService:HandlePurchaseAttempt(player, animalIndex)
	if not player or not animalIndex then
		warn("Invalid purchase attempt - missing player or animal index")
		return
	end

	if self.Config.DEBUG.PRINT_PURCHASE_INFO then
		print(("🛒 Purchase attempt by %s for animal index: %s"):format(player.Name, tostring(animalIndex)))
	end

	if not self.IsRunning then
		local Net = require(ReplicatedStorage.Packages.Net)
		local NotificationEvent = Net:RemoteEvent("NotificationService/Notify")
		NotificationEvent:FireClient(player, "<font color=\"#FA0103\">Road animal system is currently offline.</font>", 3)
		return
	end
end

function RoadAnimalService:GetStatus()
	return {
		IsRunning = self.IsRunning,
		ActiveAnimals = #self.ActiveAnimals,
		SpawnerActive = self.Spawner:IsSpawningActive(),
		ActiveSpawns = self.Spawner:GetActiveSpawnCount()
	}
end

return RoadAnimalService 