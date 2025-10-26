--[[
  Extracted from: ReplicatedStorage.Packages.Freeze.Dictionary.compat.removeValues
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: removeValues, time of decompilation: Sat Jun 28 18:35:40 2025 ]]
local v0 = require(script.Parent.Parent.removeValue);
local v1 = require(script.Parent.Parent.Parent.utils.deprecationWarning);
return function(v2, ...) --[[ Line: 10 ]] --[[ Name: removeValues ]]
    -- upvalues: v1 (copy), v0 (copy)
    v1("Dictionary." .. script.Name, "Dictionary.removeValue");
    return v0(v2, ...);
end;