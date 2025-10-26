--[[
  Extracted from: ServerScriptService.Services.CmdrService.Commands.CustomCommands.removebrainrotServer
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Animals = require(ReplicatedStorage.Datas.Animals)
local Net = require(ReplicatedStorage.Packages.Net)

return function(context, players, slot)
	local ServerScriptService = game:GetService("ServerScriptService")
	local DataManagement = require(ServerScriptService.Services.DataManagment)

	if not slot or type(slot) ~= "number" or slot < 1 then
		return "❌ Invalid slot number provided!"
	end

	local successCount = 0
	local failedPlayers = {}
	local results = {}

	for _, player in pairs(players) do
		if not DataManagement.isDataReady(player) then
			table.insert(failedPlayers, player.Name .. " (data not ready)")
			continue
		end

		local animalList = DataManagement.getAnimalList(player)
		if not animalList then
			table.insert(failedPlayers, player.Name .. " (no animal list)")
			continue
		end

		local animal = animalList[slot]
		if not animal or animal == "Empty" or type(animal) ~= "table" or not animal.Index then
			table.insert(failedPlayers, player.Name .. " (no animal in slot " .. tostring(slot) .. ")")
			continue
		end

		local animalData = Animals[animal.Index]
		if not animalData then
			table.insert(failedPlayers, player.Name .. " (invalid animal data for index " .. tostring(animal.Index) .. ")")
			continue
		end

		local success, result = pcall(function()
			return DataManagement.removeAnimal(player, slot)
		end)

		if success and result then
			successCount = successCount + 1
			table.insert(results, {
				player = player,
				animal = animalData.DisplayName or animalData.Name or tostring(animal.Index),
				slot = slot
			})
		else
			table.insert(failedPlayers, player.Name .. " (removal failed: " .. tostring(result or "unknown error") .. ")")
		end
	end

	local responseLines = {}

	if successCount > 0 then
		table.insert(responseLines, string.format("✅ Successfully removed animals from %d player(s):", successCount))

		for _, result in ipairs(results) do
			table.insert(responseLines, string.format("  • %s - %s (slot %d)", 
				result.player.Name, result.animal, result.slot))
		end
	end

	if #failedPlayers > 0 then
		table.insert(responseLines, string.format("❌ Failed for %d player(s): %s", 
			#failedPlayers, table.concat(failedPlayers, ", ")))
	end

	if #responseLines == 0 then
		return "❌ No players processed successfully!"
	end

	return table.concat(responseLines, "\n")
end