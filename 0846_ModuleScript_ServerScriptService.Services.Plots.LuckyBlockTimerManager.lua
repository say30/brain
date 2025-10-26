--[[
  Extracted from: ServerScriptService.Services.Plots.LuckyBlockTimerManager
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local DataManagement = require(ServerScriptService.Services.DataManagment)
local Animals = require(ReplicatedStorage.Datas.Animals)
local LuckyBlocks = require(ReplicatedStorage.Datas.LuckyBlocks)
local Net = require(ReplicatedStorage.Packages.Net)
local Synchronizer = require(ReplicatedStorage.Packages.Synchronizer)

local LuckyBlockTimerManager = {}
LuckyBlockTimerManager.__index = LuckyBlockTimerManager

function LuckyBlockTimerManager.new(plotManager)
	local self = setmetatable({}, LuckyBlockTimerManager)

	self.plotManager = plotManager
	self.lastUpdateTime = workspace:GetServerTimeNow()
	self.updateConnection = nil

	self.openRemote = Net:RemoteEvent("PlotService/Open")
	self.openRemote.OnServerEvent:Connect(function(player, slot)
		self:HandleLuckyBlockOpen(player, slot)
	end)

	return self
end

function LuckyBlockTimerManager:Start()
	if self.updateConnection then
		return
	end

	self.updateConnection = RunService.Heartbeat:Connect(function()
		local currentTime = workspace:GetServerTimeNow()
		local deltaTime = currentTime - self.lastUpdateTime

		if deltaTime >= 1 then
			self:UpdateAllLuckyBlockTimers(deltaTime)
			self.lastUpdateTime = currentTime
		end
	end)
end

function LuckyBlockTimerManager:Stop()
	if self.updateConnection then
		self.updateConnection:Disconnect()
		self.updateConnection = nil
	end
end

function LuckyBlockTimerManager:UpdateAllLuckyBlockTimers(deltaTime)
	local playerPlots = self.plotManager.playerPlots

	for player, plot in pairs(playerPlots) do
		if player and player.Parent then
			self:UpdatePlayerLuckyBlockTimers(player, deltaTime)
		end
	end
end

function LuckyBlockTimerManager:UpdatePlayerLuckyBlockTimers(player, deltaTime)
	if not DataManagement.isDataReady(player) then
		return
	end

	local animalList = DataManagement.getAnimalList(player)
	if not animalList then
		return
	end

	local hasUpdates = false
	local hasTimerReachedZero = false

	for slot, animalData in pairs(animalList) do
		if typeof(animalData) == "table" and animalData.Timer then
			local animalInfo = Animals[animalData.Index]
			if animalInfo and animalInfo.LuckyBlock then
				local oldTimer = animalData.Timer
				animalData.Timer = math.max(0, animalData.Timer - deltaTime)
				hasUpdates = true

				if oldTimer > 0 and animalData.Timer <= 0 then
					hasTimerReachedZero = true
					self:HandleLuckyBlockReady(player, slot, animalData)
				end
			end
		end
	end

	if hasUpdates then
		self:SyncAnimalListChanges(player, animalList)

		if hasTimerReachedZero then
			task.wait(0.1)
			self:SyncAnimalListChanges(player, animalList)
		end
	end
end

function LuckyBlockTimerManager:HandleLuckyBlockReady(player, slot, animalData)
end

function LuckyBlockTimerManager:HandleLuckyBlockOpen(player, slot)
	if not DataManagement.isDataReady(player) then
		return
	end

	local animalList = DataManagement.getAnimalList(player)
	if not animalList or not animalList[slot] then
		return
	end

	local animalData = animalList[slot]
	if typeof(animalData) ~= "table" or not animalData.Index then
		return
	end

	local animalInfo = Animals[animalData.Index]
	if not animalInfo or not animalInfo.LuckyBlock then
		return
	end

	if animalData.Timer and animalData.Timer > 0 then
		return
	end

	local animalKeyName = nil
	for keyName, animal in pairs(Animals) do
		if animal == animalInfo then
			animalKeyName = keyName
			break
		end
	end

	if not animalKeyName then
		return
	end

	local luckyBlockData = LuckyBlocks[animalKeyName]
	if not luckyBlockData or not luckyBlockData.Animals then
		return
	end

	local selectedAnimal = self:SelectRandomAnimalFromLuckyBlock(luckyBlockData.Animals)
	if not selectedAnimal then
		return
	end

	local selectedAnimalIndex = nil
	for index, animal in pairs(Animals) do
		if animal.DisplayName == selectedAnimal then
			selectedAnimalIndex = index
			break
		end
	end

	if not selectedAnimalIndex then
		return
	end

	local plot = self.plotManager:GetPlayerPlot(player)
	if not plot then
		return
	end

	local plotUID = plot:GetUUID()

	local luckyBlockMutation = animalData.Mutation
	local luckyBlockTraits = animalData.Traits or {}

	self.openRemote:FireAllClients(plotUID, slot, animalData.Index, selectedAnimal, luckyBlockMutation, luckyBlockTraits)

	task.wait(0.2)

	local success, newSlot = pcall(function()
		DataManagement.removeAnimal(player, slot)

		return DataManagement.addAnimal(player, selectedAnimalIndex, luckyBlockMutation, luckyBlockTraits)
	end)
end

function LuckyBlockTimerManager:SelectRandomAnimalFromLuckyBlock(animals)
	local totalWeight = 0
	local weightedAnimals = {}

	-- Check if animals is an array (no weights) or a dictionary (with weights)
	local isArray = true
	for key, value in pairs(animals) do
		if typeof(key) == "string" and typeof(value) == "number" then
			isArray = false
			break
		end
	end

	if isArray then
		-- Handle array format (equal chances)
		local animalCount = 0
		for _ in pairs(animals) do
			animalCount = animalCount + 1
		end

		if animalCount == 0 then
			return nil
		end

		local equalWeight = 100 / animalCount

		for _, animalName in pairs(animals) do
			totalWeight = totalWeight + equalWeight
			table.insert(weightedAnimals, {name = animalName, weight = equalWeight})
		end
	else
		-- Handle dictionary format (specified weights)
		for animalName, weight in pairs(animals) do
			totalWeight = totalWeight + weight
			table.insert(weightedAnimals, {name = animalName, weight = weight})
		end
	end

	if totalWeight <= 0 then
		return nil
	end

	local randomValue = math.random() * totalWeight
	local currentWeight = 0

	for _, animalData in ipairs(weightedAnimals) do
		currentWeight = currentWeight + animalData.weight
		if randomValue <= currentWeight then
			return animalData.name
		end
	end

	return weightedAnimals[1] and weightedAnimals[1].name
end

function LuckyBlockTimerManager:SyncAnimalListChanges(player, animalList)
	if not DataManagement.isDataReady(player) then
		return
	end

	local success = pcall(function()
		local profile = DataManagement.GetDataMan(player)
		if profile then
			profile.AnimalList = animalList
		end

		local plot = self.plotManager:GetPlayerPlot(player)
		if plot then
			plot:SetAnimalList(animalList)

			local synchronizer = plot:GetSynchronizer()
			if synchronizer then
				synchronizer:Set("AnimalList", animalList)
			end
		end
	end)
end

function LuckyBlockTimerManager:GetLuckyBlockTimer(player, slot)
	if not DataManagement.waitForData(player, 5) then
		return nil
	end

	local animalList = DataManagement.getAnimalList(player)
	if not animalList or not animalList[slot] then
		return nil
	end

	local animalData = animalList[slot]
	if typeof(animalData) == "table" and animalData.Timer then
		local animalInfo = Animals[animalData.Index]
		if animalInfo and animalInfo.LuckyBlock then
			return animalData.Timer
		end
	end

	return nil
end

function LuckyBlockTimerManager:IsLuckyBlockReady(player, slot)
	local timer = self:GetLuckyBlockTimer(player, slot)
	return timer ~= nil and timer <= 0
end

return LuckyBlockTimerManager