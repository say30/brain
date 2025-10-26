--[[
  Extracted from: ReplicatedStorage.Controllers.EventController.Events.Starfall
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Thanks For Angelus Decompiles --> https://discord.gg/CYXme7yEG9

-- Decompiled with Velocity Script Decompiler
local v_u_1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("TweenService")
local v_u_3 = game:GetService("Debris")
local v_u_4 = game:GetService("Lighting")
require(v_u_1.Shared.EventTypes)
local v5 = {}
local v6 = require(v_u_1.Packages.Net)
local v7 = require(v_u_1.Packages.Trove)
local v_u_8 = require(v_u_1.Shared.VFX)
local v9 = require(v_u_1.Packages.Shake)
local v_u_10 = require(v_u_1.Shared.ShakePresets)
local v_u_11 = require(v_u_1.Controllers.CycleController)
local v_u_12 = require(v_u_1.Controllers.SoundController)
local v_u_13 = require(v_u_1.Controllers.EventController)
local v_u_14 = require(v_u_1.Controllers.EffectController)
local v_u_15 = require(v_u_1.Controllers.AnimalController)
local v_u_16 = v6:RemoteEvent("EventService/Starfall/CreateStar")
local v_u_17 = v6:RemoteEvent("EventService/Starfall/ExplodeStar")
local v_u_18 = script.Name
local v_u_19 = v9.new()
v_u_19.Amplitude = 1.5
v_u_19.Frequency = 0.1
v_u_19.FadeInTime = 0
v_u_19.FadeOutTime = 0.6
v_u_19.PositionInfluence = Vector3.new(0.2, 0.2, 0.2)
v_u_19.RotationInfluence = Vector3.new(2.5, 0.5, 0.5)
local v_u_20 = v7.new()
local v_u_21 = {}
function v5.OnStart(_)
    -- upvalues: (copy) v_u_13, (copy) v_u_18, (copy) v_u_1, (copy) v_u_20, (copy) v_u_14, (copy) v_u_8, (copy) v_u_4, (copy) v_u_11, (copy) v_u_12
    local v22 = v_u_13:GetActiveEventData(v_u_18)
    assert(v22)
    v_u_1:SetAttribute("Starfall", true)
    v_u_20:Add(function()
        -- upvalues: (ref) v_u_1
        v_u_1:SetAttribute("Starfall", nil)
    end)
    v_u_20:Add(function()
        -- upvalues: (ref) v_u_14
        v_u_14:Activate("Blink")
    end)
    local v_u_23 = v_u_20:Clone(script.StarfallWeather)
    v_u_8.disable(v_u_23)
    v_u_23.Parent = workspace
    local v24 = v22.startedAt + 4 - workspace:GetServerTimeNow()
    v_u_20:Add(task.delay(v24, function()
        -- upvalues: (ref) v_u_14, (ref) v_u_4, (ref) v_u_20, (ref) v_u_8, (copy) v_u_23
        v_u_14:Activate("Blink")
        local v_u_25 = v_u_4:FindFirstChildOfClass("Atmosphere")
        if v_u_25 then
            v_u_25.Parent = script
            v_u_20:Add(function()
                -- upvalues: (copy) v_u_25, (ref) v_u_4
                v_u_25.Parent = v_u_4
            end)
        end
        v_u_20:Clone(script.Atmosphere).Parent = v_u_4
        local v_u_26 = v_u_4:FindFirstChildOfClass("Sky")
        if v_u_26 then
            v_u_26.Parent = script
            v_u_20:Add(function()
                -- upvalues: (copy) v_u_26, (ref) v_u_4
                v_u_26.Parent = v_u_4
            end)
        end
        v_u_20:Clone(script.Sky).Parent = v_u_4
        v_u_8.enable(v_u_23)
    end))
    v_u_11:Update()
    v_u_12:UpdateOST()
end
function v5.OnStop(_)
    -- upvalues: (copy) v_u_20, (copy) v_u_21
    v_u_20:Destroy()
    for _, v27 in v_u_21 do
        if v27.Tween then
            v27.Tween:Cancel()
        end
        if v27.Model then
            v27.Model:Destroy()
        end
    end
    table.clear(v_u_21)
end
function v5.OnLoad(_)
    -- upvalues: (copy) v_u_16, (copy) v_u_2, (copy) v_u_21, (copy) v_u_17, (copy) v_u_12, (copy) v_u_1, (copy) v_u_3, (copy) v_u_15, (copy) v_u_19, (copy) v_u_20, (copy) v_u_10
    v_u_16.OnClientEvent:Connect(function(p_u_28, p29, p30, p31)
        -- upvalues: (ref) v_u_2, (ref) v_u_21
        local v32 = script.Meteor:Clone()
        v32:PivotTo(CFrame.new(p29))
        v32.Parent = workspace
        local v33 = v32.PrimaryPart
        if v33 then
            local v34 = v_u_2:Create(v33, TweenInfo.new(p31, Enum.EasingStyle.Linear), {
                ["CFrame"] = CFrame.lookAt(p30, p29)
            })
            v34:Play()
            v_u_21[p_u_28] = {
                ["Model"] = v32,
                ["Tween"] = v34
            }
            v34.Completed:Once(function()
                -- upvalues: (ref) v_u_21, (copy) p_u_28
                if v_u_21[p_u_28] then
                    v_u_21[p_u_28].Tween = nil
                end
            end)
        else
            warn("Starfall meteor model is missing a PrimaryPart!")
            v32:Destroy()
        end
    end)
    v_u_17.OnClientEvent:Connect(function(p35, p_u_36, p37)
        -- upvalues: (ref) v_u_21, (ref) v_u_12, (ref) v_u_1, (ref) v_u_3, (ref) v_u_15, (ref) v_u_19, (ref) v_u_20, (ref) v_u_10
        local v38 = v_u_21[p35]
        if v38 then
            task.spawn(function()
                -- upvalues: (ref) v_u_12, (ref) v_u_1, (copy) p_u_36
                v_u_12:PlaySound(v_u_1.Sounds.Events.Starfall.Impact, p_u_36)
            end)
            if v38.Tween then
                v38.Tween:Cancel()
            end
            if v38.Model then
                local v39 = v38.Model
                for _, v40 in v39:GetDescendants() do
                    if v40:IsA("ParticleEmitter") then
                        v40.Enabled = false
                    elseif v40:IsA("BasePart") then
                        v40.Transparency = 1
                    end
                end
                v_u_3:AddItem(v39, 3)
            end
            v_u_21[p35] = nil
        end
        if p37 then
            local v41 = v_u_15:GetAnimals()[p37]
            if v41 then
                local v42 = v41.AnimalModel.PrimaryPart
                local v43 = v41.AnimalModel
                local v44
                if v43.PrimaryPart then
                    v44 = v43.PrimaryPart.CFrame
                else
                    v44 = v43:GetPivot()
                end
                local v45 = v44.Position
                local v46 = v41.AnimalModel:GetExtentsSize().Y * 0.5
                local v_u_47 = v45 + Vector3.new(0, v46, 0)
                task.spawn(function()
                    -- upvalues: (ref) v_u_12, (ref) v_u_1, (ref) v_u_47
                    v_u_12:PlaySound(v_u_1.Sounds.Events.Starfall.BrainrotHit, v_u_47)
                end)
                local v48 = script.StruckVFX:Clone()
                v48:PivotTo(CFrame.new(v_u_47))
                v48.Anchored = false
                local v49 = Instance.new("WeldConstraint")
                v49.Part0 = v48
                v49.Part1 = v42
                v49.Parent = v48
                v48.Parent = workspace
                for _, v_u_50 in v48:GetDescendants() do
                    if v_u_50:IsA("ParticleEmitter") then
                        task.delay(v_u_50:GetAttribute("EmitDelay") or 0, function()
                            -- upvalues: (copy) v_u_50
                            v_u_50:Emit(v_u_50:GetAttribute("EmitCount"))
                        end)
                    end
                end
                v_u_3:AddItem(v48, 5)
            end
        else
            local v51 = script.Explosion:Clone()
            v51:PivotTo(CFrame.new(p_u_36))
            v51.Parent = workspace
            for _, v_u_52 in v51:GetDescendants() do
                if v_u_52:IsA("ParticleEmitter") then
                    task.delay(v_u_52:GetAttribute("EmitDelay") or 0, function()
                        -- upvalues: (copy) v_u_52
                        v_u_52:Emit(v_u_52:GetAttribute("EmitCount") or 1)
                    end)
                end
            end
            v_u_3:AddItem(v51, 5)
            local v53 = (workspace.CurrentCamera.CFrame.Position - p_u_36).Magnitude
            if v53 <= 150 then
                local v54 = v_u_19:Clone()
                local v55 = 1 - v53 / 150
                local v56 = math.pow(v55, 2)
                v54.Amplitude = v54.Amplitude * v56
                v54.RotationInfluence = v54.RotationInfluence * v56
                v_u_20:Add(v_u_10.BindShakeToCamera(v54))
                v54:Start()
            end
            return
        end
    end)
end
return v5