--[[
  Extracted from: ReplicatedStorage.Items.Galaxy Slap.Handle.Color
  Class: Script
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local u1 = script.Parent:FindFirstChildOfClass("SurfaceAppearance")
local u2 = Color3.fromRGB(105, 90, 180)
local u3 = Color3.fromRGB(173, 216, 230)
local u4 = Color3.fromRGB(255, 182, 193)
local u5 = Color3.fromRGB(255, 255, 255)
local u6 = 0
(function() --[[Function name: efeitoGalaxiaSuave, line 15]]
    --[[
    Upvalues:
        [1] = u6
        [2] = u2
        [3] = u3
        [4] = u4
        [5] = u5
        [6] = u1
    --]]
    while true do
        u6 = u6 + 0.02
        local v7 = u6 * 1.2
        local v8 = (math.sin(v7) + 1) / 2
        local v9 = (u6 + 1) * 1.2
        local v10 = (math.sin(v9) + 1) / 2
        local v11 = u2:Lerp(u3, v8):Lerp(u4, v10):Lerp(u5, 0.5)
        if u1 then
            u1.Color = v11
        end
        wait(0.02)
    end
end)()