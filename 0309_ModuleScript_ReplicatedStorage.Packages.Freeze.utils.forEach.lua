--[[
  Extracted from: ReplicatedStorage.Packages.Freeze.utils.forEach
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: forEach, time of decompilation: Sat Jun 28 18:35:48 2025 ]]
return function(v0, v1) --[[ Line: 3 ]]
    local v2 = 0;
    for v3, v4 in v0 do
        v2 = v2 + 1;
        if v1(v4, v3) == false then
            break;
        end;
    end;
    return v2;
end;