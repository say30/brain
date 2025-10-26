--[[
  Extracted from: ReplicatedStorage.Items.Coil Combo.ComboScript
  Class: LocalScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local l_Parent_0 = script.Parent;
l_Parent_0.Equipped:Connect(function() --[[ Line: 4 ]]
    workspace.Gravity = 29.429999999999996;
end);
l_Parent_0.Unequipped:Connect(function() --[[ Line: 11 ]]
    workspace.Gravity = 196.2;
end);