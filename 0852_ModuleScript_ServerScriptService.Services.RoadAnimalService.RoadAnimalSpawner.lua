--[[
  Extracted from: ServerScriptService.Services.RoadAnimalService.RoadAnimalSpawner
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local Animals = require(ReplicatedStorage.Datas.Animals)
local Mutations = require(ReplicatedStorage.Datas.Mutations)
local Game = require(ReplicatedStorage.Datas.Game)
local NumberUtils = require(ReplicatedStorage.Utils.NumberUtils)
local Net = require(ReplicatedStorage.Packages.Net)

local RoadAnimalSpawner = {}
RoadAnimalSpawner.__index = RoadAnimalSpawner

local ANIMALS_WITH_EFFECTS = {
	["Matteo"] = "Matteo",
	["Karkerkar Kurkur"] = "Karkerkar Kurkur",
	["Tipi Topi Taco"] = "Taco",
	["Los Spyderinis"] = "Sammyni Spyderini",
	["Strawberry Elephant "] = "Strawberry"
}

local ChatEvent = Net:RemoteEvent("ChatService/ChatMessage")

function RoadAnimalSpawner.new(config)
	local self = setmetatable({}, RoadAnimalSpawner)

	self.Config = config
	self.ActiveSpawns = 0
	self.IsSpawning = false
	self.PathfinderModule = nil
	self.AnimalSpawnedCallback = nil
	self.PityDisplay = nil

	self.SpawnQueue = {}
	self.QueueProcessing = false
	self.LastSpawnTime = 0

	self._spawnMutex = false

	self.SpawnEffectRemote = Net:RemoteEvent("GameService/SpawnEffect")

	self.PendingDelayedSpawn = nil
	self.DelayedSpawnTime = 0

	return self
end

function RoadAnimalSpawner:_triggerSpawnEffect(animalTemplate, animalData)
	local animalName = animalData.DisplayName or animalData.Name
	local effectName = ANIMALS_WITH_EFFECTS[animalName]

	if effectName and self.SpawnEffectRemote then
		-- Get the spawn position
		local spawnPosition = animalTemplate.PrimaryPart and animalTemplate.PrimaryPart.Position or Vector3.new(0, 0, 0)

		self.SpawnEffectRemote:FireAllClients(effectName, spawnPosition)

		if self.Config.DEBUG.PRINT_SPAWN_INFO then
			print(("✨ VFX DEBUG: Triggered %s effect for %s at position %s"):format(effectName, animalName, tostring(spawnPosition)))
		end
	end
end

-- NEW FUNCTION: SpawnAnimalChances
function RoadAnimalSpawner:SpawnAnimalChances(animalChances, ownerId, specificMutation)
	-- Validate input
	if type(animalChances) ~= "table" or next(animalChances) == nil then
		warn("SpawnAnimalChances: animalChances must be a non-empty table")
		return nil
	end

	-- Convert animal names to indices and validate
	local validatedChances = {}
	for animalName, weight in pairs(animalChances) do
		if type(weight) ~= "number" or weight <= 0 then
			warn(("SpawnAnimalChances: Invalid weight for animal '%s'. Weight must be a positive number."):format(animalName))
			continue
		end

		-- Find animal index by name
		local animalIndex = nil
		for index, animalData in pairs(Animals) do
			if animalData.DisplayName == animalName or animalData.Name == animalName then
				animalIndex = index
				break
			end
		end

		if not animalIndex then
			warn(("SpawnAnimalChances: Animal '%s' not found in Animals data"):format(animalName))
			continue
		end

		-- Check if animal can spawn on road
		local animalData = Animals[animalIndex]
		if not animalData.RoadWeight or animalData.RoadWeight <= 0 then
			warn(("SpawnAnimalChances: Animal '%s' cannot spawn on road (RoadWeight is 0 or missing)"):format(animalName))
			continue
		end

		table.insert(validatedChances, {
			index = animalIndex,
			weight = weight,
			data = animalData,
			name = animalName
		})

		if self.Config.DEBUG.PRINT_SPAWN_INFO then
			print(("🎲 CHANCES DEBUG: Added %s with %d%% chance"):format(animalName, weight))
		end
	end

	if #validatedChances == 0 then
		warn("SpawnAnimalChances: No valid animals found to spawn")
		return nil
	end

	-- Select animal based on weighted random
	local selectedAnimal = self:_selectWeightedRandom(validatedChances)
	if not selectedAnimal then
		warn("SpawnAnimalChances: Failed to select animal")
		return nil
	end

	if self.Config.DEBUG.PRINT_SPAWN_INFO then
		print(("🎲 CHANCES DEBUG: Selected %s for spawning"):format(selectedAnimal.name or selectedAnimal.data.DisplayName))
	end

	-- Check for spawn delay
	local animalData = Animals[selectedAnimal.index]
	if animalData.SpawnDelay and animalData.SpawnDelay > 0 then
		if self.Config.DEBUG.PRINT_SPAWN_INFO then
			print(("⏰ CHANCES + DELAY DEBUG: Animal %s has spawn delay of %d seconds"):format(animalData.DisplayName, animalData.SpawnDelay))
		end

		-- Handle delayed spawn
		task.spawn(function()
			task.wait(animalData.SpawnDelay)
			self:SpawnSpecificAnimal(selectedAnimal.index, ownerId, specificMutation)
		end)

		return true -- Return true to indicate spawn was queued
	end

	-- Spawn immediately
	return self:SpawnSpecificAnimal(selectedAnimal.index, ownerId, specificMutation)
end

-- Rest of your existing methods remain the same...
function RoadAnimalSpawner:SetPathfinder(pathfinder)
	self.PathfinderModule = pathfinder
end

function RoadAnimalSpawner:SetAnimalSpawnedCallback(callback)
	self.AnimalSpawnedCallback = callback
end

function RoadAnimalSpawner:SetPityDisplay(pityDisplay)
	self.PityDisplay = pityDisplay
end

function RoadAnimalSpawner:StartSpawning()
	if self.IsSpawning then return end
	self.IsSpawning = true

	task.spawn(function()
		while self.IsSpawning do
			local ok, err = pcall(function()
				if self.ActiveSpawns < self.Config.SPAWN_SETTINGS.MAX_ANIMALS_ON_ROAD then
					self:_spawnRandomAnimal()
				end
			end)
			if not ok then
				warn("[RoadAnimalSpawner] Spawn loop error:", err)
			end
			task.wait(self.Config.SPAWN_SETTINGS.SPAWN_COOLDOWN)
		end
	end)
end

function RoadAnimalSpawner:StopSpawning()
	self.IsSpawning = false
end

function RoadAnimalSpawner:_spawnRandomAnimal()
	if self._spawnMutex then return end
	self._spawnMutex = true

	-- Pity check first
	local pittySpawn
	if self.PityDisplay then
		pittySpawn = self:_checkForPittySpawn()
	end

	if pittySpawn then
		self._spawnMutex = false
		return self:_spawnGuaranteedAnimal(pittySpawn)
	end

	-- Select weighted animal
	local weightedAnimals = {}
	for animalIndex, animalData in pairs(Animals) do
		if animalData.RoadWeight and animalData.RoadWeight > 0 then
			table.insert(weightedAnimals, {index = animalIndex, weight = animalData.RoadWeight, data = animalData})
		end
	end

	if #weightedAnimals == 0 then
		self._spawnMutex = false
		return
	end

	local selectedAnimal = self:_selectWeightedRandom(weightedAnimals)
	local animalData = Animals[selectedAnimal.index]

	-- BLOCKING spawn delay
	if animalData.SpawnDelay and animalData.SpawnDelay > 0 then
		if self.Config.DEBUG.PRINT_SPAWN_INFO then
			print(("⏰ DELAY DEBUG: Waiting %.1fs to spawn %s"):format(animalData.SpawnDelay, animalData.DisplayName))
		end

		-- Wait **here**, completely blocking other spawns
		task.wait(animalData.SpawnDelay)
	end

	-- Spawn the animal
	self:SpawnSpecificAnimal(selectedAnimal.index)

	self._spawnMutex = false
end


function RoadAnimalSpawner:_checkForPittySpawn()
	if not self.PityDisplay or not self.PityDisplay.PityTimers then
		if self.Config.DEBUG.PRINT_SPAWN_INFO then
			print("🚨 PITY DEBUG: No PityDisplay or PityTimers available")
		end
		return nil
	end

	if self.Config.DEBUG.PRINT_SPAWN_INFO then
		print("🔍 PITY DEBUG: Checking pity timers...")
	end
	for rarityName, timerData in pairs(self.PityDisplay.PityTimers) do
		if self.Config.DEBUG.PRINT_SPAWN_INFO then
			print(("🔍 PITY DEBUG: %s timer - CurrentTime: %s"):format(rarityName, tostring(timerData.CurrentTime)))
		end
		if timerData.CurrentTime <= 0 then
			if self.Config.DEBUG.PRINT_SPAWN_INFO then
				print(("🎯 PITY DEBUG: Found expired timer for %s!"):format(rarityName))
			end
			return rarityName
		end
	end
	if self.Config.DEBUG.PRINT_SPAWN_INFO then
		print("🔍 PITY DEBUG: No expired timers found")
	end
	return nil
end

function RoadAnimalSpawner:_spawnGuaranteedAnimal(guaranteedRarity)
	if self.Config.DEBUG.PRINT_SPAWN_INFO then
		print(("🎯 PITY DEBUG: Attempting to spawn guaranteed %s animal"):format(guaranteedRarity))
	end
	local guaranteedAnimals = {}

	for animalIndex, animalData in pairs(Animals) do
		if animalData.Rarity == guaranteedRarity and animalData.RoadWeight and animalData.RoadWeight > 0 then
			table.insert(guaranteedAnimals, {
				index = animalIndex,
				weight = animalData.RoadWeight,
				data = animalData
			})
			if self.Config.DEBUG.PRINT_SPAWN_INFO then
				print(("🎯 PITY DEBUG: Found %s animal: %s (weight: %s)"):format(guaranteedRarity, animalData.DisplayName, animalData.RoadWeight))
			end
		end
	end

	if self.Config.DEBUG.PRINT_SPAWN_INFO then
		print(("🎯 PITY DEBUG: Found %d animals with rarity %s"):format(#guaranteedAnimals, guaranteedRarity))
	end

	if #guaranteedAnimals == 0 then
		warn(("No %s animals available for guaranteed spawn!"):format(guaranteedRarity))
		return nil
	end

	local selectedAnimal = self:_selectWeightedRandom(guaranteedAnimals)
	if self.Config.DEBUG.PRINT_SPAWN_INFO then
		print(("🎯 PITY DEBUG: Selected animal index: %s"):format(selectedAnimal.index))
	end

	if self.PityDisplay then
		self.PityDisplay:ResetTimer(guaranteedRarity)
		if self.Config.DEBUG.PRINT_SPAWN_INFO then
			print(("🔄 PITY DEBUG: Reset timer for %s"):format(guaranteedRarity))
		end
	end

	-- Check if the guaranteed animal has a spawn delay
	local animalData = Animals[selectedAnimal.index]
	if animalData.SpawnDelay and animalData.SpawnDelay > 0 then
		if self.Config.DEBUG.PRINT_SPAWN_INFO then
			print(("⏰ PITY + DELAY DEBUG: Guaranteed animal %s has spawn delay of %d seconds"):format(animalData.DisplayName, animalData.SpawnDelay))
		end

		-- Set up the delayed spawn for guaranteed animal with time
		self.PendingDelayedSpawn = selectedAnimal
		self.DelayedSpawnTime = os.clock() + animalData.SpawnDelay

		if self.Config.DEBUG.PRINT_SPAWN_INFO then
			print(("⏰ PITY + DELAY DEBUG: Queued guaranteed %s for delayed spawn, waiting %d seconds"):format(animalData.DisplayName, animalData.SpawnDelay))
		end

		return nil -- Don't spawn immediately
	end

	local result = self:SpawnSpecificAnimal(selectedAnimal.index)
	if self.Config.DEBUG.PRINT_SPAWN_INFO then
		print(("🎯 PITY DEBUG: Spawn result: %s"):format(result and "SUCCESS" or "FAILED"))
	end
	return result
end

function RoadAnimalSpawner:_selectWeightedRandom(weightedAnimals)
	local serverLuckMultiplier = self:_getServerLuckMultiplier()

	local sortedAnimals = {}
	for _, animal in ipairs(weightedAnimals) do
		table.insert(sortedAnimals, animal)
	end
	table.sort(sortedAnimals, function(a, b)
		return a.weight < b.weight
	end)

	local totalWeight = 0
	for _, animal in ipairs(sortedAnimals) do
		totalWeight = totalWeight + animal.weight
	end

	local randomValue = math.random() * totalWeight
	if serverLuckMultiplier > 1 then
		randomValue = randomValue / serverLuckMultiplier
		if self.Config.DEBUG.PRINT_SPAWN_INFO then
			print(("🍀 Server luck active (%dx) - adjusted random value for rarer animals"):format(serverLuckMultiplier))
		end
	end

	local currentWeight = 0
	for _, animal in ipairs(sortedAnimals) do
		currentWeight = currentWeight + animal.weight
		if randomValue <= currentWeight then
			if serverLuckMultiplier > 1 and self.Config.DEBUG.PRINT_SPAWN_INFO then
				print(("🍀 Server luck helped spawn: %s (weight: %s"):format(animal.index, animal.weight))
			end
			return animal
		end
	end

	return sortedAnimals[1]
end

function RoadAnimalSpawner:_spawnNow(animalIndex, ownerId, specificMutation)
	local animalData = Animals[animalIndex]
	if not animalData then
		warn("Failed to get animal data for index:", animalIndex)
		return nil
	end

	local isBloodmoonActive = ReplicatedStorage:GetAttribute("BloodmoonEvent") or false
	local isMoltenActive = ReplicatedStorage:GetAttribute("MoltenEvent") or false
	local isGalaxyActive = ReplicatedStorage:GetAttribute("GalaxyEvent") or false

	local mutationToUse = specificMutation

	if isMoltenActive then
		if math.random() <= 0.15 then
			mutationToUse = "Lava"
		end
	elseif isBloodmoonActive then
		mutationToUse = "Bloodrot"
	elseif isGalaxyActive then
		if math.random() <= 0.15 then
			mutationToUse = "Galaxy"
		end
	end

	local animalTemplate = self:_createAnimalTemplate(animalIndex, ownerId, mutationToUse)
	if not animalTemplate then
		warn("Failed to create animal template for:", animalData.DisplayName)
		return nil
	end

	local spawnCFrame = self:_getSpawnCFrame()
	animalTemplate:SetPrimaryPartCFrame(spawnCFrame)

	local movingAnimalsFolder = workspace:FindFirstChild("MovingAnimals")
	if not movingAnimalsFolder then
		movingAnimalsFolder = Instance.new("Folder")
		movingAnimalsFolder.Name = "MovingAnimals"
		movingAnimalsFolder.Parent = workspace
	end

	animalTemplate.Parent = movingAnimalsFolder

	self.ActiveSpawns = self.ActiveSpawns + 1

	animalTemplate.AncestryChanged:Connect(function()
		if not animalTemplate.Parent then
			self.ActiveSpawns = math.max(0, self.ActiveSpawns - 1)
		end
	end)

	CollectionService:AddTag(animalTemplate, "Animal")

	self:_triggerSpawnEffect(animalTemplate, animalData)

	if self.AnimalSpawnedCallback then
		self.AnimalSpawnedCallback(animalTemplate, animalData)
	end
	
	if animalData.Rarity == "Secret" then
		ChatEvent:FireAllClients("<font color='#000000'>[SERVER] A secret Brainrot has spawned!</font>")
	end
	
	if animalData.DisplayName == "Lucky Block" then
		if animalData.Rarity == "Admin" then
			ChatEvent:FireAllClients("<font color='#d1d202'>[SERVER] A </font><font color='#ff0000'>Admin Lucky Block</font><font color='#d1d202'> has spawned!</font>")
		elseif animalData.Rarity == "Brainrot God" then
			ChatEvent:FireAllClients("<font color='#22afe2'>[SERVER] A Brainrot God Lucky Block has spawned!</font>")
		end
	end

	if animalData.Rarity == "Brainrot God" or animalData.Rarity == "Secret" or animalData.Rarity == "Admin"  and animalData.LuckyBlock == nil then
		local soundController = require(ReplicatedStorage:WaitForChild("Controllers").SoundController)

		local soundPath = string.format("Sounds.Animals.%s", animalData.DisplayName)

		soundController.PlaySound(nil, soundPath, Vector3.new(-410.752, -8, -136))

		if self.Config.DEBUG.PRINT_SPAWN_INFO then
			print(("🔊 Playing sound for rare animal: %s"):format(animalData.DisplayName))
		end
	end
	
	if animalData.DisplayName == "Strawberry Elephant" then
		_G.EventService:StartEvent("Strawberry", 900)
	end

	return animalTemplate
end

function RoadAnimalSpawner:SpawnSpecificAnimal(animalIndex, ownerId, specificMutation)
	if self._spawnMutex then
		table.insert(self.SpawnQueue, 1, {
			animalIndex = animalIndex,
			ownerId = ownerId,
			specificMutation = specificMutation,
		})

		if not self.QueueProcessing then
			self.QueueProcessing = true
			task.spawn(function()
				local delaySeconds = (self.Config.SPAWN_SETTINGS and self.Config.SPAWN_SETTINGS.MANUAL_SPAWN_DELAY) or 3
				while #self.SpawnQueue > 0 do
					local timeSinceLast = os.clock() - self.LastSpawnTime
					if timeSinceLast < delaySeconds then
						task.wait(delaySeconds - timeSinceLast)
					end

					if self._spawnMutex or (self.ActiveSpawns >= self.Config.SPAWN_SETTINGS.MAX_ANIMALS_ON_ROAD) then
						task.wait(0.1)
						continue
					end

					local req = table.remove(self.SpawnQueue, 1)
					if req then
						self:_spawnNow(req.animalIndex, req.ownerId, req.specificMutation)
						self.LastSpawnTime = os.clock()
					end
				end
				self.QueueProcessing = false
			end)
		end

		return true
	end

	self._spawnMutex = true
	local delaySeconds = (self.Config.SPAWN_SETTINGS and self.Config.SPAWN_SETTINGS.MANUAL_SPAWN_DELAY) or 3

	local function canSpawn()
		return (#self.SpawnQueue == 0)
			and (os.clock() - self.LastSpawnTime >= delaySeconds)
			and (self.ActiveSpawns < self.Config.SPAWN_SETTINGS.MAX_ANIMALS_ON_ROAD)
			and self:_isSpawnAreaClear()
	end

	if canSpawn() then
		local template = self:_spawnNow(animalIndex, ownerId, specificMutation)
		if template then
			self.LastSpawnTime = os.clock()
		end
		self._spawnMutex = false
		return template
	end

	table.insert(self.SpawnQueue, 1, {
		animalIndex = animalIndex,
		ownerId = ownerId,
		specificMutation = specificMutation,
	})

	if not self.QueueProcessing then
		self.QueueProcessing = true
		task.spawn(function()
			while #self.SpawnQueue > 0 do
				local timeSinceLast = os.clock() - self.LastSpawnTime
				if timeSinceLast < delaySeconds then
					task.wait(delaySeconds - timeSinceLast)
				end

				if self._spawnMutex or (self.ActiveSpawns >= self.Config.SPAWN_SETTINGS.MAX_ANIMALS_ON_ROAD) then
					task.wait(0.1)
					continue
				end

				local req = table.remove(self.SpawnQueue, 1)
				if req then
					self:_spawnNow(req.animalIndex, req.ownerId, req.specificMutation)
					self.LastSpawnTime = os.clock()
				end
			end
			self.QueueProcessing = false
		end)
	end

	self._spawnMutex = false

	return true
end

function RoadAnimalSpawner:_createAnimalTemplate(animalIndex, ownerId, specificMutation)
	local templateInstance = ReplicatedStorage.Others.AnimalTemplate
	if not templateInstance then
		warn("AnimalTemplate not found in ReplicatedStorage.Others!")
		return nil
	end

	local animalTemplate = templateInstance:Clone()
	animalTemplate.Name = "RoadAnimal_" .. animalIndex .. "_" .. tick()

	animalTemplate:SetAttribute("Index", animalIndex)

	local selectedMutation = specificMutation or self:_selectRandomMutation()
	if selectedMutation then
		animalTemplate:SetAttribute("Mutation", selectedMutation)
		if self.Config.DEBUG.PRINT_SPAWN_INFO then
			print(("🧬 Spawned %s with %s mutation"):format(animalIndex, selectedMutation))
		end
	end

	if ownerId then
		animalTemplate:SetAttribute("OwnerId", tostring(ownerId))
		animalTemplate:SetAttribute("OwnershipTime", tick())
	end

	for _, part in animalTemplate:GetDescendants() do
		if part:IsA("BasePart") then
			part.CanCollide = false
		end
	end

	local primaryPart = animalTemplate.PrimaryPart
	if not primaryPart then
		warn("AnimalTemplate missing PrimaryPart!")
		return nil
	end

	local promptAttachment = primaryPart:FindFirstChild("PromptAttachment")
	if not promptAttachment then
		promptAttachment = Instance.new("Attachment")
		promptAttachment.Name = "PromptAttachment"
		promptAttachment.Parent = primaryPart
	end

	local proximityPrompt = promptAttachment:FindFirstChild("ProximityPrompt")
	if not proximityPrompt then
		proximityPrompt = Instance.new("ProximityPrompt")
		proximityPrompt.Name = "ProximityPrompt"
		proximityPrompt.Parent = promptAttachment
	end

	local animalData = Animals[animalIndex]
	proximityPrompt.ObjectText = ("%s $%s"):format(animalData.DisplayName, NumberUtils:ToString(animalData.Price or 0))
	proximityPrompt.ActionText = "Purchase"
	proximityPrompt.HoldDuration = self.Config.INTERACTION_SETTINGS.PROMPT_HOLD_DURATION
	proximityPrompt.MaxActivationDistance = self.Config.INTERACTION_SETTINGS.PROMPT_DISTANCE
	proximityPrompt.RequiresLineOfSight = false

	CollectionService:AddTag(proximityPrompt, "AnimalPurchasePrompt")

	return animalTemplate
end

function RoadAnimalSpawner:_selectRandomMutation()
	local isBloodmoonActive = ReplicatedStorage:GetAttribute("BloodmoonEvent") or false
	if isBloodmoonActive then
		return "Bloodrot"
	end
	local isRainbowEventActive = ReplicatedStorage:GetAttribute("RainbowEvent") or false
	local availableMutations = {}

	for mutationName, mutationData in pairs(Mutations) do
		if mutationName == "Bloodrot" and not isBloodmoonActive then
			continue
		end
		local weight = mutationData.Weight
		if mutationName == "Candy" then
			if not ReplicatedStorage:GetAttribute("CandyEvent") then
				continue
			end
			weight = weight or 30
		end
		if type(weight) ~= "number" or weight <= 0 then
			continue
		end
		if mutationName == "Rainbow" and isRainbowEventActive then
			weight = weight * 10
		end

		table.insert(availableMutations, {
			name = mutationName,
			weight = weight
		})
	end

	table.insert(availableMutations, {
		name = nil,
		weight = 80
	})

	if #availableMutations == 0 then
		return nil
	end

	return self:_selectWeightedRandomMutation(availableMutations)
end

function RoadAnimalSpawner:_selectWeightedRandomMutation(weightedMutations)
	local serverLuckMultiplier = self:_getServerLuckMultiplier()

	local sortedMutations = {}
	for _, mutation in ipairs(weightedMutations) do
		table.insert(sortedMutations, mutation)
	end
	table.sort(sortedMutations, function(a, b)
		if a.name == nil then return false end
		if b.name == nil then return true end
		return a.weight < b.weight
	end)

	local totalWeight = 0
	for _, mutation in ipairs(sortedMutations) do
		totalWeight = totalWeight + mutation.weight
	end

	local randomValue = math.random() * totalWeight
	if serverLuckMultiplier > 1 then
		randomValue = randomValue / serverLuckMultiplier
		if self.Config.DEBUG.PRINT_SPAWN_INFO then
			print(("🍀 Server luck active (%dx) - adjusted random value for rarer mutations"):format(serverLuckMultiplier))
		end
	end

	local currentWeight = 0
	for _, mutation in ipairs(sortedMutations) do
		currentWeight = currentWeight + mutation.weight
		if randomValue <= currentWeight then
			if serverLuckMultiplier > 1 and mutation.name and self.Config.DEBUG.PRINT_SPAWN_INFO then
				print(("🍀 Server luck helped spawn mutation: %s (weight: %s)"):format(mutation.name, mutation.weight))
			end
			return mutation.name
		end
	end

	return nil
end

function RoadAnimalSpawner:_getSpawnCFrame()
	local startPoint = self:_getSpawnPoint()
	if not startPoint then
		return CFrame.new(0, 10, 0)
	end

	local endPoint = self:_getEndPoint()
	if not endPoint then
		return CFrame.new(startPoint.Position)
	end

	local direction = (endPoint.Position - startPoint.Position)
	direction = Vector3.new(direction.X, 0, direction.Z).Unit

	return CFrame.new(startPoint.Position, startPoint.Position + direction)
end

function RoadAnimalSpawner:_getEndPoint()
	local road = workspace:FindFirstChild("Road")
	if not road then
		return nil
	end

	local endPoint = road:FindFirstChild("End")
	if not endPoint then
		return nil
	end

	return endPoint
end

function RoadAnimalSpawner:_getSpawnPosition()
	local spawnCFrame = self:_getSpawnCFrame()
	return spawnCFrame.Position
end

function RoadAnimalSpawner:_getSpawnPoint()
	local road = workspace:FindFirstChild("Road")
	if not road then
		warn("Road not found in workspace!")
		return nil
	end

	local startPoint = road:FindFirstChild("Start")
	if not startPoint then
		warn("Start point not found in Road!")
		return nil
	end

	return startPoint
end

function RoadAnimalSpawner:GetActiveSpawnCount()
	return self.ActiveSpawns
end

function RoadAnimalSpawner:IsSpawningActive()
	return self.IsSpawning
end

function RoadAnimalSpawner:_getServerLuckMultiplier()
	local multiplier = ReplicatedStorage:GetAttribute("ServerLuckMultiplier")
	if multiplier and multiplier > 1 then
		local endTime = ReplicatedStorage:GetAttribute("ServerLuckEndTime")
		if endTime and workspace:GetServerTimeNow() < endTime then
			return multiplier
		end
	end
	return 1
end

function RoadAnimalSpawner:_isSpawnAreaClear()
	local movingFolder = workspace:FindFirstChild("MovingAnimals")
	if not movingFolder then
		return true
	end

	local spawnPos = self:_getSpawnPosition()
	local halfSize = (self.Config.SPAWN_SETTINGS and self.Config.SPAWN_SETTINGS.SPAWN_CLEAR_SIZE) or 6
	local size = Vector3.new(halfSize, halfSize, halfSize)

	local params = OverlapParams.new()
	params.FilterType = Enum.RaycastFilterType.Include
	params.FilterDescendantsInstances = {movingFolder}

	local hitParts = workspace:GetPartBoundsInBox(CFrame.new(spawnPos), size, params)
	return #hitParts == 0
end

return RoadAnimalSpawner