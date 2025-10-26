--[[
  Extracted from: ReplicatedStorage.Controllers.EventController.Events.Water
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

game:GetService("ServerScriptService")
local u1 = game:GetService("ReplicatedStorage")
local u2 = game:GetService("ContentProvider")
local u3 = game:GetService("RunService")
game:GetService("Players")
require(u1.Shared.EventTypes)
local v4 = {}
local u5 = require(u1.Controllers.EffectController)
local u6 = require(u1.Controllers.AnimalController)
local u7 = require(u1.Controllers.SoundController)
local u8 = require(u1.Controllers.CycleController)
local u9 = require(u1.Controllers.EventController)
local u10 = require(u1.Controllers.EventController.ClientEventUtils)
require(u1.Packages.CreateTween)
local u11 = require(u1.Packages.Observers)
require(u1.Utils.MathUtils)
local v12 = require(u1.Packages.Trove)
local v13 = require(u1.Packages.Net)
local u14 = require(u1.Shared.VFX)
require(u1.Shared.Snapshot)
local u15 = script.Name
local u16 = v13:RemoteEvent("EventService/Water/Burst")
local u17 = v12.new()
local u18 = {}
local function u36() --[[Anonymous function at line 36]]
    --[[
    Upvalues:
        [1] = u17
        [2] = u3
        [3] = u11
    --]]
    local v19 = u17:Extend()
    local u20 = table.create(4)
    v19:Add(function() --[[Anonymous function at line 48]]
        --[[
        Upvalues:
            [1] = u20
        --]]
        table.clear(u20)
    end)
    local u21 = 0
    v19:Add(u3.PreRender:Connect(function(p22) --[[Anonymous function at line 53]]
        --[[
        Upvalues:
            [1] = u21
            [2] = u20
        --]]
        debug.profilebegin("Water Event")
        u21 = u21 + p22
        for v23, v24 in u20 do
            if v24.target and v24.targetAttachment then
                v24.beam.First.Enabled = true
                v24.beam.Second.Enabled = true
                local v25 = u21 - v23 + 1
                local v26 = math.clamp(v25, 0, 1)
                local v27 = v24.beam.WorldPosition
                v24.targetAttachment.Position = v27 + (v24.target:GetPivot().Position - v27) * v26
            end
        end
        debug.profileend()
    end))
    v19:Add(u11.observeTag("WaterPlayerVFX", function(u28) --[[Anonymous function at line 75]]
        --[[
        Upvalues:
            [1] = u20
            [2] = u11
        --]]
        local u29 = script.PlayerVFX.Beam:Clone()
        u29.Parent = u28
        local u30 = script.PlayerVFX.Torso:Clone()
        u30.Parent = u28
        local u31 = u28:GetAttribute("WaterIndex")
        u20[u31] = {
            ["beam"] = u29,
            ["target"] = nil
        }
        local u35 = u11.observeTag("WaterPlayerVFX", function(p32) --[[Anonymous function at line 88]]
            --[[
            Upvalues:
                [1] = u28
                [2] = u29
                [3] = u20
            --]]
            if p32 == u28 then
                return nil
            end
            if p32:GetAttribute("WaterIndex") ~= u28:GetAttribute("WaterIndex") % 4 + 1 then
                return nil
            end
            local u33 = Instance.new("Attachment")
            u33.Position = u29.WorldPosition
            u33.Parent = workspace.Terrain
            local v34 = u20[u28:GetAttribute("WaterIndex")]
            v34.target = p32
            v34.beam.First.Attachment0 = u33
            v34.beam.Second.Attachment0 = u33
            v34.targetAttachment = u33
            return function() --[[Anonymous function at line 107]]
                --[[
                Upvalues:
                    [1] = u33
                --]]
                u33:Destroy()
            end
        end)
        return function() --[[Anonymous function at line 112]]
            --[[
            Upvalues:
                [1] = u30
                [2] = u29
                [3] = u35
                [4] = u20
                [5] = u31
            --]]
            u30:Destroy()
            u29:Destroy()
            u35()
            u20[u31] = nil
        end
    end))
end
local function u57() --[[Anonymous function at line 122]]
    --[[
    Upvalues:
        [1] = u17
        [2] = u11
        [3] = u18
        [4] = u3
    --]]
    local u37 = {}
    u17:Add(u11.observeTag("WaterShark", function(u38) --[[Anonymous function at line 124]]
        --[[
        Upvalues:
            [1] = u18
            [2] = u37
        --]]
        local v39 = u38:GetAttribute("SharkType") or "Orcalero Orcala"
        local v40 = script[v39]
        local u41 = v40:Clone()
        u41.PrimaryPart.Anchored = true
        u41.Parent = u38
        local v42
        if v40 == script["Orcalero Orcala"] then
            v42 = script.OrcaleroSwim
        else
            v42 = script.TralaleroSwim
        end
        local v43
        if v40 == script["Orcalero Orcala"] then
            v43 = script.OrcaleroAttack
        else
            v43 = script.TralaleroAttack
        end
        local u44 = u41.AnimationController.Animator:LoadAnimation(v42)
        u44.Priority = Enum.AnimationPriority.Action
        local u45 = u41.AnimationController.Animator:LoadAnimation(v43)
        u45.Priority = Enum.AnimationPriority.Action4
        u45.Looped = false
        u44:Play()
        local function u46() --[[Anonymous function at line 144]]
            --[[
            Upvalues:
                [1] = u44
                [2] = u45
            --]]
            u44:Stop(0)
            u44:Destroy()
            u45:Stop(0)
            u45:Destroy()
        end
        local u47 = u38:GetAttributeChangedSignal("Attack"):Connect(function() --[[Anonymous function at line 152]]
            --[[
            Upvalues:
                [1] = u45
            --]]
            u45:Play()
        end)
        u18[u38.Name] = u41
        local v48 = u37
        table.insert(v48, u38)
        return function() --[[Anonymous function at line 159]]
            --[[
            Upvalues:
                [1] = u37
                [2] = u38
                [3] = u47
                [4] = u41
                [5] = u18
                [6] = u46
            --]]
            local v49 = table.find(u37, u38)
            if v49 then
                table.remove(u37, v49)
            end
            u47:Disconnect()
            u41:Destroy()
            u18[u38.Name] = nil
            local v50 = u46
            if type(v50) == "function" then
                u46()
                u46 = nil
            end
        end
    end))
    u17:Add(u3.PreRender:Connect(function(_) --[[Anonymous function at line 176]]
        --[[
        Upvalues:
            [1] = u37
            [2] = u18
        --]]
        debug.profilebegin("WaterEvent:Update Sharks")
        local v51 = {}
        local v52 = {}
        for _, v53 in u37 do
            local v54 = u18[v53.Name]
            if v54 then
                local v55 = v54.PrimaryPart
                table.insert(v51, v55)
                local v56 = v53.CFrame
                table.insert(v52, v56)
            end
        end
        workspace:BulkMoveTo(v51, v52, Enum.BulkMoveMode.FireCFrameChanged)
        debug.profileend()
    end))
end
function v4.OnStart(_) --[[Anonymous function at line 194]]
    --[[
    Upvalues:
        [1] = u9
        [2] = u15
        [3] = u1
        [4] = u17
        [5] = u5
        [6] = u8
        [7] = u7
        [8] = u57
        [9] = u11
        [10] = u3
        [11] = u36
    --]]
    local v58 = u9:GetActiveEventData(u15)
    assert(v58)
    u1:SetAttribute("WaterEvent", true)
    u17:Add(function() --[[Anonymous function at line 199]]
        --[[
        Upvalues:
            [1] = u1
            [2] = u5
            [3] = u15
            [4] = u8
            [5] = u7
        --]]
        u1:SetAttribute("WaterEvent", nil)
        u5:Activate("Blink")
        u5:Stop(u15, "GrassRecolor")
        u8:Update()
        u7:UpdateOST()
        u7:UpdateAmbience()
    end)
    u17:Add(task.delay(v58.startedAt + 4 - workspace:GetServerTimeNow(), function() --[[Anonymous function at line 209]]
        --[[
        Upvalues:
            [1] = u5
            [2] = u17
            [3] = u15
            [4] = u8
            [5] = u7
            [6] = u57
            [7] = u11
            [8] = u3
        --]]
        u5:Activate("Blink")
        local v59 = u17:Add(Instance.new("ColorCorrectionEffect"))
        v59.Brightness = 0.15
        v59.Contrast = 0.1
        v59.Saturation = -0.1
        v59.TintColor = Color3.fromRGB(113, 186, 234)
        v59.Parent = workspace.CurrentCamera
        u17:Clone(script.Water).Parent = workspace
        u5:Run(u15, "GrassRecolor")
        u8:Update()
        u7:UpdateOST()
        u7:UpdateAmbience()
        u57()
        u17:Add(u11.observeCharacters(function(_, u60) --[[Anonymous function at line 230]]
            --[[
            Upvalues:
                [1] = u11
            --]]
            return u11.observeChildren(u60, function(p61) --[[Anonymous function at line 231]]
                --[[
                Upvalues:
                    [1] = u11
                    [2] = u60
                --]]
                if p61.Name ~= "UpperTorso" then
                    return nil
                end
                local u62 = {}
                for _, v63 in script.PlayerBubbles:GetChildren() do
                    local v64 = v63:Clone()
                    v64.Parent = p61
                    table.insert(u62, v64)
                end
                local u69 = u11.observeChildren(u60, function(u65) --[[Anonymous function at line 244]]
                    --[[
                    Upvalues:
                        [1] = u62
                    --]]
                    if not u65:IsA("Humanoid") then
                        return nil
                    end
                    local u68 = u65:GetPropertyChangedSignal("MoveDirection"):Connect(function() --[[Anonymous function at line 249]]
                        --[[
                        Upvalues:
                            [1] = u65
                            [2] = u62
                        --]]
                        local v66 = u65.MoveDirection ~= Vector3.new(0, 0, 0)
                        for _, v67 in u62 do
                            v67.Enabled = v66
                        end
                    end)
                    return function() --[[Anonymous function at line 256]]
                        --[[
                        Upvalues:
                            [1] = u68
                        --]]
                        u68:Disconnect()
                    end
                end)
                return function() --[[Anonymous function at line 261]]
                    --[[
                    Upvalues:
                        [1] = u62
                        [2] = u69
                    --]]
                    for _, v70 in u62 do
                        v70:Destroy()
                    end
                    table.clear(u62)
                    u69()
                end
            end)
        end))
        u17:Add(function() --[[Anonymous function at line 272]]
            workspace.Gravity = 196.2
        end)
        u17:Add(u3.PostSimulation:Connect(function(_) --[[Anonymous function at line 276]]
            workspace.Gravity = 29.429999999999996
        end))
    end))
    u17:Add(task.spawn(function() --[[Anonymous function at line 281]]
        --[[
        Upvalues:
            [1] = u36
        --]]
        u36()
    end))
end
function v4.OnStop(_) --[[Anonymous function at line 286]]
    --[[
    Upvalues:
        [1] = u17
    --]]
    u17:Destroy()
end
function v4.OnLoad(_) --[[Anonymous function at line 290]]
    --[[
    Upvalues:
        [1] = u2
        [2] = u16
        [3] = u6
        [4] = u18
        [5] = u10
        [6] = u14
        [7] = u7
        [8] = u1
    --]]
    task.spawn(pcall, function() --[[Anonymous function at line 291]]
        --[[
        Upvalues:
            [1] = u2
        --]]
        u2:PreloadAsync(script:GetChildren())
    end)
    u16.OnClientEvent:Connect(function(p71, p72) --[[Anonymous function at line 295]]
        --[[
        Upvalues:
            [1] = u6
            [2] = u18
            [3] = u10
            [4] = u14
            [5] = u7
            [6] = u1
        --]]
        local v73 = u6:GetAnimals()[p72]
        if v73 then
            local v74 = u18[p71]
            if v74 then
                v74.Parent:SetAttribute("Attack", not v74.Parent:GetAttribute("Attack"))
            end
            local v75 = script.Burst:Clone()
            v75.CFrame = CFrame.new(u10.getAnimalPosition(p72, {
                ["top"] = true
            }))
            v75.Anchored = false
            local v76 = Instance.new("WeldConstraint")
            v76.Part0 = v75
            v76.Part1 = v73.AnimalModel.PrimaryPart
            v76.Parent = v75
            v75.Parent = workspace
            u14.emit(v75)
            u7:PlaySound(u1.Sounds.Events.Water["Brainrot Hit"], v75.Position)
        end
    end)
end
return v4