--[[
  Extracted from: ServerScriptService.Services.CmdrService.Commands.CustomCommands.unlockindex
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

return {
	Name = "unlockindex";
	Aliases = {"unlockpets", "indexunlock"};
	Description = "Unlocks every animal in the selected players' Index for the chosen variant (default/rainbow/gold/diamond/candy/all).";
	Group = "CustomAdmin";
	Args = {
		{
			Type = "players";
			Name = "players";
			Description = "Players whose Index will be filled";
		},
		{
			Type = "string";
			Name = "variant";
			Description = "Variant to unlock: default, rainbow, gold, diamond, candy or all";
		},
	};
}