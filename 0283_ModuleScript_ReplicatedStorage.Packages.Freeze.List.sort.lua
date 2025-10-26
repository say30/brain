--[[
  Extracted from: ReplicatedStorage.Packages.Freeze.List.sort
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: sort, time of decompilation: Sat Jun 28 18:35:45 2025 ]]
local v0 = require(script.Parent.Parent.utils.maybeFreeze);
return function(v1, v2) --[[ Line: 16 ]] --[[ Name: sort ]]
    -- upvalues: v0 (copy)
    local v3 = table.clone(v1);
    table.sort(v3, v2);
    return v0(v3);
end;