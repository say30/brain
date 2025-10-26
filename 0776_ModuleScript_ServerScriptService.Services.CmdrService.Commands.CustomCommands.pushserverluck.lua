--[[
  Extracted from: ServerScriptService.Services.CmdrService.Commands.CustomCommands.pushserverluck
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

return {
	Name = "ServerLuck";
	Aliases = {"s"};
	Description = "Add a Server Luck to all or only the server ur in";
	Group = "CustomAdmin";
	Args = {
		{
			Type = "number";
			Name = "Multi";
			Description = "The Luck multiplayer";
		},
		{
			Type = "number";
			Name = "Duration";
			Description = "How long should it last.";
		},
		{
			Type = "string";
			Name = "Host";
			Description = "Global or Local";
		},
	};
}