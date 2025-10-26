--[[
  Extracted from: ServerScriptService.Services.EventService.Events.LaVaccaEvent
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")
local HttpService = game:GetService("HttpService")

local Packages = ReplicatedStorage:WaitForChild("Packages")
local Net = require(Packages.Net)
local Observers = require(Packages.Observers)
local Synchronizer = require(Packages.Synchronizer)

local Animals = require(ReplicatedStorage.Datas.Animals)

local LaVaccaEvent = {}
LaVaccaEvent.__index = LaVaccaEvent

function LaVaccaEvent.new(eventService)
	local self = setmetatable({}, LaVaccaEvent)
	self._eventService = eventService

	self._isActive = false
	self._triangleModels = {}
	self._cometTimer = nil
	self._eventConnection = nil
	self._continuousMonitoring = true
	self._animalsBeingHit = {}

	self._cometRemote = Net:RemoteEvent("EventService/LaVacca/Comet")

	self:_setupContinuousTriangleMonitoring()

	return self
end

function LaVaccaEvent:Start(eventEntry)
	if self._isActive then
		return
	end

	self._isActive = true

	self:_setupTriangleDetection()

	self._cometTimer = task.delay(15, function()
		self:_startCometAttacks()
	end)
end

function LaVaccaEvent:Stop(eventEntry)
	if not self._isActive then
		return
	end

	self._isActive = false

	if self._cometTimer then
		task.cancel(self._cometTimer)
		self._cometTimer = nil
	end

	if self._eventConnection then
		self._eventConnection:Disconnect()
		self._eventConnection = nil
	end

	for _, player in ipairs(Players:GetPlayers()) do
		if player.Character then
			CollectionService:RemoveTag(player.Character, "LaVaccaPlayerVFX")
		end
	end

	for _, model in ipairs(CollectionService:GetTagged("LaVaccaModel")) do
		CollectionService:RemoveTag(model, "LaVaccaModel")
		model:Destroy()
	end

	self._triangleModels = {}
	self._animalsBeingHit = {}
end

function LaVaccaEvent:_setupContinuousTriangleMonitoring()
	local triangleModels = {}
	local RunService = game:GetService("RunService")
	local connection

	local function checkAndStartEvent()
		if self._isActive then 
			return 
		end

		local allModelsPresent = triangleModels[1] and triangleModels[2] and triangleModels[3]
		if not allModelsPresent then
			local missing = {}
			for i = 1, 3 do
				if not triangleModels[i] then
					table.insert(missing, tostring(i))
				end
			end
			return
		end

		local positions = {}
		local maxAllowedDistance = 35
		local minAllowedDistance = 5

		for i = 1, 3 do
			local model = triangleModels[i]
			if model and model.PrimaryPart then
				positions[i] = model.PrimaryPart.Position
			else
				return
			end
		end

		local dist12 = (positions[1] - positions[2]).Magnitude
		local dist23 = (positions[2] - positions[3]).Magnitude
		local dist31 = (positions[3] - positions[1]).Magnitude
		local avgDistance = (dist12 + dist23 + dist31) / 3

		if dist12 > maxAllowedDistance or dist23 > maxAllowedDistance or dist31 > maxAllowedDistance then
			return
		end

		if dist12 < minAllowedDistance or dist23 < minAllowedDistance or dist31 < minAllowedDistance then
			return
		end

		local maxDiff = math.max(math.abs(dist12 - dist23), math.abs(dist23 - dist31), math.abs(dist31 - dist12))
		if maxDiff > maxAllowedDistance * 0.5 then
			return
		end

		local centerPos = (positions[1] + positions[2] + positions[3]) / 3
		ReplicatedStorage:SetAttribute("LaVaccaCenter", centerPos)

		if connection then
			connection:Disconnect()
			connection = nil
		end

		for i = 1, 3 do
			local model = triangleModels[i]
			if model then
				local ownerUserId = model:GetAttribute("OwnerUserId")
				if ownerUserId then
					local player = Players:GetPlayerByUserId(ownerUserId)
					if player then
						local stealingPlot = player:GetAttribute("StealingPlot")
						local stealingSlot = player:GetAttribute("StealingSlot")

						model:SetAttribute("PreserveOnStealingEnd", true)

						if player.Character then
							local humanoid = player.Character:FindFirstChild("Humanoid")
							if humanoid then
								for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
									if track.Name == "carry" or track.Name:find("steal") then
										track:Stop()
									end
								end
							end
						end

						player:SetAttribute("Stealing", false)
						player:SetAttribute("StealingPlot", nil)
						player:SetAttribute("StealingSlot", nil)

						if stealingPlot then
							local targetPlot = Synchronizer:Get(stealingPlot)
							if targetPlot then
								local animalList = targetPlot:Get("AnimalList") or {}
								if stealingSlot and animalList[stealingSlot] then
									animalList[stealingSlot] = nil
									targetPlot:Set("AnimalList", animalList)
								end
							end
						end
					end
				end
			end
		end

		for i = 1, 3 do
			local model = triangleModels[i]
			if model and model.PrimaryPart then
				for _, part in ipairs(model:GetDescendants()) do
					if part:IsA("BasePart") then
						part.Anchored = true
					end
				end

				for _, child in pairs(model.PrimaryPart:GetChildren()) do
					if child:IsA("WeldConstraint") then
						child:Destroy()
					end
				end
			end
		end

		local success, error = pcall(function()
			self._eventService:StartEvent("La Vacca Saturno Saturnita", 540)
		end)

		if success then
			print("[LaVaccaEvent] ✅ Event started successfully!")
		else
			warn("[LaVaccaEvent] ❌ Failed to start event:", error)
		end
	end

	connection = RunService.Heartbeat:Connect(function()
		checkAndStartEvent()
	end)

	local function onModelAdded(model)
		local index = tonumber(model:GetAttribute("LaVaccaIndex"))
		if index and index >= 1 and index <= 3 then
			triangleModels[index] = model
		end
	end

	local function onModelRemoved(model)
		local index = tonumber(model:GetAttribute("LaVaccaIndex"))
		if index and index >= 1 and index <= 3 then
			if triangleModels[index] == model then
				triangleModels[index] = nil
			end
		end
	end

	CollectionService:GetInstanceAddedSignal("LaVaccaModel"):Connect(onModelAdded)
	CollectionService:GetInstanceRemovedSignal("LaVaccaModel"):Connect(onModelRemoved)

	for _, model in ipairs(CollectionService:GetTagged("LaVaccaModel")) do
		onModelAdded(model)
	end

	return function()
		if connection then
			connection:Disconnect()
			connection = nil
		end
	end
end

function LaVaccaEvent:_setupTriangleDetection()
	local function onModelAdded(model)
		if not self._isActive then return end

		local index = model:GetAttribute("LaVaccaIndex")
		if index and index >= 1 and index <= 3 then
			self._triangleModels[index] = model

			if self._triangleModels[1] and self._triangleModels[2] and self._triangleModels[3] then
				self:_handleTriangleComplete()
			end
		end
	end

	local function onModelRemoved(model)
		if not self._isActive then return end

		local index = model:GetAttribute("LaVaccaIndex")
		if index and self._triangleModels[index] == model then
			self._triangleModels[index] = nil
		end
	end

	Observers.observeTag("LaVaccaModel", function(model)
		onModelAdded(model)
		return function()
			onModelRemoved(model)
		end
	end)
end

function LaVaccaEvent:_handleTriangleComplete()
	local positions = {}
	local playerCharacters = {}

	for i = 1, 3 do
		local model = self._triangleModels[i]
		if model and model.PrimaryPart then
			table.insert(positions, model.PrimaryPart.Position)

			local ownerUserId = model:GetAttribute("OwnerUserId")
			if ownerUserId then
				local player = Players:GetPlayerByUserId(ownerUserId)
				if player and player.Character then
					local humanoid = player.Character:FindFirstChild("Humanoid")
					if humanoid then
						local animator = humanoid:FindFirstChild("Animator")
						if animator then
							for _, track in pairs(animator:GetPlayingAnimationTracks()) do
								if track.Name == "Carry" or track.Name:find("steal") then
									track:Stop()
									track:Destroy()
								end
							end
						end
					end

					table.insert(playerCharacters, player.Character)
				end
			end
		end
	end

	if #positions == 3 then
		local centerPos = (positions[1] + positions[2] + positions[3]) / 3
		ReplicatedStorage:SetAttribute("LaVaccaCenter", centerPos)

		for _, character in ipairs(playerCharacters) do
			CollectionService:AddTag(character, "LaVaccaPlayerVFX")
		end

		self:Start()
	end
end

function LaVaccaEvent:_startCometAttacks()
	if not self._isActive then return end

	local function fireCometAttack()
		if not self._isActive then return end

		local roadAnimals = self:_getAllRoadAnimals()
		if #roadAnimals == 0 then
			return
		end

		local availableAnimals = {}
		for _, animal in ipairs(roadAnimals) do
			if animal.animalModel then
				local currentTraitsJson = animal.animalModel:GetAttribute("Traits")
				local hasGalacticTrait = false

				if currentTraitsJson then
					local success, decoded = pcall(function()
						return HttpService:JSONDecode(currentTraitsJson)
					end)
					if success and type(decoded) == "table" then
						for _, trait in ipairs(decoded) do
							if trait == "Galactic" then
								hasGalacticTrait = true
								break
							end
						end
					end
				end

				if not hasGalacticTrait then
					table.insert(availableAnimals, animal)
				end
			end
		end

		if #availableAnimals == 0 then
			return
		end

		local cometCount = math.min(2, #availableAnimals)
		for i = 1, cometCount do
			if #availableAnimals == 0 then break end
			local randomIndex = math.random(1, #availableAnimals)
			local randomAnimal = availableAnimals[randomIndex]
			if randomAnimal and randomAnimal.animalModel then
				self:_fireCometAtAnimal(randomAnimal)
				table.remove(availableAnimals, randomIndex)
			end
		end
	end

	fireCometAttack()

	self._eventConnection = RunService.Heartbeat:Connect(function()
		if not self._isActive then return end

		if math.random() < 0.004 then
			fireCometAttack()
		end
	end)
end

function LaVaccaEvent:_getAllRoadAnimals()
	local animals = {}
	local roadService = _G.RoadAnimalService

	if roadService and roadService.ActiveAnimals then
		for animalTemplate, animalData in pairs(roadService.ActiveAnimals) do
			if animalTemplate and animalTemplate.Parent then
				table.insert(animals, {
					animalModel = animalTemplate,
					data = animalData,
					uuid = tostring(animalTemplate)
				})
			end
		end
	end

	return animals
end

function LaVaccaEvent:_fireCometAtAnimal(animal)
	if not animal or not animal.animalModel or not animal.animalModel.PrimaryPart then
		return
	end

	if self._animalsBeingHit[animal.uuid] then
		return
	end

	self._animalsBeingHit[animal.uuid] = true

	local targetPos = animal.animalModel.PrimaryPart.Position
	local skyHeight = 200
	local horizontalOffset = Vector3.new(
		math.random(-30, 30),
		0,
		math.random(-30, 30)
	)

	local cometSpawnPos = targetPos + Vector3.new(0, skyHeight, 0) + horizontalOffset

	self._cometRemote:FireAllClients(cometSpawnPos, animal.uuid)

	task.delay(1.1, function()
		if not animal.animalModel or not animal.animalModel.Parent then 
			self._animalsBeingHit[animal.uuid] = nil
			return 
		end

		local currentTraitsJson = animal.animalModel:GetAttribute("Traits")
		local currentTraits = {}

		if currentTraitsJson then
			local success, decoded = pcall(function()
				return HttpService:JSONDecode(currentTraitsJson)
			end)
			if success and type(decoded) == "table" then
				currentTraits = decoded
			end
		end

		local hasGalacticTrait = false
		for _, trait in ipairs(currentTraits) do
			if trait == "Galactic" then
				hasGalacticTrait = true
				break
			end
		end

		if not hasGalacticTrait then
			table.insert(currentTraits, "Galactic")
			local newTraitsJson = HttpService:JSONEncode(currentTraits)
			animal.animalModel:SetAttribute("Traits", newTraitsJson)
		end

		self._animalsBeingHit[animal.uuid] = nil
	end)
end

return LaVaccaEvent