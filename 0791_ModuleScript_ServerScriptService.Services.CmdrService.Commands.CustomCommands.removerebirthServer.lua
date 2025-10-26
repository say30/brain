--[[
  Extracted from: ServerScriptService.Services.CmdrService.Commands.CustomCommands.removerebirthServer
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DataManagement = require(ServerScriptService.Services.DataManagment)
local Synchronizer = require(ReplicatedStorage.Packages.Synchronizer)

return function(context, players, amount)
	if amount <= 0 then
		return "❌ Amount must be greater than 0!"
	end

	if amount > 1000000000 then
		return "❌ Amount too large! Maximum is 1,000,000,000 coins."
	end

	local successCount = 0
	local failedPlayers = {}

	for _, player in pairs(players) do
		if not DataManagement.isDataReady(player) then
			table.insert(failedPlayers, player.Name .. " (data not ready)")
			continue
		end

		local currentCoins = DataManagement.GetRebirths(player)

		if currentCoins < amount then
			table.insert(failedPlayers, player.Name .. string.format(" (insufficient coins: %d)", currentCoins))
			continue
		end

		DataManagement.deductRebirths(player, amount)

		task.wait(0.1)

		local newCoins = DataManagement.GetRebirths(player)

		if newCoins < currentCoins then
			local playerSync = Synchronizer:Get(player)
			if playerSync then
				playerSync:Set("Rebirths", newCoins)
			end

			successCount = successCount + 1
		else
			table.insert(failedPlayers, player.Name .. string.format(" (coins unchanged: %d)", currentCoins))
		end
	end

	local response = ""

	if successCount > 0 then
		response = string.format("✅ Successfully removed %d coins from %d player%s", 
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