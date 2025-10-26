--[[
  Extracted from: ServerScriptService.Conch
  Class: Script
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Conch = require(ReplicatedStorage.Packages.Conch)

require(ReplicatedStorage.Shared.ConchTypes)

local ServerScriptService = game:GetService("ServerScriptService")
require(ServerScriptService.Services.CommandsService)

local Net = require(ReplicatedStorage.Packages.Net)

Conch.initiate_default_lifecycle()