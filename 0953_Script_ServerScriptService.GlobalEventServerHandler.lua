--[[
  Extracted from: ServerScriptService.GlobalEventServerHandler
  Class: Script
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")
local GlobalEventRequest = ReplicatedStorage:WaitForChild("GlobalEventRequest")
local CmdrService = ServerScriptService:WaitForChild("Services"):WaitForChild("CmdrService")
local CustomCommands = CmdrService:WaitForChild("Commands"):WaitForChild("CustomCommands")
local startGlobalEventModule = CustomCommands:WaitForChild("startglobaleventServer")

local startGlobalEventFunc = require(startGlobalEventModule)

GlobalEventRequest.OnServerEvent:Connect(function(player, action, eventName, duration)
    local context = {Executor = player}
    local result = startGlobalEventFunc(context, action, eventName, duration)
    GlobalEventRequest:FireClient(player, result)
end)

