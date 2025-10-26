--[[
  Extracted from: ReplicatedStorage.Packages.Conch.roblox_packages..pesde.alicesaidhi+conch_ui.0.2.5-rc.1.conch_ui.src.components.gap
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local vide = require "../../roblox_packages/vide"

local create = vide.create
local read = vide.read

type Can<T> = T | () -> T
type Gap = {
	read width: Can<number>?,
	read height: Can<number>?,

	[number]: unknown,
}

return function(props: Gap)
	return create "Frame" {
		Name = "gap",
		Size = function()
			return UDim2.fromOffset(
				read(props.width) or 0,
				read(props.height) or 0
			)
		end,

		BackgroundTransparency = 1,

		unpack(props),
	}
end
