--[[
  Extracted from: ReplicatedStorage.Items.Dark Matter Slap.Handle.Color
  Class: Script
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local u1 = script.Parent
local u2 = u1:FindFirstChildOfClass("SurfaceAppearance")
local u3 = Color3.fromRGB(10, 0, 20)
local u4 = Color3.fromRGB(128, 17, 255)
local u5 = Color3.fromRGB(220, 180, 255)
local u6 = Color3.fromRGB(255, 240, 255)
local u7 = 0
(function() --[[Function name: pulsarCores, line 16]]
    --[[
    Upvalues:
        [1] = u1
        [2] = u7
        [3] = u3
        [4] = u4
        [5] = u5
        [6] = u6
        [7] = u2
    --]]
    while true do
        local v8 = u1:FindFirstChildOfClass("Highlight")
        u7 = u7 + 0.02
        local v9 = u7 * 10
        local v10 = (math.sin(v9) + 1) / 2
        local v11 = u3:Lerp(u4, v10)
        local v12 = u5:Lerp(u4, v10)
        local v13 = u4:Lerp(u6, v10)
        if u2 then
            u2.Color = v11
        end
        if v8 then
            v8.FillColor = v12
            v8.OutlineColor = v13
        end
        wait(0.02)
    end
end)()