--[[
  Extracted from: ServerScriptService.Services.EventService.Events.CrabRaveEvent
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local HttpService = game:GetService("HttpService")
local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Packages = ReplicatedStorage:WaitForChild("Packages")
local Net = require(Packages.Net)
local SimplePath = require(Packages.SimplePath)

local DataManagment = require(ServerScriptService.Services.DataManagment)
local RoadAnimalService = require(ServerScriptService.Services.RoadAnimalService)
local Animals = require(ReplicatedStorage.Datas.Animals)

local CrabRaveEvent = {}
CrabRaveEvent.__index = CrabRaveEvent

local SCAN_RADIUS = 50
local TRAIT_NAME = "Claws"
local COOLDOWN_HIT = 2
local MOVEMENT_SPEED = 16
local RETURN_DELAY = 5
local MAX_ACTIVE_CRABS = 3
local STARTUP_DELAY = 9
local STATIONARY_COOLDOWN_MIN = 4
local STATIONARY_COOLDOWN_MAX = 6
local HIT_DISTANCE = 10

function CrabRaveEvent.new(eventService)
	local self = setmetatable({}, CrabRaveEvent)
	self._eventService = eventService
	self._isActive = false
	self._recentlyHit = {}
	self._originalBaseplateColor = nil
	self._crabPaths = {}
	self._targetedAnimals = {}
	self._activeCrabs = 0

	self._hitRemote = Net:RemoteEvent("EventService/Crab Rave/Hit")

	return self
end

function CrabRaveEvent:Start(eventEntry)
	if self._isActive then
		return
	end

	self._isActive = true
	self._eventEntry = eventEntry
	self._crabs = {}
	self._targetedAnimals = {}
	self._activeCrabs = 0

	local baseplate = workspace:FindFirstChild("Map")
	if baseplate then
		baseplate = baseplate:FindFirstChild("Baseplate")
		if baseplate then
			self._originalBaseplateColor = baseplate.Color
			baseplate.Color = Color3.fromRGB(156, 159, 0)
		end
	end

	local crabsFolder = Instance.new("Folder")
	crabsFolder.Name = "CrabRaveCrabs"
	crabsFolder.Parent = workspace
	CollectionService:AddTag(crabsFolder, "CrabRaveCrabFolder")

	local groundFolder = Instance.new("Folder")
	groundFolder.Name = "Ground"
	groundFolder.Parent = crabsFolder

	local wallFolder = Instance.new("Folder")
	wallFolder.Name = "Wall"
	wallFolder.Parent = crabsFolder

	local eventsFolder = workspace:FindFirstChild("Events")
	if eventsFolder then
		local crabFolder = eventsFolder:FindFirstChild("Crab")
		if crabFolder then
			for _, wanderPart in pairs(crabFolder:GetChildren()) do
				if wanderPart:IsA("BasePart") and wanderPart.Name == "Wander" then
					CollectionService:AddTag(wanderPart, "CrabRaveWanderPoint")

					local isStationary = math.abs(wanderPart.Position.Y - 23.205) < 0.1
					local parentFolder = isStationary and groundFolder or wallFolder

					local crabModel = self:_createCrabModel(wanderPart, parentFolder)
					if crabModel then
						table.insert(self._crabs, crabModel)

						if isStationary then
							CollectionService:AddTag(wanderPart, "CrabRaveStationaryPoint")
							crabModel:SetAttribute("IsStationary", true)
							crabModel:SetAttribute("Dance", 1)
						else
							CollectionService:AddTag(wanderPart, "CrabRaveWanderingPoint")
							crabModel:SetAttribute("IsStationary", false)
						end
					end
				end
			end
		else
			warn("[CrabRaveEvent] Crab folder not found in workspace.Events")
		end
	else
		warn("[CrabRaveEvent] Events folder not found in workspace")
	end

	-- Add synchronized flashing highlight effect to ALL crabs at once
	self:_addSynchronizedHighlights()

	self:_startScanning()
end

function CrabRaveEvent:Stop(eventEntry)
	if not self._isActive then
		return
	end

	self._isActive = false

	if self._originalBaseplateColor then
		local baseplate = workspace:FindFirstChild("Map")
		if baseplate then
			baseplate = baseplate:FindFirstChild("Baseplate")
			if baseplate then
				baseplate.Color = self._originalBaseplateColor
			end
		end
		self._originalBaseplateColor = nil
	end

	if self._scanConnection then
		if self._scanRunning then
			self._scanRunning = false
		end
		task.cancel(self._scanConnection)
		self._scanConnection = nil
	end

	if self._crabs then
		for _, crab in ipairs(self._crabs) do
			if crab and crab.Parent then
				if self._crabPaths[crab] then
					local path = self._crabPaths[crab]
					if path.Status == SimplePath.StatusType.Active then
						path:Stop()
					end
					self._crabPaths[crab] = nil
				end
				crab:Destroy()
			end
		end
		self._crabs = {}
	end

	self._crabPaths = {}
	self._targetedAnimals = {}
	self._activeCrabs = 0

	local wanderPoints = CollectionService:GetTagged("CrabRaveWanderPoint")
	for _, wanderPoint in ipairs(wanderPoints) do
		CollectionService:RemoveTag(wanderPoint, "CrabRaveWanderPoint")
		CollectionService:RemoveTag(wanderPoint, "CrabRaveStationaryPoint")
		CollectionService:RemoveTag(wanderPoint, "CrabRaveWanderingPoint")
	end

	local crabsFolder = workspace:FindFirstChild("CrabRaveCrabs")
	if crabsFolder then
		crabsFolder:Destroy()
	end

	self._recentlyHit = {}
end

function CrabRaveEvent:_addSynchronizedHighlights()
	-- Create highlights for all crabs at once
	local highlights = {}

	for _, crab in ipairs(self._crabs) do
		if crab and crab.Parent then
			local highlight = Instance.new("Highlight")
			highlight.Name = "CrabFlashHighlight"
			highlight.FillColor = Color3.new(1, 1, 1) -- Pure white
			highlight.OutlineColor = Color3.new(1, 1, 1) -- Pure white
			highlight.FillTransparency = 0 -- Start fully visible
			highlight.OutlineTransparency = 0 -- Start fully visible
			highlight.Parent = crab
			table.insert(highlights, highlight)
		end
	end

	-- Start synchronized flashing pattern
	task.spawn(function()
		-- Flash pattern: 3 cycles of show 0.5s, fade 0.5s
		for flashCycle = 1, 3 do
			-- Highlights start visible, so hold for 0.5 seconds
			task.wait(0.5)

			-- Fade out all highlights simultaneously
			for _, highlight in ipairs(highlights) do
				if highlight and highlight.Parent then
					local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
					local fadeOutTween = TweenService:Create(highlight, tweenInfo, {
						FillTransparency = 1,
						OutlineTransparency = 1
					})
					fadeOutTween:Play()
				end
			end

			-- Wait for fade out to complete
			task.wait(0.5)

			-- If not the last cycle, fade back in immediately
			if flashCycle < 3 then
				for _, highlight in ipairs(highlights) do
					if highlight and highlight.Parent then
						highlight.FillTransparency = 0
						highlight.OutlineTransparency = 0
					end
				end
			end
		end

		-- Clean up all highlights after final fade
		task.wait(0.1) -- Small delay to ensure final fade completes
		for _, highlight in ipairs(highlights) do
			if highlight and highlight.Parent then
				highlight:Destroy()
			end
		end
	end)
end

function CrabRaveEvent:_addFlashingHighlight(crabModel)
	-- This function is no longer used - keeping for compatibility
end

function CrabRaveEvent:_findAnimalByName(animalName)
	local roadAnimals = CollectionService:GetTagged("Animal")
	local movingAnimalsFolder = workspace:FindFirstChild("MovingAnimals")

	for _, animal in ipairs(roadAnimals) do
		if animal.Parent == movingAnimalsFolder and animal.Name == animalName then
			return animal
		end
	end

	return nil
end

function CrabRaveEvent:_hasClawsTrait(animalTemplate)
	if not animalTemplate or not animalTemplate.Parent then
		return false
	end

	task.wait(0.01)
	local currentTraitsJson = animalTemplate:GetAttribute("Traits")
	local currentTraits = {}
	if currentTraitsJson then
		local success, decoded = pcall(function()
			return HttpService:JSONDecode(currentTraitsJson)
		end)
		if success and type(decoded) == "table" then
			currentTraits = decoded
		else
			return false
		end
	end

	for _, trait in ipairs(currentTraits) do
		if trait == "Claws" then
			return true
		end
	end

	return false
end

function CrabRaveEvent:_isAnimalNearEnd(animal)
	if not animal or not animal.Parent then
		return true
	end

	local animalRootPart = animal:FindFirstChild("HumanoidRootPart")
	if not animalRootPart then
		return true
	end

	local roadEnd = workspace:FindFirstChild("Road")
	if roadEnd then
		roadEnd = roadEnd:FindFirstChild("End")
		if roadEnd then
			local distanceToEnd = (animalRootPart.Position - roadEnd.Position).Magnitude
			if distanceToEnd <= 25 then
				return true
			end
		end
	end

	return false
end

function CrabRaveEvent:_applyClawsTrait(animalTemplate)
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
		if trait == "Claws" then
			return
		end
	end

	table.insert(currentTraits, "Claws")
	animalTemplate:SetAttribute("Traits", HttpService:JSONEncode(currentTraits))
end

function CrabRaveEvent:_createCrabModel(wanderPart, parentFolder)
	local crabModel = Instance.new("Model")
	crabModel.Name = "Crab_" .. wanderPart.Name .. "_" .. math.random(1000, 9999)

	local humanoidRootPart = Instance.new("Part")
	humanoidRootPart.Name = "HumanoidRootPart"
	humanoidRootPart.Size = Vector3.new(2, 2, 2)
	humanoidRootPart.Material = Enum.Material.ForceField
	humanoidRootPart.Transparency = 1
	humanoidRootPart.CanCollide = false
	humanoidRootPart.Anchored = false

	local spawnPosition = wanderPart.Position + Vector3.new(0, wanderPart.Size.Y/2 + humanoidRootPart.Size.Y/2, 0)
	local rotatedLookVector = CFrame.Angles(0, math.rad(90), 0) * wanderPart.CFrame.LookVector
	humanoidRootPart.CFrame = CFrame.new(spawnPosition, spawnPosition + rotatedLookVector)
	humanoidRootPart.Parent = crabModel

	local humanoid = Instance.new("Humanoid")
	humanoid.WalkSpeed = 16
	humanoid.Parent = crabModel

	crabModel.PrimaryPart = humanoidRootPart

	crabModel:SetAttribute("OriginalWanderPosition", wanderPart.Position)
	local rotatedLookVector = CFrame.Angles(0, math.rad(90), 0) * wanderPart.CFrame.LookVector
	crabModel:SetAttribute("WanderRotation", rotatedLookVector)
	crabModel:SetAttribute("OriginalWanderCFrame", wanderPart.CFrame)

	crabModel.Parent = parentFolder or workspace.CrabRaveCrabs
	CollectionService:AddTag(crabModel, "CrabRaveCrabs")

	return crabModel
end

function CrabRaveEvent:_startScanning()
	if self._scanConnection then
		return
	end

	self._scanRunning = true
	self._scanConnection = task.spawn(function()
		task.wait(STARTUP_DELAY)
		while self._scanRunning do
			task.wait(0.5)

			for animalName, crabName in pairs(self._targetedAnimals) do
				local animal = nil
				for _, a in ipairs(CollectionService:GetTagged("Animal")) do
					if a:GetAttribute("Index") == animalName then
						animal = a
						break
					end
				end

				if not animal or not animal.Parent or self:_hasClawsTrait(animal) or self:_isAnimalNearEnd(animal) then
					self._targetedAnimals[animalName] = nil
					self._activeCrabs = math.max(0, self._activeCrabs - 1)

				end
			end

			for _, crab in ipairs(self._crabs) do
				if not crab.Parent then
					continue
				end

				local humanoidRootPart = crab:FindFirstChild("HumanoidRootPart")
				if not humanoidRootPart then
					continue
				end

				local isStationary = crab:GetAttribute("IsStationary")
				local isMovingToAnimal = crab:GetAttribute("MovingToAnimal")
				local moveStartTime = crab:GetAttribute("MoveStartTime")

				if isMovingToAnimal and moveStartTime then
					local currentTime = tick()
					if currentTime - moveStartTime > 15 then

						crab:SetAttribute("MovingToAnimal", false)
						crab:SetAttribute("MoveStartTime", nil)
						self:_returnCrabToWander(crab)
						continue
					end
				end

				if not isMovingToAnimal and crab:GetAttribute("MovingToAnimal") then
					crab:SetAttribute("MovingToAnimal", false)
				end

				local stationaryCooldown = crab:GetAttribute("StationaryCooldown")
				if stationaryCooldown and tick() < stationaryCooldown then
					continue
				end

				if isMovingToAnimal or crab:GetAttribute("MovingToAnimal") or self._activeCrabs >= MAX_ACTIVE_CRABS then
					continue
				end

				local animalsInRange = {}
				local allAnimals = CollectionService:GetTagged("Animal")

				for _, animal in ipairs(allAnimals) do
					if not animal.Parent or not CollectionService:HasTag(animal, "Animal") then
						continue
					end

					if self:_isAnimalNearEnd(animal) then
						continue
					end

					local animalRootPart = animal:FindFirstChild("HumanoidRootPart")
					local animalName = animal:GetAttribute("Index")
					if animalRootPart and animalName and not self._targetedAnimals[animalName] and not self._recentlyHit[animalName] then
						local hasClaws = self:_hasClawsTrait(animal)
						if not hasClaws and not self._recentlyHit[animalName] then
							local distance = (humanoidRootPart.Position - animalRootPart.Position).Magnitude
							if distance <= SCAN_RADIUS then
								table.insert(animalsInRange, animal)
							end
						end
					end
				end

				if #animalsInRange > 0 then
					local nearestAnimal = nil
					local nearestDistance = math.huge

					for _, animal in ipairs(animalsInRange) do
						local animalRootPart = animal:FindFirstChild("HumanoidRootPart")
						if animalRootPart then
							local distance = (humanoidRootPart.Position - animalRootPart.Position).Magnitude
							if distance < nearestDistance then
								nearestDistance = distance
								nearestAnimal = animal
							end
						end
					end

					local animal = nearestAnimal
					local animalName = animal:GetAttribute("Index")

					if animalName and animal.Parent and CollectionService:HasTag(animal, "Animal") and not self._targetedAnimals[animalName] and not self:_hasClawsTrait(animal) and not self:_isAnimalNearEnd(animal) then
						self._targetedAnimals[animalName] = crab.Name
						self._activeCrabs = self._activeCrabs + 1


						self:_moveCrabToAnimal(crab, animal)

						task.spawn(function()
							crab:SetAttribute("Attack", true)
							crab:SetAttribute("ReturnToWander", true)
						end)
					end
				end
			end

			for animalName, _ in pairs(self._recentlyHit) do
				local animal = workspace:FindFirstChild(animalName)
				if not animal or not CollectionService:HasTag(animal, "Animal") then
					self._recentlyHit[animalName] = nil
				end
			end

			local actualActiveCrabs = 0
			for _, crab in ipairs(self._crabs) do
				if crab.Parent and crab:GetAttribute("MovingToAnimal") then
					actualActiveCrabs = actualActiveCrabs + 1
				end
			end
			self._activeCrabs = actualActiveCrabs
		end
	end)
end

function CrabRaveEvent:_moveCrabToAnimal(crab, animal)
	local humanoidRootPart = crab:FindFirstChild("HumanoidRootPart")
	local humanoid = crab:FindFirstChild("Humanoid")
	local animalRootPart = animal:FindFirstChild("HumanoidRootPart")

	if not humanoidRootPart or not humanoid or not animalRootPart then
		return
	end

	local animalName = animal:GetAttribute("Index")

	local animalSpeed = 0
	if animal:FindFirstChild("Humanoid") then
		animalSpeed = animal.Humanoid.WalkSpeed
	end

	local dynamicCrabSpeed = math.max(MOVEMENT_SPEED, animalSpeed * 1.5)
	humanoid.WalkSpeed = dynamicCrabSpeed

	crab:SetAttribute("MovingToAnimal", true)
	crab:SetAttribute("MoveStartTime", tick())

	if self._crabPaths[crab] then
		local path = self._crabPaths[crab]
		if path.Status == SimplePath.StatusType.Active then
			path:Stop()
		end
		self._crabPaths[crab] = nil
	end

	local path = SimplePath.new(crab)
	path.Visualize = false
	self._crabPaths[crab] = path

	local animalVelocity = Vector3.new(0, 0, 0)
	if animal:FindFirstChild("Humanoid") and animal.Humanoid.MoveDirection.Magnitude > 0 then
		animalVelocity = animal.Humanoid.MoveDirection * animal.Humanoid.WalkSpeed
	end

	local distanceToAnimal = (humanoidRootPart.Position - animalRootPart.Position).Magnitude
	local estimatedTravelTime = distanceToAnimal / dynamicCrabSpeed
	local predictedPosition = animalRootPart.Position + (animalVelocity * estimatedTravelTime)
	path:Run(predictedPosition)

	local startTime = tick()
	local CHASE_TIMEOUT = 20

	local lastValidationTime = 0
	local VALIDATION_INTERVAL = 5

	local hitConnection
	hitConnection = RunService.Heartbeat:Connect(function()
		if not crab.Parent or not animal.Parent then
			hitConnection:Disconnect()
			local animalName = animal:GetAttribute("Index")
			if animalName and self._targetedAnimals[animalName] == crab.Name then
				self._targetedAnimals[animalName] = nil
				self._activeCrabs = math.max(0, self._activeCrabs - 1)
			end
			crab:SetAttribute("MovingToAnimal", false)
			crab:SetAttribute("MoveStartTime", nil)
			crab:SetAttribute("LastPathUpdate", nil)
			return
		end

		local currentTime = tick()
		if currentTime - lastValidationTime >= VALIDATION_INTERVAL then
			lastValidationTime = currentTime
			local animalName = animal:GetAttribute("Index")
			local isNearEnd = self:_isAnimalNearEnd(animal)
			local isTargetedByOther = animalName and self._targetedAnimals[animalName] and self._targetedAnimals[animalName] ~= crab.Name

			if isNearEnd or isTargetedByOther then
				hitConnection:Disconnect()
				crab:SetAttribute("MovingToAnimal", false)
				crab:SetAttribute("MoveStartTime", nil)
				crab:SetAttribute("LastPathUpdate", nil)
				if animalName and self._targetedAnimals[animalName] == crab.Name then
					self._targetedAnimals[animalName] = nil
					self._activeCrabs = math.max(0, self._activeCrabs - 1)
				end

				self:_returnCrabToWander(crab)
				return
			end
		end

		if tick() - startTime > CHASE_TIMEOUT then
			hitConnection:Disconnect()
			crab:SetAttribute("MovingToAnimal", false)
			crab:SetAttribute("MoveStartTime", nil)
			local animalName = animal:GetAttribute("Index")
			if animalName and self._targetedAnimals[animalName] then
				self._targetedAnimals[animalName] = nil
				self._activeCrabs = math.max(0, self._activeCrabs - 1)
			end
			self:_returnCrabToWander(crab)
			return
		end

		local animalRootPart = animal:FindFirstChild("HumanoidRootPart")
		if not animalRootPart then
			return
		end

		local currentAnimalPosition = animalRootPart.Position
		local animalVelocity = Vector3.new(0, 0, 0)
		if animal:FindFirstChild("Humanoid") and animal.Humanoid.MoveDirection.Magnitude > 0 then
			animalVelocity = animal.Humanoid.MoveDirection * animal.Humanoid.WalkSpeed
		end
		local updatedPredictedPosition = currentAnimalPosition + (animalVelocity * 1.5)

		local lastPathUpdate = crab:GetAttribute("LastPathUpdate") or 0
		if currentTime - lastPathUpdate >= 0.5 and path.Status == SimplePath.StatusType.Active then
			local distanceToTarget = (humanoidRootPart.Position - updatedPredictedPosition).Magnitude
			if distanceToTarget > 5 then
				path:Run(updatedPredictedPosition)
				crab:SetAttribute("LastPathUpdate", currentTime)
			end
		end

		local currentDistance = (humanoidRootPart.Position - animalRootPart.Position).Magnitude
		if currentDistance <= HIT_DISTANCE then
			hitConnection:Disconnect()

			crab:SetAttribute("MovingToAnimal", false)
			crab:SetAttribute("MoveStartTime", nil)
			local animalName = animal:GetAttribute("Index")

			if animalName then
				if not self:_hasClawsTrait(animal) and not self._recentlyHit[animalName] then
					self._recentlyHit[animalName] = true

					local traitApplied = self:_applyClawsTraitDirect(animal)
					if traitApplied then
						self._hitRemote:FireAllClients(animalName)

						task.delay(COOLDOWN_HIT, function()
							if self._recentlyHit then
								self._recentlyHit[animalName] = nil
							end
						end)
					else
						self._recentlyHit[animalName] = nil
					end
				end

				local cooldownTime = 6
				crab:SetAttribute("StationaryCooldown", tick() + cooldownTime)
			end

			task.delay(1, function()
				if crab.Parent then
					self:_returnCrabToWander(crab)
				end
			end)

			if animalName and self._targetedAnimals[animalName] then
				self._targetedAnimals[animalName] = nil
				self._activeCrabs = math.max(0, self._activeCrabs - 1)
			end

			if self._crabPaths[crab] then
				local currentPath = self._crabPaths[crab]
				if currentPath.Status == SimplePath.StatusType.Active then
					currentPath:Stop()
				end
			end
		end
	end)

end

function CrabRaveEvent:_returnCrabToWander(crab)
	local humanoidRootPart = crab:FindFirstChild("HumanoidRootPart")
	local humanoid = crab:FindFirstChild("Humanoid")
	local originalPosition = crab:GetAttribute("OriginalWanderPosition")
	local originalCFrame = crab:GetAttribute("OriginalWanderCFrame")
	local wanderRotation = crab:GetAttribute("WanderRotation")

	if not humanoidRootPart or not humanoid then
		return
	end

	humanoid.WalkSpeed = MOVEMENT_SPEED

	if not originalPosition then
		originalPosition = humanoidRootPart.Position
	end


	crab:SetAttribute("MovingToAnimal", false)
	crab:SetAttribute("ReturnToWander", false)
	crab:SetAttribute("MoveStartTime", nil)

	if self._crabPaths[crab] then
		local path = self._crabPaths[crab]
		if path.Status == SimplePath.StatusType.Active then
			path:Stop()
		end
		self._crabPaths[crab] = nil
	end

	local path = SimplePath.new(crab)
	path.Visualize = false
	self._crabPaths[crab] = path

	local targetPosition = originalPosition + Vector3.new(0, humanoidRootPart.Size.Y/2, 0)

	local pathTimeout = 5
	local pathStartTime = tick()

	path:Run(targetPosition)

	path.Reached:Connect(function()
		if humanoidRootPart.Parent then
			if originalCFrame then
				local spawnPosition = originalCFrame.Position + Vector3.new(0, humanoidRootPart.Size.Y/2, 0)
				local rotatedLookVector = CFrame.Angles(0, math.rad(90), 0) * originalCFrame.LookVector
				humanoidRootPart.CFrame = CFrame.new(spawnPosition, spawnPosition + rotatedLookVector)
			elseif wanderRotation then
				humanoidRootPart.CFrame = CFrame.new(humanoidRootPart.Position, humanoidRootPart.Position + wanderRotation)
			end

		end
	end)

	path.Error:Connect(function(errorMsg)

		if humanoidRootPart.Parent then
			humanoidRootPart.CFrame = CFrame.new(targetPosition)

		end
	end)

	task.delay(pathTimeout, function()
		if tick() - pathStartTime >= pathTimeout and humanoidRootPart.Parent then
			if path.Status == SimplePath.StatusType.Active then
				path:Stop()

				humanoidRootPart.CFrame = CFrame.new(targetPosition)
			end
		end
	end)
end

function CrabRaveEvent:_applyClawsTraitDirect(animal)
	local animalName = animal:GetAttribute("Index")

	if not animal.Parent or not CollectionService:HasTag(animal, "Animal") then
		return false
	end

	local currentTraits = animal:GetAttribute("Traits")
	local traitsTable = {}

	if currentTraits then
		local success, decoded = pcall(HttpService.JSONDecode, HttpService, currentTraits)
		if success and type(decoded) == "table" then
			traitsTable = decoded
		end
	end

	local hasClaws = false
	for _, trait in ipairs(traitsTable) do
		if trait == TRAIT_NAME then
			hasClaws = true
			break
		end
	end

	if not hasClaws then
		table.insert(traitsTable, TRAIT_NAME)
		local newTraitsJson = HttpService:JSONEncode(traitsTable)
		animal:SetAttribute("Traits", newTraitsJson)
		return true
	else
		return false
	end
end

return CrabRaveEvent