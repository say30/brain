--[[
  Extracted from: ServerScriptService.Services.EventService.Events.MatteoEvent
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")

local Packages = ReplicatedStorage:WaitForChild("Packages")
local Net = require(Packages.Net)
local Synchronizer = require(Packages.Synchronizer)

local DataManagment = require(ServerScriptService.Services.DataManagment)
local RoadAnimalService = require(ServerScriptService.Services.RoadAnimalService)
local Animals = require(ReplicatedStorage.Datas.Animals)
local RagdollModule = require(ReplicatedStorage.Packages.Ragdoll)

local MatteoEvent = {}
MatteoEvent.__index = MatteoEvent

function MatteoEvent.new(eventService)
	local self = setmetatable({}, MatteoEvent)
	self._eventService = eventService
	self._matteoSynchronizer = Synchronizer:Create("MatteoEvent", {
		TreePositions = {},
		IsRainbow = false
	})

	for _, player in pairs(Players:GetPlayers()) do
		self._matteoSynchronizer:AddListener(player)
	end

	Players.PlayerAdded:Connect(function(player)
		self._matteoSynchronizer:AddListener(player)
	end)

	Players.PlayerRemoving:Connect(function(player)
		self._matteoSynchronizer:RemoveListener(player)
	end)

	self._isActive = false
	self._treePositions = {}
	self._collectedTrees = {}

	self._collectTreeRemote = Net:RemoteFunction("EventService/Matteo/CollectTree")
	self._spawnEffectRemote = Net:RemoteEvent("EventService/Matteo/SpawnEffect")

	self._collectTreeRemote.OnServerInvoke = function(player, treeId)
		return self:_handleTreeCollection(player, treeId)
	end

	self._spawnEffectRemote.OnServerEvent:Connect(function(player)
		self:_handleSpawnEffect(player)
	end)

	return self
end

function MatteoEvent:Start(eventEntry)
	if self._isActive then
		return
	end

	self._isActive = true

	self:_generateTreePositions()

	local isRainbow = math.random() < 0.1

	eventEntry.data.TreePositions = self._treePositions
	eventEntry.data.IsRainbow = isRainbow

	local spawnTime = workspace:GetServerTimeNow() + 10
	for _, player in pairs(Players:GetPlayers()) do
		self._spawnEffectRemote:FireClient(player, spawnTime)
	end

	self._matteoSynchronizer:Set("TreePositions", self._treePositions)
	self._matteoSynchronizer:Set("IsRainbow", isRainbow)

	task.wait(8)

	self:_handleSpawnEffect()
end

function MatteoEvent:Stop(eventEntry)
	if not self._isActive then
		return
	end

	self._isActive = false

	self._matteoSynchronizer:Set("TreePositions", {})
	self._matteoSynchronizer:Set("IsRainbow", false)

	self._collectedTrees = {}
	self._treePositions = {}
end

function MatteoEvent:_generateTreePositions()
	self._treePositions = {}

	local treeCount = math.random(15, 25)

	local mapCenter = workspace:FindFirstChild("MapCenter")
	local baseplate = workspace.Map and workspace.Map:FindFirstChild("Baseplate")
	local road = workspace.Map and workspace.Map:FindFirstChild("Road")
	local plots = workspace:FindFirstChild("Plots")

	if not mapCenter or not baseplate then
		for i = 1, treeCount do
			self._treePositions[i] = Vector3.new(math.random(-50, 50), 5, math.random(-50, 50))
		end
		
		return
	end

	local baseplateSize = baseplate.Size
	local baseplatePos = baseplate.Position
	local minX = baseplatePos.X - baseplateSize.X/2
	local maxX = baseplatePos.X + baseplateSize.X/2
	local minZ = baseplatePos.Z - baseplateSize.Z/2
	local maxZ = baseplatePos.Z + baseplateSize.Z/2

	local roadBounds = {}
	if road then
		local roadSize = road.Size
		local roadPos = road.Position
		roadBounds = {
			minX = roadPos.X - roadSize.X/2 - 10,
			maxX = roadPos.X + roadSize.X/2 + 10,
			minZ = roadPos.Z - roadSize.Z/2 - 10,
			maxZ = roadPos.Z + roadSize.Z/2 + 10
		}
	end

	local plotBounds = {}
	if plots then
		for _, plot in pairs(plots:GetChildren()) do
			if plot:IsA("Model") then
				local plotCFrame, plotSize = plot:GetBoundingBox()
				table.insert(plotBounds, {
					minX = plotCFrame.Position.X - plotSize.X/2 - 5,
					maxX = plotCFrame.Position.X + plotSize.X/2 + 5,
					minZ = plotCFrame.Position.Z - plotSize.Z/2 - 5,
					maxZ = plotCFrame.Position.Z + plotSize.Z/2 + 5
				})
			end
		end
	end

	local workspaceModelBounds = {}
	for _, child in pairs(workspace:GetChildren()) do
		if child:IsA("Model") and child ~= plots then
			local modelCFrame, modelSize = child:GetBoundingBox()
			table.insert(workspaceModelBounds, {
				minX = modelCFrame.Position.X - modelSize.X/2 - 3,
				maxX = modelCFrame.Position.X + modelSize.X/2 + 3,
				minZ = modelCFrame.Position.Z - modelSize.Z/2 - 3,
				maxZ = modelCFrame.Position.Z + modelSize.Z/2 + 3
			})
		end
	end

	local function findGroundY(x, z)
		local rayOrigin = Vector3.new(x, 100, z)
		local rayDirection = Vector3.new(0, -200, 0)

		local raycastParams = RaycastParams.new()
		raycastParams.FilterType = Enum.RaycastFilterType.Exclude
		raycastParams.FilterDescendantsInstances = {}

		local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)

		if raycastResult then
			return raycastResult.Position.Y
		else
			local fallbackY = baseplatePos.Y + baseplateSize.Y/2 + 1
			return fallbackY
		end
	end

	local attempts = 0
	local maxAttempts = treeCount * 10

	for i = 1, treeCount do
		local validPosition = false
		local position

		while not validPosition and attempts < maxAttempts do
			attempts = attempts + 1

			local x = math.random(minX + 20, maxX - 20)
			local z = math.random(minZ + 20, maxZ - 20)

			local groundY = findGroundY(x, z)
			position = Vector3.new(x, groundY, z)

			validPosition = true

			if roadBounds.minX and x >= roadBounds.minX and x <= roadBounds.maxX and z >= roadBounds.minZ and z <= roadBounds.maxZ then
				validPosition = false
			end

			for _, bounds in pairs(plotBounds) do
				if x >= bounds.minX and x <= bounds.maxX and z >= bounds.minZ and z <= bounds.maxZ then
					validPosition = false
					break
				end
			end

			for _, bounds in pairs(workspaceModelBounds) do
				if x >= bounds.minX and x <= bounds.maxX and z >= bounds.minZ and z <= bounds.maxZ then
					validPosition = false
					break
				end
			end

			for j = 1, i - 1 do
				if self._treePositions[j] then
					local distance = (position - self._treePositions[j]).Magnitude
					if distance < 15 then
						validPosition = false
						break
					end
				end
			end
		end

		if validPosition then
			self._treePositions[i] = position
		else
			local fallbackX = mapCenter.Position.X + math.random(-30, 30)
			local fallbackZ = mapCenter.Position.Z + math.random(-30, 30)
			local fallbackY = findGroundY(fallbackX, fallbackZ)
			self._treePositions[i] = Vector3.new(fallbackX, fallbackY, fallbackZ)
		end
	end
end

function MatteoEvent:_handleTreeCollection(player, treeId)
	if not self._isActive then
		return false
	end

	if player.Character and player.Character:GetAttribute("Matteo_CollectedTree") then
		return false
	end

	if not self._treePositions[treeId] then
		return false
	end

	if self._collectedTrees[treeId] then
		return false
	end

	self._collectedTrees[treeId] = true
	player.Character:SetAttribute("Matteo_CollectedTree", true)

	local activeEvents = Synchronizer:Get("ActiveEvents")
	
	if activeEvents then
		for i, eventData in pairs(activeEvents) do
			if eventData.eventName == "Matteo" and eventData.data and eventData.data.TreePositions then
				eventData.data.TreePositions[treeId] = nil
				Synchronizer:Set("ActiveEvents", activeEvents)
				break
			end
		end
	end

	local treeToolSuccess = self:_giveTreeTool(player, treeId)
	
	if not treeToolSuccess then
	end

	return true
end

local function createHitbox(character)
	local root = character:FindFirstChild("HumanoidRootPart")
	if not root then return end
	local size = Vector3.new(5,5,5)
	local cframe = root.CFrame * CFrame.new(0,0,-3)
	return Region3.new(cframe.Position - size/2, cframe.Position + size/2)
end

local function getTargets(character)
	local region = createHitbox(character)
	if not region then return {} end
	local parts = workspace:FindPartsInRegion3(region, character, 10)
	local t = {}
	for _, part in ipairs(parts) do
		local char = part.Parent
		local h = char:FindFirstChild("Humanoid")
		if h and h.Health > 0 and char ~= character and not t[char] then
			t[char] = h
		end
	end
	return t
end

local cooldowns = {}

local function applySlap(player, target, direction)
	local h = target:FindFirstChild("Humanoid")
	local root = target:FindFirstChild("HumanoidRootPart")
	if not h or not root or h.Health <= 0 then return end

	h:TakeDamage(0)
	local force = 900 * 0.10
	local upwardForce = Vector3.new(0, 10, 0) 
	local bv = Instance.new("BodyVelocity")
	bv.Velocity = direction.Unit * force + upwardForce 
	bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
	bv.Parent = root
	local targetPlayer = Players:GetPlayerFromCharacter(target)
	if targetPlayer then
		targetPlayer:SetAttribute("Stealing", false)
	end
	game.Debris:AddItem(bv, 0.2)
	RagdollModule.TimedRagdoll(target, 3)
end

local animation = Instance.new("Animation")
animation.AnimationId = "rbxassetid://101980678952226"
local animationTrack

function MatteoEvent:_giveTreeTool(player, treeId)
	local backpack = player:FindFirstChild("Backpack")
	
	if not backpack then
		return false
	end


	local matteoModels = ReplicatedStorage:FindFirstChild("Models")
	if not matteoModels then
		return false
	end

	local eventsFolder = matteoModels:FindFirstChild("Events")
	
	if not eventsFolder then
		return false
	end

	local matteoFolder = eventsFolder:FindFirstChild("Matteo")
	
	if not matteoFolder then
		return false
	end

	local normalTrees = matteoFolder:FindFirstChild("NormalTrees")
	
	if not normalTrees then
		return false
	end

	local treeNames = {"Tree1", "Tree2", "Tree3", "Tree4", "Tree5"}
	local randomTreeName = treeNames[math.random(1, #treeNames)]
	local treeModel = normalTrees:FindFirstChild(randomTreeName)

	if not treeModel then
		return false
	end

	local treeTool = Instance.new("Tool")
	treeTool.Name = "Tree"
	treeTool.RequiresHandle = true

	local treeClone = treeModel:Clone()

	local handle = treeClone:FindFirstChild("Handle")
	if not handle then
		handle = Instance.new("Part")
		handle.Name = "Handle"
		handle.Size = Vector3.new(0.2, 1, 0.2)
		handle.Material = Enum.Material.Wood
		handle.BrickColor = BrickColor.new("Brown")
		handle.CanCollide = false
		handle.Anchored = false
		handle.Parent = treeTool
	else
		handle.CanCollide = false
		handle.Anchored = false
		handle.Parent = treeTool
	end

	local function moveAndWeldPart(part)
		if part:IsA("BasePart") and part ~= handle then
			part.CanCollide = false
			part.Anchored = false
			part.Parent = treeTool

			local weld = Instance.new("WeldConstraint")
			weld.Part0 = handle
			weld.Part1 = part
			weld.Parent = handle
		end
	end

	for _, part in pairs(treeClone:GetDescendants()) do
		moveAndWeldPart(part)
	end

	treeClone:Destroy()
	treeTool.Parent = backpack
	treeTool.Activated:Connect(function()
		local char = treeTool.Parent
		local player = Players:GetPlayerFromCharacter(char)
		if not player or not char:FindFirstChild("HumanoidRootPart") then return end
		local last = cooldowns[player.UserId] or 0
		if os.clock() - last < 2 then return end
		cooldowns[player.UserId] = os.clock()

		local humanoid = char:FindFirstChild("Humanoid")
		if humanoid then
			animationTrack = humanoid:LoadAnimation(animation)
			animationTrack:Play()
		end

		local dir = char.HumanoidRootPart.CFrame.LookVector
		for target in pairs(getTargets(char)) do
			applySlap(player, target, dir)
		end
	end)
	
	return true
end

function MatteoEvent:_handleSpawnEffect(player)
	if not self._isActive then
		return
	end

	local matteoIndex = self:_getMatteoAnimalIndex()
	if matteoIndex then
		local roadAnimalService = _G.RoadAnimalService
		local spawnedAnimal = roadAnimalService.Spawner:SpawnSpecificAnimal(matteoIndex, nil)
	else
		warn("[MatteoEvent] Could not find Matteo animal index")
	end
end

function MatteoEvent:_getMatteoAnimalIndex()
	for index, animalData in pairs(Animals) do
		if animalData.DisplayName == "Matteo" then
			return index
		end
	end
	
	return nil
end

return MatteoEvent