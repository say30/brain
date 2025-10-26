--[[
  Extracted from: ReplicatedStorage.Controllers.IndexController
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled with Velocity Script Decompiler
local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v3 = v1:WaitForChild("Packages")
local v_u_4 = require(v1.Packages.Gradients)
local v_u_5 = require(v1.Utils.TimeUtils)
local v_u_6 = require(v1.Packages.FFlags)
local v_u_7 = require(v3.Synchronizer)
local v8 = require(v3.Trove)
local v9 = v1:WaitForChild("Datas")
local v_u_10 = require(v9.Animals)
local v_u_11 = require(v9.Rarities)
local v_u_12 = require(v9.Mutations)
local v13 = v1:WaitForChild("Shared")
local v_u_14 = require(v13.Animals)
local v_u_15 = require(v13.Index)
local v_u_16 = require(v13.Updates)
local v17 = v1:WaitForChild("Controllers")
local v_u_18 = require(v17.InterfaceController)
local v19 = v1:WaitForChild("Classes")
local v_u_20 = require(v19.AnimatedButton)
local v_u_21 = v2.LocalPlayer
local v_u_22 = v_u_21.PlayerGui:WaitForChild("Index").Index
local v_u_23 = v_u_22.Main.Header.Close
local v_u_24 = v_u_22.Main.Content.Holder.List
local v_u_25 = v_u_24.Template
local v_u_26 = v_u_22.Main.Mutations
local v_u_27 = v_u_26.Template
local v28 = v_u_22.Progress
local v_u_29 = v28.Description
local v30 = v28.Bar
local v_u_31 = v30.Loading
local v_u_32 = v30.Number
local v_u_33 = "Default"
local v_u_34 = v8.new()
local v_u_35 = nil
local v36 = {}
local function v_u_60()
	-- upvalues: (copy) v_u_7, (copy) v_u_21, (ref) v_u_33, (copy) v_u_12, (copy) v_u_29, (copy) v_u_14, (copy) v_u_10, (copy) v_u_11, (copy) v_u_15, (copy) v_u_24, (copy) v_u_25, (copy) v_u_34, (copy) v_u_4, (copy) v_u_31, (copy) v_u_32
	local v_u_37 = v_u_7:Get(v_u_21)
	if v_u_37 then
		local v38 = Color3.new(1, 1, 1)
		if v_u_33 ~= "Default" and v_u_33 ~= nil then
			v38 = v_u_12[v_u_33].MainColor
		end
		v_u_29.Text = v_u_33 == "Default" and "Collect Normal Brainrots for +0.5x Base Multi" or ("Collect <font color=\"#%*\">%*</font> Brainrots for +0.5x Base Multi and a <font color=\"#%*\">%* Base</font>"):format(v38:ToHex(), v_u_33, v38:ToHex(), v_u_33)
		local v39 = v_u_14:GetList("Price", true)
		for v40 = 1, #v39 do
			local v_u_41 = v39[v40]
			local v42 = v_u_10[v_u_41]
			local v43 = v_u_11[v42.Rarity]
			if v_u_15:CanShowInIndex(v_u_41) then
				local v44 = v_u_24:FindFirstChild(v_u_41)
				if v44 then
					v44:SetAttribute("Mutation", v_u_33 or "Default")
				else
					local v_u_45 = v_u_25:Clone()
					v_u_45.Name = v_u_41
					v_u_45.LayoutOrder = v40
					v_u_45.Visible = true
					v_u_45:SetAttribute("Mutation", v_u_33 or "Default")
					v_u_45.NameLabel.Text = v42.DisplayName
					if v43.GradientPreset then
						v_u_45.RarityLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
						v_u_34:Add(v_u_4.apply(v_u_45.RarityLabel, v43.GradientPreset))
					else
						v_u_45.RarityLabel.TextColor3 = v43.Color
					end
					v_u_45.RarityLabel.Text = v42.Rarity
					local v46, v_u_47 = v_u_14:AttachOnViewport(v_u_41, v_u_45.ViewportFrame, true)
					if v46 then
						v_u_34:Add(v_u_45)
					end
					local v_u_48 = nil
					local v_u_49 = nil
					local function v59()
						-- upvalues: (copy) v_u_45, (copy) v_u_37, (copy) v_u_41, (ref) v_u_15, (ref) v_u_21, (ref) v_u_33, (ref) v_u_31, (ref) v_u_32, (ref) v_u_49, (ref) v_u_34, (ref) v_u_4, (ref) v_u_12, (ref) v_u_48, (copy) v_u_47, (ref) v_u_14
						local v50 = v_u_45:GetAttribute("Mutation") or "Default"
						local v51 = v_u_37:Get((("Index.%*"):format(v_u_41)))
						local v52
						if v51 == nil then
							v52 = nil
						else
							v52 = v51[v50] or nil
						end
						v_u_45.NameLabel.Visible = v52 ~= nil
						v_u_45.ViewportFrame.ImageColor3 = v52 == nil and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
						local v53, v54 = v_u_15:GetIndexAnimals(v_u_21, v_u_33)
						local v55 = v_u_15:IsComplete(v_u_21, v_u_33)
						local v56 = v_u_31
						local v57 = UDim2.new
						local v58 = v53 / v54
						v56.Size = v57(math.clamp(v58, 0, 1), 0, 1, 0)
						if v55 then
							v_u_32.Text = ("Completed %*/%*"):format(v53, v54)
							v_u_32.TextColor3 = Color3.new(0.0588235, 1, 0.32549)
							v_u_31.BackgroundColor3 = Color3.new(0.490196, 0.941176, 0.439216)
						else
							v_u_32.Text = ("%*/%*"):format(v53, v54)
							v_u_32.TextColor3 = Color3.new(1, 1, 1)
							v_u_31.BackgroundColor3 = Color3.new(0.941176, 0.729412, 0.482353)
						end
						if v_u_49 then
							v_u_34:Remove(v_u_49)
							v_u_49 = nil
						end
						if v50 == "Rainbow" then
							v_u_45.MutationLabel.Text = "Rainbow"
							v_u_49 = v_u_34:Add(v_u_4.apply(v_u_45.MutationLabel, "Rainbow"))
						else
							v_u_45.MutationLabel.Text = not v_u_12[v50] and "Default" or v_u_12[v50].DisplayWithRichText
						end
						if v_u_48 then
							v_u_34:Remove(v_u_48)
							v_u_48 = nil
						end
						if v_u_47 and (v50 ~= "Default" and v52) then
							v_u_48 = v_u_34:Add(v_u_14:ApplyMutation(v_u_47, v_u_41, v50))
						end
					end
					v_u_34:Add(v_u_45:GetAttributeChangedSignal("Mutation"):Connect(v59))
					v_u_34:Add(v_u_37:OnChanged(("Index.%*"):format(v_u_41), v59, true))
					v_u_34:Add(task.spawn(v59))
					v_u_45.Parent = v_u_24
				end
			end
		end
	end
end
function v36.Start(_)
	-- upvalues: (ref) v_u_35, (copy) v_u_18, (copy) v_u_22, (copy) v_u_23, (copy) v_u_27, (copy) v_u_26, (copy) v_u_20, (ref) v_u_33, (copy) v_u_60, (copy) v_u_12, (copy) v_u_4, (copy) v_u_6, (copy) v_u_5, (copy) v_u_7, (copy) v_u_21, (copy) v_u_34, (copy) v_u_16
	v_u_35 = v_u_18:Register("Index", v_u_22, "TopQuint")
	v_u_35:AttachCloseButton(v_u_23)
	v_u_35:Close()
	local v_u_61 = v_u_27:Clone()
	v_u_61.TextLabel.Text = "Normal"
	v_u_61.Name = "Default"
	v_u_61.Parent = v_u_26
	v_u_61.Visible = true
	local v62 = v_u_20.new(v_u_61)
	v62:Animate()
	v62.OnActivated:Connect(function()
		-- upvalues: (ref) v_u_33, (copy) v_u_61, (ref) v_u_60
		if v_u_33 ~= v_u_61.Name then
			v_u_33 = v_u_61.Name
			v_u_60()
		end
	end)
	for v_u_63, v64 in v_u_12 do
		local v_u_65 = v64.LimitedMutation
		if not v_u_65 or v_u_65 >= workspace:GetServerTimeNow() then
			local v_u_66 = v_u_27:Clone()
			v_u_66.Name = v_u_63
			v_u_66.LayoutOrder = v64.Order or 1
			v_u_66.Visible = true
			v_u_66.TextLabel.Text = v64.DisplayText
			if v_u_63 == "Rainbow" then
				v_u_4.apply(v_u_66.TextLabel, "Rainbow")
			else
				v_u_66.TextLabel.TextColor3 = v64.MainColor
			end
			if v_u_65 then
				task.spawn(function()
					-- upvalues: (ref) v_u_6, (copy) v_u_63, (copy) v_u_65, (copy) v_u_66, (ref) v_u_5
					local v67 = true
					while true do
						local v68 = v_u_6:GetInstant(("%*Timer"):format(v_u_63), v_u_65) - workspace:GetServerTimeNow()
						v_u_66.Timer.Text = v_u_5:E(v68)
						v_u_66.Timer.Visible = v68 > 0
						if v68 <= 0 and not v67 then
							v_u_66.TextLabel.Position = UDim2.fromScale(0.5, 0.5)
							v_u_66.TextLabel.Size = UDim2.fromScale(0.85, 0.55)
							v_u_66.TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
							v67 = true
						elseif v68 > 0 and v67 then
							v_u_66.TextLabel.Position = UDim2.fromScale(0.5, 0)
							v_u_66.TextLabel.Size = UDim2.fromScale(0.85, 0.65)
							v_u_66.TextLabel.AnchorPoint = Vector2.new(0.5, 0)
							v67 = false
						end
						task.wait(1)
					end
				end)
			end
			v_u_66.Parent = v_u_26
			local v69 = v_u_20.new(v_u_66)
			v69:Animate()
			v69.OnActivated:Connect(function()
				-- upvalues: (ref) v_u_33, (copy) v_u_63, (ref) v_u_60
				if v_u_33 ~= v_u_63 then
					v_u_33 = v_u_63
					v_u_60()
				end
			end)
		end
	end
	v_u_7:WaitAndCall(v_u_21, function(_)
		-- upvalues: (ref) v_u_35, (ref) v_u_60, (ref) v_u_34
		v_u_35.OnOpen:Connect(v_u_60)
		v_u_35.OnClose:Connect(function()
			-- upvalues: (ref) v_u_34
			v_u_34:Clean()
		end)
		if v_u_35:IsOpened() then
			v_u_60()
		end
	end)
	v_u_34:Add(v_u_16.OnUpdateDisabled:Connect(function()
		-- upvalues: (ref) v_u_35, (ref) v_u_60
		if v_u_35:IsOpened() then
			v_u_60()
		end
	end))
	v_u_34:Add(v_u_16.OnUpdateEnabled:Connect(function()
		-- upvalues: (ref) v_u_35, (ref) v_u_60
		if v_u_35:IsOpened() then
			v_u_60()
		end
	end))
end
return v36