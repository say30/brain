--[[
  Extracted from: ServerScriptService.Services.EventService.Events.Bombardiro Crocodilo
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local CollectionService = game:GetService("CollectionService")

local Net = require(ReplicatedStorage.Packages.Net)
local BombardiroCrocodilo = require(ReplicatedStorage.Controllers.EventController.Events["Bombardiro Crocodilo"])

local Module = {}
Module.__index = Module

function Module.new(eventService)
	local self = setmetatable({}, Module)
	self._eventService = eventService
	self._active = false
	self._bombingTask = nil
	self._recentlyTargeted = {}

	self._spawnBombRemote = Net:RemoteEvent("EventService/Bombardiro Crocodilo/SpawnBomb")
	self._explodeRemote = Net:RemoteEvent("EventService/Bombardiro Crocodilo/Explode")

	return self
end

function Module:Start(eventData)
	if self._active then return end
	self._active = true
	self._eventData = eventData or {}

	self:_startBombingLoop()

	print("[Bombardiro Crocodilo] Event started with animal targeting")
end

function Module:Stop()
	if not self._active then return end
	self._active = false

	-- Stop the bombing loop
	if self._bombingTask then
		task.cancel(self._bombingTask)
		self._bombingTask = nil
	end

	-- Stop the client-side event
	BombardiroCrocodilo.OnStop()

	print("[Bombardiro Crocodilo] Event stopped")
end

function Module:Load()
	BombardiroCrocodilo.OnLoad()
end

function Module:_startBombingLoop()
	if self._bombingTask then
		task.cancel(self._bombingTask)
	end

	self._bombingTask = task.spawn(function()
		-- Wait for the planes to appear (based on the client script, planes appear after 8 seconds)
		task.wait(10)

		while self._active do
			-- Wait 2-5 seconds between bomb drops
			task.wait(math.random(2, 5))

			local targetAnimal = self:_pickTargetAnimal()
			if targetAnimal and targetAnimal.PrimaryPart then
				self:_dropBombOnAnimal(targetAnimal)
			else
				-- If no valid animal, drop bomb at random location
				self:_dropBombAtRandomLocation()
			end
		end
	end)
end

function Module:_dropBombOnAnimal(targetAnimal)
	local targetPosition = targetAnimal.PrimaryPart.Position
	local dropHeight = targetPosition.Y + math.random(80, 120) -- Drop from above
	local dropPosition = Vector3.new(targetPosition.X, dropHeight, targetPosition.Z)

	-- Choose a random plane (assuming you have multiple planes)
	local planeId = "BombardiroPlane" .. math.random(1, 3) -- Adjust based on your plane setup

	-- Fire to all clients to spawn the bomb
	self._spawnBombRemote:FireAllClients(planeId, dropPosition, targetPosition)

	-- Mark this animal as recently targeted
	self._recentlyTargeted[targetAnimal.Name] = workspace:GetServerTimeNow()

	-- Calculate time until bomb hits the ground
	local fallTime = self:_calculateFallTime(dropPosition.Y, targetPosition.Y)

	-- Schedule explosion and trait application
	task.delay(fallTime, function()
		if self._active and targetAnimal.Parent then
			-- Fire explosion effect to all clients
			self._explodeRemote:FireAllClients(targetPosition, "Explosion")

			-- Apply the trait
			self:_applyBombardiroHatTrait(targetAnimal)

			print("[Bombardiro Crocodilo] Bomb hit", targetAnimal.Name)
		end
	end)
end

function Module:_dropBombAtRandomLocation()
	-- Get a random position for missed bombs
	local randomPosition = self:_getRandomBombPosition()
	if randomPosition then
		local dropHeight = randomPosition.Y + math.random(80, 120)
		local dropPosition = Vector3.new(randomPosition.X, dropHeight, randomPosition.Z)

		local planeId = "BombardiroPlane" .. math.random(1, 3)

		-- Fire to all clients to spawn the bomb
		self._spawnBombRemote:FireAllClients(planeId, dropPosition, randomPosition)

		-- Calculate fall time and schedule explosion
		local fallTime = self:_calculateFallTime(dropPosition.Y, randomPosition.Y)

		task.delay(fallTime, function()
			if self._active then
				-- Fire explosion effect to all clients
				self._explodeRemote:FireAllClients(randomPosition, "Explosion")
			end
		end)
	end
end

function Module:_calculateFallTime(startY, endY)
	-- Simple gravity calculation (adjust if needed to match your client script)
	local distance = startY - endY
	local gravity = 196.2 -- Roblox's default gravity
	return math.sqrt(2 * distance / gravity)
end

function Module:_pickTargetAnimal()
	local roadAnimals = CollectionService:GetTagged("Animal")
	local movingAnimalsFolder = workspace:FindFirstChild("MovingAnimals")
	local currentTime = workspace:GetServerTimeNow()

	-- Clean up old entries from recently targeted
	for animalName, lastTime in pairs(self._recentlyTargeted) do
		if (currentTime - lastTime) > 15 then -- 15 second cooldown
			self._recentlyTargeted[animalName] = nil
		end
	end

	local candidates = {}
	for _, animal in ipairs(roadAnimals) do
		-- Check if it's a road animal and hasn't been targeted recently
		if animal.Parent == movingAnimalsFolder and 
			animal.PrimaryPart and 
			string.find(animal.Name, "RoadAnimal_") and
			not self._recentlyTargeted[animal.Name] and
			not self:_hasBombardiroHatTrait(animal) then
			table.insert(candidates, animal)
		end
	end

	if #candidates == 0 then return nil end
	return candidates[math.random(1, #candidates)]
end

function Module:_getRandomBombPosition()
	-- Get a random position in the world for bombs that miss
	local x = math.random(-500, 500)
	local z = math.random(-500, 500)

	-- Raycast down to find the ground
	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
	raycastParams.FilterDescendantsInstances = {Players}

	local raycastResult = workspace:Raycast(Vector3.new(x, 1000, z), Vector3.new(0, -2000, 0), raycastParams)

	if raycastResult then
		return raycastResult.Position
	else
		return Vector3.new(x, 50, z) -- Fallback position
	end
end

function Module:_hasBombardiroHatTrait(animalTemplate)
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
		if trait == "Explosive" then
			return true
		end
	end

	return false
end

function Module:_applyBombardiroHatTrait(animalTemplate)
	if not animalTemplate or not animalTemplate.Parent then
		return
	end

	if self:_hasBombardiroHatTrait(animalTemplate) then
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

	table.insert(currentTraits, "Explosive")
	animalTemplate:SetAttribute("Traits", HttpService:JSONEncode(currentTraits))
end

return Module