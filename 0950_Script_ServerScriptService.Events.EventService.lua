--[[
  Extracted from: ServerScriptService.Events.EventService
  Class: Script
  Source file: rickdev.rbxlx
]]

local EventService = require(game.ServerScriptService.Services.EventService)

_G.EventService = nil

local EventServiceSuccessful, EventServiceError = pcall(function()
	_G.EventService = EventService.new()
end)