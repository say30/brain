--[[
  Extracted from: ReplicatedStorage.Packages.Conch.roblox_packages..pesde.alicesaidhi+conch_ui.0.2.5-rc.1.conch_ui.src.state
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local conch = require "../roblox_packages/conch"
local vide = require "../roblox_packages/vide"

local source = vide.source

return {
	opened = source(false),
	focused = source(false),

	logs = source({} :: { conch.Log }),
}
