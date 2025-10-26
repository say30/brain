--[[
  Extracted from: ReplicatedStorage.Controllers.EventController.Events.Meowl
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2025-10-18 19:25:19
-- Luau version 6, Types version 3
-- Time taken: 0.004827 seconds

local ReplicatedStorage_upvr = game:GetService("ReplicatedStorage")
local module = {}
local Trove_upvr = require(ReplicatedStorage_upvr.Packages.Trove)
local Name_upvr = script.Name
local any_new_result1_2_upvr = Trove_upvr.new()
local function _(arg1, arg2, arg3) -- Line 27, Named "loadAnimation"
	--[[ Upvalues[1]:
		[1]: any_new_result1_2_upvr (readonly)
	]]
	local any_LoadAnimation_result1_upvr_3 = arg1:LoadAnimation(arg2)
	local var7 = arg3
	if not var7 then
		var7 = any_new_result1_2_upvr
	end
	var7:Add(function() -- Line 29
		--[[ Upvalues[1]:
			[1]: any_LoadAnimation_result1_upvr_3 (readonly)
		]]
		any_LoadAnimation_result1_upvr_3:Stop(0)
		any_LoadAnimation_result1_upvr_3:Destroy()
	end)
	return any_LoadAnimation_result1_upvr_3
end
local EventController_upvr = require(ReplicatedStorage_upvr.Controllers.EventController)
local Lighting_upvr = game:GetService("Lighting")
local Observers_upvr = require(ReplicatedStorage_upvr.Packages.Observers)
local EffectController_upvr = require(ReplicatedStorage_upvr.Controllers.EffectController)
function module.OnStart(arg1) -- Line 37
	--[[ Upvalues[8]:
		[1]: EventController_upvr (readonly)
		[2]: Name_upvr (readonly)
		[3]: ReplicatedStorage_upvr (readonly)
		[4]: any_new_result1_2_upvr (readonly)
		[5]: Lighting_upvr (readonly)
		[6]: Observers_upvr (readonly)
		[7]: Trove_upvr (readonly)
		[8]: EffectController_upvr (readonly)
	]]
	assert(EventController_upvr:GetActiveEventData(Name_upvr))
	ReplicatedStorage_upvr:SetAttribute("MeowlEvent", true)
	any_new_result1_2_upvr:Add(function() -- Line 42
		--[[ Upvalues[1]:
			[1]: ReplicatedStorage_upvr (copied, readonly)
		]]
		ReplicatedStorage_upvr:SetAttribute("MeowlEvent", nil)
	end)
	any_new_result1_2_upvr:Clone(script.Map).Parent = workspace
	local Atmosphere_upvr = Lighting_upvr:FindFirstChild("Atmosphere")
	if Atmosphere_upvr then
		Atmosphere_upvr.Parent = script
		any_new_result1_2_upvr:Add(function() -- Line 51
			--[[ Upvalues[2]:
				[1]: Atmosphere_upvr (readonly)
				[2]: Lighting_upvr (copied, readonly)
			]]
			Atmosphere_upvr.Parent = Lighting_upvr
		end)
	end
	any_new_result1_2_upvr:Clone(script.AtmosphereMeowl).Parent = Lighting_upvr
	any_new_result1_2_upvr:Add(task.spawn(function() -- Line 57
		--[[ Upvalues[1]:
			[1]: any_new_result1_2_upvr (copied, readonly)
		]]
		-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
		local tbl_upvr = {}
		local function _(arg1_2) -- Line 65, Named "isPositionValid"
			--[[ Upvalues[1]:
				[1]: tbl_upvr (readonly)
			]]
			for _, v in tbl_upvr do
				if (arg1_2 - v).Magnitude < 20 then
					return false
				end
			end
			return true
		end
		local _ = {script.Trees['1'], script.Trees['2'], script.Trees['3']}
		local children = workspace.Events.Matteo:GetChildren()
		table.sort(children, function(arg1_3, arg2) -- Line 77
			local Position = arg1_3.Position
			local Position_2 = arg2.Position
			local var25 = Position_2.X + Position_2.Y
			if var25 + Position_2.Z >= Position.X + Position.Y + Position.Z then
				var25 = false
			else
				var25 = true
			end
			return var25
		end)
		-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [177] 127. Error Block 14 start (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [177] 127. Error Block 14 end (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [48] 31. Error Block 2 start (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [48] 31. Error Block 2 end (CF ANALYSIS FAILED)
	end))
	any_new_result1_2_upvr:Add(Observers_upvr.observeTag("MeowlEventMeowl", function(arg1_4) -- Line 120
		--[[ Upvalues[3]:
			[1]: Trove_upvr (copied, readonly)
			[2]: any_new_result1_2_upvr (copied, readonly)
			[3]: Observers_upvr (copied, readonly)
		]]
		local any_new_result1 = Trove_upvr.new()
		local clone_2 = any_new_result1:Clone(script.Meowl)
		clone_2.Parent = workspace
		local Weld = Instance.new("Weld")
		Weld.Part0 = clone_2.PrimaryPart
		Weld.Part1 = arg1_4
		Weld.C0 = clone_2.PrimaryPart.PivotOffset
		Weld.Parent = clone_2.PrimaryPart
		local any_LoadAnimation_result1_upvr = clone_2.AnimationController.Animator:LoadAnimation(script.Idle)
		any_new_result1_2_upvr:Add(function() -- Line 29
			--[[ Upvalues[1]:
				[1]: any_LoadAnimation_result1_upvr (readonly)
			]]
			any_LoadAnimation_result1_upvr:Stop(0)
			any_LoadAnimation_result1_upvr:Destroy()
		end)
		local var32 = any_LoadAnimation_result1_upvr
		var32.Priority = Enum.AnimationPriority.Idle
		var32.Looped = true
		var32:Play()
		any_LoadAnimation_result1_upvr = clone_2.AnimationController
		any_LoadAnimation_result1_upvr = script.Fly
		local any_LoadAnimation_result1_upvr_2 = any_LoadAnimation_result1_upvr.Animator:LoadAnimation(any_LoadAnimation_result1_upvr)
		any_new_result1_2_upvr:Add(function() -- Line 29
			--[[ Upvalues[1]:
				[1]: any_LoadAnimation_result1_upvr_2 (readonly)
			]]
			any_LoadAnimation_result1_upvr_2:Stop(0)
			any_LoadAnimation_result1_upvr_2:Destroy()
		end)
		local var35_upvr = any_LoadAnimation_result1_upvr_2
		var35_upvr.Priority = Enum.AnimationPriority.Action
		var35_upvr.Looped = true
		any_LoadAnimation_result1_upvr_2 = clone_2.AnimationController
		any_LoadAnimation_result1_upvr = any_LoadAnimation_result1_upvr_2.Animator
		any_LoadAnimation_result1_upvr_2 = script.Attack
		local any_LoadAnimation_result1_upvr_4 = any_LoadAnimation_result1_upvr:LoadAnimation(any_LoadAnimation_result1_upvr_2)
		any_new_result1_2_upvr:Add(function() -- Line 29
			--[[ Upvalues[1]:
				[1]: any_LoadAnimation_result1_upvr_4 (readonly)
			]]
			any_LoadAnimation_result1_upvr_4:Stop(0)
			any_LoadAnimation_result1_upvr_4:Destroy()
		end)
		local var38_upvr = any_LoadAnimation_result1_upvr_4
		any_LoadAnimation_result1_upvr = Enum.AnimationPriority.Action2
		var38_upvr.Priority = any_LoadAnimation_result1_upvr
		any_LoadAnimation_result1_upvr = false
		var38_upvr.Looped = any_LoadAnimation_result1_upvr
		any_LoadAnimation_result1_upvr_4 = Observers_upvr.observeAttribute
		any_LoadAnimation_result1_upvr_4 = any_LoadAnimation_result1_upvr_4(arg1_4, "Flying", function(arg1_5) -- Line 145
			--[[ Upvalues[1]:
				[1]: var35_upvr (readonly)
			]]
			if arg1_5 then
				var35_upvr:Play()
			else
				var35_upvr:Stop()
			end
			return nil
		end)
		any_LoadAnimation_result1_upvr = any_new_result1:Add
		any_LoadAnimation_result1_upvr(any_LoadAnimation_result1_upvr_4)
		any_LoadAnimation_result1_upvr_4 = arg1_4:GetAttributeChangedSignal("Attack")
		any_LoadAnimation_result1_upvr_4 = any_LoadAnimation_result1_upvr_4:Connect(function() -- Line 155
			--[[ Upvalues[1]:
				[1]: var38_upvr (readonly)
			]]
			var38_upvr:Play()
		end)
		any_LoadAnimation_result1_upvr = any_new_result1:Add
		any_LoadAnimation_result1_upvr(any_LoadAnimation_result1_upvr_4)
		any_LoadAnimation_result1_upvr = any_new_result1:WrapClean()
		return any_LoadAnimation_result1_upvr
	end, {workspace}))
	EffectController_upvr:Activate("Blink")
	EffectController_upvr:Run("MeowlEvent", "GrassRecolor")
	EffectController_upvr:Run("MeowlEvent", "WallRecolor")
	EffectController_upvr:Run("MeowlEvent", "WallBottomRecolor")
	any_new_result1_2_upvr:Add(function() -- Line 166
		--[[ Upvalues[1]:
			[1]: EffectController_upvr (copied, readonly)
		]]
		EffectController_upvr:Stop("MeowlEvent", "GrassRecolor")
		EffectController_upvr:Stop("MeowlEvent", "WallRecolor")
		EffectController_upvr:Stop("MeowlEvent", "WallBottomRecolor")
		EffectController_upvr:Activate("Blink")
	end)
end
function module.OnStop(arg1) -- Line 174
	--[[ Upvalues[1]:
		[1]: any_new_result1_2_upvr (readonly)
	]]
	any_new_result1_2_upvr:Destroy()
end
local ContentProvider_upvr = game:GetService("ContentProvider")
local any_RemoteEvent_result1_upvr = require(ReplicatedStorage_upvr.Packages.Net):RemoteEvent(`EventService/{Name_upvr}/Burst`)
local AnimalController_upvr = require(ReplicatedStorage_upvr.Controllers.AnimalController)
local VFX_upvr = require(ReplicatedStorage_upvr.Shared.VFX)
local Debris_upvr = game:GetService("Debris")
local SoundController_upvr = require(ReplicatedStorage_upvr.Controllers.SoundController)
function module.OnLoad(arg1) -- Line 178
	--[[ Upvalues[8]:
		[1]: ContentProvider_upvr (readonly)
		[2]: any_RemoteEvent_result1_upvr (readonly)
		[3]: AnimalController_upvr (readonly)
		[4]: any_new_result1_2_upvr (readonly)
		[5]: VFX_upvr (readonly)
		[6]: Debris_upvr (readonly)
		[7]: SoundController_upvr (readonly)
		[8]: ReplicatedStorage_upvr (readonly)
	]]
	task.spawn(pcall, function() -- Line 179
		--[[ Upvalues[1]:
			[1]: ContentProvider_upvr (copied, readonly)
		]]
		ContentProvider_upvr:PreloadAsync(script:GetChildren())
	end)
	any_RemoteEvent_result1_upvr.OnClientEvent:Connect(function(arg1_6) -- Line 183
		--[[ Upvalues[6]:
			[1]: AnimalController_upvr (copied, readonly)
			[2]: any_new_result1_2_upvr (copied, readonly)
			[3]: VFX_upvr (copied, readonly)
			[4]: Debris_upvr (copied, readonly)
			[5]: SoundController_upvr (copied, readonly)
			[6]: ReplicatedStorage_upvr (copied, readonly)
		]]
		local var51 = AnimalController_upvr:GetAnimals()[arg1_6]
		if not var51 then
		else
			local AnimalModel = var51.AnimalModel
			local var53 = AnimalModel
			if var53 then
				var53 = AnimalModel.PrimaryPart
			end
			local Instance = var51.Instance
			local var55 = Instance
			if var55 then
				var55 = Instance.PrimaryPart
			end
			if not var55 or not var53 then return end
			local clone = any_new_result1_2_upvr:Clone(script.Burst)
			clone:PivotTo(var55.CFrame * CFrame.new(0, (clone.Size.Y + AnimalModel:GetExtentsSize().Y) / 2, 0))
			clone.Parent = Instance
			local WeldConstraint = Instance.new("WeldConstraint")
			WeldConstraint.Part0 = clone
			WeldConstraint.Part1 = var51.AnimalModel.PrimaryPart
			WeldConstraint.Parent = clone
			VFX_upvr.emit(clone)
			Debris_upvr:AddItem(clone, 5)
			SoundController_upvr:PlaySound(ReplicatedStorage_upvr.Sounds.Events.Meowl.BrainrotHit, var55.CFrame.Position, false)
			SoundController_upvr:PlaySound(ReplicatedStorage_upvr.Sounds.Events.Meowl.Flap, var55.CFrame.Position, false)
		end
	end)
end
return module