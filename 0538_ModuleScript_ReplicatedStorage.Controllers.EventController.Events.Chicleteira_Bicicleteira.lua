--[[
  Extracted from: ReplicatedStorage.Controllers.EventController.Events.Chicleteira Bicicleteira
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

game:GetService("ServerScriptService")
local v_u_1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("ContentProvider")
local v_u_3 = game:GetService("RunService")
game:GetService("Players")
require(v_u_1.Shared.EventTypes)
local v4 = {}
local v_u_5 = require(v_u_1.Controllers.EffectController)
local v_u_6 = require(v_u_1.Controllers.AnimalController)
local v_u_7 = require(v_u_1.Controllers.SoundController)
local v_u_8 = require(v_u_1.Controllers.CycleController)
local v_u_9 = require(v_u_1.Controllers.EventController)
require(v_u_1.Controllers.EventController.ClientEventUtils)
require(v_u_1.Packages.CreateTween)
local v_u_10 = require(v_u_1.Packages.Observers)
require(v_u_1.Shared.TweenPivot)
require(v_u_1.Utils.MathUtils)
local v_u_11 = require(v_u_1.Packages.Timer)
local v_u_12 = require(v_u_1.Packages.Trove)
local v13 = require(v_u_1.Packages.Net)
local v_u_14 = require(v_u_1.Packages.Spr)
local v_u_15 = require(v_u_1.Shared.VFX)
require(v_u_1.Shared.Snapshot)
local v_u_16 = script.Name
local v_u_17 = v13:RemoteEvent("EventService/Chicleteira Bicicleteira/SpawnChicleteira")
local v_u_18 = v13:RemoteEvent("EventService/Chicleteira Bicicleteira/Burst")
local v_u_19 = v_u_12.new()
local function v_u_41()
	-- upvalues: (copy) v_u_19, (copy) v_u_3, (copy) v_u_10
	local v20 = v_u_19:Extend()
	local v_u_21 = table.create(2)
	v20:Add(function()
		-- upvalues: (copy) v_u_21
		table.clear(v_u_21)
	end)
	local v_u_22 = 0
	v20:Add(v_u_3.PreRender:Connect(function(p23)
		-- upvalues: (ref) v_u_22, (copy) v_u_21
		debug.profilebegin("Chicleteira Event")
		v_u_22 = v_u_22 + p23
		for v24, v25 in v_u_21 do
			if v25.target and v25.targetAttachment then
				v25.beam.First.Enabled = true
				v25.beam.Second.Enabled = true
				local v26 = v_u_22 - v24 + 1
				local v27 = math.clamp(v26, 0, 1)
				local v28 = v25.beam.WorldPosition
				v25.targetAttachment.Position = v28 + (v25.target:GetPivot().Position - v28) * v27
			end
		end
		debug.profileend()
	end))
	v20:Add(v_u_10.observeTag("ChicleteiraPlayerVFX", function(p_u_29)
		-- upvalues: (copy) v_u_21, (ref) v_u_10
		local v_u_30 = script.PlayerVFX.Beam:Clone()
		v_u_30.Parent = p_u_29
		local v_u_31 = script.PlayerVFX[("Torso%*"):format(p_u_29:GetAttribute("ChicleteiraIndex") % 2 + 1)]:Clone()
		v_u_31.Parent = p_u_29
		local v32 = script.PlayerVFX[("vfxTorso%*"):format(p_u_29:GetAttribute("ChicleteiraIndex") % 2 + 1)]:Clone()
		local v_u_33 = {}
		for _, v34 in v32:GetChildren() do
			v34.Parent = p_u_29
			table.insert(v_u_33, v34)
		end
		v32:Destroy()
		local v_u_35 = p_u_29:GetAttribute("ChicleteiraIndex")
		v_u_21[v_u_35] = {
			["beam"] = v_u_30,
			["target"] = nil
		}
		local v_u_39 = v_u_10.observeTag("ChicleteiraPlayerVFX", function(p36)
			-- upvalues: (copy) p_u_29, (copy) v_u_30, (ref) v_u_21
			if p36 == p_u_29 then
				return nil
			end
			if p36:GetAttribute("ChicleteiraIndex") ~= p_u_29:GetAttribute("ChicleteiraIndex") % 2 + 1 then
				return nil
			end
			local v_u_37 = Instance.new("Attachment")
			v_u_37.Position = v_u_30.WorldPosition
			v_u_37.Parent = workspace.Terrain
			local v38 = v_u_21[p_u_29:GetAttribute("ChicleteiraIndex")]
			v38.target = p36
			v38.beam.First.Attachment0 = v_u_37
			v38.beam.Second.Attachment0 = v_u_37
			v38.targetAttachment = v_u_37
			return function()
				-- upvalues: (copy) v_u_37
				v_u_37:Destroy()
			end
		end)
		return function()
			-- upvalues: (copy) v_u_31, (copy) v_u_30, (copy) v_u_33, (copy) v_u_39, (ref) v_u_21, (copy) v_u_35
			v_u_31:Destroy()
			v_u_30:Destroy()
			for _, v40 in v_u_33 do
				v40:Destroy()
			end
			v_u_39()
			v_u_21[v_u_35] = nil
		end
	end))
end
function v4.OnStart(_)
	-- upvalues: (copy) v_u_9, (copy) v_u_16, (copy) v_u_1, (copy) v_u_19, (copy) v_u_5, (copy) v_u_8, (copy) v_u_7, (copy) v_u_10, (copy) v_u_12, (copy) v_u_15, (copy) v_u_11, (copy) v_u_6, (copy) v_u_14, (copy) v_u_41
	local v42 = v_u_9:GetActiveEventData(v_u_16)
	assert(v42)
	v_u_1:SetAttribute("ChicleteiraBicicleteiraEvent", true)
	v_u_19:Add(function()
		-- upvalues: (ref) v_u_1, (ref) v_u_5, (ref) v_u_8, (ref) v_u_7
		v_u_1:SetAttribute("ChicleteiraBicicleteiraEvent", nil)
		v_u_5:Activate("Blink")
		v_u_8:Update()
		v_u_7:UpdateOST()
		v_u_7:UpdateAmbience()
	end)
	v_u_19:Add(task.delay(v42.startedAt + 2 - workspace:GetServerTimeNow(), function()
		-- upvalues: (ref) v_u_19, (ref) v_u_5, (ref) v_u_8, (ref) v_u_7
		v_u_19:Clone(script.Map).Parent = workspace
		v_u_5:Run("ChicleteiraBicicleteiraEvent", "GrassRecolor")
		v_u_19:Add(function()
			-- upvalues: (ref) v_u_5
			v_u_5:Stop("ChicleteiraBicicleteiraEvent", "GrassRecolor")
		end)
		v_u_5:Run("ChicleteiraBicicleteiraEvent", "WallRecolor")
		v_u_19:Add(function()
			-- upvalues: (ref) v_u_5
			v_u_5:Stop("ChicleteiraBicicleteiraEvent", "WallRecolor")
		end)
		v_u_8:Update()
		v_u_7:UpdateOST()
		v_u_7:UpdateAmbience()
		v_u_5:Activate("Blink")
	end))
	v_u_19:Add(v_u_10.observeTag("Event_ChicleteiraBicicleteira", function(p_u_43)
		-- upvalues: (ref) v_u_12, (ref) v_u_7, (ref) v_u_1, (ref) v_u_15, (ref) v_u_11, (ref) v_u_6, (ref) v_u_14
		local v_u_44 = p_u_43:GetPivot() * CFrame.fromOrientation(0, 3.141592653589793, 0)
		local v45 = v_u_12.new()
		local v_u_46 = v45:Clone(script["Standing Chicleteira Bicicleteira"])
		local v47 = v_u_46:GetExtentsSize().Y
		v_u_46:PivotTo(v_u_44 - Vector3.new(0, v47, 0))
		v_u_46.Parent = p_u_43
		local v48 = v_u_46.AnimationController.Animator:LoadAnimation(script.Idle)
		v45:Add(v48, "Stop")
		v45:Add(v48)
		v48.Looped = true
		v48.Priority = Enum.AnimationPriority.Idle
		v48:Play()
		local v_u_49 = v_u_46.AnimationController.Animator:LoadAnimation(script.Painting)
		v45:Add(v_u_49, "Stop")
		v45:Add(v_u_49)
		v_u_49.Looped = false
		v_u_49.Priority = Enum.AnimationPriority.Action4
		v45:Add(v48:GetMarkerReachedSignal("Shake"):Connect(function(...)
			-- upvalues: (copy) v_u_49, (ref) v_u_7, (ref) v_u_1, (copy) v_u_44
			if not v_u_49.IsPlaying then
				task.spawn(function()
					-- upvalues: (ref) v_u_7, (ref) v_u_1, (ref) v_u_44
					v_u_7:PlaySound(v_u_1.Sounds.Events["Chicleteira Bicicleteira"].Shake, v_u_44.Position)
				end)
			end
		end))
		v45:Add(p_u_43:GetAttributeChangedSignal("ForceSpray"):Connect(function()
			-- upvalues: (copy) p_u_43, (ref) v_u_7, (ref) v_u_1, (copy) v_u_44, (copy) v_u_49, (ref) v_u_15, (copy) v_u_46
			if p_u_43:GetAttribute("ForceSpray") then
				task.spawn(function()
					-- upvalues: (ref) v_u_7, (ref) v_u_1, (ref) v_u_44
					v_u_7:PlaySound(v_u_1.Sounds.Events["Chicleteira Bicicleteira"].Spray, v_u_44.Position)
				end)
				v_u_49:Stop(0)
				v_u_49:Play()
				task.wait(0.3)
				v_u_15.enable(v_u_46.Handle.vfx)
				task.wait(1)
				v_u_15.disable(v_u_46.Handle.vfx)
			end
		end))
		v45:Add(task.spawn(function()
			-- upvalues: (ref) v_u_7, (ref) v_u_1, (copy) v_u_44
			v_u_7:PlaySound(v_u_1.Sounds.Events["Chicleteira Bicicleteira"].Ground, v_u_44.Position)
		end))
		v45:Add(v_u_11.Simple(0.1, function()
			-- upvalues: (copy) p_u_43, (ref) v_u_6, (copy) v_u_44, (ref) v_u_14, (copy) v_u_46
			local v50 = nil
			local v51 = p_u_43:GetAttribute("ForceSpray")
			if v51 then
				local v52 = v_u_6:GetAnimals()[v51]
				if v52 then
					v50 = v52.Instance
				end
			end
			if v50 then
				local v53 = v50:GetPivot().Position
				local v54 = v53.X
				local v55 = v_u_44.Y
				local v56 = v53.Z
				local v57 = Vector3.new(v54, v55, v56)
				v_u_14.target(v_u_46, 1, 2, {
					["Pivot"] = CFrame.lookAt(v_u_44.Position, v57) * CFrame.fromOrientation(0, 3.141592653589793, 0)
				})
			else
				local v58 = {
					["Pivot"] = v_u_44
				}
				v_u_14.target(v_u_46, 1, 2, v58)
			end
		end, true))
		return v45:WrapClean()
	end, { workspace }))
	v_u_19:Add(task.spawn(function()
		-- upvalues: (ref) v_u_41
		v_u_41()
	end))
end
function v4.OnStop(_)
	-- upvalues: (copy) v_u_19
	v_u_19:Destroy()
end
function v4.OnLoad(_)
	-- upvalues: (copy) v_u_2, (copy) v_u_18, (copy) v_u_6, (copy) v_u_7, (copy) v_u_1, (copy) v_u_15, (copy) v_u_17, (copy) v_u_19, (copy) v_u_3
	task.spawn(pcall, function()
		-- upvalues: (ref) v_u_2
		v_u_2:PreloadAsync(script:GetChildren())
	end)
	v_u_18.OnClientEvent:Connect(function(p59)
		-- upvalues: (ref) v_u_6, (ref) v_u_7, (ref) v_u_1, (ref) v_u_15
		local v60 = v_u_6:GetAnimals()[p59]
		if v60 then
			local v61 = v60.AnimalModel
			local v62
			if v61.PrimaryPart then
				v62 = v61.PrimaryPart.CFrame
			else
				v62 = v61:GetPivot()
			end
			local v_u_63 = v62.Position
			task.spawn(function()
				-- upvalues: (ref) v_u_7, (ref) v_u_1, (copy) v_u_63
				v_u_7:PlaySound(v_u_1.Sounds.Events["Chicleteira Bicicleteira"].Hit, v_u_63)
			end)
			local v_u_64 = script.Burst:Clone()
			v_u_64:PivotTo(CFrame.new(v_u_63))
			v_u_64.Anchored = false
			local v65 = Instance.new("WeldConstraint")
			v65.Part0 = v_u_64
			v65.Part1 = v60.AnimalModel.PrimaryPart
			v65.Parent = v_u_64
			v_u_64.Parent = workspace
			v_u_15.emit(v_u_64)
			task.delay(5, function()
				-- upvalues: (copy) v_u_64
				v_u_64:Destroy()
			end)
		end
	end)
	v_u_17.OnClientEvent:Connect(function(p_u_66, p_u_67, p68, p_u_69)
		-- upvalues: (ref) v_u_19, (ref) v_u_1, (ref) v_u_3
		local v_u_70 = script["Chicleteira Bicicleteira"]:Clone()
		v_u_70:PivotTo(p_u_69 or p_u_66)
		v_u_70.Parent = workspace
		local v71 = v_u_70.AnimationController.Animator:LoadAnimation(script.Walk)
		v71.Looped = true
		v71:Play()
		v71:AdjustSpeed(2)
		local v72 = v_u_19:Clone(v_u_1.Sounds.Events["Chicleteira Bicicleteira"].Bike)
		v72.Parent = v_u_70.PrimaryPart
		v72:Play()
		local v73 = p_u_67.Z - p_u_66.Z
		local v_u_74 = math.abs(v73) / p68
		local v_u_75 = 0
		local v_u_76 = nil
		v_u_76 = v_u_3.PostSimulation:Connect(function(p77)
			-- upvalues: (ref) v_u_75, (copy) v_u_74, (ref) v_u_76, (copy) v_u_70, (copy) p_u_69, (copy) p_u_66, (copy) p_u_67
			v_u_75 = v_u_75 + p77
			local v78 = v_u_75 / v_u_74
			local v79 = math.clamp(v78, 0, 1)
			if v79 >= 1 and v_u_76 then
				v_u_76:Disconnect()
				v_u_76 = nil
				v_u_70:Destroy()
			end
			if p_u_69 == nil then
				v_u_70:PivotTo(p_u_66:Lerp(p_u_67, v79), v79)
			else
				local v80 = p_u_66:Lerp(p_u_67, v79)
				local v81 = p_u_69:Lerp(p_u_67, v79)
				local v82 = v79 / 0.05
				local v83 = math.clamp(v82, 0, 1)
				local v84 = 5 + (v81.Y - v80.Y)
				local v85 = v81.Y
				local v86 = v80.Y
				local v87 = math.lerp(v85, v86, v83)
				local v88 = 3.141592653589793 * v83
				local v89 = v87 + math.sin(v88) * v84
				v_u_70:PivotTo(CFrame.new(v80.X, v89, v81.Z) * v80.Rotation)
			end
		end)
	end)
end
return v4