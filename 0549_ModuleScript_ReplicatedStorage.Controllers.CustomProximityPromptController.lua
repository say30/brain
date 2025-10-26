--[[
  Extracted from: ReplicatedStorage.Controllers.CustomProximityPromptController
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Thanks For Angelus Decompiles --> https://discord.gg/CYXme7yEG9

-- Decompiled with Velocity Script Decompiler
local v_u_1 = game:GetService("ProximityPromptService")
local v_u_2 = game:GetService("UserInputService")
local v_u_3 = game:GetService("TweenService")
local v_u_4 = game:GetService("TextService")
local v_u_5 = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
local v_u_6 = {
	[Enum.KeyCode.ButtonX] = "rbxasset://textures/ui/Controls/xboxX.png",
	[Enum.KeyCode.ButtonY] = "rbxasset://textures/ui/Controls/xboxY.png",
	[Enum.KeyCode.ButtonA] = "rbxasset://textures/ui/Controls/xboxA.png",
	[Enum.KeyCode.ButtonB] = "rbxasset://textures/ui/Controls/xboxB.png",
	[Enum.KeyCode.DPadLeft] = "rbxasset://textures/ui/Controls/dpadLeft.png",
	[Enum.KeyCode.DPadRight] = "rbxasset://textures/ui/Controls/dpadRight.png",
	[Enum.KeyCode.DPadUp] = "rbxasset://textures/ui/Controls/dpadUp.png",
	[Enum.KeyCode.DPadDown] = "rbxasset://textures/ui/Controls/dpadDown.png",
	[Enum.KeyCode.ButtonSelect] = "rbxasset://textures/ui/Controls/xboxView.png",
	[Enum.KeyCode.ButtonStart] = "rbxasset://textures/ui/Controls/xboxmenu.png",
	[Enum.KeyCode.ButtonL1] = "rbxasset://textures/ui/Controls/xboxLB.png",
	[Enum.KeyCode.ButtonR1] = "rbxasset://textures/ui/Controls/xboxRB.png",
	[Enum.KeyCode.ButtonL2] = "rbxasset://textures/ui/Controls/xboxLT.png",
	[Enum.KeyCode.ButtonR2] = "rbxasset://textures/ui/Controls/xboxRT.png",
	[Enum.KeyCode.ButtonL3] = "rbxasset://textures/ui/Controls/xboxLS.png",
	[Enum.KeyCode.ButtonR3] = "rbxasset://textures/ui/Controls/xboxRS.png",
	[Enum.KeyCode.Thumbstick1] = "rbxasset://textures/ui/Controls/xboxLSDirectional.png",
	[Enum.KeyCode.Thumbstick2] = "rbxasset://textures/ui/Controls/xboxRSDirectional.png"
}
local v_u_7 = {
	[Enum.KeyCode.Backspace] = "rbxasset://textures/ui/Controls/backspace.png",
	[Enum.KeyCode.Return] = "rbxasset://textures/ui/Controls/return.png",
	[Enum.KeyCode.LeftShift] = "rbxasset://textures/ui/Controls/shift.png",
	[Enum.KeyCode.RightShift] = "rbxasset://textures/ui/Controls/shift.png",
	[Enum.KeyCode.Tab] = "rbxasset://textures/ui/Controls/tab.png"
}
local v_u_8 = {
	["\'"] = "rbxasset://textures/ui/Controls/apostrophe.png",
	[","] = "rbxasset://textures/ui/Controls/comma.png",
	["`"] = "rbxasset://textures/ui/Controls/graveaccent.png",
	["."] = "rbxasset://textures/ui/Controls/period.png",
	[" "] = "rbxasset://textures/ui/Controls/spacebar.png"
}
local v_u_9 = {
	[Enum.KeyCode.LeftControl] = "Ctrl",
	[Enum.KeyCode.RightControl] = "Ctrl",
	[Enum.KeyCode.LeftAlt] = "Alt",
	[Enum.KeyCode.RightAlt] = "Alt",
	[Enum.KeyCode.F1] = "F1",
	[Enum.KeyCode.F2] = "F2",
	[Enum.KeyCode.F3] = "F3",
	[Enum.KeyCode.F4] = "F4",
	[Enum.KeyCode.F5] = "F5",
	[Enum.KeyCode.F6] = "F6",
	[Enum.KeyCode.F7] = "F7",
	[Enum.KeyCode.F8] = "F8",
	[Enum.KeyCode.F9] = "F9",
	[Enum.KeyCode.F10] = "F10",
	[Enum.KeyCode.F11] = "F11",
	[Enum.KeyCode.F12] = "F12"
}
local function v_u_15(p10, p11)
	local v12 = Instance.new("Frame")
	v12.Size = UDim2.fromScale(0.5, 1)
	v12.Position = UDim2.fromScale(p11 and 0 or 0.5, 0)
	v12.BackgroundTransparency = 1
	v12.ClipsDescendants = true
	v12.Parent = p10
	local v13 = Instance.new("ImageLabel")
	v13.BackgroundTransparency = 1
	v13.Size = UDim2.fromScale(2, 1)
	v13.Position = UDim2.fromScale(p11 and 0 or -1, 0)
	v13.Image = "rbxasset://textures/ui/Controls/RadialFill.png"
	v13.Parent = v12
	local v14 = Instance.new("UIGradient")
	v14.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0),
		NumberSequenceKeypoint.new(0.4999, 0),
		NumberSequenceKeypoint.new(0.5, 1),
		NumberSequenceKeypoint.new(1, 1)
	})
	v14.Rotation = p11 and 180 or 0
	v14.Parent = v13
	return v14
