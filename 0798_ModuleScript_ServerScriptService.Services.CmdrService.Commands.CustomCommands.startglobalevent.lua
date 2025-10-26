--[[
  Extracted from: ServerScriptService.Services.CmdrService.Commands.CustomCommands.startglobalevent
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

return {
	Name = "startglobalevent";
	Aliases = {"globalevent", "gevent", "startglobal"};
	Description = "Start global events that affect all servers";
	Group = "CustomAdmin";
	Args = {
		{
			Type = "string";
			Name = "action";
			Description = "Action to perform (start, stop, list, status, random)";
		},
		{
			Type = "string";
			Name = "eventName";
			Description = "Name of the global event (required for start/stop)";
			Optional = true;
		},
		{
			Type = "integer";
			Name = "duration";
			Description = "Duration in seconds (optional for start)";
			Optional = true;
		}
	};
} 