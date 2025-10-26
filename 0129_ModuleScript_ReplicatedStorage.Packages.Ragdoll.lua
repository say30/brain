--[[
  Extracted from: ReplicatedStorage.Packages.Ragdoll
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local v1 = {}
local u2 = script.Ragdoll
function v1.Ragdoll(p3) --[[Anonymous function at line 5]]
    --[[
    Upvalues:
        [1] = u2
    --]]
	local v4 = p3:WaitForChild("Humanoid")
	if v4:GetState() ~= Enum.HumanoidStateType.Physics then
		v4.BreakJointsOnDeath = false
		for _, v5 in pairs(p3:GetDescendants()) do
			if v5:IsA("Motor6D") then
				if not u2 then
					return
				end
				local v6 = Instance.new("BallSocketConstraint")
				local v7 = Instance.new("Attachment")
				local v8 = Instance.new("Attachment")
				v7.Parent = v5.Part0
				v8.Parent = v5.Part1
				v6.Parent = v5.Parent
				u2:FireClient(game.Players:GetPlayerFromCharacter(p3), nil, "manualM")
				v6.Attachment0 = v7
				v6.Attachment1 = v8
				v7.CFrame = v5.C0
				v8.CFrame = v5.C1
				v6.LimitsEnabled = true
				if v5.Name == "Root" then
					v6:Destroy()
					local v9 = Instance.new("HingeConstraint")
					v9.Parent = v5.Parent
					v9.Attachment0 = v7
					v9.Attachment1 = v8
					v9.LimitsEnabled = true
				end
				if v5.Name == "Neck" then
					v6:Destroy()
					local v10 = Instance.new("HingeConstraint")
					v10.Parent = v5.Parent
					v10.Attachment0 = v7
					v10.Attachment1 = v8
					v10.LimitsEnabled = true
				end
				v6.TwistLimitsEnabled = true
				v5.Enabled = false
			end
		end
	end
end
function v1.NpcRagdoll(p11, p12) --[[Anonymous function at line 50]]
	local v13
	if p11 then
		v13 = p11.Humanoid
	else
		v13 = p11
	end
	if v13 then
		local _ = v13.RootPart
	end
	v13.BreakJointsOnDeath = false
	if v13:GetState() ~= Enum.HumanoidStateType.Physics then
		for _, v14 in pairs(p11:GetDescendants()) do
			if v14:IsA("Motor6D") then
				local v15 = Instance.new("BallSocketConstraint")
				local v16 = Instance.new("Attachment")
				local v17 = Instance.new("Attachment")
				v16.Parent = v14.Part0
				v17.Parent = v14.Part1
				v15.Parent = v14.Parent
				v15.Attachment0 = v16
				v15.Attachment1 = v17
				v16.CFrame = v14.C0
				v17.CFrame = v14.C1
				v15.LimitsEnabled = true
				v15.TwistLimitsEnabled = true
				v13.PlatformStand = true
				if v14.Name == "Root" then
					v15:Destroy()
					local v18 = Instance.new("HingeConstraint")
					v18.Parent = v14.Parent
					v18.Attachment0 = v16
					v18.Attachment1 = v17
					v18.LimitsEnabled = true
				end
				if v14.Name == "Neck" then
					v15:Destroy()
					local v19 = Instance.new("HingeConstraint")
					v19.Parent = v14.Parent
					v19.Attachment0 = v16
					v19.Attachment1 = v17
					v19.LimitsEnabled = true
				end
				v13:ChangeState(Enum.HumanoidStateType.Physics)
				v14.Enabled = false
			end
		end
		task.wait(p12)
		for _, v20 in pairs(p11:GetDescendants()) do
			if v20:IsA("Motor6D") then
				local v21 = v20.Parent:FindFirstChild("BallSocketConstraint") or v20.Parent:FindFirstChild("HingeConstraint")
				local v22 = v20.Part0:FindFirstChild("Attachment")
				local v23 = v20.Part1:FindFirstChild("Attachment")
				v21:Destroy()
				v22:Destroy()
				v23:Destroy()
				v13.PlatformStand = false
				v13:ChangeState(Enum.HumanoidStateType.GettingUp)
				v20.Enabled = true
			end
		end
	end
end
function v1.TimedRagdoll(p24, p25) --[[Anonymous function at line 107]]
    --[[
    Upvalues:
        [1] = u2
    --]]
	local v26 = p24:WaitForChild("Humanoid")
	v26.BreakJointsOnDeath = false
	if u2 then
		u2:FireClient(game.Players:GetPlayerFromCharacter(p24), "Make", p25)
		if v26:GetState() ~= Enum.HumanoidStateType.Physics then
			for _, v27 in pairs(p24:GetDescendants()) do
				if v27:IsA("Motor6D") then
					local v28 = Instance.new("BallSocketConstraint")
					local v29 = Instance.new("Attachment")
					local v30 = Instance.new("Attachment")
					v29.Parent = v27.Part0
					v30.Parent = v27.Part1
					v28.Parent = v27.Parent
					v28.Attachment0 = v29
					v28.Attachment1 = v30
					v29.CFrame = v27.C0
					v30.CFrame = v27.C1
					v28.LimitsEnabled = true
					v28.TwistLimitsEnabled = true
					if v27.Name == "Root" then
						v28:Destroy()
						local v31 = Instance.new("HingeConstraint")
						v31.Parent = v27.Parent
						v31.Attachment0 = v29
						v31.Attachment1 = v30
						v31.LimitsEnabled = true
					end
					if v27.Name == "Neck" then
						v28:Destroy()
						local v32 = Instance.new("HingeConstraint")
						v32.Parent = v27.Parent
						v32.Attachment0 = v29
						v32.Attachment1 = v30
						v32.LimitsEnabled = true
					end
					v27.Enabled = false
				end
			end
			task.wait(p25)
			local v33 = game.Players:GetPlayerFromCharacter(p24)
			if v33 then
				u2:FireClient(v33, "Destroy", p25)
			end
			for _, v34 in pairs(p24:GetDescendants()) do
				if v34:IsA("Motor6D") then
					local v35 = v34.Parent:FindFirstChild("BallSocketConstraint") or v34.Parent:FindFirstChild("HingeConstraint")
					local v36 = v34.Part0:FindFirstChild("Attachment")
					local v37 = v34.Part1:FindFirstChild("Attachment")
					v35:Destroy()
					v36:Destroy()
					v37:Destroy()
					v34.Enabled = true
				end
			end
		end
	end
end
function v1.Unragdoll(p38) --[[Anonymous function at line 171]]
    --[[
    Upvalues:
        [1] = u2
    --]]
	for _, v39 in pairs(p38:GetDescendants()) do
		if v39:IsA("Motor6D") then
			if not u2 then
				return
			end
			if v39.Part0 and v39.Part1 then
				p38:WaitForChild("Humanoid")
				local v40 = v39.Parent:FindFirstChild("BallSocketConstraint") or v39.Parent:FindFirstChild("HingeConstraint")
				local v41 = v39.Part0:FindFirstChild("Attachment")
				local v42 = v39.Part1:FindFirstChild("Attachment")
				if v40 then
					v40:Destroy()
				end
				if v41 then
					v41:Destroy()
				end
				if v42 then
					v42:Destroy()
				end
				u2:FireClient(game.Players:GetPlayerFromCharacter(p38), nil, "manualD")
				v39.Enabled = true
			end
		end
	end
end
return v1