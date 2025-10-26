--[[
  Extracted from: ReplicatedStorage.Packages.Conch.lib
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local conch = require "./roblox_packages/conch"
local ui = require "./roblox_packages/ui"

return setmetatable({
	ui = ui,
}, {
	__index = conch,
})
