--[[
  Extracted from: ReplicatedStorage.Packages.Freeze.Dictionary.merge
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: merge, time of decompilation: Sat Jun 28 18:35:38 2025 ]]
local v0 = require(script.Parent.Parent.utils.merge);
local v1 = require(script.Parent.Parent.utils.maybeFreeze);
return function(...) --[[ Line: 20 ]] --[[ Name: merge ]]
    -- upvalues: v1 (copy), v0 (copy)
    return v1(v0(...));
end;