--[[
  Extracted from: ServerScriptService.Main.Data.NonEmptySlotHandler
  Class: Script
  Source file: rickdev.rbxlx
]]

local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DataManagement = require(ServerScriptService.Services.DataManagment)
local Net = require(ReplicatedStorage.Packages.Net)

Net:RemoteFunction("NonEmptySlots/Get").OnServerInvoke = function(player)
	if not DataManagement.isDataReady(player) then
		warn("[NonEmptySlotHandler] Data not ready for player:", player.Name)
		return {}
	end

	local animalList = DataManagement.getAnimalList(player)
	if not animalList then
		warn("[NonEmptySlotHandler] No animal list found for player:", player.Name)
		return {}
	end

	local nonEmptySlots = {}
	for slot, animal in pairs(animalList) do
		if animal and animal ~= "Empty" and typeof(animal) == "table" and animal.Index then
			table.insert(nonEmptySlots, slot)
		end
	end

	return nonEmptySlots
end