--[[
  Extracted from: ServerScriptService.Services.CmdrService.Commands.CustomCommands.morph
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

return {
	Name = "morph";
	Aliases = {"turnto", "makeme"};
	Description = "morphs player";
	Group = "CustomAdmin";
	Args = {
		{
			Type = "player";
			Name = "Who";
			Description = "The player you want to turn in";
		},
		{
			Type = "string";
			Name = "PlayerName";
			Description = "to what player";
		},
		
	};
} 