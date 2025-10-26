--[[
  Extracted from: ReplicatedStorage.Controllers.EventController.Events.UFO
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local u1 = game:GetService("ReplicatedStorage")
local u2 = game:GetService("RunService")
local u3 = game:GetService("Players")
game:GetService("Lighting")
require(u1.Shared.EventTypes)
local v4 = require(u1.Packages.Net)
local u5 = require(u1.Shared.ShakePresets)
local v6 = {}
local u7 = require(u1.Controllers.SoundController)
local u8 = require(u1.Controllers.CycleController)
local u9 = require(u1.Packages.CreateTween)
local u10 = require(u1.Packages.Observers)
local v11 = require(u1.Packages.Trove)
local u12 = require(u1.Shared.VFX)
local u13 = u1.Models.Events.UFO.UFO
local u14 = v4:RemoteEvent("EventService/UFO/AbductionBurst")
local u15 = v4:RemoteEvent("EventService/UFO/Spawned")
local u16 = v11.new()
local function u24() --[[Anonymous function at line 27]]
    --[[
    Upvalues:
        [1] = u3
        [2] = u9
        [3] = u5
    --]]
    local v17 = u3.LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if v17 then
        local u18 = Instance.new("ScreenGui")
        u18.IgnoreGuiInset = true
        u18.ResetOnSpawn = false
        u18.DisplayOrder = 10000
        u18.Name = "UFO_SpawnFlash"
        local v19 = Instance.new("Frame")
        v19.Size = UDim2.fromScale(1, 1)
        v19.BackgroundColor3 = Color3.fromRGB(60, 255, 120)
        v19.BackgroundTransparency = 1
        v19.Parent = u18
        u18.Parent = v17
        local v20 = u9(v19, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            ["BackgroundTransparency"] = 0.4
        }, false)
        local u21 = u9(v19, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            ["BackgroundTransparency"] = 1
        }, false)
        v20:Play()
        v20.Completed:Once(function() --[[Anonymous function at line 52]]
            --[[
            Upvalues:
                [1] = u21
                [2] = u18
            --]]
            u21:Play()
            u21.Completed:Once(function() --[[Anonymous function at line 54]]
                --[[
                Upvalues:
                    [1] = u18
                --]]
                u18:Destroy()
            end)
        end)
        local u22 = u5.BumpS:Clone()
        u22.Sustain = true
        local u23 = u5.BindShakeToCamera(u22, workspace.CurrentCamera)
        u22:Start()
        task.delay(0.3, function() --[[Anonymous function at line 63]]
            --[[
            Upvalues:
                [1] = u22
                [2] = u23
            --]]
            u22:StopSustain()
            task.delay(0.2, function() --[[Anonymous function at line 65]]
                --[[
                Upvalues:
                    [1] = u22
                    [2] = u23
                --]]
                u22:Destroy()
                u23()
            end)
        end)
    end
