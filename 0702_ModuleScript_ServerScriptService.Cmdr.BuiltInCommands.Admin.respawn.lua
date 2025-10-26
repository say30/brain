--[[
  Extracted from: ServerScriptService.Cmdr.BuiltInCommands.Admin.respawn
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]



return {
	Name = "respawn";
	Description = "Respawns a player or a group of players.";
	Group = "CustomAdmin";
	AutoExec = {
		"alias \"refresh|Respawns the player and returns them to their previous location.\" var= .refresh_pos ${position $1{player|Player}} && respawn $1 && tp $1 @${{var .refresh_pos}}"
	},
	Args = {
		{
			Type = "stfing";
			Name = "targets";
			Description = "The players to respawn."
		}
	}
}
