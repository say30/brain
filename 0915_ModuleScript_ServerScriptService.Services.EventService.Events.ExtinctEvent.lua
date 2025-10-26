--[[
  Extracted from: ServerScriptService.Services.EventService.Events.ExtinctEvent
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

local ExtinctEvent = {}
ExtinctEvent.__index = ExtinctEvent

function ExtinctEvent.new(eventService)
	local self = setmetatable({}, ExtinctEvent)
	self._eventService = eventService
	self._synchronizer = eventService._synchronizer
	self._extinctSynchronizer = Synchronizer:Create("ExtinctEvent", {
		IsActive = false
	})

	for _, player in pairs(Players:GetPlayers()) do
		self._extinctSynchronizer:AddListener(player)
	end

	Players.PlayerAdded:Connect(function(player)
		self._extinctSynchronizer:AddListener(player)
		if self._isActive and self._music then
			self:_playMusicForPlayer(player)
		end
	end)

	Players.PlayerRemoving:Connect(function(player)
		self._extinctSynchronizer:RemoveListener(player)
	end)

	self._isActive = false
	self._music = nil
	self._eventFolder = nil
	self._skybox = nil

	-- Extinct Remote Events
	self._extinctFocusRemote = Net:RemoteEvent("EventService/Extinct/Focus")
	self._extinctBurstRemote = Net:RemoteEvent("EventService/Extinct/Burst")

	self._recentlyTargeted = {}
	self._activeExtinctHitboxes = {}
	self._eventStartTime = nil

	return self
end

function ExtinctEvent:_playMusicForPlayer(player)
	if not self._music then return end

	local sound = Instance.new("Sound")
	sound.SoundId = "rbxassetid://108543513149215" -- Replace with your desired music asset ID
	sound.Volume = 0.25
	sound.Looped = true
	sound.Parent = player.PlayerGui
	sound:Play()

	return sound
end

function ExtinctEvent:Start(eventEntry)
	if self._isActive then
		return
	end

	self._isActive = true
	self._eventStartTime = workspace:GetServerTimeNow()
	print("[ExtinctEvent] Starting Extinct event")

	ReplicatedStorage:SetAttribute("ExtinctEvent", true)
	self._extinctSynchronizer:Set("IsActive", true)

	-- Create and configure music
	self._music = Instance.new("Sound")
	self._music.SoundId = "rbxassetid://108543513149215" -- Replace with your desired music asset ID
	self._music.Volume = 0.25
	self._music.Looped = true
	self._music.Parent = ReplicatedStorage

	-- Play music for all current players
	for _, player in pairs(Players:GetPlayers()) do
		self:_playMusicForPlayer(player)
	end

	-- Move ExtinctEvent folder from ReplicatedStorage to Workspace
	local eventFolder = ReplicatedStorage:FindFirstChild("ExtinctEvent")
	if eventFolder then
		self._eventFolder = eventFolder:Clone()
		self._eventFolder.Parent = Workspace

		-- Move Sky from ExtinctEvent folder to Lighting
		local sky = eventFolder:FindFirstChild("Sky")
		if sky then
			self._skybox = sky:Clone()
			self._skybox.Parent = Lighting
		end
	end

	self:_startExtinctSequence()

	print("[ExtinctEvent] Extinct event started successfully")
end

function ExtinctEvent:_startExtinctSequence()
	if self._extinctTask then
		task.cancel(self._extinctTask)
	end

	self._extinctTask = task.spawn(function()
		task.wait(5) -- Initial setup phase

		while self._isActive do
			local currentTime = workspace:GetServerTimeNow()
			local eventRunTime = currentTime - self._eventStartTime

			if eventRunTime >= 6 and eventRunTime <= 85 then
				task.wait(math.random(3, 7))
				local targetAnimal = self:_pickTargetAnimal()
				if targetAnimal then
					self:_createExtinctHitbox(targetAnimal)
				end
			elseif eventRunTime > 85 then
				task.wait(math.random(8, 12))
				local targetAnimal = self:_pickTargetAnimal()
				if targetAnimal then
					self:_createExtinctHitbox(targetAnimal)
				end
			else
				task.wait(1)
			end
		end
	end)
end

function ExtinctEvent:_createExtinctHitbox(targetAnimal)
	if not targetAnimal or not targetAnimal.PrimaryPart then
		return
	end

	local animalId = targetAnimal.Name
	local animalPosition = targetAnimal.PrimaryPart.Position

	local hitboxPart = Instance.new("Part")
	hitboxPart.Name = "ExtinctHitbox_" .. animalId
	hitboxPart.Size = Vector3.new(1, 1, 1)
	hitboxPart.Transparency = 1
	hitboxPart.Anchored = true
	hitboxPart.CanCollide = false
	hitboxPart.CFrame = CFrame.new(animalPosition.X, animalPosition.Y + 9, animalPosition.Z)

	CollectionService:AddTag(hitboxPart, "ExtinctHitbox")
	hitboxPart.Parent = Workspace

	self._activeExtinctHitboxes[animalId] = hitboxPart
	self._recentlyTargeted[animalId] = workspace:GetServerTimeNow()

	task.spawn(function()
		local focusTime = workspace:GetServerTimeNow() + 1
		hitboxPart:SetAttribute("Focused", focusTime)
		self._extinctFocusRemote:FireAllClients(animalId)

		task.wait(3)
		self:_applyExtinctTrait(targetAnimal)
		self._extinctBurstRemote:FireAllClients(animalId)

		task.wait(2)
		self:_removeExtinctHitbox(animalId)
	end)
end

function ExtinctEvent:_removeExtinctHitbox(animalId)
	local hitboxPart = self._activeExtinctHitboxes[animalId]
	if hitboxPart then
		hitboxPart:Destroy()
		self._activeExtinctHitboxes[animalId] = nil
	end
end

function ExtinctEvent:Stop(eventEntry)
	if not self._isActive then
		return
	end

	self._isActive = false
	print("[ExtinctEvent] Stopping Extinct event")

	ReplicatedStorage:SetAttribute("ExtinctEvent", false)
	self._extinctSynchronizer:Set("IsActive", false)

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

	-- Remove ExtinctEvent folder from Workspace
	if self._eventFolder then
		self._eventFolder:Destroy()
		self._eventFolder = nil
	end

	-- Remove Sky from Lighting
	if self._skybox then
		self._skybox:Destroy()
		self._skybox = nil
	end

	if self._extinctTask then
		task.cancel(self._extinctTask)
		self._extinctTask = nil
	end

	for animalId, hitboxPart in pairs(self._activeExtinctHitboxes) do
		if hitboxPart then
			hitboxPart:Destroy()
		end
	end
	self._activeExtinctHitboxes = {}

	print("[ExtinctEvent] Extinct event stopped")
end

function ExtinctEvent:_pickTargetAnimal()
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
				not self:_hasExtinctTrait(animal) and 
				not self._activeExtinctHitboxes[animalId] then
				table.insert(candidates, animal)
			end
		end
	end

	if #candidates == 0 then return nil end
	return candidates[math.random(1, #candidates)]
end

function ExtinctEvent:_hasExtinctTrait(animalTemplate)
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
		if trait == "Extinct" then
			return true
		end
	end

	return false
end

function ExtinctEvent:_applyExtinctTrait(animalTemplate)
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
		if trait == "Extinct" then
			return
		end
	end

	table.insert(currentTraits, "Extinct")
	animalTemplate:SetAttribute("Traits", HttpService:JSONEncode(currentTraits))
end

return ExtinctEvent