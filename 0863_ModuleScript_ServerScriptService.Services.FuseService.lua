--[[
  Extracted from: ServerScriptService.Services.FuseService
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Synchronizer = require(ReplicatedStorage.Packages.Synchronizer)
local EasyVisuals = require(ReplicatedStorage.Packages.EasyVisuals)
local Trove = require(ReplicatedStorage.Packages.Trove)
local FuseMachineData = require(ReplicatedStorage.Datas.FuseMachineData)
local Rarities = require(ReplicatedStorage.Datas.Rarities)
local Animals = require(ReplicatedStorage.Datas.Animals)
local Net = require(ReplicatedStorage.Packages.Net)
local LocalPlayer = Players.LocalPlayer
local Mutations = require(ReplicatedStorage.Datas.Mutations)
local Remotes = require(ReplicatedStorage.Datas.FuseMachineData)
local DataManagment = require(script.Parent.DataManagment)
local plotsService = script.Parent.Plots
local PlotManager = require(plotsService.PlotManager)
local PlotSynchronizer = require(plotsService.PlotSynchronizer)
local TimeUtils = require(ReplicatedStorage.Utils.TimeUtils)
local RoadSpawner = require(script.Parent.RoadAnimalService.RoadAnimalSpawner)

local FusingService = {}
FusingService.__index = FusingService

local FusionAnimals = {}
for animalIndex, animalData in pairs(Animals) do
	if animalData.Fusion and animalData.Fusion == true then
		if not FusionAnimals[animalData.Rarity] then
			FusionAnimals[animalData.Rarity] = {}
		end
		table.insert(FusionAnimals[animalData.Rarity], animalIndex)
	end
end

function FusingService._new()
	local self = setmetatable({}, FusingService)

	self._Delivered = {}
	self._IsUsing = false
	self._TobeClaimed = false
	self._TimeEnd = 0
	self._Count = 0
	self._Chances = {
		["Common"] = 100,
		["Rare"] = 89,
		["Epic"] = 76,
		["Legendary"] = 59,
		["Mythic"] = 40,
		["Brainrot God"] = 29,
		["Secret"] = 9,
	}
	self._RemoveBrainrot = Net:RemoteFunction("FuseMachine/RemoveBrainrot");
	self._ClaimBrainrot = Net:RemoteFunction("FuseMachine/ClaimBrainrot");
	self._ConfirmFusion = Net:RemoteFunction("FuseMachine/ConfirmFusion");
	self._Delivery = Net:RemoteFunction("FuseMachine/Delivery");
	self._RevealNow = Net:RemoteEvent("FuseMachine/RevealNow");
	self._FuseAnimation = Net:RemoteEvent("FuseMachine/FuseAnimation");
	self:_setUpRemoteEvents()

	return self
end

function FusingService:_setUpRemoteEvents()
	self._Delivery.OnServerInvoke = function(player, actionId)
		return self:handleFuseDelivery(player, actionId)
	end

	self._ConfirmFusion.OnServerInvoke = function(player) -- actionId might not be needed for confirmation
		return self:handleConfirmFusion(player)
	end

	self._RevealNow.OnServerEvent:Connect(function(player) -- actionId might not be needed for reveal
		return self:handleRevealNow(player)
	end)

	self._ClaimBrainrot.OnServerInvoke = function(player) -- actionId might not be needed for claim
		return self:handleClaimBrainrot(player)
	end

	self._RemoveBrainrot.OnServerInvoke = function(player, slot, plot) -- actionId might not be needed for remove
		return self:removeBrainrot(player, slot, plot)
	end
end

-- NEW: Function to initialize player's fuse machine data when they join
function FusingService:initializePlayerData(player)
	if not DataManagment.isDataReady(player) then
		return false, "Player data not ready."
	end

	local playerState = Synchronizer:Get(player)
	if not playerState then
		return false, "Player state not found."
	end

	-- Load saved fuse machine data from DataManagement
	local playerData = DataManagment.GetDataMan(player)
	local savedFuseMachineData = playerData.FuseMachine or {}

	-- Initialize with saved data or defaults - make sure to create the full FuseMachine table structure
	local fuseMachineData = {
		Slots = savedFuseMachineData.Slots or {},
		OutputRarityOdds = savedFuseMachineData.OutputRarityOdds or {},
		Cost = savedFuseMachineData.Cost or 0,
		StartTime = savedFuseMachineData.StartTime or 0,
		FinishTime = savedFuseMachineData.FinishTime or 0,
		ReadyToClaim = savedFuseMachineData.ReadyToClaim or nil,
		FuseLuckMultiplier = savedFuseMachineData.FuseLuckMultiplier or 1,
		InstantReveals = savedFuseMachineData.InstantReveals or 0
	}

	-- Set the entire FuseMachine table at once
	playerState:Set("FuseMachine", fuseMachineData)

	return true
end

-- NEW: Function to save fuse machine data
function FusingService:saveFuseMachineData(player)
	if not DataManagment.isDataReady(player) then
		return false
	end

	local playerState = Synchronizer:Get(player)
	if not playerState then
		return false
	end

	local playerData = DataManagment.GetDataMan(player)
	if not playerData.FuseMachine then
		playerData.FuseMachine = {}
	end

	-- Get the entire FuseMachine table from synchronizer
	local fuseMachineData = playerState:Get("FuseMachine") or {}

	-- Save the entire structure
	playerData.FuseMachine = {
		Slots = fuseMachineData.Slots or {},
		OutputRarityOdds = fuseMachineData.OutputRarityOdds or {},
		Cost = fuseMachineData.Cost or 0,
		StartTime = fuseMachineData.StartTime or 0,
		FinishTime = fuseMachineData.FinishTime or 0,
		ReadyToClaim = fuseMachineData.ReadyToClaim,
		FuseLuckMultiplier = fuseMachineData.FuseLuckMultiplier or 1,
		InstantReveals = fuseMachineData.InstantReveals or 0
	}

	return true
end

local StolenSlots = {}
local first = true

function FusingService:handleFuseDelivery(player, actionId)
	local currentTime = tick()
	if self._Delivered[player] and (currentTime - self._Delivered[player]) < 2 then
		return false, "Please wait before delivering another brainrot."
	end
	self._Delivered[player] = currentTime

	if not DataManagment.isDataReady(player) then
		return false, "Player data not ready."
	end

	if not player:GetAttribute("Stealing") or player:GetAttribute("Stealing") ~= true then
		return false, "Player is not stealing."
	end

	local playerState = Synchronizer:Get(player)

	if not playerState then
		return false, "Player state not found."
	end

	local stealingPlot = player:GetAttribute("StealingPlot")
	local stealingSlot = player:GetAttribute("StealingSlot")

	if not stealingPlot or not stealingSlot then
		return false, "No active stealing plot or slot."
	end

	local targetPlot = Synchronizer:Get(stealingPlot)
	if not targetPlot then
		return false, "Target plot not found."
	end

	local animalList = targetPlot:Get("AnimalList") or {}
	local animal = animalList[stealingSlot]
	if not animal or animal == "Empty" then
		return false, "No animal found in the stealing slot."
	end

	local serializableAnimalData = {
		Index = animal.Index,       -- This is a string (e.g., "StarterFox")
		Mutation = animal.Mutation, -- This is a string or nil
	}

	local isInDeliveryArea = self:_isPlayerInFuseMachineDeliveryArea(player, workspace.FuseMachine)
	if not isInDeliveryArea then
		return false, "You are not in the fuse machine delivery area."
	end

	local currentFuseMachineSlots = playerState:Get("FuseMachine.Slots") or {}

	-- Initialize newFuseMachineSlots properly
	local newFuseMachineSlots = {}

	-- Initialize all slots as "Empty" first
	for i = 1, FuseMachineData.FuseSlots do
		newFuseMachineSlots[i] = "Empty"
	end

	-- Copy existing slots that aren't empty
	for i, slotData in pairs(currentFuseMachineSlots) do
		if slotData and slotData ~= "Empty" then
			newFuseMachineSlots[i] = slotData
		end
	end

	-- Find empty slot index
	local emptySlotIndex = -1
	for i = 1, FuseMachineData.FuseSlots do
		if not newFuseMachineSlots[i] or newFuseMachineSlots[i] == "Empty" then
			emptySlotIndex = i
			break
		end
	end

	if emptySlotIndex == -1 then
		-- Count actual filled slots for better debugging
		local filledCount = 0
		for i = 1, FuseMachineData.FuseSlots do
			if newFuseMachineSlots[i] and newFuseMachineSlots[i] ~= "Empty" then
				filledCount = filledCount + 1
			end
		end
		warn(player.Name .. ": Fuse machine slots are full (found " .. filledCount .. " filled out of " .. FuseMachineData.FuseSlots .. ").")
		return false, "Fuse machine slots are full."
	end

	-- Add the new animal to the empty slot
	newFuseMachineSlots[emptySlotIndex] = serializableAnimalData

	-- Debug print to verify the animal was added
	print("Added animal to slot", emptySlotIndex, ":", serializableAnimalData.Index)
	print("Updated slots:", newFuseMachineSlots)

	-- Save it back to synchronizer so the GUI sees it
	local currentFuseMachine = playerState:Get("FuseMachine") or {}
	currentFuseMachine.Slots = newFuseMachineSlots
	playerState:Set("FuseMachine", currentFuseMachine)

	-- ADDED: Save to persistent data
	self:saveFuseMachineData(player)

	local AnimalData = Animals[animal.Index] -- Keep using the original 'animal' here for server-side logic
	self._Chances[AnimalData.Rarity] = (self._Chances[AnimalData.Rarity] or 0) + 10 * 2

	if not StolenSlots[targetPlot:Get("Owner")] then
		StolenSlots[targetPlot:Get("Owner")] = {}
	end
	if not StolenSlots[targetPlot:Get("Owner")][stealingSlot] then
		StolenSlots[targetPlot:Get("Owner")][stealingSlot] = stealingSlot
	end

	self:_cleanupDelivery(player, targetPlot, animalList, stealingSlot)

	for _, b in workspace:WaitForChild("FuseMachine").Vfx[AnimalData.Rarity]:GetDescendants() do
		if b:IsA("ParticleEmitter") then
			b:Emit(20)
		end
	end

	-- Get the rarity data for color
	local RarityData = Rarities[AnimalData.Rarity]
	local rarityColor = "#FFFFFF" -- Default to white
	if RarityData and RarityData.Color then
		-- Convert Color3 to hex string
		local color = RarityData.Color
		rarityColor = string.format("#%02X%02X%02X", 
			math.floor(color.R * 255), 
			math.floor(color.G * 255), 
			math.floor(color.B * 255)
		)
	end

	local notificationEvent = Net:RemoteEvent("NotificationService/Notify")
	notificationEvent:FireClient(
		player,
		string.format("You have added <font color=\"%s\"><b>%s</b></font> to the Fuse Machine!", rarityColor, AnimalData.DisplayName),
		3
	)
	animal.FuseSlot = stealingSlot
	animal.FusePlot = stealingPlot
	targetPlot:Set("AnimalList", animalList)

	local currentOdds = self:_calculateOutputRarityOdds(newFuseMachineSlots)
	currentFuseMachine.OutputRarityOdds = currentOdds

	local filledSlots = 0
	for _, slotData in pairs(newFuseMachineSlots) do
		if slotData and slotData ~= "Empty" then
			filledSlots = filledSlots + 1
		end
	end
	currentFuseMachine.Cost = 100 * 1000
	currentFuseMachine.StartTime = 0

	playerState:Set("FuseMachine", currentFuseMachine)

	self:saveFuseMachineData(player)

	return true
end

function FusingService:removeBrainrot(player, slot, plot)
	if not DataManagment.isDataReady(player) then
		return false, "Player data not ready."
	end
	local playerState = Synchronizer:Get(player)
	if not playerState then
		return false, "Player state not found."
	end

	local PlotState = Synchronizer:Get(plot)
	if not PlotState then
		return false, "Target plot not found."
	end

	local animalList = PlotState:Get("AnimalList") or {}
	local animal = animalList[slot]
	animal.Steal = false
	PlotState:Set("AnimalList", animalList)

	-- Clear all fuse machine data
	local fuseMachineData = {
		Slots = {},
		OutputRarityOdds = {},
		Cost = 0,
		StartTime = 0,
		FinishTime = 0,
		ReadyToClaim = nil,
		FuseLuckMultiplier = 1,
		InstantReveals = 0
	}
	playerState:Set("FuseMachine", fuseMachineData)

	-- ADDED: Save cleared data
	self:saveFuseMachineData(player)

	return true
end

function FusingService:handleConfirmFusion(player)
	if not DataManagment.isDataReady(player) then
		return false, "Player data not ready."
	end

	local playerState = Synchronizer:Get(player)
	if not playerState then
		return false, "Player state not found."
	end

	local fuseMachineSlots = playerState:Get("FuseMachine.Slots") or {}
	local filledSlots = 0
	for _, slotData in pairs(fuseMachineSlots) do
		if slotData and slotData ~= "Empty" then
			filledSlots = filledSlots + 1
		end
	end

	if filledSlots < FuseMachineData.FuseSlots then
		return false, "Not all fuse machine slots are filled."
	end

	local fusionCost = playerState:Get("FuseMachine.Cost") or FuseMachineData.BaseFusionCost -- Fallback cost
	local playerData = DataManagment.GetDataMan(player)

	-- NEW: Determine fusion result using the new method that returns specific animal data
	local resultAnimalData = self:_determineFusionResult(fuseMachineSlots)

	self:_cleanupDelivery2(player, StolenSlots)

	-- Update FuseMachine data structure properly
	local currentFuseMachine = playerState:Get("FuseMachine") or {}
	currentFuseMachine.Slots = {} -- Clear slots after fusion starts
	currentFuseMachine.StartTime = workspace:GetServerTimeNow()
	local fuseTime = FuseMachineData.FuseTime[resultAnimalData.Rarity] or 30
	currentFuseMachine.FinishTime = workspace:GetServerTimeNow() + fuseTime
	currentFuseMachine.OutputRarityOdds = {} -- Clear odds after fusion starts

	playerState:Set("FuseMachine", currentFuseMachine)

	-- ADDED: Save fusion state
	self:saveFuseMachineData(player)

	local notificationEvent = Net:RemoteEvent("NotificationService/Notify")
	notificationEvent:FireClient(
		player,
		string.format("Fusion started! It will be ready in <font color=\"#00ff00\"><b>%s</b></font>.", TimeUtils:E(fuseTime)),
		5
	)

	task.delay(fuseTime, function()
		-- Verify that the player is still active and this is the correct fusion completion
		if player and playerState then
			local currentFinishTime = playerState:Get("FuseMachine.FinishTime")
			if currentFinishTime and currentFinishTime <= workspace:GetServerTimeNow() then
				-- The animal is now ready to be claimed. Store it.
				local currentFuseMachine = playerState:Get("FuseMachine") or {}
				currentFuseMachine.ReadyToClaim = resultAnimalData
				currentFuseMachine.FinishTime = 0 -- Indicate fusion is complete, ready for claim
				playerState:Set("FuseMachine", currentFuseMachine)

				-- ADDED: Save ready-to-claim state
				self:saveFuseMachineData(player)

				notificationEvent:FireClient(
					player,
					string.format("Your new <font color=\"#00ff00\"><b>%s</b></font> is ready to be claimed!", resultAnimalData.DisplayName),
					5
				)
			end
		else
			warn("Fusion completed for a player who is no longer active or fusion state changed.")
		end
	end)

	return true
end

function FusingService:handleRevealNow(player)
	if not DataManagment.isDataReady(player) then
		return false, "Player data not ready."
	end

	local playerState = Synchronizer:Get(player)
	if not playerState then
		return false, "Player state not found."
	end

	local readyToClaimAnimal = playerState:Get("FuseMachine.ReadyToClaim")
	if not readyToClaimAnimal then
		return false, "No animal ready to be revealed/claimed."
	end

	return true
end

function FusingService:handleClaimBrainrot(player)
	local playerState = Synchronizer:Get(player)
	if not playerState then
		return false, "Player state not found."
	end

	-- Get the ready-to-claim animal instead of recalculating
	local resultAnimalData = playerState:Get("FuseMachine.ReadyToClaim")
	if not resultAnimalData then
		return false, "No animal ready to claim."
	end

	-- Fire the fuse animation event to all clients
	self._FuseAnimation:FireAllClients(resultAnimalData)

	_G._player = player
	RoadSpawner:SpawnSpecificAnimal(resultAnimalData.DisplayName, nil, nil, true, true)
	task.delay(10, function()
		DataManagment.addAnimal(player, resultAnimalData.DisplayName)
	end)

	-- Clear all fuse machine data
	local clearedFuseMachine = {
		Slots = {},
		OutputRarityOdds = {},
		Cost = 0,
		StartTime = 0,
		FinishTime = 0,
		ReadyToClaim = nil,
		FuseLuckMultiplier = 1,
		InstantReveals = 0
	}
	playerState:Set("FuseMachine", clearedFuseMachine)

	-- ADDED: Save cleared data
	self:saveFuseMachineData(player)

	-- Reset chances
	self._Chances = {
		["Common"] = 0,
		["Rare"] = 0,
		["Epic"] = 0,
		["Legendary"] = 0,
		["Mythic"] = 0,
		["Brainrot God"] = 0,
		["Secret"] = 0,
	}

	local notificationEvent = Net:RemoteEvent("NotificationService/Notify")
	notificationEvent:FireClient(
		player,
		string.format("You have claimed your new <font color=\"#00ff00\"><b>%s</b></font>!", resultAnimalData.DisplayName),
		5
	)

	return true
end

function FusingService:_isPlayerInFuseMachineDeliveryArea(player, fuseMachine)
	if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
		return false
	end

	local humanoidRootPart = player.Character.HumanoidRootPart
	local deliveryHitbox = fuseMachine:FindFirstChild("Hitboxes") and fuseMachine.Hitboxes:FindFirstChild("Hitbox")

	if not deliveryHitbox or not deliveryHitbox:IsA("BasePart") then
		warn("FuseMachine delivery hitbox not found or is not a BasePart.")
		return false
	end

	local distance = (humanoidRootPart.Position - deliveryHitbox.Position).Magnitude
	local hitboxRadius = math.max(deliveryHitbox.Size.X, deliveryHitbox.Size.Y, deliveryHitbox.Size.Z) / 2
	local maxValidDistance = hitboxRadius + 10 -- A bit of leeway

	return distance <= maxValidDistance
end

-- NEW: Calculate output rarity odds like the client does - returns both rarities and specific animals
function FusingService:_calculateOutputRarityOdds(currentSlots)
	local rarityCounts = {}
	local animalCounts = {}
	local totalAnimals = 0

	-- Count both rarities and specific animals
	for _, slotData in pairs(currentSlots) do
		if slotData and slotData ~= "Empty" then
			local animalData = Animals[slotData.Index]
			if animalData then
				-- Count rarities
				rarityCounts[animalData.Rarity] = (rarityCounts[animalData.Rarity] or 0) + 1

				-- Count specific animals (like the client does)
				animalCounts[slotData.Index] = (animalCounts[slotData.Index] or 0) + 1

				totalAnimals = totalAnimals + 1
			end
		end
	end

	local odds = {}

	-- 🔹 Secret special rule (unchanged)
	if rarityCounts["Secret"] and rarityCounts["Secret"] > 0 then
		if totalAnimals == 1 then
			return {["Secret"] = 100}
		elseif rarityCounts["Secret"] == totalAnimals then
			return {["Secret"] = 100}
		end
	end

	-- Calculate rarity odds
	if totalAnimals > 0 then
		for rarityName, count in pairs(rarityCounts) do
			odds[rarityName] = (count / totalAnimals) * 100
		end

		-- Also calculate specific animal odds like the client
		for animalIndex, count in pairs(animalCounts) do
			odds[animalIndex] = (count / totalAnimals) * 100
		end
	end

	-- Add in custom forced chances
	for rarityName, chanceValue in pairs(self._Chances) do
		odds[rarityName] = (odds[rarityName] or 0) + chanceValue
	end

	-- 🔹 Normalize so everything sums to 100%
	local totalChance = 0
	for _, v in pairs(odds) do
		totalChance = totalChance + v
	end

	if totalChance > 0 then
		for key, v in pairs(odds) do
			odds[key] = (v / totalChance) * 100
		end
	end

	return odds
end

-- NEW: Updated fusion result determination to work like the client
function FusingService:_determineFusionResult(fuseMachineSlots)
	-- First, calculate the rarity that should be selected
	local combinedRarityWeights = {}
	local totalWeight = 0

	-- Calculate weights from input animals
	for _, slotData in pairs(fuseMachineSlots) do
		if slotData and slotData ~= "Empty" then
			local animalData = Animals[slotData.Index]
			if animalData then
				local rarityData = Rarities[animalData.Rarity]
				if rarityData then
					combinedRarityWeights[animalData.Rarity] = (combinedRarityWeights[animalData.Rarity] or 0) + rarityData.Weight
				end

				-- Add mutation boosts
				if slotData.Mutation then
					local mutationData = Mutations[slotData.Mutation]
					if mutationData and mutationData.RarityBoost then
						for boostedRarity, boostAmount in pairs(mutationData.RarityBoost) do
							combinedRarityWeights[boostedRarity] = (combinedRarityWeights[boostedRarity] or 0) + boostAmount
						end
					end
				end
			end
		end
	end

	-- Add custom chances
	for rarityName, chanceValue in pairs(self._Chances) do
		combinedRarityWeights[rarityName] = (combinedRarityWeights[rarityName] or 0) + chanceValue
	end

	-- Calculate total weight
	for _, weight in pairs(combinedRarityWeights) do
		if weight > 0 then
			totalWeight = totalWeight + weight
		end
	end

	if totalWeight == 0 then
		warn("No valid weights for fusion, defaulting to Common.")
		-- Return a default common fusion animal
		local commonFusionAnimals = FusionAnimals["Common"] or {}
		if #commonFusionAnimals > 0 then
			local randomIndex = math.random(1, #commonFusionAnimals)
			return Animals[commonFusionAnimals[randomIndex]]
		else
			-- Fallback if no common fusion animals exist
			return {Index = "FallbackCommon", Rarity = "Common", DisplayName = "Common Animal", Fusion = true}
		end
	end

	-- Select rarity based on weights
	local randomNumber = math.random() * totalWeight
	local cumulativeWeight = 0
	local selectedRarity = "Common"

	for rarityName, weight in pairs(combinedRarityWeights) do
		if weight > 0 then
			cumulativeWeight = cumulativeWeight + weight
			if randomNumber <= cumulativeWeight then
				selectedRarity = rarityName
				break
			end
		end
	end

	-- Get fusion animals of the selected rarity
	local fusionAnimalsOfRarity = FusionAnimals[selectedRarity] or {}

	if #fusionAnimalsOfRarity > 0 then
		local randomIndex = math.random(1, #fusionAnimalsOfRarity)
		local chosenAnimalIndex = fusionAnimalsOfRarity[randomIndex]
		return Animals[chosenAnimalIndex]
	else
		-- If no fusion animals exist for this rarity, try to find any fusion animal
		warn("No fusion animals found for selected rarity:", selectedRarity, ", trying to find any fusion animal.")

		-- Look for any fusion animal
		for _, rarityAnimals in pairs(FusionAnimals) do
			if #rarityAnimals > 0 then
				local randomIndex = math.random(1, #rarityAnimals)
				return Animals[rarityAnimals[randomIndex]]
			end
		end

		-- Final fallback
		warn("No fusion animals found at all, using fallback.")
		return {Index = "FallbackFusion", Rarity = selectedRarity, DisplayName = "Fusion Animal", Fusion = true}
	end
end

function FusingService:_triggerRainbowEvent()
	self._IsUsing = true
	self._TimeEnd = tick() + 900

	local VFX = workspace.FuseMachine:WaitForChild("Vfx")
	local Enabled = VFX:WaitForChild("Enabled")
	local Top = VFX:WaitForChild("Goal")

	for _, top in Top:GetDescendants() do
		if top:IsA("ParticleEmitter") then
			top.Enabled = true
		end
	end
	for _, top in Enabled:GetDescendants() do
		if top:IsA("ParticleEmitter") or top:IsA("Beam") then
			top.Enabled = true
		end
	end

	self._Delivered = 0

	task.spawn(function()
		while tick() < self._TimeEnd do
			task.wait(1)
		end
		self._IsUsing = false

		for _, top in Top:GetDescendants() do
			if top:IsA("ParticleEmitter") then
				top.Enabled = false
			end
		end
		for _, top in Enabled:GetDescendants() do
			if top:IsA("ParticleEmitter") or top:IsA("Beam") then
				top.Enabled = false
			end
		end
	end)
end

function FusingService:_cleanupDelivery2(player, Data)
	for targetPlot, stealingSlot in Data do
		local targetOwner = targetPlot
		if targetOwner then
			for i, v in stealingSlot do
				DataManagment.removeAnimal(targetOwner, v)
				local targetPlayerSync = Synchronizer:Get(targetOwner)
				if targetPlayerSync then
					local targetData = DataManagment.GetDataMan(targetOwner)
					if targetData then
						targetPlayerSync:Set("AnimalAddedOrRemoved", targetData.AnimalList)
					end
				end
			end
		end
	end

	player:SetAttribute("Stealing", false)
	player:SetAttribute("StealingPlot", nil)
	player:SetAttribute("StealingSlot", nil)
end

function FusingService:_cleanupDelivery(player, targetPlot, animalList, stealingSlot)
	local animal = animalList[stealingSlot]
	animal.Steal = "FuseMachine"
	targetPlot:Set("AnimalList", animalList)

	local targetOwner = targetPlot:Get("Owner")
	if targetOwner then
		local targetPlayerSync = Synchronizer:Get(targetOwner)
		if targetPlayerSync then
			local targetData = DataManagment.GetDataMan(targetOwner)
			if targetData then
				targetPlayerSync:Set("AnimalAddedOrRemoved", targetData.AnimalList)
			end
		end
	end

	player:SetAttribute("Stealing", false)
	player:SetAttribute("StealingPlot", nil)
	player:SetAttribute("StealingSlot", nil)
end

return FusingService