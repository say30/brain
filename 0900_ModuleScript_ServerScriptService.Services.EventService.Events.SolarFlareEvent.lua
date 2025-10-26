--[[
  Extracted from: ServerScriptService.Services.EventService.Events.SolarFlareEvent
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
local SolarFlare = require(ReplicatedStorage.Controllers.EventController.Events["Solar Flare"])
local Model = ReplicatedStorage.Models.Events["Solar Flare"]:FindFirstChild("SolarFlareBeam")
local SolarFlareEvent = {}
SolarFlareEvent.__index = SolarFlareEvent

function SolarFlareEvent.new(eventService)
	local self = setmetatable({}, SolarFlareEvent)
	self._eventService = eventService
	self._synchronizer = eventService._synchronizer
	self._solarSynchronizer = Synchronizer:Create("SolarFlareEvent", {
		IsActive = false
	})

	for _, player in pairs(Players:GetPlayers()) do
		self._solarSynchronizer:AddListener(player)
	end

	Players.PlayerAdded:Connect(function(player)
		self._solarSynchronizer:AddListener(player)
	end)

	Players.PlayerRemoving:Connect(function(player)
		self._solarSynchronizer:RemoveListener(player)
	end)
	self._isActive = false

	self._recentlyTargeted = {}


	return self
end

function SolarFlareEvent:Start(eventEntry)
	if self._isActive then
		return
	end

	self._isActive = true
	ReplicatedStorage:SetAttribute("SolarFlareEvent", true)
	local spawnTime = workspace:GetServerTimeNow() + 1
	local Solar = Model:Clone()
	Solar.BeamEnd:SetAttribute("StartTime", spawnTime)
	Solar.BeamEnd:SetAttribute("SpawnPosition", workspace.MapCenter.Position)
	Solar.Parent = workspace.Events["Solar Flare"]
	SolarFlare:OnLoad()
	SolarFlare:OnStart()
	self._solarSynchronizer:Set("IsActive", true)

	self:_startStrikeLoop()

	task.wait(1)

	

	print("[SolarFlareEvent] Solar Flare event started successfully")
end

function SolarFlareEvent:Stop(eventEntry)
	if not self._isActive then
		return
	end

	self._isActive = false
	print("[SolarFlareEvent] Stopping Solar Flare event")
	
	ReplicatedStorage:SetAttribute("SolarFlareEvent", false)
	SolarFlare:OnStop()
	self._solarSynchronizer:Set("IsActive", false)

	if self._strikeTask then
		task.cancel(self._strikeTask)
		self._strikeTask = nil
	end

	print("[SolarFlareEvent] Solar Flare event stopped")
end

function SolarFlareEvent:_startStrikeLoop()
	if self._strikeTask then
		task.cancel(self._strikeTask)
	end
	
	self._strikeTask = task.spawn(function()
		while self._isActive do
			task.wait(math.random(2,4))

			local targetAnimal = self:_pickTargetAnimal()
			if targetAnimal then
				local catIndex = math.random(1,4)
				local currentTime = workspace:GetServerTimeNow()
				local cloni = ReplicatedStorage.Models.Events["Solar Flare"].SolarFlareBeam.Hitbox:Clone()
				cloni.Name = "Hitbox" .. catIndex
				cloni:AddTag("SolarFlareHitbox")
				cloni.Position = targetAnimal.PrimaryPart.Position
				cloni.Parent = workspace.Events["Solar Flare"].SolarFlareBeam
				workspace.Events["Solar Flare"].SolarFlareBeam.BeamEnd:SetAttribute("NumBeams", catIndex)
				self._recentlyTargeted[targetAnimal.Name] = currentTime

				task.delay(3.1, function()
					self:_applysolarTrait(targetAnimal)
				end)
			end
		end
	end)
end




function SolarFlareEvent:_pickTargetAnimal()
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
			if not self._recentlyTargeted[animal.Name] and not self:_hassolarTrait(animal) then
				table.insert(candidates, animal)
			end
		end
	end

	if #candidates == 0 then return nil end
	return candidates[math.random(1, #candidates)]
end

function SolarFlareEvent:_hassolarTrait(animalTemplate)
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
		if trait == "Fire" then
			return true
		end
	end

	return false
end

function SolarFlareEvent:_applysolarTrait(animalTemplate)
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
		if trait == "Fire" then
			return
		end
	end

	table.insert(currentTraits, "Fire")
	animalTemplate:SetAttribute("Traits", HttpService:JSONEncode(currentTraits))
end

return SolarFlareEvent