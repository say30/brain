--[[
  Extracted from: ReplicatedStorage.Packages.EasyVisuals.Presets.Rainbow
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: Rainbow, time of decompilation: Sat Jun 28 18:35:18 2025 ]]
local v0 = require(script.Parent.Parent);
return function(v1, v2) --[[ Line: 3 ]]
    -- upvalues: v0 (copy)
    local v3 = v0.Gradient.new(v1, v0.Templates.Rainbow.Color, 0);
    v3:SetOffsetSpeed(v2, 1);
    return {
        Effects = {
            v3
        }
    };
end;