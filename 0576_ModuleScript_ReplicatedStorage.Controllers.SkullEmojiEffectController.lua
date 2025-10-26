--[[
  Extracted from: ReplicatedStorage.Controllers.SkullEmojiEffectController
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local u1 = game:GetService("ReplicatedStorage")
local u2 = game:GetService("RunService")
local u3 = game:GetService("Lighting")
local v4 = game:GetService("Players")
local u5 = game:GetService("Debris")
local v6 = require(u1.Packages.Trove)
require(u1.Packages.Shake)
local u7 = require(u1.Shared.ShakePresets)
local u8 = require(u1.Packages.CreateTween)
local v9 = {}
local u10 = v6.new()
local u11 = v4.LocalPlayer.PlayerGui.SkullEmoji
local u12 = u11.CanvasGroup
local u13 = u12.Skull
local u14 = {
    ["Center"] = UDim2.fromScale(0.5, 0.65),
    ["Lower"] = UDim2.fromScale(0.5, 0.8),
    ["Bottom"] = u13.Position
}
TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.In)
local u15 = TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
function v9._playEffect(p16, p17, p18) --[[Anonymous function at line 60]]
    --[[
    Upvalues:
        [1] = u3
        [2] = u14
        [3] = u12
        [4] = u13
        [5] = u11
        [6] = u1
        [7] = u15
        [8] = u8
        [9] = u10
        [10] = u7
        [11] = u2
        [12] = u5
    --]]
    local v19 = workspace.CurrentCamera
    local u20 = u3.ExposureCompensation
    local u21 = u14[p18] or u14.Bottom
    u12.GroupTransparency = 1
    u13.Position = UDim2.fromScale(u21.X.Scale * 0.85, u21.Y.Scale * 1.1)
    u13.Rotation = -5
    u11.Enabled = true
    u1.Sounds.Others.SkullEffect:Play()
    u3.ExposureCompensation = 4
    local v22 = u8(u3, u15, {
        ["ExposureCompensation"] = u20
    }, false)
    u10:Add(v22)
    v22:Play()
    local v23 = u8(u12, TweenInfo.new(0.1, Enum.EasingStyle.Quart), {
        ["GroupTransparency"] = 0
    }, false)
    u10:Add(v23)
    v23:Play()
    u13.ImageTransparency = 0
    local v24 = u8(u13, TweenInfo.new(0.125, Enum.EasingStyle.Back), {
        ["Position"] = u21,
        ["Rotation"] = 0
    }, false)
    u10:Add(v24)
    v24:Play()
    local v25 = u7.Explosion:Clone()
    v25.FadeInTime = 0
    v25.Frequency = 0.3333333333333333
    u10:Add(v25)
    u10:Add(u7.BindShakeToCamera(v25, v19))
    v25:Start()
    local u26 = u7.Bump:Clone()
    u26.FadeInTime = 0
    u26.Sustain = true
    u10:Add(u26)
    u10:Add(u7.BindShakeToCamera(u26, v19))
    u26:Start()
    u10:Add(task.delay(0.125, function() --[[Anonymous function at line 110]]
        --[[
        Upvalues:
            [1] = u2
            [2] = u26
            [3] = u13
            [4] = u21
            [5] = u10
        --]]
        local u27 = time()
        u10:Add((u2.PostSimulation:Connect(function(_) --[[Anonymous function at line 113]]
            --[[
            Upvalues:
                [1] = u26
                [2] = u13
                [3] = u21
                [4] = u27
            --]]
            local v28, _ = u26:Update()
            if u26:IsShaking() then
                local v29 = v28 * Vector3.new(1, 1, 1) * 0.075
                u13.Position = UDim2.fromScale((1 + v29.X) * u21.X.Scale, (1 + v29.Y) * u21.Y.Scale)
                local v30 = u13
                local v31 = 2 * (time() - u27)
                v30.Rotation = math.sin(v31) * 5
            end
        end)))
    end))
    local u32 = Instance.new("ColorCorrectionEffect")
    u32.Parent = u3
    u5:AddItem(u32, p17)
    local v33 = u8(u32, u15, {
        ["Brightness"] = -0.2,
        ["Contrast"] = 0.4,
        ["Saturation"] = -0.7000000000000001
    }, false)
    u10:Add(v33)
    v33:Play()
    u10:Add(task.delay(p17 - 0.5, function() --[[Anonymous function at line 142]]
        --[[
        Upvalues:
            [1] = u3
            [2] = u15
            [3] = u20
            [4] = u8
            [5] = u10
            [6] = u26
            [7] = u32
            [8] = u13
        --]]
        u3.ExposureCompensation = 2.5
        local v34 = u8(u3, u15, {
            ["ExposureCompensation"] = u20
        }, false)
        u10:Add(v34)
        v34:Play()
        u26:StopSustain()
        local v35 = u8(u32, u15, {
            ["Brightness"] = 0,
            ["Contrast"] = 0,
            ["Saturation"] = 0
        }, false)
        u10:Add(v35)
        v35:Play()
        local v36 = u8(u13, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {
            ["ImageTransparency"] = 1
        }, false)
        u10:Add(v36)
        v36:Play()
    end))
    task.wait(p17)
    p16:Stop()
end
function v9.Play(p37, p38, p39) --[[Anonymous function at line 168]]
    if p37._isPlaying then
        p37:Stop()
    end
    p37._isPlaying = true
    task.spawn(p37._playEffect, p37, math.max(p38 or 3, 1.5), p39 or "Bottom")
end
function v9.Stop(p40) --[[Anonymous function at line 178]]
    --[[
    Upvalues:
        [1] = u11
        [2] = u10
    --]]
    u11.Enabled = false
    p40._isPlaying = false
    u10:Clean()
end
function v9.Start(_) --[[Anonymous function at line 184]]
    --[[
    Upvalues:
        [1] = u11
    --]]
    u11.Enabled = false
end
return v9