--[[
  Extracted from: ReplicatedStorage.Packages.Freeze.List.merge
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: merge, time of decompilation: Sat Jun 28 18:35:43 2025 ]]
local v0 = require(script.Parent.Parent.utils.merge);
local v1 = require(script.Parent.Parent.utils.maybeFreeze);
return function(...) --[[ Line: 21 ]] --[[ Name: merge ]]
    -- upvalues: v1 (copy), v0 (copy)
    return v1(v0(...));
end;