--[[
  Extracted from: ReplicatedStorage.Controllers.EffectController.Effects.GrassRecolor
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2025-10-18 19:25:29
-- Luau version 6, Types version 3
-- Time taken: 0.006329 seconds

local ReplicatedStorage_upvr = game:GetService("ReplicatedStorage")
local module = {}
local tbl_upvr = {"WitchingHourEvent", "IndonesiaEvent"}
local tbl_2_upvr = {
	Context = "Default";
	Top = Color3.fromRGB(31, 128, 29);
	Bottom = Color3.fromRGB(31, 128, 29);
	TweenTime = 0;
	Carpet = Color3.fromRGB(196, 40, 28);
}
local var5_upvw = tbl_2_upvr
local any_new_result1_upvr = require(ReplicatedStorage_upvr.Packages.Signal).new()
local function update_upvr() -- Line 44, Named "update"
	--[[ Upvalues[4]:
		[1]: tbl_2_upvr (readonly)
		[2]: ReplicatedStorage_upvr (readonly)
		[3]: var5_upvw (read and write)
		[4]: any_new_result1_upvr (readonly)
	]]
	local var7 = tbl_2_upvr
	if ReplicatedStorage_upvr:GetAttribute("ConcertEvent") then
		var7 = {
			Context = "Concert";
			Top = Color3.fromRGB(157, 155, 151);
			Bottom = Color3.fromRGB(46, 71, 89);
			TweenTime = 2;
		}
	elseif ReplicatedStorage_upvr:GetAttribute("RapConcertEvent") then
		var7 = {
			Context = "RapConcert";
			Top = Color3.fromRGB(157, 155, 151);
			Bottom = Color3.fromRGB(46, 71, 89);
			TweenTime = 2;
		}
	elseif ReplicatedStorage_upvr:GetAttribute("BrazilEvent") then
		var7 = {
			Context = "Brazil";
			Top = Color3.fromRGB(215, 92, 31);
			Bottom = Color3.fromRGB(215, 92, 31);
			TweenTime = 2;
		}
	elseif ReplicatedStorage_upvr:GetAttribute("MexicoEvent") then
		var7 = {
			Context = "MexicoEvent";
			Top = Color3.fromRGB(160, 95, 53);
			Bottom = Color3.fromRGB(175, 126, 67);
			TweenTime = 0;
		}
	elseif ReplicatedStorage_upvr:GetAttribute("IndonesiaEvent") then
		var7 = {
			Context = "IndonesiaEvent";
			Top = Color3.fromRGB(160, 95, 53);
			Bottom = Color3.fromRGB(56, 109, 63);
			TweenTime = 0;
		}
	elseif ReplicatedStorage_upvr:GetAttribute("CrabRave") then
		var7 = {
			Context = "CrabRave";
			Top = Color3.fromRGB(235, 178, 55);
			Bottom = Color3.fromRGB(235, 178, 55);
			TweenTime = 1.95;
		}
	elseif ReplicatedStorage_upvr:GetAttribute("WaterEvent") then
		var7 = {
			Context = "WaterEvent";
			Top = Color3.fromRGB(226, 155, 64);
			Bottom = Color3.fromRGB(226, 155, 64);
			TweenTime = 0;
		}
	elseif ReplicatedStorage_upvr:GetAttribute("StrawberryEvent") then
		var7 = {
			Context = "StrawberryEvent";
			Top = Color3.fromRGB(255, 255, 255);
			Bottom = Color3.fromRGB(255, 255, 255);
			TweenTime = 0;
			MaterialVariant = "Strawberry Stud";
			Carpet = Color3.fromRGB(31, 128, 29);
		}
	elseif ReplicatedStorage_upvr:GetAttribute("MeowlEvent") then
		var7 = {
			Context = "MeowlEvent";
			Top = Color3.fromRGB(69, 97, 44);
			Bottom = Color3.fromRGB(18, 65, 29);
			TweenTime = 0;
		}
	elseif ReplicatedStorage_upvr:GetAttribute("DulDulDulEvent") then
		var7 = {
			Context = "DulDulDulEvent";
			Top = Color3.fromRGB(137, 136, 139);
			Bottom = Color3.fromRGB(87, 127, 41);
			TweenTime = 0;
		}
	elseif ReplicatedStorage_upvr:GetAttribute("ChicleteiraBicicleteiraEvent") then
		var7 = {
			Context = "ChicleteiraBicicleteiraEvent";
			Top = Color3.fromRGB(85, 67, 67);
			Bottom = Color3.fromRGB(31, 128, 29);
			TweenTime = 0;
			Carpet = Color3.fromRGB(61, 53, 57);
		}
	elseif ReplicatedStorage_upvr:GetAttribute("WitchingHourEvent") then
		var7 = {
			Context = "WitchingHourEvent";
			Top = Color3.fromRGB(39, 10, 59);
			Bottom = Color3.fromRGB(39, 10, 59);
			TweenTime = 0;
		}
	elseif ReplicatedStorage_upvr:GetAttribute("YinYangEvent") then
		var7 = {
			Context = "YinYangEvent";
			Top = Color3.fromRGB(204, 204, 204);
			Bottom = Color3.fromRGB(0, 0, 0);
			TweenTime = 0;
		}
	elseif ReplicatedStorage_upvr:GetAttribute("GalaxyEvent") then
		var7 = {
			Context = "GalaxyEvent";
			Top = Color3.fromRGB(42, 99, 255);
			Bottom = Color3.fromRGB(42, 99, 255);
			TweenTime = 2;
		}
	elseif ReplicatedStorage_upvr:GetAttribute("ExtinctEvent") then
		var7 = {
			Context = "ExtinctEvent";
			Top = Color3.fromRGB(108, 83, 58);
			Bottom = Color3.fromRGB(108, 83, 58);
			TweenTime = 0.5;
		}
	elseif ReplicatedStorage_upvr:GetAttribute("MoltenEvent") then
		var7 = {
			Context = "Molten";
			Top = Color3.fromRGB(0, 0, 0);
			Bottom = Color3.fromRGB(0, 0, 0);
			TweenTime = 0.5;
		}
	elseif ReplicatedStorage_upvr:GetAttribute("Snow") then
		var7 = {
			Context = "Snow";
			Top = Color3.fromRGB(190, 190, 190);
			Bottom = Color3.fromRGB(190, 190, 190);
			TweenTime = 8;
		}
	end
	if var5_upvw.Context == var7.Context then
	else
		var5_upvw = var7
		any_new_result1_upvr:Fire()
	end
end
function module.OnStart(arg1) -- Line 178
	--[[ Upvalues[1]:
		[1]: update_upvr (readonly)
	]]
	update_upvr()
end
function module.OnUpdate(arg1) -- Line 182
	--[[ Upvalues[1]:
		[1]: update_upvr (readonly)
	]]
	update_upvr()
end
local Observers_upvr = require(ReplicatedStorage_upvr.Packages.Observers)
local CreateTween_upvr = require(ReplicatedStorage_upvr.Packages.CreateTween)
function module.OnLoad(arg1) -- Line 186
	--[[ Upvalues[7]:
		[1]: Observers_upvr (readonly)
		[2]: var5_upvw (read and write)
		[3]: CreateTween_upvr (readonly)
		[4]: any_new_result1_upvr (readonly)
		[5]: tbl_upvr (readonly)
		[6]: ReplicatedStorage_upvr (readonly)
		[7]: tbl_2_upvr (readonly)
	]]
	Observers_upvr.observeTag("Grass", function(arg1_2) -- Line 187
		--[[ Upvalues[3]:
			[1]: var5_upvw (copied, read and write)
			[2]: CreateTween_upvr (copied, readonly)
			[3]: any_new_result1_upvr (copied, readonly)
		]]
		local var28_upvw
		local function runTween() -- Line 190
			--[[ Upvalues[4]:
				[1]: var28_upvw (read and write)
				[2]: arg1_2 (readonly)
				[3]: var5_upvw (copied, read and write)
				[4]: CreateTween_upvr (copied, readonly)
			]]
			-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
			-- KONSTANTERROR: [0] 1. Error Block 20 start (CF ANALYSIS FAILED)
			local var29
			if var29 then
				var29 = var28_upvw:Cancel
				var29()
			end
			var29 = arg1_2
			var29.MaterialVariant = var5_upvw.MaterialVariant or ""
			if arg1_2:GetAttribute("Bottom") then
				var29 = "Bottom"
			else
				var29 = "Top"
			end
			local tbl = {}
			if type(var5_upvw[var29]) == "table" then
				if not var5_upvw[var29][arg1_2:GetAttribute("Side") or "Left"] and not var5_upvw[var29].Left then
					-- KONSTANTWARNING: GOTO [66] #55
				end
			else
			end
			-- KONSTANTERROR: [0] 1. Error Block 20 end (CF ANALYSIS FAILED)
			-- KONSTANTERROR: [66] 55. Error Block 13 start (CF ANALYSIS FAILED)
			tbl.Color = var5_upvw[var29]
			var28_upvw = CreateTween_upvr(arg1_2, TweenInfo.new(var5_upvw.TweenTime), tbl)
			-- KONSTANTERROR: [66] 55. Error Block 13 end (CF ANALYSIS FAILED)
		end
		task.spawn(runTween)
		local any_Connect_result1_upvr = any_new_result1_upvr:Connect(runTween)
		return function() -- Line 207
			--[[ Upvalues[2]:
				[1]: any_Connect_result1_upvr (readonly)
				[2]: var28_upvw (read and write)
			]]
			any_Connect_result1_upvr:Disconnect()
			var28_upvw:Cancel()
		end
	end, {workspace})
	Observers_upvr.observeTag("Carpet", function(arg1_3) -- Line 213
		--[[ Upvalues[6]:
			[1]: tbl_upvr (copied, readonly)
			[2]: ReplicatedStorage_upvr (copied, readonly)
			[3]: CreateTween_upvr (copied, readonly)
			[4]: var5_upvw (copied, read and write)
			[5]: tbl_2_upvr (copied, readonly)
			[6]: any_new_result1_upvr (copied, readonly)
		]]
		local var39_upvw
		local function runTween() -- Line 216
			--[[ Upvalues[7]:
				[1]: var39_upvw (read and write)
				[2]: tbl_upvr (copied, readonly)
				[3]: ReplicatedStorage_upvr (copied, readonly)
				[4]: arg1_3 (readonly)
				[5]: CreateTween_upvr (copied, readonly)
				[6]: var5_upvw (copied, read and write)
				[7]: tbl_2_upvr (copied, readonly)
			]]
			-- KONSTANTERROR: [0] 1. Error Block 17 start (CF ANALYSIS FAILED)
			if var39_upvw then
				var39_upvw:Cancel()
			end
			-- KONSTANTERROR: [0] 1. Error Block 17 end (CF ANALYSIS FAILED)
			-- KONSTANTERROR: [19] 18. Error Block 6 start (CF ANALYSIS FAILED)
			-- KONSTANTERROR: [19] 18. Error Block 6 end (CF ANALYSIS FAILED)
			-- KONSTANTERROR: [11] 11. Error Block 23 start (CF ANALYSIS FAILED)
			-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [19.6]
			if nil then
				if false then
					-- KONSTANTWARNING: GOTO [26] #24
				end
				-- KONSTANTWARNING: GOTO [25] #23
			end
			-- KONSTANTERROR: [11] 11. Error Block 23 end (CF ANALYSIS FAILED)
		end
		local tbl_upvr_2 = {any_new_result1_upvr:Connect(runTween)}
		for _, v in tbl_upvr do
			table.insert(tbl_upvr_2, ReplicatedStorage_upvr:GetAttributeChangedSignal(v):Connect(runTween))
		end
		task.spawn(runTween)
		return function() -- Line 242
			--[[ Upvalues[2]:
				[1]: tbl_upvr_2 (readonly)
				[2]: var39_upvw (read and write)
			]]
			for _, v_2 in tbl_upvr_2 do
				v_2:Disconnect()
			end
			var39_upvw:Cancel()
		end
	end, {workspace})
end
return module