--[[
  Extracted from: ReplicatedStorage.Packages.Freeze.List.filterNot
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: filterNot, time of decompilation: Sat Jun 28 18:35:35 2025 ]]
local v0 = require(script.Parent.filter);
return function(v1, v2) --[[ Line: 17 ]] --[[ Name: filterNot ]]
    -- upvalues: v0 (copy)
    return v0(v1, function(v3, v4) --[[ Line: 18 ]]
        -- upvalues: v2 (copy)
        return not v2(v3, v4);
    end);
end;