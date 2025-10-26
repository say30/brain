--[[
  Extracted from: ReplicatedStorage.Controllers.EventController.Events.Solar Flare
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled with Medal in Seliware

local v_u_1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("TweenService")
local v_u_3 = game:GetService("RunService")
game:GetService("Lighting")
game:GetService("Players")
local v_u_4 = game:GetService("Debris")
require(v_u_1.Shared.EventTypes)
local v5 = {}
local v_u_6 = require(v_u_1.Controllers.EventController)
local v_u_7 = require(v_u_1.Packages.Observers)
local v8 = require(v_u_1.Packages.Trove)
require(v_u_1.Packages.Net)
local v_u_9 = require(v_u_1.Packages.Shake)
require(v_u_1.Shared.ShakePresets)
local v_u_10 = script.Name
local v_u_11 = v8.new()
local v_u_12 = v_u_1.Models.Events["Solar Flare"].SolarFlareBeam
local v_u_13 = v_u_12:Clone()
local v_u_14 = workspace.Events["Solar Flare"]
local v_u_15 = v_u_14.MapFloor.Position.Y - v_u_14.MapFloor.Size.Y / 2
local v_u_16 = TweenInfo.new(0.25, Enum.EasingStyle.Back)
local v_u_17 = Color3.fromRGB(49, 49, 49)
local v_u_18 = TweenInfo.new(0.8, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
local v_u_19 = workspace.CurrentCamera
local v_u_20 = nil
local v_u_21 = v_u_9.new()
v_u_21.Frequency = 0.25
v_u_21.Amplitude = 0.2
v_u_21.FadeInTime = 0.1
v_u_21.FadeOutTime = 0.2
v_u_21.PositionInfluence = Vector3.new(0.15, 0.15, 0.15)
v_u_21.RotationInfluence = Vector3.new(1, 1, 1)
local v_u_22 = v_u_9.new()
v_u_22.Frequency = 0.06666666666666667
v_u_22.Amplitude = 0.04
v_u_22.Sustain = true
v_u_22.PositionInfluence = Vector3.new(0.75, 0.75, 0.75)
v_u_22.RotationInfluence = Vector3.new(1.25, 0.25, 0.25)
function v5.OnStart(_)
	-- upvalues: (copy) v_u_6, (copy) v_u_10, (copy) v_u_11
	local v23 = v_u_6:GetActiveEventData(v_u_10)
	local v_u_24 = true
	v_u_11:Add(function()
		-- upvalues: (ref) v_u_24
		v_u_24 = false
	end)
end
function v5.OnStop(_)
	-- upvalues: (copy) v_u_11
	v_u_11:Destroy()
end
function v5.OnLoad(_)
	-- upvalues: (copy) v_u_12, (copy) v_u_17, (copy) v_u_11, (copy) v_u_3, (ref) v_u_20, (copy) v_u_19, (copy) v_u_7, (copy) v_u_14, (copy) v_u_1, (copy) v_u_13, (copy) v_u_2, (copy) v_u_16, (copy) v_u_21, (copy) v_u_9, (copy) v_u_15, (copy) v_u_4, (copy) v_u_18, (copy) v_u_22
	for _, v25 in v_u_12:GetChildren() do
		if v25.Name ~= "BeamEnd" and v25.Name ~= "Hitbox" then
			v25:Destroy()
		end
	end
	for _, v26 in v_u_12.BeamEnd:GetChildren() do
		if v26.Name ~= "MainAttachment" then
			v26:Destroy()
		end
	end
	local v_u_27 = Instance.new("Part")
	v_u_27.Name = "SolarFlareTrail"
	v_u_27.Anchored = true
	v_u_27.CanCollide = false
	v_u_27.CanQuery = false
	v_u_27.CanTouch = false
	v_u_27.Size = Vector3.new(5, 5, 5)
	v_u_27.Color = v_u_17
	v_u_27.Transparency = 0.4
	v_u_27.Material = Enum.Material.Concrete
	v_u_11:Add(v_u_3.Heartbeat:Connect(function()
		-- upvalues: (ref) v_u_20, (ref) v_u_19
		if v_u_20 then
			v_u_19.CFrame = v_u_20
			v_u_20 = nil
		end
	end))
	local v_u_28 = v_u_11:Extend()
	local v_u_29 = nil
	local v_u_30 = 0
	local v_u_31 = 0
	local v_u_32 = nil
	local v33 = { v_u_14 }
	v_u_7.observeTag("SolarFlareBase", function(p_u_34)
		warn(p_u_34)
		-- upvalues: (copy) v_u_28, (ref) v_u_29, (ref) v_u_30, (ref) v_u_31, (ref) v_u_32
		v_u_28:Clean()
		v_u_29 = p_u_34
		v_u_30 = p_u_34:GetAttribute("NumBeams") or 1
		v_u_31 = p_u_34:GetAttribute("MaxBeams") or 4
		v_u_32 = (p_u_34:GetAttribute("SpawnPosition") or p_u_34.Position).Y
		local function v35()
			-- upvalues: (ref) v_u_30, (copy) p_u_34
			v_u_30 = p_u_34:GetAttribute("NumBeams") or v_u_30
		end
		v_u_28:Add(p_u_34:GetAttributeChangedSignal("NumBeams"):Connect(v35))
		v_u_30 = p_u_34:GetAttribute("NumBeams") or v_u_30
		return function()
			-- upvalues: (ref) v_u_29, (ref) v_u_28
			v_u_29 = nil
			warn("ASD")
			v_u_28:Destroy()
		end
	end, v33)
	local v36 = { v_u_14 }
	v_u_7.observeTag("SolarFlareHitbox", function(p_u_37)
		-- upvalues: (ref) v_u_29, (ref) v_u_1, (copy) v_u_28, (ref) v_u_30, (ref) v_u_13, (ref) v_u_11, (ref) v_u_14, (ref) v_u_2, (ref) v_u_16, (ref) v_u_21, (ref) v_u_9, (ref) v_u_20, (ref) v_u_19, (copy) v_u_27, (ref) v_u_15, (ref) v_u_4, (ref) v_u_18, (ref) v_u_22, (ref) v_u_3
		while not v_u_29 and v_u_1:GetAttribute("SolarFlareEvent") do
			task.wait()
		end
		pcall(function()
			-- upvalues: (copy) p_u_37
			p_u_37:SetNetworkOwner(nil)
		end)
		warn(p_u_37)
		local v_u_38 = v_u_28:Extend()
		v_u_38:AttachToInstance(p_u_37)
		local v39 = v_u_30
		local v_u_40 = v_u_38:Add(v_u_13.Beam1:Clone())
		v_u_40:PivotTo(p_u_37:GetPivot())
		v_u_40.Anchored = true
		v_u_40.Name = ("Beam%*"):format(v39)
		v_u_40.BeamEffect:Play()
		local _ = (v39 - 1) * 6.283185307179586 / 4
		local v41 = v_u_40.BeamStartAttachment
		local v42 = v_u_11:Add(v_u_13.BeamEnd.Beam1Attachment:Clone())
		v42.Name = ("Beam%*Attachment"):format(v39)
		local v43 = {}
		for _, v44 in v42:GetChildren() do
			if v44:IsA("Beam") then
				v44.Attachment0 = v41
				if v_u_30 ~= 0 then
					v43[v44] = {
						["Width0"] = v44.Width0,
						["Width1"] = v44.Width1
					}
					v44.Width0 = 0
					v44.Width1 = 0
				end
			end
		end
		v42.Parent = v_u_29
		v_u_40.Parent = v_u_14
		for v45, v46 in v43 do
			local v_u_47 = v_u_38:Add(v_u_2:Create(v45, v_u_16, v46))
			v_u_47.Completed:Once(function()
				-- upvalues: (copy) v_u_47
				v_u_47:Destroy()
			end)
			v_u_47:Play()
		end
		local v48 = v_u_38:Add(v_u_21:Clone())
		v48:Start()
		v48:BindToRenderStep(v_u_9.NextRenderName(), Enum.RenderPriority.Camera.Value + 1, function(p49, p50)
			-- upvalues: (ref) v_u_20, (ref) v_u_19
			if not v_u_20 then
				v_u_20 = v_u_19.CFrame
			end
			local v51 = v_u_19
			v51.CFrame = v51.CFrame * (CFrame.new(p49) * CFrame.Angles(p50.X, p50.Y, p50.Z))
		end)
		local function v_u_55(p52)
			-- upvalues: (copy) v_u_38, (ref) v_u_27, (ref) v_u_15, (ref) v_u_4, (ref) v_u_14, (ref) v_u_2, (ref) v_u_18
			local v53 = v_u_38:Add(v_u_27:Clone())
			v53.CFrame = CFrame.new(p52.X, v_u_15 - 1, p52.Z) * CFrame.Angles(math.random() * 6.283185307179586, 0, math.random() * 6.283185307179586)
			v_u_4:AddItem(v53, 0.9)
			v53.Parent = v_u_14
			local v_u_54 = v_u_38:Add(v_u_2:Create(v53, v_u_18, {
				["Transparency"] = 1
			}))
			v_u_54.Completed:Once(function()
				-- upvalues: (copy) v_u_54
				v_u_54:Destroy()
			end)
			v_u_54:Play()
		end
		math.random(1, 100000)
		local v_u_56 = v_u_38:Add(v_u_22:Clone())
		v_u_56:Start()
		v_u_56:BindToRenderStep(v_u_9.NextRenderName(), Enum.RenderPriority.Camera.Value + 1, function()
			-- upvalues: (copy) p_u_37, (copy) v_u_56, (ref) v_u_19, (ref) v_u_20
			if p_u_37.Parent then
				local v57, v58 = v_u_56:Update()
				local v59 = (v_u_19.CFrame.Position - p_u_37.Position).Magnitude - 25
				local v60 = 1 - math.max(0, v59) / 75
				local v61 = math.clamp(v60, 0, 1)
				local v62 = v61 * v61
				if v62 >= 0.01 then
					if not v_u_20 then
						v_u_20 = v_u_19.CFrame
					end
					local v63 = v57 * v62
					local v64 = v58 * v62
					v_u_20 = v_u_20 * (CFrame.new(v63) * CFrame.Angles(v64.X, v64.Y, v64.Z))
				end
			else
				return
			end
		end)
		local v_u_65 = p_u_37.Position
		v_u_38:Add(v_u_3.PostSimulation:Connect(function()
			-- upvalues: (copy) p_u_37, (copy) v_u_40, (ref) v_u_65, (copy) v_u_55
			if p_u_37.Parent then
				v_u_40:PivotTo(p_u_37:GetPivot())
				local v66 = p_u_37.Position
				if (v66 - v_u_65).Magnitude >= 1.5 then
					v_u_55(v66)
					v_u_65 = v66
				end
			end
		end))
		return function()
			-- upvalues: (copy) v_u_38
			v_u_38:Destroy()
		end
	end, v36)
end
return v5