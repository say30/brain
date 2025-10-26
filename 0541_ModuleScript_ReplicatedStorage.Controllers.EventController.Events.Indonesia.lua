--[[
  Extracted from: ReplicatedStorage.Controllers.EventController.Events.Indonesia
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2025-10-18 19:25:22
-- Luau version 6, Types version 3
-- Time taken: 0.006602 seconds

local ReplicatedStorage_upvr = game:GetService("ReplicatedStorage")
local module = {}
local EncryptedAssetsController_upvr = require(ReplicatedStorage_upvr.Controllers.EncryptedAssetsController)
local SoundController_upvr = require(ReplicatedStorage_upvr.Controllers.SoundController)
local Observers_upvr = require(ReplicatedStorage_upvr.Packages.Observers)
local Trove_upvr = require(ReplicatedStorage_upvr.Packages.Trove)
local VFX_upvr = require(ReplicatedStorage_upvr.Shared.VFX)
local IndonesiaEvent_upvr = workspace.Sounds.IndonesiaEvent
local Name_upvr = script.Name
local any_new_result1_upvr = Trove_upvr.new()
local function _(arg1, arg2, arg3) -- Line 47, Named "loadAnimation"
	--[[ Upvalues[1]:
		[1]: any_new_result1_upvr (readonly)
	]]
	local any_LoadAnimation_result1_upvr = arg1:LoadAnimation(arg2)
	local var12 = arg3
	if not var12 then
		var12 = any_new_result1_upvr
	end
	var12:Add(function() -- Line 49
		--[[ Upvalues[1]:
			[1]: any_LoadAnimation_result1_upvr (readonly)
		]]
		any_LoadAnimation_result1_upvr:Stop(0)
		any_LoadAnimation_result1_upvr:Destroy()
	end)
	return any_LoadAnimation_result1_upvr
end
local EventController_upvr = require(ReplicatedStorage_upvr.Controllers.EventController)
local EffectController_upvr = require(ReplicatedStorage_upvr.Controllers.EffectController)
local CycleController_upvr = require(ReplicatedStorage_upvr.Controllers.CycleController)
local TweenPivot_upvr = require(ReplicatedStorage_upvr.Shared.TweenPivot)
local CreateTween_upvr = require(ReplicatedStorage_upvr.Packages.CreateTween)
function module.OnStart(arg1) -- Line 57
	--[[ Upvalues[13]:
		[1]: EventController_upvr (readonly)
		[2]: Name_upvr (readonly)
		[3]: any_new_result1_upvr (readonly)
		[4]: EffectController_upvr (readonly)
		[5]: CycleController_upvr (readonly)
		[6]: SoundController_upvr (readonly)
		[7]: Observers_upvr (readonly)
		[8]: VFX_upvr (readonly)
		[9]: ReplicatedStorage_upvr (readonly)
		[10]: TweenPivot_upvr (readonly)
		[11]: IndonesiaEvent_upvr (readonly)
		[12]: CreateTween_upvr (readonly)
		[13]: EncryptedAssetsController_upvr (readonly)
	]]
	local any_GetActiveEventData_result1_upvr = EventController_upvr:GetActiveEventData(Name_upvr)
	assert(any_GetActiveEventData_result1_upvr)
	local function _(arg1_2) -- Line 61, Named "calculateTimeLeft"
		--[[ Upvalues[1]:
			[1]: any_GetActiveEventData_result1_upvr (readonly)
		]]
		return math.max(any_GetActiveEventData_result1_upvr.startedAt + arg1_2 - workspace:GetServerTimeNow(), 0)
	end
	any_new_result1_upvr:Add(function() -- Line 65
		--[[ Upvalues[3]:
			[1]: EffectController_upvr (copied, readonly)
			[2]: CycleController_upvr (copied, readonly)
			[3]: SoundController_upvr (copied, readonly)
		]]
		EffectController_upvr:Activate("Blink")
		CycleController_upvr:Update()
		SoundController_upvr:UpdateOST()
	end)
	local clone_2_upvr = any_new_result1_upvr:Clone(script.Map)
	clone_2_upvr.Parent = workspace
	any_new_result1_upvr:Add(Observers_upvr.observeTag("HideInIndonesia", function(arg1_3) -- Line 73
		arg1_3.Parent = script
		local Parent_upvr = arg1_3.Parent
		return function() -- Line 76
			--[[ Upvalues[2]:
				[1]: arg1_3 (readonly)
				[2]: Parent_upvr (readonly)
			]]
			pcall(function() -- Line 77
				--[[ Upvalues[2]:
					[1]: arg1_3 (copied, readonly)
					[2]: Parent_upvr (copied, readonly)
				]]
				arg1_3.Parent = Parent_upvr
			end)
		end
	end, {workspace, script}))
	any_new_result1_upvr:Add(Observers_upvr.observeTag("HideInIndonesiaTransparency", function(arg1_4) -- Line 83
		arg1_4.Transparency = 1
		return function() -- Line 85
			--[[ Upvalues[1]:
				[1]: arg1_4 (readonly)
			]]
			arg1_4.Transparency = 0
		end
	end, {workspace}))
	EffectController_upvr:Activate("Blink")
	CycleController_upvr:Update()
	SoundController_upvr:UpdateOST()
	EffectController_upvr:Run("IndonesiaEvent", "GrassRecolor")
	EffectController_upvr:Run("IndonesiaEvent", "WallRecolor")
	EffectController_upvr:Run("IndonesiaEvent", "WallBottomRecolor")
	any_new_result1_upvr:Add(function() -- Line 97
		--[[ Upvalues[1]:
			[1]: EffectController_upvr (copied, readonly)
		]]
		EffectController_upvr:Stop("IndonesiaEvent", "GrassRecolor")
		EffectController_upvr:Stop("IndonesiaEvent", "WallRecolor")
		EffectController_upvr:Stop("IndonesiaEvent", "WallBottomRecolor")
	end)
	VFX_upvr.enable(clone_2_upvr.MapVFX.Waterfall)
	local var31_upvr = any_GetActiveEventData_result1_upvr.startedAt + 13 - workspace:GetServerTimeNow()
	task.spawn(function() -- Line 111
		--[[ Upvalues[4]:
			[1]: var31_upvr (readonly)
			[2]: SoundController_upvr (copied, readonly)
			[3]: ReplicatedStorage_upvr (copied, readonly)
			[4]: clone_2_upvr (readonly)
		]]
		if 10 < var31_upvr then
			SoundController_upvr:PlaySound(ReplicatedStorage_upvr.Sounds.Events.Indonesia.Activating, clone_2_upvr.MapVFX.Waterfall.indonesiawaterfall.Position, false)
		end
	end)
	local any_GetPivot_result1 = clone_2_upvr.Flood:GetPivot()
	clone_2_upvr.Flood:PivotTo(any_GetPivot_result1 - Vector3.new(0, 3, 0))
	any_new_result1_upvr:Add(TweenPivot_upvr(clone_2_upvr.Flood, TweenInfo.new(var31_upvr, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), any_GetPivot_result1)):Play()
	any_new_result1_upvr:Add(task.delay(any_GetActiveEventData_result1_upvr.startedAt + 87.78999999999999 - workspace:GetServerTimeNow(), function() -- Line 121
		--[[ Upvalues[4]:
			[1]: ReplicatedStorage_upvr (copied, readonly)
			[2]: CycleController_upvr (copied, readonly)
			[3]: SoundController_upvr (copied, readonly)
			[4]: any_new_result1_upvr (copied, readonly)
		]]
		ReplicatedStorage_upvr:SetAttribute("IndonesiaEventPart2", true)
		CycleController_upvr:Update()
		SoundController_upvr:UpdateOST()
		any_new_result1_upvr:Add(function() -- Line 125
			--[[ Upvalues[3]:
				[1]: ReplicatedStorage_upvr (copied, readonly)
				[2]: CycleController_upvr (copied, readonly)
				[3]: SoundController_upvr (copied, readonly)
			]]
			ReplicatedStorage_upvr:SetAttribute("IndonesiaEventPart2", nil)
			CycleController_upvr:Update()
			SoundController_upvr:UpdateOST()
		end)
	end))
	any_new_result1_upvr:Add(task.delay(var31_upvr, function() -- Line 132
		--[[ Upvalues[4]:
			[1]: VFX_upvr (copied, readonly)
			[2]: clone_2_upvr (readonly)
			[3]: ReplicatedStorage_upvr (copied, readonly)
			[4]: any_new_result1_upvr (copied, readonly)
		]]
		VFX_upvr.disable(clone_2_upvr.MapVFX.Waterfall)
		ReplicatedStorage_upvr:SetAttribute("IndonesiaEventAmbience", true)
		any_new_result1_upvr:Add(function() -- Line 136
			--[[ Upvalues[1]:
				[1]: ReplicatedStorage_upvr (copied, readonly)
			]]
			ReplicatedStorage_upvr:SetAttribute("IndonesiaEventAmbience", nil)
		end)
	end))
	any_new_result1_upvr:Add(task.spawn(function() -- Line 141
		--[[ Upvalues[5]:
			[1]: IndonesiaEvent_upvr (copied, readonly)
			[2]: CreateTween_upvr (copied, readonly)
			[3]: EncryptedAssetsController_upvr (copied, readonly)
			[4]: any_GetActiveEventData_result1_upvr (readonly)
			[5]: any_new_result1_upvr (copied, readonly)
		]]
		IndonesiaEvent_upvr.Volume = 0
		CreateTween_upvr(IndonesiaEvent_upvr, TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
			Volume = 0.35;
		})
		EncryptedAssetsController_upvr:WaitForAssetId("rbxassetid://123847828745026")
		IndonesiaEvent_upvr.SoundId = ""
		IndonesiaEvent_upvr.SoundId = "rbxassetid://123847828745026"
		while not IndonesiaEvent_upvr.IsLoaded do
			task.wait()
		end
		IndonesiaEvent_upvr.TimePosition = (62) + (workspace:GetServerTimeNow() - any_GetActiveEventData_result1_upvr.startedAt)
		IndonesiaEvent_upvr:Play()
		any_new_result1_upvr:Add(function() -- Line 155
			--[[ Upvalues[1]:
				[1]: IndonesiaEvent_upvr (copied, readonly)
			]]
			IndonesiaEvent_upvr:Stop()
		end)
	end))
end
function module.OnStop(arg1) -- Line 161
	--[[ Upvalues[1]:
		[1]: any_new_result1_upvr (readonly)
	]]
	any_new_result1_upvr:Destroy()
end
local ContentProvider_upvr = game:GetService("ContentProvider")
local RunService_upvr = game:GetService("RunService")
local any_RemoteEvent_result1_upvr = require(ReplicatedStorage_upvr.Packages.Net):RemoteEvent(`EventService/{Name_upvr}/Burst`)
local AnimalController_upvr = require(ReplicatedStorage_upvr.Controllers.AnimalController)
local Debris_upvr = game:GetService("Debris")
function module.OnLoad(arg1) -- Line 165
	--[[ Upvalues[13]:
		[1]: ContentProvider_upvr (readonly)
		[2]: EncryptedAssetsController_upvr (readonly)
		[3]: IndonesiaEvent_upvr (readonly)
		[4]: Observers_upvr (readonly)
		[5]: Trove_upvr (readonly)
		[6]: any_new_result1_upvr (readonly)
		[7]: RunService_upvr (readonly)
		[8]: any_RemoteEvent_result1_upvr (readonly)
		[9]: AnimalController_upvr (readonly)
		[10]: VFX_upvr (readonly)
		[11]: Debris_upvr (readonly)
		[12]: SoundController_upvr (readonly)
		[13]: ReplicatedStorage_upvr (readonly)
	]]
	task.spawn(pcall, function() -- Line 166
		--[[ Upvalues[1]:
			[1]: ContentProvider_upvr (copied, readonly)
		]]
		ContentProvider_upvr:PreloadAsync(script:GetChildren())
	end)
	task.spawn(function() -- Line 170
		--[[ Upvalues[3]:
			[1]: EncryptedAssetsController_upvr (copied, readonly)
			[2]: IndonesiaEvent_upvr (copied, readonly)
			[3]: ContentProvider_upvr (copied, readonly)
		]]
		EncryptedAssetsController_upvr:WaitForAssetId("rbxassetid://123847828745026")
		IndonesiaEvent_upvr.SoundId = "rbxassetid://123847828745026"
		ContentProvider_upvr:PreloadAsync({IndonesiaEvent_upvr})
	end)
	Observers_upvr.observeTag("IndonesiaCanoe", function(arg1_5) -- Line 176
		--[[ Upvalues[4]:
			[1]: Trove_upvr (copied, readonly)
			[2]: any_new_result1_upvr (copied, readonly)
			[3]: RunService_upvr (copied, readonly)
			[4]: IndonesiaEvent_upvr (copied, readonly)
		]]
		local any_new_result1 = Trove_upvr.new()
		local clone = any_new_result1:Clone(script.Canoe)
		local PrimaryPart = clone.PrimaryPart
		clone.Parent = arg1_5
		local Weld = Instance.new("Weld")
		Weld.Part0 = PrimaryPart
		Weld.Part1 = arg1_5
		Weld.C0 = CFrame.Angles(0, math.pi, 0)
		Weld.Parent = PrimaryPart
		local any_LoadAnimation_result1_upvr_2 = clone["Bambu Bambu Sahur"].AnimationController.Animator:LoadAnimation(script.BambuDance)
		local var55 = any_new_result1
		if not var55 then
			var55 = any_new_result1_upvr
		end
		var55:Add(function() -- Line 49
			--[[ Upvalues[1]:
				[1]: any_LoadAnimation_result1_upvr_2 (readonly)
			]]
			any_LoadAnimation_result1_upvr_2:Stop(0)
			any_LoadAnimation_result1_upvr_2:Destroy()
		end)
		local var57_upvr = any_LoadAnimation_result1_upvr_2
		var57_upvr.Looped = true
		var57_upvr:Play()
		any_LoadAnimation_result1_upvr_2 = RunService_upvr.PreRender
		any_LoadAnimation_result1_upvr_2 = any_LoadAnimation_result1_upvr_2:Connect(function() -- Line 193
			--[[ Upvalues[2]:
				[1]: IndonesiaEvent_upvr (copied, readonly)
				[2]: var57_upvr (readonly)
			]]
			var57_upvr:AdjustSpeed(math.lerp(1.3, 2, math.clamp(IndonesiaEvent_upvr.PlaybackLoudness / 1000, 0, 1)))
		end)
		any_new_result1:Add(any_LoadAnimation_result1_upvr_2)
		return any_new_result1:WrapClean()
	end, {workspace})
	any_RemoteEvent_result1_upvr.OnClientEvent:Connect(function(arg1_6) -- Line 202
		--[[ Upvalues[6]:
			[1]: AnimalController_upvr (copied, readonly)
			[2]: any_new_result1_upvr (copied, readonly)
			[3]: VFX_upvr (copied, readonly)
			[4]: Debris_upvr (copied, readonly)
			[5]: SoundController_upvr (copied, readonly)
			[6]: ReplicatedStorage_upvr (copied, readonly)
		]]
		local var61 = AnimalController_upvr:GetAnimals()[arg1_6]
		if not var61 then
		else
			local AnimalModel = var61.AnimalModel
			local var63 = AnimalModel
			if var63 then
				var63 = AnimalModel.PrimaryPart
			end
			local Instance = var61.Instance
			local var65 = Instance
			if var65 then
				var65 = Instance.PrimaryPart
			end
			if not var65 or not var63 then return end
			local clone_3 = any_new_result1_upvr:Clone(script.Burst)
			clone_3:PivotTo(var65.CFrame * CFrame.new(0, (clone_3.Size.Y + AnimalModel:GetExtentsSize().Y) / 2, 0))
			clone_3.Parent = Instance
			local WeldConstraint = Instance.new("WeldConstraint")
			WeldConstraint.Part0 = clone_3
			WeldConstraint.Part1 = var61.AnimalModel.PrimaryPart
			WeldConstraint.Parent = clone_3
			VFX_upvr.emit(clone_3)
			Debris_upvr:AddItem(clone_3, 5)
			SoundController_upvr:PlaySound(ReplicatedStorage_upvr.Sounds.Events.Indonesia.BrainrotHit, var65.CFrame.Position, false)
		end
	end)
end
return module