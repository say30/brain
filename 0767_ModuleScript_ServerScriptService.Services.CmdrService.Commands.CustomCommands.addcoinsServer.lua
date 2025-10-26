--[[
  Extracted from: ServerScriptService.Services.CmdrService.Commands.CustomCommands.addcoinsServer
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DataManagement = require(ServerScriptService.Services.DataManagment)
local Synchronizer = require(ReplicatedStorage.Packages.Synchronizer)

return function(context, players, amount)

	

	local successCount = 0
	local failedPlayers = {}

	for _, player in pairs(players) do
		if not DataManagement.isDataReady(player) then
			table.insert(failedPlayers, player.Name .. " (data not ready)")
			continue
		end

		local currentCoins = DataManagement.GetCoins(player)

		DataManagement.addCoins(player, amount)

		task.wait(0.1)

		local newCoins = DataManagement.GetCoins(player)

		if newCoins > currentCoins then
			local playerSync = Synchronizer:Get(player)
			if playerSync then
				playerSync:Set("Coins", newCoins)
			end

			successCount = successCount + 1
		else
			table.insert(failedPlayers, player.Name .. string.format(" (coins unchanged: %d)", currentCoins))
		end
	end

	local response = ""

	if successCount > 0 then
		response = string.format("✅ Successfully added %d coins to %d player%s", 
			amount, successCount, successCount == 1 and "" or "s")
	end

	if #failedPlayers > 0 then
		if response ~= "" then
			response = response .. "\n"
		end
		response = response .. "❌ Failed for: " .. table.concat(failedPlayers, ", ")
	end

	if response == "" then
		response = "❌ No players were processed"
	end

	return response
end 