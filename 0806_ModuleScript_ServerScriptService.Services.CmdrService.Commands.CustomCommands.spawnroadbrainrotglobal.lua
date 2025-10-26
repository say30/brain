--[[
  Extracted from: ServerScriptService.Services.CmdrService.Commands.CustomCommands.spawnroadbrainrotglobal
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

return {
	Name = "spawnroadbrainrotglobal";
	Aliases = {"spawnroadglobal", "roadglobal"};
	Description = "Spawns a road animal globally across all servers with optional mutation and traits";
	Group = "CustomAdmin";
	Args = {
		{
			Type = "animalName";
			Name = "animalName";
			Description = "The name of the animal to spawn";
		};
		{
			Type = "mutationName";
			Name = "mutation";
			Description = "Optional mutation for the animal";
			Optional = true;
		};
		{
			Type = "string";
			Name = "traits";
			Description = "Optional traits as JSON array (e.g., '[\"Taco\", \"Fireworks\"]')"; 
			Optional = true;
		};
	};
}