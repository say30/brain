--[[
  Extracted from: ReplicatedStorage.Items.Rainbow Slap.Handle.Color
  Class: LocalScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: Color, time of decompilation: Tue Jun 24 14:16:13 2025 ]]
local l_SurfaceAppearance_0 = script.Parent:FindFirstChildOfClass("SurfaceAppearance");
local v1 = Color3.fromRGB(200, 200, 200);
local v2 = Color3.fromRGB(255, 255, 255);
local v3 = 0;
(function() --[[ Line: 12 ]] --[[ Name: pulsarPretoBranco ]]
    -- upvalues: v3 (ref), v1 (copy), v2 (copy), l_SurfaceAppearance_0 (copy)
    while true do
        v3 = v3 + 0.02;
        local v4 = (math.sin(v3 * 5) + 1) / 2;
        local v5 = v1:Lerp(v2, v4);
        if l_SurfaceAppearance_0 then
            l_SurfaceAppearance_0.Color = v5;
        end;
        wait(0.02);
    end;
end)();