--[[
  Extracted from: ReplicatedStorage.Packages.Freeze.List.get
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: get, time of decompilation: Sat Jun 28 18:35:42 2025 ]]
return function(v0, v1, v2) --[[ Line: 21 ]] --[[ Name: get ]]
    if type(v1) == "number" and v1 < 0 then
        v1 = #v0 + (v1 + 1);
    end;
    return v0[v1] or v2;
end;