--[[
  Extracted from: ReplicatedStorage.Items.Dev Slap.Handle.Color
  Class: LocalScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: Color, time of decompilation: Tue Jun 24 14:16:13 2025 ]]
local l_SurfaceAppearance_0 = script.Parent:FindFirstChildOfClass("SurfaceAppearance");
local v1 = {
    Color3.fromRGB(255, 0, 0), 
    Color3.fromRGB(0, 255, 0), 
    Color3.fromRGB(0, 0, 255), 
    Color3.fromRGB(255, 255, 0), 
    Color3.fromRGB(255, 0, 255), 
    Color3.fromRGB(0, 255, 255), 
    Color3.fromRGB(255, 255, 255), 
    Color3.fromRGB(0, 0, 0)
};
(function() --[[ Line: 18 ]] --[[ Name: efeitoGlitch ]]
    -- upvalues: v1 (copy), l_SurfaceAppearance_0 (copy)
    while true do
        local v2 = v1[math.random(1, #v1)];
        if l_SurfaceAppearance_0 then
            l_SurfaceAppearance_0.Color = v2;
        end;
        wait(0.01);
    end;
end)();