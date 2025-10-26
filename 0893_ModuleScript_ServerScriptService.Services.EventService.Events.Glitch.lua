--[[
  Extracted from: ServerScriptService.Services.EventService.Events.Glitch
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

local GlitchEvent = {}
GlitchEvent.__index = GlitchEvent

function GlitchEvent.new(eventService)
	local self = setmetatable({}, GlitchEvent)
	self._eventService = eventService
	self._synchronizer = eventService._synchronizer
	self._nyanSynchronizer = Synchronizer:Create("GlitchEvent", {
		IsActive = false
	})

	for _, player in pairs(Players:GetPlayers()) do
		self._nyanSynchronizer:AddListener(player)
	end

	Players.PlayerAdded:Connect(function(player)
		self._nyanSynchronizer:AddListener(player)
	end)

	Players.PlayerRemoving:Connect(function(player)
		self._nyanSynchronizer:RemoveListener(player)
	end)

	self._isActive = false

	self._spawnEffectRemote = Net:RemoteEvent("EventService/Glitch/HoleEffect")
	--self._strikeRemote = Net:RemoteEvent("EventService/NyanCats/Struck")
	self._recentlyTargeted = {}

	self._spawnEffectRemote.OnServerEvent:Connect(function(player)
		self:_handleSpawnEffect(player)
	end)

	return self
end

function GlitchEvent:Start(eventEntry)
	if self._isActive then
		return
	end
	local GlitchSky = script.Glitch:Clone()
	GlitchSky.Parent = game.Workspace
	self._isActive = true
	print("[GlitchEvent] Starting Nyan Cats event")

	ReplicatedStorage:SetAttribute("GlitchEvent", true)

	local spawnTime = workspace:GetServerTimeNow() + 1
	--for _, player in pairs(Players:GetPlayers()) do
	--	self._spawnEffectRemote:FireClient(player, spawnTime)
	--end

	self._nyanSynchronizer:Set("IsActive", true)

	self:_startStrikeLoop()

	task.wait(1)

	

	print("[GlitchEvent] Nyan Cats event started successfully")
end

function GlitchEvent:_startStrikeLoop()
	if self._strikeTask then
		task.cancel(self._strikeTask)
	end

	self._strikeTask = task.spawn(function()
		while self._isActive do
			task.wait(math.random(2,4))

			local targetAnimal = self:_pickTargetAnimal()
			if targetAnimal then
				local catIndex = math.random(1,30)
				local currentTime = workspace:GetServerTimeNow()

				self._spawnEffectRemote:FireAllClients(targetAnimal.Name, currentTime)

				self._recentlyTargeted[targetAnimal.Name] = currentTime

				task.delay(1.1, function()
					self:_applyNyanTrait(targetAnimal)
				end)
			end
		end
	end)
end

function GlitchEvent:Stop(eventEntry)
	if not self._isActive then
		return
	end
local 	Glitchend = game.Workspace:FindFirstChild("Glitch")
Glitchend:Destroy()
	self._isActive = false
	print("[GlitchEvent] Stopping Nyan Cats event")

	ReplicatedStorage:SetAttribute("GlitchEvent", false)

	self._nyanSynchronizer:Set("IsActive", false)

	if self._strikeTask then
		task.cancel(self._strikeTask)
		self._strikeTask = nil
	end

	print("[GlitchEvent] Nyan Cats event stopped")
end



function GlitchEvent:_handleSpawnEffect(player)
	if not self._isActive then
		return
	end

	print("[GlitchEvent] Handling spawn effect for", player and player.Name or "server")
end

function GlitchEvent:_pickTargetAnimal()
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
			if not self._recentlyTargeted[animal.Name] and not self:_hasNyanTrait(animal) then
				table.insert(candidates, animal)
			end
		end
	end

	if #candidates == 0 then return nil end
	return candidates[math.random(1, #candidates)]
end

function GlitchEvent:_hasNyanTrait(animalTemplate)
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
		if trait == "Glitch" then
			return true
		end
	end

	return false
end

function GlitchEvent:_applyNyanTrait(animalTemplate)
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
		if trait == "Glitch" then
			return
		end
	end

	table.insert(currentTraits, "Glitch")
	warn(currentTraits)
	animalTemplate:SetAttribute("Traits", HttpService:JSONEncode(currentTraits))
end

return GlitchEvent