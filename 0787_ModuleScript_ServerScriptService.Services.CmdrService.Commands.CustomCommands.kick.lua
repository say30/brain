--[[
  Extracted from: ServerScriptService.Services.CmdrService.Commands.CustomCommands.kick
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

return {
	Name = "kick";
	Aliases = {"boot"};
	Description = "Kicks a player or set of players.";
	Group = "CustomAdmin";
	Args = {
		{
			Type = "players";
			Name = "players";
			Description = "The players to kick.";
		},
	};
}