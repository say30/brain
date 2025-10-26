--[[
  Extracted from: ReplicatedStorage.Packages.Observers.observeCharacters
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: observeCharacters, time of decompilation: Sat Jun 28 18:35:15 2025 ]]
local v0 = require(script.Parent.observePlayer);
local v1 = require(script.Parent.observeCharacter);
return function(v2) --[[ Line: 22 ]] --[[ Name: observeCharacters ]]
    -- upvalues: v0 (copy), v1 (copy)
    return v0(function(v3) --[[ Line: 23 ]]
        -- upvalues: v1 (ref), v2 (copy)
        return v1(v3, v2);
    end);
end;