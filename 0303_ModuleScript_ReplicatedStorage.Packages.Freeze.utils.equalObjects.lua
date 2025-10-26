--[[
  Extracted from: ReplicatedStorage.Packages.Freeze.utils.equalObjects
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: equalObjects, time of decompilation: Sat Jun 28 18:35:47 2025 ]]
return function(...) --[[ Line: 2 ]] --[[ Name: equalObjects ]]
    local v0 = select(1, ...);
    for v1 = 2, select("#", ...) do
        if v0 ~= select(v1, ...) then
            return false;
        end;
    end;
    return true;
end;