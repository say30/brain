--[[
  Extracted from: ReplicatedStorage.Utils.NumberUtils
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: NumberUtils, time of decompilation: Sat Jun 28 18:34:28 2025 ]]
local v0 = {
    "", 
    "K", 
    "M", 
    "B", 
    "T", 
    "Qa", 
    "Qi", 
    "Sx", 
    "Sp", 
    "Oc", 
    "No", 
    "Dc", 
    "Ud", 
    "Dd", 
    "Td", 
    "Qad", 
    "Qid", 
    "Sxd", 
    "Spd", 
    "Ocd", 
    "Nod", 
    "Vg", 
    "Uvg", 
    "Dvg", 
    "Tvg"
};
return {
    ToString = function(_, v2, v3) --[[ Line: 35 ]] --[[ Name: ToString ]]
        -- upvalues: v0 (copy)
        v3 = v3 or 1;
        local v4 = math.floor((math.log(math.max(1, (math.abs(v2))), 1000)));
        local v5 = v0[v4 + 1] or "e+" .. v4;
        local v6 = math.floor(v2 * (10 ^ v3 / 1000 ^ v4)) / 10 ^ v3;
        return ("%." .. v3 .. "f"):format(v6):gsub("%.?0+$", "") .. v5;
    end, 
    Comma = function(_, v8) --[[ Line: 43 ]] --[[ Name: Comma ]]
        local v9 = tostring(v8);
        while v9:match("^(-?%d+)(%d%d%d)") do
            v9 = v9:gsub("^(-?%d+)(%d%d%d)", "%1,%2");
        end;
        return v9;
    end
};