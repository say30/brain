--[[
  Extracted from: ServerScriptService.Services.EventService.Events.Water
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

--[[
Water Event:
- Sólo el animal impactado por StruckVFX recibe el trait "Shark Fin".
- El evento pone de noche y atmósfera azul; vuelve a la normalidad al terminar.
- Reproduce Workspace.Sound.Events.Water2.WaterMusic mientras está activo el evento y lo detiene al terminar.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")
local HttpService = game:GetService("HttpService")
local ServerStorage = game:GetService("ServerStorage")
local Net = require(ReplicatedStorage.Packages.Net)

local WaterHitRemote = Net:RemoteEvent("EventService/Water/Burst")

local COOLDOWN_TIME = 0

local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local NPC_NAME = "Orcalero Orcala"
local NUM_ORCALEROS = 3
local SHARKS_FOLDER_NAME = "Sharks"
local ROUTE_FOLDER = Workspace:WaitForChild("Events"):WaitForChild("Water")
local ORCALERO_SPEED = 4.2

local ORIGINAL_GRAVITY = Workspace.Gravity
local ORIGINAL_AMBIENT = Lighting.Ambient
local ORIGINAL_OUTDOOR_AMBIENT = Lighting.OutdoorAmbient
local ORIGINAL_CLOCKTIME = Lighting.ClockTime
local BLUE_AMBIENT = Color3.fromRGB(50, 120, 200)
local BLUE_OUTDOOR = Color3.fromRGB(80, 120, 220)
local LOW_GRAVITY = 50
local NIGHT_CLOCKTIME = 0

local NPCState = {}
local BodyMoverRefs = {}
local SpawnedNPCs = {}
local npcShootConnections = {}
local floatTasks = {}

-- --- MUSICA ---
local function playWaterMusic()
	local music = Workspace:FindFirstChild("Sound")
		and Workspace.Sound:FindFirstChild("Events")
		and Workspace.Sound.Events:FindFirstChild("Water2")
		and Workspace.Sound.Events.Water2:FindFirstChild("WaterMusic")
	if music then
		music.Looped = true
		music.Volume = 1
		music:Play()
	end
end

local function stopWaterMusic()
	local music = Workspace:FindFirstChild("Sound")
		and Workspace.Sound:FindFirstChild("Events")
		and Workspace.Sound.Events:FindFirstChild("Water2")
		and Workspace.Sound.Events.Water2:FindFirstChild("WaterMusic")
	if music then
		music:Stop()
	end
end

local function getRouteParts()
	local parts = {}
	for i = 1, 8 do
		local part = ROUTE_FOLDER:FindFirstChild("Part"..i)
		if part and part:IsA("BasePart") then
			table.insert(parts, part)
		end
	end
	return parts
end

local function getAnimals()
	local movingAnimalsFolder = Workspace:FindFirstChild("MovingAnimals")
	local animals = {}
	if movingAnimalsFolder then
		for _, animal in ipairs(movingAnimalsFolder:GetChildren()) do
			if animal:IsA("Model") and animal.PrimaryPart then
				table.insert(animals, animal)
			end
		end
	end
	return animals
end

local function setAtmosphere(activate)
	if activate then
		Lighting.Ambient = BLUE_AMBIENT
		Lighting.OutdoorAmbient = BLUE_OUTDOOR
		Workspace.Gravity = LOW_GRAVITY
		Lighting.ClockTime = NIGHT_CLOCKTIME
	else
		Lighting.Ambient = ORIGINAL_AMBIENT
		Lighting.OutdoorAmbient = ORIGINAL_OUTDOOR_AMBIENT
		Workspace.Gravity = ORIGINAL_GRAVITY
		Lighting.ClockTime = ORIGINAL_CLOCKTIME
	end
end

local function spawnNPCs()
	local sharksFolder = Workspace:FindFirstChild(SHARKS_FOLDER_NAME)
	if not sharksFolder then
		sharksFolder = Instance.new("Folder")
		sharksFolder.Name = SHARKS_FOLDER_NAME
		sharksFolder.Parent = Workspace
	end
	SpawnedNPCs = {}
	local templateFolder = ServerStorage:FindFirstChild(SHARKS_FOLDER_NAME)
	if not templateFolder then return sharksFolder end
	for i = 1, NUM_ORCALEROS do
		local template = templateFolder:FindFirstChild(NPC_NAME)
		if template then
			local clone = template:Clone()
			clone.Name = NPC_NAME .. tostring(i)
			clone.Parent = sharksFolder
			SpawnedNPCs[clone.Name] = clone
		end
	end
	return sharksFolder
end

local function setupFloatPhysics(npcModel)
	local root = npcModel and npcModel.PrimaryPart
	if not root then return end
	for _, child in ipairs(root:GetChildren()) do
		if child:IsA("BodyPosition") or child:IsA("BodyGyro") then
			child:Destroy()
		end
	end
	root.Anchored = false
	root.CanCollide = false
	root.Massless = true
	local bodyPos = Instance.new("BodyPosition")
	bodyPos.MaxForce = Vector3.new(1e7, 1e7, 1e7)
	bodyPos.Position = root.Position
	bodyPos.D = 900
	bodyPos.P = 1000
	bodyPos.Parent = root
	local bodyGyro = Instance.new("BodyGyro")
	bodyGyro.MaxTorque = Vector3.new(1e7, 1e7, 1e7)
	bodyGyro.CFrame = root.CFrame
	bodyGyro.P = 4000
	bodyGyro.Parent = root
	BodyMoverRefs[npcModel] = {bodyPos = bodyPos, bodyGyro = bodyGyro}
end

local function cleanupFloatPhysics(npcModel)
	local root = npcModel and npcModel.PrimaryPart
	if not root then return end
	for _, child in ipairs(root:GetChildren()) do
		if child:IsA("BodyPosition") or child:IsA("BodyGyro") then
			child:Destroy()
		end
	end
	BodyMoverRefs[npcModel] = nil
end

local function floatBetweenRoutes(npcModel)
	if not npcModel or not npcModel.PrimaryPart then return end
	setupFloatPhysics(npcModel)
	local root = npcModel.PrimaryPart
	local routes = getRouteParts()
	if #routes == 0 then return end

	local currentRouteIndex = math.random(1, #routes)
	root.Position = routes[currentRouteIndex].Position
	local mover = BodyMoverRefs[npcModel] and BodyMoverRefs[npcModel].bodyPos
	local gyro = BodyMoverRefs[npcModel] and BodyMoverRefs[npcModel].bodyGyro

	while npcModel.Parent do
		local nextRouteIndex
		repeat
			nextRouteIndex = math.random(1, #routes)
		until nextRouteIndex ~= currentRouteIndex

		local targetPos = routes[nextRouteIndex].Position
		local startPos = root.Position
		local totalDist = (targetPos - startPos).Magnitude
		local moveSpeed = ORCALERO_SPEED
		local travelTime = totalDist / moveSpeed
		local swimSeed = math.random() * 1000
		local timeElapsed = 0

		while timeElapsed < travelTime and npcModel.Parent do
			local dt = RunService.Heartbeat:Wait()
			timeElapsed = timeElapsed + dt
			local alpha = math.clamp(timeElapsed / travelTime, 0, 1)

			local newPos = startPos:Lerp(targetPos, alpha)
			local swimY = math.sin((timeElapsed + swimSeed) * 1.1) * 1.4
			local swimX = math.sin((timeElapsed + swimSeed) * 0.6) * 0.7
			local swimPos = newPos + Vector3.new(swimX, swimY, 0)
			if mover then mover.Position = swimPos end

			local lookDir = (targetPos - root.Position)
			if lookDir.Magnitude > 0.01 then
				lookDir = lookDir.Unit
				local targetCFrame = CFrame.new(root.Position, root.Position + lookDir)
				local wiggleAngle = math.sin((timeElapsed + swimSeed) * 1.7) * math.rad(6)
				local wiggleCFrame = CFrame.Angles(0, wiggleAngle, 0)
				if gyro then
					gyro.CFrame = targetCFrame * wiggleCFrame
				end
			end
		end

		currentRouteIndex = nextRouteIndex
	end
	cleanupFloatPhysics(npcModel)
end

local function activateNPCs()
	local sharksFolder = spawnNPCs()
	local routes = getRouteParts()
	local usedIndices = {}
	local i = 1
	for npcName, npc in pairs(SpawnedNPCs) do
		if npc and npc.PrimaryPart then
			local routeIndex
			repeat
				routeIndex = math.random(1, #routes)
			until not usedIndices[routeIndex]
			usedIndices[routeIndex] = true
			npc.PrimaryPart.Position = routes[routeIndex].Position
			NPCState[npcName] = {Model = npc, OriginalPosition = routes[routeIndex].Position}
			local taskObj = task.spawn(function()
				floatBetweenRoutes(npc)
			end)
			table.insert(floatTasks, taskObj)
		end
		i = i + 1
	end
end

local function deactivateNPCs()
	for npcName, data in pairs(NPCState) do
		local npc = data.Model
		if npc and data.OriginalPosition then
			cleanupFloatPhysics(npc)
			npc.PrimaryPart.Position = data.OriginalPosition
			npc:Destroy()
		end
	end
	NPCState = {}
	for _, conn in ipairs(npcShootConnections) do
		if conn then conn:Disconnect() end
	end
	npcShootConnections = {}
	for _, taskObj in ipairs(floatTasks) do
		if taskObj then task.cancel(taskObj) end
	end
	floatTasks = {}
	local sharksFolder = Workspace:FindFirstChild(SHARKS_FOLDER_NAME)
	if sharksFolder then sharksFolder:Destroy() end
end

local function struckVFX(animal)
	local assetsFolder = ReplicatedStorage:FindFirstChild("Assets")
	local waterFolder = assetsFolder and assetsFolder:FindFirstChild("Water")
	local struckTemplate = waterFolder and waterFolder:FindFirstChild("StruckVFX")
	if struckTemplate and animal.PrimaryPart then
		local vfx = struckTemplate:Clone()
		vfx.Parent = animal.PrimaryPart
		if vfx:IsA("ParticleEmitter") then
			vfx:Emit(vfx:GetAttribute("EmitCount") or 100)
		end
		game:GetService("Debris"):AddItem(vfx, 1)
	end
end

local function npcShoot(npcModel)
	local function shoot()
		local animals = getAnimals()
		if #animals > 0 and npcModel and npcModel.PrimaryPart then
			local target = animals[math.random(1, #animals)]
			WaterHitRemote:FireAllClients(target.Name, npcModel.Name)
			struckVFX(target)
			local traitsJson = target:GetAttribute("Traits")
			local traits = {}
			if traitsJson then
				local ok, decoded = pcall(function() return HttpService:JSONDecode(traitsJson) end)
				if ok and type(decoded) == "table" then traits = decoded end
			end
			if not table.find(traits, "Shark Fin") then
				table.insert(traits, "Shark Fin")
				target:SetAttribute("Traits", HttpService:JSONEncode(traits))
			end
		end
	end
	local conn = RunService.Heartbeat:Connect(function(dt)
		if math.random() < dt / 2 then
			shoot()
		end
	end)
	table.insert(npcShootConnections, conn)
end

local WaterEvent = {}
WaterEvent.__index = WaterEvent

function WaterEvent.new(eventService)
	local self = setmetatable({}, WaterEvent)
	self.eventService = eventService
	self.isActive = false
	self.eventEntry = nil
	self.connections = {}
	self.lastStrike = 0
	return self
end

function WaterEvent:Start(eventEntry)
	self.eventEntry = eventEntry
	self.isActive = true
	self.lastStrike = workspace:GetServerTimeNow()

	print("[WaterEvent] Starting Water event on server")

	self:_startWaterLogic()

	local startWaterRemote = Net:RemoteEvent("EventService/Water/Start")
	for _, player in pairs(Players:GetPlayers()) do
		startWaterRemote:FireClient(player, eventEntry)
	end

	local connection = Players.PlayerAdded:Connect(function(player)
		if self.isActive then
			startWaterRemote:FireClient(player, self.eventEntry)
		end
	end)
	table.insert(self.connections, connection)

	local assetsFolder = ReplicatedStorage:FindFirstChild("Assets")
	if assetsFolder then
		local WaterWeatherFolder = assetsFolder:FindFirstChild("WaterEvent")
		if WaterWeatherFolder then
			local WaterWeatherClone = WaterWeatherFolder:Clone()
			WaterWeatherClone.Name = "WaterEvent_Active"
			WaterWeatherClone.Parent = workspace

			task.defer(function()
				local WaterWeatherActive = workspace:FindFirstChild("WaterEvent_Active")
				if WaterWeatherActive then
					for _, desc in ipairs(WaterWeatherActive:GetDescendants()) do
						if desc:IsA("ParticleEmitter") then
							desc:Emit(desc:GetAttribute("EmitCount") or 100)
						end
					end
				end
			end)
		end
	end

	setAtmosphere(true)
	playWaterMusic()
	activateNPCs()
	for npcName, data in pairs(NPCState) do
		npcShoot(data.Model)
	end
end

function WaterEvent:Stop(eventEntry)
	self.isActive = false
	print("[WaterEvent] Stopping Water event on server")

	for _, connection in pairs(self.connections) do
		if connection then
			connection:Disconnect()
		end
	end
	self.connections = {}

	local stopWaterRemote = Net:RemoteEvent("EventService/Water/Stop")
	for _, player in pairs(Players:GetPlayers()) do
		stopWaterRemote:FireClient(player)
	end

	self.eventEntry = nil

	local WaterWeatherActive = workspace:FindFirstChild("WaterEvent_Active")
	if WaterWeatherActive then
		WaterWeatherActive:Destroy()
	end

	setAtmosphere(false)
	stopWaterMusic()
	deactivateNPCs()
end

function WaterEvent:_startWaterLogic()
	local connection
	connection = RunService.Heartbeat:Connect(function()
		if not self.isActive then
			connection:Disconnect()
			return
		end
		local currentTime = workspace:GetServerTimeNow()
		if (currentTime - self.lastStrike) >= COOLDOWN_TIME then
			if self:_strikeOneAnimal() then
				self.lastStrike = currentTime
			end
		end
	end)
	table.insert(self.connections, connection)
end

function WaterEvent:_addWetTrait(animal)
	local traitsJson = animal:GetAttribute("Traits")
	local traits = {}
	if traitsJson then
		local ok, decoded = pcall(function() return HttpService:JSONDecode(traitsJson) end)
		if ok and type(decoded) == "table" then traits = decoded end
	end
	for _, trait in ipairs(traits) do
		if trait == "Shark Fin" then return end
	end
	table.insert(traits, "Shark Fin")
	animal:SetAttribute("Traits", HttpService:JSONEncode(traits))
end

function WaterEvent:_hasWetTrait(animal)
	local traitsJson = animal:GetAttribute("Traits")
	local traits = {}
	if traitsJson then
		local ok, decoded = pcall(function() return HttpService:JSONDecode(traitsJson) end)
		if ok and type(decoded) == "table" then traits = decoded end
	end
	for _, trait in ipairs(traits) do
		if trait == "Shark Fin" then
			return true
		end
	end
	return false
end

function WaterEvent:_pickTargetAnimals()
	local movingAnimalsFolder = workspace:FindFirstChild("MovingAnimals")
	local candidates = {}
	for _, animal in ipairs(CollectionService:GetTagged("Animal")) do
		if animal.Parent == movingAnimalsFolder and animal.PrimaryPart
			and string.find(animal.Name, "RoadAnimal_")
			and not self:_hasWetTrait(animal) then
			table.insert(candidates, animal)
		end
	end
	return candidates
end

function WaterEvent:_strikeOneAnimal()
	local candidates = self:_pickTargetAnimals()
	if #candidates == 0 then return false end

	local idx = math.random(1, #candidates)
	local animal = candidates[idx]
	self:_impactAnimal(animal)
	return true
end

function WaterEvent:_impactAnimal(animal)
	if not animal or not animal.Parent or not animal.PrimaryPart then return end

	local npcIdx = math.random(1, NUM_ORCALEROS)
	local npcName = NPC_NAME .. tostring(npcIdx)
	WaterHitRemote:FireAllClients(animal.Name, npcName)
	struckVFX(animal)
	self:_addWetTrait(animal)
end

local Water = {}
function Water.OnLoad(eventService)
	return WaterEvent.new(eventService)
end

return Water