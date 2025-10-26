--[[
  Extracted from: ServerScriptService.Cmdr.BuiltInCommands.Debug.fetchServer
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local HttpService = game:GetService("HttpService")

return function (_, url)
	return HttpService:GetAsync(url)
end