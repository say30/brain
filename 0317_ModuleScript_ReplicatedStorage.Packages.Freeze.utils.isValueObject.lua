--[[
  Extracted from: ReplicatedStorage.Packages.Freeze.utils.isValueObject
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: isValueObject, time of decompilation: Sat Jun 28 18:35:49 2025 ]]
return function(v0) --[[ Line: 2 ]]
    if v0 and typeof(v0) == "table" and typeof(v0.equals) == "function" then
        return true;
    else
        return false;
    end;
end;