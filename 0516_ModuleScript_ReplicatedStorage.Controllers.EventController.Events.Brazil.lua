--[[
  Extracted from: ReplicatedStorage.Controllers.EventController.Events.Brazil
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local u1 = game:GetService("ReplicatedStorage")
local u2 = game:GetService("ContentProvider")
game:GetService("TweenService")
local u3 = game:GetService("RunService")
local u4 = game:GetService("Lighting")
local u5 = game:GetService("Players")
game:GetService("Debris")
require(u1.Shared.EventTypes)
local v6 = {}
local u7 = require(u1.Controllers.EncryptedAssetsController)
local u8 = require(u1.Controllers.AnimalController)
local u9 = require(u1.Controllers.EffectController)
local u10 = require(u1.Controllers.CameraController)
local u11 = require(u1.Controllers.SoundController)
local u12 = require(u1.Controllers.EventController)
local u13 = require(u1.Controllers.CycleController)
local u14 = require(u1.Shared.SharedEventUtils)
local u15 = require(u1.Packages.CreateTween)
require(u1.Shared.TweenPivot)
local u16 = require(u1.Packages.Observers)
require(u1.Utils.MathUtils)
require(u1.Packages.Signal)
require(u1.Packages.Spring)
local u17 = require(u1.Packages.Trove)
require(u1.Packages.Shake)
local v18 = require(u1.Packages.Net)
local u19 = require(u1.Shared.VFX)
local u20 = u5.LocalPlayer
local u21 = workspace.CurrentCamera
local u22 = Color3.fromRGB(128, 255, 0)
local u23 = Color3.fromRGB(0, 255, 0)
local u24 = script.Name
local u25 = workspace.Sounds.BrazilEvent
local u26 = workspace.Events.Brazil.FullMapFloor
local u27 = v18:RemoteEvent("EventService/Brazil/Focus")
local u28 = v18:RemoteEvent("EventService/Brazil/Burst")
local u29 = u17.new()
local function u33() --[[Anonymous function at line 52]]
    --[[
    Upvalues:
        [1] = u26
    --]]
	local v30 = u26.Position
	local v31 = u26.Size.X * 0.5 * (math.random(0, 1) * 2 - 1)
	local v32 = u26.Size.Z * 0.5 * (math.random(0, 1) * 2 - 1)
	return v30 + Vector3.new(v31, 0, v32)
end
local function u37(p34) --[[Anonymous function at line 60]]
	local u35 = Instance.new("Attachment")
	u35.Name = "Attachment"
	u35.CFrame = CFrame.new(0, 3, 0)
	local u36 = Instance.new("PointLight")
	u36.Name = "PointLight"
	u36.Brightness = 4
	u36.Color = Color3.fromRGB(255, 157, 0)
	u36.Range = 6
	u36.Parent = u35
	u35.Parent = p34
	return function() --[[Anonymous function at line 74]]
        --[[
        Upvalues:
            [1] = u35
            [2] = u36
        --]]
		u35:Destroy()
		u36:Destroy()
	end
end
function v6.OnStart(_) --[[Anonymous function at line 80]]
    --[[
    Upvalues:
        [1] = u12
        [2] = u24
        [3] = u29
        [4] = u9
        [5] = u13
        [6] = u11
        [7] = u28
        [8] = u8
        [9] = u1
        [10] = u19
        [11] = u4
        [12] = u21
        [13] = u16
        [14] = u5
        [15] = u17
        [16] = u3
        [17] = u20
        [18] = u14
        [19] = u27
        [20] = u37
        [21] = u25
        [22] = u7
        [23] = u33
        [24] = u15
        [25] = u22
        [26] = u23
        [27] = u10
    --]]
	local u38 = u12:GetActiveEventData(u24)
	assert(u38)
	local function u49(p39, u40, u41) --[[Anonymous function at line 88]]
        --[[
        Upvalues:
            [1] = u38
        --]]
		local function u44() --[[Anonymous function at line 89]]
            --[[
            Upvalues:
                [1] = u40
                [2] = u38
            --]]
			local v42 = u40
			local v43 = u38.startedAt + v42 - workspace:GetServerTimeNow()
			return math.max(v43, 0)
		end
		local function v45() --[[Anonymous function at line 93]]
            --[[
            Upvalues:
                [1] = u41
                [2] = u44
            --]]
			u41(u44)
		end
		local u46 = nil
		local v47 = u38.startedAt + p39 - workspace:GetServerTimeNow()
		local v48 = math.max(v47, 0)
		if v48 > 0 then
			u46 = task.delay(v48, v45)
		else
			u41(u44)
		end
		return function() --[[Anonymous function at line 106]]
            --[[
            Upvalues:
                [1] = u46
            --]]
			if u46 and coroutine.status(u46) == "suspended" then
				pcall(task.cancel, u46)
			end
		end
	end
	u29:Add(function() --[[Anonymous function at line 113]]
        --[[
        Upvalues:
            [1] = u9
            [2] = u13
            [3] = u11
        --]]
		u9:Activate("Blink")
		u13:Update()
		u11:UpdateOST()
	end)
	u29:Add(u28.OnClientEvent:Connect(function(p50) --[[Anonymous function at line 119]]
        --[[
        Upvalues:
            [1] = u8
            [2] = u11
            [3] = u1
            [4] = u19
        --]]
		local v51 = u8:GetAnimals()[p50]
		if v51 then
			local v52 = v51.AnimalModel
			local v53
			if v52.PrimaryPart then
				v53 = v52.PrimaryPart.CFrame
			else
				v53 = v52:GetPivot()
			end
			local u54 = v53.Position
			task.spawn(function() --[[Anonymous function at line 140]]
                --[[
                Upvalues:
                    [1] = u11
                    [2] = u1
                    [3] = u54
                --]]
				u11:PlaySound(u1.Sounds.Events.Brazil.Hit, u54)
			end)
			local u55 = script.Burst:Clone()
			u55:PivotTo(CFrame.new(u54))
			u55.Anchored = false
			local v56 = Instance.new("WeldConstraint")
			v56.Part0 = u55
			v56.Part1 = v51.AnimalModel.PrimaryPart
			v56.Parent = u55
			u55.Parent = workspace
			u19.emit(u55)
			task.delay(5, function() --[[Anonymous function at line 157]]
                --[[
                Upvalues:
                    [1] = u55
                --]]
				u55:Destroy()
			end)
		end
	end))
	local u57 = u4:FindFirstChild("Cartoon")
	if u57 then
		u57.Parent = u1
		u29:Add(function() --[[Anonymous function at line 165]]
            --[[
            Upvalues:
                [1] = u57
                [2] = u4
            --]]
			u57.Parent = u4
		end)
	end
	local u58 = u29:Clone(Instance.new("ColorCorrectionEffect"))
	u58.Parent = u21
	local u59 = nil
	local u60 = u29:Clone(script.Stage)
	local u61 = u29:Clone(script.VFX)
	local function u108() --[[Anonymous function at line 243]]
        --[[
        Upvalues:
            [1] = u61
            [2] = u29
            [3] = u16
            [4] = u17
            [5] = u3
            [6] = u8
            [7] = u1
            [8] = u14
            [9] = u27
        --]]
		local u62 = {}
		local u63 = {}
		local u64 = {}
		for _, v65 in u61.Square.Bottom:GetChildren() do
			if v65:IsA("Attachment") then
				u62[v65] = v65.Position
				table.insert(u63, v65)
			end
		end
		for _, v66 in u61.Square.Top:GetChildren() do
			if v66:IsA("Attachment") then
				u62[v66] = v66.Position
				table.insert(u64, v66)
			end
		end
		local u67 = Vector3.new(9, 9, 9)
		for _, v68 in u63 do
			v68.Position = u62[v68] * Vector3.new(1, 1, 1) * 9
		end
		for _, v69 in u64 do
			v69.Position = u62[v69] * Vector3.new(1, 1, 1) * 9
		end
		u29:Add(u16.observeTag("BrazilHitbox", function(u70) --[[Anonymous function at line 275]]
            --[[
            Upvalues:
                [1] = u17
                [2] = u3
                [3] = u8
                [4] = u1
                [5] = u67
                [6] = u64
                [7] = u62
                [8] = u63
                [9] = u14
                [10] = u61
                [11] = u27
            --]]
			local v71 = u17.new()
			local u72 = nil
			local u73 = nil
			local u74 = 0
			local u75 = false
			v71:Add(u3.PostSimulation:Connect(function(p76) --[[Anonymous function at line 285]]
                --[[
                Upvalues:
                    [1] = u70
                    [2] = u73
                    [3] = u8
                    [4] = u75
                    [5] = u1
                    [6] = u74
                    [7] = u72
                    [8] = u67
                    [9] = u64
                    [10] = u62
                    [11] = u63
                    [12] = u14
                    [13] = u61
                --]]
				local v77 = workspace:GetServerTimeNow()
				local v78 = u70.CFrame
				local v79 = u70:GetAttribute("Focused")
				local v80
				if u73 and (v79 and v79 <= v77) then
					v80 = u8:GetAnimals()[u73]
				else
					v80 = nil
				end
				if v80 then
					if not u75 then
						u75 = true
						local u81 = u1.Sounds.Events.Brazil.Cube:Clone()
						u81.Parent = u70
						u81:Play()
						u81.Ended:Once(function() --[[Anonymous function at line 297]]
                            --[[
                            Upvalues:
                                [1] = u81
                            --]]
							u81:Destroy()
						end)
					end
					local v82 = (v77 - v79) / 1
					local v83 = math.clamp(v82, 0, 1)
					local v84 = (v77 - (v79 + 1)) / 1
					u74 = math.clamp(v84, 0, 1)
					local v85 = v80.AnimalModel
					local v86 = v85:FindFirstChild("VfxInstance")
					local v87 = v80.Instance:GetPivot()
					local v88
					if v86 then
						v88 = v86.Size
					else
						v88 = v85:GetExtentsSize()
					end
					local v89 = (v88 * Vector3.new(1.25, 1.5, 1.25)):Min(Vector3.new(9, 18, 9))
					v78 = CFrame.new(v87.X, v78.Y, v87.Z)
					if not u72 then
						u72 = u67
					end
					local v90 = u72
					assert(v90)
					local v91 = u72:Lerp(v89, v83)
					local v92 = u72
					local v93 = v89.X
					local v94 = v89.Z
					local v95 = v92:Lerp(Vector3.new(v93, 0, v94), v83)
					u67 = v91
					for _, v96 in u64 do
						local v97 = u62[v96]
						local v98 = u74 * 1
						v96.Position = (v97 + Vector3.new(0, v98, 0)) * v91
					end
					for _, v99 in u63 do
						v99.Position = u62[v99] * v95
					end
				else
					if u75 then
						u75 = false
					end
					local v100 = -4 * p76
					local v101 = math.exp(v100)
					u67 = (Vector3.new(9, 9, 9)):Lerp(u67, v101)
					u72 = u67
					local v102 = u74
					u74 = math.lerp(0, v102, v101)
					for _, v103 in u64 do
						local v104 = u62[v103]
						local v105 = u74 * 1
						v103.Position = (v104 + Vector3.new(0, v105, 0)) * u67
					end
					for _, v106 in u63 do
						v106.Position = u62[v106] * u67
					end
				end
				u14.pushPartCFrame(u61.Square, v78)
			end))
			v71:Add(u27.OnClientEvent:Connect(function(p107) --[[Anonymous function at line 356]]
                --[[
                Upvalues:
                    [1] = u72
                    [2] = u67
                    [3] = u73
                --]]
				u72 = u67
				u73 = p107
			end))
			return v71:WrapClean()
		end, { workspace }))
	end
	local function u115() --[[Anonymous function at line 365]]
        --[[
        Upvalues:
            [1] = u29
            [2] = u16
            [3] = u17
            [4] = u37
        --]]
		u29:Add(u16.observeCharacters(function(_, u109) --[[Anonymous function at line 366]]
            --[[
            Upvalues:
                [1] = u17
                [2] = u37
            --]]
			local u110 = u17.new()
			u110:Add(task.spawn(function() --[[Anonymous function at line 369]]
                --[[
                Upvalues:
                    [1] = u109
                    [2] = u110
                    [3] = u37
                --]]
				local v111 = u109:WaitForChild("UpperTorso")
				if v111 then
					u110:Add((u37(v111)))
				end
			end))
			return u110:WrapClean()
		end))
		u29:Add(u16.observeChildren(workspace.RenderedMovingAnimals, function(u112) --[[Anonymous function at line 381]]
            --[[
            Upvalues:
                [1] = u17
                [2] = u37
            --]]
			local u113 = u17.new()
			u113:Add(task.spawn(function() --[[Anonymous function at line 384]]
                --[[
                Upvalues:
                    [1] = u112
                    [2] = u113
                    [3] = u37
                --]]
				local v114 = u112:WaitForChild("RootPart")
				if v114 then
					u113:Add((u37(v114)))
				end
			end))
			return u113:WrapClean()
		end))
	end
	local function u193() --[[Anonymous function at line 397]]
        --[[
        Upvalues:
            [1] = u4
            [2] = u29
            [3] = u25
            [4] = u7
            [5] = u38
            [6] = u61
            [7] = u60
            [8] = u19
            [9] = u115
            [10] = u108
            [11] = u33
            [12] = u3
            [13] = u15
            [14] = u22
            [15] = u23
            [16] = u59
            [17] = u10
            [18] = u49
        --]]
		u4.Ambient = Color3.fromRGB(50, 50, 50)
		u4.OutdoorAmbient = Color3.fromRGB(71, 71, 71)
		u29:Add(function() --[[Anonymous function at line 400]]
            --[[
            Upvalues:
                [1] = u4
            --]]
			u4.Ambient = Color3.fromRGB(241, 241, 241)
			u4.OutdoorAmbient = Color3.fromRGB(212, 212, 212)
		end)
		u29:Add(function() --[[Anonymous function at line 406]]
            --[[
            Upvalues:
                [1] = u25
            --]]
			u25:Stop()
		end)
		u29:Add(task.spawn(function() --[[Anonymous function at line 410]]
            --[[
            Upvalues:
                [1] = u7
                [2] = u25
                [3] = u38
            --]]
			u7:WaitForAssetId("rbxassetid://136243635275209")
			u25.SoundId = "rbxassetid://136243635275209"
			while not u25.IsLoaded do
				task.wait()
			end
			u25.TimePosition = workspace:GetServerTimeNow() - (u38.startedAt + 5)
			u25:Play()
		end))
		u29:Clone(script.Night_Sky).Parent = u4
		u61.Parent = u60
		u19.disable(u61)
		local u116 = u29:Add(Instance.new("Color3Value"))
		u116.Value = Color3.fromRGB(0, 0, 0)
		local u117 = u29:Add(Instance.new("Color3Value"))
		u117.Value = Color3.fromRGB(0, 0, 0)
		u19.enable(u61)
		u19.disable(u61.firestuff)
		u115()
		u108()
		local u118 = {}
		local u119 = {}
		local u120 = {}
		local u121 = {}
		local u122 = {}
		local u123 = 0
		local u124 = 0
		local u125 = 1
		for _, v126 in u60:GetDescendants() do
			if v126:IsA("SpotLight") then
				table.insert(u118, v126)
			elseif v126:IsA("ParticleEmitter") or v126:IsA("Beam") then
				if v126:IsDescendantOf(u61.Square) or v126:IsDescendantOf(u61.bigbeams) then
					table.insert(u119, v126)
				else
					table.insert(u122, v126)
				end
				if v126:IsA("ParticleEmitter") then
					u120[v126] = v126.TimeScale
					table.insert(u121, v126)
				end
			end
		end
		local u127 = {}
		local u128 = {}
		local u129 = {}
		local u130 = {}
		for _, v131 in u61.initial:GetChildren() do
			local v132 = v131.att1
			u127[v132] = u33()
			u128[v132] = u33()
			v132.WorldCFrame = CFrame.new(u128[v132])
			table.insert(u129, v132)
			for _, v133 in v132:GetChildren() do
				table.insert(u130, v133)
			end
		end
		local u134 = {}
		local u135 = {}
		local u136 = {}
		for _, v137 in u61.thinbeams:GetChildren() do
			local v138 = v137.att1
			u127[v138] = u33()
			u128[v138] = u33()
			v138.WorldCFrame = CFrame.new(u128[v138])
			table.insert(u134, v138)
			local v139 = {}
			for _, v140 in v138:GetChildren() do
				v140.Enabled = false
				table.insert(v139, v140)
			end
			u135[v139] = v137.Position.Y
			table.insert(u136, v139)
		end
		table.sort(u136, function(p141, p142) --[[Anonymous function at line 501]]
            --[[
            Upvalues:
                [1] = u135
            --]]
			return u135[p141] < u135[p142]
		end)
		local u143 = false
		local u144 = false
		local u145 = 0
		u29:Add(u3.PostSimulation:Connect(function(p146) --[[Anonymous function at line 509]]
            --[[
            Upvalues:
                [1] = u124
                [2] = u123
                [3] = u25
                [4] = u121
                [5] = u120
                [6] = u145
                [7] = u127
                [8] = u33
                [9] = u134
                [10] = u129
                [11] = u128
                [12] = u136
                [13] = u143
                [14] = u19
                [15] = u61
                [16] = u130
                [17] = u144
                [18] = u38
                [19] = u125
                [20] = u15
                [21] = u116
                [22] = u22
                [23] = u23
                [24] = u117
                [25] = u59
                [26] = u122
                [27] = u119
                [28] = u118
                [29] = u10
            --]]
			local v147 = workspace:GetServerTimeNow()
			u124 = u124 - p146
			u123 = u123 - p146
			local v148 = u25.TimePosition
			local v149 = u25.PlaybackLoudness
			local v150 = v149 / 1000
			local v151 = math.clamp(v150, 0, 1)
			for _, v152 in u121 do
				local v153 = v151 / 0.05
				v152.TimeScale = math.clamp(v153, 1, 2) * u120[v152]
			end
			if v149 >= 320 and v147 - u145 >= 2 then
				u145 = v147
				for v154, _ in u127 do
					u127[v154] = u33()
				end
			end
			for _, v155 in { u134, u129 } do
				for _, v156 in v155 do
					local v157 = u128[v156]
					local v158 = u127[v156]
					local v159 = v158 - v157
					local v160 = vector.magnitude(v159)
					local v161 = (v149 - 100) / 200
					local v162 = math.clamp(v161, 0, 1)
					local v163 = math.lerp(35, 120, v162) * p146
					if v160 < v163 then
						u127[v156] = u33()
					else
						v158 = v157 + vector.normalize(v159) * v163
					end
					u128[v156] = v158
					v156.WorldCFrame = CFrame.new(v158)
				end
			end
			if v148 >= 17 then
				local v164 = (v148 - 17) // #u136
				local v165 = math.max(v164, 2)
				if v148 >= 82 then
					v165 = v165 + 10
				end
				local v166 = #u136
				for v167 = 1, math.min(v165, v166) do
					for _, v168 in u136[v167] do
						v168.Enabled = true
					end
				end
			end
			if v148 >= 17 and not u143 then
				u19.enable(u61.firestuff)
				task.delay(5.5, function() --[[Anonymous function at line 569]]
                    --[[
                    Upvalues:
                        [1] = u19
                        [2] = u61
                    --]]
					u19.disable(u61.firestuff)
				end)
				u143 = true
				for _, v169 in u130 do
					v169.Enabled = false
				end
			end
			if v148 >= 83 and not u144 then
				u144 = true
				u19.enable(u61.firestuff)
				task.delay(5.5, function() --[[Anonymous function at line 583]]
                    --[[
                    Upvalues:
                        [1] = u19
                        [2] = u61
                    --]]
					u19.disable(u61.firestuff)
				end)
			end
			if v151 >= 0.11 and u123 <= 0 then
				local v170 = u38.startedAt + 6 - workspace:GetServerTimeNow()
				if math.max(v170, 0) <= 0 then
					u123 = 0.4
					u125 = u125 == 1 and 2 or 1
					local v171 = u15
					local v172 = u116
					local v173 = TweenInfo.new(0.2)
					local v174 = {}
					local v175
					if u125 == 1 then
						v175 = u22
					else
						v175 = u23
					end
					v174.Value = v175
					v171(v172, v173, v174)
					local v176 = u15
					local v177 = u117
					local v178 = TweenInfo.new(0.2)
					local v179 = {}
					local v180
					if u125 == 1 then
						v180 = u23
					else
						v180 = u22
					end
					v179.Value = v180
					v176(v177, v178, v179)
				end
			end
			if u59 then
				local v181 = u59
				local v182 = v151 / 0.07
				v181:AdjustSpeed((math.clamp(v182, 0.8, 1.5)))
			end
			local v183 = u116.Value
			local v184 = u117.Value
			local v185 = ColorSequence.new(v183)
			local v186 = ColorSequence.new(v184)
			for _, v187 in u122 do
				v187.Color = v185
			end
			for _, v188 in u119 do
				v188.Color = v186
			end
			for _, v189 in u118 do
				v189.Color = v183
			end
			if v151 >= 0.1 and u124 <= 0 then
				u124 = 0.1
				u10:Fov(v151 / 0.7 * 15 + 70, 0.1)
			end
		end))
		u29:Add((u49(5, 6, function(p190) --[[Anonymous function at line 631]]
            --[[
            Upvalues:
                [1] = u15
                [2] = u116
                [3] = u22
                [4] = u117
                [5] = u23
            --]]
			local v191 = {
				["Value"] = u22
			}
			u15(u116, TweenInfo.new(p190()), v191)
			local v192 = {
				["Value"] = u23
			}
			u15(u117, TweenInfo.new(p190()), v192)
		end)))
		u60.Parent = workspace
	end
	u29:Add((u49(0, 5, function(p194) --[[Anonymous function at line 644]]
        --[[
        Upvalues:
            [1] = u15
            [2] = u58
            [3] = u9
            [4] = u29
            [5] = u193
            [6] = u38
        --]]
		u15(u58, TweenInfo.new(p194(), Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
			["Brightness"] = -1.2
		})
		u9:Run("BrazilEvent", "GrassRecolor")
		u29:Add(function() --[[Anonymous function at line 650]]
            --[[
            Upvalues:
                [1] = u9
            --]]
			u9:Stop("BrazilEvent", "GrassRecolor")
		end)
		u29:Add(task.delay(p194(), function() --[[Anonymous function at line 654]]
            --[[
            Upvalues:
                [1] = u193
                [2] = u15
                [3] = u58
                [4] = u38
            --]]
			u193()
			local v195 = u15
			local v196 = u58
			local v197 = TweenInfo.new
			local v198 = u38.startedAt + 6 - workspace:GetServerTimeNow()
			v195(v196, v197(math.max(v198, 0), Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
				["Brightness"] = 0
			})
		end))
	end)))
	local v199 = u29
	local v200 = task.delay
	local v201 = u38.startedAt + 20 - workspace:GetServerTimeNow()
	v199:Add(v200(math.max(v201, 0), function() --[[Anonymous function at line 182]]
        --[[
        Upvalues:
            [1] = u29
            [2] = u16
            [3] = u5
            [4] = u17
            [5] = u59
            [6] = u3
            [7] = u38
            [8] = u20
        --]]
		u29:Add(u16.observeCharacter(u5.LocalPlayer, function(_, u202) --[[Anonymous function at line 184]]
            --[[
            Upvalues:
                [1] = u17
                [2] = u59
                [3] = u3
                [4] = u38
                [5] = u20
            --]]
			local u203 = u17.new()
			u203:Add(task.spawn(function() --[[Anonymous function at line 187]]
                --[[
                Upvalues:
                    [1] = u202
                    [2] = u59
                    [3] = u203
                    [4] = u3
                    [5] = u38
                    [6] = u20
                --]]
				local u204 = u202:WaitForChild("Humanoid")
				if u204 then
					local v205 = u204:WaitForChild("Animator")
					if v205 then
						local u206 = v205:LoadAnimation(script.Dance)
						u206.Priority = Enum.AnimationPriority.Action
						u59 = u206
						local u207 = 0
						u203:Add(u3.PostSimulation:Connect(function(p208) --[[Anonymous function at line 205]]
                            --[[
                            Upvalues:
                                [1] = u38
                                [2] = u206
                                [3] = u204
                                [4] = u20
                                [5] = u207
                            --]]
							workspace:GetServerTimeNow()
							local v209 = u38.startedAt + 55 - workspace:GetServerTimeNow()
							if math.max(v209, 0) > 0 then
								if not u206.IsPlaying then
									u206:Play()
								end
							elseif u204.MoveDirection ~= Vector3.new(0, 0, 0) or u20:GetAttribute("Stealing") then
								u207 = 0
								if u206.IsPlaying then
									u206:Stop()
								end
							else
								if u207 < 3 then
									u207 = u207 + p208
									return
								end
								if not u206.IsPlaying then
									u206:Play()
									return
								end
							end
						end))
						u203:Add(function() --[[Anonymous function at line 231]]
                            --[[
                            Upvalues:
                                [1] = u206
                                [2] = u59
                            --]]
							u206:Stop()
							u206:Destroy()
							u59 = nil
						end)
					end
				else
					return
				end
			end))
			return u203:WrapClean()
		end))
	end))
	u13:Update()
	u11:UpdateOST()
end
function v6.OnStop(_) --[[Anonymous function at line 669]]
    --[[
    Upvalues:
        [1] = u29
    --]]
	u29:Destroy()
end
function v6.OnLoad(_) --[[Anonymous function at line 673]]
    --[[
    Upvalues:
        [1] = u2
    --]]
	task.spawn(pcall, function() --[[Anonymous function at line 674]]
        --[[
        Upvalues:
            [1] = u2
        --]]
		u2:PreloadAsync(script:GetChildren())
	end)
end
return v6
