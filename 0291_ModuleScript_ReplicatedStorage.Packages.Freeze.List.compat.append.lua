--[[
  Extracted from: ReplicatedStorage.Packages.Freeze.List.compat.append
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: append, time of decompilation: Sat Jun 28 18:35:46 2025 ]]
local v0 = require(script.Parent.Parent.push);
local v1 = require(script.Parent.Parent.Parent.utils.deprecationWarning);
return function(v2, ...) --[[ Line: 10 ]] --[[ Name: append ]]
    -- upvalues: v1 (copy), v0 (copy)
    v1("List." .. script.Name, "List.push");
    return v0(v2, ...);
end;