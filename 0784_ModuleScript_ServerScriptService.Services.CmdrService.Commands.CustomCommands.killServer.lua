--[[
  Extracted from: ServerScriptService.Services.CmdrService.Commands.CustomCommands.killServer
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

return function (_, players)
	for _, player in pairs(players) do
		if player.Character then
			player.Character:BreakJoints()
		end
	end

	return ("Killed %d players."):format(#players)
end