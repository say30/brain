--[[
  Extracted from: ReplicatedStorage.Packages.Freeze.Dictionary.keys
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: keys, time of decompilation: Sat Jun 28 18:35:37 2025 ]]
local v0 = require(script.Parent.Parent.utils.maybeFreeze);
return function(v1) --[[ Line: 14 ]] --[[ Name: keys ]]
    -- upvalues: v0 (copy)
    local v2 = {};
    for v3, _ in v1 do
        table.insert(v2, v3);
    end;
    return v0(v2);
end;