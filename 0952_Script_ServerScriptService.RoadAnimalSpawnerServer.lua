--[[
  Extracted from: ServerScriptService.RoadAnimalSpawnerServer
  Class: Script
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local HttpService = game:GetService("HttpService")

-- Load the module containing the spawn logic
local CmdrService = ServerScriptService.Services:FindFirstChild("CmdrService")
local spawnModule = nil
if CmdrService then
    local customCommands = CmdrService.Commands:FindFirstChild("CustomCommands")
    if customCommands then
        spawnModule = customCommands:FindFirstChild("spawnroadbrainrotServer")
    end
end

local spawnFunc = nil
if spawnModule then
    spawnFunc = require(spawnModule)
end

local event = ReplicatedStorage:WaitForChild("SpawnRoadAnimalRequest")

event.OnServerEvent:Connect(function(player, animalName, mutation, traits)
    if not spawnFunc then
        event:FireClient(player, "Spawn Module not found!")
        return
    end

    local context = { Executor = player }
    local result = spawnFunc(context, animalName, mutation, traits)
    event:FireClient(player, result)
end)

