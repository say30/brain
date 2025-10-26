--[[
  Extracted from: ReplicatedStorage.Packages.Freeze.Dictionary.find
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: find, time of decompilation: Sat Jun 28 18:35:35 2025 ]]
local v0 = require(script.Parent.Parent.utils.findPair);
return function(v1, v2, v3) --[[ Line: 16 ]] --[[ Name: find ]]
    -- upvalues: v0 (copy)
    local _, v5 = v0(v1, v2);
    if v5 == nil then
        return v3;
    else
        return v5;
    end;
end;