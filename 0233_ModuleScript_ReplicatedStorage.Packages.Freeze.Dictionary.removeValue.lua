--[[
  Extracted from: ReplicatedStorage.Packages.Freeze.Dictionary.removeValue
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: removeValue, time of decompilation: Sat Jun 28 18:35:38 2025 ]]
local v0 = require(script.Parent.Parent.utils.maybeFreeze);
return function(v1, v2) --[[ Line: 14 ]] --[[ Name: removeValue ]]
    -- upvalues: v0 (copy)
    local v3 = {};
    local v4 = false;
    for v5, v6 in v1 do
        if v6 == v2 then
            v4 = true;
        else
            v3[v5] = v6;
        end;
    end;
    if v4 then
        return (v0(v3));
    else
        return v1;
    end;
end;