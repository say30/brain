--[[
  Extracted from: ServerScriptService.Services.CommandsService
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Net = require(ReplicatedStorage.Packages.Net)
local Conch = require(ReplicatedStorage.Packages.Conch)
local Config = require(script.Config)
local Permissions = require(script.Methods.ConsolePermissions)
local Players = game:GetService("Players")

local CommandsService = {}
CommandsService.__index = CommandsService

local DEBUG = false

function CommandsService.new()
	local self = setmetatable({}, CommandsService)
	self:_setupRemoteFunctions()

	task.spawn(function()
		local waited = 0
		while not (Conch.console and Conch.console.commands and Conch.console.commands["clear"]) and waited < 5 do
			task.wait(0.1)
			waited += 0.1
		end
		self:_loadCommandModules()
	end)

	self:_connectPlayerJoin()
	return self
end

function CommandsService:_setupRemoteFunctions()
	Net:Handle("CommandsService/ViewCommands", function(player)
		local allowed = Permissions.hasPermission(player)
		if DEBUG then
			print(string.format("[CommandsService] ViewCommands invoked by %s | allowed=%s", player.Name, tostring(allowed)))
		end
		if allowed then
			local user = Conch.get_user(player)
			if user then
				Conch.give_roles(user, "super-user")
				task.delay(0.25, function()
					if DEBUG then
						print("[CommandsService] Marking user.dirty after ViewCommands (", player.Name, ")")
					end
					user.dirty = true
				end)
			end

			local snapshot = {}
			for name, cmd in pairs(Conch.console.commands) do
				if Permissions.hasPermission(player) or Conch._.has_permissions(Conch.get_user(player), unpack(cmd.permissions)) then
					table.insert(snapshot, {
						name = cmd.name,
						description = cmd.description,
						permissions = cmd.permissions,
						arguments = cmd.arguments,
					})
				end
			end
			return snapshot
		end
		return nil
	end)
end

function CommandsService:_connectPlayerJoin()
	local function giveRole(player)
		task.spawn(function()
			while player.Parent and not Permissions.hasPermission(player) do
				task.wait(1)
			end

			if not player.Parent then
				return
			end

			if DEBUG then
				print(string.format("[CommandsService] %s authorised", player.Name))
			end

			local user
			while player.Parent do
				user = Conch.get_user(player)
				if user then break end
				task.wait(0.1)
			end

			if not user then
				warn("[CommandsService] Failed to obtain Conch user for", player)
				return
			end

			Conch.give_roles(user, "super-user")

			if DEBUG then
				print(string.format("[CommandsService] super-user role given to %s", player.Name))
			end

			task.delay(0.25, function()
				if DEBUG then
					print(string.format("[CommandsService] Marking user.dirty after role assignment (%s)", player.Name))
				end
				if user then
					user.dirty = true
				end
			end)
		end)
	end

	for _, plr in ipairs(Players:GetPlayers()) do
		giveRole(plr)
	end

	Players.PlayerAdded:Connect(giveRole)
end

function CommandsService:_loadCommandModules()
	local cmdsFolder = script:FindFirstChild("Commands")
	if not cmdsFolder then
		warn("[CommandsService] No Commands folder found – no commands loaded")
		return
	end

	for _, moduleScript in ipairs(cmdsFolder:GetChildren()) do
		if moduleScript:IsA("ModuleScript") then
			local ok, handler = pcall(require, moduleScript)
			if not ok then
				warn("[CommandsService] Failed to require command module", moduleScript:GetFullName(), handler)
			elseif type(handler) == "function" then
				local success, err = pcall(handler, Conch, Config)
				if not success then
					warn("[CommandsService] Command module error", moduleScript.Name, err)
				end
				if DEBUG then
					print("[CommandsService] Loaded command module", moduleScript.Name)
					for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
						local hadBefore = Conch.console and Conch.console.commands and Conch.console.commands[moduleScript.Name] ~= nil
						print(string.format("  └ replicate_to_player -> %s (command pre-existed=%s)", p.Name, tostring(hadBefore)))
					end
				end
			end
		end
	end

	for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
		local user = Conch.get_user(player)
		if user then
			user.dirty = true
			if DEBUG then
				print("[CommandsService] Marking dirty after modules loaded for", player.Name)
			end
		end
	end
end

return CommandsService.new() 