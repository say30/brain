--[[
  Extracted from: ReplicatedStorage.Packages.Conch.roblox_packages..pesde.alicesaidhi+conch_ui.0.2.5-rc.1.conch_ui.src.components.corner
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local vide = require "../../roblox_packages/vide"

local create = vide.create

return function(px: number)
	return create "UICorner" {
		CornerRadius = UDim.new(0, px),
	}
end
