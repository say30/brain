--[[
  Extracted from: ReplicatedStorage.Controllers.YinYangEventController
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- BgOiAQxZaW5ZYW5nRXZlbnQMR2V0QXR0cmlidXRlCUlzRW5hYmxlZAJvcwRkYXRlAyEqdAl3b3Jrc3BhY2UQR2V0U2VydmVyVGltZU5vdwR3ZGF5FEdldEludGVydmFsSW5TZWNvbmRzE0dldEludGVydmFsVG9FbmFibGUUWWluWWFuZ0V2ZW50TGFzdFRpbWUEdGltZQRtYXRoBWNsYW1wFEdldEludGVydmFsVG9EaXNhYmxlBWRlYnVnDHByb2ZpbGViZWdpbiZZaW5ZYW5nRXZlbnRDb250cm9sbGVyOlJlc3VsdEFuaW1hdGlvbghSb3RhdGlvbgRUaWNrCVR3ZWVuSW5mbwNuZXcERW51bQtFYXNpbmdTdHlsZQRTaW5lD0Vhc2luZ0RpcmVjdGlvbgNPdXQGQ3JlYXRlBFBsYXkKcHJvZmlsZWVuZARXYWl0BVdoZWVsCFNwaW5uaW5nDkZpbmRGaXJzdENoaWxkBkxvb3BlZAZWb2x1bWUGcmFuZG9tDlBvc3RTaW11bGF0aW9uB0Nvbm5lY3QFUXVpbnQGTGluZWFyCUNvbXBsZXRlZApEaXNjb25uZWN0BFN0b3AKQWx0UmV3YXJkcwdSZXdhcmRzAARUeXBlCUNhc2gtUGFjawVJbmRleAVWYWx1ZQdSZWJpcnRoA0dldAMkJSoIVG9TdHJpbmcGZm9ybWF0B0Rpc3BsYXkQWW91IHJlY2VpdmVkICUqIQdTdWNjZXNzD1Jlc3VsdEFuaW1hdGlvbgVJdGVtcwVOYW1lcwRPZGRzBEl0ZW0ISXRlbXMuJSoGV2VpZ2h0B1Byb2R1Y3QOR2V0UHJvZHVjdEluZm8ESWNvbgQlKiUlBWZsb29yBUltYWdlBFRleHQFc2V0dXAEdGFzawR3YWl0CUNoZWNrbWFyawdWaXNpYmxlDnVwZGF0ZUZhc3RTcGluCVByb2R1Y3RJZApGaXJlU2VydmVyIFlpbllhbmdTcGluV2hlZWwuTGFzdEZyZWVDbGFpbWVkBE1haW4FVGltZXIIU1BJTiBOT1cPRnJlZSBTcGluIGluICUqAUQWWWluWWFuZ1NwaW5XaGVlbC5TcGlucwVTcGlucwpTcGlucyAoJSopCVNwaW4gKCUqKQpVSUdyYWRpZW50B0VuYWJsZWQiWWluWWFuZ1NwaW5XaGVlbC5MYXN0RGFpbHlEaXNjb3VudAdCdXR0b25zBEJ1eTEMQnV5MURpc2NvdW50HVlpbllhbmdTcGluV2hlZWwuUGFpZFNwaW5zLngzBUJ1eTEwBEJ1eTMIbWFpbkxvb3AFc3Bhd24HRGVzdHJveQxZaW5ZYW5nV2hlZWwIVG9wUXVpbnQIUmVnaXN0ZXIFQ2xvc2URQXR0YWNoQ2xvc2VCdXR0b24UT25EaWN0aW9uYXJ5SW5zZXJ0ZWQIRmFzdFNwaW4GVG9nZ2xlB0FuaW1hdGULT25BY3RpdmF0ZWQLR2V0Q2hpbGRyZW4LSW1hZ2VCdXR0b24DSXNBBE5hbWUEU3BpbglSYnhBbW91bnQMUHJpY2VJblJvYnV4DU9uQ2xpZW50RXZlbnQGU2ltcGxlCm9ic2VydmVUYWcQWWluWWFuZ1NwaW5XaGVlbBFTZXR1cFlpbllhbmdXaGVlbAVTdGFydARnYW1lEVJlcGxpY2F0ZWRTdG9yYWdlCkdldFNlcnZpY2UKUnVuU2VydmljZQdQbGF5ZXJzDFR3ZWVuU2VydmljZQtDb250cm9sbGVycwxXYWl0Rm9yQ2hpbGQHcmVxdWlyZRNJbnRlcmZhY2VDb250cm9sbGVyDlNob3BDb250cm9sbGVyFk5vdGlmaWNhdGlvbkNvbnRyb2xsZXIPU291bmRDb250cm9sbGVyCFBhY2thZ2VzCU9ic2VydmVycwxTeW5jaHJvbml6ZXIFVHJvdmUDTmV0BVV0aWxzCVRpbWVVdGlscwtOdW1iZXJVdGlscwVEYXRhcwRTaG9wB0NsYXNzZXMGc2NyaXB0DkFuaW1hdGVkQnV0dG9uBlNoYXJlZAtNYXJrZXRwbGFjZQtMb2NhbFBsYXllcglQbGF5ZXJHdWkUU2hvcFNlcnZpY2UvUHVyY2hhc2ULUmVtb3RlRXZlbnQYWWluWWFuZ0V2ZW50U2VydmljZS9TcGluHllpbllhbmdFdmVudFNlcnZpY2UvUmVxdWVzdEJ1eQ5SZW1vdGVGdW5jdGlvbgATAwABAAAABvsAAABvAgAAvAAAEgEAAACfAAMAggAAAAIDAQMCADwDARgAAAAAAAA9AAAAAAUAAAAAABOkAQIAAAQAgG8CAwCkAwUAAABAQLwDA7cGAAAAnwMCAJ8BAAJNAAGZBwAAAA0AAwAIAAAADQADAAkAAICM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

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2025-09-27 10:49:07
-- Luau version 6, Types version 3
-- Time taken: 0.015423 seconds

local ReplicatedStorage_upvr = game:GetService("ReplicatedStorage")
local Controllers = ReplicatedStorage_upvr:WaitForChild("Controllers")
local Packages = ReplicatedStorage_upvr:WaitForChild("Packages")
local Synchronizer_upvr = require(Packages.Synchronizer)
local Net = require(Packages.Net)
local Utils = ReplicatedStorage_upvr:WaitForChild("Utils")
local NumberUtils_upvr = require(Utils.NumberUtils)
local Datas = ReplicatedStorage_upvr:WaitForChild("Datas")
local YinYangSpinWheel_upvr_2 = require(Datas.YinYangSpinWheel)
local Shop_upvr = require(Datas.Shop)
local LocalPlayer_upvr = game:GetService("Players").LocalPlayer
local YinYangWheel_upvr = LocalPlayer_upvr.PlayerGui:WaitForChild("YinYangWheel").YinYangWheel
local var13_upvw = false
local var14_upvw = false
local module = {}
local function _() -- Line 60, Named "IsEnabled"
	--[[ Upvalues[1]:
		[1]: ReplicatedStorage_upvr (readonly)
	]]
	return ReplicatedStorage_upvr:GetAttribute("YinYangEvent")
end
local function _() -- Line 64, Named "GetIntervalInSeconds"
	local wday_2 = os.date("!*t", workspace:GetServerTimeNow()).wday
	if wday_2 == 1 or wday_2 == 7 then
		return 3600
	end
	return 10800
end
local function _() -- Line 69, Named "GetIntervalToEnable"
	local workspace_GetServerTimeNow_result1_3 = workspace:GetServerTimeNow()
	local var18
	if workspace_GetServerTimeNow_result1_3 < var18 then
		var18 = 1755961200 - workspace_GetServerTimeNow_result1_3
		return var18
	end
	local wday_3 = os.date("!*t", workspace:GetServerTimeNow()).wday
	if wday_3 == 1 or wday_3 == 7 then
		var18 = 3600
	else
		var18 = 10800
	end
	return var18 - workspace_GetServerTimeNow_result1_3 % var18
end
local function _() -- Line 79, Named "GetIntervalToDisable"
	--[[ Upvalues[1]:
		[1]: ReplicatedStorage_upvr (readonly)
	]]
	if not ReplicatedStorage_upvr:GetAttribute("YinYangEvent") then
		return 0
	end
	return math.clamp((ReplicatedStorage_upvr:GetAttribute("YinYangEventLastTime") or 0) + 900 - os.time(), 0, math.huge)
end
local RunService_upvr = game:GetService("RunService")
local TweenService_upvr = game:GetService("TweenService")
local NotificationController_upvr = require(Controllers.NotificationController)
local function ResultAnimation_upvr(arg1, arg2) -- Line 87, Named "ResultAnimation"
	--[[ Upvalues[11]:
		[1]: Synchronizer_upvr (readonly)
		[2]: LocalPlayer_upvr (readonly)
		[3]: var14_upvw (read and write)
		[4]: YinYangWheel_upvr (readonly)
		[5]: var13_upvw (read and write)
		[6]: RunService_upvr (readonly)
		[7]: TweenService_upvr (readonly)
		[8]: YinYangSpinWheel_upvr_2 (readonly)
		[9]: Shop_upvr (readonly)
		[10]: NumberUtils_upvr (readonly)
		[11]: NotificationController_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local var23
	if var14_upvw then
	else
		var14_upvw = true
		local Wheel_2_upvr = YinYangWheel_upvr.Wheel
		local Spinning = Wheel_2_upvr:FindFirstChild("Spinning")
		if var13_upvw then
			var23 = 1
		else
			var23 = 0.8
		end
		if Spinning then
			Spinning.Looped = true
			Spinning.Volume = var23
			Spinning:Play()
		end
		local var26 = (arg1 - 1) * -60
		local var27 = var26 - (math.random() - 0.5) * 0.7 * 60
		if var13_upvw then
			var26 = 1
		else
			var26 = 9
		end
		if var13_upvw then
			local _ = 0.5
		else
		end
		local var30_upvw
		local any_Create_result1 = TweenService_upvr:Create(Wheel_2_upvr, TweenInfo.new(5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
			Rotation = var27 + var26 * 360;
		})
		if Spinning then
			-- KONSTANTERROR: Expression was reused, decompilation is incorrect
			TweenService_upvr:Create(Spinning, TweenInfo.new(5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
				Volume = 0;
			}):Play()
		end
		any_Create_result1:Play()
		any_Create_result1.Completed:Wait()
		RunService_upvr.PostSimulation:Connect(function() -- Line 112
			--[[ Upvalues[4]:
				[1]: Wheel_2_upvr (readonly)
				[2]: var30_upvw (read and write)
				[3]: YinYangWheel_upvr (copied, readonly)
				[4]: TweenService_upvr (copied, readonly)
			]]
			debug.profilebegin("YinYangEventController:ResultAnimation")
			local var31 = (Wheel_2_upvr.Rotation + 30) / 60 // 1
			if var30_upvw ~= var31 then
				var30_upvw = var31
				YinYangWheel_upvr.Tick.Rotation = -40
				TweenService_upvr:Create(YinYangWheel_upvr.Tick, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
					Rotation = 0;
				}):Play()
			end
			debug.profileend()
		end):Disconnect()
		Wheel_2_upvr.Rotation = var27
		if Spinning then
			Spinning:Stop()
			Spinning.Volume = var23
		end
		if arg2 ~= true or not YinYangSpinWheel_upvr_2.AltRewards[arg1] then
			local var36 = YinYangSpinWheel_upvr_2.Rewards[arg1]
		end
		local var37 = ""
		if var36.Type == "Cash-Pack" then
			if not Shop_upvr then
				return false
			end
			local var38 = Shop_upvr[var36.Index].Value or 0
			local var39 = Synchronizer_upvr:Wait(LocalPlayer_upvr):Get("Rebirth") or 0
			local var40 = 0
			if var40 < var39 then
				if var39 <= 1 then
					var40 = 1.5
				else
					var40 = var39
				end
				var38 *= var40
			end
			var37 = `${NumberUtils_upvr:ToString(var38, 2)}`
		else
			var37 = var36.Display
		end
		NotificationController_upvr:Success(`You received {var37}!`)
		var14_upvw = false
	end
end
local var41_upvw
local InterfaceController_upvr = require(Controllers.InterfaceController)
local Marketplace_upvr = require(ReplicatedStorage_upvr:WaitForChild("Shared").Marketplace)
local AnimatedButton_upvr = require(ReplicatedStorage_upvr:WaitForChild("Classes").AnimatedButton)
local any_RemoteEvent_result1_upvr_2 = Net:RemoteEvent("ShopService/Purchase")
local any_RemoteEvent_result1_upvr = Net:RemoteEvent("YinYangEventService/Spin")
local TimeUtils_upvr = require(Utils.TimeUtils)
local Timer_upvr = require(Packages.Timer)
local Observers_upvr = require(Packages.Observers)
local YinYangSpinWheel_upvr = require(script.YinYangSpinWheel)
function module.SetupYinYangWheel(arg1) -- Line 167
	--[[ Upvalues[20]:
		[1]: var41_upvw (read and write)
		[2]: InterfaceController_upvr (readonly)
		[3]: YinYangWheel_upvr (readonly)
		[4]: Synchronizer_upvr (readonly)
		[5]: LocalPlayer_upvr (readonly)
		[6]: YinYangSpinWheel_upvr_2 (readonly)
		[7]: Shop_upvr (readonly)
		[8]: NumberUtils_upvr (readonly)
		[9]: Marketplace_upvr (readonly)
		[10]: var14_upvw (read and write)
		[11]: AnimatedButton_upvr (readonly)
		[12]: var13_upvw (read and write)
		[13]: any_RemoteEvent_result1_upvr_2 (readonly)
		[14]: any_RemoteEvent_result1_upvr (readonly)
		[15]: ReplicatedStorage_upvr (readonly)
		[16]: TimeUtils_upvr (readonly)
		[17]: ResultAnimation_upvr (readonly)
		[18]: Timer_upvr (readonly)
		[19]: Observers_upvr (readonly)
		[20]: YinYangSpinWheel_upvr (readonly)
	]]
	var41_upvw = InterfaceController_upvr:Register("YinYangWheel", YinYangWheel_upvr, "TopQuint")
	var41_upvw:AttachCloseButton(YinYangWheel_upvr.Close)
	var41_upvw:Close()
	local any_Wait_result1_upvr = Synchronizer_upvr:Wait(LocalPlayer_upvr)
	local function setup_upvr() -- Line 175, Named "setup"
		--[[ Upvalues[6]:
			[1]: YinYangWheel_upvr (copied, readonly)
			[2]: YinYangSpinWheel_upvr_2 (copied, readonly)
			[3]: any_Wait_result1_upvr (readonly)
			[4]: Shop_upvr (copied, readonly)
			[5]: NumberUtils_upvr (copied, readonly)
			[6]: Marketplace_upvr (copied, readonly)
		]]
		-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
		local Wheel = YinYangWheel_upvr.Wheel
		local tbl = {}
		local var72
		for i = 1, var72 do
			local var73 = YinYangSpinWheel_upvr_2.Rewards[i]
			if var73 then
				if var73.Type == "Item" and any_Wait_result1_upvr:Get(`Items.{var73.Index}`) then
					var73 = YinYangSpinWheel_upvr_2.AltRewards[i]
				end
				tbl[i] = var73.Weight
			end
		end
		var72 = 0
		for _, v in tbl do
			var72 += v
		end
		tbl[5] += 100 - var72
		for i_3 = 1, #YinYangSpinWheel_upvr_2.Rewards do
			local var74 = YinYangSpinWheel_upvr_2.Rewards[i_3]
			if var74 then
				if var74.Type == "Item" and any_Wait_result1_upvr:Get(`Items.{var74.Index}`) then
					var74 = YinYangSpinWheel_upvr_2.AltRewards[i_3]
				end
				local var75 = ""
				local var76 = ""
				if var74.Type == "Cash-Pack" then
					local var77 = any_Wait_result1_upvr:Get("Rebirth") or 0
					local var78 = 0
					if var78 < var77 then
						if var77 <= 1 then
							var78 = 1.5
						else
							var78 = var77
						end
					end
					var76 = `${NumberUtils_upvr:ToString(Shop_upvr[var74.Index].Value * var78, 2)}`
					var75 = Marketplace_upvr:GetProductInfo(var74.Index, "Product").Icon
				else
					var75 = var74.Icon
				end
				if var76 ~= "" or not var74.Display then
				end
				Wheel.Items:FindFirstChild(i_3).Image = var75
				Wheel.Names:FindFirstChild(i_3).Text = var76
				Wheel.Odds:FindFirstChild(i_3).Text = `{math.floor(tbl[i_3] * 100) / 100}%`
			end
		end
	end
	setup_upvr()
	any_Wait_result1_upvr:OnDictionaryInserted("Items", function(arg1_2, arg2) -- Line 250
		--[[ Upvalues[3]:
			[1]: YinYangSpinWheel_upvr_2 (copied, readonly)
			[2]: var14_upvw (copied, read and write)
			[3]: setup_upvr (readonly)
		]]
		-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
		local _ = 1
		-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [22] 17. Error Block 5 start (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [22] 17. Error Block 5 end (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [8] 8. Error Block 2 start (CF ANALYSIS FAILED)
		-- KONSTANTERROR: Expression was reused, decompilation is incorrect
		-- KONSTANTERROR: [8] 8. Error Block 2 end (CF ANALYSIS FAILED)
	end)
	local Toggle_upvr = YinYangWheel_upvr.FastSpin.Toggle
	local any_new_result1_3 = AnimatedButton_upvr.new(Toggle_upvr)
	any_new_result1_3:Animate()
	local function _() -- Line 272, Named "updateFastSpin"
		--[[ Upvalues[2]:
			[1]: Toggle_upvr (readonly)
			[2]: var13_upvw (copied, read and write)
		]]
		Toggle_upvr.Checkmark.Visible = var13_upvw
	end
	any_new_result1_3.OnActivated:Connect(function() -- Line 276
		--[[ Upvalues[2]:
			[1]: var13_upvw (copied, read and write)
			[2]: Toggle_upvr (readonly)
		]]
		var13_upvw = not var13_upvw
		Toggle_upvr.Checkmark.Visible = var13_upvw
	end)
	Toggle_upvr.Checkmark.Visible = var13_upvw
	for _, v_2_upvr in YinYangWheel_upvr.Buttons:GetChildren() do
		if v_2_upvr:IsA("ImageButton") and v_2_upvr.Name ~= "Spin" then
			local any_new_result1_4 = AnimatedButton_upvr.new(v_2_upvr)
			any_new_result1_4:Animate()
			any_new_result1_4.OnActivated:Connect(function() -- Line 288
				--[[ Upvalues[2]:
					[1]: any_RemoteEvent_result1_upvr_2 (copied, readonly)
					[2]: v_2_upvr (readonly)
				]]
				any_RemoteEvent_result1_upvr_2:FireServer(v_2_upvr:GetAttribute("ProductId"))
			end)
			v_2_upvr.RbxAmount.Text = Marketplace_upvr:GetProductInfo(v_2_upvr:GetAttribute("ProductId"), "Product").PriceInRobux
		end
	end
	local Spin_upvr = YinYangWheel_upvr.Buttons.Spin
	local any_new_result1 = AnimatedButton_upvr.new(Spin_upvr)
	any_new_result1:Animate()
	any_new_result1.OnActivated:Connect(function() -- Line 299
		--[[ Upvalues[2]:
			[1]: var14_upvw (copied, read and write)
			[2]: any_RemoteEvent_result1_upvr (copied, readonly)
		]]
		if var14_upvw == true then
		else
			any_RemoteEvent_result1_upvr:FireServer()
		end
	end)
	local function mainLoop_upvr() -- Line 305, Named "mainLoop"
		--[[ Upvalues[5]:
			[1]: ReplicatedStorage_upvr (copied, readonly)
			[2]: any_Wait_result1_upvr (readonly)
			[3]: Spin_upvr (readonly)
			[4]: TimeUtils_upvr (copied, readonly)
			[5]: YinYangWheel_upvr (copied, readonly)
		]]
		-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
		local var92 = 0
		local var93
		if ReplicatedStorage_upvr:GetAttribute("YinYangEvent") then
			if any_Wait_result1_upvr:Get("YinYangSpinWheel.LastFreeClaimed") ~= ReplicatedStorage_upvr:GetAttribute("YinYangEventLastTime") then
				var92 += 1
				Spin_upvr.Main.Timer.Text = "SPIN NOW"
			else
				local var94
				local workspace_GetServerTimeNow_result1_2 = workspace:GetServerTimeNow()
				if workspace_GetServerTimeNow_result1_2 < 1755961200 then
					var93 = 1755961200 - workspace_GetServerTimeNow_result1_2
				else
					local wday_4 = os.date("!*t", workspace:GetServerTimeNow()).wday
					if wday_4 == 1 or wday_4 == 7 then
						local _ = 3600
					else
					end
					-- KONSTANTERROR: Expression was reused, decompilation is incorrect
					var93 = 10800 - workspace_GetServerTimeNow_result1_2 % 10800
				end
				Spin_upvr.Main.Timer.Text = `Free Spin in {TimeUtils_upvr:D(var93)}`
			end
		else
			local var98
			local workspace_GetServerTimeNow_result1 = workspace:GetServerTimeNow()
			if workspace_GetServerTimeNow_result1 < 1755961200 then
				var93 = 1755961200 - workspace_GetServerTimeNow_result1
			else
				local wday = os.date("!*t", workspace:GetServerTimeNow()).wday
				if wday == 1 or wday == 7 then
					local _ = 3600
				else
				end
				-- KONSTANTERROR: Expression was reused, decompilation is incorrect
				var93 = 10800 - workspace_GetServerTimeNow_result1 % 10800
			end
			Spin_upvr.Main.Timer.Text = `Free Spin in {TimeUtils_upvr:D(var93)}`
		end
		local var102 = var92 + any_Wait_result1_upvr:Get("YinYangSpinWheel.Spins")
		if 1 >= var102 or not `Spins ({var102})` then
		end
		Spin_upvr.Main.Spins.Text = `Spin ({var102})`
		if var102 > 0 then
		else
		end
		Spin_upvr.Main.UIGradient.Enabled = true
		if 86400 > workspace:GetServerTimeNow() - any_Wait_result1_upvr:Get("YinYangSpinWheel.LastDailyDiscount") then
			-- KONSTANTWARNING: GOTO [179] #130
		end
		local var103 = true
		YinYangWheel_upvr.Buttons.Buy1.Visible = not var103
		YinYangWheel_upvr.Buttons.Buy1Discount.Visible = var103
		if 5 > any_Wait_result1_upvr:Get("YinYangSpinWheel.PaidSpins.x3") then
			local _ = false
			-- KONSTANTWARNING: Skipped task `defvar` above
		else
		end
		YinYangWheel_upvr.Buttons.Buy10.Visible = true
		-- KONSTANTERROR: Expression was reused, decompilation is incorrect
		YinYangWheel_upvr.Buttons.Buy3.Visible = not true
	end
	any_RemoteEvent_result1_upvr.OnClientEvent:Connect(function(arg1_3, arg2) -- Line 341
		--[[ Upvalues[2]:
			[1]: mainLoop_upvr (readonly)
			[2]: ResultAnimation_upvr (copied, readonly)
		]]
		task.spawn(mainLoop_upvr)
		ResultAnimation_upvr(arg1_3, arg2)
	end)
	Timer_upvr.Simple(1, mainLoop_upvr)
	Observers_upvr.observeTag("YinYangSpinWheel", function(arg1_4) -- Line 348
		--[[ Upvalues[1]:
			[1]: YinYangSpinWheel_upvr (copied, readonly)
		]]
		local any_new_result1_2_upvr = YinYangSpinWheel_upvr.new(arg1_4)
		return function() -- Line 350
			--[[ Upvalues[1]:
				[1]: any_new_result1_2_upvr (readonly)
			]]
			any_new_result1_2_upvr:Destroy()
		end
	end)
end
function module.Start(arg1) -- Line 357
	arg1:SetupYinYangWheel()
end
return module