--[[
  Extracted from: ServerScriptService.Main.Data.Settings
  Class: Script
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Net = require(ReplicatedStorage.Packages.Net)
local Players = game:GetService("Players")

local DataManagment = require(ServerScriptService.Services.DataManagment)
local Synchronizer = require(ReplicatedStorage.Packages.Synchronizer)
local SettingsService = Net:RemoteFunction("SettingsService/ToggleSetting")

SettingsService.OnServerInvoke = function(player, settingName, plotName)
	warn(plotName, settingName)
	if not DataManagment.isDataReady(player) then
		DataManagment.waitForData(player)
	end

	local data = DataManagment.GetDataMan(player)
	if not data then
		return false, "Player data not found"
	end

	local settings = data.Settings
	if not settings then
		return false, "Settings data not found"
	end

	if plotName then
		if settings[settingName] == nil then
			return false, "Invalid setting name"
		end

		settings[settingName] = plotName
		local players = Synchronizer:Get(player)
		if players then
			players:Set("Settings." .. settingName, settings[settingName])
		end

		DataManagment.ApplySkin(player, plotName)
		return true, settings[settingName]
	else
		if settings[settingName] == nil then
			return false, "Invalid setting name"
		end

		settings[settingName] = not settings[settingName]
		local players = Synchronizer:Get(player)
		if players then
			players:Set("Settings." .. settingName, settings[settingName])
		end

		return true, settings[settingName]
	end
end