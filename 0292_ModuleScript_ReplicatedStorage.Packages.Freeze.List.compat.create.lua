--[[
  Extracted from: ReplicatedStorage.Packages.Freeze.List.compat.create
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: create, time of decompilation: Sat Jun 28 18:35:46 2025 ]]
local v0 = require(script.Parent.Parent.Parent.utils.deprecationWarning);
return function(v1, v2) --[[ Line: 9 ]] --[[ Name: create ]]
    -- upvalues: v0 (copy)
    v0("List." .. script.Name, "table.create");
    return table.create(v1, v2);
end;