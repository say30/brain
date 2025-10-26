--[[
  Extracted from: ReplicatedStorage.Packages.Conch.roblox_packages..pesde.alicesaidhi+conch_ui.0.2.5-rc.1.conch_ui.src.components.stroke
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local theme = require "../theme"
local vide = require "../../roblox_packages/vide"

local create = vide.create

type Can<T> = T | () -> T
type Stroke = {
	read thickness: Can<number>,

	[number]: unknown,
}

return function(props: Stroke)
	return create "UIStroke" {
		Thickness = props.thickness,
		Color = theme.stroke,

		unpack(props),
	}
end
