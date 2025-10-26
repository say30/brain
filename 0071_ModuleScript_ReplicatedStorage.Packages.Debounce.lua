--[[
  Extracted from: ReplicatedStorage.Packages.Debounce
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: Debounce, time of decompilation: Sat Jun 28 18:35:14 2025 ]]
local _ = game:GetService("ReplicatedStorage");
local v1 = require(script.Parent.Timer).new(0.05);
local v2 = {};
v1.Tick:Connect(function() --[[ Line: 13 ]]
    -- upvalues: v2 (copy)
    local v3 = os.clock();
    for v4, v5 in v2 do
        if v5 <= v3 then
            v2[v4] = nil;
        end;
    end;
end);
v1:Start();
return function(v6, v7) --[[ Line: 26 ]]
    -- upvalues: v2 (copy)
    if v2[v6] then
        return true;
    else
        v2[v6] = os.clock() + v7;
        return;
    end;
end;