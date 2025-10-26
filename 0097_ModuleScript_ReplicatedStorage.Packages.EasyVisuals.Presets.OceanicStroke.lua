--[[
  Extracted from: ReplicatedStorage.Packages.EasyVisuals.Presets.OceanicStroke
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: OceanicStroke, time of decompilation: Sat Jun 28 18:35:18 2025 ]]
local v0 = require(script.Parent.Parent);
return function(v1, v2, v3) --[[ Line: 3 ]]
    -- upvalues: v0 (copy)
    local v4 = v0.Gradient.new(v1, v0.Templates.Oceanic.Color, 0);
    v4:SetOffsetSpeed(v2, 1);
    v4:SetRotation(-75, 1);
    v4:SetRotationSpeed(0.1, 1);
    local v5 = v0.Stroke.new(v1, v3);
    local v6 = v0.Gradient.new(v5.Instance, v0.Templates.Oceanic.Color, 0);
    v6:SetOffsetSpeed(-v2, 1);
    return {
        Effects = {
            v4, 
            v6, 
            v5
        }
    };
end;