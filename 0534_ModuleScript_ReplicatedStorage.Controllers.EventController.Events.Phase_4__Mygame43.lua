--[[
  Extracted from: ReplicatedStorage.Controllers.EventController.Events.Phase 4: Mygame43
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2025-08-30 12:48:36
-- Luau version 6, Types version 3
-- Time taken: 0.007677 seconds

local ReplicatedStorage_upvr = game:GetService("ReplicatedStorage")
local module = {}
local Name_upvr = script.Name
local RaycastParams_new_result1 = RaycastParams.new()
RaycastParams_new_result1.FilterDescendantsInstances = {workspace.Events["Los Matteos"].Areas}
RaycastParams_new_result1.FilterType = Enum.RaycastFilterType.Include
local CurrentCamera_upvr = workspace.CurrentCamera
local any_new_result1_upvr_2 = require(ReplicatedStorage_upvr.Packages.Trove).new()
local any_new_result1_upvr = require(ReplicatedStorage_upvr.Packages.Shake).new()
any_new_result1_upvr.Amplitude = 5.5
any_new_result1_upvr.Frequency = 0.05
any_new_result1_upvr.FadeInTime = 0
any_new_result1_upvr.FadeOutTime = 0.6
any_new_result1_upvr.PositionInfluence = Vector3.new(0.5, 0.5, 0.5)
any_new_result1_upvr.RotationInfluence = Vector3.new(2.5, 0.5, 0.5)
local ShakePresets_upvr = require(ReplicatedStorage_upvr.Shared.ShakePresets)
local function shakeCameraBasedOnProximity_upvr(arg1) -- Line 58, Named "shakeCameraBasedOnProximity"
	--[[ Upvalues[4]:
		[1]: CurrentCamera_upvr (readonly)
		[2]: any_new_result1_upvr (readonly)
		[3]: any_new_result1_upvr_2 (readonly)
		[4]: ShakePresets_upvr (readonly)
	]]
	local Magnitude = (CurrentCamera_upvr.CFrame.Position - arg1).Magnitude
	if Magnitude <= 300 then
		local clone = any_new_result1_upvr:Clone()
		local var12 = (1 - Magnitude / 300 * 0.5) ^ 2
		clone.Amplitude *= var12
		clone.RotationInfluence *= var12
		any_new_result1_upvr_2:Add(ShakePresets_upvr.BindShakeToCamera(clone))
		clone:Start()
	end
end
local EventController_upvr = require(ReplicatedStorage_upvr.Controllers.EventController)
local EffectController_upvr = require(ReplicatedStorage_upvr.Controllers.EffectController)
local Observers_upvr = require(ReplicatedStorage_upvr.Packages.Observers)
local Spr_upvr = require(ReplicatedStorage_upvr.Packages.Spr)
local RunService_upvr = game:GetService("RunService")
local VFX_upvr = require(ReplicatedStorage_upvr.Shared.VFX)
local SkullEmojiEffectController_upvr = require(ReplicatedStorage_upvr.Controllers.SkullEmojiEffectController)
local any_RemoteEvent_result1_upvr = require(ReplicatedStorage_upvr.Packages.Net):RemoteEvent(`EventService/{Name_upvr}/CreateLightningOrb`)
local TweenService_upvr = game:GetService("TweenService")
local SharedEventUtils_upvr = require(ReplicatedStorage_upvr.Shared.SharedEventUtils)
local MathUtils_upvr = require(ReplicatedStorage_upvr.Utils.MathUtils)
local SoundController_upvr = require(ReplicatedStorage_upvr.Controllers.SoundController)
function module.OnStart(arg1) -- Line 76
	--[[ Upvalues[17]:
		[1]: EventController_upvr (readonly)
		[2]: Name_upvr (readonly)
		[3]: any_new_result1_upvr_2 (readonly)
		[4]: EffectController_upvr (readonly)
		[5]: ReplicatedStorage_upvr (readonly)
		[6]: Observers_upvr (readonly)
		[7]: Spr_upvr (readonly)
		[8]: RunService_upvr (readonly)
		[9]: VFX_upvr (readonly)
		[10]: CurrentCamera_upvr (readonly)
		[11]: SkullEmojiEffectController_upvr (readonly)
		[12]: any_RemoteEvent_result1_upvr (readonly)
		[13]: TweenService_upvr (readonly)
		[14]: SharedEventUtils_upvr (readonly)
		[15]: MathUtils_upvr (readonly)
		[16]: shakeCameraBasedOnProximity_upvr (readonly)
		[17]: SoundController_upvr (readonly)
	]]
	local any_GetActiveEventData_result1_upvr = EventController_upvr:GetActiveEventData(Name_upvr)
	assert(any_GetActiveEventData_result1_upvr)
	local function _(arg1_2) -- Line 80, Named "calculateTimeLeftFor"
		--[[ Upvalues[1]:
			[1]: any_GetActiveEventData_result1_upvr (readonly)
		]]
		return any_GetActiveEventData_result1_upvr.startedAt + arg1_2 - workspace:GetServerTimeNow()
	end
	any_new_result1_upvr_2:Add(function() -- Line 84
		--[[ Upvalues[1]:
			[1]: EffectController_upvr (copied, readonly)
		]]
		EffectController_upvr:Activate("Blink")
	end)
	local var27_upvw
	local function _(arg1_3) -- Line 91, Named "getOrbPosition"
		--[[ Upvalues[1]:
			[1]: var27_upvw (read and write)
		]]
		-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
		local var28 = true
		if arg1_3 ~= 2 then
			if arg1_3 ~= 3 then
				var28 = false
			else
				var28 = true
			end
		end
		if var28 then
		else
		end
		local cframe = CFrame.new((arg1_3 - 1) * 30 + 412.949, 1.113, -168.558)
		if var27_upvw then
			return var27_upvw.HumanoidRootPart.CFrame * cframe
		end
		return cframe
	end
	ReplicatedStorage_upvr.Sounds.Events["Phase 4: Mygame43"].Appear:Play()
	any_new_result1_upvr_2:Add(Observers_upvr.observeTag("Mygame43", function(arg1_4) -- Line 106
		--[[ Upvalues[8]:
			[1]: var27_upvw (read and write)
			[2]: any_GetActiveEventData_result1_upvr (readonly)
			[3]: any_new_result1_upvr_2 (copied, readonly)
			[4]: Spr_upvr (copied, readonly)
			[5]: RunService_upvr (copied, readonly)
			[6]: VFX_upvr (copied, readonly)
			[7]: CurrentCamera_upvr (copied, readonly)
			[8]: SkullEmojiEffectController_upvr (copied, readonly)
		]]
		var27_upvw = arg1_4
		assert(var27_upvw)
		local any_LoadAnimation_result1 = var27_upvw.Humanoid.Animator:LoadAnimation(script.Spawn)
		var27_upvw.Humanoid.Animator:LoadAnimation(script.Idle):Play()
		any_LoadAnimation_result1:Play()
		any_LoadAnimation_result1.TimePosition = (7) - (any_GetActiveEventData_result1_upvr.startedAt + 7 - workspace:GetServerTimeNow())
		any_new_result1_upvr_2:Add(task.delay(any_GetActiveEventData_result1_upvr.startedAt + 7.7 - workspace:GetServerTimeNow(), function() -- Line 118
			--[[ Upvalues[4]:
				[1]: var27_upvw (copied, read and write)
				[2]: any_new_result1_upvr_2 (copied, readonly)
				[3]: Spr_upvr (copied, readonly)
				[4]: RunService_upvr (copied, readonly)
			]]
			-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
			for i_upvr = 1, 4 do
				local var37 = true
				if i_upvr ~= 2 then
					if i_upvr ~= 3 then
						var37 = false
					else
						var37 = true
					end
				end
				if var37 then
				else
				end
				if var27_upvw then
					local _ = var27_upvw.HumanoidRootPart.CFrame * CFrame.new((i_upvr - 1) * 30 + -45, 50, 15)
				else
				end
				local clone_3_upvr = any_new_result1_upvr_2:Clone(script.Orb)
				-- KONSTANTERROR: Expression was reused, decompilation is incorrect

				local relativePos = CFrame.new(20 * (i_upvr - 2.5), 40, 26) 
				clone_3_upvr.CFrame = var27_upvw.HumanoidRootPart.CFrame * relativePos

				clone_3_upvr.Parent = workspace
				any_new_result1_upvr_2:Add(function() -- Line 151
					--[[ Upvalues[2]:
						[1]: Spr_upvr (copied, readonly)
						[2]: clone_3_upvr (readonly)
					]]
					Spr_upvr.stop(clone_3_upvr)
				end)

				local cframe_2_upvr = var27_upvw.HumanoidRootPart.CFrame * relativePos
				local any_NextNumber_result1_upvr = Random.new():NextNumber(2, 3)
				any_new_result1_upvr_2:Add(RunService_upvr.PostSimulation:Connect(function(arg1_5) -- Line 156
					--[[ Upvalues[5]:
						[1]: Spr_upvr (copied, readonly)
						[2]: clone_3_upvr (readonly)
						[3]: cframe_2_upvr (readonly)
						[4]: i_upvr (readonly)
						[5]: any_NextNumber_result1_upvr (readonly)
					]]
					Spr_upvr.target(clone_3_upvr, 0.8, 1, {
						Pivot = cframe_2_upvr + Vector3.new(0, math.sin((os.clock() + i_upvr * 90) * any_NextNumber_result1_upvr) * 4, 0);
					})
				end))
			end
		end))
		any_new_result1_upvr_2:Add(task.delay(any_GetActiveEventData_result1_upvr.startedAt + 3.6999999999999997 - workspace:GetServerTimeNow(), function() -- Line 164
			--[[ Upvalues[5]:
				[1]: VFX_upvr (copied, readonly)
				[2]: var27_upvw (copied, read and write)
				[3]: RunService_upvr (copied, readonly)
				[4]: CurrentCamera_upvr (copied, readonly)
				[5]: SkullEmojiEffectController_upvr (copied, readonly)
			]]
			VFX_upvr.enable(var27_upvw)
			task.wait(0.6)
			RunService_upvr.PreRender:Connect(function(arg1_6) -- Line 168
				--[[ Upvalues[2]:
					[1]: CurrentCamera_upvr (copied, readonly)
					[2]: var27_upvw (copied, read and write)
				]]
				local CFrame = CurrentCamera_upvr.CFrame
				CurrentCamera_upvr.CFrame = CFrame:Lerp(CFrame.lookAt(CFrame.Position, var27_upvw:GetPivot().Position), arg1_6 ^ 0.45)
			end):Disconnect()
			SkullEmojiEffectController_upvr:Play(3, "Lower")
		end))
		return nil
	end))
	any_new_result1_upvr_2:Add(any_RemoteEvent_result1_upvr.OnClientEvent:Connect(function(arg1_7, arg2, arg3, arg4, arg5) -- Line 181
		--[[ Upvalues[10]:
			[1]: var27_upvw (read and write)
			[2]: any_new_result1_upvr_2 (copied, readonly)
			[3]: ReplicatedStorage_upvr (copied, readonly)
			[4]: VFX_upvr (copied, readonly)
			[5]: RunService_upvr (copied, readonly)
			[6]: TweenService_upvr (copied, readonly)
			[7]: SharedEventUtils_upvr (copied, readonly)
			[8]: MathUtils_upvr (copied, readonly)
			[9]: shakeCameraBasedOnProximity_upvr (copied, readonly)
			[10]: SoundController_upvr (copied, readonly)
		]]
		-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
		local var49 = true
		if arg2 ~= 2 then
			if arg2 ~= 3 then
				var49 = false
			else
				var49 = true
			end
		end
		if var49 then
		else
		end
		if var27_upvw then
		else
		end
		-- This is the line that was still using a hard-coded position.
		-- It needs to be removed and replaced with a relative position.
		local relativePos = CFrame.new(20 * (arg2 - 2.5), 40, 26)
		local Position_upvr = (var27_upvw.HumanoidRootPart.CFrame * relativePos).Position

		local clone_upvr = any_new_result1_upvr_2:Clone(script.OrbSmaller)
		clone_upvr.CFrame = CFrame.new(Position_upvr)
		local clone_2 = ReplicatedStorage_upvr.Sounds.Events["Phase 4: Mygame43"].OrbFlying:Clone()
		clone_2.Parent = clone_upvr
		clone_upvr.Parent = workspace
		clone_2:Play()
		VFX_upvr.enable(clone_upvr)
		local random_state = Random.new(arg1_7)
		local var55_upvw = 0
		local var56_upvr = Position_upvr + (arg3 - Position_upvr) * 0.25 + Vector3.new(random_state:NextNumber(50, 100) * (random_state:NextInteger(0, 1) * 2 - 1), random_state:NextInteger(300, 400), 0)
		local var57_upvr = Position_upvr + (arg3 - Position_upvr) * 0.6 + Vector3.new(random_state:NextNumber(50, 150) * (random_state:NextInteger(0, 1) * 2 - 1), random_state:NextInteger(100, 200), 0)
		local var58_upvw
		var58_upvw = any_new_result1_upvr_2:Add(RunService_upvr.PostSimulation:Connect(function(arg1_8) -- Line 204
			--[[ Upvalues[18]:
				[1]: var55_upvw (read and write)
				[2]: TweenService_upvr (copied, readonly)
				[3]: arg4 (readonly)
				[4]: SharedEventUtils_upvr (copied, readonly)
				[5]: clone_upvr (readonly)
				[6]: MathUtils_upvr (copied, readonly)
				[7]: Position_upvr (readonly)
				[8]: var56_upvr (readonly)
				[9]: var57_upvr (readonly)
				[10]: arg3 (readonly)
				[11]: var58_upvw (read and write)
				[12]: any_new_result1_upvr_2 (copied, readonly)
				[13]: VFX_upvr (copied, readonly)
				[14]: shakeCameraBasedOnProximity_upvr (copied, readonly)
				[15]: arg3 (readonly)
				[16]: arg5 (readonly)
				[17]: SoundController_upvr (copied, readonly)
				[18]: ReplicatedStorage_upvr (copied, readonly)
			]]
			var55_upvw += arg1_8
			local any_GetValue_result1 = TweenService_upvr:GetValue(var55_upvw / arg4, Enum.EasingStyle.Sine, Enum.EasingDirection.In)
			SharedEventUtils_upvr.pushPartCFrame(clone_upvr, CFrame.new(MathUtils_upvr.cubicBezier(any_GetValue_result1, Position_upvr, var56_upvr, var57_upvr, arg3)))
			if 1 <= any_GetValue_result1 and var58_upvw then
				any_new_result1_upvr_2:Remove(var58_upvw)
				var58_upvw = nil
				VFX_upvr.disable(clone_upvr)
				task.delay(3, function() -- Line 215
					--[[ Upvalues[2]:
						[1]: any_new_result1_upvr_2 (copied, readonly)
						[2]: clone_upvr (copied, readonly)
					]]
					any_new_result1_upvr_2:Remove(clone_upvr)
				end)
				local var61_upvr = shakeCameraBasedOnProximity_upvr
				var61_upvr(arg3)
				if arg5 then
					var61_upvr = script.StrikeBrainrot:Clone()
				else
					var61_upvr = script.Strike:Clone()
				end
				var61_upvr.Position = arg3
				var61_upvr.Parent = workspace
				VFX_upvr.emit(var61_upvr)
				task.delay(4, function() -- Line 227
					--[[ Upvalues[1]:
						[1]: var61_upvr (readonly)
					]]
					var61_upvr:Destroy()
				end)
				if arg5 then
					SoundController_upvr:PlaySound(ReplicatedStorage_upvr.Sounds.Events["Los Matteos"].Hit, arg3, false)
					return
				end
				SoundController_upvr:PlaySound(ReplicatedStorage_upvr.Sounds.Events["Phase 4: Mygame43"].OrbHitNothing, arg3, false)
			end
		end))
	end))
end
function module.OnStop(arg1) -- Line 241
	--[[ Upvalues[1]:
		[1]: any_new_result1_upvr_2 (readonly)
	]]
	any_new_result1_upvr_2:Destroy()
end
local ContentProvider_upvr = game:GetService("ContentProvider")
function module.OnLoad(arg1) -- Line 245
	--[[ Upvalues[2]:
		[1]: ContentProvider_upvr (readonly)
		[2]: ReplicatedStorage_upvr (readonly)
	]]
	task.spawn(pcall, function() -- Line 246
		--[[ Upvalues[1]:
			[1]: ContentProvider_upvr (copied, readonly)
		]]
		ContentProvider_upvr:PreloadAsync(script:GetChildren())
	end)
	task.spawn(pcall, function() -- Line 250
		--[[ Upvalues[2]:
			[1]: ContentProvider_upvr (copied, readonly)
			[2]: ReplicatedStorage_upvr (copied, readonly)
		]]
		ContentProvider_upvr:PreloadAsync(ReplicatedStorage_upvr.Models.Events["Phase 4: Mygame43"])
	end)
end
return module