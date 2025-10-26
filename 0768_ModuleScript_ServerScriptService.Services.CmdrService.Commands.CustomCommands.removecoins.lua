--[[
  Extracted from: ServerScriptService.Services.CmdrService.Commands.CustomCommands.removecoins
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

return {
	Name = "removecoins";
	Aliases = {"takecoins", "removemoney"};
	Description = "Removes coins from a player or players";
	Group = "CustomAdmin";
	Args = {
		{
			Type = "players";
			Name = "Players";
			Description = "The players to remove coins from";
		},
		{
			Type = "positiveInteger";
			Name = "Amount";
			Description = "The amount of coins to remove";
		}
	};
} 