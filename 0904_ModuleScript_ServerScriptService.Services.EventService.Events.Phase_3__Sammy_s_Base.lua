--[[
  Extracted from: ServerScriptService.Services.EventService.Events.Phase 3: Sammy's Base
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
	self._sammyEvent = nil
	self._borders = {}
	return self
end

function Module:Start(eventData)
	if self._active then return end
	self._active = true

	self._eventData = eventData or {}

	local sammyEvent = script:FindFirstChild("SammyBaseEvent")
	if sammyEvent then
		self._sammyEvent = sammyEvent:Clone()
		self._sammyEvent.Parent = Workspace
	end

	local bordersFolder = Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("Borders")
	if bordersFolder then
		for _, part in ipairs(bordersFolder:GetDescendants()) do
			if part:IsA("BasePart") then
				self._borders[part] = part.CanCollide
				part.CanCollide = false
			end
		end
	end
end

function Module:Stop()
	if not self._active then return end
	self._active = false

	if self._sammyEvent and self._sammyEvent.Parent then
		self._sammyEvent:Destroy()
		self._sammyEvent = nil
	end

	for part, originalState in pairs(self._borders) do
		if part and part.Parent then
			part.CanCollide = originalState
		end
	end
	self._borders = {}
end

return Module
