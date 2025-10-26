--[[
  Extracted from: ReplicatedStorage.Shared.ConchTypes.Event
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Conch = require(ReplicatedStorage.Packages.Conch)
local Net = require(ReplicatedStorage.Packages.Net)

local Events = {}

if RunService:IsServer() then
	local ServerScriptService = game:GetService("ServerScriptService")
	for EventName in pairs(require(ServerScriptService.Services.EventService).Events) do
		table.insert(Events, EventName)
	end
else
	Events = Net:Invoke("EventService/ListEvents")
end

return Conch.register_type("Event", Conch.args.enum_new(Events))
