--[[
  Extracted from: ServerScriptService.Services.CmdrService.Commands.CustomCommands.announce
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

return {
	Name = "announce";
	Aliases = {"m"};
	Description = "Makes a server-wide announcement.";
	Group = "CustomAdmin";
	Args = {
		{
			Type = "string";
			Name = "text";
			Description = "The announcement text.";
		},
	};
}