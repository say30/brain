--[[
  Extracted from: ServerScriptService.Cmdr.BuiltInCommands.Utility.len
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

return {
	Name = "len";
	Aliases = {};
	Description = "Returns the length of a comma-separated list";
	Group = "DefaultUtil";
	Args = {
		{
			Type = "string";
			Name = "CSV";
			Description = "The comma-separated list"
		}
	};

	Run = function(_, list)
		return #(list:split(","))
	end
}