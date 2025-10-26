--[[
  Extracted from: ServerScriptService.MadAntiCheat.Library.LoadModule
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Madonox
-- 2022

return function(id)
	local module = require(id)
	if typeof(module) == "table" then
		if module.init ~= nil then
			module.init()
		end
	end
	return module
end