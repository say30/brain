--[[
  Extracted from: ReplicatedStorage.Packages.Symbol
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: Symbol, time of decompilation: Sat Jun 28 18:35:12 2025 ]]
return function(v0) --[[ Line: 45 ]] --[[ Name: Symbol ]]
    local v1 = newproxy(true);
    if not v0 then
        v0 = "";
    end;
    getmetatable(v1).__tostring = function() --[[ Line: 50 ]]
        -- upvalues: v0 (ref)
        return "Symbol(" .. v0 .. ")";
    end;
    return v1;
end;