--[[
  Extracted from: ReplicatedStorage.Controllers.EffectController.Effects.WallRecolor
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2025-10-18 19:25:31
-- Luau version 6, Types version 3
-- Time taken: 0.003644 seconds

local ReplicatedStorage_upvr = game:GetService("ReplicatedStorage")
local module = {}
local tbl_upvr = {
	Context = "Default";
	Color = Color3.fromRGB(106, 57, 9);
}
local var4_upvw = tbl_upvr
local any_new_result1_upvr = require(ReplicatedStorage_upvr.Packages.Signal).new()
local function update_upvr() -- Line 29, Named "update"
	--[[ Upvalues[4]:
		[1]: tbl_upvr (readonly)
		[2]: ReplicatedStorage_upvr (readonly)
		[3]: var4_upvw (read and write)
		[4]: any_new_result1_upvr (readonly)
	]]
	local var6 = tbl_upvr
	if ReplicatedStorage_upvr:GetAttribute("ConcertEvent") then
		var6 = {
			Context = "Concert";
			Color = Color3.fromRGB(46, 71, 89);
		}
	elseif ReplicatedStorage_upvr:GetAttribute("RapConcertEvent") then
		var6 = {
			Context = "RapConcert";
			Color = Color3.fromRGB(46, 71, 89);
		}
	elseif ReplicatedStorage_upvr:GetAttribute("MexicoEvent") then
		var6 = {
			Context = "MexicoEvent";
			Color = Color3.fromRGB(180, 91, 68);
		}
	elseif ReplicatedStorage_upvr:GetAttribute("IndonesiaEvent") then
		var6 = {
			Context = "IndonesiaEvent";
			Color = Color3.fromRGB(113, 61, 31);
		}
	elseif ReplicatedStorage_upvr:GetAttribute("DulDulDulEvent") then
		var6 = {
			Context = "DulDulDulEvent";
			Color = Color3.fromRGB(84, 81, 83);
		}
	elseif ReplicatedStorage_upvr:GetAttribute("ChicleteiraBicicleteiraEvent") then
		var6 = {
			Context = "ChicleteiraBicicleteiraEvent";
			Color = Color3.fromRGB(116, 85, 85);
		}
	elseif ReplicatedStorage_upvr:GetAttribute("MeowlEvent") then
		var6 = {
			Context = "MeowlEvent";
			Color = Color3.fromRGB(125, 93, 58);
		}
	elseif ReplicatedStorage_upvr:GetAttribute("WitchingHourEvent") then
		var6 = {
			Context = "WitchingHourEvent";
			Color = Color3.fromRGB(68, 42, 77);
			TweenTime = 0;
		}
	elseif ReplicatedStorage_upvr:GetAttribute("YinYangEvent") then
		var6 = {
			Context = "YinYangEvent";
			Color = Color3.fromRGB(0, 0, 0);
			TweenTime = 0;
		}
	elseif ReplicatedStorage_upvr:GetAttribute("GalaxyEvent") then
		var6 = {
			Context = "GalaxyEvent";
			Color = Color3.fromRGB(20, 57, 67);
		}
	end
	if var4_upvw.Context == var6.Context then
	else
		var4_upvw = var6
		any_new_result1_upvr:Fire()
	end
end
function module.OnStart(arg1) -- Line 93
	--[[ Upvalues[1]:
		[1]: update_upvr (readonly)
	]]
	update_upvr()
end
function module.OnUpdate(arg1) -- Line 97
	--[[ Upvalues[1]:
		[1]: update_upvr (readonly)
	]]
	update_upvr()
end
local Observers_upvr = require(ReplicatedStorage_upvr.Packages.Observers)
local CreateTween_upvr = require(ReplicatedStorage_upvr.Packages.CreateTween)
function module.OnLoad(arg1) -- Line 101
	--[[ Upvalues[4]:
		[1]: Observers_upvr (readonly)
		[2]: CreateTween_upvr (readonly)
		[3]: var4_upvw (read and write)
		[4]: any_new_result1_upvr (readonly)
	]]
	Observers_upvr.observeTag("Wall", function(arg1_2) -- Line 102
		--[[ Upvalues[3]:
			[1]: CreateTween_upvr (copied, readonly)
			[2]: var4_upvw (copied, read and write)
			[3]: any_new_result1_upvr (copied, readonly)
		]]
		local var20_upvw
		local function runTween() -- Line 105
			--[[ Upvalues[4]:
				[1]: var20_upvw (read and write)
				[2]: CreateTween_upvr (copied, readonly)
				[3]: arg1_2 (readonly)
				[4]: var4_upvw (copied, read and write)
			]]
			-- KONSTANTERROR: [0] 1. Error Block 15 start (CF ANALYSIS FAILED)
			local var23
			if var20_upvw then
				var20_upvw:Cancel()
			end
			local tbl_2 = {}
			if type(var4_upvw.Color) == "table" then
				var23 = var4_upvw.Color[arg1_2:GetAttribute("Side") or "Left"]
				if not var23 then
					var23 = var4_upvw.Color.Left
					if not var23 then
						var23 = select(2, next(var4_upvw))
						-- KONSTANTWARNING: GOTO [51] #40
					end
					-- KONSTANTWARNING: GOTO [51] #40
				end
			else
				var23 = var4_upvw.Color
			end
			-- KONSTANTERROR: [0] 1. Error Block 15 end (CF ANALYSIS FAILED)
			-- KONSTANTERROR: [51] 40. Error Block 9 start (CF ANALYSIS FAILED)
			tbl_2.Color = var23
			var20_upvw = CreateTween_upvr(arg1_2, TweenInfo.new(2), tbl_2)
			-- KONSTANTERROR: [51] 40. Error Block 9 end (CF ANALYSIS FAILED)
		end
		task.spawn(runTween)
		local any_Connect_result1_upvr = any_new_result1_upvr:Connect(runTween)
		return function() -- Line 118
			--[[ Upvalues[2]:
				[1]: any_Connect_result1_upvr (readonly)
				[2]: var20_upvw (read and write)
			]]
			any_Connect_result1_upvr:Disconnect()
			var20_upvw:Cancel()
		end
	end, {workspace})
end
return module