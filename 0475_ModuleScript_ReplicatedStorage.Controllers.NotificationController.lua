--[[
  Extracted from: ReplicatedStorage.Controllers.NotificationController
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local GuiService = game:GetService("GuiService")

local Packages = ReplicatedStorage:WaitForChild("Packages")
local Net = require(Packages.Net)

local Controllers = ReplicatedStorage:WaitForChild("Controllers")
local SoundController = require(Controllers.SoundController)

local PlayerGui = Players.LocalPlayer.PlayerGui
local NotificationGui = PlayerGui:WaitForChild("Notification").Notification
local NotificationTemplate = NotificationGui.Template

local NotificationRemote = Net:RemoteEvent("NotificationService/Notify")
local TweenInfoLinear = TweenInfo.new(1, Enum.EasingStyle.Linear)

local NotificationService = {}

function NotificationService:Error(message)
	self:Notify(("<font color=\"#FA0103\">%*</font>"):format(message), 5, "Sounds.Sfx.Error")
end

function NotificationService:Success(message)
	self:Notify(("<font color=\"#92FF67\">%*</font>"):format(message), 5, "Sounds.Sfx.Success")
end

function NotificationService:Notify(message, duration, soundId, position)
	task.spawn(function()
		duration = duration or 5
		local clone = NotificationTemplate:Clone()
		clone.Text = message

		if soundId then
			SoundController:PlaySound(soundId)
		end

		clone.Visible = true

		local parentGui
		if position == "Top" then
			parentGui = PlayerGui:WaitForChild("TopNotification").TopNotification
		else
			parentGui = NotificationGui
		end

		clone.Parent = parentGui

		task.wait(duration)

		local tweenText = TweenService:Create(clone, TweenInfoLinear, { TextTransparency = 1 })
		local tweenStroke = TweenService:Create(clone.UIStroke, TweenInfoLinear, { Transparency = 1 })
		tweenStroke:Play()
		tweenText:Play()

		tweenText.Completed:Once(function()
			clone:Destroy()
		end)
	end)
end

function NotificationService:Start()
	NotificationRemote.OnClientEvent:Connect(function(...)
		self:Notify(...)
	end)

	local function updateTopNotificationPosition()
		PlayerGui:WaitForChild("TopNotification").TopNotification.Position = UDim2.fromScale(0.5, 0.075) + UDim2.fromOffset(0, GuiService.TopbarInset.Height)
	end

	GuiService:GetPropertyChangedSignal("TopbarInset"):Connect(updateTopNotificationPosition)
	updateTopNotificationPosition()
end

return NotificationService