--[[
  Extracted from: ReplicatedStorage.Items.Blackhole Slap.Handle.Color
  Class: Script
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: Color, time of decompilation: Tue Jun 24 14:16:12 2025 ]]
local l_Parent_0 = script.Parent;
local l_SurfaceAppearance_0 = l_Parent_0:FindFirstChildOfClass("SurfaceAppearance");
local l_Highlight_0 = l_Parent_0:FindFirstChildOfClass("Highlight");
local v3 = Color3.fromRGB(0, 0, 0);
local v4 = Color3.fromRGB(255, 170, 0);
local v5 = Color3.new(1, 1, 1);
(function() --[[ Line: 12 ]] --[[ Name: transicaoCores ]]
    -- upvalues: v3 (copy), v4 (copy), v5 (copy), l_SurfaceAppearance_0 (copy), l_Highlight_0 (copy)
    while true do
        for v6 = 0, 1, 0.02 do
            local v7 = v3:Lerp(v4, v6);
            local v8 = v5:Lerp(v4, v6);
            if l_SurfaceAppearance_0 then
                l_SurfaceAppearance_0.Color = v7;
            end;
            if l_Highlight_0 then
                l_Highlight_0.FillColor = v8;
                l_Highlight_0.OutlineColor = v8;
            end;
            wait(0.02);
        end;
        for v9 = 1, 0, -0.02 do
            local v10 = v3:Lerp(v4, v9);
            local v11 = v5:Lerp(v4, v9);
            if l_SurfaceAppearance_0 then
                l_SurfaceAppearance_0.Color = v10;
            end;
            if l_Highlight_0 then
                l_Highlight_0.FillColor = v11;
                l_Highlight_0.OutlineColor = v11;
            end;
            wait(0.02);
        end;
    end;
end)();