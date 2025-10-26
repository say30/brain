--[[
  Extracted from: ReplicatedStorage.Controllers.EventController.Events.Bombardiro Crocodilo
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local u1 = game:GetService("ReplicatedStorage")
game:GetService("TweenService")
local u2 = game:GetService("RunService")
game:GetService("Players")
game:GetService("Debris")
require(u1.Shared.EventTypes)
local v3 = {}
require(u1.Controllers.AnimalController)
local u4 = require(u1.Controllers.EffectController)
local u5 = require(u1.Controllers.SoundController)
local u6 = require(u1.Controllers.EventController)
local u7 = require(u1.Controllers.CycleController)
require(u1.Shared.ShakePresets)
local u8 = require(u1.Packages.Observers)
require(u1.Shared.TweenPivot)
local u9 = require(u1.Utils.MathUtils)
local v10 = require(u1.Packages.Trove)
require(u1.Packages.Shake)
local v11 = require(u1.Packages.Net)
local u12 = require(u1.Shared.VFX)
local u13 = script["Svinina Bombardino"]
local u14 = script["Bombardiro Crocodilo"]
local u15 = v11:RemoteEvent("EventService/Bombardiro Crocodilo/SpawnBomb")
local u16 = v11:RemoteEvent("EventService/Bombardiro Crocodilo/Explode")
local u17 = script.Name
local u18 = v10.new()
local _ = workspace.CurrentCamera
local u19 = {}
function v3.OnStart(_) --[[Anonymous function at line 39]]
    --[[
    Upvalues:
        [1] = u6
        [2] = u17
        [3] = u1
        [4] = u18
        [5] = u12
        [6] = u5
        [7] = u4
        [8] = u7
        [9] = u2
        [10] = u8
        [11] = u14
        [12] = u19
    --]]
    local v20 = u6:GetActiveEventData(u17)
    assert(v20)
    workspace:GetServerTimeNow()
    u1:SetAttribute("BombardiroCrocodiloEvent", true)
    u18:Add(function() --[[Anonymous function at line 46]]
        --[[
        Upvalues:
            [1] = u1
        --]]
        u1:SetAttribute("BombardiroCrocodiloEvent", nil)
    end)
    u18:Add(task.delay(v20.startedAt + 8 - workspace:GetServerTimeNow(), function() --[[Anonymous function at line 50]]
        --[[
        Upvalues:
            [1] = u18
            [2] = u12
            [3] = u1
            [4] = u5
            [5] = u4
        --]]
        local v21 = u18:Clone(script.Planesbg)
        u12.enable(v21)
        v21.Parent = workspace
        u1:SetAttribute("BombardiroCrocodiloEventSoundTrack", true)
        u5:UpdateOST()
        u18:Add(function() --[[Anonymous function at line 57]]
            --[[
            Upvalues:
                [1] = u1
                [2] = u5
                [3] = u4
            --]]
            u1:SetAttribute("BombardiroCrocodiloEventSoundTrack", nil)
            u5:UpdateOST()
            u4:Activate("Blink")
        end)
    end))
    u5:UpdateOST()
    u7:Update()
    local v22 = u18:Extend()
    local u23 = table.create(3)
    v22:Add(function() --[[Anonymous function at line 79]]
        --[[
        Upvalues:
            [1] = u23
        --]]
        table.clear(u23)
    end)
    local u24 = 0
    v22:Add(u2.PreRender:Connect(function(p25) --[[Anonymous function at line 84]]
        --[[
        Upvalues:
            [1] = u24
            [2] = u23
        --]]
        debug.profilebegin("Bombardiro Event")
        u24 = u24 + p25
        for v26, v27 in u23 do
            if v27.target and v27.targetAttachment then
                v27.beam.First.Enabled = true
                v27.beam.Second.Enabled = true
                local v28 = u24 - v26 + 1
                local v29 = math.clamp(v28, 0, 1)
                local v30 = v27.beam.WorldPosition
                v27.targetAttachment.Position = v30 + (v27.target:GetPivot().Position - v30) * v29
            end
        end
        debug.profileend()
    end))
    v22:Add(u8.observeTag("BombardiroCrocodiloPlayerVFX", function(u31) --[[Anonymous function at line 106]]
        --[[
        Upvalues:
            [1] = u23
            [2] = u8
        --]]
        local u32 = script.PlayerVFX.Beam:Clone()
        u32.Parent = u31
        local u33 = script.PlayerVFX.Torso:Clone()
        u33.Parent = u31
        local u34 = u31:GetAttribute("BombardiroIndex")
        u23[u34] = {
            ["beam"] = u32,
            ["target"] = nil
        }
        local u38 = u8.observeTag("BombardiroCrocodiloPlayerVFX", function(p35) --[[Anonymous function at line 119]]
            --[[
            Upvalues:
                [1] = u31
                [2] = u32
                [3] = u23
            --]]
            if p35 == u31 then
                return nil
            end
            if p35:GetAttribute("BombardiroIndex") ~= u31:GetAttribute("BombardiroIndex") % 3 + 1 then
                return nil
            end
            local u36 = Instance.new("Attachment")
            u36.Position = u32.WorldPosition
            u36.Parent = workspace.Terrain
            local v37 = u23[u31:GetAttribute("BombardiroIndex")]
            v37.target = p35
            v37.beam.First.Attachment0 = u36
            v37.beam.Second.Attachment0 = u36
            v37.targetAttachment = u36
            return function() --[[Anonymous function at line 138]]
                --[[
                Upvalues:
                    [1] = u36
                --]]
                u36:Destroy()
            end
        end)
        return function() --[[Anonymous function at line 143]]
            --[[
            Upvalues:
                [1] = u33
                [2] = u32
                [3] = u38
                [4] = u23
                [5] = u34
            --]]
            u33:Destroy()
            u32:Destroy()
            u38()
            u23[u34] = nil
        end
    end))
    local u39 = {}
    u18:Add(u8.observeTag("BombardiroPlane", function(u40) --[[Anonymous function at line 153]]
        --[[
        Upvalues:
            [1] = u14
            [2] = u19
            [3] = u39
        --]]
        local u41 = u14:Clone()
        u41.PrimaryPart.Anchored = true
        for _, v42 in u41["Svinina Bombardino"]:GetChildren() do
            if v42.Name ~= "RootPart" then
                v42.Transparency = 1
            end
        end
        u41.Parent = u40
        local u44 = task.delay(5, function() --[[Anonymous function at line 167]]
            --[[
            Upvalues:
                [1] = u41
            --]]
            for _, v43 in u41["Svinina Bombardino"]:GetChildren() do
                if v43.Name ~= "RootPart" then
                    v43.Transparency = 0
                end
            end
        end)
        u19[u40.Name] = u41
        local v45 = u39
        table.insert(v45, u40)
        return function() --[[Anonymous function at line 180]]
            --[[
            Upvalues:
                [1] = u39
                [2] = u40
                [3] = u41
                [4] = u19
                [5] = u44
            --]]
            local v46 = table.find(u39, u40)
            if v46 then
                table.remove(u39, v46)
            end
            u41:Destroy()
            u19[u40.Name] = nil
            if coroutine.status(u44) == "suspended" then
                pcall(task.cancel, u44)
            end
        end
    end))
    u18:Add(u2.PreRender:Connect(function(_) --[[Anonymous function at line 195]]
        --[[
        Upvalues:
            [1] = u39
            [2] = u19
        --]]
        local v47 = {}
        local v48 = {}
        for _, v49 in u39 do
            local v50 = u19[v49.Name]
            if v50 then
                local v51 = v50.PrimaryPart
                table.insert(v47, v51)
                local v52 = v49.CFrame
                table.insert(v48, v52)
            end
        end
        workspace:BulkMoveTo(v47, v48, Enum.BulkMoveMode.FireCFrameChanged)
    end))
end
function v3.OnStop(_) --[[Anonymous function at line 210]]
    --[[
    Upvalues:
        [1] = u18
    --]]
    u18:Destroy()
end
function v3.OnLoad(_) --[[Anonymous function at line 214]]
    --[[
    Upvalues:
        [1] = u12
        [2] = u15
        [3] = u19
        [4] = u13
        [5] = u1
        [6] = u9
        [7] = u2
        [8] = u16
    --]]
    local function u56(p53, p54) --[[Anonymous function at line 215]]
        --[[
        Upvalues:
            [1] = u12
        --]]
        local u55 = script[p54 or "Explosion"]:Clone()
        u55.CFrame = p53
        u55.Parent = workspace
        u12.emit(u55)
        task.delay(5, function() --[[Anonymous function at line 222]]
            --[[
            Upvalues:
                [1] = u55
            --]]
            u55:Destroy()
        end)
    end
    u15.OnClientEvent:Connect(function(p57, u58, p59) --[[Anonymous function at line 227]]
        --[[
        Upvalues:
            [1] = u19
            [2] = u13
            [3] = u1
            [4] = u9
            [5] = u2
        --]]
        local v60 = u19[p57]
        if v60 and v60:FindFirstChild("Svinina Bombardino") then
            for _, u61 in v60["Svinina Bombardino"]:GetChildren() do
                if u61.Name ~= "RootPart" then
                    u61.Transparency = 1
                    task.delay(1, function() --[[Anonymous function at line 236]]
                        --[[
                        Upvalues:
                            [1] = u61
                        --]]
                        u61.Transparency = 0
                    end)
                end
            end
        end
        local u62 = u13:Clone()
        u62.PrimaryPart.Anchored = true
        u62:PivotTo(CFrame.new(u58))
        local v63 = u1.Sounds.Events["Bombardiro Crocodilo"].DroppingBomb:Clone()
        v63.Parent = u62
        u62.Parent = workspace
        v63:Play()
        local u64 = 0
        local u65 = u9.calculateTimeToGround(u58.y, p59.y)
        local u66 = nil
        u66 = u2.PostSimulation:Connect(function(p67) --[[Anonymous function at line 257]]
            --[[
            Upvalues:
                [1] = u64
                [2] = u65
                [3] = u62
                [4] = u58
                [5] = u9
                [6] = u66
            --]]
            u64 = u64 + p67
            local v68 = u64 / u65
            local v69 = u62
            local v70 = CFrame.new
            local v71 = u58
            local v72 = u9.simulateGravity(u64)
            v69:PivotTo(v70(v71 - vector.create(0, v72, 0)) * CFrame.Angles(-u64 * 3.141592653589793 * 2, 0, 0))
            if v68 >= 1 then
                u66:Disconnect()
                for _, v73 in u62:GetDescendants() do
                    if v73:IsA("BasePart") then
                        v73.Transparency = 1
                    elseif v73:IsA("ParticleEmitter") then
                        v73:Destroy()
                    end
                end
                task.wait(3)
                u62:Destroy()
            end
        end)
    end)
    u16.OnClientEvent:Connect(function(p74, p75) --[[Anonymous function at line 279]]
        --[[
        Upvalues:
            [1] = u56
        --]]
        local v76 = u56
        if typeof(p74) ~= "CFrame" then
            p74 = CFrame.new(p74)
        end
        v76(p74, p75)
    end)
end
return v3