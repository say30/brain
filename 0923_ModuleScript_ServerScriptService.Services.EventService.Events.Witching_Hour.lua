--[[
  Extracted from: ServerScriptService.Services.EventService.Events.Witching Hour
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

local Net = require(ReplicatedStorage.Packages.Net)
local WitchingHour = require(ReplicatedStorage.Controllers.EventController.Events["Witching Hour"])

local Module = {}
Module.__index = Module

function Module.new(eventService)
	local self = setmetatable({}, Module)
	self._eventService = eventService
	self._active = false
	return self
end

function Module:Start(eventData)
	if self._active then return end
	self._active = true

	self._eventData = eventData or {}

	WitchingHour.OnStart()
end

function Module:Stop()
	if not self._active then return end
	self._active = false

	WitchingHour.OnStop()
end

function Module:Load()
	WitchingHour.OnLoad()
end

return Module
-- adding traits 