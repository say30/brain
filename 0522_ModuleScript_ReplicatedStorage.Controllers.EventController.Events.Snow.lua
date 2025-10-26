--[[
  Extracted from: ReplicatedStorage.Controllers.EventController.Events.Snow
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local u1 = game:GetService("ReplicatedStorage")
local u2 = game:GetService("CollectionService")
local u3 = game:GetService("TweenService")
game:GetService("RunService")
local u4 = game:GetService("Lighting")
game:GetService("Players")
require(u1.Shared.EventTypes)
local v5 = {}
local u6 = require(u1.Controllers.AnimalController)
local u7 = require(u1.Controllers.EffectController)
local u8 = require(u1.Controllers.SoundController)
local u9 = require(u1.Controllers.EventController)
local u10 = require(u1.Controllers.CycleController)
require(u1.Shared.ShakePresets)
require(u1.Packages.Observers)
local v11 = require(u1.Packages.Trove)
local v12 = require(u1.Packages.Net)
local u13 = require(u1.Shared.VFX)
local u14 = script.Name
local u15 = v12:RemoteEvent("EventService/Snow/Hit")
local u16 = v11.new()
function v5.OnStart(_) --[[Anonymous function at line 29]]
    --[[
    Upvalues:
        [1] = u9
        [2] = u14
        [3] = u1
        [4] = u16
        [5] = u13
        [6] = u4
        [7] = u7
        [8] = u10
        [9] = u8
    --]]
    local v17 = u9:GetActiveEventData(u14)
    assert(v17)
    u1:SetAttribute("Snow", true)
    u16:Add(function() --[[Anonymous function at line 38]]
        --[[
        Upvalues:
            [1] = u1
        --]]
        u1:SetAttribute("Snow", nil)
    end)
    local v18 = v17.startedAt + 4 - workspace:GetServerTimeNow()
    local u19 = u16:Clone(script.SnowWeather)
    u13.disable(u19)
    u19.Parent = workspace
    u16:Add(task.delay(v18, function() --[[Anonymous function at line 52]]
        --[[
        Upvalues:
            [1] = u4
            [2] = u16
            [3] = u13
            [4] = u19
        --]]
        local u20 = u4:FindFirstChild("Atmosphere")
        if u20 then
            u20.Parent = script
            u16:Add(function() --[[Anonymous function at line 56]]
                --[[
                Upvalues:
                    [1] = u20
                    [2] = u4
                --]]
                u20.Parent = u4
            end)
        end
        u16:Clone(script.AtmosphereSnow).Parent = u4
        local u21 = u4:FindFirstChild("Cartoon")
        if u21 then
            u21.Parent = script
            u16:Add(function() --[[Anonymous function at line 66]]
                --[[
                Upvalues:
                    [1] = u21
                    [2] = u4
                --]]
                u21.Parent = u4
            end)
        end
        u16:Clone(script.SkySnow).Parent = u4
        u13.enable(u19)
    end))
    u7:Run("Snow", "GrassRecolor")
    u16:Add(function() --[[Anonymous function at line 77]]
        --[[
        Upvalues:
            [1] = u7
        --]]
        u7:Stop("Snow", "GrassRecolor")
    end)
    u10:Update()
    u8:UpdateOST()
    -- u8:UpdateAmbience()
end
function v5.OnStop(_) --[[Anonymous function at line 86]]
    --[[
    Upvalues:
        [1] = u16
    --]]
    u16:Destroy()
end
function v5.OnLoad(_) --[[Anonymous function at line 90]]
    --[[
    Upvalues:
        [1] = u15
        [2] = u6
        [3] = u8
        [4] = u1
        [5] = u3
        [6] = u16
        [7] = u2
    --]]
    u15.OnClientEvent:Connect(function(p22) --[[Anonymous function at line 91]]
        --[[
        Upvalues:
            [1] = u6
            [2] = u8
            [3] = u1
        --]]
        local v23
        if type(p22) == "string" then
            local v24 = u6:GetAnimals()[p22]
            if not v24 then
                return
            end
            local v25 = v24.AnimalModel
            local v26
            if v25.PrimaryPart then
                v26 = v25.PrimaryPart.CFrame
            else
                v26 = v25:GetPivot()
            end
            local v27 = v26.Position
            local v28 = v24.AnimalModel:GetExtentsSize().Y * 0.5
            v23 = v27 + Vector3.new(0, v28, 0)
            p22 = v24.AnimalModel.PrimaryPart
        else
            v23 = p22:GetPivot().Position
        end
        u8:PlaySound(u1.Sounds.Events.Snow.Burst, v23)
        local v29 = script.StruckVFX:Clone()
        v29:PivotTo(CFrame.new(v23))
        v29.Anchored = false
        local v30 = Instance.new("WeldConstraint")
        v30.Part0 = v29
        v30.Part1 = p22
        v30.Parent = v29
        v29.Parent = workspace
        for _, u31 in v29:GetDescendants() do
            if u31:IsA("ParticleEmitter") then
                task.delay(u31:GetAttribute("EmitDelay") or 0, function() --[[Anonymous function at line 135]]
                    --[[
                    Upvalues:
                        [1] = u31
                    --]]
                    u31:Emit(u31:GetAttribute("EmitCount"))
                end)
            end
        end
    end)
    local function u38(u32) --[[Anonymous function at line 142]]
        --[[
        Upvalues:
            [1] = u3
        --]]
        task.wait(math.random() * 0.8)
        local u33 = u32:GetPivot() * CFrame.new(0, 10, 0)
        local u34 = Instance.new("CFrameValue")
        u34.Value = u32:GetPivot()
        local u36 = u34.Changed:Connect(function(p35) --[[Anonymous function at line 150]]
            --[[
            Upvalues:
                [1] = u32
            --]]
            u32:PivotTo(p35)
        end)
        local v37 = u3:Create(u34, TweenInfo.new(1.2), {
            ["Value"] = u33
        })
        v37:Play()
        v37.Completed:Connect(function() --[[Anonymous function at line 159]]
            --[[
            Upvalues:
                [1] = u36
                [2] = u34
                [3] = u32
                [4] = u33
            --]]
            u36:Disconnect()
            u34:Destroy()
            u32:PivotTo(u33)
        end)
    end
    u16:Add(u2:GetInstanceAddedSignal("SnowPile"):Connect(function(p39) --[[Anonymous function at line 174]]
        --[[
        Upvalues:
            [1] = u38
        --]]
        if p39:IsA("Model") then
            task.spawn(u38, p39)
        end
    end))
    for _, v40 in u2:GetTagged("SnowPile") do
        if v40:IsA("Model") then
            task.spawn(u38, v40)
        end
    end
end
return v5