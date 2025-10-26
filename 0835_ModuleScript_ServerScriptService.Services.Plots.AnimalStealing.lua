--[[
  Extracted from: ServerScriptService.Services.Plots.AnimalStealing
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")
local HttpService = game:GetService("HttpService")

local Packages = ReplicatedStorage.Packages
local Net = require(Packages.Net)
local Synchronizer = require(Packages.Synchronizer)
local DataManagment = require(ServerScriptService.Services.DataManagment)
local Animals = require(ReplicatedStorage.Shared.Animals)
local PlotConstants = require(script.Parent.PlotConstants)

local AnimalStealing = {}
AnimalStealing.__index = AnimalStealing

function AnimalStealing.new(plotManager)
	local self = setmetatable({}, AnimalStealing)

	self.plotManager = plotManager

	self.playerStolenModels = {}
	self.playerCarryAnimTracks = {}
	self.deliveryDebounce = {}
	self.stealNotificationDebounce = {}
	self.alreadyStealingDebounce = {}
	self.capacityFullDebounce = {}

	self:_setupRemoteEvents()
	self:_setupPlayerConnections()
	self:_setupToolStorage()

	return self
end

-- New function to setup tool storage system
function AnimalStealing:_setupToolStorage()
	-- Create main storage folder if it doesn't exist
	local toolStorageFolder = ServerStorage:FindFirstChild("PlayerToolStorage")
	if not toolStorageFolder then
		toolStorageFolder = Instance.new("Folder")
		toolStorageFolder.Name = "PlayerToolStorage"
		toolStorageFolder.Parent = ServerStorage
	end
end

-- New function to store player tools when stealing starts
function AnimalStealing:_storePlayerTools(player)
	if not player or not player.Character then
		warn("[AnimalStealing] Cannot store tools - player or character invalid")
		return false
	end

	local backpack = player:FindFirstChild("Backpack")
	if not backpack then
		warn("[AnimalStealing] Cannot store tools - backpack not found for player:", player.Name)
		return false
	end

	-- Create storage folder structure
	local toolStorageFolder = ServerStorage:FindFirstChild("PlayerToolStorage")
	if not toolStorageFolder then
		self:_setupToolStorage()
		toolStorageFolder = ServerStorage:FindFirstChild("PlayerToolStorage")
	end

	-- Use UserId as folder name for better reliability
	local playerStorageFolder = toolStorageFolder:FindFirstChild(tostring(player.UserId))
	if not playerStorageFolder then
		playerStorageFolder = Instance.new("Folder")
		playerStorageFolder.Name = tostring(player.UserId)
		playerStorageFolder.Parent = toolStorageFolder

		-- Add metadata
		playerStorageFolder:SetAttribute("PlayerName", player.Name)
		playerStorageFolder:SetAttribute("StorageTime", workspace:GetServerTimeNow())
	else
		-- Clear existing tools in storage (safety measure)
		for _, existingTool in pairs(playerStorageFolder:GetChildren()) do
			if existingTool:IsA("Tool") then
				existingTool:Destroy()
			end
		end
	end

	local storedCount = 0
	local totalTools = 0

	-- Store tools from backpack
	for _, tool in pairs(backpack:GetChildren()) do
		if tool:IsA("Tool") then
			totalTools = totalTools + 1
			local success = pcall(function()
				-- Clone the tool to preserve original data
				local toolClone = tool:Clone()
				toolClone.Parent = playerStorageFolder

				-- Remove original tool from backpack
				tool:Destroy()

				storedCount = storedCount + 1
			end)

			if not success then
				warn("[AnimalStealing] Failed to store tool:", tool.Name, "for player:", player.Name)
			end
		end
	end

	-- Also check for equipped tool in character
	local equippedTool = player.Character:FindFirstChildOfClass("Tool")
	if equippedTool then
		totalTools = totalTools + 1
		local success = pcall(function()
			local toolClone = equippedTool:Clone()
			toolClone.Parent = playerStorageFolder

			equippedTool:Destroy()

			storedCount = storedCount + 1
		end)

		if not success then
			warn("[AnimalStealing] Failed to store equipped tool:", equippedTool.Name, "for player:", player.Name)
		end
	end

	playerStorageFolder:SetAttribute("StoredToolCount", storedCount)
	playerStorageFolder:SetAttribute("LastUpdated", workspace:GetServerTimeNow())

	return storedCount > 0
end

-- New function to restore player tools when stealing ends
function AnimalStealing:_restorePlayerTools(player)
	if not player or not player.Character then
		return false
	end

	local backpack = player:FindFirstChild("Backpack")
	if not backpack then
		warn("[AnimalStealing] Cannot restore tools - backpack not found for player:", player.Name)
		return false
	end

	local toolStorageFolder = ServerStorage:FindFirstChild("PlayerToolStorage")
	if not toolStorageFolder then
		print("[AnimalStealing] No tool storage folder found")
		return false
	end

	local playerStorageFolder = toolStorageFolder:FindFirstChild(tostring(player.UserId))
	if not playerStorageFolder then
		return false
	end

	local restoredCount = 0
	local totalStoredTools = 0

	-- Count total stored tools
	for _, item in pairs(playerStorageFolder:GetChildren()) do
		if item:IsA("Tool") then
			totalStoredTools = totalStoredTools + 1
		end
	end

	-- Restore tools to backpack
	for _, storedTool in pairs(playerStorageFolder:GetChildren()) do
		if storedTool:IsA("Tool") then
			local success = pcall(function()
				-- Move tool back to backpack (don't clone to avoid duplicates)
				storedTool.Parent = backpack
				restoredCount = restoredCount + 1
			end)

			if not success then
				warn("[AnimalStealing] Failed to restore tool:", storedTool.Name, "for player:", player.Name)
				-- If moving failed, try to destroy to prevent orphaned tools
				pcall(function()
					storedTool:Destroy()
				end)
			end
		end
	end

	-- Clean up empty storage folder
	if #playerStorageFolder:GetChildren() == 0 then
		playerStorageFolder:Destroy()
	end

	print("[AnimalStealing] Restored", restoredCount, "/", totalStoredTools, "tools for player:", player.Name)
	return restoredCount > 0
end

-- New function to clean up orphaned tool storage
function AnimalStealing:_cleanupToolStorage(player)
	local toolStorageFolder = ServerStorage:FindFirstChild("PlayerToolStorage")
	if not toolStorageFolder then
		return
	end

	local playerStorageFolder = toolStorageFolder:FindFirstChild(tostring(player.UserId))
	if playerStorageFolder then
		-- Log what we're cleaning up
		local toolCount = 0
		for _, item in pairs(playerStorageFolder:GetChildren()) do
			if item:IsA("Tool") then
				toolCount = toolCount + 1
			end
		end

		if toolCount > 0 then
			print("[AnimalStealing] Cleaning up", toolCount, "orphaned tools for player:", player.Name)
		end

		playerStorageFolder:Destroy()
	end
end

function AnimalStealing:_setupRemoteEvents()
	local StealAnimal = Net:RemoteEvent(PlotConstants.REMOTES.STEAL_ANIMAL)
	local DeliveryHandler = Net:RemoteEvent(PlotConstants.REMOTES.DELIVERY_HANDLER)
	local removeBrainrot = Net:RemoteFunction("FuseMachine/RemoveBrainrot")

	local GrabAnimal = Net:RemoteEvent("StealService/Grab")
	StealAnimal.OnServerEvent:Connect(function(player, timestamp, actionId, targetPlotName, animalSlot)
		self:handleStealAttempt(player, timestamp, actionId, targetPlotName, animalSlot)
	end)

	GrabAnimal.OnServerEvent:Connect(function(player, actionId, targetPlotName, animalSlot)
		self:handleGrab(player, actionId, targetPlotName, animalSlot)
	end)

	DeliveryHandler.OnServerEvent:Connect(function(player, actionId)
		self:handleDelivery(player, actionId)
	end)

end

function AnimalStealing:_setupPlayerConnections()
	Players.PlayerAdded:Connect(function(player)
		self:_connectPlayerEvents(player)
	end)

	Players.PlayerRemoving:Connect(function(player)
		self:_handlePlayerRemoving(player)
	end)

	for _, player in pairs(Players:GetPlayers()) do
		self:_connectPlayerEvents(player)
	end
end

function AnimalStealing:_connectPlayerEvents(player)
	player:GetAttributeChangedSignal("Stealing"):Connect(function()
		local isCurrentlyStealing = player:GetAttribute("Stealing")
		if not isCurrentlyStealing then
			self:_cleanupStealState(player)
		end
	end)

	player.CharacterAdded:Connect(function()
		if player:GetAttribute("Stealing") then
			self:_cleanupStealState(player)
		end
	end)
end

function AnimalStealing:_handleLeavingPlayerStolenAnimals(player)
	local playerPlot = self.plotManager:GetPlayerPlot(player)
	if not playerPlot then
		return
	end

	local plotSync = playerPlot:GetSynchronizer()
	if not plotSync then
		return
	end

	local animalList = plotSync:Get("AnimalList") or {}

	for slot, animal in pairs(animalList) do
		if typeof(animal) == "table" and animal.Steal == true then
			print("[AnimalStealing] Removing stolen animal", animal.Index, "from leaving player", player.Name, "slot", slot)

			animalList[slot] = "Empty"

			DataManagment.removeAnimal(player, slot)
		end
	end

	plotSync:Set("AnimalList", animalList)
	plotSync:Set("AnimalPodiums", animalList)
end

function AnimalStealing:removeBrainrot(player, slot)
	warn()
	local playerPlot = self.plotManager:GetPlayerPlot(player)
	if not playerPlot then
		return
	end

	local plotSync = playerPlot:GetSynchronizer()
	if not plotSync then
		return
	end

	local animalList = plotSync:Get("AnimalList") or {}
	local animal = animalList[slot]
	animal.Steal = false

	plotSync:Set("AnimalList", animalList)
	plotSync:Set("AnimalPodiums", animalList)
end


function AnimalStealing:_handlePlayerRemoving(player)
	self:_handleLeavingPlayerStolenAnimals(player)

	self:_cleanupStealState(player)

	-- Clean up tool storage when player leaves
	self:_cleanupToolStorage(player)

	self.playerStolenModels[player] = nil
	self.playerCarryAnimTracks[player] = nil
	self.deliveryDebounce[player] = nil

	local playerUserId = player.UserId
	for key, _ in pairs(self.stealNotificationDebounce) do
		if string.find(key, "^" .. playerUserId .. "_") then
			self.stealNotificationDebounce[key] = nil
		end
	end
end

function AnimalStealing:_validateAndRepairAnimalList(plotInstance, plotUUID)
	local animalManager = self.plotManager:GetAnimalManager(plotInstance)
	if not animalManager then
		warn("[AnimalStealing] No animal manager found for plot: " .. plotUUID)
		return {}
	end

	local animalList = plotInstance:GetAnimalList()
	return animalManager:ValidateAndRepairAnimalList(animalList)
end

function AnimalStealing:_cleanupStealState(player)
	local stealingPlot = player:GetAttribute("StealingPlot")
	local stealingSlot = player:GetAttribute("StealingSlot")

	if stealingPlot and stealingSlot then
		local targetPlot = self.plotManager:GetPlotByUUID(stealingPlot)
		if targetPlot then
			local animalManager = self.plotManager:GetAnimalManager(targetPlot)
			if animalManager and animalManager:HasValidAnimal(stealingSlot) then
				animalManager:SetStealState(stealingSlot, false)
			end
		end
	end

	player:SetAttribute("StealingPlot", nil)
	player:SetAttribute("StealingSlot", nil)

	self:_cleanupStolenAnimal(player)

	-- Restore tools when stealing ends
	self:_restorePlayerTools(player)

	local carryAnimTrack = self.playerCarryAnimTracks[player]
	if carryAnimTrack and carryAnimTrack.IsPlaying then
		carryAnimTrack:Stop()
		carryAnimTrack:Destroy()
	end
	self.playerCarryAnimTracks[player] = nil
end

-- Add this function to your AnimalStealing module
function AnimalStealing:_createBoundingBox(model)
	-- Calculate the bounding box of the model
	local minX, minY, minZ = math.huge, math.huge, math.huge
	local maxX, maxY, maxZ = -math.huge, -math.huge, -math.huge

	for _, part in pairs(model:GetDescendants()) do
		if part:IsA("BasePart") then
			local cf = part.CFrame
			local size = part.Size
			local corners = {
				cf * CFrame.new(-size.X/2, -size.Y/2, -size.Z/2),
				cf * CFrame.new(size.X/2, -size.Y/2, -size.Z/2),
				cf * CFrame.new(-size.X/2, size.Y/2, -size.Z/2),
				cf * CFrame.new(size.X/2, size.Y/2, -size.Z/2),
				cf * CFrame.new(-size.X/2, -size.Y/2, size.Z/2),
				cf * CFrame.new(size.X/2, -size.Y/2, size.Z/2),
				cf * CFrame.new(-size.X/2, size.Y/2, size.Z/2),
				cf * CFrame.new(size.X/2, size.Y/2, size.Z/2)
			}

			for _, corner in pairs(corners) do
				local pos = corner.Position
				minX, minY, minZ = math.min(minX, pos.X), math.min(minY, pos.Y), math.min(minZ, pos.Z)
				maxX, maxY, maxZ = math.max(maxX, pos.X), math.max(maxY, pos.Y), math.max(maxZ, pos.Z)
			end
		end
	end

	-- Create the bounding box
	local boundingBox = Instance.new("Part")
	boundingBox.Name = "BoundingBox"
	boundingBox.Material = Enum.Material.ForceField
	boundingBox.BrickColor = BrickColor.new("Bright blue")
	boundingBox.Transparency = 0.7
	boundingBox.CanCollide = false
	boundingBox.CanQuery = false
	boundingBox.CanTouch = false
	boundingBox.Anchored = false
	boundingBox.Massless = true

	-- Set size and position
	local sizeX, sizeY, sizeZ = maxX - minX, maxY - minY, maxZ - minZ
	local centerX, centerY, centerZ = (maxX + minX) / 2, (maxY + minY) / 2, (maxZ + minZ) / 2

	boundingBox.Size = Vector3.new(sizeX, sizeY, sizeZ)
	boundingBox.CFrame = CFrame.new(centerX, centerY, centerZ)
	boundingBox.Parent = model

	-- Create selection box for better visibility
	local selectionBox = Instance.new("SelectionBox")
	selectionBox.Adornee = boundingBox
	selectionBox.Color3 = Color3.fromRGB(0, 162, 255)
	selectionBox.LineThickness = 0.2
	selectionBox.Transparency = 0.3
	selectionBox.Parent = boundingBox

	return boundingBox, Vector3.new(sizeX, sizeY, sizeZ), Vector3.new(centerX, centerY, centerZ)
end

-- Modified version of your _createStolenAnimalModel function
function AnimalStealing:_createStolenAnimalModel(player, animalData, isStolen)
	local character = player.Character
	if not character or not character:FindFirstChild("HumanoidRootPart") then
		warn("[AnimalStealing] Player character or HumanoidRootPart not found for _createCarriedAnimalModel.")
		return
	end

	local animalModelFolder = ReplicatedStorage:FindFirstChild("Models")
	if not animalModelFolder then
		warn("[AnimalStealing] 'Models' folder not found in ReplicatedStorage.")
		return
	end

	local animalsFolder = animalModelFolder:FindFirstChild("Animals")
	if not animalsFolder then
		warn("[AnimalStealing] 'Animals' folder not found in ReplicatedStorage/Models.")
		return
	end

	local animalTemplate = animalsFolder:FindFirstChild(animalData.Index)
	if not animalTemplate then
		warn("[AnimalStealing] Animal template not found for index:", animalData.Index)
		return
	end

	local carriedAnimalModel = animalTemplate:Clone()
	carriedAnimalModel:SetAttribute("Index", animalData.Index)
	if animalData.Mutation then
		carriedAnimalModel:SetAttribute("Mutation", animalData.Mutation)
	end
	if animalData.Traits then
		local traitsToSet = animalData.Traits
		if typeof(animalData.Traits) == "table" then
			traitsToSet = HttpService:JSONEncode(animalData.Traits)
		end
		carriedAnimalModel:SetAttribute("Traits", traitsToSet)
	end

	carriedAnimalModel.Parent = workspace

	-- Apply mutations and traits (existing code)
	if animalData.Mutation then
		local sharedAnimals = require(ReplicatedStorage.Shared.Animals)
		sharedAnimals:ApplyMutation(carriedAnimalModel, animalData.Index, animalData.Mutation)
	end

	if animalData.Traits then
		local sharedAnimals = require(ReplicatedStorage.Shared.Animals)
		local traitsArray = animalData.Traits
		if typeof(animalData.Traits) == "string" then
			local success, decoded = pcall(function()
				return HttpService:JSONDecode(animalData.Traits)
			end)
			if success then
				traitsArray = decoded
			end
		end
		if traitsArray and type(traitsArray) == "table" then
			sharedAnimals:ApplyTraits(carriedAnimalModel, animalData.Index, traitsArray)
		end
	end

	-- Set up animations (existing code)
	local animationsFolder = ReplicatedStorage:FindFirstChild("Animations")
	if animationsFolder then
		local animalsAnimFolder = animationsFolder:FindFirstChild("Animals")
		if animalsAnimFolder then
			local specificAnimFolder = animalsAnimFolder:FindFirstChild(animalData.Index)
			if specificAnimFolder then
				local idleAnim = specificAnimFolder:FindFirstChild("Idle")
				if idleAnim then
					local animController = carriedAnimalModel:FindFirstChildOfClass("AnimationController")
					if not animController then
						animController = Instance.new("AnimationController")
						animController.Name = "AnimationController"
						animController.Parent = carriedAnimalModel
					end

					local animator = animController:FindFirstChildOfClass("Animator")
					if not animator then
						animator = Instance.new("Animator")
						animator.Parent = animController
					end

					local success, track = pcall(function()
						return animator:LoadAnimation(idleAnim)
					end)
					if success and track then
						track.Looped = true
						track:Play()
					end
				end
			end
		end
	end

	-- Make parts non-collidable (existing code)
	for _, part in carriedAnimalModel:GetDescendants() do
		if part:IsA("BasePart") then
			part.CanCollide = false
			part.CanQuery = false
			part.CanTouch = false
			part.Massless = true
			part.Anchored = false
		end
	end

	-- Create bounding box and get dimensions
	local boundingBox, boxSize, boxCenter = self:_createBoundingBox(carriedAnimalModel)

	-- Create a handle part at the back bottom of the bounding box
	local handlePart = Instance.new("Part")
	handlePart.Name = "CarryHandle"
	handlePart.Size = Vector3.new(0.5, 0.5, 0.5)
	handlePart.Material = Enum.Material.Neon
	handlePart.BrickColor = BrickColor.new("Bright green")
	handlePart.Transparency = 0.5
	handlePart.CanCollide = false
	handlePart.CanQuery = false
	handlePart.CanTouch = false
	handlePart.Massless = true
	handlePart.Anchored = false
	handlePart.Shape = Enum.PartType.Ball
	handlePart.Parent = carriedAnimalModel

	-- Position the handle at the back bottom of the bounding box
	-- Back = positive Z direction, Bottom = negative Y direction
	local handleOffset = CFrame.new(0, -boxSize.Y/2 - 0.5, boxSize.Z/2 + 0.5)

	-- Get the primary part or use bounding box center
	local primaryPart = carriedAnimalModel.PrimaryPart or boundingBox

	-- Position the animal model relative to player
	local playerRootPart = character.HumanoidRootPart
	local carryOffset = CFrame.new(0, 2.5, -2) -- More up (2.5) and even more forward (-0.5)

	-- Position the primary part
	primaryPart.CFrame = playerRootPart.CFrame * carryOffset

	-- Position the handle relative to the bounding box center
	handlePart.CFrame = boundingBox.CFrame * handleOffset

	-- Create weld constraint between player and the handle (this is the key change)
	local weldConstraint = Instance.new("WeldConstraint")
	weldConstraint.Part0 = playerRootPart
	weldConstraint.Part1 = handlePart
	weldConstraint.Parent = handlePart

	-- Create weld constraints to keep the animal model parts together
	local modelWeld = Instance.new("WeldConstraint")
	modelWeld.Part0 = handlePart
	modelWeld.Part1 = primaryPart
	modelWeld.Parent = primaryPart

	-- Weld bounding box to the model
	local boxWeld = Instance.new("WeldConstraint")
	boxWeld.Part0 = primaryPart
	boxWeld.Part1 = boundingBox
	boxWeld.Parent = boundingBox

	self:_addStolenOverhead(carriedAnimalModel, primaryPart, isStolen)

	self.playerStolenModels[player] = carriedAnimalModel

	if animalData.Index == "La Vacca Saturno Saturnita" and isStolen then
		self:_tagVisualStolenModel(player, carriedAnimalModel)
	end

	return carriedAnimalModel
end

-- Optional: Add a function to toggle bounding box visibility
function AnimalStealing:toggleBoundingBox(player, visible)
	local stolenModel = self.playerStolenModels[player]
	if not stolenModel then return end

	local boundingBox = stolenModel:FindFirstChild("BoundingBox")
	if boundingBox then
		boundingBox.Transparency = visible and 0.7 or 1
		local selectionBox = boundingBox:FindFirstChildOfClass("SelectionBox")
		if selectionBox then
			selectionBox.Transparency = visible and 0.3 or 1
		end
	end

	local handle = stolenModel:FindFirstChild("CarryHandle")
	if handle then
		handle.Transparency = visible and 0.5 or 1
	end
end

function AnimalStealing:_addStolenOverhead(carriedAnimalModel, attachmentPart, isStolen)
	local overheadsFolder = ReplicatedStorage:FindFirstChild("Overheads")
	if not overheadsFolder then
		warn("[AnimalStealing] 'Overheads' folder not found in ReplicatedStorage.")
		return
	end

	local animalOverheadTemplate = overheadsFolder:FindFirstChild("AnimalOverhead")
	if not animalOverheadTemplate then
		warn("[AnimalStealing] 'AnimalOverhead' template not found in Overheads folder.")
		return
	end

	local carriedOverhead = animalOverheadTemplate:Clone()

	if isStolen then
		carriedOverhead.DisplayName.Text = "STOLEN"
		carriedOverhead.DisplayName.TextColor3 = Color3.fromRGB(255, 0, 0)
	else
		carriedOverhead.DisplayName.Text = ""
	end

	carriedOverhead.DisplayName.TextStrokeTransparency = 0
	carriedOverhead.DisplayName.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)

	carriedOverhead.Generation.Visible = false
	carriedOverhead.Price.Visible = false
	carriedOverhead.Rarity.Visible = false
	carriedOverhead.Mutation.Visible = false

	local AnimalsData = require(ReplicatedStorage.Datas.Animals) -- Re-require to ensure it's the correct path if different from Shared
	local animalIndex = carriedAnimalModel:GetAttribute("Index")
	local animalData = animalIndex and AnimalsData[animalIndex]
	local overheadYOffsetModifier = (animalData and animalData.OverheadYOffsetModifier) or 1

	local overheadAttachment = Instance.new("Attachment")
	overheadAttachment.Name = "CarriedOverhead"
	overheadAttachment.CFrame = CFrame.new(0, 3 * overheadYOffsetModifier, 0)

	local primaryPart = carriedAnimalModel.PrimaryPart
	if primaryPart then
		overheadAttachment.Parent = primaryPart
	else
		-- Fallback to the provided attachmentPart or first child if primaryPart doesn't exist
		overheadAttachment.Parent = attachmentPart or carriedAnimalModel:GetChildren()[1]
	end

	carriedOverhead.Parent = overheadAttachment
end


function AnimalStealing:_playCarryAnimation(player)
	local character = player.Character
	if not character then return end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid then return end

	local animator = humanoid:FindFirstChildOfClass("Animator")
	if not animator then
		animator = Instance.new("Animator")
		animator.Parent = humanoid
	end

	local carryAnim = ReplicatedStorage:FindFirstChild("Animations")
	if not carryAnim then
		return
	end

	local playerAnims = carryAnim:FindFirstChild("Player")
	if not playerAnims then
		return
	end

	local carryAnimation = playerAnims:FindFirstChild("Carry")
	if not carryAnimation then
		return
	end

	local animTrack = animator:LoadAnimation(carryAnimation)
	animTrack.Looped = true
	animTrack:Play()
	self.playerCarryAnimTracks[player] = animTrack
end

function AnimalStealing:_sendNotification(player, message)
	local NotificationEvent = Net:RemoteEvent("NotificationService/Notify")
	if NotificationEvent and player then
		NotificationEvent:FireClient(player, message, 3)
	end
end

function AnimalStealing:_getColoredAnimalName(animalIndex)
	local Animals = require(ReplicatedStorage.Datas.Animals)
	local Rarities = require(ReplicatedStorage.Datas.Rarities)

	local animalData = Animals[animalIndex]
	if not animalData then
		return animalIndex
	end

	local rarityData = Rarities[animalData.Rarity]
	if not rarityData then
		return animalData.DisplayName
	end

	local color = rarityData.Color
	local r = math.floor(color.R * 255)
	local g = math.floor(color.G * 255)
	local b = math.floor(color.B * 255)
	local hexColor = string.format("#%02X%02X%02X", r, g, b)

	return string.format('<font color="%s">%s</font>', hexColor, animalData.DisplayName)
end
local LastPlot
function AnimalStealing:handleGrab(player, actionId, plotUUID, animalSlot)
	if actionId == "Grab" then
		if not DataManagment.isDataReady(player) then
			return false, "Player data not ready."
		end

		if not actionId or not plotUUID or not animalSlot then
			return false, "Missing parameters for grab."
		end

		if self.playerStolenModels[player] then
			self:_sendNotification(player, "You are already carrying an animal.")
			return false, "Already carrying an animal."
		end

		local playerPlot = self.plotManager:GetPlayerPlot(player)
		if not playerPlot or playerPlot:GetUUID() ~= plotUUID then
			self:_sendNotification(player, "You can only grab animals from your own plot.")
			return false, "Not your plot."
		end

		local playerPlotSync = playerPlot:GetSynchronizer()
		if not playerPlotSync then
			warn("[AnimalStealing] Player plot synchronizer not found for grab.")
			return false, "Plot data not available."
		end

		local animalList = playerPlotSync:Get("AnimalList") or {}
		local animal = animalList[animalSlot]

		if not animal or animal == PlotConstants.STATES.EMPTY or typeof(animal) ~= "table" then
			self:_sendNotification(player, "No animal found at this slot on your plot.")
			return false, "Invalid animal slot."
		end

		if animal.Steal == true then
			local stealingPlayer = nil
			for _, otherPlayer in pairs(Players:GetPlayers()) do
				if otherPlayer:GetAttribute("Stealing") and
					otherPlayer:GetAttribute("StealingPlot") == plotUUID and
					otherPlayer:GetAttribute("StealingSlot") == animalSlot then
					stealingPlayer = otherPlayer
					break
				end
			end
			if stealingPlayer then
				self:_sendNotification(player, "Your " .. self:_getColoredAnimalName(animal.Index) .. " is currently being stolen!")
				return false, "Animal is being stolen."
			else
				warn("[AnimalStealing] Orphaned 'Steal' state detected for owned animal during grab. Resetting.")
				local animalManager = self.plotManager:GetAnimalManager(playerPlot)
				if animalManager then
					animalManager:SetStealState(animalSlot, false)
					animal.Steal = false
				end
			end
		end

		local createdModel = self:_createStolenAnimalModel(player, animal, false)
		if not createdModel then
			return false, "erm. ignore this ALL works"
		end

		self:_playCarryAnimation(player)
		LastPlot = animalSlot

		-- Store original animal data before marking as being carried
		player:SetAttribute("CarriedAnimalData", HttpService:JSONEncode(animal))

		animal.Steal = player.UserId
		playerPlotSync:Set("AnimalList", animalList)
		playerPlotSync:Set("AnimalPodiums", animalList)
		player:SetAttribute("Stealing", true)
		player:SetAttribute("StealingPlot", plotUUID)
		player:SetAttribute("StealingSlot", animalSlot)
		player:SetAttribute("IsCarryingOwned", true)

		return true, "Animal grabbed successfully."

	elseif actionId == "Place" then
		if not DataManagment.isDataReady(player) then
			return false, "Player data not ready."
		end

		if not plotUUID or not animalSlot then
			return false, "Missing parameters for placing."
		end

		local playerPlot = self.plotManager:GetPlayerPlot(player)
		if not playerPlot or playerPlot:GetUUID() ~= plotUUID then
			self:_sendNotification(player, "You can only place animals on your own plot.")
			return false, "Not your plot."
		end

		if not player:GetAttribute("Stealing") or not player:GetAttribute("IsCarryingOwned") then
			self:_sendNotification(player, "You are not carrying an owned animal to place.")
			return false, "Not carrying owned animal."
		end

		local playerPlotSync = playerPlot:GetSynchronizer()
		if not playerPlotSync then
			warn("[AnimalStealing] Player plot synchronizer not found for place.")
			return false, "Plot data not available."
		end

		local animalList = playerPlotSync:Get("AnimalList") or {}
		local originalSlot = LastPlot -- The slot where the animal was originally grabbed from
		local targetSlot = animalSlot -- The slot where the player wants to place the animal

		local stolenModel = self.playerStolenModels[player]
		if not stolenModel then
			self:_sendNotification(player, "No animal model found to place.")
			self:_cleanupStealState(player)
			return false, "No animal model."
		end

		-- Get the carried animal data
		local carriedAnimalDataStr = player:GetAttribute("CarriedAnimalData")
		if not carriedAnimalDataStr then
			self:_sendNotification(player, "Error: Carried animal data not found.")
			self:_cleanupStealState(player)
			return false, "Carried animal data missing."
		end

		local carriedAnimalData
		local success, decoded = pcall(function()
			return HttpService:JSONDecode(carriedAnimalDataStr)
		end)
		if not success then
			self:_sendNotification(player, "Error: Failed to decode carried animal data.")
			self:_cleanupStealState(player)
			return false, "Failed to decode animal data."
		end
		carriedAnimalData = decoded

		-- Reset the Steal flag for the carried animal
		carriedAnimalData.Steal = false
		carriedAnimalData.LastCollect = workspace:GetServerTimeNow()

		-- Check if target slot has an animal
		local targetAnimal = animalList[targetSlot]
		local isTargetSlotEmpty = (not targetAnimal or targetAnimal == PlotConstants.STATES.EMPTY or typeof(targetAnimal) ~= "table")

		if isTargetSlotEmpty then
			animalList[originalSlot] = PlotConstants.STATES.EMPTY
			animalList[targetSlot] = carriedAnimalData

			local coloredAnimalName = self:_getColoredAnimalName(carriedAnimalData.Index)
		else
			-- Swap animals - target slot has an animal
			local targetAnimalData = {}
			for key, value in pairs(targetAnimal) do
				targetAnimalData[key] = value
			end
			targetAnimalData.LastCollect = workspace:GetServerTimeNow()
			targetAnimalData.Steal = false

			animalList[originalSlot] = targetAnimalData
			animalList[targetSlot] = carriedAnimalData

			local carriedAnimalName = self:_getColoredAnimalName(carriedAnimalData.Index)
			local targetAnimalName = self:_getColoredAnimalName(targetAnimalData.Index)
		end

		-- Update the plot
		playerPlotSync:Set("AnimalList", animalList)
		playerPlotSync:Set("AnimalPodiums", animalList)

		-- Clean up player state
		self:_cleanupStealState(player)
		player:SetAttribute("Stealing", false)
		player:SetAttribute("IsCarryingOwned", nil)
		player:SetAttribute("CarriedAnimalData", nil)

		return true, "Animal placement completed successfully."
	end
end

function AnimalStealing:handleStealAttempt(player, timestamp, actionId, targetPlotName, animalSlot)
	if not DataManagment.isDataReady(player) then
		print("[AnimalStealing] Data not ready for player:", player.Name)
		return
	end

	if not timestamp or not actionId or not targetPlotName or not animalSlot then
		print("[AnimalStealing] Missing parameters for player:", player.Name)
		return
	end

	local timeDiff = math.abs(workspace:GetServerTimeNow() - (timestamp - PlotConstants.SECURITY.TIMESTAMP_OFFSET))
	if timeDiff > PlotConstants.SECURITY.TIMESTAMP_TOLERANCE then
		print("[AnimalStealing] Timestamp validation failed for player:", player.Name, "TimeDiff:", timeDiff)
		--return
	end

	local targetPlot = self.plotManager:GetPlotByUUID(targetPlotName)
	if not targetPlot then
		print("[AnimalStealing] Target plot not found:", targetPlotName, "for player:", player.Name)
		--return
	end

	local targetOwner = targetPlot:GetOwner()
	if not targetOwner or targetOwner == player then
		print("[AnimalStealing] Invalid target owner for player:", player.Name)
		--return
	end
	
	local distance = (playerCharacter.HumanoidRootPart.Position - targetPlotModel.Position).Magnitude
	local MAX_STEAL_DISTANCE = 50 -- Adjust as needed

	if distance > MAX_STEAL_DISTANCE then
		print("[AnimalStealing] Player too far away:", player.Name, "Distance:", distance, "Max allowed:", MAX_STEAL_DISTANCE)
		self:_sendNotification(player, "You're too far away to steal from this plot!")
		return
	end

	-- Continue with existing security manager check
	local securityManager = self.plotManager:GetSecurityManager(targetPlot)
	if securityManager then
		local canSteal, reason = securityManager:CanPlayerSteal(player, targetPlot)
		if not canSteal then
			print("[AnimalStealing] Security check failed for player:", player.Name, "Reason:", reason)
			--return
		end
	end

	local securityManager = self.plotManager:GetSecurityManager(targetPlot)
	if securityManager then
		local canSteal, reason = securityManager:CanPlayerSteal(player, targetPlot)
		if not canSteal then
			print("[AnimalStealing] Security check failed for player:", player.Name, "Reason:", reason)
			--return
		end
	end

	local notificationKey = targetOwner.UserId .. "_" .. animalSlot
	local currentTime = tick()
	if self.stealNotificationDebounce[notificationKey] then
		local timeSinceLastNotification = currentTime - self.stealNotificationDebounce[notificationKey]
		if timeSinceLastNotification < 3 then
			print("[AnimalStealing] Notification debounce active for player:", player.Name, "Time remaining:", 3 - timeSinceLastNotification)
			--return
		end
	end

	local animalList = self:_validateAndRepairAnimalList(targetPlot, targetPlotName)
	local animal = animalList[animalSlot]

	if not animal or animal == PlotConstants.STATES.EMPTY or typeof(animal) ~= "table" then
		print("[AnimalStealing] Invalid animal at slot", animalSlot, "for player:", player.Name, "Animal:", animal)
		return
	end

	if player:GetAttribute("Stealing") then
		local currentStealingPlot = player:GetAttribute("StealingPlot")
		local currentStealingSlot = player:GetAttribute("StealingSlot")

		if not currentStealingPlot or not currentStealingSlot then
			self:_cleanupStealState(player)
		else
			if currentStealingPlot == targetPlotName and currentStealingSlot == animalSlot then
				return
			else
				local now = tick()
				if (self.alreadyStealingDebounce[player] or 0) < now - 0.5 then
					local coloredAnimalName = self:_getColoredAnimalName(animal.Index)
					self.alreadyStealingDebounce[player] = now
				end
				return
			end
		end
	end

	if animal.Steal == true then
		local actuallyBeingStolen = false
		local stealingPlayer = nil

		for _, otherPlayer in pairs(Players:GetPlayers()) do
			if otherPlayer:GetAttribute("Stealing") and 
				otherPlayer:GetAttribute("StealingPlot") == targetPlotName and 
				otherPlayer:GetAttribute("StealingSlot") == animalSlot then
				actuallyBeingStolen = true
				stealingPlayer = otherPlayer
				break
			end
		end

		if not actuallyBeingStolen then
			self:_resetOrphanedStealState(targetPlot, targetOwner, animalList, animalSlot)
		else
			if stealingPlayer == player then
				return
			else
				local coloredAnimalName = self:_getColoredAnimalName(animal.Index)
				self:_sendNotification(player, coloredAnimalName .. " is already being stolen by " .. stealingPlayer.Name)
				return
			end
		end
	end

	local playerAnimalList = DataManagment.getAnimalList(player)
	local maxAnimals = DataManagment.GetMaxAnimals(player)

	local currentAnimals = 0
	for _, ownedAnimal in ipairs(playerAnimalList) do
		if ownedAnimal ~= "Empty" and ownedAnimal ~= nil then
			currentAnimals += 1
		end
	end

	if currentAnimals >= maxAnimals then
		print("[AnimalStealing] Player", player.Name, "has full capacity:", currentAnimals, "/", maxAnimals)
		local now = tick()
		if (self.capacityFullDebounce[player] or 0) < now - 2 then
			self:_sendNotification(player, "<font color=\"#FA0103\">You need more room in your base to steal a brainrot!</font>")
			self.capacityFullDebounce[player] = now
		end
		--	return
	end

	self.stealNotificationDebounce[notificationKey] = currentTime

	local coloredAnimalName = self:_getColoredAnimalName(animal.Index)
	self:_sendNotification(targetOwner, "Someone is stealing your " .. coloredAnimalName)

	local animalManager = self.plotManager:GetAnimalManager(targetPlot)
	if animalManager then
		animalManager:SetStealState(animalSlot, true)
	end

	player:SetAttribute("Stealing", true)
	player:SetAttribute("StealingPlot", targetPlotName)
	player:SetAttribute("StealingSlot", animalSlot)

	self:_createStolenAnimalModel(player, animal)
	self:_playCarryAnimation(player)

	print("[AnimalStealing] Successfully started steal for player:", player.Name, "Animal:", animal.Index, "Slot:", animalSlot)
end

function AnimalStealing:_resetOrphanedStealState(targetPlot, targetOwner, animalList, animalSlot)
	local animal = animalList[animalSlot]
	if not animal or typeof(animal) ~= "table" or not animal.Index then
		return
	end

	animal.Steal = false

	if targetOwner then
		local targetData = DataManagment.GetDataMan(targetOwner)
		if targetData and targetData.AnimalList and targetData.AnimalList[animalSlot] then
			local ownerAnimal = targetData.AnimalList[animalSlot]
			if typeof(ownerAnimal) == "table" and ownerAnimal.Index then
				ownerAnimal.Steal = false
			end
		end
	end

	local currentAnimalList = targetPlot:Get("AnimalList") or {}
	if currentAnimalList[animalSlot] and typeof(currentAnimalList[animalSlot]) == "table" and currentAnimalList[animalSlot].Index then
		targetPlot:Set(("AnimalList.%d.Steal"):format(animalSlot), false)
	else
		targetPlot:Set("AnimalList", animalList)
	end

	if targetOwner then
		local targetPlayerSync = Synchronizer:Get(targetOwner)
		if targetPlayerSync then
			local playerAnimalList = targetPlayerSync:Get("AnimalList") or {}
			if playerAnimalList[animalSlot] and typeof(playerAnimalList[animalSlot]) == "table" and playerAnimalList[animalSlot].Index then
				targetPlayerSync:Set(("AnimalList.%d.Steal"):format(animalSlot), false)
			else
				local targetData = DataManagment.GetDataMan(targetOwner)
				if targetData then
					targetPlayerSync:Set("AnimalAddedOrRemoved", targetData.AnimalList)
					targetPlayerSync:Set("AnimalPodiums", targetData.AnimalList)
				end
			end

			local targetData = DataManagment.GetDataMan(targetOwner)
			if targetData then
				targetPlayerSync:Set("AnimalAddedOrRemoved", targetData.AnimalList)
				targetPlayerSync:Set("AnimalPodiums", targetData.AnimalList)
			end
		end
	end
end

function AnimalStealing:_setStealState(targetPlot, targetOwner, animalList, animalSlot, stealState)
	local animal = animalList[animalSlot]
	if not animal or typeof(animal) ~= "table" or not animal.Index then
		return false
	end

	animal.Steal = stealState

	if targetOwner then
		local targetData = DataManagment.GetDataMan(targetOwner)
		if targetData and targetData.AnimalList and targetData.AnimalList[animalSlot] then
			local ownerAnimal = targetData.AnimalList[animalSlot]
			if typeof(ownerAnimal) == "table" and ownerAnimal.Index then
				ownerAnimal.Steal = stealState
			end
		end
	end

	local currentAnimalList = targetPlot:Get("AnimalList") or {}
	if currentAnimalList[animalSlot] and typeof(currentAnimalList[animalSlot]) == "table" and currentAnimalList[animalSlot].Index then
		targetPlot:Set(("AnimalList.%d.Steal"):format(animalSlot), stealState)
	else
		targetPlot:Set("AnimalList", animalList)
	end

	if targetOwner then
		local targetPlayerSync = Synchronizer:Get(targetOwner)
		if targetPlayerSync then
			local playerAnimalList = targetPlayerSync:Get("AnimalList") or {}
			if playerAnimalList[animalSlot] and typeof(playerAnimalList[animalSlot]) == "table" and playerAnimalList[animalSlot].Index then
				targetPlayerSync:Set(("AnimalList.%d.Steal"):format(animalSlot), stealState)
			else
				local targetData = DataManagment.GetDataMan(targetOwner)
				if targetData then
					targetPlayerSync:Set("AnimalAddedOrRemoved", targetData.AnimalList)
					targetPlayerSync:Set("AnimalPodiums", targetData.AnimalList)
				end
			end

			local targetData = DataManagment.GetDataMan(targetOwner)
			if targetData then
				targetPlayerSync:Set("AnimalAddedOrRemoved", targetData.AnimalList)
				targetPlayerSync:Set("AnimalPodiums", targetData.AnimalList)
			end
		end
	end

	return true
end

function AnimalStealing:handleDelivery(player, actionId)
	local currentTime = tick()
	if self.deliveryDebounce[player] then
		local timeSinceLastCall = currentTime - self.deliveryDebounce[player]
		if timeSinceLastCall < 2 then
			return 
		end
	end

	self.deliveryDebounce[player] = currentTime

	if not DataManagment.isDataReady(player) then
		return
	end

	if not player:GetAttribute("Stealing") then
		return
	end

	local stealingPlot = player:GetAttribute("StealingPlot")
	local stealingSlot = player:GetAttribute("StealingSlot")

	if not stealingPlot or not stealingSlot then
		self:_cleanupStealState(player)
		player:SetAttribute("Stealing", false)
		return
	end

	local playerData = DataManagment.GetDataMan(player)
	if not playerData then
		return
	end

	local targetPlot = Synchronizer:Get(stealingPlot)
	local ownerLeftGame = false
	if not targetPlot then
		local stolenAnimalModel = self.playerStolenModels[player]
		if stolenAnimalModel and stolenAnimalModel.Parent and stolenAnimalModel:GetAttribute("Index") then
			print("[AnimalStealing] Target plot not found, but stolen model exists - owner likely left game")
			ownerLeftGame = true
		else
			self:_cleanupStealState(player)
			player:SetAttribute("Stealing", false)
			return
		end
	end

	local animalList = {}
	local animal = nil
	local slotIndex = tonumber(stealingSlot)
	if not slotIndex then
		print("[AnimalStealing] Invalid stealingSlot for indexing:", stealingSlot, "Type:", typeof(stealingSlot))
		self:_cleanupStealState(player)
		player:SetAttribute("Stealing", false)
		return
	end

	if not ownerLeftGame then
		animalList = targetPlot:Get("AnimalList") or {}
		animal = animalList[slotIndex]
	else
		print("[AnimalStealing] Owner left game, using stolen model for animal data")
	end

	local stolenAnimalModel = self.playerStolenModels[player]
	local hasValidStolenModel = stolenAnimalModel and stolenAnimalModel.Parent and stolenAnimalModel:GetAttribute("Index")

	print("[DEBUG] Animal from plot:", animal, "Type:", typeof(animal))
	print("[DEBUG] Has valid stolen model:", hasValidStolenModel)
	if hasValidStolenModel then
		print("[DEBUG] Stolen model attributes - Index:", stolenAnimalModel:GetAttribute("Index"), "Mutation:", stolenAnimalModel:GetAttribute("Mutation"), "Traits:", stolenAnimalModel:GetAttribute("Traits"))
	end

	local capturedAnimal = nil
	if animal and typeof(animal) == "table" and animal.Steal then
		capturedAnimal = {
			Index = animal.Index,
			Mutation = animal.Mutation,
			Traits = animal.Traits,
			Steal = true
		}
		print("[DEBUG] Captured animal data from target plot:", capturedAnimal.Index, "Mutation:", capturedAnimal.Mutation)
	elseif hasValidStolenModel then
		capturedAnimal = {
			Index = stolenAnimalModel:GetAttribute("Index"),
			Mutation = stolenAnimalModel:GetAttribute("Mutation"),
			Traits = stolenAnimalModel:GetAttribute("Traits"),
			Steal = true
		}
		print("[DEBUG] Captured animal data from stolen model:", capturedAnimal.Index, "Mutation:", capturedAnimal.Mutation)
	end

	if not capturedAnimal then
		print("[AnimalStealing] Cannot deliver - no valid stolen animal found")
		self:_cleanupStealState(player)
		player:SetAttribute("Stealing", false)
		return
	end

	animal = capturedAnimal

	local playerPlot = self.plotManager:GetPlayerPlot(player)
	if not playerPlot then
		self:_cleanupStealState(player)
		player:SetAttribute("Stealing", false)
		return
	end

	local playerPlotModel = playerPlot:GetPlotModel()
	if not playerPlotModel then
		self:_cleanupStealState(player)
		player:SetAttribute("Stealing", false)
		return
	end

	local stolenAnimal = {
		Index = animal.Index,
		LastCollect = workspace:GetServerTimeNow(),
		Mutation = animal.Mutation,
		Traits = animal.Traits,
		Steal = false
	}

	print("[DEBUG] Captured stolen animal data:", stolenAnimal.Index, "Mutation:", stolenAnimal.Mutation, "Traits:", stolenAnimal.Traits)

	local stolenAnimalModel = self.playerStolenModels[player]

	local carryAnimTrack = self.playerCarryAnimTracks[player]
	if carryAnimTrack and carryAnimTrack.IsPlaying then
		carryAnimTrack:Stop()
		carryAnimTrack:Destroy()
	end
	self.playerCarryAnimTracks[player] = nil

	player:SetAttribute("Stealing", false)
	player:SetAttribute("StealingPlot", nil)
	player:SetAttribute("StealingSlot", nil)

	if not ownerLeftGame and animalList[slotIndex] and typeof(animalList[slotIndex]) == "table" then
		animalList[slotIndex] = "Empty"
		targetPlot:Set("AnimalList", animalList)
		targetPlot:Set("AnimalPodiums", animalList)
	end

	if not ownerLeftGame then
		local targetOwner = targetPlot:Get("Owner")
		if targetOwner then
			local ownerUserId = typeof(targetOwner) == "Instance" and targetOwner.UserId or targetOwner
			local ownerPlayer = Players:GetPlayerByUserId(ownerUserId)
			if ownerPlayer then
				DataManagment.removeAnimal(ownerPlayer, slotIndex)

				local targetPlayerSync = Synchronizer:Get(ownerPlayer)
				if targetPlayerSync then
					local targetData = DataManagment.GetDataMan(ownerPlayer)
					if targetData then
						targetPlayerSync:Set("AnimalAddedOrRemoved", targetData.AnimalList)
						targetPlayerSync:Set("AnimalPodiums", targetData.AnimalList)
					end
				end
			else
				print("[AnimalStealing] Owner left game, but animal data preserved for delivery:", stolenAnimal.Index, "Mutation:", stolenAnimal.Mutation)
			end
		end
	else
		print("[AnimalStealing] Owner already left game, skipping owner data cleanup for:", stolenAnimal.Index, "Mutation:", stolenAnimal.Mutation)
	end

	print("[DEBUG] About to process stolen animal delivery for:", player.Name, "Animal:", stolenAnimal.Index)
	local deliverySuccess = self:_processStolenAnimalDelivery(player, stolenAnimal, playerPlot)
	print("[DEBUG] Delivery result:", deliverySuccess)

	if stolenAnimalModel and stolenAnimalModel.Parent then
		if CollectionService:HasTag(stolenAnimalModel, "LaVaccaModel") then
			if not stolenAnimalModel:GetAttribute("PreserveOnStealingEnd") then
				CollectionService:RemoveTag(stolenAnimalModel, "LaVaccaModel")
				stolenAnimalModel:Destroy()
			else
				print("[AnimalStealing] 🎭 Preserving La Vacca model:", stolenAnimalModel.Name)
			end
		else
			stolenAnimalModel:Destroy()
		end
	end
	self.playerStolenModels[player] = nil
end

function AnimalStealing:_findEmptySlot(player)
	if not DataManagment.isDataReady(player) then
		warn("[EmptySlotHandler] Data not ready for player:", player.Name)
		return nil
	end

	local animalList = DataManagment.getAnimalList(player)
	if not animalList then
		warn("[EmptySlotHandler] No animal list found for player:", player.Name)
		return nil
	end

	local maxAnimals = DataManagment.GetMaxAnimals(player)
	for i = 1, maxAnimals do
		if animalList[i] == "Empty" or animalList[i] == nil then
			return i
		end
	end

	return nil
end

function AnimalStealing:_processStolenAnimalDelivery(player, stolenAnimal, playerPlot)
	local playerData = DataManagment.GetDataMan(player)
	if not playerData then
		print("[DEBUG] No player data for:", player.Name)
		return false
	end

	local isDataReady = DataManagment.isDataReady(player)
	print("[DEBUG] Data ready for", player.Name, ":", isDataReady)

	if not isDataReady then
		print("[DEBUG] Player data not ready, waiting...")
		local success = DataManagment.waitForData(player, 10)
		if not success then
			print("[DEBUG] Failed to wait for data for:", player.Name)
			self:_sendNotification(player, "Failed to deliver animal - data not ready!")
			return false
		end
	end

	print("[DEBUG] Delivering stolen animal:", stolenAnimal.Index, "Mutation:", stolenAnimal.Mutation, "Traits:", stolenAnimal.Traits, "for player:", player.Name)

	local traitsString = nil
	if stolenAnimal.Traits and typeof(stolenAnimal.Traits) == "table" then
		local HttpService = game:GetService("HttpService")
		local success, encoded = pcall(HttpService.JSONEncode, HttpService, stolenAnimal.Traits)
		if success then
			traitsString = encoded
		else
			print("[DEBUG] Failed to encode traits:", stolenAnimal.Traits)
		end
	elseif typeof(stolenAnimal.Traits) == "string" then
		traitsString = stolenAnimal.Traits
	end

	print("[DEBUG] Calling DataManagment.addAnimal with:", stolenAnimal.Index, stolenAnimal.Mutation, traitsString)
	local addedSlot = DataManagment.addAnimal(player, stolenAnimal.Index, stolenAnimal.Mutation, traitsString)
	print("[DEBUG] DataManagment.addAnimal returned:", addedSlot)

	if not addedSlot then
		print("[DEBUG] Failed to add animal - base might be full")
		self:_sendNotification(player, "Your base is full! Cannot steal more animals.")
		return false
	end

	print("[DEBUG] Successfully added stolen animal to slot:", addedSlot)

	local updatedAnimalList = DataManagment.getAnimalList(player)

	task.wait(0.1)

	local playerPlotSync = playerPlot:GetSynchronizer()
	playerPlotSync:Set("AnimalList", updatedAnimalList)
	playerPlotSync:Set("AnimalPodiums", updatedAnimalList)

	local playerSync = Synchronizer:Get(player)
	if playerSync then
		playerSync:Set("AnimalAddedOrRemoved", updatedAnimalList)
		playerSync:Set("AnimalPodiums", updatedAnimalList)
	end

	local coloredAnimalName = self:_getColoredAnimalName(stolenAnimal.Index)
	self:_sendNotification(player, "You stole " .. coloredAnimalName)

	DataManagment.addSteals(player, 1)
	local updatedPlayerData = DataManagment.GetDataMan(player)
	if updatedPlayerData and playerSync then
		playerSync:Set("Steals", updatedPlayerData.Steals or 0)
	end

	return true
end

function AnimalStealing:_tagVisualStolenModel(player, stolenAnimalModel)
	if not stolenAnimalModel or not stolenAnimalModel.Parent then
		warn("[LaVacca Ritual] Visual stolen model not found for player:", player.Name)
		return
	end

	local usedIndices = {}
	for _, model in pairs(workspace:GetChildren()) do
		if CollectionService:HasTag(model, "LaVaccaModel") then
			local index = model:GetAttribute("LaVaccaIndex")
			if index then
				usedIndices[index] = true
			end
		end
	end

	local availableIndex = nil
	for i = 1, 3 do
		if not usedIndices[i] then
			availableIndex = i
			break
		end
	end

	if not availableIndex then
		availableIndex = math.random(1, 3)
		for _, model in pairs(workspace:GetChildren()) do
			if CollectionService:HasTag(model, "LaVaccaModel") and 
				model:GetAttribute("LaVaccaIndex") == availableIndex then
				CollectionService:RemoveTag(model, "LaVaccaModel")
				model:SetAttribute("LaVaccaIndex", nil)
				break
			end
		end
	end

	stolenAnimalModel:SetAttribute("LaVaccaIndex", availableIndex)
	stolenAnimalModel:SetAttribute("OwnerUserId", player.UserId)
	stolenAnimalModel:SetAttribute("CreatedAt", workspace:GetServerTimeNow())

	CollectionService:AddTag(stolenAnimalModel, "LaVaccaModel")
end

function AnimalStealing:_cleanupStolenAnimal(player)
	local stolenAnimalModel = self.playerStolenModels[player]
	if stolenAnimalModel and stolenAnimalModel.Parent then
		if CollectionService:HasTag(stolenAnimalModel, "LaVaccaModel") then
			CollectionService:RemoveTag(stolenAnimalModel, "LaVaccaModel")
		end
		stolenAnimalModel:Destroy()
	end

	local carryAnimTrack = self.playerCarryAnimTracks[player]
	if carryAnimTrack then
		if carryAnimTrack.IsPlaying then
			carryAnimTrack:Stop()
		end
		carryAnimTrack:Destroy()
		self.playerCarryAnimTracks[player] = nil
	end

	self.playerStolenModels[player] = nil
end

return AnimalStealing