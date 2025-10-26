--[[
  Extracted from: ServerScriptService.Cmdr.BuiltInCommands.Debug.version
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local version = "v1.12.0"

return {
	Name = "version",
	Args = {},
	Description = "Shows the current version of Cmdr",
	Group = "DefaultDebug",

	Run = function()
		return ("Cmdr Version %s"):format(version)
	end,
}
