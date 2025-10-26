--[[
  Extracted from: ReplicatedStorage.Controllers.EventController.Events.Rain
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local u1 = game:GetService("ReplicatedStorage")
game:GetService("TweenService")
game:GetService("RunService")
local u2 = game:GetService("Lighting")
game:GetService("Players")
require(u1.Shared.EventTypes)
local v3 = {}
local u4 = require(u1.Controllers.AnimalController)
require(u1.Controllers.EffectController)
local u5 = require(u1.Controllers.SoundController)
local u6 = require(u1.Controllers.EventController)
local u7 = require(u1.Controllers.CycleController)
require(u1.Shared.ShakePresets)
require(u1.Packages.Observers)
local v8 = require(u1.Packages.Trove)
local v9 = require(u1.Packages.Net)
local u10 = require(u1.Shared.VFX)
local u11 = script.Name
local u12 = v9:RemoteEvent("EventService/Rain/Hit")
local u13 = v8.new()
function v3.OnStart(_) --[[Anonymous function at line 28]]
    --[[
    Upvalues:
        [1] = u6
        [2] = u11
        [3] = u1
        [4] = u13
        [5] = u10
        [6] = u2
        [7] = u7
        [8] = u5
    --]]
    local v14 = u6:GetActiveEventData(u11)
    assert(v14)
    u1:SetAttribute("Rain", true)
    u13:Add(function() --[[Anonymous function at line 33]]
        --[[
        Upvalues:
            [1] = u1
        --]]
        u1:SetAttribute("Rain", nil)
    end)
    local v15 = v14.startedAt + 4 - workspace:GetServerTimeNow()
    local u16 = u13:Clone(script.RainWeather)
    u10.disable(u16)
    u16.Parent = workspace
    u13:Add(task.delay(v15, function() --[[Anonymous function at line 47]]
        --[[
        Upvalues:
            [1] = u2
            [2] = u13
            [3] = u10
            [4] = u16
        --]]
        local u17 = u2:FindFirstChild("Atmosphere")
        if u17 then
            u17.Parent = script
            u13:Add(function() --[[Anonymous function at line 51]]
                --[[
                Upvalues:
                    [1] = u17
                    [2] = u2
                --]]
                u17.Parent = u2
            end)
        end
        u13:Clone(script.AtmosphereRain).Parent = u2
        local u18 = u2:FindFirstChild("Cartoon")
        if u18 then
            u18.Parent = script
            u13:Add(function() --[[Anonymous function at line 61]]
                --[[
                Upvalues:
                    [1] = u18
                    [2] = u2
                --]]
                u18.Parent = u2
            end)
        end
        u13:Clone(script.SkyRain).Parent = u2
        u10.enable(u16)
    end))
    u7:Update()
    u5:UpdateOST()
    u5:UpdateAmbience()
end
function v3.OnStop(_) --[[Anonymous function at line 90]]
    --[[
    Upvalues:
        [1] = u13
    --]]
    u13:Destroy()
end
function v3.OnLoad(_) --[[Anonymous function at line 94]]
    --[[
    Upvalues:
        [1] = u12
        [2] = u4
        [3] = u5
        [4] = u1
        [5] = u10
    --]]
    u12.OnClientEvent:Connect(function(p19) --[[Anonymous function at line 95]]
        --[[
        Upvalues:
            [1] = u4
            [2] = u5
            [3] = u1
            [4] = u10
        --]]
        local v20
        if type(p19) == "string" then
            local v21 = u4:GetAnimals()[p19]
            if not v21 then
                return
            end
            local v22 = v21.AnimalModel
            local v23
            if v22.PrimaryPart then
                v23 = v22.PrimaryPart.CFrame
            else
                v23 = v22:GetPivot()
            end
            local v24 = v23.Position
            local v25 = v21.AnimalModel:GetExtentsSize().Y * 0.5
            v20 = v24 + Vector3.new(0, v25, 0)
            p19 = v21.AnimalModel.PrimaryPart
        else
            v20 = p19:GetPivot().Position
        end
        u5:PlaySound(u1.Sounds.Events.Rain.Burst, v20)
        local u26 = script.StruckVFX:Clone()
        u26:PivotTo(CFrame.new(v20))
        u26.Anchored = false
        local v27 = Instance.new("WeldConstraint")
        v27.Part0 = u26
        v27.Part1 = p19
        v27.Parent = u26
        u26.Parent = workspace
        u10.emit(u26)
        task.delay(3, function() --[[Anonymous function at line 139]]
            --[[
            Upvalues:
                [1] = u26
            --]]
            u26:Destroy()
        end)
    end)
end
return v3