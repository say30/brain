--[[
  Extracted from: ReplicatedStorage.Packages.Conch.roblox_packages..pesde.alicesaidhi+conch_ui.0.2.5-rc.1.conch_ui.src.stories.app.story
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local conch = require "../../roblox_packages/conch"
local vide = require "../../roblox_packages/vide"

local app = require "../app"
local state = require "../state"

return function(target)
	state.opened(true)
	conch.register_default_commands()
	conch._.create_local_user()
	return vide.mount(function() return app() end, target)
end
