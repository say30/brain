--[[
  Extracted from: ServerScriptService.Services.CmdrService.Commands.CustomCommands.pushserverluckServer
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local MessagingService = game:GetService("MessagingService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Net = require(ReplicatedStorage.Packages.Net)
local NotificationEvent = Net:RemoteEvent("NotificationService/Notify")

MessagingService:SubscribeAsync("ServerLuckGlobal", function(message)
	local data = message.Data
	if data.FromServer == game.JobId then return end
	local currentTime = workspace:GetServerTimeNow()
	local endTime = currentTime + data.Duration
	ReplicatedStorage:SetAttribute("ServerLuckMultiplier", data.Multiplier)
	ReplicatedStorage:SetAttribute("ServerLuckEndTime", endTime)
	for _, player in pairs(Players:GetPlayers()) do
		NotificationEvent:FireClient(player, string.format("🍀 Server Luck globally set to %dx for %d seconds!", data.Multiplier, data.Duration), 5)
	end
end)

return function(context, multiplier, duration, scope)
	multiplier = tonumber(multiplier)
	duration = tonumber(duration)
	if not multiplier or not duration then
		return "Invalid multiplier or duration."
	end
	scope = scope and scope:lower() or "local"
	local currentTime = workspace:GetServerTimeNow()
	local endTime = currentTime + duration
	ReplicatedStorage:SetAttribute("ServerLuckMultiplier", multiplier)
	ReplicatedStorage:SetAttribute("ServerLuckEndTime", endTime)
	for _, player in pairs(Players:GetPlayers()) do
		NotificationEvent:FireClient(player, string.format("🍀 Server Luck locally set to %dx for %d seconds!", multiplier, duration), 5)
	end
	if scope == "global" then
		MessagingService:PublishAsync("ServerLuckGlobal", {
			Multiplier = multiplier,
			Duration = duration,
			FromServer = game.JobId
		})
		return string.format("Server luck set to %dx for %d seconds.", multiplier, duration)
	end
	return string.format("Server luck set to %dx for %d seconds.", multiplier, duration)
end
