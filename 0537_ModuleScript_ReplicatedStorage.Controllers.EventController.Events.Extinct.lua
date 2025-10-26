--[[
  Extracted from: ReplicatedStorage.Controllers.EventController.Events.Extinct
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local v_u_1 = game:GetService("ReplicatedStorage")
require(v_u_1.Shared.EventTypes)
local v2 = {}
local v_u_3 = require(v_u_1.Controllers.EffectController)
local v_u_4 = require(v_u_1.Controllers.AnimalController)
local v_u_5 = require(v_u_1.Controllers.SoundController)
local v_u_6 = require(v_u_1.Controllers.EventController)
local v_u_7 = require(v_u_1.Controllers.CycleController)
require(v_u_1.Packages.FFlags)
local v8 = require(v_u_1.Packages.Trove)
local v9 = require(v_u_1.Packages.Net)
local v_u_10 = require(v_u_1.Shared.VFX)
local v_u_11 = script.Name
local v_u_12 = v9:RemoteEvent("EventService/Extinct/Burst")
local v_u_13 = v8.new()
function v2.OnStart(_)
	-- upvalues: (copy) v_u_6, (copy) v_u_11, (copy) v_u_3, (copy) v_u_13, (copy) v_u_7, (copy) v_u_5
	local v14 = v_u_6:GetActiveEventData(v_u_11)
	assert(v14)
	v_u_3:Run("ExtinctEvent", "GrassRecolor")
	v_u_13:Add(function()
		-- upvalues: (ref) v_u_3
		v_u_3:Stop("ExtinctEvent", "GrassRecolor")
	end)
	v_u_3:Run("ExtinctEvent", "WallRecolor")
	v_u_13:Add(function()
		-- upvalues: (ref) v_u_3
		v_u_3:Stop("ExtinctEvent", "WallRecolor")
	end)
	v_u_13:Clone(script.Map).Parent = workspace
	v_u_13:Add(function()
		-- upvalues: (ref) v_u_3
		v_u_3:Activate("Blink")
	end)
	v_u_7:Update()
	v_u_5:UpdateOST()
	v_u_3:Activate("Blink")
end
function v2.OnStop(_)
	-- upvalues: (copy) v_u_13
	v_u_13:Destroy()
end
function v2.OnLoad(_)
	-- upvalues: (copy) v_u_12, (copy) v_u_4, (copy) v_u_5, (copy) v_u_1, (copy) v_u_10
	v_u_12.OnClientEvent:Connect(function(p15)
		-- upvalues: (ref) v_u_4, (ref) v_u_5, (ref) v_u_1, (ref) v_u_10
		local v16 = v_u_4:GetAnimals()[p15]
		if v16 then
			local v17 = v16.AnimalModel
			local v18
			if v17.PrimaryPart then
				v18 = v17.PrimaryPart.CFrame
			else
				v18 = v17:GetPivot()
			end
			local v_u_19 = v18.Position
			task.spawn(function()
				-- upvalues: (ref) v_u_5, (ref) v_u_1, (copy) v_u_19
				v_u_5:PlaySound(v_u_1.Sounds.Events.Extinct.Hit, v_u_19)
			end)
			local v_u_20 = script.Burst:Clone()
			v_u_20:PivotTo(CFrame.new(v_u_19))
			v_u_20.Anchored = false
			local v21 = Instance.new("WeldConstraint")
			v21.Part0 = v_u_20
			v21.Part1 = v16.AnimalModel.PrimaryPart
			v21.Parent = v_u_20
			v_u_20.Parent = workspace
			v_u_10.emit(v_u_20)
			task.delay(5, function()
				-- upvalues: (copy) v_u_20
				v_u_20:Destroy()
			end)
		end
	end)
end
return v2