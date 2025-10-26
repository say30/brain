--[[
  Extracted from: ServerScriptService.Cmdr.BuiltInCommands.Debug.fetch
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

return {
	Name = "fetch";
	Aliases = {};
	Description = "Fetch a value from the Internet";
	Group = "DefaultDebug";
	Args = {
		{
			Type = "url";
			Name = "URL";
			Description = "The URL to fetch.";
		}
	};
}