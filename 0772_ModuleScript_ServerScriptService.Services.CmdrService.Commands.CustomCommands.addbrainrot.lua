--[[
  Extracted from: ServerScriptService.Services.CmdrService.Commands.CustomCommands.addbrainrot
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

return {
	Name = "addbrainrot";
	Aliases = {"givebrainrot", "addanimal"};
	Description = "Adds any animal to a player's plot";
	Group = "CustomAdmin";
	Args = {
		{
			Type = "players";
			Name = "Players";
			Description = "The players to give animals to";
		},
		{
			Type = "animalName";
			Name = "Animal";
			Description = "The animal to add (optional - random if not specified)";
			Optional = true;
		},
		{
			Type = "mutationName";
			Name = "Mutation";
			Description = "The mutation for the animal (optional)";
			Optional = true;
		}
	};
} 