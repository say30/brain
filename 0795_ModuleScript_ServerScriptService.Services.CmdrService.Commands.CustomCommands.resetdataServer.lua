--[[
  Extracted from: ServerScriptService.Services.CmdrService.Commands.CustomCommands.resetdataServer
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local DataManagement = require(game.ServerScriptService.Services.DataManagment)

return function(context, players)
	local processed = {}
	for _, player in ipairs(players) do
		if not player or not player.Parent then
			table.insert(processed, "❌ " .. (player and player.Name or "<unknown>") .. " not in server")
			continue
		end

		local success, lastError = DataManagement.resetPlayerData(player)

		if success then
			table.insert(processed, "✅ " .. player.Name)
		else
			table.insert(processed, string.format("❌ %s (%s)", player.Name, tostring(lastError)))
		end
	end

	return table.concat(processed, "\n")
end