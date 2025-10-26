--[[
  Extracted from: ReplicatedStorage.Controllers.YinYangEventController.YinYangSpinWheel
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- BgNlDFlpbllhbmdFdmVudAxHZXRBdHRyaWJ1dGUJSXNFbmFibGVkAm9zBGRhdGUDISp0CXdvcmtzcGFjZRBHZXRTZXJ2ZXJUaW1lTm93BHdkYXkUR2V0SW50ZXJ2YWxJblNlY29uZHMTR2V0SW50ZXJ2YWxUb0VuYWJsZRRZaW5ZYW5nRXZlbnRMYXN0VGltZQR0aW1lBG1hdGgFY2xhbXAUR2V0SW50ZXJ2YWxUb0Rpc2FibGUETWFpbgxXYWl0Rm9yQ2hpbGQKU3VyZmFjZUd1aQVXaGVlbAVJdGVtcwVOYW1lcwRPZGRzB1Jld2FyZHMEVHlwZQRJdGVtCEl0ZW1zLiUqBUluZGV4BmZvcm1hdANHZXQKQWx0UmV3YXJkcw5GaW5kRmlyc3RDaGlsZAAJQ2FzaC1QYWNrBVZhbHVlB1JlYmlydGgDJCUqCFRvU3RyaW5nB1Byb2R1Y3QOR2V0UHJvZHVjdEluZm8ESWNvbgdEaXNwbGF5BCUqJSUGV2VpZ2h0BUltYWdlBFRleHQFc2V0dXAFZGVidWcMcHJvZmlsZWJlZ2luGVlpbllhbmdTcGluV2hlZWw6Um90YXRlM0QISW5zdGFuY2UGQ0ZyYW1lBkFuZ2xlcwNyYWQKcHJvZmlsZWVuZAxZaW5ZYW5nV2hlZWwGVG9nZ2xlIFlpbllhbmdTcGluV2hlZWwuTGFzdEZyZWVDbGFpbWVkCE92ZXJoZWFkDEJpbGxib2FyZEd1aQlDb3VudGRvd24IU1BJTiBOT1cPRnJlZSBTcGluIGluICUqAUQEV2FpdAxzZXRtZXRhdGFibGUDbmV3CUNvbGxlY3RvchRPbkRpY3Rpb25hcnlJbnNlcnRlZANBZGQNUmVuZGVyU3RlcHBlZAdDb25uZWN0BFJvb3QPUHJveGltaXR5UHJvbXB0CVRyaWdnZXJlZAdEZXN0cm95BFRpY2sIU3RhcnROb3cEZ2FtZRFSZXBsaWNhdGVkU3RvcmFnZQpHZXRTZXJ2aWNlClJ1blNlcnZpY2UHUGxheWVycwVEYXRhcwdyZXF1aXJlEFlpbllhbmdTcGluV2hlZWwEU2hvcAVVdGlscwlUaW1lVXRpbHMLTnVtYmVyVXRpbHMLQ29udHJvbGxlcnMOU2hvcENvbnRyb2xsZXITSW50ZXJmYWNlQ29udHJvbGxlcgZT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

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2025-09-27 10:49:08
-- Luau version 6, Types version 3
-- Time taken: 0.006845 seconds

local ReplicatedStorage_upvr = game:GetService("ReplicatedStorage")
local Datas = ReplicatedStorage_upvr:WaitForChild("Datas")
local Utils = ReplicatedStorage_upvr:WaitForChild("Utils")
local Packages = ReplicatedStorage_upvr:WaitForChild("Packages")
local module_upvr = {}
module_upvr.__index = module_upvr
local function _() -- Line 52, Named "IsEnabled"
	--[[ Upvalues[1]:
		[1]: ReplicatedStorage_upvr (readonly)
	]]
	return ReplicatedStorage_upvr:GetAttribute("YinYangEvent")
end
local function _() -- Line 56, Named "GetIntervalInSeconds"
	local wday_4 = os.date("!*t", workspace:GetServerTimeNow()).wday
	if wday_4 == 1 or wday_4 == 7 then
		return 3600
	end
	return 10800
end
local function _() -- Line 61, Named "GetIntervalToEnable"
	local wday_3 = os.date("!*t", workspace:GetServerTimeNow()).wday
	local var9
	if wday_3 == 1 or wday_3 == 7 then
		var9 = 3600
	else
		var9 = 10800
	end
	return var9 - workspace:GetServerTimeNow() % var9
end
local function _() -- Line 67, Named "GetIntervalToDisable"
	--[[ Upvalues[1]:
		[1]: ReplicatedStorage_upvr (readonly)
	]]
	if not ReplicatedStorage_upvr:GetAttribute("YinYangEvent") then
		return 0
	end
	return math.clamp((ReplicatedStorage_upvr:GetAttribute("YinYangEventLastTime") or 0) + 900 - os.time(), 0, math.huge)
end
local Synchronizer_upvr = require(Packages.Synchronizer)
local LocalPlayer_upvr = game:GetService("Players").LocalPlayer
local Trove_upvr = require(Packages.Trove)
local YinYangSpinWheel_upvr = require(Datas.YinYangSpinWheel)
local Shop_upvr = require(Datas.Shop)
local NumberUtils_upvr = require(Utils.NumberUtils)
local Marketplace_upvr = require(ReplicatedStorage_upvr:WaitForChild("Shared").Marketplace)
local RunService_upvr = game:GetService("RunService")
local InterfaceController_upvr = require(ReplicatedStorage_upvr:WaitForChild("Controllers").InterfaceController)
local Timer_upvr = require(Packages.Timer)
local TimeUtils_upvr = require(Utils.TimeUtils)
function module_upvr.new(arg1) -- Line 77
	--[[ Upvalues[13]:
		[1]: Synchronizer_upvr (readonly)
		[2]: LocalPlayer_upvr (readonly)
		[3]: module_upvr (readonly)
		[4]: Trove_upvr (readonly)
		[5]: YinYangSpinWheel_upvr (readonly)
		[6]: Shop_upvr (readonly)
		[7]: NumberUtils_upvr (readonly)
		[8]: Marketplace_upvr (readonly)
		[9]: RunService_upvr (readonly)
		[10]: InterfaceController_upvr (readonly)
		[11]: Timer_upvr (readonly)
		[12]: ReplicatedStorage_upvr (readonly)
		[13]: TimeUtils_upvr (readonly)
	]]
	local any_Wait_result1_upvr = Synchronizer_upvr:Wait(LocalPlayer_upvr)
	local setmetatable_result1_upvr = setmetatable({}, module_upvr)
	setmetatable_result1_upvr.Instance = arg1
	setmetatable_result1_upvr.Collector = Trove_upvr.new()
	local function setup_upvr() -- Line 86, Named "setup"
		--[[ Upvalues[6]:
			[1]: arg1 (readonly)
			[2]: YinYangSpinWheel_upvr (copied, readonly)
			[3]: any_Wait_result1_upvr (readonly)
			[4]: Shop_upvr (copied, readonly)
			[5]: NumberUtils_upvr (copied, readonly)
			[6]: Marketplace_upvr (copied, readonly)
		]]
		-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
		local Wheel = arg1:WaitForChild("Main"):WaitForChild("SurfaceGui").Wheel
		for i = 1, #YinYangSpinWheel_upvr.Rewards do
			local var28 = YinYangSpinWheel_upvr.Rewards[i]
			if var28 then
				if var28.Type == "Item" and any_Wait_result1_upvr:Get(`Items.{var28.Index}`) then
					var28 = YinYangSpinWheel_upvr.AltRewards[i]
				end
				local var29 = ""
				local var30 = ""
				if var28.Type == "Cash-Pack" then
					local Value = Shop_upvr[var28.Index].Value
					local var32 = any_Wait_result1_upvr:Get("Rebirth") or 0
					local var33 = 0
					if var33 < var32 then
						if var32 <= 1 then
							var33 = 1.5
						else
							var33 = var32
						end
						Value *= var33
					end
					var30 = `${NumberUtils_upvr:ToString(Value, 2)}`
					var29 = Marketplace_upvr:GetProductInfo(var28.Index, "Product").Icon
				else
					var29 = var28.Icon
				end
				if var30 ~= "" or not var28.Display then
				end
				Wheel.Items:FindFirstChild(i).Image = var29 or ""
				Wheel.Names:FindFirstChild(i).Text = var30
				Wheel.Odds:FindFirstChild(i).Text = `{var28.Weight}%`
			end
		end
	end
	setup_upvr()
	setmetatable_result1_upvr.Collector:Add(any_Wait_result1_upvr:OnDictionaryInserted("Items", function(arg1_2, arg2) -- Line 144
		--[[ Upvalues[2]:
			[1]: YinYangSpinWheel_upvr (copied, readonly)
			[2]: setup_upvr (readonly)
		]]
		-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
		local _ = 1
		-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [22] 17. Error Block 5 start (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [22] 17. Error Block 5 end (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [8] 8. Error Block 2 start (CF ANALYSIS FAILED)
		-- KONSTANTERROR: Expression was reused, decompilation is incorrect
		-- KONSTANTERROR: [8] 8. Error Block 2 end (CF ANALYSIS FAILED)
	end))
	setmetatable_result1_upvr.Collector:Add(RunService_upvr.RenderStepped:Connect(function(arg1_3) -- Line 158
		--[[ Upvalues[1]:
			[1]: setmetatable_result1_upvr (readonly)
		]]
		debug.profilebegin("YinYangSpinWheel:Rotate3D")
		local Main = setmetatable_result1_upvr.Instance.Main
		Main.CFrame *= CFrame.Angles(0, 0, math.rad(arg1_3 * 45))
		debug.profileend()
	end))
	setmetatable_result1_upvr.Collector:Add(setmetatable_result1_upvr.Instance.Root.ProximityPrompt.Triggered:Connect(function() -- Line 166
		--[[ Upvalues[1]:
			[1]: InterfaceController_upvr (copied, readonly)
		]]
		InterfaceController_upvr:Toggle("YinYangWheel", true)
	end))
	local any_new_result1 = Timer_upvr.new(1)
	setmetatable_result1_upvr.Collector:Add(any_new_result1, "Destroy")
	setmetatable_result1_upvr.Collector:Add(any_new_result1.Tick:Connect(function() -- Line 172
		--[[ Upvalues[4]:
			[1]: ReplicatedStorage_upvr (copied, readonly)
			[2]: any_Wait_result1_upvr (readonly)
			[3]: setmetatable_result1_upvr (readonly)
			[4]: TimeUtils_upvr (copied, readonly)
		]]
		local var41
		if ReplicatedStorage_upvr:GetAttribute("YinYangEvent") then
			if any_Wait_result1_upvr:Get("YinYangSpinWheel.LastFreeClaimed") ~= ReplicatedStorage_upvr:GetAttribute("YinYangEventLastTime") then
				setmetatable_result1_upvr.Instance.Overhead.BillboardGui.Countdown.Text = "SPIN NOW"
			else
				local wday = os.date("!*t", workspace:GetServerTimeNow()).wday
				if wday == 1 or wday == 7 then
					var41 = 3600
				else
					var41 = 10800
				end
				setmetatable_result1_upvr.Instance.Overhead.BillboardGui.Countdown.Text = `Free Spin in {TimeUtils_upvr:D(var41 - workspace:GetServerTimeNow() % var41)}`
			end
		end
		local wday_2 = os.date("!*t", workspace:GetServerTimeNow()).wday
		if wday_2 == 1 or wday_2 == 7 then
			var41 = 3600
		else
			var41 = 10800
		end
		setmetatable_result1_upvr.Instance.Overhead.BillboardGui.Countdown.Text = `Free Spin in {TimeUtils_upvr:D(var41 - workspace:GetServerTimeNow() % var41)}`
	end))
	any_new_result1:StartNow()
	return setmetatable_result1_upvr
end
function module_upvr.Destroy(arg1) -- Line 190
	arg1.Collector:Destroy()
end
return module_upvr