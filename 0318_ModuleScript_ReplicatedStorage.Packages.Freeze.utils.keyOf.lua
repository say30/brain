--[[
  Extracted from: ReplicatedStorage.Packages.Freeze.utils.keyOf
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: keyOf, time of decompilation: Sat Jun 28 18:35:50 2025 ]]
local v0 = require(script.Parent.findKey);
local v1 = require(script.Parent.is);
return function(v2, v3) --[[ Line: 4 ]]
    -- upvalues: v0 (copy), v1 (copy)
    return v0(v2, function(v4) --[[ Line: 5 ]]
        -- upvalues: v1 (ref), v3 (copy)
        return v1(v4, v3);
    end);
end;