--[[
  Extracted from: ReplicatedStorage.Controllers.EventController.Events.Bubblegum
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local v1 = game:GetService("ReplicatedStorage")
local u2 = game:GetService("CollectionService")
local u3 = game:GetService("TweenService")
game:GetService("RunService")
game:GetService("Lighting")
game:GetService("Players")
require(v1.Shared.EventTypes)
local v4 = {}
require(v1.Controllers.AnimalController)
local u5 = require(v1.Controllers.SoundController)
local u6 = require(v1.Controllers.EventController)
require(v1.Controllers.CycleController)
local u7 = require(v1.Utils.TimeUtils)
local v8 = require(v1.Packages.Trove)
local u9 = require(v1.Packages.Timer)
local v10 = require(v1.Packages.Net)
local u11 = require(v1.Shared.VFX)
local u12 = v10:RemoteEvent("EventService/Bubblegum/RollAnimation")
local u13 = v10:RemoteEvent("EventService/Bubblegum/EmitBurst")
local u14 = script.Name
local u15 = workspace.Events.Bubblegum.Machine
local u16 = u15.Tank.BillboardGui.DisplayText
local u17 = v8.new()
function v4.OnStart(_) --[[Anonymous function at line 35]]
    --[[
    Upvalues:
        [1] = u6
        [2] = u14
        [3] = u2
        [4] = u11
        [5] = u15
        [6] = u17
        [7] = u5
        [8] = u9
        [9] = u16
        [10] = u7
    --]]
    local u18 = u6:GetActiveEventData(u14)
    assert(u18)
    local u19 = {}
    for _, v20 in u2:GetTagged("BubbleGumProgress") do
        if v20:IsA("BasePart") and not u19[v20] then
            u19[v20] = {
                ["Position"] = v20.Position
            }
        end
    end
    u11.emit(u15.Vfx.Goal)
    u17:Add(task.spawn(function() --[[Anonymous function at line 47]]
        --[[
        Upvalues:
            [1] = u5
            [2] = u15
        --]]
        u5:PlaySound("Sounds.Sfx.Bubblegum Machine.Apply", u15.Goal.Position)
    end))
    u17:Add(task.spawn(function() --[[Anonymous function at line 51]]
        --[[
        Upvalues:
            [1] = u5
            [2] = u15
        --]]
        u5:PlaySound("Sounds.Sfx.Bubblegum Machine.Deactivation", u15.Goal.Position)
    end))
    u17:Add(u9.Simple(1, function() --[[Anonymous function at line 55]]
        --[[
        Upvalues:
            [1] = u18
            [2] = u16
            [3] = u7
            [4] = u19
        --]]
        local v21 = u18.endsAt - workspace:GetServerTimeNow()
        local v22 = math.max(v21, 0)
        u16.Text = u7:E(v22)
        if u19 then
            local v23 = v22 / 600
            local v24 = math.clamp(v23, 0, 1)
            local v25 = math.lerp(0, 7.3, v24)
            for v26, v27 in u19 do
                local v28 = (v25 - 7.3) / 2
                local v29 = v26.Size.X
                local v30 = v26.Size.Y
                v26.Size = Vector3.new(v29, v30, v25)
                v26.Position = v27.Position + Vector3.new(0, 0, 1) * v28
            end
        end
    end, true))
end
function v4.OnStop(_) --[[Anonymous function at line 74]]
    --[[
    Upvalues:
        [1] = u17
    --]]
    u17:Destroy()
end
function v4.OnLoad(_) --[[Anonymous function at line 78]]
    --[[
    Upvalues:
        [1] = u13
        [2] = u11
        [3] = u15
        [4] = u12
        [5] = u3
    --]]
    u13.OnClientEvent:Connect(function() --[[Anonymous function at line 79]]
        --[[
        Upvalues:
            [1] = u11
            [2] = u15
        --]]
        u11.emit(u15.Vfx.bubblegumburst)
    end)
    u12.OnClientEvent:Connect(function() --[[Anonymous function at line 83]]
        --[[
        Upvalues:
            [1] = u15
            [2] = u3
        --]]
        local u31 = Instance.new("NumberValue")
        for _, u32 in { u15.Circle1, u15.Circle2 } do
            u31.Changed:Connect(function(p33) --[[Anonymous function at line 87]]
                --[[
                Upvalues:
                    [1] = u32
                --]]
                u32.CFrame = CFrame.new(u32.CFrame.Position) * CFrame.Angles(0, -1.5707963267948966, p33)
            end)
        end
        local v34 = u3:Create(u31, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            ["Value"] = 6.283185307179586
        })
        v34.Completed:Once(function() --[[Anonymous function at line 96]]
            --[[
            Upvalues:
                [1] = u31
            --]]
            u31:Destroy()
        end)
        v34:Play()
    end)
end
return v4