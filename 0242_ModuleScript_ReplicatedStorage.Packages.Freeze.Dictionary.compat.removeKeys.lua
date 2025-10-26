--[[
  Extracted from: ReplicatedStorage.Packages.Freeze.Dictionary.compat.removeKeys
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: removeKeys, time of decompilation: Sat Jun 28 18:35:40 2025 ]]
local l_remove_0 = require(script.Parent.Parent:FindFirstChild("remove"));
local v1 = require(script.Parent.Parent.Parent.utils.deprecationWarning);
return function(v2, ...) --[[ Line: 10 ]] --[[ Name: removeKeys ]]
    -- upvalues: v1 (copy), l_remove_0 (copy)
    v1("Dictionary." .. script.Name, "Dictionary.remove");
    return l_remove_0(v2, ...);
end;