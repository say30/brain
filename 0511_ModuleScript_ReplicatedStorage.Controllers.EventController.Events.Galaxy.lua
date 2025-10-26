--[[
  Extracted from: ReplicatedStorage.Controllers.EventController.Events.Galaxy
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local v1 = game:GetService("ReplicatedStorage")
game:GetService("TweenService")
local u2 = game:GetService("RunService")
local u3 = game:GetService("Lighting")
game:GetService("Players")
require(v1.Shared.EventTypes)
local v4 = {}
local u5 = require(v1.Controllers.EffectController)
local u6 = require(v1.Controllers.SoundController)
local u7 = require(v1.Controllers.EventController)
local u8 = require(v1.Controllers.CycleController)
local u9 = require(v1.Packages.Observers)
local v10 = require(v1.Packages.Trove)
local u11 = script.Name
local u12 = v1.Models.Events.UFO.UFO
local u13 = v10.new()
function v4.OnStart(_) --[[Anonymous function at line 55]]
    --[[
    Upvalues:
        [1] = u7
        [2] = u11
        [3] = u3
        [4] = u13
        [5] = u5
        [6] = u8
        [7] = u6
        [8] = u9
        [9] = u12
        [10] = u2
    --]]
    local v14 = u7:GetActiveEventData(u11)
    assert(v14)
    local u15 = u3:FindFirstChild("Atmosphere")
    if u15 then
        u15.Parent = script
        u13:Add(function() --[[Anonymous function at line 62]]
            --[[
            Upvalues:
                [1] = u15
                [2] = u3
            --]]
            u15.Parent = u3
        end)
    end
    u13:Clone(script.AtmosphereGalaxy).Parent = u3
    local u16 = u3:FindFirstChild("Cartoon")
    if u16 then
        u16.Parent = script
        u13:Add(function() --[[Anonymous function at line 71]]
            --[[
            Upvalues:
                [1] = u16
                [2] = u3
            --]]
            u16.Parent = u3
        end)
    end
    u13:Clone(script.SkyGalaxy).Parent = u3
    u5:Run("GalaxyEvent", "GrassRecolor")
    u13:Add(function() --[[Anonymous function at line 78]]
        --[[
        Upvalues:
            [1] = u5
        --]]
        u5:Stop("GalaxyEvent", "GrassRecolor")
    end)
    u5:Run("GalaxyEvent", "WallRecolor")
    u13:Add(function() --[[Anonymous function at line 83]]
        --[[
        Upvalues:
            [1] = u5
        --]]
        u5:Stop("GalaxyEvent", "WallRecolor")
    end)
    u13:Clone(script.GalaxyMap).Parent = workspace
    local u17 = script.GalaxyWeather:Clone()
    u17.Parent = workspace
    u13:Add(function() --[[Anonymous function at line 91]]
        --[[
        Upvalues:
            [1] = u17
        --]]
        for _, v18 in u17:GetDescendants() do
            if v18:IsA("ParticleEmitter") then
                v18.Enabled = false
            end
        end
        task.wait(4)
        u17:Destroy()
    end)
    u8:Update()
    u6:UpdateOST()
    local u19 = u13:Extend()
    u19:Add(u9.observeTag("GalaxyUFO", function(u20) --[[Anonymous function at line 26]]
        --[[
        Upvalues:
            [1] = u19
            [2] = u12
            [3] = u2
        --]]
        if not u20:IsA("BasePart") then
            return nil
        end
        local u21 = u19:Extend()
        local u22 = u21:Clone(u12)
        for _, v23 in u22:GetDescendants() do
            if v23:IsA("BasePart") then
                v23.Anchored = true
            end
        end
        u22.Parent = workspace
        u21:Add(u2.PostSimulation:Connect(function() --[[Anonymous function at line 41]]
            --[[
            Upvalues:
                [1] = u22
                [2] = u20
                [3] = u21
            --]]
            if u22.PrimaryPart and u20.Parent then
                u22:PivotTo(u20.CFrame)
            else
                u21:Destroy()
            end
        end))
        return function() --[[Anonymous function at line 49]]
            --[[
            Upvalues:
                [1] = u21
            --]]
            u21:Destroy()
        end
    end))
end
function v4.OnStop(_) --[[Anonymous function at line 107]]
    --[[
    Upvalues:
        [1] = u13
    --]]
    u13:Destroy()
end
function v4.OnLoad(_) --[[Anonymous function at line 111]] end
return v4