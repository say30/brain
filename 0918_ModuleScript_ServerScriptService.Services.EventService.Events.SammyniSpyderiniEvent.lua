--[[
  Extracted from: ServerScriptService.Services.EventService.Events.SammyniSpyderiniEvent
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

local SammyniSpyderiniEvent = {}
SammyniSpyderiniEvent.__index = SammyniSpyderiniEvent

function SammyniSpyderiniEvent.new(eventService)
	local self = setmetatable({}, SammyniSpyderiniEvent)
	self._eventService = eventService
	self._synchronizer = eventService._synchronizer
	self._sammyniSynchronizer = Synchronizer:Create("SammyniSpyderiniEvent", {
		IsActive = false
	})

	for _, player in pairs(Players:GetPlayers()) do
		self._sammyniSynchronizer:AddListener(player)
	end

	Players.PlayerAdded:Connect(function(player)
		self._sammyniSynchronizer:AddListener(player)
		if self._isActive and self._music then
			self:_playMusicForPlayer(player)
		end
	end)

	Players.PlayerRemoving:Connect(function(player)
		self._sammyniSynchronizer:RemoveListener(player)
	end)

	self._isActive = false
	self._music = nil
	self._eventFolder = nil
	self._skybox = nil

	-- Sammyni Spyderini Remote Events
	self._sammyniFocusRemote = Net:RemoteEvent("EventService/SammyniSpyderini/Focus")
	self._sammyniBurstRemote = Net:RemoteEvent("EventService/SammyniSpyderini/Burst")

	self._recentlyTargeted = {}
	self._activeSammyniHitboxes = {}
	self._eventStartTime = nil

	return self
end

function SammyniSpyderiniEvent:_playMusicForPlayer(player)
	if not self._music then return end

	local sound = Instance.new("Sound")
	sound.SoundId = "rbxassetid://1846893179" -- Spider-themed music placeholder
	sound.Volume = 0.25
	sound.Looped = true
	sound.Parent = player.PlayerGui
	sound:Play()

	return sound
end

function SammyniSpyderiniEvent:Start(eventEntry)
	if self._isActive then
		return
	end

	self._isActive = true
	self._eventStartTime = workspace:GetServerTimeNow()
	print("[SammyniSpyderiniEvent] Starting Sammyni Spyderini event")

	ReplicatedStorage:SetAttribute("SammyniSpyderiniEvent", true)
	self._sammyniSynchronizer:Set("IsActive", true)

	-- Create and configure music
	self._music = Instance.new("Sound")
	self._music.SoundId = "rbxassetid://1846893179" -- Spider-themed music placeholder
	self._music.Volume = 0.25
	self._music.Looped = true
	self._music.Parent = ReplicatedStorage

	-- Play music for all current players
	for _, player in pairs(Players:GetPlayers()) do
		self:_playMusicForPlayer(player)
	end

	-- Move SammyniSpyderiniEvent folder and its contents from ReplicatedStorage to Workspace
	local eventFolder = ReplicatedStorage:FindFirstChild("SammyniSpyderiniEvent")
	if eventFolder then
		self._eventFolder = eventFolder:Clone()
		self._eventFolder.Parent = Workspace
		print("[SammyniSpyderiniEvent] Cloned SammyniSpyderiniEvent folder to Workspace with all contents")
	else
		warn("[SammyniSpyderiniEvent] SammyniSpyderiniEvent folder not found in ReplicatedStorage")
	end

	-- Move Sky from SammyniSpyderiniEvent folder to Lighting, if it exists
	if eventFolder then
		local sky = eventFolder:FindFirstChild("Sky")
		if sky then
			self._skybox = sky:Clone()
			self._skybox.Parent = Lighting
			print("[SammyniSpyderiniEvent] Cloned Sky to Lighting")
		end
	end

	self:_startSammyniSequence()

	print("[SammyniSpyderiniEvent] Sammyni Spyderini event started successfully")
end

function SammyniSpyderiniEvent:_startSammyniSequence()
	if self._sammyniTask then
		task.cancel(self._sammyniTask)
	end

	self._sammyniTask = task.spawn(function()
		task.wait(5) -- Initial setup phase

		while self._isActive do
			local currentTime = workspace:GetServerTimeNow()
			local eventRunTime = currentTime - self._eventStartTime

			if eventRunTime >= 6 and eventRunTime <= 85 then
				task.wait(math.random(3, 7))
				local targetAnimal = self:_pickTargetAnimal()
				if targetAnimal then
					self:_createSammyniHitbox(targetAnimal)
				end
			elseif eventRunTime > 85 then
				task.wait(math.random(8, 12))
				local targetAnimal = self:_pickTargetAnimal()
				if targetAnimal then
					self:_createSammyniHitbox(targetAnimal)
				end
			else
				task.wait(1)
			end
		end
	end)
end

function SammyniSpyderiniEvent:_createSammyniHitbox(targetAnimal)
	if not targetAnimal or not targetAnimal.PrimaryPart then
		return
	end

	local animalId = targetAnimal.Name
	local animalPosition = targetAnimal.PrimaryPart.Position

	local hitboxPart = Instance.new("Part")
	hitboxPart.Name = "SammyniHitbox_" .. animalId
	hitboxPart.Size = Vector3.new(1, 1, 1)
	hitboxPart.Transparency = 1
	hitboxPart.Anchored = true
	hitboxPart.CanCollide = false
	hitboxPart.CFrame = CFrame.new(animalPosition.X, animalPosition.Y + 9, animalPosition.Z)

	CollectionService:AddTag(hitboxPart, "SammyniHitbox")
	hitboxPart.Parent = Workspace

	self._activeSammyniHitboxes[animalId] = hitboxPart
	self._recentlyTargeted[animalId] = workspace:GetServerTimeNow()

	task.spawn(function()
		local focusTime = workspace:GetServerTimeNow() + 1
		hitboxPart:SetAttribute("Focused", focusTime)
		self._sammyniFocusRemote:FireAllClients(animalId)

		task.wait(3)
		self:_applySammyniTrait(targetAnimal)
		self._sammyniBurstRemote:FireAllClients(animalId)

		task.wait(2)
		self:_removeSammyniHitbox(animalId)
	end)
end

function SammyniSpyderiniEvent:_removeSammyniHitbox(animalId)
	local hitboxPart = self._activeSammyniHitboxes[animalId]
	if hitboxPart then
		hitboxPart:Destroy()
		self._activeSammyniHitboxes[animalId] = nil
	end
end

function SammyniSpyderiniEvent:Stop(eventEntry)
	if not self._isActive then
		return
	end

	self._isActive = false
	print("[SammyniSpyderiniEvent] Stopping Sammyni Spyderini event")

	ReplicatedStorage:SetAttribute("SammyniSpyderiniEvent", false)
	self._sammyniSynchronizer:Set("IsActive", false)

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

	-- Remove SammyniSpyderiniEvent folder from Workspace
	if self._eventFolder then
		self._eventFolder:Destroy()
		self._eventFolder = nil
		print("[SammyniSpyderiniEvent] Removed SammyniSpyderiniEvent folder from Workspace")
	end

	-- Remove Sky from Lighting
	if self._skybox then
		self._skybox:Destroy()
		self._skybox = nil
		print("[SammyniSpyderiniEvent] Removed Sky from Lighting")
	end

	if self._sammyniTask then
		task.cancel(self._sammyniTask)
		self._sammyniTask = nil
	end

	for animalId, hitboxPart in pairs(self._activeSammyniHitboxes) do
		if hitboxPart then
			hitboxPart:Destroy()
		end
	end
	self._activeSammyniHitboxes = {}

	print("[SammyniSpyderiniEvent] Sammyni Spyderini event stopped")
end

function SammyniSpyderiniEvent:_pickTargetAnimal()
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
				not self:_hasSammyniTrait(animal) and 
				not self._activeSammyniHitboxes[animalId] then
				table.insert(candidates, animal)
			end
		end
	end

	if #candidates == 0 then return nil end
	return candidates[math.random(1, #candidates)]
end

function SammyniSpyderiniEvent:_hasSammyniTrait(animalTemplate)
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
		if trait == "SammyniSpyderini" then
			return true
		end
	end

	return false
end

function SammyniSpyderiniEvent:_applySammyniTrait(animalTemplate)
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
		if trait == "SammyniSpyderini" then
			return
		end
	end

	table.insert(currentTraits, "SammyniSpyderini")
	animalTemplate:SetAttribute("Traits", HttpService:JSONEncode(currentTraits))
end

return SammyniSpyderiniEvent