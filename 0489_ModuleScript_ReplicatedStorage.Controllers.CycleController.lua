--[[
  Extracted from: ReplicatedStorage.Controllers.CycleController
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2025-10-18 19:23:08
-- Luau version 6, Types version 3
-- Time taken: 0.008773 seconds

local ReplicatedStorage_upvr = game:GetService("ReplicatedStorage")
local var2_upvw
local var3_upvw
local module_upvr = {
	IsNight = function(arg1) -- Line 23, Named "IsNight"
		local workspace_GetServerTimeNow_result1 = workspace:GetServerTimeNow()
		if 900 > workspace_GetServerTimeNow_result1 % 1800 then
			workspace_GetServerTimeNow_result1 = false
		else
			workspace_GetServerTimeNow_result1 = true
		end
		return workspace_GetServerTimeNow_result1
	end;
	IsDay = function(arg1) -- Line 28, Named "IsDay"
		local workspace_GetServerTimeNow_result1_2 = workspace:GetServerTimeNow()
		if workspace_GetServerTimeNow_result1_2 % 1800 >= 900 then
			workspace_GetServerTimeNow_result1_2 = false
		else
			workspace_GetServerTimeNow_result1_2 = true
		end
		return workspace_GetServerTimeNow_result1_2
	end;
}
local Lighting_upvr = game:GetService("Lighting")
local var8_upvw
local TweenService_upvr = game:GetService("TweenService")
function module_upvr.Update(arg1) -- Line 33
	--[[ Upvalues[6]:
		[1]: var2_upvw (read and write)
		[2]: var3_upvw (read and write)
		[3]: ReplicatedStorage_upvr (readonly)
		[4]: Lighting_upvr (readonly)
		[5]: var8_upvw (read and write)
		[6]: TweenService_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	var2_upvw = os.clock()
	local var16
	if var3_upvw then
		local _1_2 = var3_upvw:Get("Overrides")[1]
		if _1_2 then
			var16 = _1_2.state
		else
			var16 = nil
		end
	end
	if ReplicatedStorage_upvr:GetAttribute("BloodmoonEvent") then
		var16 = 20
	end
	if ReplicatedStorage_upvr:GetAttribute("CandyEvent") then
		var16 = 14
	end
	if ReplicatedStorage_upvr:GetAttribute("GalaxyEvent") or ReplicatedStorage_upvr:GetAttribute("YinYangEvent") or ReplicatedStorage_upvr:GetAttribute("UFOEvent") or ReplicatedStorage_upvr:GetAttribute("StrawberryEvent") or ReplicatedStorage_upvr:GetAttribute("WitchingHourEvent") then
		var16 = 11
	end
	if ReplicatedStorage_upvr:GetAttribute("Effect_Space") or ReplicatedStorage_upvr:GetAttribute("NyanCatsEvent") or ReplicatedStorage_upvr:GetAttribute("4thOfJulyEvent") or ReplicatedStorage_upvr:GetAttribute("10BVisitsEvent") or ReplicatedStorage_upvr:GetAttribute("GlitchEvent") or ReplicatedStorage_upvr:GetAttribute("MoltenEvent") or ReplicatedStorage_upvr:GetAttribute("BombardiroCrocodiloEvent") or ReplicatedStorage_upvr:GetAttribute("Starfall") or ReplicatedStorage_upvr:GetAttribute("LosMatteosEventNightTime") or ReplicatedStorage_upvr:GetAttribute("SammyniSpyderiniEvent") or ReplicatedStorage_upvr:GetAttribute("MeowlEvent") then
		var16 = 0
	end
	if ReplicatedStorage_upvr:GetAttribute("ChicleteiraBicicleteiraEvent") then
		var16 = 6
	end
	if ReplicatedStorage_upvr:GetAttribute("WaterEvent") then
		var16 = 14.5
	end
	if ReplicatedStorage_upvr:GetAttribute("CrabRave") then
		var16 = 14
	end
	if ReplicatedStorage_upvr:GetAttribute("ConcertEvent") or ReplicatedStorage_upvr:GetAttribute("RapConcertEvent") or ReplicatedStorage_upvr:GetAttribute("BrazilEvent") then
		var16 = 0
	end
	if not var16 then
		local var18 = workspace:GetServerTimeNow() % 1800
		if var18 < 900 then
			var16 = 6 + var18 / 900 * 12
		else
			var16 = 18 + (var18 - 900) / 900 * 12
			if 24 <= var16 then
				var16 -= 24
			end
		end
		if ReplicatedStorage_upvr:GetAttribute("ClockTimeOverride") then
			var16 = ReplicatedStorage_upvr:GetAttribute("ClockTimeOverride")
		end
	end
	if 1 < math.abs(var16 - Lighting_upvr.ClockTime) then
		local var19
		if not var16 ~= var8_upvw then
			TweenService_upvr:Create(Lighting_upvr, TweenInfo.new(5), {
				ClockTime = var16;
			}):Play()
			local tbl = {}
			if false then
				var19 = 0.071
			else
				var19 = 0
			end
			tbl.Intensity = var19
			TweenService_upvr:Create(Lighting_upvr.SunRays, TweenInfo.new(1), tbl)
			-- KONSTANTWARNING: GOTO [270] #223
		end
	end
	Lighting_upvr.ClockTime = var16
	-- KONSTANTERROR: Expression was reused, decompilation is incorrect
	if false then
	else
	end
	Lighting_upvr.SunRays.Intensity = 0
	-- KONSTANTERROR: Expression was reused, decompilation is incorrect
	var8_upvw = not var16
end
local Synchronizer_upvr = require(ReplicatedStorage_upvr.Packages.Synchronizer)
function module_upvr.Start(arg1) -- Line 126
	--[[ Upvalues[4]:
		[1]: var2_upvw (read and write)
		[2]: module_upvr (readonly)
		[3]: var3_upvw (read and write)
		[4]: Synchronizer_upvr (readonly)
	]]
	task.spawn(function() -- Line 127
		--[[ Upvalues[2]:
			[1]: var2_upvw (copied, read and write)
			[2]: module_upvr (copied, readonly)
		]]
		while true do
			if not var2_upvw or 5 <= os.clock() - var2_upvw then
				module_upvr:Update()
			end
			task.wait(1)
		end
	end)
	var3_upvw = Synchronizer_upvr:Wait("Cycle")
	var3_upvw:OnArrayInserted("Overrides", function() -- Line 139
		--[[ Upvalues[1]:
			[1]: module_upvr (copied, readonly)
		]]
		module_upvr:Update()
	end)
	var3_upvw:OnArrayRemoved("Overrides", function() -- Line 143
		--[[ Upvalues[1]:
			[1]: module_upvr (copied, readonly)
		]]
		module_upvr:Update()
	end)
end
return module_upvr