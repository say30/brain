--[[
  Extracted from: ReplicatedStorage.Controllers.EventController.Events.Phase 5: Sammy Snap
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

game:GetService("ServerScriptService")
local u1 = game:GetService("ReplicatedStorage")
local u2 = game:GetService("ContentProvider")
game:GetService("TweenService")
local u3 = game:GetService("SoundService")
local u4 = game:GetService("HttpService")
local u5 = game:GetService("StarterGui")
local u6 = game:GetService("RunService")
game:GetService("Lighting")
local u7 = game:GetService("Players")
game:GetService("Debris")
require(u1.Shared.EventTypes)
local v8 = {}
local u9 = require(u1.Controllers.SkullEmojiEffectController)
local u10 = require(u1.Controllers.CharacterController)
local u11 = require(u1.Controllers.EffectController)
require(u1.Controllers.AnimalController)
require(u1.Controllers.SoundController)
require(u1.Controllers.CycleController)
local u12 = require(u1.Controllers.EventController)
require(u1.Controllers.EventController.ClientEventUtils)
require(u1.Shared.SharedEventUtils)
local u13 = require(u1.Packages.Serialization)
require(u1.Packages.CreateTween)
require(u1.Shared.ShakePresets)
local u14 = require(u1.Packages.TopbarPlus)
local u15 = require(u1.Packages.Observers)
local u16 = require(u1.Packages.Moonlite)
require(u1.Utils.MathUtils)
local u17 = require(u1.Packages.Squash)
require(u1.Packages.Shake)
local v18 = require(u1.Packages.Trove)
require(u1.Packages.Net)
require(u1.Packages.Spr)
local u19 = require(u1.Shared.VFX)
local u20 = workspace.RenderedMovingAnimals
local u21 = script.Name
local u22 = v18.new()
function v8.OnStart(_) --[[Anonymous function at line 54]]
    --[[
    Upvalues:
        [1] = u12
        [2] = u21
        [3] = u22
        [4] = u14
        [5] = u5
        [6] = u10
        [7] = u3
        [8] = u1
        [9] = u15
        [10] = u20
        [11] = u7
        [12] = u13
        [13] = u17
        [14] = u4
        [15] = u16
        [16] = u6
        [17] = u9
        [18] = u19
        [19] = u11
    --]]
    local v23 = u12:GetActiveEventData(u21)
    assert(v23)
    local u24 = u22:Extend()
    local u25 = u24:Clone(script.Cutscene.Assets)
    local u26 = workspace.CurrentCamera
    u26.CameraType = Enum.CameraType.Scriptable
    task.spawn(pcall, function() --[[Anonymous function at line 69]]
        --[[
        Upvalues:
            [1] = u14
            [2] = u5
        --]]
        pcall(u14.setTopbarEnabled, false)
        u5:SetCore("TopbarEnabled", false)
        u5:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
    end)
    u24:Add(function() --[[Anonymous function at line 75]]
        --[[
        Upvalues:
            [1] = u26
            [2] = u10
            [3] = u14
            [4] = u5
        --]]
        task.wait()
        u26.CameraType = Enum.CameraType.Custom
        local _, v27 = u10:GetCharacter()
        u26.CameraSubject = v27
        u26.FieldOfView = 70
        task.spawn(pcall, function() --[[Anonymous function at line 83]]
            --[[
            Upvalues:
                [1] = u14
                [2] = u5
            --]]
            pcall(u14.setTopbarEnabled, true)
            u5:SetCore("TopbarEnabled", true)
            u5:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)
        end)
    end)
    u3.Cutscene.Volume = 0
    u24:Add(function() --[[Anonymous function at line 91]]
        --[[
        Upvalues:
            [1] = u3
        --]]
        u3.Cutscene.Volume = 1
    end)
    u1.Sounds.Events["Phase 5: Sammy Snap"].Walk:Play()
    u25.Parent = workspace
    u24:Add(u15.observeCharacters(function(_, u28) --[[Anonymous function at line 100]]
        --[[
        Upvalues:
            [1] = u1
        --]]
        u28.Parent = u1
        return function() --[[Anonymous function at line 102]]
            --[[
            Upvalues:
                [1] = u28
                [2] = u1
            --]]
            if u28.Parent == u1 then
                u28.Parent = workspace
            end
        end
    end))
    for _, u29 in u20:GetChildren() do
        u29.Parent = u1
        u24:Add(function() --[[Anonymous function at line 112]]
            --[[
            Upvalues:
                [1] = u29
                [2] = u1
                [3] = u20
            --]]
            if u29.Parent == u1 then
                u29.Parent = u20
            end
        end)
    end
    u24:Add(u15.observeChildren(u7.LocalPlayer.PlayerGui, function(u30) --[[Anonymous function at line 120]]
        if not u30:IsA("LayerCollector") then
            return nil
        end
        if u30:GetAttribute("ShowInCutscene") then
            return nil
        end
        local u31 = u30.Enabled
        u30.Enabled = false
        return function() --[[Anonymous function at line 131]]
            --[[
            Upvalues:
                [1] = u30
                [2] = u31
            --]]
            if u30.Enabled ~= u31 then
                u30.Enabled = u31
            end
        end
    end))
    local v32 = u13.des(u17.frombuffer(u4:JSONDecode(require(script.Cutscene))))
    local u33 = u16.CreatePlayer(v32, u25)
    u33:ReplaceElementByPath("game.CurrentCamera", u26)
    u33.TimePosition = 11.17 - (v23.startedAt + 11.17 - workspace:GetServerTimeNow())
    u33.Looped = false
    local u34 = false
    u24:Add(u6.PostSimulation:Connect(function(_) --[[Anonymous function at line 152]]
        --[[
        Upvalues:
            [1] = u33
            [2] = u25
            [3] = u34
            [4] = u1
        --]]
        local v35
        if u33.TimePosition < 5 then
            local v36 = u33.TimePosition * 0.75 - 1
            v35 = math.clamp(v36, 1, 6)
        else
            v35 = 1
        end
        u25["SAMMY ENTRANCE CUTSCENE"].SpyderSammy:ScaleTo(v35)
        if u33.TimePosition >= 5 and not u34 then
            u34 = true
            u1.Sounds.Events["Phase 5: Sammy Snap"].Fire:Play()
        end
    end))
    u24:Add(task.delay(v23.startedAt + 10 - workspace:GetServerTimeNow(), function() --[[Anonymous function at line 162]]
        --[[
        Upvalues:
            [1] = u9
        --]]
        u9:Play(2.5, "Lower")
    end))
    u24:Add(task.delay(v23.startedAt + 10 - workspace:GetServerTimeNow(), function() --[[Anonymous function at line 166]]
        --[[
        Upvalues:
            [1] = u1
            [2] = u25
            [3] = u24
            [4] = u19
        --]]
        u1.Sounds.Events["Phase 5: Sammy Snap"].Snap:Play()
        local v37 = u25["SAMMY ENTRANCE CUTSCENE"].SpyderSammywdwadwawa.LeftHand
        local v38 = u24:Clone(script.Snap)
        v38.CFrame = v37.CFrame
        v38.Parent = workspace
        local v39 = Instance.new("Weld")
        v39.Part0 = v38
        v39.Part1 = v37
        v39.Parent = v38
        u19.emit(v38)
    end))
    u24:Add(task.delay(v23.startedAt + 10.5 - workspace:GetServerTimeNow(), function() --[[Anonymous function at line 183]]
        --[[
        Upvalues:
            [1] = u33
        --]]
        u33.FrameRate = 0.0001
        u33.TimePosition = 6300000
    end))
    u24:Add(task.delay(v23.startedAt + 12 - workspace:GetServerTimeNow(), function() --[[Anonymous function at line 188]]
        --[[
        Upvalues:
            [1] = u9
            [2] = u11
            [3] = u33
        --]]
        u9:Stop()
        u11:Activate("Blink")
        u33:Stop()
    end))
    u24:Add(function() --[[Anonymous function at line 194]]
        --[[
        Upvalues:
            [1] = u33
        --]]
        u33:Stop()
        u33:Destroy()
    end)
    u33:Compile()
    u33:Play()
    u24:Add(u33.Completed:Once(function() --[[Anonymous function at line 201]]
        --[[
        Upvalues:
            [1] = u24
        --]]
        u24:Destroy()
    end))
end
function v8.OnStop(_) --[[Anonymous function at line 206]]
    --[[
    Upvalues:
        [1] = u22
    --]]
    u22:Destroy()
end
function v8.OnLoad(_) --[[Anonymous function at line 210]]
    --[[
    Upvalues:
        [1] = u2
        [2] = u1
    --]]
    task.spawn(pcall, function() --[[Anonymous function at line 211]]
        --[[
        Upvalues:
            [1] = u2
        --]]
        u2:PreloadAsync(script:GetChildren())
    end)
    task.spawn(pcall, function() --[[Anonymous function at line 215]]
        --[[
        Upvalues:
            [1] = u2
            [2] = u1
        --]]
        u2:PreloadAsync(u1.Models.Events["Phase 4: Mygame43"])
    end)
end
return v8