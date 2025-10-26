--[[
  Extracted from: ReplicatedStorage.Controllers.FuseMachineController
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Synchronizer = require(ReplicatedStorage.Packages.Synchronizer)
local EasyVisuals = require(ReplicatedStorage.Packages.EasyVisuals)
local Trove = require(ReplicatedStorage.Packages.Trove)
local NotificationController = require(ReplicatedStorage.Controllers.NotificationController)
local FuseMachineData = require(ReplicatedStorage.Datas.FuseMachineData)
local Rarities = require(ReplicatedStorage.Datas.Rarities)
local Animals = require(ReplicatedStorage.Datas.Animals)
local LocalPlayer = Players.LocalPlayer
local FuseMachineUI = LocalPlayer.PlayerGui:WaitForChild("FuseMachine").FuseMachine
local Mutations = require(ReplicatedStorage.Datas.Mutations)
local SharedAnimals = require(ReplicatedStorage.Shared.Animals)
local Net = require(ReplicatedStorage.Packages.Net)
local Timer = require(ReplicatedStorage.Packages.Timer)
local Observers = require(ReplicatedStorage.Packages.Observers)
local SoundController = require(ReplicatedStorage.Controllers.SoundController)
local VFX = require(ReplicatedStorage.Shared.VFX)
local InterfaceController = require(ReplicatedStorage.Controllers.InterfaceController)
local TimeUtils = require(ReplicatedStorage.Utils.TimeUtils)
local NumberUtils = require(ReplicatedStorage.Utils.NumberUtils)
local AnimatedButton = require(ReplicatedStorage.Classes.AnimatedButton)

local module = {}

local Brainrots = FuseMachineUI.Brainrots
local Fusions = FuseMachineUI.Fusions
local BuyButton = FuseMachineUI.Buy
local TimeLabel = FuseMachineUI.Time
local CloseButton = FuseMachineUI.Header.Close

local buyButtonTrove = Trove.new()
local timerTrove = Trove.new()
local mainTrove
local updateFunction

local function setupBrainrots()
	local playerState = Synchronizer:Get(LocalPlayer)
	if not playerState then return end

	for _, v in Brainrots:GetChildren() do
		if v:IsA("Frame") and v.Name ~= "Template" then
			v:Destroy()
		end
	end

	local slots = playerState:Get("FuseMachine.Slots")
	if not slots or #slots == 0 then return end

	for i = 1, FuseMachineData.FuseSlots do
		local slotData = slots[i]
		if slotData and slotData ~= "Empty" then
			local animalData = Animals[slotData.Index]
			local rarityData = Rarities[animalData.Rarity]
			local clone = Brainrots.Template:Clone()

			clone.Name = `{animalData.DisplayName}.{i}`
			clone.BrainrotName.Text = animalData.DisplayName

			if slotData.Mutation then
				clone.Mutation.Text = Mutations[slotData.Mutation].DisplayWithRichText
			end

			clone.Rarity.Text = animalData.Rarity

			if rarityData.GradientPreset then
				clone.Rarity.TextColor3 = Color3.fromRGB(255, 255, 255)
				EasyVisuals.new(clone.Rarity, rarityData.GradientPreset, 0.5)
			else
				clone.Rarity.TextColor3 = rarityData.Color
			end

			clone.Parent = Brainrots
			clone.Visible = true

			SharedAnimals:AttachOnViewport(animalData.DisplayName, clone.ViewportFrame, true, slotData.Mutation)
		end
	end
end

local function updateOdds()
	local playerState = Synchronizer:Get(LocalPlayer)
	if not playerState then return end

	for _, v in Fusions:GetChildren() do
		if v:IsA("TextLabel") and v.Name ~= "Template" then
			v:Destroy()
		end
	end

	local odds = playerState:Get("FuseMachine.OutputRarityOdds")
	if not odds then return end

	for rarityName, chance in odds do
		if chance > 0 then
			local rarityData = Rarities[rarityName]
			local clone = Fusions.Template:Clone()

			clone.Name = rarityName

			local textChance
			if chance == math.floor(chance) then
				textChance = string.format("%d", chance)
			else
				textChance = string.format("%.2f", chance)
			end

			clone.Text = `{rarityName} ({textChance}%)`

			if rarityData.GradientPreset then
				clone.TextColor3 = Color3.fromRGB(255, 255, 255)
				EasyVisuals.new(clone, rarityData.GradientPreset, 0.5)
			else
				clone.TextColor3 = rarityData.Color
			end

			clone.Parent = Fusions
			clone.LayoutOrder = rarityData.Weight
			clone.Visible = true
		end
	end
end

local function updateBuyButton()
	local playerState = Synchronizer:Get(LocalPlayer)
	if not playerState then return end

	local cost = playerState:Get("FuseMachine.Cost")
	local finishTime = playerState:Get("FuseMachine.FinishTime")
	local startTime = playerState:Get("FuseMachine.StartTime")

	local isFinished = finishTime and finishTime <= workspace:GetServerTimeNow()

	buyButtonTrove:Clean()
	BuyButton.Visible = false

	if not cost then return end
	if startTime and startTime ~= 0 and not isFinished then return end

	-- ✅ NEW CHECK: Require all slots to be filled before showing button
	local slots = playerState:Get("FuseMachine.Slots")
	if not slots then return end
	for i = 1, FuseMachineData.FuseSlots do
		if not slots[i] or slots[i] == "Empty" then
			return -- Hide button if even one slot is empty
		end
	end

	BuyButton.Price.Text = `${NumberUtils:ToString(cost)}`
	BuyButton.Visible = true

	local animatedButton = AnimatedButton.new(BuyButton)
	animatedButton:Animate()
	buyButtonTrove:Add(animatedButton)

	buyButtonTrove:Add(animatedButton.OnActivated:Connect(function()
		local success, message = FuseMachineData.Remotes.ConfirmFusion:InvokeServer()
		if not success then
			NotificationController:Error(message or "Something went wrong!")
		else
			buyButtonTrove:Clean()
		end
	end))
end

local function updateTimer()
	timerTrove:Clean()
	local playerState = Synchronizer:Get(LocalPlayer)
	if not playerState then return end

	local finishTime = playerState:Get("FuseMachine.FinishTime")
	local fuseMachineModel = workspace:FindFirstChild("FuseMachine")

	if not fuseMachineModel then return end

	local countdownLabel = fuseMachineModel.Overhead.BillboardGui.Countdown
	if not countdownLabel then return end

	if not finishTime then
		local odds = playerState:Get("FuseMachine.OutputRarityOdds")
		local maxRarityName = "Common"

		if odds then
			for rarityName, chance in odds do
				print(Rarities[rarityName].Weight, Rarities[maxRarityName].Weight, rarityName)
				if chance > 0 and Rarities[maxRarityName].Weight < Rarities[rarityName].Weight then
					maxRarityName = rarityName
				end
			end

			TimeLabel.Text = `Fusion Time (<font color="#ffff00">{TimeUtils:E(FuseMachineData.FuseTime[maxRarityName])}</font>)`
		else
			TimeLabel.Text = `Fusion Time (<font color="#ffff00">0s</font>)`
		end

		local slots = playerState:Get("FuseMachine.Slots")
		local count = 0
		if slots then
			for i = 1, FuseMachineData.FuseSlots do
				if type(slots[i]) == "table" then
					count += 1
				end
			end
		end
		countdownLabel.Text = `{count}/{FuseMachineData.FuseSlots}`
	else
		local timeLeft = finishTime - workspace:GetServerTimeNow()
		if timeLeft < 0 then
			TimeLabel.Text = `Fusion Time (<font color="#ffff00">0s</font>)`
			countdownLabel.Text = "READY"
			return
		end

		local formattedTime = TimeUtils:E(timeLeft)
		TimeLabel.Text = `Fusion Time (<font color="#ffff00">{formattedTime}</font>)`
		countdownLabel.Text = formattedTime
	end
end

local function updateUI()
	task.spawn(setupBrainrots)
	task.spawn(updateBuyButton)
	task.spawn(updateOdds)
	task.spawn(updateTimer)
end

function module.Start()
	mainTrove = InterfaceController:Register("FuseMachine", FuseMachineUI, "TopQuint")
	mainTrove:AttachCloseButton(CloseButton)
	mainTrove:Close()

	Synchronizer:WaitAndCall(LocalPlayer, function(playerState)
		playerState:OnChanged("FuseMachine", updateUI)
		playerState:OnChanged("FuseMachine.Cost", updateUI)
		playerState:OnChanged("FuseMachine.OutputRarityOdds", updateUI)
		task.spawn(updateUI)
	end)

	Timer.Simple(1, function()
		updateTimer()
		updateBuyButton()
	end)

	Observers.observeTag("FuseMachinePrompt", function(prompt)
		local promptTrove = Trove.new()

		local function updatePrompt()
			local playerState = Synchronizer:Wait(LocalPlayer)
			if not playerState then return end

			local startTime = playerState:Get("FuseMachine.StartTime")
			local finishTime = playerState:Get("FuseMachine.FinishTime")

			if finishTime and finishTime ~= 0 and finishTime <= workspace:GetServerTimeNow() then
				prompt.ActionText = "Claim"
			elseif startTime and startTime ~= 0 then
				prompt.ActionText = "Reveal Now"
			else
				prompt.ActionText = "Fuse Machine"
			end
		end

		promptTrove:Add(task.spawn(function()
			local playerState = Synchronizer:Wait(LocalPlayer)
			if not playerState then return end

			playerState:OnChanged("FuseMachine", updatePrompt)
			playerState:OnChanged("FuseMachine.Cost", updatePrompt)
			playerState:OnChanged("FuseMachine.OutputRarityOdds", updatePrompt)
			promptTrove:Add(Timer.Simple(1, updatePrompt))
			task.spawn(updatePrompt)
		end))

		promptTrove:Add(prompt.Triggered:Connect(function()
			local playerState = Synchronizer:Get(LocalPlayer)
			if not playerState then return end

			local startTime = playerState:Get("FuseMachine.StartTime")
			local finishTime = playerState:Get("FuseMachine.FinishTime")

			if finishTime and finishTime ~= 0 and finishTime <= workspace:GetServerTimeNow() then
				local s, q = pcall(function()
					return FuseMachineData.Remotes.ClaimBrainrot:InvokeServer()
				end)
				warn(s, q)
			elseif startTime and startTime ~= 0 then
				--FuseMachineData.Remotes.RevealNow:InvokeServer()
			else
				InterfaceController:Toggle("FuseMachine")
			end
		end))

		return function()
			promptTrove:Destroy()
		end
	end)

	Observers.observeTag("FuseMachine", function(machineModel)
		local machineTrove = Trove.new()
		for _, hitbox in machineModel.Hitboxes:GetChildren() do
			machineTrove:Add(hitbox.Touched:Connect(function(otherPart)
				if otherPart.Name ~= "HumanoidRootPart" then return end
				local player = Players:GetPlayerFromCharacter(otherPart.Parent)
				if not player or player ~= LocalPlayer then return end

				--if player:GetAttribute("StealingIndex") then
				local success = FuseMachineData["Remotes"].Delivery:InvokeServer(hitbox)
				if not success then return end

				task.spawn(function()
					--	SoundController:PlaySound(ReplicatedStorage.Sounds.Sfx["Fuse Machine"].Deposit)
				end)

				local fuseMachineModel = workspace:FindFirstChild("FuseMachine")
				if fuseMachineModel then
					VFX.emit(fuseMachineModel.Vfx.emitfuse)
				end

				updateUI()
				---end
			end))
		end

		return function()
			machineTrove:Destroy()
		end
	end)

	FuseMachineData.Remotes.FuseAnimation.OnClientEvent:Connect(function(data)
		local machineModel = workspace:FindFirstChild("FuseMachine")
		if not machineModel then return end

		local animationTrove = Trove.new()

		local door = machineModel.Door
		local animator = door.AnimationController.Animator

		local doorOpenAnim = animator:LoadAnimation(ReplicatedStorage.Animations.FuseMachine.DoorOpen)
		local doorCloseAnim = animator:LoadAnimation(ReplicatedStorage.Animations.FuseMachine.DoorClose)
		local leverMoveAnim = animator:LoadAnimation(ReplicatedStorage.Animations.FuseMachine.LeverMove)

		animationTrove:Add(function()
			doorOpenAnim:Stop()
			doorOpenAnim:Destroy()
			doorCloseAnim:Stop()
			doorCloseAnim:Destroy()
			leverMoveAnim:Stop()
			leverMoveAnim:Destroy()
		end)

		local animalData = Animals[data.Index]
		leverMoveAnim:Play()
		task.delay(1, function()
			leverMoveAnim:AdjustSpeed(0)
		end)

		task.spawn(function()
			local raritySound = ReplicatedStorage.Sounds.Sfx["Fuse Machine"]:FindFirstChild(animalData.Rarity)
			if raritySound then
				SoundController:PlaySound(raritySound, machineModel:GetPivot().Position)
			end
		end)

		doorOpenAnim:Play()
		animationTrove:Add(doorOpenAnim:GetMarkerReachedSignal("Freeze"):Once(function()
			doorOpenAnim:AdjustSpeed(0)
		end))

		local rarityVFX = machineModel.Vfx:FindFirstChild(animalData.Rarity)
		if rarityVFX then
			VFX.enable(rarityVFX)
		end

		task.wait(3)

		VFX.disable(rarityVFX)
		task.wait(1)

		leverMoveAnim:AdjustSpeed(-1)
		doorCloseAnim:Play()
		doorCloseAnim.Stopped:Wait()
		doorOpenAnim:Stop()
		task.wait(2)

		animationTrove:Destroy()
	end)
end

function module.Destroy()
	if mainTrove then
		mainTrove:Destroy()
	end
end

return module