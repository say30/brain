--[[
  Extracted from: ServerScriptService.Services.CmdrService.Configuration
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local Configuration = {}
Configuration.__index = Configuration

local Players = game:GetService("Players")
local GroupService = game:GetService("GroupService")

export type ConfigurationType = {
	_authorizedUsers: {[number]: boolean},
	_authorizedGroups: {[number]: {rankRequired: number}},
	_settings: {[string]: any},

	new: () -> ConfigurationType,
	IsAuthorized: (self: ConfigurationType, player: Player) -> boolean,
	AddUser: (self: ConfigurationType, userId: number) -> (),
	RemoveUser: (self: ConfigurationType, userId: number) -> (),
	AddGroup: (self: ConfigurationType, groupId: number, rankRequired: number?) -> (),
	RemoveGroup: (self: ConfigurationType, groupId: number) -> (),
	SetSetting: (self: ConfigurationType, key: string, value: any) -> (),
	GetSetting: (self: ConfigurationType, key: string) -> any,
}

local DEFAULT_SETTINGS = {
	REQUIRE_AUTHORIZATION = true,

	GAME_OWNER_AUTHORIZED = true,

	ALLOW_GROUP_AUTHORIZATION = true,

	LOG_COMMANDS = true,
	ANNOUNCE_COMMAND_USAGE = false,

	ACTIVATION_KEYS = {Enum.KeyCode.F2, Enum.KeyCode.Quote},
	PLACE_NAME = "Admin Console",

	MAX_COMMAND_LENGTH = 1000,
	RATE_LIMIT_ENABLED = true,
	RATE_LIMIT_COMMANDS_PER_MINUTE = 30
}

local DEFAULT_AUTHORIZED_USERS = {
	[1011903140] = true, -- larpset
}

local DEFAULT_AUTHORIZED_GROUPS = {
}

function Configuration.new(): ConfigurationType
	local self = setmetatable({}, Configuration)

	self._authorizedUsers = {}
	self._authorizedGroups = {}
	self._settings = {}

	self:_loadDefaults()

	return self
end

function Configuration:IsAuthorized(player: Player): boolean
	if not self:GetSetting("REQUIRE_AUTHORIZATION") then
		return true
	end

	if self:GetSetting("GAME_OWNER_AUTHORIZED") and player.UserId == game.CreatorId then
		return true
	end

	if self._authorizedUsers[player.UserId] then
		return true
	end

	if self:GetSetting("ALLOW_GROUP_AUTHORIZATION") then
		for groupId, groupData in pairs(self._authorizedGroups) do
			local success, rank = pcall(function()
				return player:GetRankInGroup(groupId)
			end)

			if success and rank >= groupData.rankRequired then
				return true
			end
		end
	end

	return false
end

function Configuration:AddUser(userId: number)
	if type(userId) ~= "number" then
		error("Configuration: UserId must be a number!")
	end

	self._authorizedUsers[userId] = true
end

function Configuration:RemoveUser(userId: number)
	if type(userId) ~= "number" then
		error("Configuration: UserId must be a number!")
	end

	self._authorizedUsers[userId] = nil
end

function Configuration:AddGroup(groupId: number, rankRequired: number?)
	if type(groupId) ~= "number" then
		error("Configuration: GroupId must be a number!")
	end

	rankRequired = rankRequired or 1

	self._authorizedGroups[groupId] = {
		rankRequired = rankRequired
	}
end

function Configuration:RemoveGroup(groupId: number)
	if type(groupId) ~= "number" then
		error("Configuration: GroupId must be a number!")
	end

	self._authorizedGroups[groupId] = nil
end

function Configuration:SetSetting(key: string, value: any)
	if type(key) ~= "string" then
		error("Configuration: Setting key must be a string!")
	end

	self._settings[key] = value
end

function Configuration:GetSetting(key: string): any
	if type(key) ~= "string" then
		error("Configuration: Setting key must be a string!")
	end

	return self._settings[key]
end

function Configuration:_loadDefaults()
	for key, value in pairs(DEFAULT_SETTINGS) do
		self._settings[key] = value
	end

	for userId, authorized in pairs(DEFAULT_AUTHORIZED_USERS) do
		if authorized then
			self._authorizedUsers[userId] = true
		end
	end

	for groupId, groupData in pairs(DEFAULT_AUTHORIZED_GROUPS) do
		self._authorizedGroups[groupId] = groupData
	end
end

function Configuration:GetAuthorizedUsers(): {[number]: boolean}
	return self._authorizedUsers
end

function Configuration:GetAuthorizedGroups(): {[number]: {rankRequired: number}}
	return self._authorizedGroups
end

function Configuration:GetAllSettings(): {[string]: any}
	return self._settings
end

return Configuration 