--[[
  Extracted from: ServerScriptService.Services.EventService.Events.1MEvent
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

local OneMEvent = {}
OneMEvent.__index = OneMEvent

function OneMEvent.new(eventService)
	local self = setmetatable({}, OneMEvent)
	self._eventService = eventService
	self._synchronizer = eventService._synchronizer
	self._oneMSynchronizer = Synchronizer:Create("OneMEvent", {
		IsActive = false
	})

	for _, player in pairs(Players:GetPlayers()) do
		self._oneMSynchronizer:AddListener(player)
	end

	Players.PlayerAdded:Connect(function(player)
		self._oneMSynchronizer:AddListener(player)
		if self._isActive and self._music then
			self:_playMusicForPlayer(player)
		end
	end)

	Players.PlayerRemoving:Connect(function(player)
		self._oneMSynchronizer:RemoveListener(player)
	end)

	self._isActive = false
	self._music = nil
	self._eventFolder = nil

	-- OneM Remote Events
	self._oneMFocusRemote = Net:RemoteEvent("EventService/OneM/Focus")
	self._oneMBurstRemote = Net:RemoteEvent("EventService/OneM/Burst")

	self._recentlyTargeted = {}
	self._activeOneMHitboxes = {}
	self._eventStartTime = nil

	return self
end

function OneMEvent:_playMusicForPlayer(player)
	if not self._music then return end

	local sound = Instance.new("Sound")
	sound.SoundId = "rbxassetid://104361043595775"
	sound.Volume = 0.25
	sound.Looped = true
	sound.Parent = player.PlayerGui
	sound:Play()

	return sound
end

function OneMEvent:Start(eventEntry)
	if self._isActive then
		return
	end

	self._isActive = true
	self._eventStartTime = workspace:GetServerTimeNow()
	print("[OneMEvent] Starting 1M event")

	ReplicatedStorage:SetAttribute("OneMEvent", true)
	self._oneMSynchronizer:Set("IsActive", true)

	-- Create and configure music
	self._music = Instance.new("Sound")
	self._music.SoundId = "rbxassetid://104361043595775"
	self._music.Volume = 0.25
	self._music.Looped = true
	self._music.Parent = ReplicatedStorage

	-- Play music for all current players
	for _, player in pairs(Players:GetPlayers()) do
		self:_playMusicForPlayer(player)
	end

	-- Move Event1M folder from ReplicatedStorage to Workspace
	local eventFolder = ReplicatedStorage:FindFirstChild("Event1M")
	if eventFolder then
		self._eventFolder = eventFolder:Clone()
		self._eventFolder.Parent = Workspace
		-- Optionally clear the original folder in ReplicatedStorage
		-- eventFolder:ClearAllChildren()
	end

	self:_startOneMSequence()

	print("[OneMEvent] 1M event started successfully")
end

function OneMEvent:_startOneMSequence()
	if self._oneMTask then
		task.cancel(self._oneMTask)
	end

	self._oneMTask = task.spawn(function()
		task.wait(5) -- Initial setup phase

		while self._isActive do
			local currentTime = workspace:GetServerTimeNow()
			local eventRunTime = currentTime - self._eventStartTime

			if eventRunTime >= 6 and eventRunTime <= 85 then
				task.wait(math.random(3, 7))
				local targetAnimal = self:_pickTargetAnimal()
				if targetAnimal then
					self:_createOneMHitbox(targetAnimal)
				end
			elseif eventRunTime > 85 then
				task.wait(math.random(8, 12))
				local targetAnimal = self:_pickTargetAnimal()
				if targetAnimal then
					self:_createOneMHitbox(targetAnimal)
				end
			else
				task.wait(1)
			end
		end
	end)
end

function OneMEvent:_createOneMHitbox(targetAnimal)
	if not targetAnimal or not targetAnimal.PrimaryPart then
		return
	end

	local animalId = targetAnimal.Name
	local animalPosition = targetAnimal.PrimaryPart.Position

	local hitboxPart = Instance.new("Part")
	hitboxPart.Name = "OneMHitbox_" .. animalId
	hitboxPart.Size = Vector3.new(1, 1, 1)
	hitboxPart.Transparency = 1
	hitboxPart.Anchored = true
	hitboxPart.CanCollide = false
	hitboxPart.CFrame = CFrame.new(animalPosition.X, animalPosition.Y + 9, animalPosition.Z)

	CollectionService:AddTag(hitboxPart, "OneMHitbox")
	hitboxPart.Parent = Workspace

	self._activeOneMHitboxes[animalId] = hitboxPart
	self._recentlyTargeted[animalId] = workspace:GetServerTimeNow()

	task.spawn(function()
		local focusTime = workspace:GetServerTimeNow() + 1
		hitboxPart:SetAttribute("Focused", focusTime)
		self._oneMFocusRemote:FireAllClients(animalId)

		task.wait(3)
		self:_applyOneMTrait(targetAnimal)
		self._oneMBurstRemote:FireAllClients(animalId)

		task.wait(2)
		self:_removeOneMHitbox(animalId)
	end)
end

function OneMEvent:_removeOneMHitbox(animalId)
	local hitboxPart = self._activeOneMHitboxes[animalId]
	if hitboxPart then
		hitboxPart:Destroy()
		self._activeOneMHitboxes[animalId] = nil
	end
end

function OneMEvent:Stop(eventEntry)
	if not self._isActive then
		return
	end

	self._isActive = false
	print("[OneMEvent] Stopping 1M event")

	ReplicatedStorage:SetAttribute("OneMEvent", false)
	self._oneMSynchronizer:Set("IsActive", false)

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

	-- Remove Event1M folder from Workspace
	if self._eventFolder then
		self._eventFolder:Destroy()
		self._eventFolder = nil
	end

	if self._oneMTask then
		task.cancel(self._oneMTask)
		self._oneMTask = nil
	end

	for animalId, hitboxPart in pairs(self._activeOneMHitboxes) do
		if hitboxPart then
			hitboxPart:Destroy()
		end
	end
	self._activeOneMHitboxes = {}

	print("[OneMEvent] 1M event stopped")
end

function OneMEvent:_pickTargetAnimal()
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
				not self:_hasOneMTrait(animal) and 
				not self._activeOneMHitboxes[animalId] then
				table.insert(candidates, animal)
			end
		end
	end

	if #candidates == 0 then return nil end
	return candidates[math.random(1, #candidates)]
end

function OneMEvent:_hasOneMTrait(animalTemplate)
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
		if trait == "1M" then
			return true
		end
	end

	return false
end

function OneMEvent:_applyOneMTrait(animalTemplate)
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
		if trait == "1M" then
			return
		end
	end

	table.insert(currentTraits, "1M")
	animalTemplate:SetAttribute("Traits", HttpService:JSONEncode(currentTraits))
end

return OneMEvent