--[[
  Extracted from: ServerScriptService.Services.EventService.Events.CandyEvent
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

local CandyEvent = {}
CandyEvent.__index = CandyEvent

function CandyEvent.new(eventService)
	local self = setmetatable({}, CandyEvent)
	self._eventService = eventService
	self._synchronizer = eventService._synchronizer
	self._candySynchronizer = Synchronizer:Create("CandyEvent", {
		IsActive = false
	})

	for _, player in pairs(Players:GetPlayers()) do
		self._candySynchronizer:AddListener(player)
	end

	Players.PlayerAdded:Connect(function(player)
		self._candySynchronizer:AddListener(player)
		if self._isActive and self._music then
			self:_playMusicForPlayer(player)
		end
	end)

	Players.PlayerRemoving:Connect(function(player)
		self._candySynchronizer:RemoveListener(player)
	end)

	self._isActive = false
	self._music = nil
	self._eventFolder = nil
	self._skybox = nil

	-- Candy Remote Events
	self._candyFocusRemote = Net:RemoteEvent("EventService/Candy/Focus")
	self._candyBurstRemote = Net:RemoteEvent("EventService/Candy/Burst")

	self._recentlyTargeted = {}
	self._activeCandyHitboxes = {}
	self._eventStartTime = nil

	return self
end

function CandyEvent:_playMusicForPlayer(player)
	if not self._music then return end

	local sound = Instance.new("Sound")
	sound.SoundId = "rbxassetid://104540042499979" -- Candy-themed music (replace if needed)
	sound.Volume = 0.25
	sound.Looped = true
	sound.Parent = player.PlayerGui
	sound:Play()

	return sound
end

function CandyEvent:Start(eventEntry)
	if self._isActive then
		return
	end

	self._isActive = true
	self._eventStartTime = workspace:GetServerTimeNow()
	print("[CandyEvent] Starting Candy event")

	ReplicatedStorage:SetAttribute("CandyEvent", true)
	self._candySynchronizer:Set("IsActive", true)

	-- Create and configure music
	self._music = Instance.new("Sound")
	self._music.SoundId = "rbxassetid://104540042499979" -- Candy-themed music (replace if needed)
	self._music.Volume = 0.25
	self._music.Looped = true
	self._music.Parent = ReplicatedStorage

	-- Play music for all current players
	for _, player in pairs(Players:GetPlayers()) do
		self:_playMusicForPlayer(player)
	end

	-- Move CandyEvent folder and its contents from ReplicatedStorage to Workspace
	local eventFolder = ReplicatedStorage:FindFirstChild("CandyEvent")
	if eventFolder then
		self._eventFolder = eventFolder:Clone()
		self._eventFolder.Parent = Workspace
		print("[CandyEvent] Cloned CandyEvent folder to Workspace with all contents")
	else
		warn("[CandyEvent] CandyEvent folder not found in ReplicatedStorage")
	end

	-- Move Sky from CandyEvent folder to Lighting, if it exists
	if eventFolder then
		local sky = eventFolder:FindFirstChild("SkyCandy")
		if sky then
			self._skybox = sky:Clone()
			self._skybox.Parent = Lighting
			print("[CandyEvent] Cloned Sky to Lighting")
		end
	end

	self:_startCandySequence()

	print("[CandyEvent] Candy event started successfully")
end

function CandyEvent:_startCandySequence()
	if self._candyTask then
		task.cancel(self._candyTask)
	end

	self._candyTask = task.spawn(function()
		task.wait(5) -- Initial setup phase

		while self._isActive do
			local currentTime = workspace:GetServerTimeNow()
			local eventRunTime = currentTime - self._eventStartTime

			if eventRunTime >= 6 and eventRunTime <= 85 then
				task.wait(math.random(3, 7))
				local targetAnimal = self:_pickTargetAnimal()
				if targetAnimal then
					self:_createCandyHitbox(targetAnimal)
				end
			elseif eventRunTime > 85 then
				task.wait(math.random(8, 12))
				local targetAnimal = self:_pickTargetAnimal()
				if targetAnimal then
					self:_createCandyHitbox(targetAnimal)
				end
			else
				task.wait(1)
			end
		end
	end)
end

function CandyEvent:_createCandyHitbox(targetAnimal)
	if not targetAnimal or not targetAnimal.PrimaryPart then
		return
	end

	local animalId = targetAnimal.Name
	local animalPosition = targetAnimal.PrimaryPart.Position

	local hitboxPart = Instance.new("Part")
	hitboxPart.Name = "CandyHitbox_" .. animalId
	hitboxPart.Size = Vector3.new(1, 1, 1)
	hitboxPart.Transparency = 1
	hitboxPart.Anchored = true
	hitboxPart.CanCollide = false
	hitboxPart.CFrame = CFrame.new(animalPosition.X, animalPosition.Y + 9, animalPosition.Z)

	CollectionService:AddTag(hitboxPart, "CandyHitbox")
	hitboxPart.Parent = Workspace

	self._activeCandyHitboxes[animalId] = hitboxPart
	self._recentlyTargeted[animalId] = workspace:GetServerTimeNow()

	task.spawn(function()
		local focusTime = workspace:GetServerTimeNow() + 1
		hitboxPart:SetAttribute("Focused", focusTime)
		self._candyFocusRemote:FireAllClients(animalId)

		task.wait(3)
		self:_applyCandyTrait(targetAnimal)
		self._candyBurstRemote:FireAllClients(animalId)

		task.wait(2)
		self:_removeCandyHitbox(animalId)
	end)
end

function CandyEvent:_removeCandyHitbox(animalId)
	local hitboxPart = self._activeCandyHitboxes[animalId]
	if hitboxPart then
		hitboxPart:Destroy()
		self._activeCandyHitboxes[animalId] = nil
	end
end

function CandyEvent:Stop(eventEntry)
	if not self._isActive then
		return
	end

	self._isActive = false
	print("[CandyEvent] Stopping Candy event")

	ReplicatedStorage:SetAttribute("CandyEvent", false)
	self._candySynchronizer:Set("IsActive", false)

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

	-- Remove CandyEvent folder from Workspace
	if self._eventFolder then
		self._eventFolder:Destroy()
		self._eventFolder = nil
		print("[CandyEvent] Removed CandyEvent folder from Workspace")
	end

	-- Remove Sky from Lighting
	if self._skybox then
		self._skybox:Destroy()
		self._skybox = nil
		print("[CandyEvent] Removed Sky from Lighting")
	end

	if self._candyTask then
		task.cancel(self._candyTask)
		self._candyTask = nil
	end

	for animalId, hitboxPart in pairs(self._activeCandyHitboxes) do
		if hitboxPart then
			hitboxPart:Destroy()
		end
	end
	self._activeCandyHitboxes = {}

	print("[CandyEvent] Candy event stopped")
end

function CandyEvent:_pickTargetAnimal()
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
				not self:_hasCandyTrait(animal) and 
				not self._activeCandyHitboxes[animalId] then
				table.insert(candidates, animal)
			end
		end
	end

	if #candidates == 0 then return nil end
	return candidates[math.random(1, #candidates)]
end

function CandyEvent:_hasCandyTrait(animalTemplate)
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
		if trait == "Candy" then
			return true
		end
	end

	return false
end

function CandyEvent:_applyCandyTrait(animalTemplate)
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
		if trait == "Candy" then
			return
		end
	end

	table.insert(currentTraits, "Candy")
	animalTemplate:SetAttribute("Traits", HttpService:JSONEncode(currentTraits))
end

return CandyEvent