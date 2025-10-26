--[[
  Extracted from: ReplicatedStorage.Packages.Freeze.utils.is
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: is, time of decompilation: Sat Jun 28 18:35:49 2025 ]]
local v0 = require(script.Parent.isValueObject);
return function(v1, v2) --[[ Line: 4 ]]
    -- upvalues: v0 (copy)
    if v1 == v2 or v1 ~= v1 and v2 ~= v2 then
        return true;
    elseif not v1 or not v2 then
        return false;
    else
        if typeof(v1) == "function" and typeof(v2) == "function" then
            v1 = v1();
            v2 = v2();
            if v1 == v2 or v1 ~= v1 and v2 ~= v2 then
                return true;
            elseif not v1 or not v2 then
                return false;
            end;
        end;
        return not not (v0(v1) and v0(v2) and v1.equals(v2));
    end;
end;