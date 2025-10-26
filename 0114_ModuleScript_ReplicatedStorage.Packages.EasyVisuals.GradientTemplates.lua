--[[
  Extracted from: ReplicatedStorage.Packages.EasyVisuals.GradientTemplates
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: GradientTemplates, time of decompilation: Sat Jun 28 18:35:20 2025 ]]
local l_script_Descendants_0 = script:GetDescendants();
local v1 = {};
for _, v3 in l_script_Descendants_0 do
    if v3:IsA("ModuleScript") then
        v1[v3.Name] = require(v3)();
    end;
end;
return v1;