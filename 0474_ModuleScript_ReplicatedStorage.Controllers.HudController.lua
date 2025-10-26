--[[
  Extracted from: ReplicatedStorage.Controllers.HudController
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local u3 = game:GetService("TweenService")
local v4 = v1:WaitForChild("Controllers")
local u5 = require(v4.InterfaceController)
local u6 = require(v4.CameraController)
local u7 = require(v4.GameController)
local u8 = require(v4.SoundController)
local u9 = require(v4.EventController)
local u10 = require(v1.Utils.TimeUtils)
local u11 = require(v1.Datas.ServerData)
local v12 = v1.Packages
local u13 = require(v12.Synchronizer)
local u14 = require(v12.Timer)
local v15 = v1:WaitForChild("Classes")
local u16 = require(v15.AnimatedButton)
local v17 = v1:WaitForChild("Shared")
local u18 = require(v17.Friends)
local v19 = v1:WaitForChild("Utils")
local u20 = require(v19.NumberUtils)
local u21 = v2.LocalPlayer
local u22 = u21.PlayerGui
local u23 = u22.LeftCenter.LeftCenter
local u24 = u22.LeftBottom.LeftBottom
local u25 = TweenInfo.new(0.5, Enum.EasingStyle.Quint)
local u26 = nil
return {
	["Start"] = function(_) --[[Function name: Start, line 43]]
        --[[
        Upvalues:
            [1] = u3
            [2] = u23
            [3] = u25
            [4] = u26
            [5] = u5
            [6] = u6
            [7] = u7
            [8] = u16
            [9] = u22
            [10] = u13
            [11] = u14
            [12] = u9
            [13] = u10
            [14] = u24
            [15] = u18
            [16] = u21
            [17] = u11
            [18] = u20
            [19] = u8
        --]]
		local u27 = u3:Create(u23, u25, {
			["Position"] = UDim2.fromScale(u23.Position.X.Scale - 1, u23.Position.Y.Scale)
		})
		local u28 = u3:Create(u23, u25, {
			["Position"] = u23.Position
		})
		u26 = u5:Register("Hud", u23, "Custom")
		u26.OnOpen:Connect(function() --[[Anonymous function at line 52]]
            --[[
            Upvalues:
                [1] = u6
                [2] = u28
            --]]
			u6:Blur(0, 0.5)
			u6:Fov(u6:GetDefaultFov(), 0.5)
			u28:Play()
		end)
		u26.OnClose:Connect(function() --[[Anonymous function at line 59]]
            --[[
            Upvalues:
                [1] = u27
            --]]
			u27:Play()
		end)
		u26:Close()
		u7:OnGameLoaded(function() --[[Anonymous function at line 66]]
            --[[
            Upvalues:
                [1] = u26
            --]]
			u26:Toggle(true)
		end)
		for _, u29 in u23.Buttons:GetChildren() do
			if u29:IsA("GuiButton") then
				local v30 = u16.new(u29)
				v30:Animate()
				v30.OnActivated:Connect(function() --[[Anonymous function at line 75]]
                    --[[
                    Upvalues:
                        [1] = u5
                        [2] = u29
                    --]]
					u5:Toggle(u29.Name)
				end)
			end
		end
		local u31 = {}
		for _, v32 in u22:WaitForChild("ActiveEvents").ActiveEvents:GetChildren() do
			if v32:IsA("GuiObject") then
				u31[v32.Name] = v32
			end
		end
		local u33 = {}
		local u34 = u13:Get("ServerLuck")
		task.spawn(function() --[[Anonymous function at line 91]]
            --[[
            Upvalues:
                [1] = u13
                [2] = u34
            --]]
			u13:WaitAndCall("ServerLuck", function(p35) --[[Anonymous function at line 92]]
                --[[
                Upvalues:
                    [1] = u34
                --]]
				u34 = p35
			end)
		end)
		u14.Simple(1, function() --[[Anonymous function at line 97]]
            --[[
            Upvalues:
                [1] = u9
                [2] = u34
                [3] = u31
                [4] = u33
                [5] = u3
                [6] = u10
            --]]
			local v36 = workspace:GetServerTimeNow()
			local v37 = {}
			for _, v38 in u9:GetActiveEvents() do
				v37[v38.eventName] = v38.endsAt - v36
			end
			local v39 = u34:Get("Index") or 0
			if v37["Phase 2: Galaxy Introduction"] then
				v37["Phase 2: Galaxy Introduction"] = v37["Phase 2: Galaxy Introduction"] - 31
			end
			local v40 = v37["6x Server Luck"]
			local v41 = v37["8x Server Luck"]
			if v41 and v41 > 0 then
				v37["8x Server Luck"] = nil
				v37.Luck = v41
				u31.Luck.Main.Image = "rbxassetid://124799036749678"
			elseif v40 and v40 > 0 then
				v37["6x Server Luck"] = nil
				v37.Luck = v40
				u31.Luck.Main.Image = "rbxassetid://94933198053674"
			elseif v39 > 0 then
				v37.Luck = (u34:Get("EndTime") or v36) - v36
				u31.Luck.Main.Image = v39 == 1 and "rbxassetid://92074411396710" or "rbxassetid://90033075589118"
			end
			for _, u42 in u31 do
				local v43 = u42.Name
				local v44 = v37[v43]
				local u45
				if v44 == nil then
					u45 = false
				else
					u45 = v44 > 0
				end
				if u45 ~= u33[v43] then
					local v46
					if u45 then
						v46 = TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
					else
						v46 = TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
					end
					local u47 = u3:Create(u42.Main, v46, {
						["Position"] = UDim2.fromScale(0.5, u45 and 0.5 or 1.5)
					})
					if u45 then
						u42.Visible = true
					end
					u47:Play()
					u47.Completed:Once(function() --[[Anonymous function at line 147]]
                        --[[
                        Upvalues:
                            [1] = u45
                            [2] = u42
                            [3] = u47
                        --]]
						if not u45 then
							u42.Visible = false
						end
						u47:Cancel()
						u47:Destroy()
					end)
					u33[v43] = u45
				end
				local v48 = u42.Main.TextLabel
				local v49
				if v44 then
					local v50 = u10
					local v51 = v44 // 1
					v49 = v50:B((math.max(v51, 0)))
				else
					v49 = u42.Main.TextLabel.Text
				end
				v48.Text = v49
			end
		end)
		u14.Simple(5, function() --[[Anonymous function at line 164]]
            --[[
            Upvalues:
                [1] = u24
                [2] = u18
                [3] = u21
            --]]
			u24.FriendBoost.Text = ("Friend Boost: +%*%%"):format((u18:GetFriendBoostPercentage(u21)))
		end)
		if u11.IsContentCreatorGame() then
			local u52 = u24.CC
			local v53 = UDim2.fromScale(0, -u52.Size.Y.Scale * 0.8)
			u52.Visible = true
			local v54 = u24.FriendBoost
			v54.Position = v54.Position + v53
			local v55 = u24.Currency
			v55.Position = v55.Position + v53
			local v56 = u24.Cashout
			v56.Position = v56.Position + v53
			u52:GetPropertyChangedSignal("Parent"):Once(function() --[[Anonymous function at line 176]]
                --[[
                Upvalues:
                    [1] = u52
                    [2] = u24
                    [3] = u21
                --]]
				if u52.Parent ~= u24 then
					u21:Kick()
				end
			end)
			u52:GetPropertyChangedSignal("Visible"):Once(function() --[[Anonymous function at line 182]]
                --[[
                Upvalues:
                    [1] = u52
                    [2] = u21
                --]]
				if not u52.Visible then
					u21:Kick()
				end
			end)
		end
		u13:WaitAndCall(u21, function(p57) --[[Anonymous function at line 190]]
            --[[
            Upvalues:
                [1] = u24
                [2] = u20
                [3] = u3
                [4] = u8
            --]]
			local u58 = u24.Currency
			local u59 = u24.Cashout
			local u60 = TweenInfo.new(5, Enum.EasingStyle.Linear)
			p57:OnChanged("Coins", function(p61, p62) --[[Anonymous function at line 197]]
                --[[
                Upvalues:
                    [1] = u58
                    [2] = u20
                    [3] = u59
                    [4] = u3
                    [5] = u60
                    [6] = u8
                --]]
				u58.Text = ("$%*"):format((u20:ToString(p61, 2)))
				if p62 then
					local v63 = p61 - p62
					if v63 == 0 then
						return
					end
					local u64 = u59.Template:Clone()
					u64.Text = ("%*$%*"):format(v63 > 0 and "+" or "-", (u20:ToString(math.abs(v63), 2)))
					u64.TextColor3 = v63 < 0 and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(13, 255, 0)
					u64.Visible = true
					u64.Parent = u59
					local v65 = u3:Create(u64, u60, {
						["TextTransparency"] = 1
					})
					local v66 = u3:Create(u64.UIStroke, u60, {
						["Transparency"] = 1
					})
					v65.Completed:Once(function() --[[Anonymous function at line 212]]
                        --[[
                        Upvalues:
                            [1] = u64
                        --]]
						u64:Destroy()
					end)
					v65:Play()
					v66:Play()
					if v63 > 0 then
						u8:PlaySound("Sounds.Sfx.Cashout")
					end
				end
			end, true)
		end)
	end
}