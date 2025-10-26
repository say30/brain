--[[
  Extracted from: ReplicatedStorage.Controllers.EventController.Events.10B Visits
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Thanks For Angelus Decompiles --> https://discord.gg/CYXme7yEG9

-- Decompiled with Velocity Script Decompiler
local v_u_1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("ContentProvider")
local v_u_3 = game:GetService("TweenService")
local v_u_4 = game:GetService("RunService")
game:GetService("Players")
game:GetService("Debris")
require(v_u_1.Shared.EventTypes)
local v5 = {}
local v_u_6 = require(v_u_1.Controllers.AnimalController)
local v_u_7 = require(v_u_1.Controllers.SoundController)
local v_u_8 = require(v_u_1.Controllers.EventController)
local v_u_9 = require(v_u_1.Controllers.CycleController)
local v_u_10 = require(v_u_1.Controllers.EventController.ClientEventUtils)
local v_u_11 = require(v_u_1.Shared.SharedEventUtils)
require(v_u_1.Packages.Synchronizer)
local v_u_12 = require(v_u_1.Shared.ShakePresets)
require(v_u_1.Packages.Observers)
local v_u_13 = require(v_u_1.Shared.TweenPivot)
local v_u_14 = require(v_u_1.Utils.MathUtils)
local v15 = require(v_u_1.Packages.Trove)
local v16 = require(v_u_1.Packages.Net)
local v_u_17 = require(v_u_1.Shared.VFX)
local v_u_18 = v16:RemoteEvent("EventService/10B Visits/CreateFirework")
local v_u_19 = v16:RemoteEvent("EventService/10B Visits/ExplodeTraitEffect")
local v_u_20 = script.Name
local v_u_21 = v15.new()
local v_u_22 = RaycastParams.new()
v_u_22.FilterType = Enum.RaycastFilterType.Include
v_u_22.FilterDescendantsInstances = { workspace.Map, workspace.Plots }
local v_u_23 = {}
function v5.OnStart(_)
    -- upvalues: (copy) v_u_8, (copy) v_u_20, (copy) v_u_1, (copy) v_u_21, (copy) v_u_7, (copy) v_u_9, (copy) v_u_12, (copy) v_u_3, (copy) v_u_13, (copy) v_u_18, (copy) v_u_23, (copy) v_u_17, (copy) v_u_22, (copy) v_u_4, (copy) v_u_10, (copy) v_u_11, (copy) v_u_14
    local v24 = v_u_8:GetActiveEventData(v_u_20)
    assert(v24)
    v_u_1:SetAttribute("10BVisitsEvent", true)
    v_u_21:Add(function()
        -- upvalues: (ref) v_u_1
        v_u_1:SetAttribute("10BVisitsEvent", nil)
    end)
    v_u_7:UpdateOST()
    v_u_9:Update()
    local v_u_25 = v_u_1.Models.Events["10B Visits"].Fireworks:Clone()
    v_u_25.Parent = workspace
    local v_u_26 = v_u_25:GetChildren()
    table.sort(v_u_26, function(p27, p28)
        local v29 = p27.Name
        local v30 = tonumber(v29)
        local v31 = p28.Name
        return v30 < tonumber(v31)
    end)
    local v_u_32 = {}
    for _, v33 in v_u_26 do
        v_u_32[v33] = v33.CFrame
    end
    local v_u_34 = v_u_12.BumpS:Clone()
    v_u_21:Add(v_u_34)
    v_u_34.Sustain = true
    v_u_21:Add(v_u_12.BindShakeToCamera(v_u_34, workspace.CurrentCamera))
    v_u_34:Start()
    v_u_21:Add(task.delay(v24.startedAt + 4 - workspace:GetServerTimeNow(), function()
        -- upvalues: (copy) v_u_34
        v_u_34:StopSustain()
    end))
    v_u_21:Add(function()
        -- upvalues: (copy) v_u_26, (ref) v_u_3, (copy) v_u_32, (copy) v_u_25
        for _, v35 in v_u_26 do
            local v36 = v_u_3
            local v37 = TweenInfo.new(1 + math.random() + math.random(), Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            local v38 = {}
            local v39 = v_u_32[v35]
            local v40 = v35.Size.Y * 1.1
            v38.CFrame = v39 - Vector3.new(0, v40, 0)
            v36:Create(v35, v37, v38):Play()
        end
        task.wait(3)
        v_u_25:Destroy()
    end)
    local v_u_41 = v_u_21:Clone(script.DroneRig)
    v_u_41.Parent = workspace
    local v_u_42 = v_u_41.AnimationController.Animator:LoadAnimation(script.DronesAnimation)
    v_u_42:Play(0, 1, 0.2)
    v_u_42:GetMarkerReachedSignal("TungFinished"):Once(function()
        -- upvalues: (copy) v_u_42
        v_u_42:AdjustSpeed(1)
    end)
    v_u_42:GetMarkerReachedSignal("Lower"):Once(function()
        -- upvalues: (ref) v_u_13, (copy) v_u_41
        v_u_13(v_u_41, TweenInfo.new(1), script.DroneRig:GetPivot() - Vector3.new(0, 100, 0)):Play()
    end)
    v_u_42:GetMarkerReachedSignal("Freeze"):Once(function()
        -- upvalues: (copy) v_u_42
        v_u_42:AdjustSpeed(0)
    end)
    local v_u_43 = {}
    for _, v44 in v_u_41:GetChildren() do
        if v44:IsA("BasePart") then
            table.insert(v_u_43, v44)
        end
    end
    v_u_21:Add(v_u_18.OnClientEvent:Connect(function(p45)
        -- upvalues: (ref) v_u_23, (copy) v_u_26, (copy) v_u_32, (ref) v_u_17, (ref) v_u_1, (ref) v_u_7, (ref) v_u_3, (copy) v_u_43, (ref) v_u_22, (ref) v_u_4, (ref) v_u_10, (ref) v_u_11, (ref) v_u_14
        for v46, v_u_47 in p45 do
            local v48 = script.Effects
            local v49 = v_u_47.FireworkEffect
            local v_u_50 = v48[tostring(v49)]
            local v_u_51 = ColorSequence.new(Color3.new(1, 1, 1))
            local v52 = v_u_50.specs["Embers [20]"]
            if v52 then
                v_u_51 = v52.Color
            end
            v_u_23[v46] = v_u_51
            local v53 = v_u_26[v_u_47.Chosen]
            local v_u_54 = script.Firework:Clone()
            v_u_54.CFrame = v_u_32[v53]
            v_u_54.Parent = workspace
            local v_u_55 = script.FireworkStartup:Clone()
            local v56 = v_u_32[v53]
            local v57 = v53.Size.Y * 0.5 - v_u_55.Size.Y * 0.5
            v_u_55.CFrame = v56 + Vector3.new(0, v57, 0)
            v_u_55.Parent = workspace
            v_u_17.emit(v_u_55)
            local v58 = v_u_1.Sounds.Events["10B Visits"]["Trail Sound Ball"]:Clone()
            v58.Parent = v_u_54
            v_u_7:PlaySound(v58)
            local v59 = v_u_1.Sounds.Events["10B Visits"].Shot:Clone()
            v59.Parent = v_u_55
            v_u_7:PlaySound(v59)
            task.delay(2, function()
                -- upvalues: (copy) v_u_55
                v_u_55:Destroy()
            end)
            local v60 = v_u_32[v53]
            local v61 = v53.Size.Y
            local v_u_62 = v60 - Vector3.new(0, v61, 0)
            local v63 = v_u_32[v53]
            local v64 = v_u_47.Height
            local v_u_65 = v63 + Vector3.new(0, v64, 0)
            local v66 = v_u_47.Height / 20
            local v_u_67 = v_u_3:Create(v_u_54, TweenInfo.new(v66, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                ["CFrame"] = v_u_65
            })
            v_u_67:Play()
            task.delay(v66 * 0.8, function()
                -- upvalues: (copy) v_u_67, (ref) v_u_7, (ref) v_u_1, (copy) v_u_65, (ref) v_u_51, (ref) v_u_43, (copy) v_u_50, (ref) v_u_17, (copy) v_u_54, (copy) v_u_47, (copy) v_u_62, (ref) v_u_22, (ref) v_u_4, (ref) v_u_10, (ref) v_u_11, (ref) v_u_14
                v_u_67:Destroy()
                v_u_7:PlaySound(v_u_1.Sounds.Events["10B Visits"]["Firework Explosion"], v_u_65.Position)
                local v68 = v_u_51.Keypoints[1].Value
                for _, v69 in v_u_43 do
                    v69.Color = v68
                end
                local v_u_70 = v_u_50:Clone()
                v_u_70.CFrame = v_u_65
                v_u_70.Parent = workspace
                v_u_17.emit(v_u_70)
                v_u_54:Destroy()
                task.delay(4, function()
                    -- upvalues: (copy) v_u_70
                    v_u_70:Destroy()
                end)
                for _, v_u_71 in v_u_47.Falloffs do
                    local v_u_72
                    if typeof(v_u_71) == "Vector3" then
                        v_u_72 = v_u_62 + v_u_71
                        local v73 = workspace:Raycast((v_u_65 + v_u_71).Position, Vector3.new(-0, -200, -0), v_u_22)
                        if v73 then
                            v_u_72 = CFrame.new(v73.Position)
                        end
                    else
                        v_u_72 = nil
                    end
                    local v_u_74 = script.Falloff:Clone()
                    v_u_74.CFrame = v_u_65
                    for _, v75 in v_u_74:GetDescendants() do
                        if v75:IsA("ParticleEmitter") then
                            v75.Color = v_u_51
                        end
                    end
                    v_u_74.Parent = workspace
                    local v_u_76 = 0
                    local v_u_77 = nil
                    v_u_77 = v_u_4.PostSimulation:Connect(function(p78)
                        -- upvalues: (ref) v_u_76, (ref) v_u_72, (copy) v_u_71, (ref) v_u_10, (ref) v_u_11, (copy) v_u_74, (ref) v_u_14, (ref) v_u_65, (ref) v_u_47, (ref) v_u_51, (ref) v_u_17, (ref) v_u_77
                        v_u_76 = v_u_76 + p78
                        local v79 = v_u_72
                        if not v79 then
                            local v80 = v_u_71
                            if type(v80) == "string" then
                                v79 = CFrame.new(v_u_10.getAnimalPosition(v_u_71, {
                                    ["top"] = true
                                }))
                            end
                        end
                        local v81 = v79 or CFrame.identity
                        local v82 = v_u_76 / 2.3
                        local v83 = v_u_11.pushPartCFrame
                        local v84 = v_u_74
                        local v85 = CFrame.new
                        local v86 = v_u_14.quadBezier
                        local v87 = v_u_65.Position
                        local v88 = v_u_65.Position
                        local v89 = v_u_47.Height
                        v83(v84, v85(v86(v82, v87, v88 + Vector3.new(0, v89, 0) + (v81.Position - v_u_65.Position) * Vector3.new(1, 0, 1) * 0.7, v81.Position)))
                        if v82 >= 1 then
                            local v90 = v_u_71
                            if type(v90) ~= "string" then
                                local v_u_91 = script.GroundImpact:Clone()
                                local v92 = v_u_91.Size.Y * 0.5
                                v_u_91.CFrame = v81 + Vector3.new(0, v92, 0)
                                for _, v93 in v_u_91:GetDescendants() do
                                    if v93:IsA("ParticleEmitter") then
                                        v93.Color = v_u_51
                                    end
                                end
                                v_u_91.Parent = workspace
                                v_u_17.emit(v_u_91)
                                v_u_17.disable(v_u_74)
                                task.delay(3, function()
                                    -- upvalues: (ref) v_u_74, (copy) v_u_91
                                    v_u_74:Destroy()
                                    v_u_91:Destroy()
                                end)
                                v_u_77:Disconnect()
                            end
                        end
                    end)
                end
            end)
        end
    end))
    local v94 = Random.new()
    for _, v95 in v_u_26 do
        local v96 = v_u_32[v95]
        local v97 = v95.Size.Y * 1.1
        v95.CFrame = v96 - Vector3.new(0, v97, 0)
        local v_u_98 = v_u_3:Create(v95, TweenInfo.new(v94:NextNumber(3, 7), Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            ["CFrame"] = v_u_32[v95]
        })
        local v_u_99 = v_u_21:Add(function()
            -- upvalues: (copy) v_u_98
            v_u_98:Cancel()
            v_u_98:Destroy()
        end)
        v_u_98.Completed:Once(function()
            -- upvalues: (ref) v_u_21, (copy) v_u_99
            v_u_21:Remove(v_u_99)
        end)
        v_u_98:Play()
    end
end
function v5.OnStop(_)
    -- upvalues: (copy) v_u_21, (copy) v_u_23
    v_u_21:Destroy()
    table.clear(v_u_23)
end
function v5.OnLoad(_)
    -- upvalues: (copy) v_u_2, (copy) v_u_19, (copy) v_u_6, (copy) v_u_10, (copy) v_u_17, (copy) v_u_7, (copy) v_u_1
    task.spawn(pcall, function()
        -- upvalues: (ref) v_u_2
        v_u_2:PreloadAsync(script:GetChildren())
    end)
    v_u_19.OnClientEvent:Connect(function(p100, p101)
        -- upvalues: (ref) v_u_6, (ref) v_u_10, (ref) v_u_17, (ref) v_u_7, (ref) v_u_1
        local v102 = v_u_6:GetAnimals()[p101]
        if v102 then
            local v103 = script.FireworkBurst:Clone()
            v103.CFrame = CFrame.new(v_u_10.getAnimalPosition(p101, {
                ["top"] = true
            }))
            v103.Anchored = false
            local v104 = ColorSequence.new(Color3.new(1, 1, 1))
            local v105 = script.Effects[tostring(p100)].specs["Embers [20]"]
            if v105 then
                v104 = v105.Color
            end
            for _, v106 in v103:GetDescendants() do
                if v106:IsA("ParticleEmitter") then
                    v106.Color = v104
                end
            end
            local v107 = Instance.new("WeldConstraint")
            v107.Part0 = v103
            v107.Part1 = v102.AnimalModel.PrimaryPart
            v107.Parent = v103
            v103.Parent = workspace
            v_u_17.emit(v103)
            v_u_7:PlaySound(v_u_1.Sounds.Events["10B Visits"]["Brainrot Hit"], v103.Position)
        end
    end)
end
return v5