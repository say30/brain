--[[
  Extracted from: ServerScriptService.Services.EventService.Events.Phase 5: Sammy Snap
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

local Net = require(ReplicatedStorage.Packages.Net)

local Module = {}
Module.__index = Module

function Module.new(eventService)
	local self = setmetatable({}, Module)
	self._eventService = eventService
	self._active = false
	self._runningEvents = {}
	return self
end

function Module:Start(eventData)
	if self._active then return end
	self._active = true
	self._eventData = eventData or {}

	local svc = self._eventService

	local events = svc.GetAllEvents and svc:GetAllEvents() or svc.Events
	if not events then
		warn("[Phase5SammySnapEvent] No events available")
		return
	end

	local validEvents = {}
	for _, eventName in ipairs(events) do
		if not string.find(eventName, "Phase") then
			table.insert(validEvents, eventName)
		end
	end

	if #validEvents == 0 then
		warn("[Phase5SammySnapEvent] No valid events to start")
		return
	end

	local function shuffle(t)
		for i = #t, 2, -1 do
			local j = math.random(i)
			t[i], t[j] = t[j], t[i]
		end
	end
	shuffle(validEvents)

	local count = math.random(8, 12)
	local chosenEvents = {}
	for i = 1, math.min(count, #validEvents) do
		table.insert(chosenEvents, validEvents[i])
	end

	task.delay(10, function()
		if not self._active then return end
		for _, eventName in ipairs(chosenEvents) do
			local ok = svc:StartEvent(eventName)
			if ok then
				table.insert(self._runningEvents, eventName)
			else
				warn("[Phase5SammySnapEvent] Failed to start event:", eventName)
			end
		end
	end)
end

function Module:Stop()
	self._active = false
	self._runningEvents = {}
end

return Module
