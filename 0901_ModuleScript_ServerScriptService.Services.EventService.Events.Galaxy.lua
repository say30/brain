--[[
  Extracted from: ServerScriptService.Services.EventService.Events.Galaxy
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

local Net = require(ReplicatedStorage.Packages.Net)
local Galaxy = require(ReplicatedStorage.Controllers.EventController.Events.Galaxy)

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

	ReplicatedStorage:SetAttribute("GalaxyEvent", true)
	ReplicatedStorage:SetAttribute("GalaxyEventLastTime", os.time())

	Galaxy.OnStart()
end

function Module:Stop()
	if not self._active then return end
	self._active = false

	Galaxy.OnStop()
	ReplicatedStorage:SetAttribute("GalaxyEvent", false)
end

function Module:Load()
	Galaxy.OnLoad()
end

return Module
