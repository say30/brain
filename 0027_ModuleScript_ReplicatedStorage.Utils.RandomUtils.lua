--[[
  Extracted from: ReplicatedStorage.Utils.RandomUtils
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: RandomUtils, time of decompilation: Sat Jun 28 18:34:29 2025 ]]
return {
    RandomOnArray = function(_, v1, v2) --[[ Line: 8 ]] --[[ Name: RandomOnArray ]]
        local v3 = 1 + (v2 or 0) / 3;
        local v4 = 0;
        local v5 = {};
        for v6 = 1, #v1 do
            local v7 = v1[v6] ^ (1 / v3);
            table.insert(v5, v7);
            v4 = v4 + v7;
        end;
        local v8 = math.random() * v4;
        local v9 = 0;
        for v10 = 1, #v5 do
            v9 = v9 + v5[v10];
            if v8 <= v9 then
                return v10;
            end;
        end;
    end, 
    GetPercentage = function(_, v12, v13) --[[ Line: 35 ]] --[[ Name: GetPercentage ]]
        local v14 = 1 + (v13 or 0) / 3;
        local v15 = 0;
        local v16 = {};
        for v17 = 1, #v12 do
            local v18 = v12[v17] ^ (1 / v14);
            table.insert(v16, v18);
            v15 = v15 + v18;
        end;
        local v19 = {};
        for v20 = 1, #v16 do
            table.insert(v19, v16[v20] / v15 * 100);
        end;
        return v19;
    end
};