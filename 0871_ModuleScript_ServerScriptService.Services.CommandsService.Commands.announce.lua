--[[
  Extracted from: ServerScriptService.Services.CommandsService.Commands.announce
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local MessagingService = game:GetService("MessagingService")

local Net = require(ReplicatedStorage.Packages.Net)
local Conch = require(ReplicatedStorage.Packages.Conch)

local NotificationEvent = Net:RemoteEvent("NotificationService/Notify")
local CHANNEL = "b82db150-528f-4042-a0b5-ad6aaf1a5c33"

MessagingService:SubscribeAsync(CHANNEL, function(message)
	local data = message.Data
	if not data or not data.Text then
		return
	end

	for _, player in ipairs(Players:GetPlayers()) do
		NotificationEvent:FireClient(player, data.Text, 5, nil, "Top")
	end
end)

local module = function(_, Config)
	Conch.register("announce", {
		permissions = { Config.RequiredRole or "super-user" },
		arguments = function()
			return {
				kind = "argument",
				type = "string",
				name = "text",
			}
		end,
		callback = function(text)
			if not text or text == "" then
				return false, "You must provide announcement text"
			end

			MessagingService:PublishAsync(CHANNEL, { Text = text })
			return "announced"
		end,
	})
end

return module
