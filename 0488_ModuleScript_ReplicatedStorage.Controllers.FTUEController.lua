--[[
  Extracted from: ReplicatedStorage.Controllers.FTUEController
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Packages = ReplicatedStorage:WaitForChild("Packages")
local Synchronizer = require(Packages.Synchronizer)
local Trove = require(Packages.Trove)
local Net = require(Packages.Net)
local Controllers = ReplicatedStorage:WaitForChild("Controllers")
local AnimalController = require(Controllers.AnimalController)
local _ = require(Controllers.NotificationController)
local PlotController = require(Controllers.PlotController)
local Cleanup = Trove.new()
local LocalPlayer = Players.LocalPlayer
local TextLabel = LocalPlayer.PlayerGui:WaitForChild("Main").Tutorial.TextLabel
local FinishTutorial = Net:RemoteEvent("FinishTutorial")

local Module = {}

--[[

local CashCollected = Net:RemoteEvent("PlotService/CashCollected")

local function Setup(Data)
	local function HideLabel()
		TextLabel.Visible = false
	end

	local TutorialStarted = false
	local TutorialFinished = false

	local function UpdateTutorial()
		task.wait(0.5)
		local HumanoidRootPart = (LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart", 5)
		if not HumanoidRootPart then return end

		TextLabel.Visible = false
		Cleanup:Clean()

		if Data:Get("TutorialFinished") == true then
			TutorialFinished = true
			if TutorialStarted then
				TutorialStarted = false
				TextLabel.Text = "Steal Brainrots from other players and bring them back to your base!"
				TextLabel.Visible = true
				task.delay(10, HideLabel)
			end
			Cleanup:Destroy()
			return
		end

		TutorialStarted = true
		local HasAnimal, AnimalIndex = AnimalController:HasAnimal("Noobini Pizzanini")

		if HasAnimal then
			local MyPlot = PlotController:GetMyPlot()
			if MyPlot then
				local AnimalPodiums = MyPlot.PlotModel:WaitForChild("AnimalPodiums", 5)
				if not AnimalPodiums then
					warn("AnimalPodiums not found in plot model during tutorial")
					return
				end

				local Podium = AnimalPodiums:FindFirstChild(AnimalIndex[1])
				if not Podium then
					warn("Podium not found for animal index", AnimalIndex[1])
					return
				end

				local ClaimMain = Podium.Claim.Main
				local Arrow = script.TutorialArrow:Clone()
				Arrow.Parent = workspace
				Arrow.Start.CFrame = HumanoidRootPart.CFrame

				local Weld1 = Instance.new("WeldConstraint", Arrow.Start)
				Weld1.Part0 = HumanoidRootPart
				Weld1.Part1 = Arrow.Start

				Arrow.End.CFrame = ClaimMain.CFrame

				local Weld2 = Instance.new("WeldConstraint", Arrow.End)
				Weld2.Part0 = ClaimMain
				Weld2.Part1 = Arrow.End

				Cleanup:Add(Arrow)
			end

			TextLabel.Text = "Go collect your cash!"
			TextLabel.Visible = true

			Cleanup:Add(CashCollected.OnClientEvent:Connect(function()
				FinishTutorial:FireServer()
			end))

			Cleanup:Add(Data:OnChanged("AnimalAddedOrRemoved", UpdateTutorial))
			return
		end

		local MovingAnimal = AnimalController:HasAnimalMovingToBase("Noobini Pizzanini")
		if MovingAnimal then
			local UID = MovingAnimal.UID
			TextLabel.Text = ("Wait for %s to reach your base!"):format("Noobini Pizzanini")
			TextLabel.Visible = true

			Cleanup:Add(MovingAnimal.Instance.PrimaryPart.PromptAttachment.ProximityPrompt:GetAttributeChangedSignal("TargetPlayer"):Connect(UpdateTutorial))
			Cleanup:Add(AnimalController.OnAnimalDestroyed:Connect(function(ID)
				if UID ~= ID then return end
				UpdateTutorial()
			end))
			Cleanup:Add(AnimalController.OnFollowingChanged:Connect(function(Name)
				if Name == "Noobini Pizzanini" then
					UpdateTutorial()
				end
			end))
			return
		end

		local WildAnimal = AnimalController:HasAnimalInRoadWithoutTarget("Noobini Pizzanini")
		if WildAnimal then
			local UID = WildAnimal.UID
			local Arrow = script.TutorialArrow:Clone()
			Arrow.Parent = workspace
			Arrow.Start.CFrame = HumanoidRootPart.CFrame

			local Weld1 = Instance.new("WeldConstraint", Arrow.Start)
			Weld1.Part0 = HumanoidRootPart
			Weld1.Part1 = Arrow.Start

			Arrow.End.CFrame = WildAnimal.AnimalModel.PrimaryPart.CFrame

			local Weld2 = Instance.new("WeldConstraint", Arrow.End)
			Weld2.Part0 = WildAnimal.AnimalModel.PrimaryPart
			Weld2.Part1 = Arrow.End

			TextLabel.Text = ("Go buy a %s"):format("Noobini Pizzanini")
			TextLabel.Visible = true

			Cleanup:Add(Arrow)
			Cleanup:Add(AnimalController.OnAnimalDestroyed:Connect(function(ID)
				if UID ~= ID then return end
				UpdateTutorial()
			end))
			Cleanup:Add(WildAnimal.Instance.PrimaryPart.PromptAttachment.ProximityPrompt:GetAttributeChangedSignal("TargetPlayer"):Connect(UpdateTutorial))
			Cleanup:Add(AnimalController.OnFollowingChanged:Connect(function(Name)
				if Name == "Noobini Pizzanini" then
					UpdateTutorial()
				end
			end))
			return
		end

		Cleanup:Add(AnimalController.OnAnimalSpawn:Connect(UpdateTutorial))
	end

	if Data:Get("TutorialFinished") == true then
		return
	end

	LocalPlayer.CharacterAdded:Connect(UpdateTutorial)
	
	Data:OnChanged("TutorialFinished", UpdateTutorial, true)
end

Module.Start = function()
	Synchronizer:WaitAndCall(LocalPlayer, Setup)
end

return Module

]]

Module.Start = function()
	Synchronizer:WaitAndCall(LocalPlayer, function(Data)
		if Data:Get("TutorialFinished") ~= true then
			FinishTutorial:FireServer()
		end
	end)
end

return Module
