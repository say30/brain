--[[
  Extracted from: ServerScriptService.Services.CmdrService.Commands.CustomCommands.respawnServer
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

return function(_, players)
	for _, player in pairs(players) do
		if player.Character then
			player:LoadCharacter()
		end
	end
	return ("Respawned %d players."):format(#players)
end
