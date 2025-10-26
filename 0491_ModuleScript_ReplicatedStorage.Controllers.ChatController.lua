--[[
  Extracted from: ReplicatedStorage.Controllers.ChatController
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Packages = ReplicatedStorage:WaitForChild("Packages")
local Datas = ReplicatedStorage:WaitForChild("Datas")

local Net = require(Packages.Net)
local Timer = require(Packages.Timer).new(1)
local Synchronizer = require(Packages.Synchronizer)
local Tips = require(Datas.Tips)

local ChatEvent = Net:RemoteEvent("ChatService/ChatMessage")
local RBXSystem = TextChatService.TextChannels:WaitForChild("RBXSystem")

local ChatController = {
	SendMessage = function(_, Message)
		RBXSystem:DisplaySystemMessage(Message)
	end
}

ChatController.Start = function(_)
	local SettingsData = Synchronizer:Wait(Players.LocalPlayer)

	ChatEvent.OnClientEvent:Connect(function(...)
		ChatController:SendMessage(...)
	end)

	local LastTipTimes = {}

	Timer.Tick:Connect(function()
		for Index = 1, #Tips do
			local Tip = Tips[Index]
			local CurrentTime = os.clock()
			LastTipTimes[Index] = LastTipTimes[Index] or CurrentTime

			if CurrentTime - LastTipTimes[Index] >= Tip.ShowEvery and SettingsData:Get("Settings.Chat Tips") then
				LastTipTimes[Index] = CurrentTime
				ChatController:SendMessage(Tip.ChatMessage)
			end
		end
	end)

	Timer:Start()
end

return ChatController