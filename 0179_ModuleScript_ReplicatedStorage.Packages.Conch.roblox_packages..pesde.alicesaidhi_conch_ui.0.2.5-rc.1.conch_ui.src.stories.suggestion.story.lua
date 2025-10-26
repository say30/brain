--[[
  Extracted from: ReplicatedStorage.Packages.Conch.roblox_packages..pesde.alicesaidhi+conch_ui.0.2.5-rc.1.conch_ui.src.stories.suggestion.story
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local conch = require "../../roblox_packages/conch"
local vide = require "../../roblox_packages/vide"

local state = require "../state"
local suggestion = require "../components/suggestion"

local source = vide.source

return function(target)
	state.opened(true)
	conch._.create_local_user()
	return vide.mount(
		function()
			return suggestion {

				highlighted_suggestion = source {
					name = "highlight",
					description = "this argument onmly takes like a vector or something and does this and that i honestly dont care.",
					type = "meow",
				},
				suggestions = source { "test", "value", "grapes", "apples" },
			}
		end,
		target
	)
end
