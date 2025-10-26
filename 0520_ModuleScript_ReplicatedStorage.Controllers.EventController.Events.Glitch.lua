--[[
  Extracted from: ReplicatedStorage.Controllers.EventController.Events.Glitch
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Thanks For Angelus Decompiles --> https://discord.gg/CYXme7yEG9

-- Decompiled with Velocity Script Decompiler
local v_u_1 = game:GetService("RunService")
local v_u_2 = game:GetService("ReplicatedStorage")
game:GetService("ContentProvider")
require(v_u_2.Shared.EventTypes)
local v3 = {}
local v_u_4 = require(v_u_2.Controllers.AnimalController)
local v_u_5 = require(v_u_2.Controllers.SoundController)
local v_u_6 = require(v_u_2.Controllers.CycleController)
require(v_u_2.Packages.Synchronizer)
require(v_u_2.Packages.FFlags)
local v7 = require(v_u_2.Packages.Trove)
local v8 = require(v_u_2.Packages.Net)
local v_u_9 = require(v_u_2.Shared.VFX)
local v_u_10 = v8:RemoteEvent("EventService/Glitch/HoleEffect")
local _ = script.Name
local v_u_11 = CFrame.new(-410.752, -9.782, 59.406)
local v_u_12 = v7.new()
function v3.OnStart(_)
    -- upvalues: (copy) v_u_2, (copy) v_u_12, (copy) v_u_6, (copy) v_u_5
    Random.new()
    v_u_2:SetAttribute("GlitchEvent", true)
    v_u_12:Add(function()
        -- upvalues: (ref) v_u_2
        v_u_2:SetAttribute("GlitchEvent", nil)
    end)
    v_u_6:Update()
    v_u_5:UpdateOST()
end
function v3.OnStop(_)
    -- upvalues: (copy) v_u_12
    v_u_12:Destroy()
end
function v3.OnLoad(_)
    -- upvalues: (copy) v_u_10, (copy) v_u_4, (copy) v_u_11, (copy) v_u_5, (copy) v_u_1, (copy) v_u_9
    v_u_10.OnClientEvent:Connect(function(p13, p_u_14)
        -- upvalues: (ref) v_u_4, (ref) v_u_11, (ref) v_u_5, (ref) v_u_1, (ref) v_u_9
        local v15 = v_u_4:GetAnimals()[p13]
        if v15 then
            local v_u_16 = script.Hole:Clone()
            v_u_16:PivotTo(CFrame.new(v_u_11.X, v_u_11.Y + v_u_16.Size.Y * 0.5, v15.Instance:GetPivot().Z + v_u_16.Size.Z * 0.5))
            v_u_16.Parent = workspace
            task.spawn(function()
                -- upvalues: (ref) v_u_5, (copy) v_u_16
                v_u_5:PlaySound("Sounds.Events.Glitch.Hole", v_u_16:GetPivot().Position)
            end)
            local v_u_17 = v15.Instance
            local v_u_18 = v_u_17:GetPivot()
            local v_u_19 = nil
            v_u_19 = v_u_1.PostSimulation:Connect(function(_)
                -- upvalues: (copy) p_u_14, (ref) v_u_19, (copy) v_u_16, (ref) v_u_9, (copy) v_u_17, (copy) v_u_18
                local v20 = workspace:GetServerTimeNow() - p_u_14
                local v21
                if v20 < 0.15 then
                    v21 = 0
                elseif v20 < 1 then
                    local v22 = (v20 - 0.15) / 0.85
                    local v23 = math.clamp(v22, 0, 1)
                    v21 = -(v23 * v23 * 98.1)
                else
                    local v24 = (v20 - 1) / 0.5
                    local v25 = math.clamp(v24, 0, 1) * 0.4
                    v21 = 15.696000000000002 - v25 * v25 * 98.1
                end
                if v20 >= 1.5 then
                    v_u_19:Disconnect()
                    v_u_16:Destroy()
                elseif v20 >= 1 then
                    v_u_9.disable(v_u_16)
                end
                v_u_17:PivotTo(v_u_18 + Vector3.new(0, v21, 0))
            end)
        end
    end)
end
return v3