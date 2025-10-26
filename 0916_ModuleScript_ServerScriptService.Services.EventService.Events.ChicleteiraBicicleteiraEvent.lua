--[[
  Extracted from: ServerScriptService.Services.EventService.Events.ChicleteiraBicicleteiraEvent
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

local ChicleteiraBicicleteiraEvent = {}
ChicleteiraBicicleteiraEvent.__index = ChicleteiraBicicleteiraEvent

function ChicleteiraBicicleteiraEvent.new(eventService)
	local self = setmetatable({}, ChicleteiraBicicleteiraEvent)
	self._eventService = eventService
	self._synchronizer = eventService._synchronizer
	self._chicleteiraSynchronizer = Synchronizer:Create("ChicleteiraBicicleteiraEvent", {
		IsActive = false
	})

	for _, player in pairs(Players:GetPlayers()) do
		self._chicleteiraSynchronizer:AddListener(player)
	end

	Players.PlayerAdded:Connect(function(player)
		self._chicleteiraSynchronizer:AddListener(player)
		if self._isActive and self._music then
			self:_playMusicForPlayer(player)
		end
	end)

	Players.PlayerRemoving:Connect(function(player)
		self._chicleteiraSynchronizer:RemoveListener(player)
	end)

	self._isActive = false
	self._music = nil
	self._eventFolder = nil
	self._skybox = nil

	-- Chicleteira Bicicleteira Remote Events
	self._chicleteiraFocusRemote = Net:RemoteEvent("EventService/ChicleteiraBicicleteira/Focus")
	self._chicleteiraBurstRemote = Net:RemoteEvent("EventService/ChicleteiraBicicleteira/Burst")

	self._recentlyTargeted = {}
	self._activeChicleteiraHitboxes = {}
	self._eventStartTime = nil

	return self
end

function ChicleteiraBicicleteiraEvent:_playMusicForPlayer(player)
	if not self._music then return end

	local sound = Instance.new("Sound")
	sound.SoundId = "rbxassetid://1807226938" -- Chicleteira Bicicleteira Funk from Shazam
	sound.Volume = 0.25
	sound.Looped = true
	sound.Parent = player.PlayerGui
	sound:Play()

	return sound
end

function ChicleteiraBicicleteiraEvent:Start(eventEntry)
	if self._isActive then
		return
	end

	self._isActive = true
	self._eventStartTime = workspace:GetServerTimeNow()
	print("[ChicleteiraBicicleteiraEvent] Starting Chicleteira Bicicleteira event")

	ReplicatedStorage:SetAttribute("ChicleteiraBicicleteiraEvent", true)
	self._chicleteiraSynchronizer:Set("IsActive", true)

	-- Create and configure music
	self._music = Instance.new("Sound")
	self._music.SoundId = "rbxassetid://1807226938" -- Chicleteira Bicicleteira Funk from Shazam
	self._music.Volume = 0.25
	self._music.Looped = true
	self._music.Parent = ReplicatedStorage

	-- Play music for all current players
	for _, player in pairs(Players:GetPlayers()) do
		self:_playMusicForPlayer(player)
	end

	-- Move ChicleteiraBicicleteiraEvent folder and its contents from ReplicatedStorage to Workspace
	local eventFolder = ReplicatedStorage:FindFirstChild("ChicleteiraBicicleteiraEvent")
	if eventFolder then
		self._eventFolder = eventFolder:Clone()
		self._eventFolder.Parent = Workspace
		print("[ChicleteiraBicicleteiraEvent] Cloned ChicleteiraBicicleteiraEvent folder to Workspace with all contents")
	else
		warn("[ChicleteiraBicicleteiraEvent] ChicleteiraBicicleteiraEvent folder not found in ReplicatedStorage")
	end

	-- Move Sky from ChicleteiraBicicleteiraEvent folder to Lighting, if it exists
	if eventFolder then
		local sky = eventFolder:FindFirstChild("Sky")
		if sky then
			self._skybox = sky:Clone()
			self._skybox.Parent = Lighting
			print("[ChicleteiraBicicleteiraEvent] Cloned Sky to Lighting")
		end
	end

	self:_startChicleteiraSequence()

	print("[ChicleteiraBicicleteiraEvent] Chicleteira Bicicleteira event started successfully")
end

function ChicleteiraBicicleteiraEvent:_startChicleteiraSequence()
	if self._chicleteiraTask then
		task.cancel(self._chicleteiraTask)
	end

	self._chicleteiraTask = task.spawn(function()
		task.wait(5) -- Initial setup phase

		while self._isActive do
			local currentTime = workspace:GetServerTimeNow()
			local eventRunTime = currentTime - self._eventStartTime

			if eventRunTime >= 6 and eventRunTime <= 85 then
				task.wait(math.random(3, 7))
				local targetAnimal = self:_pickTargetAnimal()
				if targetAnimal then
					self:_createChicleteiraHitbox(targetAnimal)
				end
			elseif eventRunTime > 85 then
				task.wait(math.random(8, 12))
				local targetAnimal = self:_pickTargetAnimal()
				if targetAnimal then
					self:_createChicleteiraHitbox(targetAnimal)
				end
			else
				task.wait(1)
			end
		end
	end)
end

function ChicleteiraBicicleteiraEvent:_createChicleteiraHitbox(targetAnimal)
	if not targetAnimal or not targetAnimal.PrimaryPart then
		return
	end

	local animalId = targetAnimal.Name
	local animalPosition = targetAnimal.PrimaryPart.Position

	local hitboxPart = Instance.new("Part")
	hitboxPart.Name = "ChicleteiraHitbox_" .. animalId
	hitboxPart.Size = Vector3.new(1, 1, 1)
	hitboxPart.Transparency = 1
	hitboxPart.Anchored = true
	hitboxPart.CanCollide = false
	hitboxPart.CFrame = CFrame.new(animalPosition.X, animalPosition.Y + 9, animalPosition.Z)

	CollectionService:AddTag(hitboxPart, "ChicleteiraHitbox")
	hitboxPart.Parent = Workspace

	self._activeChicleteiraHitboxes[animalId] = hitboxPart
	self._recentlyTargeted[animalId] = workspace:GetServerTimeNow()

	task.spawn(function()
		local focusTime = workspace:GetServerTimeNow() + 1
		hitboxPart:SetAttribute("Focused", focusTime)
		self._chicleteiraFocusRemote:FireAllClients(animalId)

		task.wait(3)
		self:_applyChicleteiraTrait(targetAnimal)
		self._chicleteiraBurstRemote:FireAllClients(animalId)

		task.wait(2)
		self:_removeChicleteiraHitbox(animalId)
	end)
end

function ChicleteiraBicicleteiraEvent:_removeChicleteiraHitbox(animalId)
	local hitboxPart = self._activeChicleteiraHitboxes[animalId]
	if hitboxPart then
		hitboxPart:Destroy()
		self._activeChicleteiraHitboxes[animalId] = nil
	end
end

function ChicleteiraBicicleteiraEvent:Stop(eventEntry)
	if not self._isActive then
		return
	end

	self._isActive = false
	print("[ChicleteiraBicicleteiraEvent] Stopping Chicleteira Bicicleteira event")

	ReplicatedStorage:SetAttribute("ChicleteiraBicicleteiraEvent", false)
	self._chicleteiraSynchronizer:Set("IsActive", false)

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

	-- Remove ChicleteiraBicicleteiraEvent folder from Workspace
	if self._eventFolder then
		self._eventFolder:Destroy()
		self._eventFolder = nil
		print("[ChicleteiraBicicleteiraEvent] Removed ChicleteiraBicicleteiraEvent folder from Workspace")
	end

	-- Remove Sky from Lighting
	if self._skybox then
		self._skybox:Destroy()
		self._skybox = nil
		print("[ChicleteiraBicicleteiraEvent] Removed Sky from Lighting")
	end

	if self._chicleteiraTask then
		task.cancel(self._chicleteiraTask)
		self._chicleteiraTask = nil
	end

	for animalId, hitboxPart in pairs(self._activeChicleteiraHitboxes) do
		if hitboxPart then
			hitboxPart:Destroy()
		end
	end
	self._activeChicleteiraHitboxes = {}

	print("[ChicleteiraBicicleteiraEvent] Chicleteira Bicicleteira event stopped")
end

function ChicleteiraBicicleteiraEvent:_pickTargetAnimal()
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
				not self:_hasChicleteiraTrait(animal) and 
				not self._activeChicleteiraHitboxes[animalId] then
				table.insert(candidates, animal)
			end
		end
	end

	if #candidates == 0 then return nil end
	return candidates[math.random(1, #candidates)]
end

function ChicleteiraBicicleteiraEvent:_hasChicleteiraTrait(animalTemplate)
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
		if trait == "Chicleteira" then
			return true
		end
	end

	return false
end

function ChicleteiraBicicleteiraEvent:_applyChicleteiraTrait(animalTemplate)
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
		if trait == "Chicleteira" then
			return
		end
	end

	table.insert(currentTraits, "Chicleteira")
	animalTemplate:SetAttribute("Traits", HttpService:JSONEncode(currentTraits))
end

return ChicleteiraBicicleteiraEvent