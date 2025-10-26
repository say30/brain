--[[
  Extracted from: ReplicatedStorage.Packages.Freeze.utils.shallowCopy
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: shallowCopy, time of decompilation: Sat Jun 28 18:35:51 2025 ]]
local v0 = require(script.Parent.isImmutable);
return function(v1) --[[ Line: 4 ]]
    -- upvalues: v0 (copy)
    if v0(v1) then
        return v1:clone();
    else
        return table.clone(v1);
    end;
end;