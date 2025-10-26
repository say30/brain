--[[
  Extracted from: ReplicatedStorage.Controllers.EventController.Events.Los Matteos
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

game:GetService("ServerScriptService")
local u1 = game:GetService("ReplicatedStorage")
local u2 = game:GetService("ContentProvider")
local u3 = game:GetService("RunService")
local u4 = game:GetService("Players")
local u5 = game:GetService("Debris")
require(u1.Shared.EventTypes)
local v6 = {}
local u7 = require(u1.Controllers.EffectController)
require(u1.Controllers.AnimalController)
local u8 = require(u1.Controllers.SoundController)
local u9 = require(u1.Controllers.CycleController)
local u10 = require(u1.Controllers.EventController)
require(u1.Controllers.EventController.ClientEventUtils)
local u11 = require(u1.Shared.SharedEventUtils)
local u12 = require(u1.Packages.EvLightning)
local u13 = require(u1.Packages.CreateTween)
local u14 = require(u1.Shared.ShakePresets)
local u15 = require(u1.Packages.Observers)
require(u1.Utils.MathUtils)
require(u1.Shared.Snapshot)
require(script.TreeRootAnimator)
local v16 = require(u1.Packages.Shake)
local v17 = require(u1.Packages.Trove)
local v18 = require(u1.Packages.Net)
local u19 = require(u1.Shared.VFX)
local u20 = script.Name
local u21 = script.Clouds:GetChildren()
local u22 = workspace.Events["Los Matteos"].CloudsStart
local u23 = workspace.Events["Los Matteos"].CloudsEnd
local u24 = v18:RemoteEvent("EventService/Los Matteos/CreateLightningBolt")
local u25 = RaycastParams.new()
u25.FilterDescendantsInstances = { workspace.Events["Los Matteos"].Areas }
u25.FilterType = Enum.RaycastFilterType.Include
local u26 = v17.new()
local u27 = Instance.new("Part")
u27.Anchored = true
u27.CanCollide = false
u27.TopSurface = Enum.SurfaceType.Smooth
u27.BottomSurface = Enum.SurfaceType.Smooth
u27.Material = Enum.Material.Neon
u27.Color = Color3.fromRGB(96, 234, 255)
local u28 = v16.new()
u28.Amplitude = 3
u28.Frequency = 0.1
u28.FadeInTime = 0
u28.FadeOutTime = 0.6
u28.PositionInfluence = Vector3.new(0.5, 0.5, 0.5)
u28.RotationInfluence = Vector3.new(2.5, 0.5, 0.5)
local function u46() --[[Anonymous function at line 64]]
    --[[
    Upvalues:
        [1] = u26
        [2] = u3
        [3] = u15
    --]]
	local v29 = u26:Extend()
	local u30 = table.create(4)
	v29:Add(function() --[[Anonymous function at line 76]]
        --[[
        Upvalues:
            [1] = u30
        --]]
		table.clear(u30)
	end)
	local u31 = 0
	v29:Add(u3.PreRender:Connect(function(p32) --[[Anonymous function at line 81]]
        --[[
        Upvalues:
            [1] = u31
            [2] = u30
        --]]
		debug.profilebegin("Los Matteos Event")
		u31 = u31 + p32
		for v33, v34 in u30 do
			if v34.target and v34.targetAttachment then
				v34.beam.First.Enabled = true
				v34.beam.Second.Enabled = true
				local v35 = u31 - v33 + 1
				local v36 = math.clamp(v35, 0, 1)
				local v37 = v34.beam.WorldPosition
				v34.targetAttachment.Position = v37 + (v34.target:GetPivot().Position - v37) * v36
			end
		end
		debug.profileend()
	end))
	v29:Add(u15.observeTag("LosMatteosPlayerVFX", function(u38) --[[Anonymous function at line 103]]
        --[[
        Upvalues:
            [1] = u30
            [2] = u15
        --]]
		local u39 = script.PlayerVFX.Beam:Clone()
		u39.Parent = u38
		local u40 = script.PlayerVFX.Torso:Clone()
		u40.Parent = u38
		local u41 = u38:GetAttribute("LosMatteosIndex")
		u30[u41] = {
			["beam"] = u39,
			["target"] = nil
		}
		local u45 = u15.observeTag("LosMatteosPlayerVFX", function(p42) --[[Anonymous function at line 116]]
            --[[
            Upvalues:
                [1] = u38
                [2] = u39
                [3] = u30
            --]]
			if p42 == u38 then
				return nil
			end
			if p42:GetAttribute("LosMatteosIndex") ~= u38:GetAttribute("LosMatteosIndex") % 3 + 1 then
				return nil
			end
			local u43 = Instance.new("Attachment")
			u43.Position = u39.WorldPosition
			u43.Parent = workspace.Terrain
			local v44 = u30[u38:GetAttribute("LosMatteosIndex")]
			v44.target = p42
			v44.beam.First.Attachment0 = u43
			v44.beam.Second.Attachment0 = u43
			v44.targetAttachment = u43
			return function() --[[Anonymous function at line 135]]
                --[[
                Upvalues:
                    [1] = u43
                --]]
				u43:Destroy()
			end
		end)
		return function() --[[Anonymous function at line 140]]
            --[[
            Upvalues:
                [1] = u40
                [2] = u39
                [3] = u45
                [4] = u30
                [5] = u41
            --]]
			u40:Destroy()
			u39:Destroy()
			u45()
			u30[u41] = nil
		end
	end))
end
function v6.OnStart(_) --[[Anonymous function at line 150]]
    --[[
    Upvalues:
        [1] = u10
        [2] = u20
        [3] = u1
        [4] = u25
        [5] = u26
        [6] = u7
        [7] = u9
        [8] = u8
        [9] = u13
        [10] = u15
        [11] = u4
        [12] = u22
        [13] = u23
        [14] = u21
        [15] = u3
        [16] = u11
        [17] = u24
        [18] = u28
        [19] = u14
        [20] = u19
        [21] = u5
        [22] = u12
        [23] = u27
        [24] = u46
    --]]
	local u47 = u10:GetActiveEventData(u20)
	assert(u47)
	local u48 = u1:GetAttribute("LosMatteosSpawn")
	if not u48 then
		u48 = workspace.MapCenter.Position
		local v49 = workspace:Raycast(u48, Vector3.new(-0, -25, -0), u25)
		if v49 then
			local v50 = u48.X
			local v51 = v49.Position.Y
			local v52 = u48.Z
			u48 = Vector3.new(v50, v51, v52)
		end
	end
	u1:SetAttribute("LosMatteosEvent", true)
	u26:Add(function() --[[Anonymous function at line 164]]
        --[[
        Upvalues:
            [1] = u1
            [2] = u7
            [3] = u9
            [4] = u8
        --]]
		u1:SetAttribute("LosMatteosEvent", nil)
		u7:Activate("Blink")
		u9:Update()
		u8:UpdateOST()
		u8:UpdateAmbience()
	end)
	local function u84(p53, p54, u55) --[[Anonymous function at line 177]]
        --[[
        Upvalues:
            [1] = u26
            [2] = u13
        --]]
		local function v71(u56, u57, u58, p59) --[[Anonymous function at line 178]]
            --[[
            Upvalues:
                [1] = u26
                [2] = u55
                [3] = u13
            --]]
			local u60 = u56.CFrame
			local v61 = p59 and 0 or u57.X
			local v62 = p59 and 0 or u57.Z
			local v63 = Vector3.new(v61, 0, v62)
			local v64 = u60 * CFrame.new(0, -(u57.Y - v63.Y) / 2, 0)
			u56.Size = v63
			u56.CFrame = v64
			local u65 = u56.Transparency
			u56.Transparency = 1
			local v66 = u26
			local v67 = task.delay
			local v68
			if u55 then
				v68 = u55(u58)
			else
				v68 = u58
			end
			v66:Add(v67(v68, function() --[[Anonymous function at line 189]]
                --[[
                Upvalues:
                    [1] = u56
                    [2] = u65
                    [3] = u55
                    [4] = u58
                    [5] = u13
                    [6] = u57
                    [7] = u60
                --]]
				u56.Transparency = u65
				local v69 = not u55 and 1 or u55(u58 + 1)
				local v70 = TweenInfo.new(v69, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
				u13(u56, v70, {
					["Size"] = u57
				})
				u13(u56, v70, {
					["CFrame"] = u60
				})
			end))
		end
		local v72 = {}
		local v73 = (1 / 0)
		local v74 = (-1 / 0)
		for _, v75 in p53:GetDescendants() do
			if v75:IsA("BasePart") and v75.Transparency < 1 then
				table.insert(v72, v75)
				local v76 = v75.Position.Y
				v73 = math.min(v73, v76)
				local v77 = v75.Position.Y
				v74 = math.max(v74, v77)
			end
		end
		table.sort(v72, function(p78, p79) --[[Anonymous function at line 215]]
			return p78.Position.Y < p79.Position.Y
		end)
		local v80 = v74 - v73
		for _, v81 in v72 do
			local v82 = v81.Color.R * 255 < 90
			local v83 = (v81.Position.Y - v73) / v80 * p54
			if v82 then
				v83 = v83 + 0.2
			end
			v71(v81, v81.Size, v83, v82)
		end
	end
	u26:Add(task.spawn(function() --[[Anonymous function at line 231]]
        --[[
        Upvalues:
            [1] = u8
            [2] = u1
            [3] = u48
        --]]
		u8:PlaySound(u1.Sounds.Events["Los Matteos"].Grow, u48, false)
	end))
	u26:Add(task.delay(u47.startedAt + 3 - workspace:GetServerTimeNow(), function() --[[Anonymous function at line 235]]
        --[[
        Upvalues:
            [1] = u1
            [2] = u26
            [3] = u9
            [4] = u8
            [5] = u48
            [6] = u84
            [7] = u47
        --]]
		u1:SetAttribute("LosMatteosEventNightTime", true)
		u26:Add(function() --[[Anonymous function at line 237]]
            --[[
            Upvalues:
                [1] = u1
            --]]
			u1:SetAttribute("LosMatteosEventNightTime", nil)
		end)
		u9:Update()
		u8:UpdateOST()
		u8:UpdateAmbience()
		local v85 = u26:Clone(script.Tree)
		v85:PivotTo(CFrame.new(u48))
		if u1:GetAttribute("LosMatteosEventIsRainbow") then
			for _, v86 in v85.Leaves:GetDescendants() do
				v86:SetAttribute("RainbowIgnoreTransparency", true)
				v86:AddTag("RainbowModel")
			end
		end
		v85.Parent = workspace
		u84(v85, 5, function(p87) --[[Anonymous function at line 257]]
            --[[
            Upvalues:
                [1] = u47
            --]]
			local v88 = p87 + 3
			return u47.startedAt + v88 - workspace:GetServerTimeNow()
		end)
	end))
	u26:Add(task.delay(u47.startedAt + 7 - workspace:GetServerTimeNow(), function() --[[Anonymous function at line 262]]
        --[[
        Upvalues:
            [1] = u1
        --]]
		u1.Sounds.Events["Los Matteos"].Roots:Play()
	end))
	u26:Add(function() --[[Anonymous function at line 266]]
        --[[
        Upvalues:
            [1] = u1
        --]]
		u1.Sounds.Events["Los Matteos"].Roots:Stop()
	end)
	u26:Add(u1:GetAttributeChangedSignal("LosMatteosGrowing"):Connect(function() --[[Anonymous function at line 270]]
        --[[
        Upvalues:
            [1] = u1
        --]]
		u1.Sounds.Events["Los Matteos"].Roots.Looped = u1:GetAttribute("LosMatteosGrowing") ~= false
	end))
	u26:Add(u15.observeTag("LosMatteos_Tree", function(p89) --[[Anonymous function at line 274]]
        --[[
        Upvalues:
            [1] = u84
        --]]
		u84(p89, 1)
		return nil
	end))
	u26:Add(u15.observeCharacter(u4.LocalPlayer, function(_, p90) --[[Anonymous function at line 279]]
        --[[
        Upvalues:
            [1] = u26
            [2] = u15
        --]]
		return u26:Add(u15.observeAttribute(p90, "Matteo_CollectedTree", function(p91) --[[Anonymous function at line 280]]
            --[[
            Upvalues:
                [1] = u26
                [2] = u15
            --]]
			if p91 then
				return u26:Add(u15.observeTag("LosMatteos_TreePrompt", function(u92) --[[Anonymous function at line 286]]
					u92.Enabled = false
					return function() --[[Anonymous function at line 290]]
                        --[[
                        Upvalues:
                            [1] = u92
                        --]]
						u92.Enabled = true
					end
				end, { workspace }))
			else
				return nil
			end
		end))
	end))
	local u93 = {}
	local function v123() --[[Anonymous function at line 306]]
        --[[
        Upvalues:
            [1] = u22
            [2] = u23
            [3] = u26
            [4] = u21
            [5] = u13
            [6] = u93
            [7] = u3
            [8] = u11
        --]]
		local function u109(p94, p95) --[[Anonymous function at line 310]]
            --[[
            Upvalues:
                [1] = u22
                [2] = u23
                [3] = u26
                [4] = u21
                [5] = u13
                [6] = u93
            --]]
			local v96 = u22.Position
			local v97 = u22.Size
			local v98 = u23.Position
			local v99 = u26:Clone(u21[math.random(1, #u21)])
			v99.Transparency = 1
			v99.CFrame = CFrame.new(v96.X + math.random(-v97.X * 0.5, v97.X * 0.5), v96.Y, v96.Z + (p94 or 0) * 30 + (p95 or 0))
			local v100 = v99.Position.X
			local v101 = v96.Y
			local v102 = v98.Z
			local v103 = Vector3.new(v100, v101, v102)
			local v104 = v98 - v96
			local v105 = v103 - v99.Position
			if vector.dot(v104, v105) >= 0 then
				v99.Parent = workspace.Camera
				local v106 = 50 / v99.Size.Magnitude
				local v107 = {
					["instance"] = v99,
					["speed"] = math.clamp(v106, 5, 15) * (math.random(80, 120) / 100),
					["startPos"] = v99.Position,
					["endPos"] = v103
				}
				u26:Add(u13(v99, TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, (p95 or 0) * 0.1 + (math.abs(p94 or 0) + 1) * 0.5), {
					["Transparency"] = 0
				}))
				local v108 = u93
				table.insert(v108, v107)
				return v107
			end
		end
		local v110 = 0
		for v111 = 1, 50 do
			u109(v110, v111)
			if v111 % 3 == 1 then
				v110 = v110 + 1
			end
		end
		u26:Add(u3.PostSimulation:Connect(function(p112) --[[Anonymous function at line 360]]
            --[[
            Upvalues:
                [1] = u93
                [2] = u26
                [3] = u13
                [4] = u109
                [5] = u11
            --]]
			for v113 = #u93, 1, -1 do
				local v114 = u93[v113]
				local u115 = v114.instance
				local v116 = u115.Position
				local v117 = v114.endPos - v116
				local v118 = vector.normalize(v117)
				local v119 = v114.endPos - v116
				local v120 = vector.magnitude(v119)
				local v121 = v114.speed * p112
				local v122
				if v120 < v121 then
					v122 = v114.endPos
					table.remove(u93, v113)
					u26:Add(u13(u115, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
						["Transparency"] = 1
					})).Completed:Once(function() --[[Anonymous function at line 379]]
                        --[[
                        Upvalues:
                            [1] = u26
                            [2] = u115
                        --]]
						u26:Remove(u115)
					end)
					u109()
				else
					v122 = v116 + v118 * v121
				end
				u11.pushPartCFrame(u115, CFrame.lookAt(v122, v122 + v118))
			end
		end))
	end
	u26:Add(task.delay(u47.startedAt + 8 - workspace:GetServerTimeNow(), function() --[[Anonymous function at line 394]]
        --[[
        Upvalues:
            [1] = u26
        --]]
		u26:Clone(script.RainWeather).Parent = workspace
	end))
	u26:Add(u24.OnClientEvent:Connect(function(p124, u125, u126) --[[Anonymous function at line 399]]
        --[[
        Upvalues:
            [1] = u28
            [2] = u26
            [3] = u14
            [4] = u93
            [5] = u8
            [6] = u1
            [7] = u13
            [8] = u19
            [9] = u5
            [10] = u12
            [11] = u27
        --]]
		local v127 = Random.new(p124)
		local v128 = (workspace.CurrentCamera.CFrame.Position - u125).Magnitude
		if v128 <= 75 then
			local v129 = u28:Clone()
			local v130 = (1 - v128 / 75 * 0.5) ^ 2
			v129.Amplitude = v129.Amplitude * v130
			v129.RotationInfluence = v129.RotationInfluence * v130
			u26:Add(u14.BindShakeToCamera(v129))
			v129:Start()
		end
		local v131 = {}
		for _, v132 in u93 do
			if ((v132.instance.Position - u125) * Vector3.new(1, 0, 1)).Magnitude < 100 then
				local v133 = v132.instance
				table.insert(v131, v133)
			end
		end
		local v134
		if #v131 > 0 then
			local v135 = v131[v127:NextInteger(1, #v131)]
			v134 = v135.Position
			u8:PlaySound(u1.Sounds.Events["Los Matteos"]["Lightning Strike"], v135.Position, false)
			local v136 = v135.Color
			v135.Color = Color3.fromRGB(90, 109, 161)
			u13(v135, TweenInfo.new(1, Enum.EasingStyle.Sine), {
				["Color"] = v136
			})
			for _, v137 in script.CloudParticles:GetChildren() do
				local v138 = v137:Clone()
				v138.Parent = v135
				u19.emit(v138)
				u5:AddItem(v138, 2)
			end
		else
			v134 = u125 + Vector3.new(0, 70, 0)
		end
		local u139 = u12.create(v134, u125, {
			["bends"] = 4,
			["thickness"] = 1,
			["max_depth"] = 1,
			["fork_bends"] = 1,
			["fork_chance"] = 30,
			["decay"] = 3,
			["material"] = Enum.Material.Neon
		})
		local u140 = Instance.new("Model")
		u139.model = u140
		u140.Name = "LightningBolt"
		local v141 = u139:GetLines()
		table.sort(v141, function(p142, p143) --[[Anonymous function at line 465]]
			return p142.origin.Y > p143.origin.Y
		end)
		local v144 = v141[#v141].origin.Y
		local v145 = v141[1].origin.Y
		local v146 = v145 - v144
		local v147 = u139.random:NextInteger(10, 20) / 100
		local u148 = table.create(#v141)
		for v149, v150 in v141 do
			if v150.goal.Y >= u125.Y then
				local v151 = (v145 - v150.origin.Y) / v146 * v147
				local v152 = math.max(v151, 0)
				local v153 = u27:Clone()
				local v154 = u139.thickness - v150.depth * 2 * 0.1
				local v155 = u139.thickness - v150.depth * 2 * 0.1
				local v156 = (v150.origin - v150.goal).Magnitude + 0.5
				v153.Size = Vector3.new(v154, v155, v156)
				v153.CFrame = CFrame.new((v150.goal + v150.origin) / 2, v150.goal)
				v153.Transparency = 1
				v153.Parent = u140
				u148[v149] = v153
				u13(v153, TweenInfo.new(0.05, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, v152), {
					["Transparency"] = v150.transparency
				})
			end
		end
		task.delay(v147 + 0.05, function() --[[Anonymous function at line 496]]
            --[[
            Upvalues:
                [1] = u126
                [2] = u125
                [3] = u19
                [4] = u8
                [5] = u1
                [6] = u148
                [7] = u13
                [8] = u139
                [9] = u140
            --]]
			local u157
			if u126 then
				u157 = script.StrikeBrainrot:Clone()
			else
				u157 = script.Strike:Clone()
			end
			u157.Position = u125
			u157.Parent = workspace
			u19.emit(u157)
			if u126 then
				u8:PlaySound(u1.Sounds.Events["Los Matteos"].Hit, u125, false)
			else
				u8:PlaySound(u1.Sounds.Events["Los Matteos"].HitNothing, u125, false)
			end
			for _, u158 in u148 do
				task.spawn(function() --[[Anonymous function at line 510]]
                    --[[
                    Upvalues:
                        [1] = u158
                        [2] = u13
                    --]]
					u158.Transparency = 0
					task.wait(0.1)
					u158.Transparency = 1
					task.wait(0.1)
					u13(u158, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, true), {
						["Transparency"] = 0.4
					})
				end)
			end
			task.delay(u139.options.decay or 1, function() --[[Anonymous function at line 521]]
                --[[
                Upvalues:
                    [1] = u157
                    [2] = u140
                    [3] = u139
                --]]
				u157:Destroy()
				u140:Destroy()
				u139.destroyed = true
			end)
		end)
		u140.Parent = workspace.CurrentCamera
		u139.drew = true
	end))
	v123()
	u26:Add(task.spawn(function() --[[Anonymous function at line 534]]
        --[[
        Upvalues:
            [1] = u46
        --]]
		u46()
	end))
end
function v6.OnStop(_) --[[Anonymous function at line 539]]
    --[[
    Upvalues:
        [1] = u26
    --]]
	u26:Destroy()
end
function v6.OnLoad(_) --[[Anonymous function at line 543]]
    --[[
    Upvalues:
        [1] = u2
    --]]
	task.spawn(pcall, function() --[[Anonymous function at line 544]]
        --[[
        Upvalues:
            [1] = u2
        --]]
		u2:PreloadAsync(script:GetChildren())
	end)
end
return v6