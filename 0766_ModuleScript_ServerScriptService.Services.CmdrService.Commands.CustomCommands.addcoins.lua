--[[
  Extracted from: ServerScriptService.Services.CmdrService.Commands.CustomCommands.addcoins
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

return {
	Name = "addcoins";
	Aliases = {"givecoins", "addmoney"};
	Description = "Adds coins to a player or group of players";
	Group = "CustomAdmin";
	Args = {
		{
			Type = "players";
			Name = "players";
			Description = "The players to give coins to";
		},
		{
			Type = "integer";
			Name = "amount";
			Description = "The amount of coins to add (must be positive)";
		}
	};
	
	
} 