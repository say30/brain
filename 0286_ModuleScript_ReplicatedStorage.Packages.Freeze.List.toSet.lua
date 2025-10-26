--[[
  Extracted from: ReplicatedStorage.Packages.Freeze.List.toSet
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: toSet, time of decompilation: Sat Jun 28 18:35:45 2025 ]]
return function(v0) --[[ Line: 10 ]]
    local v1 = {};
    for _, v3 in v0 do
        v1[v3] = true;
    end;
    return v1;
end;