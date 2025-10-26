--[[
  Extracted from: ServerScriptService.Services.EventService.Events.Brazil
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

local BrazilEvent = {}
BrazilEvent.__index = BrazilEvent

function BrazilEvent.new(eventService)
	local self = setmetatable({}, BrazilEvent)
	self._eventService = eventService
	self._synchronizer = eventService._synchronizer
	self._brazilSynchronizer = Synchronizer:Create("BrazilEvent", {
		IsActive = false
	})

	for _, player in pairs(Players:GetPlayers()) do
		self._brazilSynchronizer:AddListener(player)
	end

	Players.PlayerAdded:Connect(function(player)
		self._brazilSynchronizer:AddListener(player)
	end)

	Players.PlayerRemoving:Connect(function(player)
		self._brazilSynchronizer:RemoveListener(player)
	end)

	self._isActive = false

	-- Brazil Remote Events (matching the client script)
	self._brazilFocusRemote = Net:RemoteEvent("EventService/Brazil/Focus")
	self._brazilBurstRemote = Net:RemoteEvent("EventService/Brazil/Burst")

	self._recentlyTargeted = {}
	self._activeBrazilHitboxes = {}
	self._eventStartTime = nil

	return self
end

function BrazilEvent:Start(eventEntry)
	if self._isActive then
		return
	end

	self._isActive = true
	self._eventStartTime = workspace:GetServerTimeNow()
	print("[BrazilEvent] Starting Brazil event")

	ReplicatedStorage:SetAttribute("BrazilEvent", true)

	self._brazilSynchronizer:Set("IsActive", true)

	self:_startBrazilSequence()

	print("[BrazilEvent] Brazil event started successfully")
end

function BrazilEvent:_startBrazilSequence()
	if self._brazilTask then
		task.cancel(self._brazilTask)
	end

	self._brazilTask = task.spawn(function()
		-- Wait for initial setup phase (5 seconds)
		task.wait(5)

		-- Start the main targeting loop
		while self._isActive do
			local currentTime = workspace:GetServerTimeNow()
			local eventRunTime = currentTime - self._eventStartTime

			-- Different phases of the event
			if eventRunTime >= 6 and eventRunTime <= 85 then -- Main active phase
				task.wait(math.random(3, 7)) -- Brazil cubes spawn every 3-7 seconds

				local targetAnimal = self:_pickTargetAnimal()
				if targetAnimal then
					self:_createBrazilHitbox(targetAnimal)
				end
			elseif eventRunTime > 85 then
				-- Event is winding down, less frequent targeting
				task.wait(math.random(8, 12))

				local targetAnimal = self:_pickTargetAnimal()
				if targetAnimal then
					self:_createBrazilHitbox(targetAnimal)
				end
			else
				task.wait(1) -- Wait during setup phase
			end
		end
	end)
end

function BrazilEvent:_createBrazilHitbox(targetAnimal)
	if not targetAnimal or not targetAnimal.PrimaryPart then
		return
	end

	local animalId = targetAnimal.Name
	local animalPosition = targetAnimal.PrimaryPart.Position

	-- Create Brazil hitbox part
	local hitboxPart = Instance.new("Part")
	hitboxPart.Name = "BrazilHitbox_" .. animalId
	hitboxPart.Size = Vector3.new(1,1,1) -- Cube size matching the client
	hitboxPart.Transparency = 1 -- Invisible on server
	hitboxPart.Anchored = true
	hitboxPart.CanCollide = false
	hitboxPart.CFrame = CFrame.new(animalPosition.X, animalPosition.Y + 9, animalPosition.Z)

	-- Add the tag that the client script observes
	CollectionService:AddTag(hitboxPart, "BrazilHitbox")

	hitboxPart.Parent = workspace

	self._activeBrazilHitboxes[animalId] = hitboxPart
	self._recentlyTargeted[animalId] = workspace:GetServerTimeNow()

	-- Start the Brazil sequence for this animal
	task.spawn(function()
		-- Phase 1: Focus on the animal (sends animal ID to client)
		local focusTime = workspace:GetServerTimeNow() + 1 -- 1 second delay before focusing
		hitboxPart:SetAttribute("Focused", focusTime)

		-- Send focus event to clients
		self._brazilFocusRemote:FireAllClients(animalId)

		-- Phase 2: Wait for the cube animation and effects (about 3 seconds total)
		task.wait(3)

		-- Phase 3: Apply Brazil trait and fire burst effect
		self:_applyBrazilTrait(targetAnimal)
		self._brazilBurstRemote:FireAllClients(animalId)

		-- Phase 4: Clean up after a delay
		task.wait(2)
		self:_removeBrazilHitbox(animalId)
	end)
end

function BrazilEvent:_removeBrazilHitbox(animalId)
	local hitboxPart = self._activeBrazilHitboxes[animalId]
	if hitboxPart then
		hitboxPart:Destroy()
		self._activeBrazilHitboxes[animalId] = nil
	end
end

function BrazilEvent:Stop(eventEntry)
	if not self._isActive then
		return
	end

	self._isActive = false
	print("[BrazilEvent] Stopping Brazil event")

	ReplicatedStorage:SetAttribute("BrazilEvent", false)

	self._brazilSynchronizer:Set("IsActive", false)

	if self._brazilTask then
		task.cancel(self._brazilTask)
		self._brazilTask = nil
	end

	-- Clean up all active hitboxes
	for animalId, hitboxPart in pairs(self._activeBrazilHitboxes) do
		if hitboxPart then
			hitboxPart:Destroy()
		end
	end
	self._activeBrazilHitboxes = {}

	print("[BrazilEvent] Brazil event stopped")
end

function BrazilEvent:_pickTargetAnimal()
	local roadAnimals = CollectionService:GetTagged("Animal")
	local movingAnimalsFolder = workspace:FindFirstChild("MovingAnimals")
	local currentTime = workspace:GetServerTimeNow()

	-- Clean up old targets (longer cooldown for Brazil event)
	for animalId, lastTime in pairs(self._recentlyTargeted) do
		if (currentTime - lastTime) > 20 then -- 20 second cooldown
			self._recentlyTargeted[animalId] = nil
		end
	end

	local candidates = {}
	for _, animal in ipairs(roadAnimals) do
		if animal.Parent == movingAnimalsFolder and animal.PrimaryPart and string.find(animal.Name, "RoadAnimal_") then
			local animalId = animal.Name
			if not self._recentlyTargeted[animalId] and 
				not self:_hasBrazilTrait(animal) and 
				not self._activeBrazilHitboxes[animalId] then
				table.insert(candidates, animal)
			end
		end
	end

	if #candidates == 0 then return nil end
	return candidates[math.random(1, #candidates)]
end

function BrazilEvent:_hasBrazilTrait(animalTemplate)
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
		if trait == "Brazil" then
			return true
		end
	end

	return false
end

function BrazilEvent:_applyBrazilTrait(animalTemplate)
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
		if trait == "Brazil" then
			return
		end
	end

	table.insert(currentTraits, "Brazil")
	animalTemplate:SetAttribute("Traits", HttpService:JSONEncode(currentTraits))
end

return BrazilEvent