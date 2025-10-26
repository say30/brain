--[[
  Extracted from: ReplicatedStorage.Packages.Freeze.List.compat.findWhere
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: findWhere, time of decompilation: Sat Jun 28 18:35:46 2025 ]]
local v0 = require(script.Parent.Parent.find);
local v1 = require(script.Parent.Parent.Parent.utils.deprecationWarning);
return function(v2, v3, v4) --[[ Line: 10 ]] --[[ Name: findWhere ]]
    -- upvalues: v1 (copy), v0 (copy)
    assert(v4 == nil, "[Freeze] findWhere's `from` argument is not supported.");
    v1("List." .. script.Name, "List.find");
    return v0(v2, v3);
end;