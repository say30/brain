--[[
  Extracted from: Workspace.RainbowMachine.Overhead.BillboardGui.DisplayText.Rainbow
  Class: Script
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: Rainbow, time of decompilation: Tue Jun 24 14:16:05 2025 ]]
local l_ReplicatedStorage_0 = game:GetService("ReplicatedStorage");
local v1 = require(l_ReplicatedStorage_0.Packages.EasyVisuals).new(script.Parent, "Rainbow", 0.5);
script.Parent.Destroying:Once(function() --[[ Line: 6 ]]
    -- upvalues: v1 (copy)
    v1:Destroy();
end);