end
local function v_u_23()
	-- upvalues: (copy) v_u_15
	local v16 = Instance.new("Frame")
	v16.Name = "CircularProgressBar"
	v16.Size = UDim2.fromOffset(58, 58)
	v16.AnchorPoint = Vector2.new(0.5, 0.5)
	v16.Position = UDim2.fromScale(0.5, 0.5)
	v16.BackgroundTransparency = 1
	local v_u_17 = v_u_15(v16, true)
	local v_u_18 = v_u_15(v16, false)
	local v19 = Instance.new("NumberValue")
	v19.Name = "Progress"
	v19.Parent = v16
	v19.Changed:Connect(function(p20)
		-- upvalues: (copy) v_u_17, (copy) v_u_18
		local v21 = p20 * 360
		local v22 = math.clamp(v21, 0, 360)
		v_u_17.Rotation = math.clamp(v22, 180, 360)
		v_u_18.Rotation = math.clamp(v22, 0, 180)
	end)
	return v16
end
local function v_u_116(p_u_24, p25, p26)
	-- upvalues: (copy) v_u_3, (copy) v_u_6, (copy) v_u_2, (copy) v_u_7, (copy) v_u_8, (copy) v_u_9, (copy) v_u_23, (copy) v_u_4
	local v_u_27 = {}
	local v_u_28 = {}
	local v_u_29 = {}
	local v_u_30 = {}
	local v31 = TweenInfo.new(p_u_24.HoldDuration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
	local v32 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local v33 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local v34 = TweenInfo.new(0.06, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
	local v_u_35 = Instance.new("BillboardGui")
	v_u_35.Name = "Prompt"
	v_u_35.AlwaysOnTop = true
	local v36 = Instance.new("Frame")
	v36.Size = UDim2.fromScale(0.5, 1)
	v36.BackgroundTransparency = 1
	v36.BackgroundColor3 = Color3.new(0.07, 0.07, 0.07)
	v36.Parent = v_u_35
	local v_u_37 = p_u_24:GetAttribute("State") == "Sell"
	if v_u_37 then
		v36.BackgroundColor3 = Color3.fromRGB(67, 0, 0)
	end
	Instance.new("UICorner").Parent = v36
	local v38 = Instance.new("Frame")
	v38.Name = "InputFrame"
	v38.Size = UDim2.fromScale(1, 1)
	v38.BackgroundTransparency = 1
	v38.SizeConstraint = Enum.SizeConstraint.RelativeYY
	v38.Parent = v36
	local v39 = Instance.new("Frame")
	v39.Size = UDim2.fromScale(1, 1)
	v39.Position = UDim2.fromScale(0.5, 0.5)
	v39.AnchorPoint = Vector2.new(0.5, 0.5)
	v39.BackgroundTransparency = 1
	v39.Parent = v38
	local v40 = Instance.new("UIScale")
	v40.Parent = v39
	local v41 = p25 == Enum.ProximityPromptInputType.Touch and 1.6 or 1.33
	local v42 = v_u_3
	table.insert(v_u_27, v42:Create(v40, v33, {
		["Scale"] = v41
	}))
	local v43 = v_u_3
	table.insert(v_u_28, v43:Create(v40, v33, {
		["Scale"] = 1
	}))
	local v_u_44 = Instance.new("TextLabel")
	v_u_44.Name = "ActionText"
	v_u_44.Size = UDim2.fromScale(1, 1)
	v_u_44.Font = Enum.Font.GothamMedium
	v_u_44.TextSize = 19
	v_u_44.BackgroundTransparency = 1
	v_u_44.TextTransparency = 1
	v_u_44.TextColor3 = Color3.new(1, 1, 1)
	v_u_44.TextXAlignment = Enum.TextXAlignment.Left
	v_u_44.Parent = v36
	local v45 = v_u_3
	table.insert(v_u_27, v45:Create(v_u_44, v33, {
		["TextTransparency"] = 1
	}))
	local v46 = v_u_3
	table.insert(v_u_28, v46:Create(v_u_44, v33, {
		["TextTransparency"] = 0
	}))
	local v47 = v_u_3
	table.insert(v_u_29, v47:Create(v_u_44, v33, {
		["TextTransparency"] = 1
	}))
	local v48 = v_u_3
	table.insert(v_u_30, v48:Create(v_u_44, v33, {
		["TextTransparency"] = 0
	}))
	local v_u_49 = Instance.new("TextLabel")
	v_u_49.Name = "ObjectText"
	v_u_49.Size = UDim2.fromScale(1, 1)
	v_u_49.Font = Enum.Font.GothamMedium
	v_u_49.TextSize = 14
	v_u_49.BackgroundTransparency = 1
	v_u_49.TextTransparency = 1
	v_u_49.TextColor3 = Color3.new(0.7, 0.7, 0.7)
	v_u_49.TextXAlignment = Enum.TextXAlignment.Left
	v_u_49.Parent = v36
	local v50 = v_u_3
	table.insert(v_u_27, v50:Create(v_u_49, v33, {
		["TextTransparency"] = 1
	}))
	local v51 = v_u_3
	table.insert(v_u_28, v51:Create(v_u_49, v33, {
		["TextTransparency"] = 0
	}))
	local v52 = v_u_3
	table.insert(v_u_29, v52:Create(v_u_49, v33, {
		["TextTransparency"] = 1
	}))
	local v53 = v_u_3
	table.insert(v_u_30, v53:Create(v_u_49, v33, {
		["TextTransparency"] = 0
	}))
	local v54 = v_u_3
	local v55 = {
		["Size"] = UDim2.fromScale(0.5, 1),
		["BackgroundTransparency"] = 1
	}
	table.insert(v_u_27, v54:Create(v36, v33, v55))
	local v56 = v_u_3
	local v57 = {
		["Size"] = UDim2.fromScale(1, 1),
		["BackgroundTransparency"] = 0.2
	}
	table.insert(v_u_28, v56:Create(v36, v33, v57))
	local v58 = v_u_3
	local v59 = {
		["Size"] = UDim2.fromScale(0.5, 1),
		["BackgroundTransparency"] = 1
	}
	table.insert(v_u_29, v58:Create(v36, v33, v59))
	local v60 = v_u_3
	local v61 = {
		["Size"] = UDim2.fromScale(1, 1),
		["BackgroundTransparency"] = 0.2
	}
	table.insert(v_u_30, v60:Create(v36, v33, v61))
	local v62 = Instance.new("Frame")
	v62.Name = "RoundFrame"
	v62.Size = UDim2.fromOffset(48, 48)
	v62.AnchorPoint = Vector2.new(0.5, 0.5)
	v62.Position = UDim2.fromScale(0.5, 0.5)
	v62.BackgroundTransparency = 1
	v62.Parent = v39
	local v63 = Instance.new("UICorner")
	v63.CornerRadius = UDim.new(0.5, 0)
	v63.Parent = v62
	local v64 = v_u_3
	table.insert(v_u_29, v64:Create(v62, v34, {
		["BackgroundTransparency"] = 1
	}))
	local v65 = v_u_3
	table.insert(v_u_30, v65:Create(v62, v34, {
		["BackgroundTransparency"] = 0.5
	}))
	if p25 == Enum.ProximityPromptInputType.Gamepad then
		if v_u_6[p_u_24.GamepadKeyCode] ~= nil then
			local v66 = Instance.new("ImageLabel")
			v66.Name = "ButtonImage"
			v66.AnchorPoint = Vector2.new(0.5, 0.5)
			v66.Size = UDim2.fromOffset(24, 24)
			v66.Position = UDim2.fromScale(0.5, 0.5)
			v66.BackgroundTransparency = 1
			v66.ImageTransparency = 1
			v66.Image = v_u_2:GetImageForKeyCode(p_u_24.GamepadKeyCode)
			v66.Parent = v39
			local v67 = v_u_3
			table.insert(v_u_29, v67:Create(v66, v34, {
				["ImageTransparency"] = 1
			}))
			local v68 = v_u_3
			table.insert(v_u_30, v68:Create(v66, v34, {
				["ImageTransparency"] = 0
			}))
		end
	elseif p25 == Enum.ProximityPromptInputType.Touch then
		local v69 = Instance.new("ImageLabel")
		v69.Name = "ButtonImage"
		v69.BackgroundTransparency = 1
		v69.ImageTransparency = 1
		v69.Size = UDim2.fromOffset(25, 31)
		v69.AnchorPoint = Vector2.new(0.5, 0.5)
		v69.Position = UDim2.fromScale(0.5, 0.5)
		v69.Image = "rbxasset://textures/ui/Controls/TouchTapIcon.png"
		v69.Parent = v39
		local v70 = v_u_3
		table.insert(v_u_29, v70:Create(v69, v34, {
			["ImageTransparency"] = 1
		}))
		local v71 = v_u_3
		table.insert(v_u_30, v71:Create(v69, v34, {
			["ImageTransparency"] = 0
		}))
	else
		local v72 = Instance.new("ImageLabel")
		v72.Name = "ButtonImage"
		v72.BackgroundTransparency = 1
		v72.ImageTransparency = 1
		v72.Size = UDim2.fromOffset(28, 30)
		v72.AnchorPoint = Vector2.new(0.5, 0.5)
		v72.Position = UDim2.fromScale(0.5, 0.5)
		v72.Image = "rbxasset://textures/ui/Controls/key_single.png"
		v72.Parent = v39
		local v73 = v_u_3
		table.insert(v_u_29, v73:Create(v72, v34, {
			["ImageTransparency"] = 1
		}))
		local v74 = v_u_3
		table.insert(v_u_30, v74:Create(v72, v34, {
			["ImageTransparency"] = 0
		}))
		local v75 = v_u_2:GetStringForKeyCode(p_u_24.KeyboardKeyCode)
		local v76 = v_u_7[p_u_24.KeyboardKeyCode]
		if v76 == nil then
			v76 = v_u_8[v75]
		end
		if v76 == nil then
			v75 = v_u_9[p_u_24.KeyboardKeyCode] or v75
		end
		if v76 then
			local v77 = Instance.new("ImageLabel")
			v77.Name = "ButtonImage"
			v77.AnchorPoint = Vector2.new(0.5, 0.5)
			v77.Size = UDim2.fromOffset(36, 36)
			v77.Position = UDim2.fromScale(0.5, 0.5)
			v77.BackgroundTransparency = 1
			v77.ImageTransparency = 1
			v77.Image = v76
			v77.Parent = v39
			local v78 = v_u_3
			table.insert(v_u_29, v78:Create(v77, v34, {
				["ImageTransparency"] = 1
			}))
			local v79 = v_u_3
			table.insert(v_u_30, v79:Create(v77, v34, {
				["ImageTransparency"] = 0
			}))
		elseif v75 == nil or v75 == "" then
			local v80 = error
			local v81 = p_u_24.Name
			local v82 = p_u_24.KeyboardKeyCode
			v80("ProximityPrompt \'" .. v81 .. "\' has an unsupported keycode for rendering UI: " .. tostring(v82))
		else
			local v83 = Instance.new("TextLabel")
			v83.Name = "ButtonText"
			v83.Position = UDim2.fromOffset(0, -1)
			v83.Size = UDim2.fromScale(1, 1)
			v83.Font = Enum.Font.GothamMedium
			v83.TextSize = 14
			if string.len(v75) > 2 then
				v83.TextSize = 12
			end
			v83.BackgroundTransparency = 1
			v83.TextTransparency = 1
			v83.TextColor3 = Color3.new(1, 1, 1)
			v83.TextXAlignment = Enum.TextXAlignment.Center
			v83.Text = v75
			v83.Parent = v39
			local v84 = v_u_3
			table.insert(v_u_29, v84:Create(v83, v34, {
				["TextTransparency"] = 1
			}))
			local v85 = v_u_3
			table.insert(v_u_30, v85:Create(v83, v34, {
				["TextTransparency"] = 0
			}))
		end
	end
	if p25 == Enum.ProximityPromptInputType.Touch or p_u_24.ClickablePrompt then
		local v86 = Instance.new("TextButton")
		v86.BackgroundTransparency = 1
		v86.TextTransparency = 1
		v86.Size = UDim2.fromScale(1, 1)
		v86.Parent = v_u_35
		local v_u_87 = false
		v86.InputBegan:Connect(function(p88)
			-- upvalues: (copy) p_u_24, (ref) v_u_87
			if (p88.UserInputType == Enum.UserInputType.Touch or p88.UserInputType == Enum.UserInputType.MouseButton1) and p88.UserInputState ~= Enum.UserInputState.Change then
				p_u_24:InputHoldBegin()
				v_u_87 = true
			end
		end)
		v86.InputEnded:Connect(function(p89)
			-- upvalues: (ref) v_u_87, (copy) p_u_24
			if (p89.UserInputType == Enum.UserInputType.Touch or p89.UserInputType == Enum.UserInputType.MouseButton1) and v_u_87 then
				v_u_87 = false
				p_u_24:InputHoldEnd()
			end
		end)
		v_u_35.Active = true
	end
	if p_u_24.HoldDuration > 0 then
		local v90 = v_u_23()
		v90.Parent = v39
		local v91 = v_u_3
		local v92 = v90.Progress
		table.insert(v_u_27, v91:Create(v92, v31, {
			["Value"] = 1
		}))
		local v93 = v_u_3
		local v94 = v90.Progress
		table.insert(v_u_28, v93:Create(v94, v32, {
			["Value"] = 0
		}))
	end
	local v_u_95, v_u_96
	if p_u_24.HoldDuration > 0 then
		v_u_95 = p_u_24.PromptButtonHoldBegan:Connect(function()
			-- upvalues: (copy) v_u_27
			for _, v97 in ipairs(v_u_27) do
				v97:Play()
			end
		end)
		v_u_96 = p_u_24.PromptButtonHoldEnded:Connect(function()
			-- upvalues: (copy) v_u_28
			for _, v98 in ipairs(v_u_28) do
				v98:Play()
			end
		end)
	else
		v_u_95 = nil
		v_u_96 = nil
	end
	local v_u_100 = p_u_24.Triggered:Connect(function()
		-- upvalues: (copy) v_u_29
		for _, v99 in ipairs(v_u_29) do
			v99:Play()
		end
	end)
	local v_u_102 = p_u_24.TriggerEnded:Connect(function()
		-- upvalues: (copy) v_u_30
		for _, v101 in ipairs(v_u_30) do
			v101:Play()
		end
	end)
	local function v112()
		-- upvalues: (ref) v_u_4, (copy) p_u_24, (copy) v_u_37, (copy) v_u_44, (copy) v_u_49, (copy) v_u_35
		local v103 = v_u_4:GetTextSize(p_u_24.ActionText, 19, Enum.Font.GothamMedium, Vector2.new(1000, 1000))
		local v104 = v_u_4:GetTextSize(p_u_24.ObjectText, 14, Enum.Font.GothamMedium, Vector2.new(1000, 1000))
		local v105 = v103.X
		local v106 = v104.X
		local v107 = math.max(v105, v106)
		local v108, v109, v110
		if v_u_37 then
			v108 = 62
			v109 = 62
			v110 = 62
		else
			v108 = 72
			v109 = 72
			v110 = 72
		end
		if p_u_24.ActionText ~= nil and p_u_24.ActionText ~= "" or p_u_24.ObjectText ~= nil and p_u_24.ObjectText ~= "" then
			v108 = v107 + v109 + 24
		end
		local v111 = (p_u_24.ObjectText == nil or p_u_24.ObjectText == "") and 0 or 9
		v_u_44.Position = UDim2.new(0.5, v109 - v108 / 2, 0, v111)
		v_u_49.Position = UDim2.new(0.5, v109 - v108 / 2, 0, -10)
		v_u_44.Text = p_u_24.ActionText
		v_u_49.Text = p_u_24.ObjectText
		v_u_44.AutoLocalize = p_u_24.AutoLocalize
		v_u_44.RootLocalizationTable = p_u_24.RootLocalizationTable
		v_u_49.AutoLocalize = p_u_24.AutoLocalize
		v_u_49.RootLocalizationTable = p_u_24.RootLocalizationTable
		v_u_35.Size = UDim2.fromOffset(v108, v110)
		v_u_35.SizeOffset = Vector2.new(p_u_24.UIOffset.X / v_u_35.Size.Width.Offset, p_u_24.UIOffset.Y / v_u_35.Size.Height.Offset)
	end
	local v_u_113 = p_u_24.Changed:Connect(v112)
	v112()
	v_u_35.Adornee = p_u_24.Parent
	v_u_35.Parent = p26
	for _, v114 in ipairs(v_u_30) do
		v114:Play()
	end
	return function()
		-- upvalues: (ref) v_u_95, (ref) v_u_96, (ref) v_u_100, (ref) v_u_102, (copy) v_u_113, (copy) v_u_29, (copy) v_u_35
		if v_u_95 then
			v_u_95:Disconnect()
		end
		if v_u_96 then
			v_u_96:Disconnect()
		end
		v_u_100:Disconnect()
		v_u_102:Disconnect()
		v_u_113:Disconnect()
		for _, v115 in ipairs(v_u_29) do
			v115:Play()
		end
		task.wait(0.2)
		v_u_35.Parent = nil
	end
end
task.spawn(function()
	-- upvalues: (copy) v_u_1, (copy) v_u_5, (copy) v_u_116
	local v_u_117 = false
	v_u_1.PromptShown:Connect(function(p118, p119)
		-- upvalues: (ref) v_u_117, (ref) v_u_5, (ref) v_u_116
		if p118.Style == Enum.ProximityPromptStyle.Default then
			return
		elseif p118:GetAttribute("State") ~= "Sell" and p118:GetAttribute("State") ~= "Grab" or not v_u_117 then
			local v120 = v_u_5:FindFirstChild("ProximityPrompts")
			if v120 == nil then
				v120 = Instance.new("ScreenGui")
				v120.Name = "ProximityPrompts"
				v120.ResetOnSpawn = false
				v120.Parent = v_u_5
			end
			local v121 = v_u_116(p118, p119, v120)
			p118.PromptHidden:Wait()
			v121()
		end
	end)
	v_u_1.PromptButtonHoldBegan:Connect(function()
		-- upvalues: (ref) v_u_117
		v_u_117 = true
	end)
	v_u_1.PromptButtonHoldEnded:Connect(function()
		-- upvalues: (ref) v_u_117
		v_u_117 = false
	end)
end)
return {}