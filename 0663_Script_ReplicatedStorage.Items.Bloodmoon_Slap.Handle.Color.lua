--[[
  Extracted from: ReplicatedStorage.Items.Bloodmoon Slap.Handle.Color
  Class: Script
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: Color, time of decompilation: Tue Jun 24 14:16:13 2025 ]]
local l_Parent_0 = script.Parent;
local l_SurfaceAppearance_0 = l_Parent_0:FindFirstChildOfClass("SurfaceAppearance");
local l_Highlight_0 = l_Parent_0:FindFirstChildOfClass("Highlight");
local v3 = Color3.fromRGB(200, 25, 25);
local v4 = Color3.fromRGB(155, 25, 25);
local v5 = Color3.fromRGB(125, 25, 25);
local v6 = Color3.fromRGB(75, 25, 25);
local v7 = 0;
if l_Highlight_0 then
    l_Highlight_0.FillTransparency = 0.9;
    l_Highlight_0.OutlineTransparency = 0;
end;
(function() --[[ Line: 22 ]] --[[ Name: pulsarCores ]]
    -- upvalues: v7 (ref), v3 (copy), v4 (copy), v5 (copy), v6 (copy), l_SurfaceAppearance_0 (copy), l_Highlight_0 (copy)
    while true do
        v7 = v7 + 0.02;
        local v8 = (math.sin(v7 * 10) + 1) / 2;
        local v9 = v3:Lerp(v4, v8);
        local v10 = v5:Lerp(v4, v8);
        local v11 = v4:Lerp(v6, v8);
        if l_SurfaceAppearance_0 then
            l_SurfaceAppearance_0.Color = v9;
        end;
        if l_Highlight_0 then
            l_Highlight_0.FillColor = v10;
            l_Highlight_0.OutlineColor = v11;
        end;
        wait(0.02);
    end;
end)();