--[[
  Extracted from: ReplicatedStorage.Controllers.EventController.Events.Strawberry
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local v_u_1 = game:GetService("ReplicatedStorage")
game:GetService("RunService")
local v_u_2 = game:GetService("Lighting")
local v_u_3 = game:GetService("Debris")
require(v_u_1.Shared.EventTypes)
local v4 = {}
local v_u_5 = require(v_u_1.Controllers.EffectController)
local v_u_6 = require(v_u_1.Controllers.AnimalController)
local v_u_7 = require(v_u_1.Controllers.EventController)
local v_u_8 = require(v_u_1.Controllers.SoundController)
local v_u_9 = require(v_u_1.Packages.CreateTween)
local v10 = require(v_u_1.Packages.Trove)
local v11 = require(v_u_1.Packages.Net)
local v_u_12 = require(v_u_1.Shared.VFX)
local v_u_13 = script.Name
local v_u_14 = v11:RemoteEvent((("EventService/%*/Burst"):format(v_u_13)))
local v_u_15 = v10.new()
local function v_u_47(p16, p17, p_u_18)
    local function v34(p_u_19, p_u_20, p_u_21, p22)
        local v_u_23 = p_u_19.CFrame
        local v24 = p22 and 0 or p_u_20.X
        local v25 = p22 and 0 or p_u_20.Z
        local v26 = Vector3.new(v24, 0, v25)
        local v27 = v_u_23 * CFrame.new(0, -(p_u_20.Y - v26.Y) / 2, 0)
        p_u_19.Size = v26
        p_u_19.CFrame = v27
        local v_u_28 = p_u_19.Transparency
        p_u_19.Transparency = 1
        local v29 = v_u_15
        local v30 = task.delay
        local v31
        if p_u_18 then
            v31 = p_u_18(p_u_21)
        else
            v31 = p_u_21
        end
        v29:Add(v30(v31, function()
            p_u_19.Transparency = v_u_28
            local v32 = not p_u_18 and 1 or p_u_18(p_u_21 + 1)
            local v33 = TweenInfo.new(v32, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
            v_u_9(p_u_19, v33, {
                ["Size"] = p_u_20
            })
            v_u_9(p_u_19, v33, {
                ["CFrame"] = v_u_23
            })
        end))
    end
    local v35 = {}
    local v36 = (1 / 0)
    local v37 = (-1 / 0)
    for _, v38 in p16:GetDescendants() do
        if v38:IsA("BasePart") and v38.Transparency < 1 then
            table.insert(v35, v38)
            local v39 = v38.Position.Y
            v36 = math.min(v36, v39)
            local v40 = v38.Position.Y
            v37 = math.max(v37, v40)
        end
    end
    table.sort(v35, function(p41, p42)
        return p41.Position.Y < p42.Position.Y
    end)
    local v43 = v37 - v36
    for _, v44 in v35 do
        local v45 = (v44.Position.Y - v36) / v43 * p17 + 0.25
        local v46 = v44:FindFirstAncestorOfClass("Model").Name == "strawberry"
        if v46 then
            v45 = v45 + 1
        end
        v34(v44, v44.Size, v45, v46)
    end
end
function v4.OnStart(_)
    local v_u_48 = v_u_7:GetActiveEventData(v_u_13)
    assert(v_u_48)
    v_u_1:SetAttribute("StrawberryEvent", true)
    v_u_15:Add(function()
        v_u_1:SetAttribute("StrawberryEvent", nil)
    end)
    v_u_5:Activate("Blink")
    v_u_5:Run("StrawberryEvent", "GrassRecolor")
    v_u_15:Add(function()
        v_u_5:Stop("StrawberryEvent", "GrassRecolor")
        v_u_5:Activate("Blink")
    end)
    local v_u_49 = v_u_2:FindFirstChild("Atmosphere")
    if v_u_49 then
        v_u_49.Parent = script
        v_u_15:Add(function()
            v_u_49.Parent = v_u_2
        end)
    end
    v_u_15:Clone(script.Atmosphere).Parent = v_u_2
    local v_u_50 = v_u_2:FindFirstChildOfClass("Sky")
    if v_u_50 then
        v_u_50.Parent = script
        v_u_15:Add(function()
            v_u_50.Parent = v_u_2
        end)
    end
    v_u_15:Clone(script.Sky).Parent = v_u_2
    local v51 = v_u_15:Clone(script.StrawberryVFX)
    v51.Parent = workspace
    v_u_12.enable(v51)
    local v52 = v_u_15:Clone(script.Bushes)
    local v53 = Random.new()
    for _, v54 in v52:GetChildren() do
        v_u_47(v54, v53:NextNumber(5, 7), function(p55)
            return v_u_48.startedAt + p55 - workspace:GetServerTimeNow()
        end)
    end
    v52.Parent = workspace
end
function v4.OnStop(_)
    v_u_15:Destroy()
end
function v4.OnLoad(_)
    v_u_14.OnClientEvent:Connect(function(p56)
        local v57 = v_u_6:GetAnimals()[p56]
        if v57 then
            local v58 = v57.AnimalModel
            local v59
            if v58 then
                v59 = v58.PrimaryPart
            else
                v59 = v58
            end
            local v60 = v57.Instance
            local v61
            if v60 then
                v61 = v60.PrimaryPart
            else
                v61 = v60
            end
            if v61 and v59 then
                local v62 = v_u_15:Clone(script.Burst)
                v62:PivotTo(v61.CFrame * CFrame.new(0, (v62.Size.Y + v58:GetExtentsSize().Y) / 2, 0))
                v62.Parent = v60
                local v63 = Instance.new("WeldConstraint")
                v63.Part0 = v62
                v63.Part1 = v57.AnimalModel.PrimaryPart
                v63.Parent = v62
                v_u_12.emit(v62)
                v_u_3:AddItem(v62, 5)
                v_u_8:PlaySound(v_u_1.Sounds.Events.Strawberry.BrainrotHit, v61.CFrame.Position, false)
            end
        else
            return
        end
    end)
end
return v4