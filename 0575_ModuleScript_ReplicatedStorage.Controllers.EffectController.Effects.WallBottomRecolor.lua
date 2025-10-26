--[[
  Extracted from: ReplicatedStorage.Controllers.EffectController.Effects.WallBottomRecolor
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2025-10-18 19:25:32
-- Luau version 6, Types version 3
-- Time taken: 0.003489 seconds

local ReplicatedStorage_upvr = game:GetService("ReplicatedStorage")
local module = {}
local tbl_3_upvr = {
	Context = "Default";
	Color = Color3.fromRGB(99, 95, 98);
}
local var4_upvw = tbl_3_upvr
local any_new_result1_upvr = require(ReplicatedStorage_upvr.Packages.Signal).new()
local function update_upvr() -- Line 29, Named "update"
	--[[ Upvalues[4]:
		[1]: tbl_3_upvr (readonly)
		[2]: ReplicatedStorage_upvr (readonly)
		[3]: var4_upvw (read and write)
		[4]: any_new_result1_upvr (readonly)
	]]
	local var6 = tbl_3_upvr
	if ReplicatedStorage_upvr:GetAttribute("ConcertEvent") then
		var6 = {
			Context = "Concert";
			Color = Color3.fromRGB(17, 17, 17);
		}
	elseif ReplicatedStorage_upvr:GetAttribute("RapConcertEvent") then
		var6 = {
			Context = "RapConcert";
			Color = Color3.fromRGB(17, 17, 17);
		}
	elseif ReplicatedStorage_upvr:GetAttribute("DulDulDulEvent") then
		var6 = {
			Context = "DulDulDulEvent";
			Color = Color3.fromRGB(129, 124, 128);
		}
	elseif ReplicatedStorage_upvr:GetAttribute("MexicoEvent") then
		var6 = {
			Context = "MexicoEvent";
			Color = Color3.fromRGB(138, 81, 45);
		}
	elseif ReplicatedStorage_upvr:GetAttribute("IndonesiaEvent") then
		var6 = {
			Context = "IndonesiaEvent";
			Color = Color3.fromRGB(95, 44, 0);
		}
	elseif ReplicatedStorage_upvr:GetAttribute("MeowlEvent") then
		var6 = {
			Context = "MeowlEvent";
			Color = Color3.fromRGB(111, 71, 30);
		}
	elseif ReplicatedStorage_upvr:GetAttribute("WitchingHourEvent") then
		var6 = {
			Context = "WitchingHourEvent";
			Color = Color3.fromRGB(99, 95, 98);
			TweenTime = 0;
		}
	elseif ReplicatedStorage_upvr:GetAttribute("YinYangEvent") then
		var6 = {
			Context = "YinYangEvent";
			Color = Color3.fromRGB(204, 204, 204);
			TweenTime = 0;
		}
	end
	if var4_upvw.Context == var6.Context then
	else
		var4_upvw = var6
		any_new_result1_upvr:Fire()
	end
end
function module.OnStart(arg1) -- Line 83
	--[[ Upvalues[1]:
		[1]: update_upvr (readonly)
	]]
	update_upvr()
end
function module.OnUpdate(arg1) -- Line 87
	--[[ Upvalues[1]:
		[1]: update_upvr (readonly)
	]]
	update_upvr()
end
local Observers_upvr = require(ReplicatedStorage_upvr.Packages.Observers)
local CreateTween_upvr = require(ReplicatedStorage_upvr.Packages.CreateTween)
function module.OnLoad(arg1) -- Line 91
	--[[ Upvalues[4]:
		[1]: Observers_upvr (readonly)
		[2]: CreateTween_upvr (readonly)
		[3]: var4_upvw (read and write)
		[4]: any_new_result1_upvr (readonly)
	]]
	Observers_upvr.observeTag("WallBottom", function(arg1_2) -- Line 92
		--[[ Upvalues[3]:
			[1]: CreateTween_upvr (copied, readonly)
			[2]: var4_upvw (copied, read and write)
			[3]: any_new_result1_upvr (copied, readonly)
		]]
		local var18_upvw
		local function runTween() -- Line 95
			--[[ Upvalues[4]:
				[1]: var18_upvw (read and write)
				[2]: CreateTween_upvr (copied, readonly)
				[3]: arg1_2 (readonly)
				[4]: var4_upvw (copied, read and write)
			]]
			-- KONSTANTERROR: [0] 1. Error Block 15 start (CF ANALYSIS FAILED)
			local var21
			if var18_upvw then
				var18_upvw:Cancel()
			end
			local tbl = {}
			if type(var4_upvw.Color) == "table" then
				var21 = var4_upvw.Color[arg1_2:GetAttribute("Side") or "Left"]
				if not var21 then
					var21 = var4_upvw.Color.Left
					if not var21 then
						var21 = select(2, next(var4_upvw))
						-- KONSTANTWARNING: GOTO [51] #40
					end
					-- KONSTANTWARNING: GOTO [51] #40
				end
			else
				var21 = var4_upvw.Color
			end
			-- KONSTANTERROR: [0] 1. Error Block 15 end (CF ANALYSIS FAILED)
			-- KONSTANTERROR: [51] 40. Error Block 9 start (CF ANALYSIS FAILED)
			tbl.Color = var21
			var18_upvw = CreateTween_upvr(arg1_2, TweenInfo.new(2), tbl)
			-- KONSTANTERROR: [51] 40. Error Block 9 end (CF ANALYSIS FAILED)
		end
		task.spawn(runTween)
		local any_Connect_result1_upvr = any_new_result1_upvr:Connect(runTween)
		return function() -- Line 108
			--[[ Upvalues[2]:
				[1]: any_Connect_result1_upvr (readonly)
				[2]: var18_upvw (read and write)
			]]
			any_Connect_result1_upvr:Disconnect()
			var18_upvw:Cancel()
		end
	end, {workspace})
end
return module