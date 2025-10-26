--[[
  Extracted from: ReplicatedStorage.Packages.Freeze.Dictionary.remove
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: remove, time of decompilation: Sat Jun 28 18:35:38 2025 ]]
local v0 = require(script.Parent.Parent.utils.set);
local v1 = require(script.Parent.Parent.utils.maybeFreeze);
return function(v2, ...) --[[ Line: 18 ]] --[[ Name: remove ]]
    -- upvalues: v0 (copy), v1 (copy)
    local v3 = table.clone(v2);
    for _, v5 in {
        ...
    } do
        v3 = v0(v3, v5, nil);
    end;
    return v1(v3);
end;