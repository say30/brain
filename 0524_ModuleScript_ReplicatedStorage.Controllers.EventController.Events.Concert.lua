--[[
  Extracted from: ReplicatedStorage.Controllers.EventController.Events.Concert
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local u1 = game:GetService("ReplicatedStorage")
game:GetService("TweenService")
local u2 = game:GetService("RunService")
local u3 = game:GetService("Lighting")
local u4 = game:GetService("Players")
require(u1.Shared.EventTypes)
local v5 = {}
local u6 = require(u1.Controllers.EncryptedAssetsController)
local u7 = require(u1.Controllers.AnimalController)
local u8 = require(u1.Controllers.EffectController)
local u9 = require(u1.Controllers.CameraController)
local u10 = require(u1.Controllers.SoundController)
local u11 = require(u1.Controllers.EventController)
local u12 = require(u1.Controllers.CycleController)
local u13 = require(u1.Packages.CreateTween)
require(u1.Shared.TweenPivot)
local u14 = require(u1.Packages.Observers)
local u15 = require(u1.Utils.MathUtils)
local u16 = require(u1.Packages.Signal)
require(u1.Packages.Spring)
local u17 = require(u1.Packages.Trove)
require(u1.Packages.Shake)
local v18 = require(u1.Packages.Net)
local u19 = require(u1.Shared.VFX)
local u20 = u4.LocalPlayer
local u21 = workspace.CurrentCamera
local u22 = script.Name
local u23 = workspace.Sounds.Concert
local u24 = v18:RemoteEvent("EventService/Concert/Shoot")
local u25 = u17.new()
local u26 = nil
function v5.OnStart(_) --[[Anonymous function at line 44]]
    --[[
    Upvalues:
        [1] = u11
        [2] = u22
        [3] = u25
        [4] = u8
        [5] = u12
        [6] = u10
        [7] = u3
        [8] = u1
        [9] = u21
        [10] = u23
        [11] = u6
        [12] = u19
        [13] = u24
        [14] = u7
        [15] = u2
        [16] = u15
        [17] = u13
        [18] = u9
        [19] = u16
        [20] = u14
        [21] = u4
        [22] = u17
        [23] = u20
    --]]
    local u27 = u11:GetActiveEventData(u22)
    assert(u27)
    local function u38(p28, u29, u30) --[[Anonymous function at line 52]]
        --[[
        Upvalues:
            [1] = u27
        --]]
        local function u33() --[[Anonymous function at line 53]]
            --[[
            Upvalues:
                [1] = u29
                [2] = u27
            --]]
            local v31 = u29
            local v32 = u27.startedAt + v31 - workspace:GetServerTimeNow()
            return math.max(v32, 0)
        end
        local function v34() --[[Anonymous function at line 57]]
            --[[
            Upvalues:
                [1] = u30
                [2] = u33
            --]]
            u30(u33)
        end
        local u35 = nil
        local v36 = u27.startedAt + p28 - workspace:GetServerTimeNow()
        local v37 = math.max(v36, 0)
        if v37 > 0 then
            u35 = task.delay(v37, v34)
        else
            u30(u33)
        end
        return function() --[[Anonymous function at line 70]]
            --[[
            Upvalues:
                [1] = u35
            --]]
            if u35 and coroutine.status(u35) == "suspended" then
                pcall(task.cancel, u35)
            end
        end
    end
    u25:Add(function() --[[Anonymous function at line 77]]
        --[[
        Upvalues:
            [1] = u8
            [2] = u12
            [3] = u10
        --]]
        u8:Activate("Blink")
        u12:Update()
        u10:UpdateOST()
    end)
    local u39 = u3:FindFirstChild("Atmosphere")
    if u39 then
        u39.Parent = u1
        u25:Add(function() --[[Anonymous function at line 86]]
            --[[
            Upvalues:
                [1] = u39
                [2] = u3
            --]]
            u39.Parent = u3
        end)
    end
    u25:Clone(script.Atmosphere).Parent = u3
    local u40 = u3:FindFirstChild("Cartoon")
    if u40 then
        u40.Parent = u1
        u25:Add(function() --[[Anonymous function at line 96]]
            --[[
            Upvalues:
                [1] = u40
                [2] = u3
            --]]
            u40.Parent = u3
        end)
    end
    local u41 = nil
    local u42 = u25:Clone(Instance.new("ColorCorrectionEffect"))
    u42.Parent = u21
    local function u180() --[[Anonymous function at line 113]]
        --[[
        Upvalues:
            [1] = u3
            [2] = u25
            [3] = u23
            [4] = u6
            [5] = u27
            [6] = u19
            [7] = u24
            [8] = u7
            [9] = u10
            [10] = u1
            [11] = u2
            [12] = u15
            [13] = u38
            [14] = u41
            [15] = u13
            [16] = u9
        --]]
        u3.Ambient = Color3.new(0, 0, 0)
        u3.OutdoorAmbient = Color3.fromRGB(100, 100, 100)
        u3.EnvironmentDiffuseScale = 0
        u3.EnvironmentSpecularScale = 0
        u25:Add(function() --[[Anonymous function at line 118]]
            --[[
            Upvalues:
                [1] = u3
            --]]
            u3.Ambient = Color3.fromRGB(241, 241, 241)
            u3.OutdoorAmbient = Color3.fromRGB(212, 212, 212)
            u3.EnvironmentDiffuseScale = 1
            u3.EnvironmentSpecularScale = 0.5
        end)
        u25:Add(function() --[[Anonymous function at line 126]]
            --[[
            Upvalues:
                [1] = u23
            --]]
            u23:Stop()
        end)
        u25:Add(task.spawn(function() --[[Anonymous function at line 130]]
            while not u23.IsLoaded do
                task.wait()
            end
            local v43 = u23
            local v44 = u23.TimePosition
            local v45 = workspace:GetServerTimeNow() - (u27.startedAt + 5)
            v43.TimePosition = math.max(v44, v45)
            u23:Play()
        end))
        local u46 = {
            Color3.fromRGB(255, 255, 255),
            Color3.fromRGB(255, 0, 0),
            Color3.fromRGB(255, 128, 0),
            Color3.fromRGB(255, 255, 0),
            Color3.fromRGB(128, 255, 0),
            Color3.fromRGB(0, 255, 0),
            Color3.fromRGB(0, 255, 128),
            Color3.fromRGB(0, 255, 255),
            Color3.fromRGB(0, 0, 255),
            Color3.fromRGB(128, 0, 255),
            Color3.fromRGB(255, 0, 255),
            Color3.fromRGB(255, 0, 128),
            Color3.fromRGB(255, 0, 255),
            Color3.fromRGB(0, 128, 255)
        }
        u25:Clone(script.Night_Sky).Parent = u3
        local u47 = u25:Clone(script.Stage)
        local u48 = u25:Clone(script.VFX)
        local u49 = u48.SmokeStage
        u25:Add(u49)
        u49.Parent = workspace
        u48.Parent = u47
        u19.disable(u48)
        local u50 = u47.SpotLights:GetChildren()
        local _ = #u50
        local u51 = {}
        local u52 = {}
        local u53 = {}
        local u54 = {}
        local u55 = {}
        local u56 = false
        local u57 = false
        local u58 = {}
        local u59 = {}
        local u60 = false
        local u61 = false
        local u62 = {}
        local u63 = {}
        for _, v64 in u50 do
            u51[v64] = v64:GetPivot()
            u52[v64] = 0
            u53[v64] = 0
            u54[v64] = 25
            v64.Rotate.Neon["1"].LightBeam:Destroy()
            local v65 = script.lightbeambig.Beams:Clone()
            for _, v66 in v65:GetChildren() do
                v66.Attachment0 = v64.Rotate.Neon["1"]
                v66.Attachment1 = v64.Rotate.Neon["2"]
                v66.Parent = v64.Rotate.Neon
                table.insert(u55, v66)
            end
            v65:Destroy()
        end
        u47.Parent = workspace
        local u67 = { u47.Rigs.TungTung, u47.Rigs.Tralalero, u47.Rigs.Chimpanzini }
        local u68 = {}
        for _, v69 in u67 do
            if v69.Name ~= "TungTung" then
                for _, v70 in v69:GetChildren() do
                    if v70:IsA("BasePart") then
                        v70.Transparency = 1
                    end
                end
            end
            local v71 = {}
            local v72 = v69.Throw
            local v73 = v69.AnimationController.Animator:LoadAnimation(v72)
            u25:Add(v73, "Stop")
            u25:Add(v73)
            v71.Throw = v73
            local v74 = v69.Shuffle
            local v75 = v69.AnimationController.Animator:LoadAnimation(v74)
            u25:Add(v75, "Stop")
            u25:Add(v75)
            v71.Shuffle = v75
            u68[v69] = v71
        end
        local u76 = u25:Add(Instance.new("Color3Value"))
        u76.Value = Color3.fromRGB(0, 0, 0)
        for _, v77 in u68 do
            v77.Shuffle:Play()
        end
        local u78 = true
        u25:Add(function() --[[Anonymous function at line 241]]
            --[[
            Upvalues:
                [1] = u78
            --]]
            u78 = false
        end)
		u25:Add(u24.OnClientEvent:Connect(function(p79, p80, u81)
			local u82 = u7:GetAnimals()[p80]
			if u82 then
				local v83 = u67[p79] or u67[1]
				if v83 then
					u68[v83].Throw:Play()
					task.wait(0.25)
					if u78 then
						local u84 = v83:FindFirstChild("SHOOT", true).WorldPosition
						task.spawn(function()
							u10:PlaySound(u1.Sounds.Events.Concert.Shoot, u84)
						end)
						local u85 = script.DiscoProjectile:Clone()
						u85.Part.CFrame = CFrame.new(u84)
						u85.Parent = workspace
						local u86 = nil
						u86 = u2.PreRender:Connect(function()
							debug.profilebegin("Concert Disco Shoot")
							local v87 = u82.AnimalModel
							local v88
							if v87.PrimaryPart then
								v88 = v87.PrimaryPart.CFrame
							else
								v88 = v87:GetPivot()
							end
							local u89 = v88.Position
							local v90 = u84 + (u89 - u84) * 0.5 + Vector3.new(0, 90, 0)
							local v91 = 1 - (u81 + 3 - workspace:GetServerTimeNow()) / 3
							local v92 = u15.quadBezier(math.clamp(v91, 0, 1), u84, v90, u89)
							u85.Part.CFrame = CFrame.new(v92)
							if v91 >= 1 then
								u86:Disconnect()
								task.spawn(function()
									u10:PlaySound(u1.Sounds.Events.Concert.Hit, u89)
								end)
								u85:Destroy()
								local u93 = script.DiscoExplosion:Clone()
								u93:PivotTo(CFrame.new(u89))
								u93.Anchored = false
								local v94 = Instance.new("WeldConstraint")
								v94.Part0 = u93
								v94.Part1 = u82.AnimalModel.PrimaryPart
								v94.Parent = u93
								u93.Parent = workspace
								u19.emit(u93)
								task.delay(3, function()
									u93:Destroy()
								end)
								-- Add FireServer call to notify the server of the hit
								u24:FireServer(p79, p80, u81)
							end
							debug.profileend()
						end)
					end
				end
			end
		end))
        u25:Add((u38(10, 15, function(u96) --[[Anonymous function at line 333]]
            --[[
            Upvalues:
                [1] = u19
                [2] = u48
                [3] = u55
                [4] = u25
                [5] = u2
                [6] = u23
                [7] = u58
                [8] = u62
                [9] = u68
                [10] = u41
                [11] = u46
                [12] = u13
                [13] = u76
                [14] = u59
                [15] = u63
                [16] = u50
                [17] = u53
                [18] = u54
                [19] = u52
                [20] = u51
                [21] = u60
                [22] = u56
                [23] = u49
                [24] = u61
                [25] = u47
                [26] = u57
                [27] = u9
            --]]
            u19.enable(u48)
            local u97 = 1
            local u98 = 0
            local u99 = 0
            local u100 = 0
            local u101 = 0
            local u102 = {}
            local u103 = Color3.new(0, 0, 0)
            local u104 = ColorSequence.new(u103)
            task.delay(u96(), function() --[[Anonymous function at line 347]]
                --[[
                Upvalues:
                    [1] = u55
                --]]
                for _, v105 in u55 do
                    v105.Enabled = true
                end
            end)
            u25:Add(function() --[[Anonymous function at line 353]]
                workspace.Gravity = 196.2
            end)
            u25:Add(u2.PostSimulation:Connect(function(p106) --[[Anonymous function at line 357]]
                --[[
                Upvalues:
                    [1] = u99
                    [2] = u98
                    [3] = u101
                    [4] = u100
                    [5] = u23
                    [6] = u58
                    [7] = u62
                    [8] = u68
                    [9] = u41
                    [10] = u96
                    [11] = u97
                    [12] = u46
                    [13] = u13
                    [14] = u76
                    [15] = u103
                    [16] = u59
                    [17] = u102
                    [18] = u104
                    [19] = u63
                    [20] = u50
                    [21] = u53
                    [22] = u54
                    [23] = u52
                    [24] = u51
                    [25] = u60
                    [26] = u55
                    [27] = u56
                    [28] = u19
                    [29] = u49
                    [30] = u61
                    [31] = u47
                    [32] = u57
                    [33] = u9
                --]]
                workspace.Gravity = 29.429999999999996
                u99 = u99 - p106
                u98 = u98 - p106
                u101 = u101 - p106
                u100 = u100 - p106
                local v107 = u23.TimePosition
                local v108
                if v107 >= 20 and v107 <= 25 then
                    v108 = true
                elseif v107 >= 70 then
                    v108 = v107 <= 94.5
                else
                    v108 = false
                end
                local v109 = (u23.PlaybackLoudness - 100) / 900
                local v110 = math.clamp(v109, 0, 1)
                for _, v111 in u58 do
                    local v112 = v110 / 0.05
                    v111.TimeScale = math.clamp(v112, 1, 2) * u62[v111]
                end
                for v113, v114 in u68 do
                    if v113.Name == "TungTung" then
                        local v115 = v114.Shuffle
                        local v116 = v110 * 0.5 / 0.13
                        v115:AdjustSpeed((math.clamp(v116, 0.25, 1)))
                    else
                        local v117 = v114.Shuffle
                        local v118 = v110 / 0.13
                        v117:AdjustSpeed((math.clamp(v118, 0.5, 1.5)))
                    end
                end
                if u41 then
                    local v119 = u41
                    local v120
                    if v108 then
                        v120 = 3
                    else
                        local v121 = v110 / 0.06
                        v120 = math.clamp(v121, 1, 3)
                    end
                    v119:AdjustSpeed(v120)
                end
                local v122
                if v107 >= 70 and v107 <= 94.5 then
                    if v107 >= 85 then
                        v122 = 0.05
                    else
                        local v123 = (v107 - 70) / 12
                        local v124 = math.min(v123, 1)
                        v122 = math.lerp(0.5, 0.2, v124)
                    end
                else
                    v122 = v108 and 0.1 or 0.3
                end
                if (v110 >= 0.11 or v108) and (u100 <= 0 and u96() <= 0) then
                    u100 = v122
                    u97 = u97 % #u46 + 1
                    u13(u76, TweenInfo.new(0.2), {
                        ["Value"] = u46[u97]
                    })
                end
                local v125 = u76.Value
                if v107 >= 94.3 and v107 <= 97.7 then
                    v125 = u103
                end
                local v126 = ColorSequence.new(v125)
                for _, v127 in u59 do
                    local v128
                    if u102[v127] then
                        v128 = u104
                    else
                        v128 = v126
                    end
                    v127.Color = v128
                end
                for _, v129 in u63 do
                    local v130
                    if u102[v129] then
                        v130 = u103
                    else
                        v130 = v125
                    end
                    v129.Color = v130
                end
                local v131
                if v108 then
                    v131 = 1.5
                else
                    local v132 = v110 / 0.25
                    v131 = math.clamp(v132, 0.05, 1)
                end
                local v133 = p106 * v131
                for _, v134 in u50 do
                    local v135 = u53[v134] or 0
                    local v136 = u54[v134] or 0
                    local v137 = (u52[v134] or 0) + v133
                    local v138 = math.clamp(v137, 0, 1)
                    u52[v134] = v138
                    if v138 >= 1 then
                        u52[v134] = 0
                        u53[v134] = v136
                        local v139 = u54
                        v139[v134] = v139[v134] * -1
                    else
                        local v140 = math.lerp(v135, v136, v138)
                        local v141 = math.rad(v140)
                        v134:PivotTo(u51[v134] * CFrame.Angles(0, v141, not u60 and 0 or v141))
                        if u60 then
                            for _, v142 in v134.Rotate.Neon:GetChildren() do
                                if v142.Name == "CustomAttachment_-1" or (v142.Name == "2" or v142.Name == "CustomAttachment_2") then
                                    local v143 = v142.Position.X
                                    local v144 = v138 * 3.141592653589793
                                    local v145 = math.sin(v144) * 100
                                    v142.Position = Vector3.new(v143, v145, 300)
                                end
                            end
                        end
                    end
                end
                if v108 and u99 <= 0 then
                    local v146 = math.random(100, 200)
                    u99 = v146 / 1000
                    local v147 = {}
                    for _, u148 in u55 do
                        v147[u148] = true
                        local v149 = u148.Width0 - 0.5
                        u148.Width0 = math.max(v149, 0.5)
                        local v150 = u148.Width1 - 2.5
                        u148.Width1 = math.max(v150, 1)
                        local v151 = u148.Brightness + 0.5
                        u148.Brightness = math.min(v151, 13)
                        u148.Enabled = false
                        task.delay(math.random(50, v146) / 1000, function() --[[Anonymous function at line 458]]
                            --[[
                            Upvalues:
                                [1] = u148
                            --]]
                            u148.Enabled = true
                        end)
                    end
                    for _, u152 in u59 do
                        if not v147[u152] then
                            u102[u152] = true
                            task.delay(math.random(50, v146) / 1000, function() --[[Anonymous function at line 469]]
                                --[[
                                Upvalues:
                                    [1] = u102
                                    [2] = u152
                                --]]
                                u102[u152] = nil
                            end)
                        end
                    end
                    for _, u153 in u63 do
                        u102[u153] = true
                        task.delay(math.random(50, v146) / 1000, function() --[[Anonymous function at line 476]]
                            --[[
                            Upvalues:
                                [1] = u102
                                [2] = u153
                            --]]
                            u102[u153] = nil
                        end)
                    end
                end
                if v107 >= 25 and not u56 then
                    u56 = true
                    for _, v154 in u50 do
                        local v155 = v154.Rotate.Neon["1"]
                        local v156 = v154.Rotate.Neon["2"]
                        local v157 = v156:Clone()
                        v157.Name = "CustomAttachment_1"
                        v157.Parent = v154.Rotate.Neon
                        u13(v156, TweenInfo.new(5), {
                            ["Position"] = v156.Position + Vector3.new(15, 0, 0)
                        })
                        u13(v157, TweenInfo.new(5), {
                            ["Position"] = v156.Position - Vector3.new(15, 0, 0)
                        })
                        local v158 = script.lightbeambig.Beams:Clone()
                        for _, v159 in v158:GetChildren() do
                            v159.Width0 = 0.5
                            v159.Width1 = 1
                            v159.Brightness = 13
                            v159.Attachment0 = v155
                            v159.Attachment1 = v157
                            v159.Parent = v154.Rotate.Neon
                            local v160 = u55
                            table.insert(v160, v159)
                            local v161 = u59
                            table.insert(v161, v159)
                        end
                        v158:Destroy()
                    end
                end
                if v107 >= 71 and not u60 then
                    u19.enable(u49)
                    task.delay(5, function() --[[Anonymous function at line 519]]
                        --[[
                        Upvalues:
                            [1] = u19
                            [2] = u49
                        --]]
                        u19.disable(u49)
                    end)
                    u60 = true
                    for _, v162 in u50 do
                        local v163 = v162.Rotate.Neon["1"]
                        local v164 = v162.Rotate.Neon["2"]
                        local v165 = v164.Position - Vector3.new(15, 0, 0)
                        u13(v164, TweenInfo.new(5), {
                            ["Position"] = v165
                        })
                        for v166 = -2, 2 do
                            if v166 ~= 0 then
                                local v167 = v164:Clone()
                                v167.Name = ("CustomAttachment_%*"):format(v166)
                                v167.Parent = v162.Rotate.Neon
                                local v168 = u13
                                local v169 = TweenInfo.new(5)
                                local v170 = {}
                                local v171 = v166 * 30
                                v170.Position = v165 + Vector3.new(v171, 0, 0)
                                v168(v167, v169, v170)
                                local v172 = script.lightbeambig.Beams:Clone()
                                for _, v173 in v172:GetChildren() do
                                    v173.Width0 = 0.5
                                    v173.Width1 = 1
                                    v173.Brightness = 13
                                    v173.Attachment0 = v163
                                    v173.Attachment1 = v167
                                    v173.Parent = v162.Rotate.Neon
                                    local v174 = u55
                                    table.insert(v174, v173)
                                    local v175 = u59
                                    table.insert(v175, v173)
                                end
                                v172:Destroy()
                            end
                        end
                    end
                end
                if v107 >= 36 and not u61 then
                    u61 = true
                    for _, v176 in u47.Rigs.Tralalero:GetChildren() do
                        if v176:IsA("BasePart") then
                            u13(v176, TweenInfo.new(1), {
                                ["Transparency"] = 0
                            })
                        end
                    end
                end
                if v107 >= 61.5 and not u57 then
                    u57 = true
                    for _, v177 in u47.Rigs.Chimpanzini:GetChildren() do
                        if v177:IsA("BasePart") then
                            u13(v177, TweenInfo.new(1), {
                                ["Transparency"] = 0
                            })
                        end
                    end
                end
                if (v110 >= 0.2 or v108) and u98 <= 0 then
                    u98 = v108 and 0.2 or 0.1
                    u9:Fov((v110 - 0.2) * 15 + 70, 0.1)
                end
            end))
        end)))
        for _, v178 in u47:GetDescendants() do
            if v178:IsA("BasePart") and v178.Name == "Neon" or v178:IsA("SpotLight") then
                table.insert(u63, v178)
            elseif v178:IsA("ParticleEmitter") or v178:IsA("Beam") then
                table.insert(u59, v178)
                if v178:IsA("ParticleEmitter") then
                    u62[v178] = v178.TimeScale
                    table.insert(u58, v178)
                end
            end
        end
        u25:Add((u38(10, 15, function(p179) --[[Anonymous function at line 613]]
            --[[
            Upvalues:
                [1] = u13
                [2] = u76
                [3] = u46
            --]]
            u13(u76, TweenInfo.new(p179()), {
                ["Value"] = u46[1]
            })
        end)))
    end
    u25:Add((u38(0, 5, function(p181) --[[Anonymous function at line 620]]
        --[[
        Upvalues:
            [1] = u13
            [2] = u42
            [3] = u180
            [4] = u8
            [5] = u25
        --]]
        u13(u42, TweenInfo.new(p181(), Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
            ["Brightness"] = -1
        })
        task.delay(p181(), u180)
        u8:Run("ConcertEvent", "GrassRecolor")
        u25:Add(function() --[[Anonymous function at line 628]]
            --[[
            Upvalues:
                [1] = u8
            --]]
            u8:Stop("ConcertEvent", "GrassRecolor")
        end)
        u8:Run("ConcertEvent", "WallRecolor")
        u25:Add(function() --[[Anonymous function at line 633]]
            --[[
            Upvalues:
                [1] = u8
            --]]
            u8:Stop("ConcertEvent", "WallRecolor")
        end)
        u8:Run("ConcertEvent", "WallBottomRecolor")
        u25:Add(function() --[[Anonymous function at line 638]]
            --[[
            Upvalues:
                [1] = u8
            --]]
            u8:Stop("ConcertEvent", "WallBottomRecolor")
        end)
    end)))
    u25:Add((u38(10, 15, function(p182) --[[Anonymous function at line 643]]
        --[[
        Upvalues:
            [1] = u13
            [2] = u42
        --]]
        u13(u42, TweenInfo.new(p182(), Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
            ["Brightness"] = -0.05
        })
    end)))
    local v183 = u25
    local v184 = task.delay
    local v185 = u27.startedAt + 24.5 - workspace:GetServerTimeNow()
    v183:Add(v184(math.max(v185, 0), function() --[[Anonymous function at line 652]]
        --[[
        Upvalues:
            [1] = u25
            [2] = u16
            [3] = u14
            [4] = u4
            [5] = u17
            [6] = u41
            [7] = u2
            [8] = u27
            [9] = u20
        --]]
        u25:Add(u16.new())
        u25:Add(u14.observeCharacter(u4.LocalPlayer, function(_, u186) --[[Anonymous function at line 656]]
            --[[
            Upvalues:
                [1] = u17
                [2] = u41
                [3] = u2
                [4] = u27
                [5] = u20
            --]]
            local u187 = u17.new()
            u187:Add(task.spawn(function() --[[Anonymous function at line 659]]
                --[[
                Upvalues:
                    [1] = u186
                    [2] = u41
                    [3] = u187
                    [4] = u2
                    [5] = u27
                    [6] = u20
                --]]
                local u188 = u186:WaitForChild("Humanoid")
                if u188 then
                    local v189 = u188:WaitForChild("Animator")
                    if v189 then
                        local u190 = v189:LoadAnimation(script.Dance)
                        u190.Priority = Enum.AnimationPriority.Action
                        u41 = u190
                        local u191 = 0
                        u187:Add(u2.PostSimulation:Connect(function(p192) --[[Anonymous function at line 677]]
                            --[[
                            Upvalues:
                                [1] = u27
                                [2] = u190
                                [3] = u188
                                [4] = u20
                                [5] = u191
                            --]]
                            workspace:GetServerTimeNow()
                            local v193 = u27.startedAt + 84.5 - workspace:GetServerTimeNow()
                            if math.max(v193, 0) > 0 then
                                if not u190.IsPlaying then
                                    u190:Play()
                                end
                            elseif u188.MoveDirection ~= Vector3.new(0, 0, 0) or u20:GetAttribute("Stealing") then
                                u191 = 0
                                if u190.IsPlaying then
                                    u190:Stop()
                                end
                            else
                                if u191 < 3 then
                                    u191 = u191 + p192
                                    return
                                end
                                if not u190.IsPlaying then
                                    u190:Play()
                                    return
                                end
                            end
                        end))
                        u187:Add(function() --[[Anonymous function at line 703]]
                            --[[
                            Upvalues:
                                [1] = u190
                                [2] = u41
                            --]]
                            u190:Stop()
                            u190:Destroy()
                            u41 = nil
                        end)
                    end
                else
                    return
                end
            end))
            return u187:WrapClean()
        end))
    end))
    u12:Update()
    u10:UpdateOST()
end
function v5.OnStop(_) --[[Anonymous function at line 718]]
    --[[
    Upvalues:
        [1] = u25
        [2] = u26
    --]]
    u25:Destroy()
    u26 = nil
end
function v5.OnLoad(_) --[[Anonymous function at line 723]] end
return v5