--[[
  Extracted from: ServerScriptService.Services.CmdrService.Commands.CustomCommands.announceServer
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local TextService = game:GetService("TextService")
local Players = game:GetService("Players")
local MessagingService = game:GetService("MessagingService")
local Chat = game:GetService("Chat")

local Net = require(game.ReplicatedStorage.Packages.Net)
local NotificationEvent = Net:RemoteEvent("NotificationService/Notify")

MessagingService:SubscribeAsync("GlobalAnnouncement", function(message)
	local data = message.Data
	for _, player in ipairs(Players:GetPlayers()) do
		NotificationEvent:FireClient(player, data.Text, 5,nil,"Top")
	end
end)

return function(context, text)
	local fromUserId = context.Executor.UserId
	local fromUserName = context.Executor.Name
	MessagingService:PublishAsync("GlobalAnnouncement", {
		Text = text,
		FromUserId = fromUserId,
		FromUserName = fromUserName
	})
	return "Sent global announcement."
end
