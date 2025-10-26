--[[
  Extracted from: ServerScriptService.CraftingMachineServer
  Class: Script
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")
local CraftingMachineModule = require(ReplicatedStorage:FindFirstChild("CraftingMachineModule"))
local SyncEvent = ReplicatedStorage:FindFirstChild("SyncCraftingMachineData")
local RequestEvent = ReplicatedStorage:FindFirstChild("RequestCraftingMachineData")
local CraftAnimalEvent = ReplicatedStorage:FindFirstChild("CraftAnimal")

CraftingMachineModule:InitGlobal()

local function syncAll()
	if SyncEvent then
		local players = Players:GetPlayers()
		local globalData = CraftingMachineModule:GetGlobalData(players)
		for _, player in players do
			SyncEvent:FireClient(player, globalData)
		end
	end
end

if RequestEvent then
	RequestEvent.OnServerEvent:Connect(function(player)
		local players = Players:GetPlayers()
		local globalData = CraftingMachineModule:GetGlobalData(players)
		SyncEvent:FireClient(player, globalData)
	end)
end

if CraftAnimalEvent then
	CraftAnimalEvent.OnServerEvent:Connect(function(player, recipeName)
		local success, result = CraftingMachineModule:Craft(player, recipeName)
		CraftAnimalEvent:FireClient(player, {success = success, result = result})
		syncAll()
	end)
end

spawn(function()
	while true do
		local now = os.time()
		if CraftingMachineModule.GlobalData.NextUpdateTime <= now then
			CraftingMachineModule:GlobalRefresh()
			syncAll()
		end
		task.wait(1)
	end
end)

Players.PlayerAdded:Connect(function(player)
	if SyncEvent then
		local players = Players:GetPlayers()
		local globalData = CraftingMachineModule:GetGlobalData(players)
		SyncEvent:FireClient(player, globalData)
	end
end)

