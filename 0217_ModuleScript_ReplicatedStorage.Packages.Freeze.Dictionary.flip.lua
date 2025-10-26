--[[
  Extracted from: ReplicatedStorage.Packages.Freeze.Dictionary.flip
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: flip, time of decompilation: Sat Jun 28 18:35:36 2025 ]]
local v0 = require(script.Parent.Parent.utils.maybeFreeze);
return function(v1) --[[ Line: 14 ]] --[[ Name: flip ]]
    -- upvalues: v0 (copy)
    local v2 = {};
    for v3, v4 in v1 do
        v2[v4] = v3;
    end;
    return v0(v2);
end;