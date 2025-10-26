--[[
  Extracted from: ReplicatedStorage.Packages.Freeze.utils.reduce
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: reduce, time of decompilation: Sat Jun 28 18:35:51 2025 ]]
return function(v0, v1, v2, v3) --[[ Line: 3 ]] --[[ Name: reduce ]]
    local v4 = #v0 + 1;
    for v5, v6 in v0 do
        if v3 then
            v6 = v0[v4 - v5];
        end;
        v2 = v1(v2, v6, v5);
    end;
    return v2;
end;