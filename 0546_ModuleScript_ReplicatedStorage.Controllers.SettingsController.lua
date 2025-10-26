--[[
  Extracted from: ReplicatedStorage.Controllers.SettingsController
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local u3 = require(v1.Packages.Synchronizer)
local v4 = require(v1.Packages.TopbarPlus)
local v5 = require(v1.Packages.Net)
local u6 = require(v1.Classes.AnimatedButton)
local u7 = require(v1.Controllers.NotificationController)
local u8 = require(v1.Controllers.InterfaceController)
local u9 = require(v1.Controllers.SoundController)
local u10 = require(v1.Shared.Index)
local u11 = require(v1.Datas.Mutations)
local u12 = v5:RemoteFunction("SettingsService/ToggleSetting")
local u13 = v2.LocalPlayer
local v14 = u13.PlayerGui
local u15 = v4.new():setImage(110481567543062, "Selected"):setImage(78403024093069, "Deselected"):setOrder(1)
local u16 = {
	["Music"] = 1,
	["Sound Effects"] = 2,
	["VFX"] = 3,
	["Chat Tips"] = 4,
	["Base Skin"] = 5
}
local u17 = nil
local u18 = v14:WaitForChild("Settings").Settings
local u19 = u18.Content.ScrollingFrame
local u20 = u19.Template
local u21 = u19.TemplateBaseSkin
local u22 = u18.Header.Close
local v23 = {}
local function u27() --[[Anonymous function at line 52]]
    --[[
    Upvalues:
        [1] = u11
    --]]
	local v24 = { "Normal" }
	for v25, v26 in pairs(u11) do
		if not v26.LimitedMutation then
			table.insert(v24, v25)
		end
	end
	return v24
end
local function u49(p28) --[[Anonymous function at line 62]]
    --[[
    Upvalues:
        [1] = u19
        [2] = u21
        [3] = u27
        [4] = u10
        [5] = u13
        [6] = u11
        [7] = u6
        [8] = u12
        [9] = u7
        [10] = u9
        [11] = u16
        [12] = u20
    --]]
	for _, v29 in u19:GetChildren() do
		if v29.Name ~= "Template" and (v29.Name ~= "TemplateBaseSkin" and v29:IsA("Frame")) then
			v29:Destroy()
		end
	end
	for u30, v31 in p28 do
		if u30 == "Base Skin" then
			local v32 = u21:Clone()
			v32.Name = u30
			v32.Function.Text = u30
			for _, v33 in u21.Button.DropDown:GetChildren() do
				if v33 ~= "Template" and v33:IsA("Frame") then
					v33:Destroy()
				end
			end
			for _, u34 in ipairs((u27())) do
				if u34 ~= v31 then
					local v35 = v32.Button.DropDown.Template:Clone()
					v35.Name = u34
					v35.Text.Text = u34
					local v36 = u34 == "Normal" and true or u10:IsComplete(u13, u34)
					v35.Locked.Visible = not v36
					local v37 = u11[u34]
					v35.BackgroundColor3 = u34 ~= "Normal" and v37.MainColor or Color3.new(0.490196, 0.435294, 0.435294)
					v35.UIStroke.Color = u34 ~= "Normal" and v37.Palettes[1][2] or Color3.new(0.490196, 0.435294, 0.435294)
					v35.Text.UIStroke.Color = u34 ~= "Normal" and v37.Palettes[1][2] or Color3.new(0.490196, 0.435294, 0.435294)
					if v36 then
						local v38 = u6.new(v35)
						v38:Animate()
						v38.OnActivated:Connect(function() --[[Anonymous function at line 106]]
                            --[[
                            Upvalues:
                                [1] = u19
                                [2] = u12
                                [3] = u30
                                [4] = u34
                                [5] = u7
                                [6] = u9
                            --]]
							u19.CanvasSize = UDim2.new(0, 0, 0, 0)
							local v39, v40 = u12:InvokeServer(u30, u34)
							if not v39 then
								u7:Error(v40)
								u9:PlaySound("Sounds.Sfx.Error")
							end
						end)
					end
					v35.LayoutOrder = u34 == "Normal" and 1 or (u11[u34].Order or 1)
					v35.Parent = v32.Button.DropDown
					v35.Visible = true
				end
			end
			local u41 = v32.Button
			u41.Text.Text = v31
			local v42 = u11[v31]
			u41.BackgroundColor3 = v31 ~= "Normal" and v42.MainColor or Color3.new(0.490196, 0.435294, 0.435294)
			u41.UIStroke.Color = v31 ~= "Normal" and v42.Palettes[1][1] or Color3.new(0.490196, 0.435294, 0.435294)
			u6.new(u41).OnActivated:Connect(function() --[[Anonymous function at line 130]]
                --[[
                Upvalues:
                    [1] = u41
                    [2] = u19
                --]]
				local v43 = u41.DropDown
				v43.Visible = not v43.Visible
				u41.Polygon.Rotation = v43.Visible and 180 or 0
				u19.CanvasSize = v43.Visible and UDim2.new(0, 0, 1.7, 0) or UDim2.new(0, 0, 0, 0)
				u19.CanvasPosition = v43.Visible and Vector2.new(0, u19.AbsoluteCanvasSize.Y - u19.AbsoluteSize.Y) or Vector2.new(0, 0)
			end)
			v32.LayoutOrder = u16[u30]
			v32.Parent = u19
			v32.Visible = true
		else
			local v44 = u20:Clone()
			v44.Name = u30
			v44.Function.Text = u30
			local v45 = v44.Buttons.Button
			v45.Text.Text = v31 and "On" or "Off"
			v45.BackgroundColor3 = v31 and Color3.new(0.0470588, 0.466667, 0.235294) or Color3.new(0.490196, 0.435294, 0.435294)
			v45.UIStroke.Color = v31 and Color3.new(0.00784314, 0.219608, 0) or Color3.new(0.403922, 0.356863, 0.356863)
			v45.Text.UIStroke.Color = v31 and Color3.new(0.00784314, 0.219608, 0) or Color3.new(0.403922, 0.356863, 0.356863)
			local v46 = u6.new(v45)
			v46:Animate()
			v46.OnActivated:Connect(function() --[[Anonymous function at line 157]]
                --[[
                Upvalues:
                    [1] = u12
                    [2] = u30
                    [3] = u7
                    [4] = u9
                --]]
				local v47, v48 = u12:InvokeServer(u30)
				if not v47 then
					u7:Error(v48)
					u9:PlaySound("Sounds.Sfx.Error")
				end
			end)
			v44.LayoutOrder = u16[u30]
			v44.Parent = u19
			v44.Visible = true
		end
	end
end
function v23.Start(_) --[[Anonymous function at line 171]]
    --[[
    Upvalues:
        [1] = u17
        [2] = u8
        [3] = u18
        [4] = u22
        [5] = u15
        [6] = u3
        [7] = u13
        [8] = u49
    --]]
	u17 = u8:Register("Settings", u18, "TopQuint")
	u17:AttachCloseButton(u22)
	u17:Close()
	u15.selected:Connect(function() --[[Anonymous function at line 178]]
        --[[
        Upvalues:
            [1] = u8
        --]]
		u8:SetState("Settings", true)
	end)
	u15.deselected:Connect(function() --[[Anonymous function at line 182]]
        --[[
        Upvalues:
            [1] = u8
        --]]
		u8:SetState("Settings", false)
	end)
	u17.OnOpen:Connect(function() --[[Anonymous function at line 186]]
        --[[
        Upvalues:
            [1] = u15
        --]]
		u15:select()
	end)
	u17.OnClose:Connect(function() --[[Anonymous function at line 190]]
        --[[
        Upvalues:
            [1] = u15
        --]]
		u15:deselect()
	end)
	u3:WaitAndCall(u13, function(u50) --[[Anonymous function at line 194]]
        --[[
        Upvalues:
            [1] = u49
        --]]
		for v51, _ in u50:Get("Settings") do
			u50:OnChanged(("Settings.%*"):format(v51), function(_) --[[Anonymous function at line 198]]
                --[[
                Upvalues:
                    [1] = u50
                    [2] = u49
                --]]
				local v52 = u50:Get("Settings")
				task.spawn(u49, v52)
			end, true)
		end
	end)
end
return v23