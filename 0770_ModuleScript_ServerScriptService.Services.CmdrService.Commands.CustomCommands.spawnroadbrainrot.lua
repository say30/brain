--[[
  Extracted from: ServerScriptService.Services.CmdrService.Commands.CustomCommands.spawnroadbrainrot
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

return {
	Name = "spawnroadbrainrot";
	Aliases = {"spawnroad", "roadspawn"};
	Description = "Spawns a specific animal on the road with optional mutation";
	Group = "CustomAdmin";
	Args = {
		{
			Type = "animalName";
			Name = "Animal";
			Description = "The animal to spawn on the road";
		},
		{
			Type = "mutationName";
			Name = "Mutation";
			Description = "The mutation for the animal (optional)";
			Optional = true;
		}
	};
} 