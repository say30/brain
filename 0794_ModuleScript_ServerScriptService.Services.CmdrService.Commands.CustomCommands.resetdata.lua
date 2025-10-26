--[[
  Extracted from: ServerScriptService.Services.CmdrService.Commands.CustomCommands.resetdata
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

return {
	Name = "resetdata";
	Aliases = {"resetplayerdata", "datareset"};
	Description = "Resets a player's saved data profile (DataStore) and kicks them so it regenerates.";
	Group = "CustomAdmin";
	Args = {
		{
			Type = "players";
			Name = "players";
			Description = "The player or players whose data will be wiped and regenerated";
		},
	};
} 