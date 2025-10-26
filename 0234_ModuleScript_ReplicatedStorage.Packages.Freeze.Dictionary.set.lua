--[[
  Extracted from: ReplicatedStorage.Packages.Freeze.Dictionary.set
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: set, time of decompilation: Sat Jun 28 18:35:38 2025 ]]
local v0 = require(script.Parent.Parent.utils.set);
local v1 = require(script.Parent.Parent.utils.maybeFreeze);
return function(v2, v3, v4) --[[ Line: 16 ]] --[[ Name: set ]]
    -- upvalues: v1 (copy), v0 (copy)
    if v3 == nil then
        return v2;
    else
        return v1(v0(v2, v3, v4));
    end;
end;