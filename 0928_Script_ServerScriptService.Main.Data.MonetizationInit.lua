--[[
  Extracted from: ServerScriptService.Main.Data.MonetizationInit
  Class: Script
  Source file: rickdev.rbxlx
]]

local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local MonetizationService = require(ServerScriptService.Services.MonetizationService)

local function InitializeMonetization()
	if not _G.MonetizationService then
		local monetizationInstance = MonetizationService.new()
		_G.MonetizationService = monetizationInstance
	end
end

InitializeMonetization()