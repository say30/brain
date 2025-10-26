--[[
  Extracted from: ServerScriptService.Cmdr.BuiltInCommands.Utility.echo
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

return {
	Name = "echo";
	Aliases = {"="};
	Description = "Echoes your text back to you.";
	Group = "DefaultUtil";
	Args = {
		{
			Type = "string";
			Name = "Text";
			Description = "The text."
		},
	};

	Run = function(_, text)
		return text
	end
}