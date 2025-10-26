--[[
  Extracted from: ReplicatedStorage.Packages.Freeze.utils.maybeFreeze
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: maybeFreeze, time of decompilation: Sat Jun 28 18:35:50 2025 ]]
return function(v0) --[[ Line: 5 ]]
    if table.isfrozen(v0) then
        return v0;
    else
        return table.freeze(v0);
    end;
end;