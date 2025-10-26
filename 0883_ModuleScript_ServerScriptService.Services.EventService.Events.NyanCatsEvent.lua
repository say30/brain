--[[
  Extracted from: ServerScriptService.Services.EventService.Events.NyanCatsEvent
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

local NyanCatsEvent = {}
NyanCatsEvent.__index = NyanCatsEvent

function NyanCatsEvent.new(eventService)
	local self = setmetatable({}, NyanCatsEvent)
	self._eventService = eventService
	self._synchronizer = eventService._synchronizer
	self._nyanSynchronizer = Synchronizer:Create("NyanCatsEvent", {
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

	self._spawnEffectRemote = Net:RemoteEvent("EventService/NyanCats/SpawnEffect")
	self._strikeRemote = Net:RemoteEvent("EventService/NyanCats/Struck")
	self._recentlyTargeted = {}

	self._spawnEffectRemote.OnServerEvent:Connect(function(player)
		self:_handleSpawnEffect(player)
	end)

	return self
end

function NyanCatsEvent:Start(eventEntry)
	if self._isActive then
		return
	end

	self._isActive = true
	print("[NyanCatsEvent] Starting Nyan Cats event")

	ReplicatedStorage:SetAttribute("NyanCatsEvent", true)

	local spawnTime = workspace:GetServerTimeNow() + 1
	for _, player in pairs(Players:GetPlayers()) do
		self._spawnEffectRemote:FireClient(player, spawnTime)
	end

	self._nyanSynchronizer:Set("IsActive", true)

	self:_startStrikeLoop()

	task.wait(1)

	self:_spawnGattatinoNyanino()

	print("[NyanCatsEvent] Nyan Cats event started successfully")
end

function NyanCatsEvent:Stop(eventEntry)
	if not self._isActive then
		return
	end

	self._isActive = false
	print("[NyanCatsEvent] Stopping Nyan Cats event")

	ReplicatedStorage:SetAttribute("NyanCatsEvent", false)

	self._nyanSynchronizer:Set("IsActive", false)

	if self._strikeTask then
		task.cancel(self._strikeTask)
		self._strikeTask = nil
	end

	print("[NyanCatsEvent] Nyan Cats event stopped")
end

function NyanCatsEvent:_spawnGattatinoNyanino()
	print("[NyanCatsEvent] Spawning Gattatino Nyanino on the road")

	local success, result = pcall(function()
		local animalData = Animals["Gattatino Neonino"]
		if not animalData then
			warn("[NyanCatsEvent] Gattatino Nyanino not found in Animals data")
			return
		end

		_G.RoadAnimalService.Spawner:SpawnSpecificAnimal("Gattatino Nyanino", nil, nil)
		print("[NyanCatsEvent] Spawned Gattatino Nyanino on the road")
	end)

	if not success then
		warn("[NyanCatsEvent] Failed to spawn Gattatino Nyanino on the road:", result)
	end
end

function NyanCatsEvent:_handleSpawnEffect(player)
	if not self._isActive then
		return
	end

	print("[NyanCatsEvent] Handling spawn effect for", player and player.Name or "server")
end

function NyanCatsEvent:_startStrikeLoop()
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

				self._strikeRemote:FireAllClients(catIndex, targetAnimal.Name, currentTime)

				self._recentlyTargeted[targetAnimal.Name] = currentTime

				task.delay(3.1, function()
					self:_applyNyanTrait(targetAnimal)
				end)
			end
		end
	end)
end

function NyanCatsEvent:_pickTargetAnimal()
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

function NyanCatsEvent:_hasNyanTrait(animalTemplate)
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
		if trait == "Nyan" then
			return true
		end
	end

	return false
end

function NyanCatsEvent:_applyNyanTrait(animalTemplate)
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
		if trait == "Nyan" then
			return
		end
	end

	table.insert(currentTraits, "Nyan")
	animalTemplate:SetAttribute("Traits", HttpService:JSONEncode(currentTraits))
end

return NyanCatsEvent