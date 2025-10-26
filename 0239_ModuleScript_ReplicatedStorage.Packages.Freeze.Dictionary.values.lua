--[[
  Extracted from: ReplicatedStorage.Packages.Freeze.Dictionary.values
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: values, time of decompilation: Sat Jun 28 18:35:39 2025 ]]
local v0 = require(script.Parent.Parent.utils.maybeFreeze);
return function(v1) --[[ Line: 14 ]] --[[ Name: values ]]
    -- upvalues: v0 (copy)
    local v2 = {};
    for _, v4 in v1 do
        table.insert(v2, v4);
    end;
    return v0(v2);
end;