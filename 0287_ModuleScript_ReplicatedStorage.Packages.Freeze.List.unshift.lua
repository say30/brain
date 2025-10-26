--[[
  Extracted from: ReplicatedStorage.Packages.Freeze.List.unshift
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: unshift, time of decompilation: Sat Jun 28 18:35:45 2025 ]]
local v0 = require(script.Parent.Parent.utils.maybeFreeze);
return function(v1, ...) --[[ Line: 14 ]] --[[ Name: unshift ]]
    -- upvalues: v0 (copy)
    local v2 = select("#", ...);
    local v3 = table.clone(v1);
    for v4 = v2, 1, -1 do
        table.insert(v3, 1, (select(v4, ...)));
    end;
    return v0(v3);
end;