--[[
  Extracted from: ServerScriptService.Services.RoadAnimalService.RoadAnimalPathfinder
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local RoadAnimalPathfinder = {}
RoadAnimalPathfinder.__index = RoadAnimalPathfinder

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local PathfindingService = game:GetService("PathfindingService")

local function MakeNonCollidable(model)
	for _, part in ipairs(model:GetDescendants()) do
		if part:IsA("BasePart") then
			part.CanCollide = false
			part.CanQuery = false
			part.CanTouch = false
		end
	end
end

local SimplePath = require(ReplicatedStorage.Packages.SimplePath)

function RoadAnimalPathfinder.new(config)
	local self = setmetatable({}, RoadAnimalPathfinder)

	self.Config = config
	self.ActivePaths = {}
	self.AnimalReachedEndCallback = nil

	return self
end

function RoadAnimalPathfinder:SetAnimalReachedEndCallback(callback)
	self.AnimalReachedEndCallback = callback
end

function RoadAnimalPathfinder:StartPathfinding(animalTemplate)
	if not animalTemplate or not animalTemplate.Parent then
		warn("Invalid animal template provided to pathfinder")
		return false
	end

	local humanoid = animalTemplate:FindFirstChild("Humanoid")
	local humanoidRootPart = animalTemplate.PrimaryPart

	humanoid.WalkSpeed = require(ReplicatedStorage:WaitForChild("Datas").Game).RoadSpawn.AnimalSpeed
	humanoid.StateChanged:Connect(function(_, newState)
		if newState == Enum.HumanoidStateType.Physics then
			humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
		end
	end)

	local pathConfig = {
		WaypointSpacing = self.Config.ROAD_SETTINGS.WAYPOINT_SPACING,
		AgentRadius = math.min(self.Config.ROAD_SETTINGS.AGENT_RADIUS, 2),
		AgentHeight = math.min(self.Config.ROAD_SETTINGS.AGENT_HEIGHT, 5),
		AgentCanJump = true,
		AgentCanClimb = false,
		Costs = {
			Water = 20,
			DangerousLava = math.huge
		}
	}

	local path = SimplePath.new(animalTemplate, pathConfig)

	if self.Config.DEBUG.VISUALIZE_PATHS then
		path.Visualize = true
	end

	self:_setupPathEvents(animalTemplate, path)

	self.ActivePaths[animalTemplate] = {
		Path = path,
		StartTime = tick(),
		IsStuck = false,
		StuckTime = 0,
		Retries = 0,
		FallbackMode = false,
		LastPosition = humanoidRootPart.Position
	}

	self:_startMovement(animalTemplate, path)

	return true
end

function RoadAnimalPathfinder:StopPathfinding(animal)
	local pathData = self.ActivePaths[animal]
	if not pathData then
		return
	end

	if pathData.Path.Status == "Active" then
		pathData.Path:Stop()
	end

	-- Stop any fallback movement
	if pathData.FallbackConnection then
		pathData.FallbackConnection:Disconnect()
		pathData.FallbackConnection = nil
	end

	self.ActivePaths[animal] = nil

	if self.Config.DEBUG.PRINT_MOVEMENT_INFO then
		print(("⏹️ Stopped pathfinding for animal: %s"):format(animal.Name))
	end
end

function RoadAnimalPathfinder:_setupPathEvents(animal, path)
	path.Reached:Connect(function(agent, finalWaypoint)
		self:_onAnimalReachedEnd(animal)
	end)

	path.Blocked:Connect(function(agent, blockedWaypoint)
		self:_onAnimalBlocked(animal, path)
	end)

	path.Error:Connect(function(errorType)
		self:_onPathError(animal, path, errorType)
	end)

	if self.Config.DEBUG.PRINT_MOVEMENT_INFO then
		path.WaypointReached:Connect(function(agent, oldWaypoint, newWaypoint)
			if newWaypoint then
				print(("📍 Animal %s reached waypoint at position: %s"):format(
					animal.Name, tostring(newWaypoint.Position)))
			end
		end)
	end
end

function RoadAnimalPathfinder:_startMovement(animal, path)
	local endPoint = self:_getEndPoint()
	if not endPoint then
		warn("No end point found for road!")
		-- Start fallback movement instead of failing
		self:_startFallbackMovement(animal)
		return
	end

	if self.Config.DEBUG.PRINT_MOVEMENT_INFO then
		print(("🚀 Starting movement for %s to end point"):format(animal.Name))
	end

	local success = path:Run(endPoint)
	if not success then
		-- If pathfinding fails immediately, start fallback movement
		self:_startFallbackMovement(animal)
	end
end

function RoadAnimalPathfinder:_onAnimalReachedEnd(animal)
	local pathData = self.ActivePaths[animal]

	if pathData and pathData.IsMovingToPlayer then
		if self.Config.DEBUG.PRINT_MOVEMENT_INFO then
			print(("🏠 Animal %s reached player's plot"):format(animal.Name))
		end

		self:_handleAnimalReachedPlayerPlot(animal)
	else
		if self.Config.DEBUG.PRINT_MOVEMENT_INFO then
			print(("🎯 Animal reached end: %s"):format(animal.Name))
		end

		self:StopPathfinding(animal)

		local humanoid = animal:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid:MoveTo(animal.PrimaryPart.Position)
			humanoid.WalkSpeed = 0
			humanoid.JumpPower = 0
			humanoid:ChangeState(Enum.HumanoidStateType.Physics)
		end

		animal:Destroy()

		if self.AnimalReachedEndCallback then
			self.AnimalReachedEndCallback(animal)
		end
	end
end

function RoadAnimalPathfinder:_handleAnimalReachedPlayerPlot(animal)
	local proximityPrompt = animal.PrimaryPart:FindFirstChild("PromptAttachment"):FindFirstChild("ProximityPrompt")
	local targetPlayerId = proximityPrompt and proximityPrompt:GetAttribute("TargetPlayer")

	if targetPlayerId then
		local player = game.Players:GetPlayerByUserId(targetPlayerId)
		if player then
			self:_addAnimalToPlayerPlot(player, animal)

			if self.Config.DEBUG.PRINT_PURCHASE_INFO then
				print(("✅ Animal %s added to %s's plot"):format(animal.Name, player.Name))
			end
		end
	end

	self:StopPathfinding(animal)

	if self.AnimalReachedEndCallback then
		self.AnimalReachedEndCallback(animal)
	end
end

function RoadAnimalPathfinder:_addAnimalToPlayerPlot(player, animal)
	if self.Config.DEBUG.PRINT_PURCHASE_INFO then
		print(("📝 Adding animal %s to %s's plot data"):format(animal.Name, player.Name))
	end

	local proximityPrompt = animal.PrimaryPart:FindFirstChild("PromptAttachment"):FindFirstChild("ProximityPrompt")
	local animalIndex = proximityPrompt and proximityPrompt:GetAttribute("AnimalData")
	local targetPlayer = proximityPrompt and proximityPrompt:GetAttribute("TargetPlayer")

	local animalMutation = animal:GetAttribute("Mutation")
	local animalTraits = animal:GetAttribute("Traits")

	if self.Config.DEBUG.PRINT_PURCHASE_INFO then
		print(("🔍 Debug attributes - AnimalData: %s, TargetPlayer: %s, Mutation: %s, Traits: %s"):format(
			tostring(animalIndex), tostring(targetPlayer), tostring(animalMutation), tostring(animalTraits)))
	end

	if not animalIndex then
		warn("No animal data found for purchased animal:", animal.Name)
		warn("Available attributes:", proximityPrompt and proximityPrompt:GetAttributes() or "No prompt found")
		return
	end

	local ServerScriptService = game:GetService("ServerScriptService")
	local DataManagement = require(ServerScriptService.Services.DataManagment)

	if DataManagement.isDataReady(player) then
		DataManagement.addAnimal(player, animalIndex, animalMutation, animalTraits)

		local indexSuccess = DataManagement.addToIndex(player, animalIndex, animalMutation)
		if indexSuccess then
			local ReplicatedStorage = game:GetService("ReplicatedStorage")
			local Synchronizer = require(ReplicatedStorage.Packages.Synchronizer)
			local playerSync = Synchronizer:Get(player)
			if playerSync then
				local profile = DataManagement.GetDataMan(player)
				if profile and profile.Data and profile.Data.Index then
					playerSync:Set("Index", profile.Data.Index)
				end
			end

			if self.Config.DEBUG.PRINT_PURCHASE_INFO then
				local mutationText = animalMutation and (" (" .. animalMutation .. ")") or " (Default)"
				print(("📖 Added %s%s to %s's Index collection"):format(animalIndex, mutationText, player.Name))
			end
		else
			warn("Failed to add animal to Index for player:", player.Name)
		end

		self:_updatePlotAnimalList(player)

		if self.Config.DEBUG.PRINT_PURCHASE_INFO then
			local mutationText = animalMutation and (" with " .. animalMutation .. " mutation") or ""
			print(("✅ Successfully added %s%s to %s's animal collection"):format(animalIndex, mutationText, player.Name))
		end
	else
		warn("Player data not ready when adding animal:", player.Name)
	end
end

function RoadAnimalPathfinder:_onAnimalBlocked(animal, path)
	local pathData = self.ActivePaths[animal]
	if not pathData then
		return
	end

	if self.Config.DEBUG.PRINT_MOVEMENT_INFO then
		print(("⚠️ Animal blocked: %s - switching to fallback movement"):format(animal.Name))
	end

	-- Instead of marking as stuck, switch to fallback movement
	self:_startFallbackMovement(animal)
end

function RoadAnimalPathfinder:_onPathError(animal, path, errorType)
	if self.Config.DEBUG.PRINT_MOVEMENT_INFO then
		print(("⚠️ Path error for animal %s: %s - switching to fallback movement"):format(animal.Name, tostring(errorType)))
	end

	-- Instead of retrying or removing, switch to fallback movement
	self:_startFallbackMovement(animal)
end

function RoadAnimalPathfinder:_startFallbackMovement(animal)
	local pathData = self.ActivePaths[animal]
	if not pathData then
		return
	end

	local humanoid = animal:FindFirstChildOfClass("Humanoid")
	if not humanoid then
		return
	end

	-- Stop the current path
	if pathData.Path.Status == "Active" then
		pathData.Path:Stop()
	end

	pathData.FallbackMode = true

	if self.Config.DEBUG.PRINT_MOVEMENT_INFO then
		print(("🚶 Starting fallback movement for %s"):format(animal.Name))
	end

	-- Disconnect any existing fallback connection
	if pathData.FallbackConnection then
		pathData.FallbackConnection:Disconnect()
	end

	-- Create a simple forward movement
	pathData.FallbackConnection = RunService.Heartbeat:Connect(function()
		if not animal or not animal.Parent then
			if pathData.FallbackConnection then
				pathData.FallbackConnection:Disconnect()
				pathData.FallbackConnection = nil
			end
			return
		end

		local humanoidRootPart = animal.PrimaryPart
		if not humanoidRootPart then
			return
		end

		-- Get the end point
		local endPoint = self:_getEndPoint()
		if endPoint then
			-- Calculate direction towards end point
			local direction = (endPoint - humanoidRootPart.Position).Unit
			local targetPosition = humanoidRootPart.Position + (direction * 10)

			-- Make sure the animal keeps walking towards the end
			humanoid:MoveTo(targetPosition)

			-- Check if animal reached the end
			local distanceToEnd = (endPoint - humanoidRootPart.Position).Magnitude
			if distanceToEnd < 5 then
				self:_onAnimalReachedEnd(animal)
				return
			end
		else
			-- If no end point, just move forward
			local lookDirection = humanoidRootPart.CFrame.LookVector
			local targetPosition = humanoidRootPart.Position + (lookDirection * 10)
			humanoid:MoveTo(targetPosition)
		end
	end)
end

function RoadAnimalPathfinder:_retryPath(animal, path)
	-- This function is now simplified - just start fallback movement
	if self.Config.DEBUG.PRINT_MOVEMENT_INFO then
		print(("🔄 Switching to fallback movement for animal: %s"):format(animal.Name))
	end

	self:_startFallbackMovement(animal)
end

function RoadAnimalPathfinder:_getEndPoint()
	local Road = workspace:FindFirstChild("Road")
	if not Road then
		warn("Road folder not found in workspace!")
		return nil
	end

	local endPoint = Road:FindFirstChild("End")
	if not endPoint then
		warn("Road end point not found!")
		return nil
	end

	return endPoint.Position
end

function RoadAnimalPathfinder:_performStuckCleanup()
	-- This cleanup is now less aggressive since we use fallback movement
	local currentTime = tick()
	local stuckAnimals = {}

	for animal, pathData in pairs(self.ActivePaths) do
		-- Only clean up animals that have been inactive for a very long time
		if pathData.IsStuck and (currentTime - pathData.StuckTime) > (self.Config.MOVEMENT_SETTINGS.STUCK_TIMEOUT * 3) then
			table.insert(stuckAnimals, animal)
		end
	end

	for _, animal in ipairs(stuckAnimals) do
		warn(("Removing extremely stuck animal: %s"):format(animal.Name))
		self:_onAnimalReachedEnd(animal)
	end
end

function RoadAnimalPathfinder:_updatePerformanceStats()
	if not self.Config.DEBUG.SHOW_PERFORMANCE_STATS then
		return
	end

	local activeCount = 0
	local stuckCount = 0
	local fallbackCount = 0

	for animal, pathData in pairs(self.ActivePaths) do
		activeCount = activeCount + 1
		if pathData.IsStuck then
			stuckCount = stuckCount + 1
		end
		if pathData.FallbackMode then
			fallbackCount = fallbackCount + 1
		end
	end

	if activeCount > 0 then
		print(("📊 Pathfinder Stats - Active: %d, Stuck: %d, Fallback: %d"):format(activeCount, stuckCount, fallbackCount))
	end
end

function RoadAnimalPathfinder:_startBackgroundProcesses()
	task.spawn(function()
		while true do
			task.wait(10)
			self:_performStuckCleanup()
		end
	end)

	if self.Config.DEBUG.SHOW_PERFORMANCE_STATS then
		task.spawn(function()
			while true do
				task.wait(30)
				self:_updatePerformanceStats()
			end
		end)
	end
end

function RoadAnimalPathfinder:GetActivePathCount()
	local count = 0
	for _ in pairs(self.ActivePaths) do
		count = count + 1
	end
	return count
end

function RoadAnimalPathfinder:GetStuckAnimals()
	local stuckAnimals = {}

	for animal, pathData in pairs(self.ActivePaths) do
		if pathData.IsStuck then
			table.insert(stuckAnimals, animal)
		end
	end

	return stuckAnimals
end

function RoadAnimalPathfinder:GetFallbackAnimals()
	local fallbackAnimals = {}

	for animal, pathData in pairs(self.ActivePaths) do
		if pathData.FallbackMode then
			table.insert(fallbackAnimals, animal)
		end
	end

	return fallbackAnimals
end

function RoadAnimalPathfinder:ForceStopAll()
	for animal, _ in pairs(self.ActivePaths) do
		self:StopPathfinding(animal)
	end
end

function RoadAnimalPathfinder:Initialize()
	self:_startBackgroundProcesses()
end

function RoadAnimalPathfinder:ChangeTarget(animal, newTargetPosition)
	local pathData = self.ActivePaths[animal]
	if not pathData then
		warn("No active path found for animal:", animal.Name)
		return false
	end

	if self.Config.DEBUG.PRINT_MOVEMENT_INFO then
		print(("🎯 Changing target for %s to position: %s"):format(animal.Name, tostring(newTargetPosition)))
	end

	-- Stop fallback movement if active
	if pathData.FallbackConnection then
		pathData.FallbackConnection:Disconnect()
		pathData.FallbackConnection = nil
		pathData.FallbackMode = false
	end

	if pathData.Path.Status == "Active" then
		pathData.Path:Stop()
	end

	local success = pathData.Path:Run(newTargetPosition)
	if success then
		pathData.IsMovingToPlayer = true
		pathData.PlayerTarget = newTargetPosition

		if self.Config.DEBUG.PRINT_MOVEMENT_INFO then
			print(("✅ Successfully changed path for %s"):format(animal.Name))
		end
	else
		warn(("❌ Failed to change path for %s - using fallback movement"):format(animal.Name))
		-- If changing target fails, use fallback movement towards new target
		self:_startFallbackMovementToTarget(animal, newTargetPosition)
		success = true
	end

	return success
end

function RoadAnimalPathfinder:_startFallbackMovementToTarget(animal, targetPosition)
	local pathData = self.ActivePaths[animal]
	if not pathData then
		return
	end

	local humanoid = animal:FindFirstChildOfClass("Humanoid")
	if not humanoid then
		return
	end

	pathData.FallbackMode = true
	pathData.IsMovingToPlayer = true
	pathData.PlayerTarget = targetPosition

	if self.Config.DEBUG.PRINT_MOVEMENT_INFO then
		print(("🚶 Starting fallback movement to target for %s"):format(animal.Name))
	end

	-- Disconnect any existing fallback connection
	if pathData.FallbackConnection then
		pathData.FallbackConnection:Disconnect()
	end

	-- Create movement towards specific target
	pathData.FallbackConnection = RunService.Heartbeat:Connect(function()
		if not animal or not animal.Parent then
			if pathData.FallbackConnection then
				pathData.FallbackConnection:Disconnect()
				pathData.FallbackConnection = nil
			end
			return
		end

		local humanoidRootPart = animal.PrimaryPart
		if not humanoidRootPart then
			return
		end

		-- Calculate direction towards target
		local direction = (targetPosition - humanoidRootPart.Position).Unit
		local movePosition = humanoidRootPart.Position + (direction * 10)

		humanoid:MoveTo(movePosition)

		-- Check if animal reached the target
		local distanceToTarget = (targetPosition - humanoidRootPart.Position).Magnitude
		if distanceToTarget < 5 then
			self:_onAnimalReachedEnd(animal)
			return
		end
	end)
end

function RoadAnimalPathfinder:_updatePlotAnimalList(player)
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local ServerScriptService = game:GetService("ServerScriptService")
	local Synchronizer = require(ReplicatedStorage.Packages.Synchronizer)
	local DataManagement = require(ServerScriptService.Services.DataManagment)

	task.wait(0.2)

	local plotsFolder = workspace:FindFirstChild("Plots")
	if not plotsFolder then
		return
	end

	local playerPlot = nil
	for _, plot in pairs(plotsFolder:GetChildren()) do
		if plot:GetAttribute("Owner") == player.UserId then
			playerPlot = plot
			break
		end
	end

	if not playerPlot then
		return
	end

	local plotUUID = playerPlot.Name
	local plotSync = Synchronizer:Get(plotUUID)
	local playerSync = Synchronizer:Get(player)

	if plotSync then
		local updatedAnimalList = DataManagement.getAnimalList(player)
		plotSync:Set("AnimalList", updatedAnimalList)
		plotSync:Set("AnimalPodiums", updatedAnimalList)

		if playerSync then
			playerSync:Set("AnimalAddedOrRemoved", updatedAnimalList)
			playerSync:Set("AnimalPodiums", updatedAnimalList)
		end

		if self.Config.DEBUG.PRINT_PURCHASE_INFO then
			print(("🔄 Updated plot animal list for %s (Count: %d)"):format(player.Name, #updatedAnimalList))
		end
	end
end

return RoadAnimalPathfinder