--[[
  Extracted from: ReplicatedStorage.Packages.Freeze.List.compat.join
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: join, time of decompilation: Sat Jun 28 18:35:46 2025 ]]
local v0 = require(script.Parent.Parent.merge);
local v1 = require(script.Parent.Parent.Parent.utils.deprecationWarning);
return function(...) --[[ Line: 10 ]] --[[ Name: join ]]
    -- upvalues: v1 (copy), v0 (copy)
    v1("List." .. script.Name, "List.merge");
    return v0(...);
end;