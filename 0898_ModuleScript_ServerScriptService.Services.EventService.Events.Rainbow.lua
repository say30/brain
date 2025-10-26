--[[
  Extracted from: ServerScriptService.Services.EventService.Events.Rainbow
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

local Net = require(ReplicatedStorage.Packages.Net)
local Rainbow = require(ReplicatedStorage.Controllers.EventController.Events.Rainbow)

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

	Rainbow.OnStart()
end

function Rainbow:Stop()
	if not self._active then return end
	self._active = false

	Rainbow.OnStop()
end

function Module:Load()
	Rainbow.OnLoad()
end

return Module