--[[
  Extracted from: ServerScriptService.Services.EventService.Events.YinYangEvent
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

---By Mr.Flowers
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

local YinYangEvent = {}
YinYangEvent.__index = YinYangEvent

function YinYangEvent.new(eventService)
	local self = setmetatable({}, YinYangEvent)
	self._eventService = eventService
	self._synchronizer = eventService._synchronizer
	self._yinYangSynchronizer = Synchronizer:Create("YinYangEvent", {
		IsActive = false
	})

	for _, player in pairs(Players:GetPlayers()) do
		self._yinYangSynchronizer:AddListener(player)
	end

	Players.PlayerAdded:Connect(function(player)
		self._yinYangSynchronizer:AddListener(player)
		if self._isActive and self._music then
			self:_playMusicForPlayer(player)
		end
	end)

	Players.PlayerRemoving:Connect(function(player)
		self._yinYangSynchronizer:RemoveListener(player)
	end)

	self._isActive = false
	self._music = nil
	self._eventFolder = nil
	self._skybox = nil

	-- Remote Events
	self._yinYangFocusRemote = Net:RemoteEvent("EventService/YinYang/Focus")
	self._yinYangBurstRemote = Net:RemoteEvent("EventService/YinYang/Burst")

	self._recentlyTargeted = {}
	self._activeYinYangHitboxes = {}
	self._eventStartTime = nil

	return self
end

function YinYangEvent:_playMusicForPlayer(player)
	if not self._music then return end

	local sound = Instance.new("Sound")
	sound.SoundId = "rbxassetid://1837258874" -- YinYang event music placeholder
	sound.Volume = 0.25
	sound.Looped = true
	sound.Parent = player:WaitForChild("PlayerGui")
	sound:Play()

	return sound 
end

function YinYangEvent:Start(eventEntry)
	if self._isActive then
		return
	end

	self._isActive = true
	self._eventStartTime = workspace:GetServerTimeNow()
	print("[YinYangEvent] Starting YinYang event")

	ReplicatedStorage:SetAttribute("YinYangEvent", true)
	self._yinYangSynchronizer:Set("IsActive", true)

	-- Create and configure music
	self._music = Instance.new("Sound")
	self._music.SoundId = "rbxassetid://1837258874"
	self._music.Volume = 0.25
	self._music.Looped = true
	self._music.Parent = ReplicatedStorage

	-- Play music for all current players
	for _, player in pairs(Players:GetPlayers()) do
		self:_playMusicForPlayer(player)
	end

	-- ✅ Fixed path to YinYangEvent folder in ReplicatedStorage.Models.Events
	local modelsFolder = ReplicatedStorage:FindFirstChild("Models")
	local eventsFolder = modelsFolder and modelsFolder:FindFirstChild("Events")
	local eventFolder = eventsFolder and eventsFolder:FindFirstChild("YinYangEvent")

	if eventFolder then
		self._eventFolder = eventFolder:Clone()
		self._eventFolder.Parent = Workspace
		print("[YinYangEvent] Cloned YinYangEvent folder from Models/Events into Workspace")
	else
		warn("[YinYangEvent] YinYangEvent folder not found in ReplicatedStorage.Models.Events")
	end

	-- Move Sky from YinYangEvent folder to Lighting
	if self._eventFolder then
		local sky = self._eventFolder:FindFirstChild("Sky")
		if sky then
			self._skybox = sky:Clone()
			self._skybox.Parent = Lighting
			print("[YinYangEvent] Cloned Sky to Lighting")
		end
	end

	self:_startYinYangSequence()

	print("[YinYangEvent] YinYang event started successfully")
end

function YinYangEvent:_startYinYangSequence()
	if self._yinYangTask then
		task.cancel(self._yinYangTask)
	end

	self._yinYangTask = task.spawn(function()
		task.wait(5) -- Initial setup phase

		while self._isActive do
			local currentTime = workspace:GetServerTimeNow()
			local eventRunTime = currentTime - self._eventStartTime

			if eventRunTime >= 6 and eventRunTime <= 85 then
				task.wait(math.random(3, 7))
				local targetAnimal = self:_pickTargetAnimal()
				if targetAnimal then
					self:_createYinYangHitbox(targetAnimal)
				end
			elseif eventRunTime > 85 then
				task.wait(math.random(8, 12))
				local targetAnimal = self:_pickTargetAnimal()
				if targetAnimal then
					self:_createYinYangHitbox(targetAnimal)
				end
			else
				task.wait(1)
			end
		end
	end)
end

function YinYangEvent:_createYinYangHitbox(targetAnimal)
	if not targetAnimal or not targetAnimal.PrimaryPart then
		return
	end

	local animalId = targetAnimal.Name
	local animalPosition = targetAnimal.PrimaryPart.Position

	local hitboxPart = Instance.new("Part")
	hitboxPart.Name = "YinYangHitbox_" .. animalId
	hitboxPart.Size = Vector3.new(1, 1, 1)
	hitboxPart.Transparency = 1
	hitboxPart.Anchored = true
	hitboxPart.CanCollide = false
	hitboxPart.CFrame = CFrame.new(animalPosition.X, animalPosition.Y + 9, animalPosition.Z)

	CollectionService:AddTag(hitboxPart, "YinYangHitbox")
	hitboxPart.Parent = Workspace

	self._activeYinYangHitboxes[animalId] = hitboxPart
	self._recentlyTargeted[animalId] = workspace:GetServerTimeNow()

	task.spawn(function()
		local focusTime = workspace:GetServerTimeNow() + 1
		hitboxPart:SetAttribute("Focused", focusTime)
		self._yinYangFocusRemote:FireAllClients(animalId)

		task.wait(3)
		self:_applyYinYangTrait(targetAnimal)
		self._yinYangBurstRemote:FireAllClients(animalId)

		task.wait(2)
		self:_removeYinYangHitbox(animalId)
	end)
end

function YinYangEvent:_removeYinYangHitbox(animalId)
	local hitboxPart = self._activeYinYangHitboxes[animalId]
	if hitboxPart then
		hitboxPart:Destroy()
		self._activeYinYangHitboxes[animalId] = nil
	end
end

function YinYangEvent:Stop(eventEntry)
	if not self._isActive then
		return
	end

	self._isActive = false
	print("[YinYangEvent] Stopping YinYang event")

	ReplicatedStorage:SetAttribute("YinYangEvent", false)
	self._yinYangSynchronizer:Set("IsActive", false)

	-- Stop music for all players
	for _, player in pairs(Players:GetPlayers()) do
		local playerGui = player:FindFirstChild("PlayerGui")
		if playerGui then
			local sound = playerGui:FindFirstChildOfClass("Sound")
			if sound then
				sound:Stop()
				sound:Destroy()
			end
		end
	end

	if self._music then
		self._music:Destroy()
		self._music = nil
	end

	-- Remove YinYangEvent folder from Workspace
	if self._eventFolder then
		self._eventFolder:Destroy()
		self._eventFolder = nil
		print("[YinYangEvent] Removed YinYangEvent folder from Workspace")
	end

	-- Remove Sky from Lighting
	if self._skybox then
		self._skybox:Destroy()
		self._skybox = nil
		print("[YinYangEvent] Removed Sky from Lighting")
	end

	if self._yinYangTask then
		task.cancel(self._yinYangTask)
		self._yinYangTask = nil
	end

	for animalId, hitboxPart in pairs(self._activeYinYangHitboxes) do
		if hitboxPart then
			hitboxPart:Destroy()
		end
	end
	self._activeYinYangHitboxes = {}

	print("[YinYangEvent] YinYang event stopped")
end

function YinYangEvent:_pickTargetAnimal()
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
				not self:_hasYinYangTrait(animal) and 
				not self._activeYinYangHitboxes[animalId] then
				table.insert(candidates, animal)
			end
		end
	end

	if #candidates == 0 then return nil end
	return candidates[math.random(1, #candidates)]
end

function YinYangEvent:_hasYinYangTrait(animalTemplate)
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
		if trait == "YinYang" then
			return true
		end
	end

	return false
end

function YinYangEvent:_applyYinYangTrait(animalTemplate)
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
		if trait == "YinYang" then
			return
		end
	end

	table.insert(currentTraits, "YinYang")
	animalTemplate:SetAttribute("Traits", HttpService:JSONEncode(currentTraits))
end

return YinYangEvent