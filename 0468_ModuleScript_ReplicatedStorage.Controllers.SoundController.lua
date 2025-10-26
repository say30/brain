--[[
  Extracted from: ReplicatedStorage.Controllers.SoundController
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2025-10-18 19:22:39
-- Luau version 6, Types version 3
-- Time taken: 0.010795 seconds

local SoundService_upvr = game:GetService("SoundService")
local ReplicatedStorage_upvr = game:GetService("ReplicatedStorage")
local TweenService_upvr = game:GetService("TweenService")
local Packages = ReplicatedStorage_upvr:WaitForChild("Packages")
local Sounds_upvr = workspace:WaitForChild("Sounds")
local TweenInfo_new_result1_upvr = TweenInfo.new(3, Enum.EasingStyle.Linear)
local module_upvr = {}
local tbl_2_upvr = {}
local StringUtils_upvr = require(ReplicatedStorage_upvr:WaitForChild("Utils").StringUtils)
function module_upvr.PlaySound(arg1, arg2, arg3, arg4) -- Line 31
	--[[ Upvalues[3]:
		[1]: tbl_2_upvr (readonly)
		[2]: StringUtils_upvr (readonly)
		[3]: ReplicatedStorage_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 59 start (CF ANALYSIS FAILED)
	if arg4 == false then
	else
	end
	-- KONSTANTERROR: [0] 1. Error Block 59 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [12] 10. Error Block 6 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [12] 10. Error Block 6 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [19] 16. Error Block 53 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [19] 16. Error Block 53 end (CF ANALYSIS FAILED)
end
local var10_upvw = 1
local CreateTween_upvr = require(ReplicatedStorage_upvr.Packages.CreateTween)
local function updateEventMusicVolume_upvr() -- Line 126, Named "updateEventMusicVolume"
	--[[ Upvalues[4]:
		[1]: ReplicatedStorage_upvr (readonly)
		[2]: var10_upvw (read and write)
		[3]: CreateTween_upvr (readonly)
		[4]: SoundService_upvr (readonly)
	]]
	local var12
	if ReplicatedStorage_upvr:GetAttribute("KarkerkarKurkurEvent") then
		var12 = 0
	else
		var12 = 1
	end
	if var10_upvw == var12 then
	else
		var10_upvw = var12
		CreateTween_upvr(SoundService_upvr.Cutscene.WorkspaceSounds.EventMusic, TweenInfo.new(1), {
			Volume = var12;
		})
	end
end
local CycleController_upvr = require(ReplicatedStorage_upvr:WaitForChild("Controllers").CycleController)
function module_upvr.UpdateOST(arg1) -- Line 141
	--[[ Upvalues[6]:
		[1]: updateEventMusicVolume_upvr (readonly)
		[2]: ReplicatedStorage_upvr (readonly)
		[3]: Sounds_upvr (readonly)
		[4]: CycleController_upvr (readonly)
		[5]: TweenService_upvr (readonly)
		[6]: TweenInfo_new_result1_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 185 start (CF ANALYSIS FAILED)
	updateEventMusicVolume_upvr()
	local var19
	if ReplicatedStorage_upvr:GetAttribute("ConcertEvent") then
		var19 = nil
	elseif ReplicatedStorage_upvr:GetAttribute("RapConcertEvent") then
		var19 = nil
	elseif ReplicatedStorage_upvr:GetAttribute("BrazilEvent") then
		var19 = nil
	elseif ReplicatedStorage_upvr:GetAttribute("MexicoEvent") then
		var19 = nil
	elseif ReplicatedStorage_upvr:GetAttribute("IndonesiaEventPart2") then
		var19 = Sounds_upvr.IndonesiaEventPart2
	elseif ReplicatedStorage_upvr:GetAttribute("IndonesiaEvent") then
		var19 = nil
	elseif ReplicatedStorage_upvr:GetAttribute("KarkerkarKurkurEvent") then
		var19 = nil
	elseif ReplicatedStorage_upvr:GetAttribute("CrabRave") then
		var19 = Sounds_upvr.CrabRave
	elseif ReplicatedStorage_upvr:GetAttribute("RainingTacosEvent") then
		var19 = Sounds_upvr.RainingTacos
	elseif ReplicatedStorage_upvr:GetAttribute("4thOfJulyEvent") then
		var19 = Sounds_upvr["4thOfJuly"]
	elseif ReplicatedStorage_upvr:GetAttribute("10BVisitsEvent") then
		var19 = Sounds_upvr["10B"]
	elseif ReplicatedStorage_upvr:GetAttribute("NyanCatsEvent") then
		var19 = Sounds_upvr.NyanCats
	elseif ReplicatedStorage_upvr:GetAttribute("SammyniSpyderiniEvent") then
		var19 = Sounds_upvr["Sammyni Spyderini"]
	elseif ReplicatedStorage_upvr:GetAttribute("MatteoEvent") or ReplicatedStorage_upvr:GetAttribute("LosMatteosEvent") then
		var19 = Sounds_upvr.Matteo
	elseif ReplicatedStorage_upvr:GetAttribute("UFOEvent") then
		var19 = Sounds_upvr.UFO
	elseif ReplicatedStorage_upvr:GetAttribute("MeowlEvent") then
		var19 = Sounds_upvr.Meowl
	elseif ReplicatedStorage_upvr:GetAttribute("YinYangEvent") then
		var19 = Sounds_upvr.YinYang
	elseif ReplicatedStorage_upvr:GetAttribute("GalaxyEvent") then
		var19 = Sounds_upvr.Galaxy
	elseif ReplicatedStorage_upvr:GetAttribute("MoltenEvent") then
		var19 = Sounds_upvr.Night
	elseif ReplicatedStorage_upvr:GetAttribute("CandyEvent") then
		var19 = Sounds_upvr.Candy
	elseif ReplicatedStorage_upvr:GetAttribute("BloodmoonEvent") then
		var19 = Sounds_upvr.Bloodmoon
	elseif ReplicatedStorage_upvr:GetAttribute("RainbowEvent") then
		var19 = Sounds_upvr.Rainbow
	elseif ReplicatedStorage_upvr:GetAttribute("BombardiroCrocodiloEvent") then
		var19 = Sounds_upvr["Bombardiro Crocodilo"]
	elseif CycleController_upvr:IsNight() or ReplicatedStorage_upvr:GetAttribute("LaVaccaEvent") then
		var19 = Sounds_upvr.Night
	else
		var19 = Sounds_upvr.Day
	end
	local children_2, NONE_4, NONE_2 = Sounds_upvr:GetChildren()
	-- KONSTANTERROR: [0] 1. Error Block 185 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [357] 277. Error Block 96 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [357] 277. Error Block 96 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [250] 205. Error Block 161 start (CF ANALYSIS FAILED)
	-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [357.7]
	if not nil then
		-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [357.6]
		if nil ~= nil then
			-- KONSTANTERROR: Expression was reused, decompilation is incorrect (x7)
			if nil ~= nil and nil ~= nil and nil ~= nil and nil ~= nil and nil ~= nil and nil ~= nil and nil ~= nil then
				-- KONSTANTERROR: Expression was reused, decompilation is incorrect
				if not nil then
				end
				-- KONSTANTERROR: Expression was reused, decompilation is incorrect
				if nil == var19 then
					-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [357.8]
					if not nil then
						-- KONSTANTWARNING: GOTO [357] #277
					end
				else
					-- KONSTANTERROR: Expression was reused, decompilation is incorrect
					if nil then
					end
				end
			end
		end
	end
	-- KONSTANTERROR: [250] 205. Error Block 161 end (CF ANALYSIS FAILED)
end
function module_upvr.UpdateAmbience(arg1) -- Line 282
	--[[ Upvalues[4]:
		[1]: Sounds_upvr (readonly)
		[2]: ReplicatedStorage_upvr (readonly)
		[3]: TweenService_upvr (readonly)
		[4]: TweenInfo_new_result1_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 61 start (CF ANALYSIS FAILED)
	local tbl = {
		Rain = Sounds_upvr:FindFirstChild("Ambience_Rain");
		Snow = Sounds_upvr:FindFirstChild("Ambience_Snow");
		Starfall = Sounds_upvr:FindFirstChild("Ambience_Starfall");
		Water = Sounds_upvr:FindFirstChild("Ambience_Water");
		Strawberry = Sounds_upvr:FindFirstChild("Ambience_Strawberry");
		Extinct = Sounds_upvr:FindFirstChild("Ambience_Extinct");
		["Witching Hour"] = Sounds_upvr:FindFirstChild("Ambience_Witching Hour");
		Indonesia = Sounds_upvr:FindFirstChild("Ambience_IndonesiaEvent");
	}
	local var24
	if ReplicatedStorage_upvr:GetAttribute("Starfall") then
		var24 = tbl.Starfall
	elseif ReplicatedStorage_upvr:GetAttribute("Rain") or ReplicatedStorage_upvr:GetAttribute("LosMatteosEvent") then
		var24 = tbl.Rain
	elseif ReplicatedStorage_upvr:GetAttribute("WaterEvent") then
		var24 = tbl.Water
	elseif ReplicatedStorage_upvr:GetAttribute("Snow") then
		var24 = tbl.Snow
	elseif ReplicatedStorage_upvr:GetAttribute("StrawberryEvent") then
		var24 = tbl.Strawberry
	elseif ReplicatedStorage_upvr:GetAttribute("ExtinctEvent") then
		var24 = tbl.Extinct
	elseif ReplicatedStorage_upvr:GetAttribute("WitchingHourEvent") then
		var24 = tbl["Witching Hour"]
	elseif ReplicatedStorage_upvr:GetAttribute("IndonesiaEventAmbience") then
		var24 = tbl.Indonesia
	end
	local pairs_result1, pairs_result2, pairs_result3 = pairs(tbl)
	local var28
	-- KONSTANTERROR: [0] 1. Error Block 61 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [202] 151. Error Block 36 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [202] 151. Error Block 36 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [141] 107. Error Block 54 start (CF ANALYSIS FAILED)
	-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [202.7]
	if nil then
		if not var28 then
		end
		-- KONSTANTERROR: Expression was reused, decompilation is incorrect
		if nil == var24 then
			-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [202.9]
			if not nil then
				-- KONSTANTWARNING: GOTO [202] #151
			end
		else
			-- KONSTANTERROR: Expression was reused, decompilation is incorrect
			if nil then
			end
		end
	end
	-- KONSTANTERROR: [141] 107. Error Block 54 end (CF ANALYSIS FAILED)
end
local any_RemoteEvent_result1_upvr = require(Packages.Net):RemoteEvent("SoundService/PlayClientSound")
local Synchronizer_upvr = require(Packages.Synchronizer)
local LocalPlayer_upvr = game:GetService("Players").LocalPlayer
function module_upvr.Start(arg1) -- Line 343
	--[[ Upvalues[5]:
		[1]: any_RemoteEvent_result1_upvr (readonly)
		[2]: module_upvr (readonly)
		[3]: Synchronizer_upvr (readonly)
		[4]: LocalPlayer_upvr (readonly)
		[5]: SoundService_upvr (readonly)
	]]
	any_RemoteEvent_result1_upvr.OnClientEvent:Connect(function(...) -- Line 344
		--[[ Upvalues[1]:
			[1]: module_upvr (copied, readonly)
		]]
		module_upvr:PlaySound(...)
	end)
	task.spawn(function() -- Line 348
		--[[ Upvalues[1]:
			[1]: module_upvr (copied, readonly)
		]]
		while task.wait(4) do
			module_upvr:UpdateOST()
			module_upvr:UpdateAmbience()
		end
	end)
	Synchronizer_upvr:WaitAndCall(LocalPlayer_upvr, function(arg1_2) -- Line 355
		--[[ Upvalues[1]:
			[1]: SoundService_upvr (copied, readonly)
		]]
		arg1_2:OnChanged("Settings.Music", function(arg1_3) -- Line 356
			--[[ Upvalues[1]:
				[1]: SoundService_upvr (copied, readonly)
			]]
			local var36
			if arg1_3 then
				var36 = 1
			else
				var36 = 0
			end
			SoundService_upvr:WaitForChild("Cutscene"):WaitForChild("WorkspaceSounds").Volume = var36
		end, true)
		arg1_2:OnChanged("Settings.Sound Effects", function(arg1_4) -- Line 360
			--[[ Upvalues[1]:
				[1]: SoundService_upvr (copied, readonly)
			]]
			local var38
			if arg1_4 then
				var38 = 1
			else
				var38 = 0
			end
			SoundService_upvr:WaitForChild("Sound Effects").Volume = var38
		end, true)
		arg1_2:OnChanged("Settings.Sound Effects", function(arg1_5) -- Line 364
			--[[ Upvalues[1]:
				[1]: SoundService_upvr (copied, readonly)
			]]
			local var40
			if arg1_5 then
				var40 = 1
			else
				var40 = 0
			end
			SoundService_upvr:WaitForChild("ToolsSounds").Volume = var40
		end, true)
	end)
end
return module_upvr