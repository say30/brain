--[[
  Extracted from: ServerScriptService.Services.EventService.Events.Starfall
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

local Net = require(ReplicatedStorage.Packages.Net)
local Concert = require(ReplicatedStorage.Controllers.EventController.Events.Starfall)

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

	Concert.OnStart()
end

function Concert:Stop()
	if not self._active then return end
	self._active = false

	Concert.OnStop()
end

function Module:Load()
	Concert.OnLoad()
end

return Module