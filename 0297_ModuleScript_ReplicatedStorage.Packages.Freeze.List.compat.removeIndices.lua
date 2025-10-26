--[[
  Extracted from: ReplicatedStorage.Packages.Freeze.List.compat.removeIndices
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: removeIndices, time of decompilation: Sat Jun 28 18:35:47 2025 ]]
local l_remove_0 = require(script.Parent.Parent:FindFirstChild("remove"));
local v1 = require(script.Parent.Parent.Parent.utils.deprecationWarning);
return function(v2, ...) --[[ Line: 10 ]] --[[ Name: removeIndices ]]
    -- upvalues: v1 (copy), l_remove_0 (copy)
    v1("List." .. script.Name, "List.remove");
    return l_remove_0(v2, ...);
end;