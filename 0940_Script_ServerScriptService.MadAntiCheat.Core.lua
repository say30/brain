--[[
  Extracted from: ServerScriptService.MadAntiCheat.Core
  Class: Script
  Source file: rickdev.rbxlx
]]

-- Madonox
-- 2022

local library = {}
for _,v in ipairs(script.Parent.Library:GetChildren()) do
	library[v.Name] = require(v)
end

local validation = library.LoadModule(8472471824)
if library.Validation.loaderBuild == validation.loaderBuild then
	local main = library.LoadModule(8472470237)
	local success,err = pcall(function()
		main.start(script.Parent.Configuration)
	end)
	if not success then
		warn("---------------")
		warn("MadAntiCheat ERROR:")
		warn("The main anti-cheat module failed to start!  Please report this error to the owner!")
		warn("Error: "..err)
		warn("---------------")
	end
else
	warn("---------------")
	warn("MadAntiCheat CRITICAL ERROR:")
	warn("Cannot load anti-cheat, this loader is out of date!")
	warn("---------------")
end