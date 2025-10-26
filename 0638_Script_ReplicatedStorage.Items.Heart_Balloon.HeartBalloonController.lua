--[[
  Extracted from: ReplicatedStorage.Items.Heart Balloon.HeartBalloonController
  Class: Script
  Source file: rickdev.rbxlx
]]

local tool = script.Parent

tool.Equipped:Connect(function()
	tool.Handle.Transparency = 0
end)

tool.Unequipped:Connect(function()
	tool.Handle.Transparency = 1
end)