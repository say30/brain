--[[
  Extracted from: ReplicatedStorage.Items.Coil Combo.ComboController
  Class: Script
  Source file: rickdev.rbxlx
]]

script.Parent:SetAttribute("SpeedModifier", 1.5)
script.Parent:SetAttribute("JumpModifier", 1.5)
script.Parent.ComboScript.Enabled = true

script.Parent.Equipped:Connect(function()
	script.Parent.Handle.CoilSound:Play()
	script.Parent.Handle.CoilSound2:Play()
end)