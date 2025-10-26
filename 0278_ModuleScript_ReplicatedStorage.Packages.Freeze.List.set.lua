--[[
  Extracted from: ReplicatedStorage.Packages.Freeze.List.set
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: set, time of decompilation: Sat Jun 28 18:35:44 2025 ]]
local v0 = require(script.Parent.Parent.utils.maybeFreeze);
return function(v1, v2, v3) --[[ Line: 17 ]] --[[ Name: set ]]
    -- upvalues: v0 (copy)
    if v1[v2] == v3 then
        return v1;
    else
        local v4 = table.clone(v1);
        v4[v2] = v3;
        return v0(v4);
    end;
end;