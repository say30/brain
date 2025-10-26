--[[
  Extracted from: ReplicatedStorage.Packages.Freeze.Dictionary.findKey
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: findKey, time of decompilation: Sat Jun 28 18:35:36 2025 ]]
local v0 = require(script.Parent.Parent.utils.findPair);
return function(v1, v2, v3) --[[ Line: 17 ]] --[[ Name: findKey ]]
    -- upvalues: v0 (copy)
    local v4, _ = v0(v1, v2);
    if v4 == nil then
        return v3;
    else
        return v4;
    end;
end;