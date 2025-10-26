--[[
  Extracted from: ReplicatedStorage.Controllers.EventController.Events.Witching Hour
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local ContentProvider = game:GetService("ContentProvider")
local RunService = game:GetService("RunService")

local Trove = require(ReplicatedStorage.Packages.Trove)
local Observers = require(ReplicatedStorage.Packages.Observers)
local Net = require(ReplicatedStorage.Packages.Net)
local Spr = require(ReplicatedStorage.Packages.Spr)

local EventController = require(ReplicatedStorage.Controllers.EventController)
local EffectController = require(ReplicatedStorage.Controllers.EffectController)
local SoundController = require(ReplicatedStorage.Controllers.SoundController)
local AnimalController = require(ReplicatedStorage.Controllers.AnimalController)
local CycleController = require(ReplicatedStorage.Controllers.CycleController)
local MathUtils = require(ReplicatedStorage.Utils.MathUtils)
local VFX = require(ReplicatedStorage.Shared.VFX)

local module = {}
local TROVE = Trove.new()
local NAME = script.Name

-- remotes
local REMOTE_PROJECTILE = Net:RemoteEvent("EventService/WitchingHour/Projectile")
local REMOTE_BURST = Net:RemoteEvent("EventService/WitchingHour/Burst")


local function getAnimalPosition(animalId)
	local animal = AnimalController:GetAnimals()[animalId]
	if not animal then
		return Vector3.new(0, 0, 0)
	end
	local model = animal.AnimalModel
	if model.PrimaryPart then
		return model.PrimaryPart.CFrame.Position
	else
		return model:GetPivot().Position
	end
end


function module.OnStart()

	assert(EventController:GetActiveEventData(NAME), ("No active event data for %q"):format(NAME))


	local cartoon = Lighting:FindFirstChild("Cartoon")
	if cartoon then
		local originalParent = cartoon.Parent
		cartoon.Parent = script
		TROVE:Add(function()
			
			pcall(function()
				cartoon.Parent = originalParent or Lighting
			end)
		end)
	end

	-- add skys
	if script:FindFirstChild("PurpleSky") then
		local skyClone = script.PurpleSky:Clone()
		skyClone.Parent = Lighting
		TROVE:Add(function()
			if skyClone and skyClone.Parent then
				skyClone:Destroy()
			end
		end)
	end

	-- does the wall recolring shit yk
	EffectController:Run("WitchingHourEvent", "GrassRecolor")
	TROVE:Add(function()
		EffectController:Stop("WitchingHourEvent", "GrassRecolor")
	end)

	EffectController:Run("WitchingHourEvent", "WallRecolor")
	TROVE:Add(function()
		EffectController:Stop("WitchingHourEvent", "WallRecolor")
	end)

	EffectController:Run("WitchingHourEvent", "WallBottomRecolor")
	TROVE:Add(function()
		EffectController:Stop("WitchingHourEvent", "WallBottomRecolor")
	end)


	if script:FindFirstChild("Map") then
		local mapClone = script.Map:Clone()
		mapClone.Parent = Workspace
		TROVE:Add(function()
			if mapClone and mapClone.Parent then
				mapClone:Destroy()
			end
		end)
	end

	-- white shit after event stops 
	EffectController:Activate("Blink")
	TROVE:Add(function()
		EffectController:Activate("Blink") 
	end)


	TROVE:Add(Observers.observeTag("HideInWitchingHour", function(instance)
		local originalParent = instance.Parent
		instance.Parent = script
		return function()
			
			pcall(function()
				if instance and originalParent then
					instance.Parent = originalParent
				end
			end)
		end
	end, { Workspace, script }))


	CycleController:Update()
	SoundController:UpdateOST()
end


function module.OnStop()
	TROVE:Destroy()
end


function module.OnLoad()
	-- Preload resources (children of this script, and witching hour event sounds)
	task.spawn(function()
		pcall(function()
			ContentProvider:PreloadAsync(script:GetChildren())
		end)
	end)

	task.spawn(function()
		pcall(function()
			local sounds = ReplicatedStorage:FindFirstChild("Sounds")
			if sounds and sounds.Events and sounds.Events["Witching Hour"] then
				ContentProvider:PreloadAsync(sounds.Events["Witching Hour"]:GetChildren())
			end
		end)
	end)


	REMOTE_PROJECTILE.OnClientEvent:Connect(function(shooterId, flightDuration, travelTime, startTimeOffset, strength)



		local eventModelRoot = Workspace.Events and Workspace.Events["Witching Hour"] and Workspace.Events["Witching Hour"].Model
		local shooterModel = eventModelRoot and eventModelRoot:FindFirstChild("Sammy")
		if not shooterModel then
			return
		end

		-- play shoot animation on shooter (safe)
		local success, animator = pcall(function()
			return shooterModel.Humanoid.Animator
		end)
		if success and animator then
			local animObj = animator:LoadAnimation(script:FindFirstChild("Shoot"))
			if animObj then
				animObj.Looped = false
				animObj:Play()
				animObj.Ended:Once(function()
					animObj:Stop()
					animObj:Destroy()
				end)
			end
		end


		local rand = Random.new()
		local minRadius = math.min((strength or 0) * 0.5, 50)
		local lateralOffset = rand:NextUnitVector() * (rand:NextInteger(0, 1) * 2 - 1) * minRadius * 0.65
		lateralOffset = Vector3.new(lateralOffset.X, rand:NextNumber(-2, 7) * (minRadius / 50), lateralOffset.Z)

		local lateralOffset2 = rand:NextUnitVector() * (rand:NextInteger(0, 1) * 2 - 1) * minRadius
		lateralOffset2 = Vector3.new(lateralOffset2.X, rand:NextNumber(-2, 7) * (minRadius / 50), lateralOffset2.Z)

		if (strength or 0) <= 15 then
			lateralOffset = Vector3.new(0, 0, 0)
			lateralOffset2 = Vector3.new(0, 0, 0)
		end


		local projectileClone = script:FindFirstChild("Projectile") and script.Projectile:Clone()
		if not projectileClone then
			return
		end

		local started = false
		local startCFrame = shooterModel:FindFirstChild("Cylinder.001") and shooterModel["Cylinder.001"].Attachment and shooterModel["Cylinder.001"].Attachment.WorldCFrame
		local endTime = startTimeOffset + travelTime
		local preRenderConn
		preRenderConn = RunService.PreRender:Connect(function()
			local now = workspace:GetServerTimeNow()
			local t
			if now < startTimeOffset then
				t = 0
			else
				t = 1 - math.max(endTime - now, 0) / travelTime
			end

			if t >= 1 then
				if preRenderConn then
					preRenderConn:Disconnect()
				end
				if projectileClone and projectileClone.Parent then
					projectileClone:Destroy()
				end
				return
			end

			if t > 0 and not started then
				started = true
		
				startCFrame = shooterModel["Cylinder.001"].Attachment.WorldCFrame
				projectileClone.Parent = Workspace
				task.spawn(function()
					SoundController:PlaySound(ReplicatedStorage.Sounds.Events["Witching Hour"].Shot, startCFrame.Position)
				end)
			end

			if not startCFrame then
				return
			end


			local startPos = startCFrame.Position
			local animalPos = getAnimalPosition(shooterId)


			local controlA = startPos:Lerp(animalPos, 0.4) + lateralOffset
			local controlB = startPos:Lerp(animalPos, 0.8) + lateralOffset2
			local cframe = CFrame.new(MathUtils.cubicBezier(t, startPos, controlA, controlB, animalPos))
			projectileClone.CFrame = cframe


			local waist = shooterModel.UpperTorso and shooterModel.UpperTorso:FindFirstChild("Waist")
			if waist then
				local originalC0 = waist:GetAttribute("C0")
				if not originalC0 then
					originalC0 = waist.C0
					waist:SetAttribute("C0", originalC0)
				end

				if t >= 0.8 then
					Spr.target(waist, 1, 2, { C0 = originalC0 })
				else
					local rootCFrame = shooterModel.HumanoidRootPart.CFrame
					local vec = rootCFrame:VectorToObjectSpace((animalPos - rootCFrame.Position).Unit)
					local pitch = math.clamp(math.asin(math.clamp(vec.Y, -1, 1)), -0.2617993877991494, 0.2617993877991494)
					local yaw = math.clamp(math.atan2(-vec.X, -vec.Z), -1.0471975511965976, 1.0471975511965976)
					Spr.target(waist, 1, 2, { C0 = originalC0 * CFrame.Angles(pitch, yaw, 0) })
				end
			end
		end)

		TROVE:Add(function()
			if preRenderConn and preRenderConn.Connected then
				preRenderConn:Disconnect()
			end
			if projectileClone and projectileClone.Parent then
				projectileClone:Destroy()
			end
		end)
	end)


	REMOTE_BURST.OnClientEvent:Connect(function(animalId)
		local animals = AnimalController:GetAnimals()
		local entry = animals[animalId]
		if not entry then
			return
		end

		local model = entry.AnimalModel
		local pivot = model.PrimaryPart and model.PrimaryPart.CFrame or model:GetPivot()
		-- add the burst thing moonhead
		pcall(function()
			VFX.play("WitchingHourBurst", pivot.Position)
		end)

		
		pcall(function()
			SoundController:PlaySound(ReplicatedStorage.Sounds.Events["Witching Hour"].Burst, pivot.Position)
		end)
	end)
end

return module