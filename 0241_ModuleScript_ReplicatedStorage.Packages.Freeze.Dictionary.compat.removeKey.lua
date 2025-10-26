--[[
  Extracted from: ReplicatedStorage.Packages.Freeze.Dictionary.compat.removeKey
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: removeKey, time of decompilation: Sat Jun 28 18:35:39 2025 ]]
local l_remove_0 = require(script.Parent.Parent:FindFirstChild("remove"));
local v1 = require(script.Parent.Parent.Parent.utils.deprecationWarning);
return function(v2, v3) --[[ Line: 10 ]] --[[ Name: removeKey ]]
    -- upvalues: v1 (copy), l_remove_0 (copy)
    v1("Dictionary." .. script.Name, "Dictionary.remove");
    return l_remove_0(v2, v3);
end;