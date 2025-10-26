--[[
  Extracted from: ReplicatedStorage.Packages.Freeze.utils.setIn
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: setIn, time of decompilation: Sat Jun 28 18:35:51 2025 ]]
local v0 = require(script.Parent.updateIn);
local v1 = require(script.Parent.Parent.None);
return function(v2, v3, v4) --[[ Line: 4 ]]
    -- upvalues: v0 (copy), v1 (copy)
    return v0(v2, v3, function() --[[ Line: 5 ]]
        -- upvalues: v4 (copy)
        return v4;
    end, v1);
end;