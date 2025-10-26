--[[
  Extracted from: ServerScriptService.Services.SoftShutdownService
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local SoftShutdown = {}
SoftShutdown.__index = SoftShutdown

function SoftShutdown.new()
	local self = setmetatable({}, SoftShutdown)
	self.CheckInterval = 10
	self.Running = false
	return self
end

function SoftShutdown:HandleShutdown()
	if (game.VIPServerId ~= "" and game.VIPServerOwnerId == 0) then
		local waitTime = 30

		Players.PlayerAdded:Connect(function(player)
			task.wait(waitTime)
			waitTime = waitTime / 2
			TeleportService:Teleport(game.PlaceId, player)
		end)

		for _, player in ipairs(Players:GetPlayers()) do
			TeleportService:Teleport(game.PlaceId, player)
			task.wait(waitTime)
			waitTime = waitTime / 2
		end
	else
		game:BindToClose(function()
			if #Players:GetPlayers() == 0 then
				return
			end

			if RunService:IsStudio() then
				return
			end

			local reservedServerCode = TeleportService:ReserveServer(game.PlaceId)

			for _, plr in ipairs(Players:GetPlayers()) do
				TeleportService:TeleportToPrivateServer(game.PlaceId, reservedServerCode, { plr })
			end

			Players.PlayerAdded:Connect(function(plr)
				TeleportService:TeleportToPrivateServer(game.PlaceId, reservedServerCode, { plr })
			end)

			while #Players:GetPlayers() > 0 do
				task.wait(1)
			end
		end)
	end
end

function SoftShutdown:Start()
	if self.Running then return end
	self.Running = true

	task.spawn(function()
		while self.Running do
			if RunService:IsServer() then
				self:HandleShutdown()
			end
			task.wait(self.CheckInterval)
		end
	end)
end

return SoftShutdown