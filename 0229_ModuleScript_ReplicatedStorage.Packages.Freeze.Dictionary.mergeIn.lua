--[[
  Extracted from: ReplicatedStorage.Packages.Freeze.Dictionary.mergeIn
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: mergeIn, time of decompilation: Sat Jun 28 18:35:38 2025 ]]
local v0 = require(script.Parent.Parent.utils.mergeIn);
local v1 = require(script.Parent.Parent.utils.maybeFreeze);
return function(v2, v3, ...) --[[ Line: 25 ]] --[[ Name: mergeIn ]]
    -- upvalues: v1 (copy), v0 (copy)
    return v1(v0(v2, v3, ...));
end;