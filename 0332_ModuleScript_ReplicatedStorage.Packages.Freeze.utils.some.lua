--[[
  Extracted from: ReplicatedStorage.Packages.Freeze.utils.some
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: some, time of decompilation: Sat Jun 28 18:35:52 2025 ]]
return function(v0, v1) --[[ Line: 3 ]]
    for v2, v3 in v0 do
        if v1(v3, v2) == true then
            return true;
        end;
    end;
    return false;
end;