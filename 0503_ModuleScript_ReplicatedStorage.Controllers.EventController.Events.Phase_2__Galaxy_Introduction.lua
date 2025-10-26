--[[
  Extracted from: ReplicatedStorage.Controllers.EventController.Events.Phase 2: Galaxy Introduction
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

game:GetService("ServerScriptService")
local u1 = game:GetService("ReplicatedStorage")
local u2 = game:GetService("ContentProvider")
local u3 = game:GetService("TextChatService")
local u4 = game:GetService("SoundService")
local u5 = game:GetService("HttpService")
local u6 = game:GetService("StarterGui")
local u7 = game:GetService("RunService")
local u8 = game:GetService("Lighting")
local u9 = game:GetService("Players")
require(u1.Shared.EventTypes)
local u10 = {}
local u11 = require(u1.Controllers.CharacterController)
require(u1.Controllers.InterfaceController)
local u12 = require(u1.Controllers.EffectController)
local u13 = require(u1.Controllers.EventController)
local u14 = require(u1.Controllers.CycleController)
local u15 = require(u1.Packages.Serialization)
local u16 = require(u1.Packages.CreateTween)
local u17 = require(u1.Packages.TopbarPlus)
local u18 = require(u1.Packages.Observers)
local u19 = require(u1.Packages.Moonlite)
require(u1.Utils.TimeUtils)
local u20 = require(u1.Packages.Squash)
require(u1.Packages.Timer)
local v21 = require(u1.Packages.Trove)
local u22 = script.Name
local u23 = TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
local u24 = {
    "I created admin abuse!",
    "My admin is better!",
    "Blah Blah Blah",
    "Me and Albert made admin!"
}
local u25 = u1.Models.Events["Phase 2: Galaxy Introduction"]
local u26 = workspace.Events["Phase 2: Galaxy Introduction"]
local u27 = v21.new()
function u10.PlayInitialCutscene(_) --[[Anonymous function at line 70]]
    --[[
    Upvalues:
        [1] = u13
        [2] = u22
        [3] = u27
        [4] = u17
        [5] = u6
        [6] = u11
        [7] = u4
        [8] = u18
        [9] = u1
        [10] = u9
        [11] = u15
        [12] = u20
        [13] = u5
        [14] = u19
        [15] = u16
        [16] = u3
        [17] = u24
    --]]
    local u28 = u13:GetActiveEventData(u22)
    assert(u28)
    local u29 = u28.startedAt + 45.666 + 1 - workspace:GetServerTimeNow()
    if u29 > 0 then
        local u30 = u27:Extend()
        local u31 = u30:Clone(script.Cutscene.Assets)
        local u32 = u30:Clone(script.RainingTacos)
        u32.Volume = 0.1
        u32.Parent = u31["Computer Desk"].Computer["Meshes/Computer_Cube.008"]
        local u33 = workspace.CurrentCamera
        u33.CameraType = Enum.CameraType.Scriptable
        task.spawn(pcall, function() --[[Anonymous function at line 94]]
            --[[
            Upvalues:
                [1] = u17
                [2] = u6
            --]]
            pcall(u17.setTopbarEnabled, false)
            u6:SetCore("TopbarEnabled", false)
        end)
        u30:Add(function() --[[Anonymous function at line 99]]
            --[[
            Upvalues:
                [1] = u33
                [2] = u11
                [3] = u17
                [4] = u6
            --]]
            task.wait()
            u33.CameraType = Enum.CameraType.Custom
            local _, v34 = u11:GetCharacter()
            u33.CameraSubject = v34
            u33.FieldOfView = 70
            task.spawn(pcall, function() --[[Anonymous function at line 107]]
                --[[
                Upvalues:
                    [1] = u17
                    [2] = u6
                --]]
                pcall(u17.setTopbarEnabled, true)
                u6:SetCore("TopbarEnabled", true)
            end)
        end)
        u4.Cutscene.Volume = 0
        u30:Add(function() --[[Anonymous function at line 114]]
            --[[
            Upvalues:
                [1] = u4
            --]]
            u4.Cutscene.Volume = 1
        end)
        u30:Add(u18.observeTag("Plot", function(u35) --[[Anonymous function at line 119]]
            --[[
            Upvalues:
                [1] = u1
            --]]
            if not u35:IsA("PVInstance") then
                return nil
            end
            if u35:GetAttribute("Order") ~= 2 then
                return nil
            end
            u35.Parent = u1
            return function() --[[Anonymous function at line 130]]
                --[[
                Upvalues:
                    [1] = u35
                    [2] = u1
                --]]
                if u35.Parent == u1 then
                    u35.Parent = workspace.Plots
                end
            end
        end))
        u31.Parent = workspace
        u30:Add(u18.observeCharacters(function(_, u36) --[[Anonymous function at line 140]]
            --[[
            Upvalues:
                [1] = u1
            --]]
            u36.Parent = u1
            return function() --[[Anonymous function at line 142]]
                --[[
                Upvalues:
                    [1] = u36
                    [2] = u1
                --]]
                if u36.Parent == u1 then
                    u36.Parent = workspace
                end
            end
        end))
        u30:Add(u18.observeChildren(u9.LocalPlayer.PlayerGui, function(u37) --[[Anonymous function at line 150]]
            if not u37:IsA("LayerCollector") then
                return nil
            end
            if u37:GetAttribute("ShowInCutscene") then
                return nil
            end
            local u38 = u37.Enabled
            u37.Enabled = false
            return function() --[[Anonymous function at line 161]]
                --[[
                Upvalues:
                    [1] = u37
                    [2] = u38
                --]]
                if u37.Enabled ~= u38 then
                    u37.Enabled = u38
                end
            end
        end))
        local v39 = u15.des(u20.frombuffer(u5:JSONDecode(require(script.Cutscene))))
        local u40 = u19.CreatePlayer(v39, u31)
        u40:ReplaceElementByPath("game.CurrentCamera", u33)
        u32.TimePosition = 45.666 - u29
        u40.TimePosition = 45.666 - u29
        u40.Looped = false
        xpcall(function() --[[Anonymous function at line 180]]
            --[[
            Upvalues:
                [1] = u1
                [2] = u30
                [3] = u29
            --]]
            u1.Sounds.Events["Phase 2: Galaxy Introduction"].Cutscene:Play()
            u30:Add(task.spawn(function() --[[Anonymous function at line 182]]
                --[[
                Upvalues:
                    [1] = u1
                    [2] = u29
                --]]
                while not u1.Sounds.Events["Phase 2: Galaxy Introduction"].Cutscene.IsLoaded do
                    task.wait()
                end
                u1.Sounds.Events["Phase 2: Galaxy Introduction"].Cutscene.TimePosition = 54.666 - u29
            end))
        end, warn)
        u32:Play()
        u30:Add(task.delay(u28.startedAt + 7 - workspace:GetServerTimeNow(), function() --[[Anonymous function at line 191]]
            --[[
            Upvalues:
                [1] = u16
                [2] = u32
            --]]
            u16(u32, TweenInfo.new(3), {
                ["Volume"] = 0.05
            })
        end))
        local u41 = u27:Add(Instance.new("ColorCorrectionEffect"))
        u41.Parent = workspace.CurrentCamera
        local v42 = u28.startedAt + 46.166 - workspace:GetServerTimeNow()
        if v42 > 0 then
            u27:Add(task.delay(v42, function() --[[Anonymous function at line 203]]
                --[[
                Upvalues:
                    [1] = u28
                    [2] = u16
                    [3] = u41
                    [4] = u27
                --]]
                local u43 = u28.startedAt + 47.666 - workspace:GetServerTimeNow()
                local u44 = u16(u41, TweenInfo.new(u43 * 0.5), {
                    ["TintColor"] = Color3.new(0, 0, 0)
                })
                u27:Add(task.delay(u43, function() --[[Anonymous function at line 209]]
                    --[[
                    Upvalues:
                        [1] = u44
                        [2] = u16
                        [3] = u41
                        [4] = u43
                    --]]
                    u44:Cancel()
                    u44:Destroy()
                    u16(u41, TweenInfo.new(u43 * 0.5), {
                        ["TintColor"] = Color3.new(1, 1, 1)
                    })
                end))
            end))
        end
        u30:Add(task.spawn(function() --[[Anonymous function at line 220]]
            --[[
            Upvalues:
                [1] = u3
                [2] = u30
                [3] = u28
                [4] = u24
                [5] = u31
            --]]
            u3.BubbleChatConfiguration.BubbleDuration = 3
            u30:Add(function() --[[Anonymous function at line 222]]
                --[[
                Upvalues:
                    [1] = u3
                --]]
                u3.BubbleChatConfiguration.BubbleDuration = 15
            end)
            local v45 = 0
            while workspace:GetServerTimeNow() < u28.startedAt + 15 do
                v45 = v45 % #u24 + 1
                u3:DisplayBubble(u31.JandelR15.LowerTorso, u24[v45])
                task.wait(1)
            end
        end))
        u30:Add(function() --[[Anonymous function at line 234]]
            --[[
            Upvalues:
                [1] = u40
            --]]
            u40:Stop()
            u40:Destroy()
        end)
        u40:Compile()
        u40:Play()
        u30:Add(u40.Completed:Once(function() --[[Anonymous function at line 241]]
            --[[
            Upvalues:
                [1] = u30
            --]]
            u30:Destroy()
        end))
    end
end
function u10.PlayTakeoffCutscene(_) --[[Anonymous function at line 246]]
    --[[
    Upvalues:
        [1] = u13
        [2] = u22
        [3] = u10
        [4] = u27
        [5] = u17
        [6] = u6
        [7] = u11
        [8] = u4
        [9] = u18
        [10] = u9
        [11] = u15
        [12] = u20
        [13] = u5
        [14] = u19
    --]]
    local v46 = u13:GetActiveEventData(u22)
    assert(v46)
    if v46.startedAt + 82.982 - workspace:GetServerTimeNow() > 0 then
        u10._rocketShipCutscenePlaying = true
        local u47 = u27:Extend()
        local v48 = u47:Clone(script.Cutscene2.Assets)
        local u49 = workspace.CurrentCamera
        u49.CameraType = Enum.CameraType.Scriptable
        task.spawn(pcall, function() --[[Anonymous function at line 269]]
            --[[
            Upvalues:
                [1] = u17
                [2] = u6
            --]]
            pcall(u17.setTopbarEnabled, false)
            u6:SetCore("TopbarEnabled", false)
            u6:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
        end)
        u47:Add(function() --[[Anonymous function at line 275]]
            --[[
            Upvalues:
                [1] = u49
                [2] = u11
                [3] = u17
                [4] = u6
                [5] = u10
            --]]
            task.wait()
            u49.CameraType = Enum.CameraType.Custom
            local _, v50 = u11:GetCharacter()
            u49.CameraSubject = v50
            u49.FieldOfView = 70
            task.spawn(pcall, function() --[[Anonymous function at line 283]]
                --[[
                Upvalues:
                    [1] = u17
                    [2] = u6
                --]]
                pcall(u17.setTopbarEnabled, true)
                u6:SetCore("TopbarEnabled", true)
                u6:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)
            end)
            u10._rocketShipCutscenePlaying = false
        end)
        u4.Cutscene.Volume = 0
        u47:Add(function() --[[Anonymous function at line 293]]
            --[[
            Upvalues:
                [1] = u4
            --]]
            u4.Cutscene.Volume = 1
        end)
        v48.Parent = workspace
        u47:Add(u18.observeChildren(u9.LocalPlayer.PlayerGui, function(u51) --[[Anonymous function at line 300]]
            if not u51:IsA("LayerCollector") then
                return nil
            end
            if u51:GetAttribute("ShowInCutscene") then
                return nil
            end
            local u52 = u51.Enabled
            u51.Enabled = false
            return function() --[[Anonymous function at line 311]]
                --[[
                Upvalues:
                    [1] = u51
                    [2] = u52
                --]]
                if u51.Enabled ~= u52 then
                    u51.Enabled = u52
                end
            end
        end))
        local v53 = u15.des(u20.frombuffer(u5:JSONDecode(require(script.Cutscene2))))
        local u54 = u19.CreatePlayer(v53, v48)
        u54:ReplaceElementByPath("game.CurrentCamera", u49)
        local v55 = 82.982 - (v46.startedAt + 82.982 - workspace:GetServerTimeNow())
        u54.TimePosition = math.max(v55, 0)
        u54.Looped = false
        u47:Add(function() --[[Anonymous function at line 329]]
            --[[
            Upvalues:
                [1] = u54
            --]]
            u54:Stop()
            u54:Destroy()
        end)
        u54:Compile()
        u54:Play()
        u47:Add(u54.Completed:Once(function() --[[Anonymous function at line 336]]
            --[[
            Upvalues:
                [1] = u47
            --]]
            u47:Destroy()
        end))
    end
end
function u10.PlayTorusEffect(_) --[[Anonymous function at line 342]]
    --[[
    Upvalues:
        [1] = u9
        [2] = u1
        [3] = u27
        [4] = u25
        [5] = u26
        [6] = u7
        [7] = u8
        [8] = u16
        [9] = u23
    --]]
    local u56 = u9.LocalPlayer
    local u57 = workspace.CurrentCamera
    local u58 = u1.Sounds.Events["Phase 2: Galaxy Introduction"].SpaceshipFlyingTorus
    local u59 = u27:Extend()
    local u60 = u59:Clone(u25.Torus)
    u60.Size = u60.Size * 6
    u60:PivotTo(CFrame.new(0, 5000, 0))
    u60.Parent = u26
    u56.CameraMode = Enum.CameraMode.LockFirstPerson
    u57.CameraType = Enum.CameraType.Scriptable
    local v61 = u60.Size
    local v62 = v61.X
    local v63 = v61.Z
    local v64 = math.max(v62, v63)
    local v65 = v61.X
    local v66 = v61.Y
    local v67 = v61.Z
    local v68 = math.min(v65, v66, v67)
    local v69 = (((v64 - v68) / 2 * 2 - v68) / 2 + v64 / 2) / 2
    local v70 = u60.CFrame.Position - u60.CFrame.RightVector * v69
    u57.CFrame = CFrame.lookAt(v70, v70 + u60.CFrame.LookVector)
    u59:Add(u7.PreRender:Connect(function(p71) --[[Anonymous function at line 381]]
        --[[
        Upvalues:
            [1] = u60
        --]]
        local v72 = u60
        v72.CFrame = v72.CFrame * CFrame.fromAxisAngle(Vector3.new(0, 1, 0), p71 * 2.0943951023931953)
    end))
    local u73 = u8.ExposureCompensation
    u8.ExposureCompensation = 4
    u27:Add(u16(u8, u23, {
        ["ExposureCompensation"] = 2.5
    }))
    u59:Clone(u25.SpaceDepthOfField).Parent = u8
    u58.TimePosition = 0
    u58:Play()
    return function() --[[Anonymous function at line 400]]
        --[[
        Upvalues:
            [1] = u8
            [2] = u16
            [3] = u23
            [4] = u73
            [5] = u56
            [6] = u57
            [7] = u59
            [8] = u58
        --]]
        u8.ExposureCompensation = 3.5
        u16(u8, u23, {
            ["ExposureCompensation"] = u73
        })
        u56.CameraMode = Enum.CameraMode.Classic
        u57.CameraType = Enum.CameraType.Custom
        u59:Destroy()
        u58:Stop()
    end
end
function u10.OnStart(u74) --[[Anonymous function at line 417]]
    --[[
    Upvalues:
        [1] = u13
        [2] = u22
        [3] = u27
        [4] = u18
        [5] = u7
        [6] = u1
        [7] = u14
        [8] = u10
        [9] = u12
        [10] = u16
    --]]
    local u75 = u13:GetActiveEventData(u22)
    assert(u75)
    u27:Add(task.delay(u75.startedAt + 74.666 - workspace:GetServerTimeNow(), function() --[[Anonymous function at line 425]]
        --[[
        Upvalues:
            [1] = u27
            [2] = u75
            [3] = u18
            [4] = u7
            [5] = u1
            [6] = u14
            [7] = u74
            [8] = u10
        --]]
        u27:Add(task.delay(u75.startedAt + 76.666 - workspace:GetServerTimeNow(), function() --[[Anonymous function at line 429]]
            --[[
            Upvalues:
                [1] = u27
                [2] = u18
                [3] = u7
                [4] = u75
            --]]
            u27:Add(u18.observeTag("Rocketship", function(u76) --[[Anonymous function at line 430]]
                --[[
                Upvalues:
                    [1] = u7
                    [2] = u75
                --]]
				print("Found rocketship:", u76.Name)
                local u77 = u76:GetPivot()
                local u80 = u7.PostSimulation:Connect(function(_) --[[Anonymous function at line 433]]
                    --[[
                    Upvalues:
                        [1] = u75
                        [2] = u76
                        [3] = u77
                    --]]
                    local v78 = ((workspace:GetServerTimeNow() - (u75.startedAt + 76.666)) / 20) ^ 2
                    local v79 = math.lerp(0, 200, v78) ^ 2
                    u76:PivotTo(u77 + Vector3.new(0, v79, 0))
                end)
                return function() --[[Anonymous function at line 440]]
                    --[[
                    Upvalues:
                        [1] = u80
                    --]]
                    u80:Disconnect()
                end
            end))
        end))
        u1:SetAttribute("GalaxyIntroduction", true)
        u27:Add(function() --[[Anonymous function at line 448]]
            --[[
            Upvalues:
                [1] = u1
            --]]
            u1:SetAttribute("GalaxyIntroduction", nil)
        end)
        u14:Update()
        u27:Add(task.delay(u75.startedAt + 85.982 - workspace:GetServerTimeNow(), function() --[[Anonymous function at line 452]]
            --[[
            Upvalues:
                [1] = u74
                [2] = u27
            --]]
            while u74._rocketShipCutscenePlaying do
                task.wait()
            end
            u27:Add(u74:PlayTorusEffect())
        end))
        u10:PlayTakeoffCutscene()
    end))
    u27:Add(function() --[[Anonymous function at line 463]]
        --[[
        Upvalues:
            [1] = u12
        --]]
        u12:Activate("Blink")
    end)
    local u81 = u75.startedAt + 1 - workspace:GetServerTimeNow()
    if u81 > 0 then
        local u82 = u27:Add(Instance.new("ColorCorrectionEffect"))
        u82.Parent = workspace.CurrentCamera
        local u83 = u16(u82, TweenInfo.new(u81 * 0.5), {
            ["TintColor"] = Color3.new(0, 0, 0)
        })
        u27:Add(task.delay(u81, function() --[[Anonymous function at line 476]]
            --[[
            Upvalues:
                [1] = u83
                [2] = u16
                [3] = u82
                [4] = u81
                [5] = u10
            --]]
            u83:Cancel()
            u83:Destroy()
            u16(u82, TweenInfo.new(u81 * 0.5), {
                ["TintColor"] = Color3.new(1, 1, 1)
            })
            u10:PlayInitialCutscene()
        end))
    else
        u10:PlayInitialCutscene()
    end
end
function u10.OnStop(_) --[[Anonymous function at line 491]]
    --[[
    Upvalues:
        [1] = u27
    --]]
    u27:Destroy()
end
function u10.OnLoad(_) --[[Anonymous function at line 495]]
    --[[
    Upvalues:
        [1] = u2
        [2] = u1
    --]]
    task.spawn(pcall, function() --[[Anonymous function at line 496]]
        --[[
        Upvalues:
            [1] = u2
        --]]
        u2:PreloadAsync(script:GetChildren())
    end)
    task.spawn(pcall, function() --[[Anonymous function at line 500]]
        --[[
        Upvalues:
            [1] = u2
            [2] = u1
        --]]
        u2:PreloadAsync(u1.Sounds.Events["Phase 2: Galaxy Introduction"])
    end)
    task.wait(6)
end
return u10