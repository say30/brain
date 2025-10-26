--[[
  Extracted from: ServerScriptService.Services.CmdrService.Commands.CustomCommands.addbrainrotServer
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DataManagement = require(ServerScriptService.Services.DataManagment)
local Animals = require(ReplicatedStorage.Datas.Animals)
local Mutations = require(ReplicatedStorage.Datas.Mutations)

local function getAllAnimals()
	local animalList = {}
	for animalName, _ in pairs(Animals) do
		table.insert(animalList, animalName)
	end
	return animalList
end

return function(context, players, animalName, mutation)
	local selectedAnimal = animalName
	if selectedAnimal then
		local animalData = Animals[selectedAnimal]
		if not animalData then
			return string.format("❌ Animal '%s' not found!", selectedAnimal)
		end
	else
		local allAnimals = getAllAnimals()
		selectedAnimal = allAnimals[math.random(1, #allAnimals)]
	end

	if mutation and not Mutations[mutation] then
		return string.format("❌ Mutation '%s' not found!", mutation)
	end

	local successCount = 0
	local failedPlayers = {}
	local results = {}

	for _, player in pairs(players) do
		if not DataManagement.isDataReady(player) then
			table.insert(failedPlayers, player.Name .. " (data not ready)")
			continue
		end

		local maxAnimals = DataManagement.GetMaxAnimals(player)
		local currentAnimals = DataManagement.getAnimalList(player)
		local emptySlots = 0

		for i = 1, maxAnimals do
			if currentAnimals[i] == "Empty" or currentAnimals[i] == nil then
				emptySlots = emptySlots + 1
			end
		end

		if emptySlots == 0 then
			table.insert(failedPlayers, player.Name .. " (no empty slots)")
			continue
		end

		local success, slotNumber = pcall(function()
			return DataManagement.addAnimal(player, selectedAnimal, mutation)
		end)

		if success and slotNumber then
			successCount = successCount + 1
			table.insert(results, {
				player = player,
				animal = selectedAnimal,
				mutation = mutation,
				slot = slotNumber
			})

			DataManagement.addToIndex(player, selectedAnimal, mutation)
		else
			table.insert(failedPlayers, player.Name .. " (operation failed)")
		end
	end

	local responseLines = {}

	if successCount > 0 then
		local animalData = Animals[selectedAnimal]
		local mutationText = mutation and (" with " .. (Mutations[mutation].DisplayText or mutation) .. " mutation") or ""

		table.insert(responseLines, string.format("✅ Successfully added %s%s to %d player(s):", 
			animalData.DisplayName, mutationText, successCount))

		for _, result in ipairs(results) do
			table.insert(responseLines, string.format("  • %s (slot %d)", 
				result.player.Name, result.slot))
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