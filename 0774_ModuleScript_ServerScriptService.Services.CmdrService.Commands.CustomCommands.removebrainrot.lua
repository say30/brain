--[[
  Extracted from: ServerScriptService.Services.CmdrService.Commands.CustomCommands.removebrainrot
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

return {
	Name = "removebrainrot";
	Aliases = {"deletebrainrot", "takebrainrot"};
	Description = "Removes an animal from a player's slot";
	Group = "CustomAdmin";
	Args = {
		{
			Type = "players";
			Name = "players";
			Description = "The players to remove the animal from";
		},
		{
			Type = "nonEmptySlot";
			Name = "slot";
			Description = "The slot number to remove the animal from";
		};
	};
}