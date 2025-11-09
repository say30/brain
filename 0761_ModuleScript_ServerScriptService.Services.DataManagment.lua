--[[
  Extracted from: ServerScriptService.Services.DataManagment
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-->> Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local Packages = ReplicatedStorage:WaitForChild("Packages")

local BaseConfig = require(ReplicatedStorage:WaitForChild("BaseConfig"))

-->> Modules
local ProfileStore = require(ServerScriptService.Controllers.ProfileStore)
local Synchronizer = require(ReplicatedStorage.Packages.Synchronizer)

local Template = {
        Coins = 100,
        Gelatin = 0,
        Essences = 0,
        Rebirths = 0,
	RainbowSpinWheel = {
		Spins = 1,
		PaidSpins = { x3 = 0 },
		LastDailyDiscount = os.time(),
		LastFreeClaimed = 0
	},
	CandySpinWheel = {
		Spins = 1,
		PaidSpins = { x3 = 0 },
		LastDailyDiscount = os.time(),
		LastFreeClaimed = 0
	},
	BloodmoonSpinWheel = {
		Spins = 1,
		PaidSpins = { x3 = 0 },
		LastDailyDiscount = os.time(),
		LastFreeClaimed = 0
	},
	MoltenSpinWheel = {
		Spins = 1,
		PaidSpins = { x3 = 0},
		LastDailyDiscount = os.time(),
		LastFreeClaimed = 0
	},
	GalaxySpinWheel = {
		Spins = 6,
		PaidSpins = { x3 = 0},
		LastDailyDiscount = os.time(),
		LastFreeClaimed = 0
	},
	Steals = 0,
	Inventory = {},
	LastClaimed = os.date("%j"),
	Streak = 1,
	Gamepass = {},
	RainbowEvent = {
		LastClaimed = 0,
		SkipPurchased = false
	},
	BoughtStarterPack = false,
	AnimalList = {},
	Index = {},
	LastOnline = workspace:GetServerTimeNow(),
	Settings = {
		Music = true,
		["Sound Effects"] = true,
		VFX = true	,
		["Chat Tips"] = true,
		["Base Skin"] = "Normal"
	},
	TutorialFinished = true, -- for now, the tutorial is disabled
	TutorialProgress = {
		StartedAt = 0,
		CompletedAt = 0,
		CurrentStep = 1,
		StepsCompleted = {}
	},
        HourPickCooldown = 0,
        BaseState = BaseConfig.createDefaultState(),
}

local GlobalTemplate = {
	ActiveEvents = {}
}

local DATASTORE_KEY = "Data"
local ACTIVE_TEMPLATE = Template

local DataStore = ProfileStore.New(DATASTORE_KEY, ACTIVE_TEMPLATE)
local OriginalDataStore = DataStore

local DataStoreModule = {}
local Profiles = {}
local ProfileLoadingStates = {}
local QueuedOperations = {}
local ProfileLoadingBlacklist = {}

local LOADING_STATES = {
	NOT_STARTED = "NotStarted",
	LOADING = "Loading", 
	LOADED = "Loaded",
	FAILED = "Failed"
}

local function executeQueuedOperations(player)
	local queue = QueuedOperations[player]
	if queue then
		for _, operation in ipairs(queue) do
			task.spawn(operation.func, unpack(operation.args))
		end
		QueuedOperations[player] = nil
	end
end

local function queueOperation(player, func, ...)
	if not QueuedOperations[player] then
		QueuedOperations[player] = {}
	end
	table.insert(QueuedOperations[player], {
		func = func,
		args = {...}
	})
end

function DataStoreModule.loadProfile(player: Player)
	if ProfileLoadingBlacklist[player] then
		warn(`[DataStore] Profile loading blocked for blacklisted player: {player.Name}`)
		return nil
	end

	if Profiles[player] and ProfileLoadingStates[player] == LOADING_STATES.LOADED then
		return Profiles[player]
	end

	if ProfileLoadingStates[player] == LOADING_STATES.LOADING then
		while ProfileLoadingStates[player] == LOADING_STATES.LOADING do
			task.wait(0.1)
		end
		return Profiles[player]
	end

	ProfileLoadingStates[player] = LOADING_STATES.LOADING

	local maxRetries = 3
	local retryDelay = 5

	for attempt = 1, maxRetries do
		local success, profile = pcall(function()
			return DataStore:StartSessionAsync(tostring(player.UserId))
		end)

		if not success and tostring(profile):find("session") then
			if attempt < maxRetries then
				task.wait(8)
				continue
			end
		end

		if success and profile then
			local dataKeyCount = 0
			if profile.Data then
				for _ in pairs(profile.Data) do
					dataKeyCount = dataKeyCount + 1
				end
			else
				print(`[DEBUG] Profile loaded for {player.Name}: No Data found`)
			end

			local isEmptyProfile = not profile.Data or dataKeyCount == 0 or profile.Data.Coins == nil
			local isStudio = RunService:IsStudio()

			if isEmptyProfile then
				if not profile.Data then
					profile.Data = {}
				end
				local function deepCopy(original)
					local copy = {}
					for key, value in pairs(original) do
						if typeof(value) == "table" then
							copy[key] = deepCopy(value)
						else
							copy[key] = value
						end
					end
					return copy
				end

				profile.Data = deepCopy(Template)
			else
				--print(`[DEBUG] Profile for {player.Name} has data, running normal reconcile`)
			end

			profile:Reconcile()
			profile:AddUserId(player.UserId)

			local postReconcileKeyCount = 0
			if profile.Data then
				for _ in pairs(profile.Data) do
					postReconcileKeyCount = postReconcileKeyCount + 1
				end
			end

			if profile.Data and profile.Data.Coins ~= nil then

			else
				local function deepCopy(original)
					local copy = {}
					for key, value in pairs(original) do
						if typeof(value) == "table" then
							copy[key] = deepCopy(value)
						else
							copy[key] = value
						end
					end
					return copy
				end
				profile.Data = deepCopy(Template)
			end

			Profiles[player] = profile
			ProfileLoadingStates[player] = LOADING_STATES.LOADED

			executeQueuedOperations(player)

			return profile
		else
			local errorMsg = if success then "Session conflict" else tostring(profile)
			warn(`Failed to load profile for player: {player.Name} (Attempt {attempt}/{maxRetries}): {errorMsg}`)

			if attempt < maxRetries then
				local waitTime = retryDelay * attempt
				if not success or (success and not profile) then
					waitTime = waitTime * 2
				end
				task.wait(waitTime)
			end
		end
	end

	ProfileLoadingStates[player] = LOADING_STATES.FAILED
	warn(`All attempts failed to load profile for player: {player.Name}. Player will be kicked.`)

	player:Kick("Failed to load your data. Please rejoin the game. (Error Code: 267)")
	return nil
end

function DataStoreModule.loadProfileAsync(player: Player)
	return task.spawn(function()
		return DataStoreModule.loadProfile(player)
	end)
end

local function safeDataOperation(player: Player, operation)
	if ProfileLoadingBlacklist[player] then
		warn(`[DataStore] Data operation blocked for blacklisted player: {player.Name}`)
		return nil
	end

	if not player.Parent then
		return nil
	end

	local state = ProfileLoadingStates[player]

	if state == LOADING_STATES.LOADED then
		return operation()
	elseif state == LOADING_STATES.LOADING then
		queueOperation(player, operation)
		return nil
	else
		task.spawn(function()
			DataStoreModule.loadProfile(player)
		end)
		queueOperation(player, operation)
		return nil
	end
end

function DataStoreModule.saveProfile(player: Player)
	local profile = Profiles[player]
	if profile then
		local maxRetries = 3
		local retryDelay = 0.5

		for attempt = 1, maxRetries do
			local success, err = pcall(function()
				profile:EndSession()
			end)

			if success then
				break
			else
				warn(`Failed to end session for player: {player.Name} (Attempt {attempt}/{maxRetries}): {tostring(err)}`)
				if attempt < maxRetries then
					task.wait(retryDelay * attempt)
				end
			end
		end

		Profiles[player] = nil
		ProfileLoadingStates[player] = nil
		QueuedOperations[player] = nil
		ProfileLoadingBlacklist[player] = nil
	end
end

function DataStoreModule.getHourPickCooldown(player: Player)
	local profile = Profiles[player]
	if profile and profile.Data and ProfileLoadingStates[player] == LOADING_STATES.LOADED then
		return profile.Data.HourPickCooldown or 0
	end
	return 0
end

function DataStoreModule.setHourPickCooldown(player: Player, cooldownEndTime: number)
	return safeDataOperation(player, function()
		local profile = Profiles[player]
		if profile and profile.Data then
			profile.Data.HourPickCooldown = cooldownEndTime
			return true
		end
		return false
	end)
end

function DataStoreModule.addSteals(player: Player, amount: number)
	return safeDataOperation(player, function()
		local profile = Profiles[player]
		if profile and profile.Data then
			profile.Data.Steals = (profile.Data.Steals or 0) + math.max(0, math.floor(amount))
		end
	end)
end

function DataStoreModule.addAnimal(player: Player, animal: string, mutation: string?, traits: string?)
	return safeDataOperation(player, function()
		local profile = Profiles[player]
		if profile and profile.Data then
			local PlayerChanel = Synchronizer:Get(player)
			local animalList = profile.Data.AnimalList
			local maxAnimals = DataStoreModule.GetMaxAnimals(player)
			for i = 1, maxAnimals do
				if animalList[i] == "Empty" or animalList[i] == nil then
					local animalData = {
						Index = animal,
						LastCollect = workspace:GetServerTimeNow(),
						Mutation = mutation,
						Steal = false
					}

					local Animals = require(ReplicatedStorage.Datas.Animals)
					local animalInfo = Animals[animal]
					if animalInfo and animalInfo.LuckyBlock and animalInfo.LuckyBlock.Timer then
						animalData.Timer = animalInfo.LuckyBlock.Timer
					end

					if traits and traits ~= "" then
						if typeof(traits) == "string" then
							local success, decodedTraits = pcall(HttpService.JSONDecode, HttpService, traits)
							animalData.Traits = success and decodedTraits or nil
						else
							animalData.Traits = traits
						end
					end

					animalList[i] = animalData

					DataStoreModule.addToIndex(player, animal, mutation)

					if PlayerChanel then
						PlayerChanel:Set("AnimalAddedOrRemoved", animalList)
						PlayerChanel:Set("AnimalPodiums", animalList)
					end

					local PlotsService = require(script.Parent.Plots)
					local plot = PlotsService.getPlot(player)
					if plot then
						plot:SetAnimalList(animalList)
					end

					return i 
				end
			end	

		end
	end)
end

function DataStoreModule.removeAnimal(player: Player, slot: number)
	return safeDataOperation(player, function()
		local profile = Profiles[player]
		if profile and profile.Data then
			local PlayerChannel = Synchronizer:Get(player)
			local animalList = profile.Data.AnimalList

			if animalList[slot] and typeof(animalList[slot]) == "table" then
				local removedAnimal = animalList[slot]
				animalList[slot] = "Empty"

				if PlayerChannel then
					PlayerChannel:Set("AnimalAddedOrRemoved", animalList)
					PlayerChannel:Set("AnimalPodiums", animalList)
				end

				local PlotsService = require(script.Parent.Plots)
				local plot = PlotsService.getPlot(player)
				if plot then
					plot:SetAnimalList(animalList)
				end

				return removedAnimal
			end
		end
		return nil
	end)
end

function DataStoreModule.updateAnimal(player: Player, slot: number, data: table)
	return safeDataOperation(player, function()
		local profile = Profiles[player]
		if profile and profile.Data then
			local animalList = profile.Data.AnimalList
			if animalList[slot] and typeof(animalList[slot]) == "table" then
				for key, value in pairs(data) do
					animalList[slot][key] = value
				end

				local updatedAnimalList = DataStoreModule.getAnimalList(player)

				local PlayerChannel = Synchronizer:Get(player)
				if PlayerChannel then
					PlayerChannel:Set("AnimalAddedOrRemoved", updatedAnimalList)
					PlayerChannel:Set("AnimalPodiums", updatedAnimalList)
				end

				local PlotsService = require(script.Parent.Plots)
				local plot = PlotsService.getPlot(player)
				if plot then
					plot:SetAnimalList(updatedAnimalList)
				end

				return true
			elseif data == "Empty" then
				animalList[slot] = "Empty"

				local updatedAnimalList = DataStoreModule.getAnimalList(player)

				local PlayerChannel = Synchronizer:Get(player)
				if PlayerChannel then
					PlayerChannel:Set("AnimalAddedOrRemoved", updatedAnimalList)
					PlayerChannel:Set("AnimalPodiums", updatedAnimalList)
				end

				local PlotsService = require(script.Parent.Plots)
				local plot = PlotsService.getPlot(player)
				if plot then
					plot:SetAnimalList(updatedAnimalList)
				end

				return true
			end
		end
		return false
	end)
end

function DataStoreModule.getAnimalList(player: Player)
	local profile = Profiles[player]
	if profile and profile.Data and ProfileLoadingStates[player] == LOADING_STATES.LOADED then
		return profile.Data.AnimalList
	end
	return {}
end

function DataStoreModule.GetMaxAnimals(player: Player)
	local profile = Profiles[player]
	if profile and profile.Data and ProfileLoadingStates[player] == LOADING_STATES.LOADED then
		local rebirthTier = profile.Data.Rebirths or 0
		local Bases = require(ReplicatedStorage.Datas.Bases)
		return Bases[rebirthTier].MaxAnimals
	end
	local Bases = require(ReplicatedStorage.Datas.Bases)
	return Bases[0].MaxAnimals
end

function DataStoreModule.GetCoins(player: Player)
        local profile = Profiles[player]
        if profile and profile.Data and ProfileLoadingStates[player] == LOADING_STATES.LOADED then
                return profile.Data.Coins
        end
        return 0
end

function DataStoreModule.GetGelatin(player: Player)
        local profile = Profiles[player]
        if profile and profile.Data and ProfileLoadingStates[player] == LOADING_STATES.LOADED then
                return profile.Data.Gelatin or 0
        end
        return 0
end

function DataStoreModule.GetEssences(player: Player)
        local profile = Profiles[player]
        if profile and profile.Data and ProfileLoadingStates[player] == LOADING_STATES.LOADED then
                return profile.Data.Essences or 0
        end
        return 0
end

function DataStoreModule.addCoins(player: Player, amount: number)
        return safeDataOperation(player, function()
                local profile = Profiles[player]
                if profile and profile.Data then
                        profile.Data.Coins = profile.Data.Coins + math.max(0, math.floor(amount))
		end
	end)
end

function DataStoreModule.addGelatin(player: Player, amount: number)
        return safeDataOperation(player, function()
                local profile = Profiles[player]
                if profile and profile.Data then
                        profile.Data.Gelatin = (profile.Data.Gelatin or 0) + math.max(0, math.floor(amount))
                end
        end)
end

function DataStoreModule.addEssences(player: Player, amount: number)
        return safeDataOperation(player, function()
                local profile = Profiles[player]
                if profile and profile.Data then
                        profile.Data.Essences = (profile.Data.Essences or 0) + math.max(0, math.floor(amount))
                end
        end)
end

function DataStoreModule.SetCoins(player: Player, amount: number)
        return safeDataOperation(player, function()
                local profile = Profiles[player]
                if profile and profile.Data then
                        profile.Data.Coins = math.max(0, math.floor(amount))
                end
        end)
end

function DataStoreModule.SetGelatin(player: Player, amount: number)
        return safeDataOperation(player, function()
                local profile = Profiles[player]
                if profile and profile.Data then
                        profile.Data.Gelatin = math.max(0, math.floor(amount))
                end
        end)
end

function DataStoreModule.SetEssences(player: Player, amount: number)
        return safeDataOperation(player, function()
                local profile = Profiles[player]
                if profile and profile.Data then
                        profile.Data.Essences = math.max(0, math.floor(amount))
                end
        end)
end

function DataStoreModule.deductCoins(player: Player, amount: number)
        return safeDataOperation(player, function()
                local profile = Profiles[player]
                if profile and profile.Data then
                        local deductAmount = math.abs(math.floor(amount))
			local currentCoins = profile.Data.Coins

			local newCoins = math.max(0, currentCoins - deductAmount)
			profile.Data.Coins = newCoins

			return newCoins >= 0 and currentCoins >= deductAmount
		end
		return false
	end)
end

function DataStoreModule.deductGelatin(player: Player, amount: number)
        return safeDataOperation(player, function()
                local profile = Profiles[player]
                if profile and profile.Data then
                        local deductAmount = math.abs(math.floor(amount))
                        local currentGelatin = profile.Data.Gelatin or 0

                        local newGelatin = math.max(0, currentGelatin - deductAmount)
                        profile.Data.Gelatin = newGelatin

                        return newGelatin >= 0 and currentGelatin >= deductAmount
                end
                return false
        end)
end

function DataStoreModule.deductEssences(player: Player, amount: number)
        return safeDataOperation(player, function()
                local profile = Profiles[player]
                if profile and profile.Data then
                        local deductAmount = math.abs(math.floor(amount))
                        local currentEssences = profile.Data.Essences or 0

                        local newEssences = math.max(0, currentEssences - deductAmount)
                        profile.Data.Essences = newEssences

                        return newEssences >= 0 and currentEssences >= deductAmount
                end
                return false
        end)
end

function DataStoreModule.deductRebirths(player: Player, amount: number)
        return safeDataOperation(player, function()
                local profile = Profiles[player]
                if profile and profile.Data then
                        local deductAmount = math.abs(math.floor(amount))
			local currentCoins = profile.Data.Rebirths

			local newCoins = math.max(0, currentCoins - deductAmount)
			profile.Data.Rebirths = newCoins

			return newCoins >= 0 and currentCoins >= deductAmount
		end
		return false
	end)
end

function DataStoreModule.GetBaseState(player: Player)
        local profile = Profiles[player]
        if profile and profile.Data and ProfileLoadingStates[player] == LOADING_STATES.LOADED then
                profile.Data.BaseState = profile.Data.BaseState or BaseConfig.createDefaultState()
                local baseState = profile.Data.BaseState
                baseState.UnlockedPods = baseState.UnlockedPods or BaseConfig.InitialUnlockedPods
                baseState.AssignedPods = baseState.AssignedPods or {}
                baseState.Upgrades = baseState.Upgrades or {}
                return baseState
        end

        local defaultState = BaseConfig.createDefaultState()
        return defaultState
end

function DataStoreModule.SetBaseState(player: Player, baseState)
        return safeDataOperation(player, function()
                local profile = Profiles[player]
                if profile and profile.Data then
                        local newState = baseState or BaseConfig.createDefaultState()
                        profile.Data.BaseState = BaseConfig.copyState(newState)
                end
        end)
end

function DataStoreModule.UpdateBaseState(player: Player, callback)
        if typeof(callback) ~= "function" then
                return false
        end

        return safeDataOperation(player, function()
                local profile = Profiles[player]
                if profile and profile.Data then
                        local state = profile.Data.BaseState
                        if typeof(state) ~= "table" then
                                state = BaseConfig.createDefaultState()
                                profile.Data.BaseState = state
                        end

                        callback(state)
                        return state
                end
        end)
end

function DataStoreModule.GetRebirths(player: Player)
        local profile = Profiles[player]
        if profile and profile.Data and ProfileLoadingStates[player] == LOADING_STATES.LOADED then
                return profile.Data.Rebirths
        end
	return 0
end

function DataStoreModule.GetDataMan(player: Player)
	local profile = Profiles[player]
	if profile and profile.Data and ProfileLoadingStates[player] == LOADING_STATES.LOADED then
		local dataKeyCount = 0
		for _ in pairs(profile.Data) do
			dataKeyCount = dataKeyCount + 1
		end

		local isDataCorrupted = profile.Data.Coins == nil or dataKeyCount == 0
		local isStudio = RunService:IsStudio()

		if isDataCorrupted then

			local function deepCopy(original)
				local copy = {}
				for key, value in pairs(original) do
					if typeof(value) == "table" then
						copy[key] = deepCopy(value)
					else
						copy[key] = value
					end
				end
				return copy
			end

			profile.Data = deepCopy(Template)
		end

		return profile.Data
	end

	return Template
end

function DataStoreModule.addRebirths(player: Player, amount: number)
	return safeDataOperation(player, function()
		local profile = Profiles[player]
		if profile and profile.Data then
			profile.Data.Rebirths = profile.Data.Rebirths + math.max(0, math.floor(amount))
		end
	end)
end

function DataStoreModule.setRebirths(player: Player, amount: number)
	return safeDataOperation(player, function()
		local profile = Profiles[player]
		if profile and profile.Data then
			profile.Data.Rebirths = math.max(0, math.floor(amount))
		end
	end)
end

function DataStoreModule.isDataReady(player: Player)
	return ProfileLoadingStates[player] == LOADING_STATES.LOADED
end

function DataStoreModule.waitForData(player: Player, timeout: number?)
	timeout = timeout or 30
	local startTime = tick()

	while ProfileLoadingStates[player] ~= LOADING_STATES.LOADED do
		if tick() - startTime > timeout then
			warn(`Timeout waiting for data for player: {player.Name}`)
			return false
		end
		if ProfileLoadingStates[player] == LOADING_STATES.FAILED then
			return false
		end
		task.wait(0.1)
	end

	return true
end

function DataStoreModule.updateLastOnline(player: Player)
	return safeDataOperation(player, function()
		local profile = Profiles[player]
		if profile and profile.Data then
			profile.Data.LastOnline = workspace:GetServerTimeNow()
		end
	end)
end

function DataStoreModule.getLastOnline(player: Player)
	local profile = Profiles[player]
	if profile and profile.Data and ProfileLoadingStates[player] == LOADING_STATES.LOADED then
		return profile.Data.LastOnline or workspace:GetServerTimeNow()
	end
	return workspace:GetServerTimeNow()
end
function DataStoreModule.GetGlobalData()

	return GlobalTemplate
end
function DataStoreModule.calculateOfflineGains(player: Player)
	local profile = Profiles[player]
	if profile and profile.Data and ProfileLoadingStates[player] == LOADING_STATES.LOADED then
		local currentTime = workspace:GetServerTimeNow()
		local lastOnline = profile.Data.LastOnline or currentTime
		local offlineTime = math.max(0, currentTime - lastOnline)

		local GameData = require(ReplicatedStorage:WaitForChild("Datas").Game)
		local rebirths = profile.Data.Rebirths or 0
		local maxOfflineTime = GameData.Game.OfflineMaxTime[rebirths] or GameData.Game.OfflineMaxTime[0] or 60

		offlineTime = math.min(offlineTime, maxOfflineTime)

		local animalList = profile.Data.AnimalList or {}
		for i, animal in ipairs(animalList) do
			if animal and typeof(animal) == "table" then
				if offlineTime > 0 then
					animalList[i].OfflineGain = offlineTime
				else
					animalList[i].OfflineGain = nil
				end

				animalList[i].Steal = false
			end
		end

		profile.Data.AnimalList = animalList

		return animalList
	end
	return {}
end

function DataStoreModule.addToIndex(player: Player, animalIndex: string, mutation: string?)
	return safeDataOperation(player, function()
		local profile = Profiles[player]
		if profile and profile.Data then
			if not profile.Data.Index then
				profile.Data.Index = {}
			end

			if not profile.Data.Index[animalIndex] then
				profile.Data.Index[animalIndex] = {}
			end

			local mutationKey = mutation or "Default"

			profile.Data.Index[animalIndex][mutationKey] = true

			local PlayerChannel = Synchronizer:Get(player)
			if PlayerChannel then
				PlayerChannel:Set("Index." .. animalIndex, profile.Data.Index[animalIndex])
				PlayerChannel:Set("Index", profile.Data.Index)
			end

			local Animals = require(ReplicatedStorage.Datas.Animals)
			local allCandy = true
			for id, _ in pairs(Animals) do
				if not (profile.Data.Index[id] and profile.Data.Index[id]["Candy"]) then
					allCandy = false
					break
				end
			end

			local PlotsService = require(script.Parent.Plots)
			local plot = PlotsService.getPlot(player)
			if plot then
				if plot.RefreshMultiplier then
					plot:RefreshMultiplier()
				end

				if allCandy and plot.ApplyCandySkin then
					plot:ApplyCandySkin()
				elseif not allCandy then
					local allRainbow = true
					for id, _ in pairs(Animals) do
						if not (profile.Data.Index[id] and profile.Data.Index[id]["Rainbow"]) then
							allRainbow = false
							break
						end
					end
					if allRainbow and plot.ApplyRainbowSkin then
						plot:ApplyRainbowSkin()
					elseif not allRainbow then
						local allDiamond = true
						for id, _ in pairs(Animals) do
							if not (profile.Data.Index[id] and profile.Data.Index[id]["Diamond"]) then
								allDiamond = false
								break
							end
						end
						if allDiamond and plot.ApplyDiamondSkin then
							plot:ApplyDiamondSkin()
						elseif not allDiamond then
							local allGold = true
							for id, _ in pairs(Animals) do
								if not (profile.Data.Index[id] and profile.Data.Index[id]["Gold"]) then
									allGold = false
									break
								end
							end
							if allGold and plot.ApplyGoldSkin then
								plot:ApplyGoldSkin()
							end
						end
					end
				end

				return true
			end
		end
		return false
	end)
end

function DataStoreModule.isTutorialFinished(player: Player)
	local profile = Profiles[player]
	if profile and profile.Data and ProfileLoadingStates[player] == LOADING_STATES.LOADED then
		return profile.Data.TutorialFinished or false
	end
	return false
end

function DataStoreModule.finishTutorial(player: Player)
	return safeDataOperation(player, function()
		local profile = Profiles[player]
		if profile and profile.Data then
			if not profile.Data.TutorialFinished then
				profile.Data.TutorialFinished = true
				profile.Data.TutorialProgress.CompletedAt = workspace:GetServerTimeNow()

				local PlayerChannel = Synchronizer:Get(player)
				if PlayerChannel then
					PlayerChannel:Set("TutorialFinished", true)
				end

				DataStoreModule.addCoins(player, 500)

				return true
			end
		end
		return false
	end)
end

function DataStoreModule.updateTutorialStep(player: Player, step: number)
	return safeDataOperation(player, function()
		local profile = Profiles[player]
		if profile and profile.Data then
			if not profile.Data.TutorialProgress then
				profile.Data.TutorialProgress = {
					StartedAt = workspace:GetServerTimeNow(),
					CompletedAt = 0,
					CurrentStep = 1,
					StepsCompleted = {}
				}
			end

			profile.Data.TutorialProgress.CurrentStep = step
			profile.Data.TutorialProgress.StepsCompleted[step] = workspace:GetServerTimeNow()

			local PlayerChannel = Synchronizer:Get(player)
			if PlayerChannel then
				PlayerChannel:Set("TutorialStep", step)
			end

			return true
		end
		return false
	end)
end

function DataStoreModule.getTutorialProgress(player: Player)
	local profile = Profiles[player]
	if profile and profile.Data and ProfileLoadingStates[player] == LOADING_STATES.LOADED then
		return profile.Data.TutorialProgress or {
			StartedAt = 0,
			CompletedAt = 0,
			CurrentStep = 1,
			StepsCompleted = {}
		}
	end
	return {
		StartedAt = 0,
		CompletedAt = 0,
		CurrentStep = 1,
		StepsCompleted = {}
	}
end

function DataStoreModule.getGamepasses(player: Player)
	local profile = Profiles[player]
	if profile and profile.Data and ProfileLoadingStates[player] == LOADING_STATES.LOADED then
		return profile.Data.Gamepass or {}
	end
	return {}
end

function DataStoreModule.getDatastoreKey()
	return DATASTORE_KEY
end

function DataStoreModule.forceCleanupSession(player: Player)
	local profile = Profiles[player]
	if profile then
		warn(`Force cleaning up stuck session for player: {player.Name}`)

		local success, err = pcall(function()
			if profile:IsActive() then
				profile:Save()
				task.wait(1)
				profile:EndSession()
			end
		end)

		if not success then
			warn(`Force cleanup failed for player: {player.Name}: {tostring(err)}`)
		end

		Profiles[player] = nil
		ProfileLoadingStates[player] = nil
		QueuedOperations[player] = nil
	end
end

function DataStoreModule.clearStuckSession(player: Player)

	task.wait(5)

	return true
end

function DataStoreModule.resetPlayerData(player: Player)
	local userId = tostring(player.UserId)
	local profile = Profiles[player]

	ProfileLoadingBlacklist[player] = true
	player:Kick("Profile session end - Please rejoin")

	if profile then
		local sessionEndSuccess = pcall(function()
			profile:EndSession()
		end)

		if not sessionEndSuccess then
			warn("[DataStore] Failed to end session for player:", player.Name)
		end

		if profile.session_token then
			local testData = ProfileStore.Test()
			if testData and testData.ActiveSessionCheck then
				testData.ActiveSessionCheck[profile.session_token] = nil
				print("[DataStore] Manually cleared ActiveSessionCheck for:", player.Name)
			end
		end

		Profiles[player] = nil
		ProfileLoadingStates[player] = nil
		QueuedOperations[player] = nil

		local removeSuccess = false
		local maxRetries = 3

		for attempt = 1, maxRetries do
			local success, err = pcall(function()
				DataStore:RemoveAsync(userId)
			end)

			if success then
				removeSuccess = true
				print("[DataStore] Successfully removed data for player:", player.Name, "on attempt", attempt)
				break
			else
				warn("[DataStore] Failed to remove data for player:", player.Name, "on attempt", attempt, "Error:", err)
			end
		end

		if not removeSuccess then
			warn("[DataStore] Failed to remove data for player after all retries:", player.Name)
		end

	else
		warn("[DataStore] No profile found for player:", player.Name, "during reset")
	end

	ProfileLoadingBlacklist[player] = nil
	print("[DataStore] Removed player from loading blacklist:", player.Name)
end

function DataStoreModule.getProfileState(player: Player)
	return ProfileLoadingStates[player] or LOADING_STATES.NOT_STARTED
end

local function startPeriodicCleanup()
	task.spawn(function()
		while true do
			task.wait(300)

			for player, profile in pairs(Profiles) do
				if not player.Parent then
					warn(`Found orphaned profile for disconnected player: {player.Name}`)
					DataStoreModule.forceCleanupSession(player)
				end
			end

			for player, state in pairs(ProfileLoadingStates) do
				if not player.Parent and state == LOADING_STATES.LOADING then
					warn(`Found stuck loading state for disconnected player: {player.Name}`)
					ProfileLoadingStates[player] = nil
					QueuedOperations[player] = nil
					ProfileLoadingBlacklist[player] = nil
				end
			end
		end
	end)
end

startPeriodicCleanup()

function DataStoreModule.hasGamepass(player: Player, gamepassName: string)
	local profile = Profiles[player]
	if profile and profile.Data and ProfileLoadingStates[player] == LOADING_STATES.LOADED then
		local gamepasses = profile.Data.Gamepass or {}
		return gamepasses[gamepassName] == true
	end
	return false
end

function DataStoreModule.addGamepass(player: Player, gamepassName: string)
	return safeDataOperation(player, function()
		local profile = Profiles[player]
		if profile and profile.Data then
			profile.Data.Gamepass = profile.Data.Gamepass or {}
			profile.Data.Gamepass[gamepassName] = true

			local PlayerChannel = Synchronizer:Get(player)
			if PlayerChannel then
				PlayerChannel:Set("Gamepass", profile.Data.Gamepass)
			end

			return true
		end
		return false
	end)
end

function DataStoreModule.removeGamepass(player: Player, gamepassName: string)
	return safeDataOperation(player, function()
		local profile = Profiles[player]
		if profile and profile.Data then
			profile.Data.Gamepass = profile.Data.Gamepass or {}
			profile.Data.Gamepass[gamepassName] = false

			local PlayerChannel = Synchronizer:Get(player)
			if PlayerChannel then
				PlayerChannel:Set("Gamepass", profile.Data.Gamepass)
			end

			return true
		end
		return false
	end)
end

function DataStoreModule.updateGamepasses(player: Player, gamepasses: table)
	return safeDataOperation(player, function()
		local profile = Profiles[player]
		if profile and profile.Data then
			profile.Data.Gamepass = gamepasses or {}

			local PlayerChannel = Synchronizer:Get(player)
			if PlayerChannel then
				PlayerChannel:Set("Gamepass", profile.Data.Gamepass)
			end

			return true
		end
		return false
	end)
end

function DataStoreModule.getTotalGeneration(player: Player)
	local profile = Profiles[player]
	if not (profile and profile.Data and ProfileLoadingStates[player] == LOADING_STATES.LOADED) then
		return 0
	end

	local Animals = require(ReplicatedStorage.Shared.Animals)
	local animalList = profile.Data.AnimalList or {}
	local totalGeneration = 0

	for _, animal in pairs(animalList) do
		if animal and typeof(animal) == "table" and animal.Index then
			local generation = Animals:GetGeneration(
				animal.Index,
				animal.Mutation,
				animal.Traits or {},
				player
			)
			totalGeneration = totalGeneration + generation
		end
	end

	return math.floor(totalGeneration)
end

return DataStoreModule