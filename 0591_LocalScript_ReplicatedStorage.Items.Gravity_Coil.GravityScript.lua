--[[
  Extracted from: ReplicatedStorage.Items.Gravity Coil.GravityScript
  Class: LocalScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: ComboScript, time of decompilation: Tue Jun 24 14:16:10 2025 ]]
local l_Parent_0 = script.Parent;
l_Parent_0.Equipped:Connect(function() --[[ Line: 4 ]]
    workspace.Gravity = 29.429999999999996;
end);
l_Parent_0.Unequipped:Connect(function() --[[ Line: 11 ]]
    workspace.Gravity = 196.2;
end);