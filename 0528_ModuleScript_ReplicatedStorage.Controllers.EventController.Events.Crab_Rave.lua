--[[
  Extracted from: ReplicatedStorage.Controllers.EventController.Events.Crab Rave
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Thanks For Angelus Decompiles --> https://discord.gg/CYXme7yEG9

-- Decompiled with Velocity Script Decompiler
local v_u_1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("ContentProvider")
local v_u_3 = game:GetService("TweenService")
local v_u_4 = game:GetService("RunService")
game:GetService("Lighting")
local v_u_5 = game:GetService("Players")
require(v_u_1.Shared.EventTypes)
local v6 = {}
local v_u_7 = require(v_u_1.Controllers.CameraController)
local v_u_8 = require(v_u_1.Controllers.AnimalController)
local v_u_9 = require(v_u_1.Controllers.EffectController)
local v_u_10 = require(v_u_1.Controllers.SoundController)
local v_u_11 = require(v_u_1.Controllers.CycleController)
local v_u_12 = require(v_u_1.Controllers.EventController)
require(v_u_1.Packages.Synchronizer)
local v_u_13 = require(v_u_1.Packages.Observers)
require(v_u_1.Shared.TweenPivot)
local v_u_14 = require(v_u_1.Packages.Signal)
require(v_u_1.Packages.FFlags)
local v_u_15 = require(v_u_1.Packages.Trove)
local v16 = require(v_u_1.Packages.Net)
local v_u_17 = require(v_u_1.Shared.VFX)
local v_u_18 = v16:RemoteEvent("EventService/Crab Rave/Hit")
local v_u_19 = v_u_5.LocalPlayer
local v_u_20 = workspace.Sounds.CrabRave
local v_u_21 = script.Name
local v_u_22 = v_u_15.new()
function v6.OnStart(_)
	-- upvalues: (copy) v_u_12, (copy) v_u_21, (copy) v_u_22, (copy) v_u_1, (copy) v_u_11, (copy) v_u_10, (copy) v_u_20, (copy) v_u_3, (copy) v_u_17, (copy) v_u_9, (copy) v_u_13, (copy) v_u_15, (copy) v_u_4, (copy) v_u_7, (copy) v_u_14, (copy) v_u_5, (copy) v_u_19
	local v_u_23 = v_u_12:GetActiveEventData(v_u_21)
	assert(v_u_23)
	local v_u_24 = true
	v_u_22:Add(function()
		-- upvalues: (ref) v_u_24
		v_u_24 = false
	end)
	v_u_1:SetAttribute("CrabRave", true)
	v_u_22:Add(function()
		-- upvalues: (ref) v_u_1, (ref) v_u_11, (ref) v_u_10
		v_u_1:SetAttribute("CrabRave", nil)
		v_u_11:Update()
		v_u_10:UpdateOST()
	end)
	v_u_22:Add(task.spawn(function()
		-- upvalues: (ref) v_u_20, (copy) v_u_23
		while not v_u_20.IsLoaded do
			task.wait()
		end
		local v25 = v_u_20
		local v26 = v_u_20.TimePosition
		local v27 = workspace:GetServerTimeNow() - v_u_23.startedAt
		v25.TimePosition = math.max(v26, v27)
	end))
	v_u_11:Update()
	v_u_10:UpdateOST()
	local v_u_28 = v_u_22:Add(Instance.new("ColorCorrectionEffect"))
	v_u_28.Parent = workspace.CurrentCamera
	local v_u_29 = v_u_22:Clone(script.Ocean)
	v_u_29.Parent = workspace
	local v_u_30 = v_u_22:Add(Instance.new("Highlight"))
	assert(v_u_30)
	v_u_30.DepthMode = Enum.HighlightDepthMode.Occluded
	v_u_30.FillColor = Color3.new(1, 1, 1)
	v_u_30.FillTransparency = 1
	v_u_30.OutlineTransparency = 1
	for _, v31 in v_u_29:GetChildren() do
		if v31:IsA("Beam") then
			local v32 = v31.TextureLength
			v31.TextureLength = 0
			v_u_3:Create(v_u_29.ocean, TweenInfo.new(v_u_23.startedAt + 45 - workspace:GetServerTimeNow(), Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
				["TextureLength"] = v32
			}):Play()
		end
	end
	v_u_3:Create(v_u_29.att1, TweenInfo.new(v_u_23.startedAt + 45 - workspace:GetServerTimeNow(), Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
		["Position"] = Vector3.new(0, 0, 400)
	}):Play()
	v_u_3:Create(v_u_28, TweenInfo.new(v_u_23.startedAt + 1.95 - workspace:GetServerTimeNow()), {
		["Brightness"] = -1.2
	}):Play()
	v_u_22:Add(task.delay(v_u_23.startedAt + 45 - workspace:GetServerTimeNow(), function()
		-- upvalues: (ref) v_u_17, (copy) v_u_29
		v_u_17.enable(v_u_29.oceanparticles)
	end))
	v_u_9:Run("CrabRaveEvent", "GrassRecolor")
	v_u_22:Add(function()
		-- upvalues: (ref) v_u_9
		v_u_9:Stop("CrabRaveEvent", "GrassRecolor")
	end)
	v_u_22:Add(function()
		-- upvalues: (ref) v_u_9
		v_u_9:Activate("Blink")
	end)
	v_u_22:Add(v_u_13.observeTag("CrabRaveCrabFolder", function(p33)
		-- upvalues: (ref) v_u_30
		v_u_30.Parent = p33
		return nil
	end))
	v_u_22:Add(v_u_13.observeTag("CrabRaveCrabs", function(p_u_34)
		-- upvalues: (ref) v_u_15, (copy) v_u_23, (ref) v_u_4
		local v_u_35 = v_u_15.new()
		local v_u_36 = p_u_34.Parent.Name
		local v_u_37 = v_u_35:Clone(script.Crab)
		local v_u_38 = nil
		local v_u_39 = nil
		v_u_37["Cylinder.005"].Transparency = 1
		v_u_35:Add(task.delay(v_u_23.startedAt + 2 - workspace:GetServerTimeNow(), function()
			-- upvalues: (copy) v_u_37
			v_u_37["Cylinder.005"].Transparency = 0
		end))
		local v_u_40 = v_u_35:Add(Instance.new("Weld"))
		v_u_40.Part0 = v_u_37["Cylinder.005"]
		v_u_40.Part1 = p_u_34.HumanoidRootPart
		v_u_40.C1 = CFrame.new(0, 3.6, 0)
		v_u_40.Parent = v_u_37
		local v_u_41 = 0
		local v_u_42 = 0
		local v_u_43 = CFrame.new(0, 3.6, 0)
		v_u_35:Add(v_u_4.PostSimulation:Connect(function(p44)
			-- upvalues: (ref) v_u_42, (ref) v_u_41, (copy) v_u_40, (copy) v_u_43
			local v45 = v_u_42 - v_u_41
			if math.abs(v45) >= 0.1 then
				local v46 = v_u_42
				local v47 = v_u_41 - v_u_42
				local v48 = p44 * -1
				v_u_41 = v46 + v47 * math.exp(v48)
				v_u_40.C1 = v_u_43 * CFrame.Angles(0, v_u_41, 0)
			end
		end))
		v_u_37.Parent = p_u_34
		local v49 = script.Animation1
		local v_u_50 = v_u_37.AnimationController:LoadAnimation(v49)
		v_u_35:Add(function()
			-- upvalues: (copy) v_u_50
			v_u_50:Stop(0)
			v_u_50:Destroy()
		end)
		local v51 = script.Animation2
		local v_u_52 = v_u_37.AnimationController:LoadAnimation(v51)
		v_u_35:Add(function()
			-- upvalues: (copy) v_u_52
			v_u_52:Stop(0)
			v_u_52:Destroy()
		end)
		local v53 = script.Animation3_Right
		local v_u_54 = v_u_37.AnimationController:LoadAnimation(v53)
		v_u_35:Add(function()
			-- upvalues: (copy) v_u_54
			v_u_54:Stop(0)
			v_u_54:Destroy()
		end)
		local v55 = script.Animation3_Left
		local v_u_56 = v_u_37.AnimationController:LoadAnimation(v55)
		v_u_35:Add(function()
			-- upvalues: (copy) v_u_56
			v_u_56:Stop(0)
			v_u_56:Destroy()
		end)
		v_u_56.Priority = Enum.AnimationPriority.Action
		local v57 = script.Animation4_Walk
		local v_u_58 = v_u_37.AnimationController:LoadAnimation(v57)
		v_u_35:Add(function()
			-- upvalues: (copy) v_u_58
			v_u_58:Stop(0)
			v_u_58:Destroy()
		end)
		local v_u_59 = v_u_58
		v_u_59.Priority = Enum.AnimationPriority.Action
		local v60 = script.Animation4_Attack
		local v_u_61 = v_u_37.AnimationController:LoadAnimation(v60)
		v_u_35:Add(function()
			-- upvalues: (copy) v_u_61
			v_u_61:Stop(0)
			v_u_61:Destroy()
		end)
		v_u_61.Priority = Enum.AnimationPriority.Action4
		local v_u_62 = v_u_59
		v_u_50:Play()
		local v63 = p_u_34:FindFirstChildOfClass("Humanoid")
		if v63 then
			v_u_35:Add(v63.Running:Connect(function(p64)
				-- upvalues: (ref) v_u_62, (ref) v_u_38, (ref) v_u_39
				if p64 > 1 then
					if not v_u_62.IsPlaying then
						v_u_62:Play()
					end
					if v_u_38 then
						v_u_38.ParticleEmitter.Enabled = true
					end
					if v_u_39 then
						v_u_39.ParticleEmitter.Enabled = true
						return
					end
				else
					if v_u_62.IsPlaying then
						v_u_62:Stop()
					end
					if v_u_38 then
						v_u_38.ParticleEmitter.Enabled = false
					end
					if v_u_39 then
						v_u_39.ParticleEmitter.Enabled = false
					end
				end
			end))
		end
		v_u_35:Add(p_u_34:GetAttributeChangedSignal("Attack"):Connect(function()
			-- upvalues: (copy) v_u_61
			v_u_61:Play()
		end))
		local v65 = script.Animation5
		local v_u_66 = v_u_37.AnimationController:LoadAnimation(v65)
		v_u_35:Add(function()
			-- upvalues: (copy) v_u_66
			v_u_66:Stop(0)
			v_u_66:Destroy()
		end)
		v_u_66.Priority = Enum.AnimationPriority.Action2
		local v67 = script.Animation6
		local v_u_68 = v_u_37.AnimationController:LoadAnimation(v67)
		v_u_35:Add(function()
			-- upvalues: (copy) v_u_68
			v_u_68:Stop(0)
			v_u_68:Destroy()
		end)
		v_u_68.Priority = Enum.AnimationPriority.Action2
		local v69 = script.Animation7
		local v_u_70 = v_u_37.AnimationController:LoadAnimation(v69)
		v_u_35:Add(function()
			-- upvalues: (copy) v_u_70
			v_u_70:Stop(0)
			v_u_70:Destroy()
		end)
		v_u_70.Priority = Enum.AnimationPriority.Action2
		local v71 = script.Animation8
		local v_u_72 = v_u_37.AnimationController:LoadAnimation(v71)
		v_u_35:Add(function()
			-- upvalues: (copy) v_u_72
			v_u_72:Stop(0)
			v_u_72:Destroy()
		end)
		local v_u_73 = v_u_72
		v_u_73.Priority = Enum.AnimationPriority.Action2
		local v_u_74 = {
			v_u_66,
			v_u_68,
			v_u_70,
			v_u_73
		}
		local v_u_75 = nil
		v_u_35:Add(p_u_34:GetAttributeChangedSignal("Dance"):Connect(function()
			-- upvalues: (ref) v_u_23, (copy) p_u_34, (copy) v_u_74, (ref) v_u_75
			local v76 = v_u_23.startedAt + 85 - workspace:GetServerTimeNow()
			local v77 = v_u_23.startedAt + 105 - workspace:GetServerTimeNow()
			local v78 = v76 <= 0 and v77 > 0 and 4 or p_u_34:GetAttribute("Dance")
			if not v78 or (not v_u_74[v78] or v_u_75 ~= v_u_74[v78]) then
				if v_u_75 then
					v_u_75:Stop()
					v_u_75 = nil
				end
				if v78 ~= nil then
					v_u_75 = v_u_74[v78]
					local v79 = v_u_75
					assert(v79)
					v_u_75:Play()
				end
			end
		end))
		local v_u_80 = nil
		v_u_35:Add(task.delay(v_u_23.startedAt + 7 - workspace:GetServerTimeNow(), function()
			-- upvalues: (copy) v_u_50, (copy) v_u_52
			v_u_50:Stop()
			v_u_52:Play()
		end))
		if v_u_36 == "Ground" then
			v_u_35:Add(p_u_34:GetAttributeChangedSignal("ReachedFirstTarget"):Once(function()
				-- upvalues: (ref) v_u_80, (copy) v_u_35, (copy) v_u_37
				v_u_80 = v_u_35:Clone(script.SanddrumRoll)
				local v81 = v_u_35:Add(Instance.new("Weld"))
				v81.Part0 = v_u_80
				v81.Part1 = v_u_37["Cylinder.005"]
				v81.C0 = CFrame.new(0.2, 3.629, 4.378)
				v81.Parent = v_u_80
				v_u_80.Parent = v_u_37
			end))
		end
		v_u_35:Add(task.delay(v_u_23.startedAt + 27.5 - workspace:GetServerTimeNow(), function()
			-- upvalues: (copy) v_u_36, (copy) p_u_34, (ref) v_u_80, (copy) v_u_35, (copy) v_u_56, (ref) v_u_62, (ref) v_u_42
			if v_u_36 == "Ground" then
				p_u_34:GetPivot()
				if v_u_80 then
					local v_u_82 = v_u_80
					v_u_82.ParticleEmitter.Enabled = false
					task.delay(3, function()
						-- upvalues: (ref) v_u_35, (copy) v_u_82
						v_u_35:Remove(v_u_82)
					end)
					v_u_80 = nil
				end
				local v83 = v_u_56
				if v_u_62 ~= v83 then
					if v_u_62.IsPlaying then
						v_u_62:Stop()
					end
					v_u_62 = v83
				end
				v_u_56:Play(nil, nil, 0.3333333333333333)
				v_u_42 = 1.5707963267948966
			end
		end))
		v_u_35:Add(task.delay(v_u_23.startedAt + 31 - workspace:GetServerTimeNow(), function()
			-- upvalues: (copy) v_u_36, (copy) v_u_56, (ref) v_u_38, (copy) v_u_35, (copy) v_u_37, (ref) v_u_39, (copy) v_u_52, (copy) v_u_50
			if v_u_36 == "Ground" then
				v_u_56:AdjustSpeed(1)
				v_u_38 = v_u_35:Clone(script.WalkPart)
				local v84 = v_u_38
				assert(v84)
				local v85 = v_u_35:Add(Instance.new("Weld"))
				v85.Part0 = v_u_38
				v85.Part1 = v_u_37["Cylinder.005"]
				v85.C0 = CFrame.new(0.614, 3.129, 4.731) * CFrame.fromOrientation(0, -1.5707963267948966, 0)
				v85.Parent = v_u_38
				v_u_38.Parent = v_u_37
				v_u_39 = v_u_35:Clone(script.WalkPart)
				local v86 = v_u_39
				assert(v86)
				local v87 = v_u_35:Add(Instance.new("Weld"))
				v87.Part0 = v_u_39
				v87.Part1 = v_u_37["Cylinder.005"]
				v87.C0 = CFrame.new(0.414, 3.129, -4.78) * CFrame.fromOrientation(0, -1.5707963267948966, 0)
				v87.Parent = v_u_39
				v_u_39.Parent = v_u_37
			elseif v_u_36 == "Wall" then
				v_u_52:Stop()
				v_u_50:Play()
			end
		end))
		v_u_35:Add(task.delay(v_u_23.startedAt + 43 - workspace:GetServerTimeNow(), function()
			-- upvalues: (copy) v_u_54, (ref) v_u_42
			v_u_54:Play(nil, nil, 0.3333333333333333)
			v_u_42 = 0
		end))
		v_u_35:Add(task.delay(v_u_23.startedAt + 46 - workspace:GetServerTimeNow(), function()
			-- upvalues: (copy) v_u_54, (copy) v_u_59, (ref) v_u_62, (copy) v_u_36, (copy) v_u_52, (copy) v_u_50
			v_u_54:Stop()
			local v88 = v_u_59
			if v_u_62 ~= v88 then
				local v89 = v_u_62.IsPlaying
				if v89 then
					v_u_62:Stop()
				end
				v_u_62 = v88
				if v89 then
					v_u_62:Play()
				end
			end
			if v_u_36 == "Wall" then
				v_u_52:Stop()
				v_u_50:Play()
			end
		end))
		v_u_35:Add(task.delay(v_u_23.startedAt + 141 - workspace:GetServerTimeNow(), function()
			-- upvalues: (ref) v_u_23, (copy) v_u_35, (ref) v_u_4, (copy) v_u_66, (copy) v_u_68, (copy) v_u_70, (copy) v_u_73
			local v_u_90 = v_u_23.startedAt + 161 - workspace:GetServerTimeNow()
			local v_u_91 = 0
			v_u_35:Add(v_u_4.PreSimulation:Connect(function(p92)
				-- upvalues: (ref) v_u_91, (copy) v_u_90, (ref) v_u_66, (ref) v_u_68, (ref) v_u_70, (ref) v_u_73
				v_u_91 = v_u_91 + p92
				local v93 = v_u_91 / v_u_90
				v_u_66:AdjustSpeed((math.lerp(1, 0.1, v93)))
				v_u_68:AdjustSpeed((math.lerp(1, 0.1, v93)))
				v_u_70:AdjustSpeed((math.lerp(1, 0.1, v93)))
				v_u_73:AdjustSpeed((math.lerp(1, 0.1, v93)))
			end))
		end))
		return function()
			-- upvalues: (copy) v_u_35
			v_u_35:Destroy()
		end
	end))
	local _ = workspace.CurrentCamera
	local v_u_94 = 0
	local v_u_95 = 0
	v_u_22:Add(v_u_4.PostSimulation:Connect(function(p96)
		-- upvalues: (ref) v_u_95, (ref) v_u_94, (ref) v_u_20, (ref) v_u_30, (ref) v_u_3, (ref) v_u_7
		v_u_95 = v_u_95 - p96
		v_u_94 = v_u_94 - p96
		local v97 = (v_u_20.PlaybackLoudness - 100) / 900
		local v98 = math.clamp(v97, 0, 1)
		if v_u_94 <= 0 and v_u_30 then
			v_u_94 = 0.5
			v_u_30.FillTransparency = 0
			v_u_3:Create(v_u_30, TweenInfo.new(0.3), {
				["FillTransparency"] = 1
			}):Play()
		end
		if v98 >= 0.25 and v_u_95 <= 0 then
			v_u_95 = 0.1
			v_u_7:Fov((v98 - 0.25) * 20 + 70, 0.1)
		end
	end))
	v_u_22:Add(task.delay(v_u_23.startedAt + 7 - workspace:GetServerTimeNow(), function()
		-- upvalues: (ref) v_u_30, (ref) v_u_3, (copy) v_u_28
		if v_u_30 then
			v_u_30:Destroy()
			v_u_30 = nil
		end
		local v_u_99 = v_u_3:Create(v_u_28, TweenInfo.new(1), {
			["Brightness"] = 0
		})
		v_u_99:Play()
		v_u_99.Completed:Once(function()
			-- upvalues: (copy) v_u_99
			v_u_99:Cancel()
			v_u_99:Destroy()
		end)
	end))
	v_u_22:Add(task.delay(v_u_23.startedAt + 46 - workspace:GetServerTimeNow(), function()
		-- upvalues: (ref) v_u_22, (ref) v_u_14, (ref) v_u_13, (ref) v_u_5, (ref) v_u_15, (ref) v_u_4, (copy) v_u_23, (ref) v_u_19
		v_u_22:Add(v_u_14.new())
		local v110 = v_u_22:Add(v_u_13.observeCharacter(v_u_5.LocalPlayer, function(_, p_u_100)
			-- upvalues: (ref) v_u_15, (ref) v_u_4, (ref) v_u_23, (ref) v_u_19
			local v_u_101 = v_u_15.new()
			v_u_101:Add(task.spawn(function()
				-- upvalues: (copy) p_u_100, (copy) v_u_101, (ref) v_u_4, (ref) v_u_23, (ref) v_u_19
				local v_u_102 = p_u_100:WaitForChild("Humanoid")
				if v_u_102 then
					local v103 = v_u_102:WaitForChild("Animator")
					if v103 then
						local v_u_104 = v103:LoadAnimation(script.Dance)
						v_u_104.Priority = Enum.AnimationPriority.Action
						v_u_104:Play(2)
						local v_u_105 = 0
						local v_u_106 = 0
						v_u_101:Add(v_u_4.PostSimulation:Connect(function(p107)
							-- upvalues: (ref) v_u_23, (copy) v_u_104, (ref) v_u_106, (copy) v_u_102, (ref) v_u_19, (ref) v_u_105
							local v108 = workspace:GetServerTimeNow()
							if v_u_23.startedAt + 66 - (v108 or workspace:GetServerTimeNow()) > 0 then
								if not v_u_104.IsPlaying then
									v_u_104:Play()
									v_u_104.TimePosition = (v108 - v_u_23.startedAt) % v_u_104.Length
								end
							else
								local v109 = v_u_104.Length
								if v_u_106 ~= v109 and v109 > 0 then
									v_u_106 = v109
									v_u_104.TimePosition = (v108 - v_u_23.startedAt) % v109
								end
								if v_u_102.MoveDirection ~= Vector3.new(0, 0, 0) or v_u_19:GetAttribute("Stealing") then
									v_u_105 = 0
									if v_u_104.IsPlaying then
										v_u_104:Stop()
									end
								else
									if v_u_105 < 3 then
										v_u_105 = v_u_105 + p107
										return
									end
									if not v_u_104.IsPlaying then
										v_u_104:Play()
										v_u_104.TimePosition = (v108 - v_u_23.startedAt) % v_u_104.Length
										return
									end
								end
							end
						end))
						v_u_101:Add(function()
							-- upvalues: (copy) v_u_104
							v_u_104:Stop()
							v_u_104:Destroy()
						end)
					end
				else
					return
				end
			end))
			return v_u_101:WrapClean()
		end))
		v_u_22:Add(task.delay(v_u_23.startedAt + 140 - workspace:GetServerTimeNow(), v110))
	end))
end
function v6.OnStop(_)
	-- upvalues: (copy) v_u_22
	v_u_22:Destroy()
end
function v6.OnLoad(_)
	-- upvalues: (copy) v_u_2, (copy) v_u_18, (copy) v_u_8, (copy) v_u_17
	task.spawn(pcall, function()
		-- upvalues: (ref) v_u_2
		v_u_2:PreloadAsync(script:GetChildren())
	end)
	v_u_18.OnClientEvent:Connect(function(p111)
		-- upvalues: (ref) v_u_8, (ref) v_u_17
		local v112
		if type(p111) == "string" then
			local v113 = v_u_8:GetAnimals()[p111]
			if not v113 then
				return
			end
			local v114 = v113.AnimalModel
			local v115
			if v114.PrimaryPart then
				v115 = v114.PrimaryPart.CFrame
			else
				v115 = v114:GetPivot()
			end
			local v116 = v115.Position
			local v117 = v113.AnimalModel:GetExtentsSize().Y * 0.5
			v112 = v116 + Vector3.new(0, v117, 0)
			p111 = v113.AnimalModel.PrimaryPart
		else
			v112 = p111:GetPivot().Position
		end
		local v118 = script.CrabHit:Clone()
		v118:PivotTo(CFrame.new(v112))
		v118.Anchored = false
		local v119 = Instance.new("WeldConstraint")
		v119.Part0 = v118
		v119.Part1 = p111
		v119.Parent = v118
		v118.Parent = workspace
		v_u_17.emit(v118)
	end)
end
return v6