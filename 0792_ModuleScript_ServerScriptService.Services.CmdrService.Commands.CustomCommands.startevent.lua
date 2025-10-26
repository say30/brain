--[[
  Extracted from: ServerScriptService.Services.CmdrService.Commands.CustomCommands.startevent
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

return {
	Name = "startevent";
	Aliases = {"startevent"};
	Description = "Start an event by name or random event";
	Group = "CustomAdmin";
	Args = {
		{
			Type = "string";
			Name = "eventName";
			Description = "Name of the event to start or 'random' to start random event";
		},
		{
			Type = "integer";
			Name = "duration";
			Description = "Duration in seconds (optional)";
			Optional = true;
		}
	};
}
