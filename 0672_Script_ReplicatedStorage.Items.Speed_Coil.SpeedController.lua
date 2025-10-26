--[[
  Extracted from: ReplicatedStorage.Items.Speed Coil.SpeedController
  Class: Script
  Source file: rickdev.rbxlx
]]

script.Parent:SetAttribute("SpeedModifier", 1.5)

script.Parent.Equipped:Connect(function()
	script.Parent.Handle.CoilSound:Play()
end)