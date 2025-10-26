--[[
  Extracted from: ServerScriptService.Services.CmdrService.Commands.CustomCommands.kill
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

return {
	Name = "kill";
	Aliases = {"slay"};
	Description = "Kills a player or set of players.";
	Group = "CustomAdmin";
	Args = {
		{
			Type = "players";
			Name = "victims";
			Description = "The players to kill.";
		},
	};
}