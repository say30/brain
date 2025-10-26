--[[
  Extracted from: ServerScriptService.Services.AdminPanelService
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")

local Net = require(ReplicatedStorage.Packages.Net)
local AdminCommands = require(ReplicatedStorage.Datas.AdminCommands)
local DataManagement = require(ServerScriptService.Services.DataManagment)

local ADMIN_GAMEPASS_NAME = "Admin Commands"

local AdminPanelService = {}
AdminPanelService.__index = AdminPanelService

local playerCooldowns = {}

function AdminPanelService.new()
	local self = setmetatable({}, AdminPanelService)

	self._placeCooldownEvent = Net:RemoteEvent("AdminPanelService/PlaceCooldownFromChat")
	self._executeCommandEvent = Net:RemoteEvent("AdminPanelService/ExecuteCommand")
	self._dealWithThisEvent = Net:RemoteEvent("AdminPanelService/DealWithThis")
	self._openUIEvent = Net:RemoteEvent("AdminPanelService/OpenUI")

	self._commandModules = {
		jail = require(script.CommandModules.JailCommand),
		morph = require(script.CommandModules.MorphCommand),
		ragdoll = require(script.CommandModules.RagdollCommand),
		rocket = require(script.CommandModules.RocketCommand),
		tiny = require(script.CommandModules.TinyCommand),
		control = require(script.CommandModules.ControlCommand),
		balloon = require(script.CommandModules.BalloonCommand)
	}

	self:_setupEventHandlers()
	self:_setupPlayerHandlers()
	self:_setupPlayerCleanup()

return self
end

function AdminPanelService:_hasAdminAccess(player: Player): boolean
	if not DataManagement.isDataReady(player) then
		return false
	end

	return DataManagement.hasGamepass(player, ADMIN_GAMEPASS_NAME)
end

function AdminPanelService:_setAdminAttribute(player: Player)
	if self:_hasAdminAccess(player) then
		player:SetAttribute("AdminCommands", true)
	else
		player:SetAttribute("AdminCommands", false)
	end
end

function AdminPanelService:_isOnCooldown(player: Player, commandName: string): boolean
	local playerId = tostring(player.UserId)
	local playerCooldownData = playerCooldowns[playerId]

	if not playerCooldownData then
		return false
	end

	local expireTime = playerCooldownData[commandName]
	if not expireTime then
		return false
	end

	return tick() < expireTime
end

function AdminPanelService:_setCooldown(player: Player, commandName: string, duration: number)
	local playerId = tostring(player.UserId)

	if not playerCooldowns[playerId] then
		playerCooldowns[playerId] = {}
	end

	playerCooldowns[playerId][commandName] = tick() + duration
end

function AdminPanelService:_setupEventHandlers()
	self._executeCommandEvent.OnServerEvent:Connect(function(executor: Player, targetPlayer: Player, commandName: string)
		if not self:_hasAdminAccess(executor) then
			warn("[AdminPanelService] Non-admin player attempted to execute command:", executor.Name)
			return
		end

		if not targetPlayer or not targetPlayer.Parent then
			warn("[AdminPanelService] Invalid target player for command:", commandName)
			return
		end

		local command = AdminCommands[commandName]
		if not command then
			warn("[AdminPanelService] Unknown command:", commandName)
			return
		end

		if self:_isOnCooldown(executor, commandName) then
			warn("[AdminPanelService] Command", commandName, "is on cooldown for player:", executor.Name)
			return
		end

		if commandName == "control" and executor == targetPlayer then
			local notificationEvent = Net:RemoteEvent("NotificationService/Notify")
			notificationEvent:FireClient(executor, '<font color="#FA0103">You can\'t run this command on yourself!</font>', 5, "Sounds.Sfx.Error")
			return
		end

		self:_setCooldown(executor, commandName, command.cooldown)
		self._placeCooldownEvent:FireClient(executor, commandName)

		local notificationEvent = Net:RemoteEvent("NotificationService/Notify")
		notificationEvent:FireClient(executor, string.format('<font color="#92FF67">Successfully executed "%s" on %s!</font>', commandName, targetPlayer.Name), 5, "Sounds.Sfx.Success")
		notificationEvent:FireClient(targetPlayer, string.format('%s ran "%s" on you! %s', executor.Name, commandName, command.description), 5)

		if self._commandModules[commandName] then
			self._commandModules[commandName]:Execute(executor, targetPlayer)
		end

		if command.effects then
			if command.effects.Victim then
				self._dealWithThisEvent:FireClient(targetPlayer, commandName, "Victim", targetPlayer)
			end

			if command.effects.Executor then
				self._dealWithThisEvent:FireClient(executor, commandName, "Executor", targetPlayer)
			end
		end
	end)
end

function AdminPanelService:_setupPlayerHandlers()
	Players.PlayerAdded:Connect(function(player)
		task.spawn(function()
			while not DataManagement.isDataReady(player) and player.Parent do
				task.wait(1)
			end

			if player.Parent then
				self:_setAdminAttribute(player)
			end
		end)
	end)

	for _, player in pairs(Players:GetPlayers()) do
		task.spawn(function()
			while not DataManagement.isDataReady(player) and player.Parent do
				task.wait(1)
			end

			if player.Parent then
				self:_setAdminAttribute(player)
			end
		end)
	end
end

function AdminPanelService:OpenAdminPanel(player: Player)
	if not self:_hasAdminAccess(player) then
		warn("[AdminPanelService] Player", player.Name, "does not have admin access")
		return
	end

	self._openUIEvent:FireClient(player)
end

function AdminPanelService:HasAdminAccess(player: Player): boolean
	return self:_hasAdminAccess(player)
end

function AdminPanelService:RefreshAdminStatus(player: Player)
	self:_setAdminAttribute(player)
end

function AdminPanelService:_setupPlayerCleanup()
	Players.PlayerRemoving:Connect(function(player)
		local playerId = tostring(player.UserId)
		playerCooldowns[playerId] = nil
	end)
end

local adminPanelService = AdminPanelService.new()

_G.OpenAdminPanel = function(player: Player)
	adminPanelService:OpenAdminPanel(player)
end

return adminPanelService