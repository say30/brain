--[[
  Extracted from: ReplicatedStorage.Packages.Freeze.List.reverse
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: reverse, time of decompilation: Sat Jun 28 18:35:44 2025 ]]
local v0 = require(script.Parent.Parent.utils.maybeFreeze);
return function(v1) --[[ Line: 14 ]] --[[ Name: reverse ]]
    -- upvalues: v0 (copy)
    local v2 = #v1;
    local v3 = table.create(v2);
    local v4 = v2 + 1;
    for v5, _ in v1 do
        v3[v5] = v1[v4 - v5];
    end;
    return v0(v3);
end;