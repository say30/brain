--[[
  Extracted from: ServerScriptService.Main.Data.Leaderboards
  Class: Script
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local HttpService = game:GetService("HttpService")
local Packages = ReplicatedStorage:WaitForChild("Packages")
local Net = require(Packages.Net)
local DataStoreModule = require(game:GetService("ServerScriptService").Services.DataManagment)
local GenerationLeaderboard = DataStoreService:GetOrderedDataStore("GlobalLeaderboards_Generation")
local StealsLeaderboard = DataStoreService:GetOrderedDataStore("GlobalLeaderboards_Steals")
local GetTopPlayers = Net:RemoteFunction("Leaderboard/GetTopPlayers")
local GetDisplayNames = Net:RemoteFunction("Leaderboard/GetDisplayNames")
local ReplicateUpdate = Net:RemoteEvent("Leaderboard/ReplicateUpdate")
local ReplicateDisplayNames = Net:RemoteEvent("Leaderboard/ReplicateDisplayNames")
local MAX_LEADERBOARD_SIZE = 100
local UPDATE_INTERVAL = 60
local DISPLAY_NAME_CACHE_DURATION = 3600
local MAX_RETRIES = 3
local RETRY_DELAY = 1
local MIN_DS_BUDGET = 1
local DisplayNameCache = {}
local LeaderboardCache = {Generation = {}, Steals = {}}
local NAME_REQUEST_THROTTLE = 0.25

local LastSavedValues = {
	Generation = {},
	Steals = {}
}

local function isValidPlayer(player)
	return player and player.UserId and player.UserId > 0
end

local function updatePlayerLeaderboard(player, leaderboardType, value)
	if not isValidPlayer(player) then return end
	value = math.floor(value or 0)
	if value <= 0 then return end

	if leaderboardType == "Generation" and value < 1000 then return end

	local last = LastSavedValues[leaderboardType][player.UserId]
	if last and last == value then
		return
	end

	local requestType = Enum.DataStoreRequestType.UpdateAsync
	while DataStoreService:GetRequestBudgetForRequestType(requestType) < MIN_DS_BUDGET do
		task.wait(1)
	end

	for attempt = 1, MAX_RETRIES do
		local success, err = pcall(function()
			if leaderboardType == "Generation" then
				GenerationLeaderboard:SetAsync(tostring(player.UserId), value)
			elseif leaderboardType == "Steals" then
				StealsLeaderboard:SetAsync(tostring(player.UserId), value)
			end
		end)
		if success then
			LastSavedValues[leaderboardType][player.UserId] = value
			return
		end
		if attempt < MAX_RETRIES then
			task.wait(RETRY_DELAY * attempt)
		end
	end
end

local function getTopPlayers(leaderboardType)
	for attempt = 1, MAX_RETRIES do
		local success, result = pcall(function()
			local leaderboard = leaderboardType == "Generation" and GenerationLeaderboard or StealsLeaderboard
			local pages = leaderboard:GetSortedAsync(false, MAX_LEADERBOARD_SIZE, 0)
			local data = pages:GetCurrentPage()
			local topPlayers = {}
			for rank, entry in ipairs(data) do
				local userId = tonumber(entry.key)
				if userId > 0 then 
					table.insert(topPlayers, {
						UserId = userId,
						Value = entry.value,
						Rank = rank
					})
				end
			end
			return topPlayers
		end)
		if success then
			return result
		end
		if attempt < MAX_RETRIES then
			task.wait(RETRY_DELAY * attempt)
		end
	end
	return {}
end

local function getDisplayNames(userIds)
	local names = {}
	local toFetch = {}
	for _, userId in ipairs(userIds) do
		if userId <= 0 then continue end 
		if DisplayNameCache[userId] and DisplayNameCache[userId].Timestamp + DISPLAY_NAME_CACHE_DURATION > os.time() then
			names[userId] = DisplayNameCache[userId].Name
		else
			table.insert(toFetch, userId)
		end
	end
	if #toFetch > 0 then
		for index, userId in ipairs(toFetch) do
			local success, fetchedName = pcall(Players.GetNameFromUserIdAsync, Players, userId)
			if success and fetchedName then
				DisplayNameCache[userId] = {Name = fetchedName, Timestamp = os.time()}
				names[userId] = fetchedName
			else
				DisplayNameCache[userId] = {Name = "User" .. userId, Timestamp = os.time()}
				if not names[userId] then
					warn(string.format("[Leaderboards] Username fetch failed for %d : %s", userId, fetchedName or "HTTP error"))
				end
				names[userId] = "User" .. userId
			end

			if index < #toFetch then
				task.wait(NAME_REQUEST_THROTTLE)
			end
		end
	end
	return names
end

local function updateLeaderboards()
	for _, player in ipairs(Players:GetPlayers()) do
		if not isValidPlayer(player) then continue end
		if DataStoreModule.isDataReady(player) then
			local data = DataStoreModule.GetDataMan(player)
			local totalGeneration = DataStoreModule.getTotalGeneration(player)
			updatePlayerLeaderboard(player, "Generation", totalGeneration)
			updatePlayerLeaderboard(player, "Steals", data.Steals)
		else
			warn("Data not ready for player:", player.Name)
		end
	end
	for _, leaderboardType in ipairs({"Generation", "Steals"}) do
		local topPlayers = getTopPlayers(leaderboardType)
		if #topPlayers > 0 then
			LeaderboardCache[leaderboardType] = topPlayers
			ReplicateUpdate:FireAllClients(leaderboardType, topPlayers)
			local userIds = {}
			for _, entry in ipairs(topPlayers) do
				if entry.UserId > 0 then
					table.insert(userIds, entry.UserId)
				end
			end
			local displayNames = getDisplayNames(userIds)
			ReplicateDisplayNames:FireAllClients(displayNames)
		end
	end
end

GetTopPlayers.OnServerInvoke = function(player, leaderboardType)
	if leaderboardType ~= "Generation" and leaderboardType ~= "Steals" then return {} end
	local data = LeaderboardCache[leaderboardType] or getTopPlayers(leaderboardType)
	return data
end

GetDisplayNames.OnServerInvoke = function(player)
	local userIds = {}
	for _, leaderboardType in ipairs({"Generation", "Steals"}) do
		for _, entry in ipairs(LeaderboardCache[leaderboardType] or {}) do
			if entry.UserId > 0 then
				table.insert(userIds, entry.UserId)
			end
		end
	end
	local names = getDisplayNames(userIds)
	return names
end

Players.PlayerAdded:Connect(function(player)
	if not isValidPlayer(player) then return end
	task.wait(2)
	DataStoreModule.loadProfileAsync(player)
	task.spawn(function()
		if DataStoreModule.waitForData(player, 30) then
			local data = DataStoreModule.GetDataMan(player)
			local totalGeneration = DataStoreModule.getTotalGeneration(player)
			updatePlayerLeaderboard(player, "Generation", totalGeneration)
			updatePlayerLeaderboard(player, "Steals", data.Steals)

			for _, lbType in ipairs({"Generation", "Steals"}) do
				local cached = LeaderboardCache[lbType]
				if #cached > 0 then
					ReplicateUpdate:FireClient(player, lbType, cached)
				end
			end
			local userIds = {}
			for _, lbType in ipairs({"Generation", "Steals"}) do
				for _, entry in ipairs(LeaderboardCache[lbType] or {}) do
					if entry.UserId > 0 then
						table.insert(userIds, entry.UserId)
					end
				end
			end
			local names = getDisplayNames(userIds)
			ReplicateDisplayNames:FireClient(player, names)
		else
			warn("Failed to load data for", player.Name)
		end
	end)
end)

Players.PlayerRemoving:Connect(function(player)
	if not isValidPlayer(player) then return end
	if DataStoreModule.isDataReady(player) then
		local data = DataStoreModule.GetDataMan(player)
		local totalGeneration = DataStoreModule.getTotalGeneration(player)
		updatePlayerLeaderboard(player, "Generation", totalGeneration)
		updatePlayerLeaderboard(player, "Steals", data.Steals)
	end
end)

for _, player in ipairs(Players:GetPlayers()) do
	if isValidPlayer(player) then
		task.spawn(function()
			if DataStoreModule.waitForData(player, 30) then
				local data = DataStoreModule.GetDataMan(player)
				local totalGeneration = DataStoreModule.getTotalGeneration(player)
				updatePlayerLeaderboard(player, "Generation", totalGeneration)
				updatePlayerLeaderboard(player, "Steals", data.Steals)
			else
				warn("Failed to load data for existing player:", player.Name)
			end
		end)
	end
end

task.spawn(function()
	while true do
		updateLeaderboards()
		task.wait(UPDATE_INTERVAL)
	end
end)