--[[
  Extracted from: ServerScriptService.Services.Tips
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")

local Data = ReplicatedStorage.Datas
local TipsData = require(Data.Tips)

local TipsHandler = {}
TipsHandler.__index = TipsHandler

function TipsHandler.new()
	local self = setmetatable({}, TipsHandler)

	self._tips = TipsData
	self._timers = {}

	self:_setupPlayerEvents()
	self:_startTipCycles()

	return self
end

function TipsHandler:_setupPlayerEvents()
	Players.PlayerAdded:Connect(function(player)
		self:_startPlayerTipCycle(player)
	end)

	Players.PlayerRemoving:Connect(function(player)
		self:_stopPlayerTipCycle(player)
	end)

	for _, player in ipairs(Players:GetPlayers()) do
		task.spawn(function()
			self:_startPlayerTipCycle(player)
		end)
	end
end

function TipsHandler:_startTipCycles()
	for _, tip in ipairs(self._tips) do
		task.spawn(function()
			while true do
				task.wait(tip.ShowEvery)
				for _, player in ipairs(Players:GetPlayers()) do
					self:_showTip(player, tip.ChatMessage)
				end
			end
		end)
	end
end

function TipsHandler:_startPlayerTipCycle(player)
	local timers = {}
	for index, tip in ipairs(self._tips) do
		timers[index] = task.spawn(function()
			while true do
				task.wait(tip.ShowEvery)
				self:_showTip(player, tip.ChatMessage)
			end
		end)
	end
	self._timers[player.UserId] = timers
end

function TipsHandler:_stopPlayerTipCycle(player)
	local timers = self._timers[player.UserId]
	if timers then
		for _, timer in pairs(timers) do
			task.cancel(timer)
		end
		self._timers[player.UserId] = nil
	end
end

function TipsHandler:_showTip(player, message)
	local success, err = pcall(function()
		local chatChannel = TextChatService.TextChannels.RBXGeneral
		if chatChannel then
			chatChannel:DisplaySystemMessage(message)
		end
	end)
	
	if not success then
	--	warn("[TipsHandler] Failed to send tip to " .. player.Name .. ": " .. tostring(err))
	end
end

return TipsHandler