--[[
  Extracted from: ReplicatedStorage.Controllers.EventController.Events.Sammyni Spyderini
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

game:GetService("ServerScriptService")
local v_u_1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("ContentProvider")
local v_u_3 = game:GetService("RunService")
game:GetService("Players")
local v_u_4 = game:GetService("Debris")
require(v_u_1.Shared.EventTypes)
local v5 = {}
local v_u_6 = require(v_u_1.Controllers.EffectController)
local v_u_7 = require(v_u_1.Controllers.AnimalController)
local v_u_8 = require(v_u_1.Controllers.SoundController)
local v_u_9 = require(v_u_1.Controllers.CycleController)
local v_u_10 = require(v_u_1.Controllers.EventController)
require(v_u_1.Controllers.EventController.ClientEventUtils)
local v_u_11 = require(v_u_1.Packages.CreateTween)
require(v_u_1.Shared.TweenPivot)
local v_u_12 = require(v_u_1.Packages.Observers)
require(v_u_1.Utils.MathUtils)
local v_u_13 = require(v_u_1.Packages.Trove)
local v14 = require(v_u_1.Packages.Net)
local v_u_15 = require(v_u_1.Shared.VFX)
require(v_u_1.Shared.Snapshot)
local v_u_16 = workspace.MapCenter
local v_u_17 = script.Name
local v_u_18 = v14:RemoteEvent((("EventService/%*/Burst"):format(v_u_17)))
local v_u_19 = v_u_13.new()
local v_u_20 = RaycastParams.new()
v_u_20.FilterType = Enum.RaycastFilterType.Include
v_u_20.FilterDescendantsInstances = { workspace.Map, workspace.Plots }
local function v_u_25(p21, p22)
    local v23 = workspace:Raycast(p21, Vector3.new(-0, -25, -0), v_u_20)
    if v23 then
        p21 = v23.Position
    end
    local v_u_24 = script.Hole:Clone()
    v_u_24.CFrame = CFrame.new(p21 + Vector3.new(0, 0.01, 0)) * CFrame.Angles(0, 0, 1.5707963267948966)
    v_u_24.Size = Vector3.new(0.01, 0.01, 0.01)
    v_u_24.Parent = workspace
    v_u_11(v_u_24, TweenInfo.new(0.75, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        ["Size"] = Vector3.new(0.01, 8, 8)
    })
    task.delay(p22, function()
        v_u_11(v_u_24, TweenInfo.new(0.75, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
            ["Size"] = Vector3.new(0.01, 0.01, 0.01)
        }).Completed:Wait()
        v_u_24:Destroy()
    end)
end
local function v_u_43()
    local v26 = v_u_19:Extend()
    local v_u_27 = table.create(4)
    v26:Add(function()
        table.clear(v_u_27)
    end)
    local v_u_28 = 0
    v26:Add(v_u_3.PreRender:Connect(function(p29)
        debug.profilebegin("Sammyni Spyderini Event")
        v_u_28 = v_u_28 + p29
        for v30, v31 in v_u_27 do
            if v31.target and v31.targetAttachment then
                v31.beam.First.Enabled = true
                v31.beam.Second.Enabled = true
                local v32 = v_u_28 - v30 + 1
                local v33 = math.clamp(v32, 0, 1)
                local v34 = v31.beam.WorldPosition
                v31.targetAttachment.Position = v34 + (v31.target:GetPivot().Position - v34) * v33
            end
        end
        debug.profileend()
    end))
    v26:Add(v_u_12.observeTag("SammyniSpyderiniPlayerVFX", function(p_u_35)
        local v_u_36 = script.PlayerVFX.Beam:Clone()
        v_u_36.Parent = p_u_35
        local v_u_37 = script.PlayerVFX.Torso:Clone()
        v_u_37.Parent = p_u_35
        local v_u_38 = p_u_35:GetAttribute("SammyniSpyderiniIndex")
        v_u_27[v_u_38] = {
            ["beam"] = v_u_36,
            ["target"] = nil
        }
        local v_u_42 = v_u_12.observeTag("SammyniSpyderiniPlayerVFX", function(p39)
            if p39 == p_u_35 then
                return nil
            end
            if p39:GetAttribute("SammyniSpyderiniIndex") ~= p_u_35:GetAttribute("SammyniSpyderiniIndex") % 4 + 1 then
                return nil
            end
            local v_u_40 = Instance.new("Attachment")
            v_u_40.Position = v_u_36.WorldPosition
            v_u_40.Parent = workspace.Terrain
            local v41 = v_u_27[p_u_35:GetAttribute("SammyniSpyderiniIndex")]
            v41.target = p39
            v41.beam.First.Attachment0 = v_u_40
            v41.beam.Second.Attachment0 = v_u_40
            v41.targetAttachment = v_u_40
            return function()
                v_u_40:Destroy()
            end
        end)
        return function()
            v_u_37:Destroy()
            v_u_36:Destroy()
            v_u_42()
            v_u_27[v_u_38] = nil
        end
    end))
end
function v5.OnStart(_)
    local v44 = v_u_10:GetActiveEventData(v_u_17)
    assert(v44)
    v_u_1:SetAttribute("SammyniSpyderiniEvent", true)
    v_u_19:Add(function()
        v_u_1:SetAttribute("SammyniSpyderiniEvent", nil)
        v_u_6:Activate("Blink")
        v_u_9:Update()
        v_u_8:UpdateOST()
        v_u_8:UpdateAmbience()
    end)
    v_u_19:Add(v_u_12.observeTag("SammyniSpyderini", function(p_u_45)
        local v46 = v_u_13.new()
        local v_u_47 = p_u_45:WaitForChild("HumanoidRootPart")
        local v48 = v46:Clone(script["Sammyni Spyderini"])
        local v49 = v46:Add(Instance.new("Weld"))
        v49.Part0 = v48.PrimaryPart
        v49.Part1 = v_u_47
        v49.C0 = CFrame.Angles(0, 3.141592653589793, 0)
        v49.Parent = v48.PrimaryPart
        v48.Parent = p_u_45
        local v50 = v48.AnimationController.Animator
        local v51 = v50:LoadAnimation(script.Idle)
        v51.Priority = Enum.AnimationPriority.Idle
        local v_u_52 = v50:LoadAnimation(script.Walk)
        v_u_52.Priority = Enum.AnimationPriority.Movement
        local v_u_53 = v50:LoadAnimation(script.Attack)
        local v_u_54 = v50:LoadAnimation(script.Ground)
        v_u_54.Looped = true
        local v_u_55 = v50:LoadAnimation(script.InitialGround)
        v_u_55.Looped = true
        local v_u_56 = v50:LoadAnimation(script.Jump)
        v51:Play()
        v46:Add(v_u_54:GetMarkerReachedSignal("Freeze"):Connect(function()
            v_u_54:AdjustSpeed(0)
        end))
        v46:Add(v_u_55:GetMarkerReachedSignal("Freeze"):Connect(function()
            v_u_55:AdjustSpeed(0)
        end))
        local v_u_57 = nil
        local function v58()
            if p_u_45:GetAttribute("InitialGround") then
                v_u_57 = true
                v_u_8:PlaySound(v_u_1.Sounds.Events["Sammyni Spyderini"].EnterHole, v_u_47.Position, false)
                v_u_25(v_u_47.Position, 1.5)
                if not v_u_55.IsPlaying then
                    v_u_55:Play()
                    return
                end
            else
                if p_u_45:GetAttribute("Ground") then
                    v_u_8:PlaySound(v_u_1.Sounds.Events["Sammyni Spyderini"].EnterHole, v_u_47.Position, false)
                    v_u_25(v_u_47.Position, 1.5)
                    if not v_u_54.IsPlaying then
                        if v_u_57 then
                            v_u_54.TimePosition = 0.6
                        end
                        v_u_54:Play(v_u_57 and 0 or nil)
                        if v_u_57 then
                            v_u_54.TimePosition = 0.6
                        end
                    end
                    v_u_57 = false
                    return
                end
                v_u_57 = false
                v_u_8:PlaySound(v_u_1.Sounds.Events["Sammyni Spyderini"].LeaveHole, v_u_47.Position, false)
                v_u_25(v_u_47.Position, 1.5)
                v_u_56:Play()
                v_u_54:Stop()
                v_u_55:Stop()
            end
        end
        v46:Add(task.defer(function()
            if p_u_45:GetAttribute("IsRunning") then
                v_u_52:Play()
            end
        end))
        v46:Add(p_u_45:GetAttributeChangedSignal("IsRunning"):Connect(function()
            if p_u_45:GetAttribute("IsRunning") then
                v_u_52:Play()
            else
                v_u_52:Stop()
            end
        end))
        if p_u_45:GetAttribute("Ground") and not v_u_54.IsPlaying then
            v_u_54.TimePosition = 0.6
            v_u_54:Play(0)
            v_u_54.TimePosition = 0.6
        end
        v46:Add(p_u_45:GetAttributeChangedSignal("Ground"):Connect(v58))
        v46:Add(p_u_45:GetAttributeChangedSignal("InitialGround"):Connect(v58))
        v46:Add(p_u_45:GetAttributeChangedSignal("AttackAnimation"):Connect(function()
            v_u_53:Play()
        end))
        return v46:WrapClean()
    end))
    local v_u_59 = v44.startedAt + 5 - workspace:GetServerTimeNow()
    v_u_19:Add(task.delay(v_u_59, function()
        if v_u_59 > 1 then
            v_u_8:PlaySound(v_u_1.Sounds.Events["Sammyni Spyderini"].Expanding, workspace.MapCenter.Position, false)
        end
        local v60 = v_u_19:Clone(script.Web_Main)
        for _, v61 in v60.Lines:GetChildren() do
            local v62 = v61.Size
            v61.Size = Vector3.new(0, 1, 1)
            v_u_11(v61, TweenInfo.new(v62.Magnitude / 150, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
                ["Size"] = v62
            })
        end
        for _, v_u_63 in v60:GetDescendants() do
            if not v_u_63:IsDescendantOf(v60.Lines) and v_u_63:IsA("BasePart") then
                local v64 = v_u_63.Size
                v_u_63.Size = Vector3.new(0, 1, 1)
                local v_u_65 = v_u_63.Transparency
                v_u_63.Transparency = 1
                local v66 = ((v_u_63.Position - v_u_16.Position) * Vector3.new(1, 0, 1)).Magnitude * 2 / 150
                task.delay(v66, function()
                    v_u_63.Transparency = v_u_65
                end)
                v_u_11(v_u_63, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0, false, v66), {
                    ["Size"] = v64
                })
            end
        end
        v60.Parent = workspace
        v_u_9:Update()
        v_u_8:UpdateOST()
        v_u_8:UpdateAmbience()
    end))
    v_u_19:Add(task.spawn(function()
        v_u_43()
    end))
end
function v5.OnStop(_)
    v_u_19:Destroy()
end
function v5.OnLoad(_)
    task.spawn(pcall, function()
        v_u_2:PreloadAsync(script:GetChildren())
    end)
    v_u_18.OnClientEvent:Connect(function(p67)
        local v68 = v_u_7:GetAnimals()[p67]
        if v68 then
            local v69 = v68.AnimalModel
            local v70 = v68.AnimalModel
            if v70 then
                v70 = v69.PrimaryPart
            end
            local v71 = v68.Instance
            local v72
            if v71 then
                v72 = v71.PrimaryPart
            else
                v72 = v71
            end
            if v72 and v70 then
                local v73 = v_u_19:Clone(script.Burst)
                v73:PivotTo(v72.CFrame * CFrame.new(0, (v73.Size.Y + v69:GetExtentsSize().Y) / 2, 0))
                v73.Parent = v71
                local v74 = Instance.new("WeldConstraint")
                v74.Part0 = v73
                v74.Part1 = v68.AnimalModel.PrimaryPart
                v74.Parent = v73
                v_u_15.emit(v73)
                v_u_4:AddItem(v73, 5)
                v_u_8:PlaySound(v_u_1.Sounds.Events["Sammyni Spyderini"].Hit, v72.CFrame.Position, false)
            end
        else
            return
        end
    end)
end
return v5