end
function v6.OnStart(_) --[[Anonymous function at line 187]]
    --[[
    Upvalues:
        [1] = u16
        [2] = u10
        [3] = u13
        [4] = u1
        [5] = u9
        [6] = u2
        [7] = u14
        [8] = u12
        [9] = u15
        [10] = u24
        [11] = u8
        [12] = u7
    --]]
    local u25 = u16:Extend()
    u25:Add(u10.observeTag("GalaxyUFO", function(u26) --[[Anonymous function at line 75]]
        --[[
        Upvalues:
            [1] = u25
            [2] = u13
            [3] = u1
            [4] = u9
            [5] = u2
        --]]
        if not u26:IsA("BasePart") then
            return nil
        end
        local u27 = u25:Extend()
        local u28 = u27:Clone(u13)
        for _, v29 in u28:GetDescendants() do
            if v29:IsA("BasePart") then
                v29.Anchored = true
            end
        end
        local v30 = u1.Sounds.Events.UFO.Flying:Clone()
        v30.Parent = u26
        v30:Play()
        u28.Parent = workspace
        local v31 = u28:FindFirstChild("BeamPart", true)
        local u32
        if v31 then
            u32 = v31:FindFirstChild("att0")
        else
            u32 = v31
        end
        local u33
        if v31 then
            u33 = v31:FindFirstChild("att1")
        else
            u33 = v31
        end
        if not (v31 and (u32 and (u33 and (u32:IsA("Attachment") and u33:IsA("Attachment"))))) then
            u27:Destroy()
            return nil
        end
        local u34 = {}
        for _, v35 in u33:GetChildren() do
            if v35:IsA("Beam") then
                v35.Attachment0 = u32
                v35.Attachment1 = u33
                v35.Enabled = false
                table.insert(u34, v35)
            end
        end
        local u36 = u33.Position
        local u37 = nil
        local function v38() --[[Anonymous function at line 116]]
            --[[
            Upvalues:
                [1] = u37
            --]]
            if u37 then
                u37:Cancel()
                u37 = nil
            end
        end
        local function u46(p39) --[[Anonymous function at line 135]]
            --[[
            Upvalues:
                [1] = u1
                [2] = u26
                [3] = u34
                [4] = u33
                [5] = u32
                [6] = u36
                [7] = u37
                [8] = u9
            --]]
            if p39 == "down" then
                local v40 = u1.Sounds.Events.UFO.Abducting:Clone()
                v40.Parent = u26
                v40:Play()
                for _, v41 in u34 do
                    v41.Enabled = true
                end
                u33.Position = u32.Position
                local v42 = u36
                if u37 then
                    u37:Cancel()
                    u37 = nil
                end
                u37 = u9(u33, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
                    ["Position"] = v42
                })
            elseif p39 == "off" then
                local v43 = u32.Position
                if u37 then
                    u37:Cancel()
                    u37 = nil
                end
                u37 = u9(u33, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
                    ["Position"] = v43
                })
                local v44 = u37
                if v44 then
                    v44.Completed:Wait()
                end
                for _, v45 in u34 do
                    v45.Enabled = false
                end
                u33.Position = u36
            end
        end
        u27:Add(u26:GetAttributeChangedSignal("BeamState"):Connect(function() --[[Anonymous function at line 154]]
            --[[
            Upvalues:
                [1] = u26
                [2] = u46
            --]]
            local v47 = u26:GetAttribute("BeamState")
            if typeof(v47) == "string" then
                u46(v47)
            end
        end))
        u27:Add(u2.PostSimulation:Connect(function() --[[Anonymous function at line 161]]
            --[[
            Upvalues:
                [1] = u28
                [2] = u26
                [3] = u27
            --]]
            if u28.PrimaryPart == nil or u26.Parent == nil then
                u27:Destroy()
            else
                u28:PivotTo(u26.CFrame)
            end
        end))
        u27:Add(v38)
        u27:Add(task.spawn(function() --[[Anonymous function at line 171]]
            --[[
            Upvalues:
                [1] = u26
                [2] = u46
                [3] = u34
                [4] = u33
                [5] = u36
            --]]
            local v48 = u26:GetAttribute("BeamState")
            if typeof(v48) == "string" then
                u46(v48)
            else
                for _, v49 in u34 do
                    v49.Enabled = false
                end
                u33.Position = u36
            end
        end))
        return function() --[[Anonymous function at line 181]]
            --[[
            Upvalues:
                [1] = u27
            --]]
            u27:Destroy()
        end
    end))
    u16:Add(u14.OnClientEvent:Connect(function(p50) --[[Anonymous function at line 190]]
        --[[
        Upvalues:
            [1] = u1
            [2] = u12
            [3] = u16
        --]]
        local v51 = script.Effects.ufoemit:Clone()
        v51:PivotTo(CFrame.new(p50))
        local v52 = u1.Sounds.Events.UFO.Burst:Clone()
        v52.Parent = v51
        v52:Play()
        v51.Parent = workspace
        u12.emit(v51)
        u16:Add(v51)
        task.wait(1.5)
        v51:Destroy()
    end))
    u16:Add(u15.OnClientEvent:Connect(function(_) --[[Anonymous function at line 206]]
        --[[
        Upvalues:
            [1] = u24
        --]]
        u24()
    end))
    u1:SetAttribute("UFOEvent", true)
    u16:Add(function() --[[Anonymous function at line 211]]
        --[[
        Upvalues:
            [1] = u1
            [2] = u8
            [3] = u7
        --]]
        u1:SetAttribute("UFOEvent", nil)
        u8:Update()
        u7:UpdateOST()
    end)
end
function v6.OnStop(_) --[[Anonymous function at line 218]]
    --[[
    Upvalues:
        [1] = u16
    --]]
    u16:Destroy()
end
function v6.OnLoad(_) --[[Anonymous function at line 222]] end
return v6