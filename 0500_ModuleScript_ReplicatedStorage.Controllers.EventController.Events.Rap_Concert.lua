--[[
  Extracted from: ReplicatedStorage.Controllers.EventController.Events.Rap Concert
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local u1 = game:GetService("ReplicatedStorage")
game:GetService("TweenService")
local u2 = game:GetService("RunService")
local u3 = game:GetService("Lighting")
local u4 = game:GetService("Players")
require(u1.Shared.EventTypes)
local v5 = {}
local u6 = require(u1.Controllers.EncryptedAssetsController)
require(u1.Controllers.AnimalController)
local u7 = require(u1.Controllers.EffectController)
local u8 = require(u1.Controllers.CameraController)
local u9 = require(u1.Controllers.SoundController)
local u10 = require(u1.Controllers.EventController)
local u11 = require(u1.Controllers.CycleController)
local u12 = require(u1.Packages.CreateTween)
require(u1.Shared.TweenPivot)
local u13 = require(u1.Packages.Observers)
require(u1.Utils.MathUtils)
local u14 = require(u1.Packages.Signal)
require(u1.Packages.Spring)
local u15 = require(u1.Packages.Trove)
require(u1.Packages.Shake)
local u16 = require(u1.Packages.Spr)
require(u1.Packages.Net)
local u17 = require(u1.Shared.VFX)
local u18 = u4.LocalPlayer
local u19 = workspace.CurrentCamera
local u20 = script.Name
local u21 = workspace.Sounds.Concert
local u22 = u15.new()
local u23 = nil
function v5.OnStart(_) --[[Anonymous function at line 43]]
    --[[
    Upvalues:
        [1] = u10
        [2] = u20
        [3] = u22
        [4] = u7
        [5] = u11
        [6] = u9
        [7] = u3
        [8] = u1
        [9] = u19
        [10] = u21
        [11] = u6
        [12] = u17
        [13] = u2
        [14] = u12
        [15] = u16
        [16] = u8
        [17] = u14
        [18] = u13
        [19] = u4
        [20] = u15
        [21] = u18
    --]]
    local u24 = u10:GetActiveEventData(u20)
    assert(u24)
    local function u35(p25, u26, u27) --[[Anonymous function at line 51]]
        --[[
        Upvalues:
            [1] = u24
        --]]
        local function u30() --[[Anonymous function at line 52]]
            --[[
            Upvalues:
                [1] = u26
                [2] = u24
            --]]
            local v28 = u26
            local v29 = u24.startedAt + v28 - workspace:GetServerTimeNow()
            return math.max(v29, 0)
        end
        local function v31() --[[Anonymous function at line 56]]
            --[[
            Upvalues:
                [1] = u27
                [2] = u30
            --]]
            u27(u30)
        end
        local u32 = nil
        local v33 = u24.startedAt + p25 - workspace:GetServerTimeNow()
        local v34 = math.max(v33, 0)
        if v34 > 0 then
            u32 = task.delay(v34, v31)
        else
            u27(u30)
        end
        return function() --[[Anonymous function at line 69]]
            --[[
            Upvalues:
                [1] = u32
            --]]
            if u32 and coroutine.status(u32) == "suspended" then
                pcall(task.cancel, u32)
            end
        end
    end
    u22:Add(function() --[[Anonymous function at line 76]]
        --[[
        Upvalues:
            [1] = u7
            [2] = u11
            [3] = u9
        --]]
        u7:Activate("Blink")
        u11:Update()
        u9:UpdateOST()
    end)
    local u36 = u3:FindFirstChild("Atmosphere")
    if u36 then
        u36.Parent = u1
        u22:Add(function() --[[Anonymous function at line 85]]
            --[[
            Upvalues:
                [1] = u36
                [2] = u3
            --]]
            u36.Parent = u3
        end)
    end
    u22:Clone(script.Atmosphere).Parent = u3
    local u37 = u3:FindFirstChild("Cartoon")
    if u37 then
        u37.Parent = u1
        u22:Add(function() --[[Anonymous function at line 95]]
            --[[
            Upvalues:
                [1] = u37
                [2] = u3
            --]]
            u37.Parent = u3
        end)
    end
    local u38 = nil
    local u39 = u22:Clone(Instance.new("ColorCorrectionEffect"))
    u39.Parent = u19
    local function u130() --[[Anonymous function at line 112]]
        --[[
        Upvalues:
            [1] = u3
            [2] = u22
            [3] = u21
            [4] = u6
            [5] = u24
            [6] = u17
            [7] = u35
            [8] = u2
            [9] = u38
            [10] = u12
            [11] = u16
            [12] = u8
        --]]
        u3.Ambient = Color3.new(0, 0, 0)
        u3.OutdoorAmbient = Color3.fromRGB(100, 100, 100)
        u3.EnvironmentDiffuseScale = 0
        u3.EnvironmentSpecularScale = 0
        u22:Add(function() --[[Anonymous function at line 117]]
            --[[
            Upvalues:
                [1] = u3
            --]]
            u3.Ambient = Color3.fromRGB(241, 241, 241)
            u3.OutdoorAmbient = Color3.fromRGB(212, 212, 212)
            u3.EnvironmentDiffuseScale = 1
            u3.EnvironmentSpecularScale = 0.5
        end)
        u22:Add(function() --[[Anonymous function at line 125]]
            --[[
            Upvalues:
                [1] = u21
            --]]
            u21:Stop()
        end)
        u22:Add(task.spawn(function() --[[Anonymous function at line 129]]
            --[[
            Upvalues:
                [1] = u6
                [2] = u21
                [3] = u24
            --]]
            u6:WaitForAssetId("rbxassetid://124977112693561")
            u21.SoundId = "rbxassetid://124977112693561"
            while not u21.IsLoaded do
                task.wait()
            end
            local v40 = u21
            local v41 = u21.TimePosition
            local v42 = workspace:GetServerTimeNow() - (u24.startedAt + 5)
            v40.TimePosition = math.max(v41, v42)
            u21:Play()
        end))
        local u43 = {
            Color3.fromRGB(255, 255, 255),
            Color3.fromRGB(255, 0, 0),
            Color3.fromRGB(255, 128, 0),
            Color3.fromRGB(255, 255, 0),
            Color3.fromRGB(128, 255, 0),
            Color3.fromRGB(0, 255, 0),
            Color3.fromRGB(0, 255, 128),
            Color3.fromRGB(0, 255, 255),
            Color3.fromRGB(0, 0, 255),
            Color3.fromRGB(128, 0, 255),
            Color3.fromRGB(255, 0, 255),
            Color3.fromRGB(255, 0, 128),
            Color3.fromRGB(255, 0, 255),
            Color3.fromRGB(0, 128, 255)
        }
        u22:Clone(script.Night_Sky).Parent = u3
        local v44 = u22:Clone(script.Stage)
        local u45 = u22:Clone(script.VFX)
        local u46 = u45.SmokeStage
        u22:Add(u46)
        u46.Parent = workspace
        u45.Parent = v44
        u17.disable(u45)
        local u47 = v44.SpotLights:GetChildren()
        local _ = #u47
        local u48 = {}
        local u49 = {}
        local u50 = {}
        local u51 = {}
        local u52 = {}
        local u53 = false
        local u54 = false
        local u55 = {}
        local u56 = {}
        local u57 = {}
        local u58 = {}
        for _, v59 in u47 do
            u48[v59] = v59:GetPivot()
            u49[v59] = 0
            u50[v59] = 0
            u51[v59] = 25
            v59.Rotate.Neon["1"].LightBeam:Destroy()
            local v60 = script.lightbeambig.Beams:Clone()
            for _, v61 in v60:GetChildren() do
                v61.Attachment0 = v59.Rotate.Neon["1"]
                v61.Attachment1 = v59.Rotate.Neon["2"]
                v61.Parent = v59.Rotate.Neon
                table.insert(u52, v61)
            end
            v60:Destroy()
        end
        v44.Parent = workspace
        local u62 = u22:Add(Instance.new("Color3Value"))
        u62.Value = Color3.fromRGB(0, 0, 0)
        local u63 = true
        u22:Add(function() --[[Anonymous function at line 214]]
            --[[
            Upvalues:
                [1] = u63
            --]]
            u63 = false
        end)
        for _, v64 in u52 do
            v64.Enabled = false
        end
        u22:Add((u35(10, 15, function(u65) --[[Anonymous function at line 222]]
            --[[
            Upvalues:
                [1] = u17
                [2] = u45
                [3] = u52
                [4] = u22
                [5] = u2
                [6] = u21
                [7] = u55
                [8] = u58
                [9] = u38
                [10] = u43
                [11] = u12
                [12] = u62
                [13] = u24
                [14] = u16
                [15] = u56
                [16] = u57
                [17] = u47
                [18] = u50
                [19] = u51
                [20] = u49
                [21] = u48
                [22] = u53
                [23] = u54
                [24] = u46
                [25] = u8
            --]]
            u17.enable(u45)
            local u66 = 1
            local u67 = 0
            local u68 = 0
            local u69 = 0
            local u70 = 0
            local u71 = {}
            local u72 = Color3.new(0, 0, 0)
            local u73 = ColorSequence.new(u72)
            task.delay(u65(), function() --[[Anonymous function at line 236]]
                --[[
                Upvalues:
                    [1] = u52
                --]]
                for _, v74 in u52 do
                    v74.Enabled = true
                end
            end)
            u22:Add(function() --[[Anonymous function at line 242]]
                workspace.Gravity = 196.2
            end)
            local u75 = u45.VFXDisco
            local u76 = u75:GetPivot()
            local u77 = 0
            u22:Add(u2.PostSimulation:Connect(function(p78) --[[Anonymous function at line 251]]
                --[[
                Upvalues:
                    [1] = u77
                    [2] = u68
                    [3] = u67
                    [4] = u70
                    [5] = u69
                    [6] = u21
                    [7] = u55
                    [8] = u58
                    [9] = u38
                    [10] = u65
                    [11] = u66
                    [12] = u43
                    [13] = u12
                    [14] = u62
                    [15] = u75
                    [16] = u76
                    [17] = u24
                    [18] = u16
                    [19] = u56
                    [20] = u71
                    [21] = u73
                    [22] = u57
                    [23] = u72
                    [24] = u47
                    [25] = u50
                    [26] = u51
                    [27] = u49
                    [28] = u48
                    [29] = u53
                    [30] = u54
                    [31] = u52
                    [32] = u17
                    [33] = u46
                    [34] = u8
                --]]
                workspace.Gravity = 29.429999999999996
                u77 = u77 - p78
                u68 = u68 - p78
                u67 = u67 - p78
                u70 = u70 - p78
                u69 = u69 - p78
                local v79 = u21.TimePosition
                local v80 = (u21.PlaybackLoudness - 100) / 900
                local v81 = math.clamp(v80, 0, 1)
                for _, v82 in u55 do
                    local v83 = v81 / 0.05
                    v82.TimeScale = math.clamp(v83, 1, 2) * u58[v82]
                end
                if u38 then
                    local v84 = u38
                    local v85 = v81 / 0.2
                    v84:AdjustSpeed((math.clamp(v85, 0.5, 1.1)))
                end
                if v81 >= 0.11 and (u69 <= 0 and u65() <= 0) then
                    u69 = 0.3
                    u66 = u66 % #u43 + 1
                    u12(u62, TweenInfo.new(0.2), {
                        ["Value"] = u43[u66]
                    })
                end
                u75:PivotTo(u76 * CFrame.Angles(0, workspace:GetServerTimeNow() - u24.startedAt, 0))
                u16.target(u75, 1, 2, {
                    ["Scale"] = 1
                })
                if u77 <= 0 and v81 > 0.05 then
                    u77 = 0.1
                    u16.target(u75, 1, 10, {
                        ["Scale"] = v81 + 1
                    })
                end
                local v86 = u62.Value
                local v87 = ColorSequence.new(v86)
                for _, v88 in u56 do
                    local v89
                    if u71[v88] then
                        v89 = u73
                    else
                        v89 = v87
                    end
                    v88.Color = v89
                end
                for _, v90 in u57 do
                    local v91
                    if u71[v90] then
                        v91 = u72
                    else
                        v91 = v86
                    end
                    v90.Color = v91
                end
                local v92 = v81 / 0.25
                local v93 = p78 * math.clamp(v92, 0.05, 1)
                for _, v94 in u47 do
                    local v95 = u50[v94] or 0
                    local v96 = u51[v94] or 0
                    local v97 = (u49[v94] or 0) + v93
                    local v98 = math.clamp(v97, 0, 1)
                    u49[v94] = v98
                    if v98 >= 1 then
                        u49[v94] = 0
                        u50[v94] = v96
                        local v99 = u51
                        v99[v94] = v99[v94] * -1
                    else
                        local v100 = math.lerp(v95, v96, v98)
                        local v101 = math.rad(v100)
                        v94:PivotTo(u48[v94] * CFrame.Angles(0, v101, not u53 and 0 or v101))
                        if u53 then
                            for _, v102 in v94.Rotate.Neon:GetChildren() do
                                if v102.Name == "CustomAttachment_-1" or (v102.Name == "2" or v102.Name == "CustomAttachment_2") then
                                    local v103 = v102.Position.X
                                    local v104 = v98 * 3.141592653589793
                                    local v105 = math.sin(v104) * 100
                                    v102.Position = Vector3.new(v103, v105, 300)
                                end
                            end
                        end
                    end
                end
                if v79 >= 25 and not u54 then
                    u54 = true
                    for _, v106 in u47 do
                        local v107 = v106.Rotate.Neon["1"]
                        local v108 = v106.Rotate.Neon["2"]
                        local v109 = v108:Clone()
                        v109.Name = "CustomAttachment_1"
                        v109.Parent = v106.Rotate.Neon
                        u12(v108, TweenInfo.new(5), {
                            ["Position"] = v108.Position + Vector3.new(15, 0, 0)
                        })
                        u12(v109, TweenInfo.new(5), {
                            ["Position"] = v108.Position - Vector3.new(15, 0, 0)
                        })
                        local v110 = script.lightbeambig.Beams:Clone()
                        for _, v111 in v110:GetChildren() do
                            v111.Width0 = 0.5
                            v111.Width1 = 1
                            v111.Brightness = 13
                            v111.Attachment0 = v107
                            v111.Attachment1 = v109
                            v111.Parent = v106.Rotate.Neon
                            local v112 = u52
                            table.insert(v112, v111)
                            local v113 = u56
                            table.insert(v113, v111)
                        end
                        v110:Destroy()
                    end
                end
                if v79 >= 71 and not u53 then
                    u17.enable(u46)
                    task.delay(5, function() --[[Anonymous function at line 381]]
                        --[[
                        Upvalues:
                            [1] = u17
                            [2] = u46
                        --]]
                        u17.disable(u46)
                    end)
                    u53 = true
                    for _, v114 in u47 do
                        local v115 = v114.Rotate.Neon["1"]
                        local v116 = v114.Rotate.Neon["2"]
                        local v117 = v116.Position - Vector3.new(15, 0, 0)
                        u12(v116, TweenInfo.new(5), {
                            ["Position"] = v117
                        })
                        for v118 = -2, 2 do
                            if v118 ~= 0 then
                                local v119 = v116:Clone()
                                v119.Name = ("CustomAttachment_%*"):format(v118)
                                v119.Parent = v114.Rotate.Neon
                                local v120 = u12
                                local v121 = TweenInfo.new(5)
                                local v122 = {}
                                local v123 = v118 * 30
                                v122.Position = v117 + Vector3.new(v123, 0, 0)
                                v120(v119, v121, v122)
                                local v124 = script.lightbeambig.Beams:Clone()
                                for _, v125 in v124:GetChildren() do
                                    v125.Width0 = 0.5
                                    v125.Width1 = 1
                                    v125.Brightness = 13
                                    v125.Attachment0 = v115
                                    v125.Attachment1 = v119
                                    v125.Parent = v114.Rotate.Neon
                                    local v126 = u52
                                    table.insert(v126, v125)
                                    local v127 = u56
                                    table.insert(v127, v125)
                                end
                                v124:Destroy()
                            end
                        end
                    end
                end
                if v81 >= 0.2 and u67 <= 0 then
                    u67 = 0.1
                    u8:Fov((v81 - 0.2) * 15 + 70, 0.1)
                end
            end))
        end)))
        for _, v128 in v44:GetDescendants() do
            if not v128:IsDescendantOf(u45.VFXDisco) then
                if v128:IsA("BasePart") and v128.Name == "Neon" or v128:IsA("SpotLight") then
                    table.insert(u57, v128)
                elseif v128:IsA("ParticleEmitter") or v128:IsA("Beam") then
                    table.insert(u56, v128)
                    if v128:IsA("ParticleEmitter") then
                        u58[v128] = v128.TimeScale
                        table.insert(u55, v128)
                    end
                end
            end
        end
        u22:Add((u35(10, 15, function(p129) --[[Anonymous function at line 451]]
            --[[
            Upvalues:
                [1] = u12
                [2] = u62
                [3] = u43
            --]]
            u12(u62, TweenInfo.new(p129()), {
                ["Value"] = u43[1]
            })
        end)))
    end
    u22:Add((u35(0, 5, function(p131) --[[Anonymous function at line 458]]
        --[[
        Upvalues:
            [1] = u12
            [2] = u39
            [3] = u130
            [4] = u7
            [5] = u22
        --]]
        u12(u39, TweenInfo.new(p131(), Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
            ["Brightness"] = -1.2
        })
        task.delay(p131(), u130)
        u7:Run("ConcertEvent", "GrassRecolor")
        u22:Add(function() --[[Anonymous function at line 466]]
            --[[
            Upvalues:
                [1] = u7
            --]]
            u7:Stop("ConcertEvent", "GrassRecolor")
        end)
        u7:Run("ConcertEvent", "WallRecolor")
        u22:Add(function() --[[Anonymous function at line 471]]
            --[[
            Upvalues:
                [1] = u7
            --]]
            u7:Stop("ConcertEvent", "WallRecolor")
        end)
        u7:Run("ConcertEvent", "WallBottomRecolor")
        u22:Add(function() --[[Anonymous function at line 476]]
            --[[
            Upvalues:
                [1] = u7
            --]]
            u7:Stop("ConcertEvent", "WallBottomRecolor")
        end)
    end)))
    u22:Add((u35(10, 15, function(p132) --[[Anonymous function at line 481]]
        --[[
        Upvalues:
            [1] = u12
            [2] = u39
        --]]
        u12(u39, TweenInfo.new(p132(), Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
            ["Brightness"] = -0.05
        })
    end)))
    local v133 = u22
    local v134 = task.delay
    local v135 = u24.startedAt + 15 - workspace:GetServerTimeNow()
    v133:Add(v134(math.max(v135, 0), function() --[[Anonymous function at line 490]]
        --[[
        Upvalues:
            [1] = u22
            [2] = u14
            [3] = u13
            [4] = u4
            [5] = u15
            [6] = u38
            [7] = u2
            [8] = u24
            [9] = u18
        --]]
        u22:Add(u14.new())
        u22:Add(u13.observeCharacter(u4.LocalPlayer, function(_, u136) --[[Anonymous function at line 494]]
            --[[
            Upvalues:
                [1] = u15
                [2] = u38
                [3] = u2
                [4] = u24
                [5] = u18
            --]]
            local u137 = u15.new()
            u137:Add(task.spawn(function() --[[Anonymous function at line 497]]
                --[[
                Upvalues:
                    [1] = u136
                    [2] = u38
                    [3] = u137
                    [4] = u2
                    [5] = u24
                    [6] = u18
                --]]
                local u138 = u136:WaitForChild("Humanoid")
                if u138 then
                    local v139 = u138:WaitForChild("Animator")
                    if v139 then
                        local u140 = v139:LoadAnimation(script.Dance)
                        u140.Priority = Enum.AnimationPriority.Action
                        u38 = u140
                        local u141 = 0
                        u137:Add(u2.PostSimulation:Connect(function(p142) --[[Anonymous function at line 515]]
                            --[[
                            Upvalues:
                                [1] = u24
                                [2] = u140
                                [3] = u138
                                [4] = u18
                                [5] = u141
                            --]]
                            workspace:GetServerTimeNow()
                            local v143 = u24.startedAt + 75 - workspace:GetServerTimeNow()
                            if math.max(v143, 0) > 0 then
                                if not u140.IsPlaying then
                                    u140:Play()
                                end
                            elseif u138.MoveDirection ~= Vector3.new(0, 0, 0) or u18:GetAttribute("Stealing") then
                                u141 = 0
                                if u140.IsPlaying then
                                    u140:Stop()
                                end
                            else
                                if u141 < 3 then
                                    u141 = u141 + p142
                                    return
                                end
                                if not u140.IsPlaying then
                                    u140:Play()
                                    return
                                end
                            end
                        end))
                        u137:Add(function() --[[Anonymous function at line 541]]
                            --[[
                            Upvalues:
                                [1] = u140
                                [2] = u38
                            --]]
                            u140:Stop()
                            u140:Destroy()
                            u38 = nil
                        end)
                    end
                else
                    return
                end
            end))
            return u137:WrapClean()
        end))
    end))
    u11:Update()
    u9:UpdateOST()
end
function v5.OnStop(_) --[[Anonymous function at line 556]]
    --[[
    Upvalues:
        [1] = u22
        [2] = u23
    --]]
    u22:Destroy()
    u23 = nil
end
function v5.OnLoad(_) --[[Anonymous function at line 561]] end
return v5