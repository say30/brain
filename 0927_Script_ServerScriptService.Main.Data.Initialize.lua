--[[
  Extracted from: ServerScriptService.Main.Data.Initialize
  Class: Script
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataStoreModule = require(game.ServerScriptService.Services.DataManagment)
local Plots = require(game.ServerScriptService.Services.Plots)
local Playersmodule = require(game.ServerScriptService.Services.Players)
local TutorialService = require(game.ServerScriptService.Services.TutorialService)
local Tips = require(game.ServerScriptService.Services.Tips)

local Players = game:GetService("Players")

local InitializingPlayers = {}

local function initializePlayer(player: Player)
	if InitializingPlayers[player] then
		return
	end


	InitializingPlayers[player] = true

	task.spawn(function()
		local success, profile = pcall(function()
			return DataStoreModule.loadProfile(player)
		end)

		if not success then
			InitializingPlayers[player] = nil
			player:Kick("Failed to load your data. Please rejoin the game.")
			return
		end

		if not profile then
			InitializingPlayers[player] = nil
			return
		end

		local dataReady = DataStoreModule.waitForData(player, 30)
		if not dataReady then
			InitializingPlayers[player] = nil
			player:Kick("Data loading timeout. Please rejoin the game.")
			return
		end

		
		local plotSuccess = pcall(function()
			Plots.CreatePlot(player)
		end)


		local Tips = pcall(function()
			Tips.new(Plots)
		end)


		if  not plotSuccess then
			warn("Error initializing systems for " .. player.Name)
			InitializingPlayers[player] = nil
			player:Kick("Failed to initialize game systems. Please rejoin.")
			return
		end
		InitializingPlayers[player] = nil
		ReplicatedStorage:SetAttribute("ServerReady", true)
	end)
end

Players.PlayerAdded:Connect(initializePlayer)

for _, player in pairs(Players:GetPlayers()) do
	task.spawn(initializePlayer, player)
end

Players.PlayerRemoving:Connect(function(player)
	InitializingPlayers[player] = nil

	local success, err = pcall(function()
		DataStoreModule.updateLastOnline(player)
		DataStoreModule.saveProfile(player)
	end)

	if not success then

		task.wait(1)
		local forceSuccess, forceErr = pcall(function()
			DataStoreModule.forceCleanupSession(player)
		end)
	end
end)