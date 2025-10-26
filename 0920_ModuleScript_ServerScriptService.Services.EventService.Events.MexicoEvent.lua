--[[
  Extracted from: ServerScriptService.Services.EventService.Events.MexicoEvent
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local CollectionService = game:GetService("CollectionService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")

local Packages = ReplicatedStorage:WaitForChild("Packages")
local Net = require(Packages.Net)
local Synchronizer = require(Packages.Synchronizer)

local DataManagment = require(ServerScriptService.Services.DataManagment)
local RoadAnimalService = require(ServerScriptService.Services.RoadAnimalService)
local Animals = require(ReplicatedStorage.Datas.Animals)

local MexicoEvent = {}
MexicoEvent.__index = MexicoEvent

function MexicoEvent.new(eventService)
	local self = setmetatable({}, MexicoEvent)
	self._eventService = eventService
	self._synchronizer = eventService._synchronizer
	self._mexicoSynchronizer = Synchronizer:Create("MexicoEvent", {
		IsActive = false
	})

	for _, player in pairs(Players:GetPlayers()) do
		self._mexicoSynchronizer:AddListener(player)
	end

	Players.PlayerAdded:Connect(function(player)
		self._mexicoSynchronizer:AddListener(player)
		if self._isActive and self._music then
			self:_playMusicForPlayer(player)
		end
	end)

	Players.PlayerRemoving:Connect(function(player)
		self._mexicoSynchronizer:RemoveListener(player)
	end)

	self._isActive = false
	self._music = nil
	self._eventFolder = nil
	self._skybox = nil

	-- Mexico Remote Events
	self._mexicoFocusRemote = Net:RemoteEvent("EventService/Mexico/Focus")
	self._mexicoBurstRemote = Net:RemoteEvent("EventService/Mexico/Burst")

	self._recentlyTargeted = {}
	self._activeMexicoHitboxes = {}
	self._eventStartTime = nil

	return self
end

function MexicoEvent:_playMusicForPlayer(player)
	if not self._music then return end

	local sound = Instance.new("Sound")
	sound.SoundId = "rbxassetid://1837258874" -- Mexico-themed music placeholder
	sound.Volume = 0.25
	sound.Looped = true
	sound.Parent = player.PlayerGui
	sound:Play()

	return sound
end

function MexicoEvent:Start(eventEntry)
	if self._isActive then
		return
	end

	self._isActive = true
	self._eventStartTime = workspace:GetServerTimeNow()
	print("[MexicoEvent] Starting Mexico event")

	ReplicatedStorage:SetAttribute("MexicoEvent", true)
	self._mexicoSynchronizer:Set("IsActive", true)

	-- Create and configure music
	self._music = Instance.new("Sound")
	self._music.SoundId = "rbxassetid://1837258874" -- Mexico-themed music placeholder
	self._music.Volume = 0.25
	self._music.Looped = true
	self._music.Parent = ReplicatedStorage

	-- Play music for all current players
	for _, player in pairs(Players:GetPlayers()) do
		self:_playMusicForPlayer(player)
	end

	-- Clone MexicoEvent folder and its contents from ReplicatedStorage to Workspace
	local eventFolder = ReplicatedStorage:FindFirstChild("MexicoEvent")
	if eventFolder then
		self._eventFolder = eventFolder:Clone()
		self._eventFolder.Parent = Workspace
		print("[MexicoEvent] Cloned MexicoEvent folder to Workspace with all contents (including models)")
	else
		warn("[MexicoEvent] MexicoEvent folder not found in ReplicatedStorage")
	end

	-- Move Sky from MexicoEvent folder to Lighting, if it exists
	if eventFolder then
		local sky = eventFolder:FindFirstChild("Sky")
		if sky then
			self._skybox = sky:Clone()
			self._skybox.Parent = Lighting
			print("[MexicoEvent] Cloned Sky to Lighting")
		end
	end

	self:_startMexicoSequence()

	print("[MexicoEvent] Mexico event started successfully")
end

function MexicoEvent:_startMexicoSequence()
	if self._mexicoTask then
		task.cancel(self._mexicoTask)
	end

	self._mexicoTask = task.spawn(function()
		task.wait(5) -- Initial setup phase

		while self._isActive do
			local currentTime = workspace:GetServerTimeNow()
			local eventRunTime = currentTime - self._eventStartTime

			if eventRunTime >= 6 and eventRunTime <= 85 then
				task.wait(math.random(3, 7))
				local targetAnimal = self:_pickTargetAnimal()
				if targetAnimal then
					self:_createMexicoHitbox(targetAnimal)
				end
			elseif eventRunTime > 85 then
				task.wait(math.random(8, 12))
				local targetAnimal = self:_pickTargetAnimal()
				if targetAnimal then
					self:_createMexicoHitbox(targetAnimal)
				end
			else
				task.wait(1)
			end
		end
	end)
end

function MexicoEvent:_createMexicoHitbox(targetAnimal)
	if not targetAnimal or not targetAnimal.PrimaryPart then
		return
	end

	local animalId = targetAnimal.Name
	local animalPosition = targetAnimal.PrimaryPart.Position

	local hitboxPart = Instance.new("Part")
	hitboxPart.Name = "MexicoHitbox_" .. animalId
	hitboxPart.Size = Vector3.new(1, 1, 1)
	hitboxPart.Transparency = 1
	hitboxPart.Anchored = true
	hitboxPart.CanCollide = false
	hitboxPart.CFrame = CFrame.new(animalPosition.X, animalPosition.Y + 9, animalPosition.Z)

	CollectionService:AddTag(hitboxPart, "MexicoHitbox")
	hitboxPart.Parent = Workspace

	self._activeMexicoHitboxes[animalId] = hitboxPart
	self._recentlyTargeted[animalId] = workspace:GetServerTimeNow()

	task.spawn(function()
		local focusTime = workspace:GetServerTimeNow() + 1
		hitboxPart:SetAttribute("Focused", focusTime)
		self._mexicoFocusRemote:FireAllClients(animalId)

		task.wait(3)
		self:_applyMexicoTrait(targetAnimal)
		self._mexicoBurstRemote:FireAllClients(animalId)

		task.wait(2)
		self:_removeMexicoHitbox(animalId)
	end)
end

function MexicoEvent:_removeMexicoHitbox(animalId)
	local hitboxPart = self._activeMexicoHitboxes[animalId]
	if hitboxPart then
		hitboxPart:Destroy()
		self._activeMexicoHitboxes[animalId] = nil
	end
end

function MexicoEvent:Stop(eventEntry)
	if not self._isActive then
		return
	end

	self._isActive = false
	print("[MexicoEvent] Stopping Mexico event")

	ReplicatedStorage:SetAttribute("MexicoEvent", false)
	self._mexicoSynchronizer:Set("IsActive", false)

	-- Stop music for all players
	for _, player in pairs(Players:GetPlayers()) do
		local playerGui = player.PlayerGui
		local sound = playerGui:FindFirstChildOfClass("Sound")
		if sound then
			sound:Stop()
			sound:Destroy()
		end
	end

	if self._music then
		self._music:Destroy()
		self._music = nil
	end

	-- Remove MexicoEvent folder from Workspace
	if self._eventFolder then
		self._eventFolder:Destroy()
		self._eventFolder = nil
		print("[MexicoEvent] Removed MexicoEvent folder from Workspace")
	end

	-- Remove Sky from Lighting
	if self._skybox then
		self._skybox:Destroy()
		self._skybox = nil
		print("[MexicoEvent] Removed Sky from Lighting")
	end

	if self._mexicoTask then
		task.cancel(self._mexicoTask)
		self._mexicoTask = nil
	end

	for animalId, hitboxPart in pairs(self._activeMexicoHitboxes) do
		if hitboxPart then
			hitboxPart:Destroy()
		end
	end
	self._activeMexicoHitboxes = {}

	print("[MexicoEvent] Mexico event stopped")
end

function MexicoEvent:_pickTargetAnimal()
	local roadAnimals = CollectionService:GetTagged("Animal")
	local movingAnimalsFolder = Workspace:FindFirstChild("MovingAnimals")
	local currentTime = workspace:GetServerTimeNow()

	for animalId, lastTime in pairs(self._recentlyTargeted) do
		if (currentTime - lastTime) > 20 then
			self._recentlyTargeted[animalId] = nil
		end
	end

	local candidates = {}
	for _, animal in ipairs(roadAnimals) do
		if animal.Parent == movingAnimalsFolder and animal.PrimaryPart and string.find(animal.Name, "RoadAnimal_") then
			local animalId = animal.Name
			if not self._recentlyTargeted[animalId] and 
				not self:_hasMexicoTrait(animal) and 
				not self._activeMexicoHitboxes[animalId] then
				table.insert(candidates, animal)
			end
		end
	end

	if #candidates == 0 then return nil end
	return candidates[math.random(1, #candidates)]
end

function MexicoEvent:_hasMexicoTrait(animalTemplate)
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
		if trait == "Mexico" then
			return true
		end
	end

	return false
end

function MexicoEvent:_applyMexicoTrait(animalTemplate)
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
		if trait == "Mexico" then
			return
		end
	end

	table.insert(currentTraits, "Mexico")
	animalTemplate:SetAttribute("Traits", HttpService:JSONEncode(currentTraits))
end

return MexicoEvent