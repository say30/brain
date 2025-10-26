--[[
  Extracted from: ServerScriptService.Main.Items.Tools
  Class: Script
  Source file: rickdev.rbxlx
]]

local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataManagment = require(ServerScriptService.Services.DataManagment)
local ShopData = require(ReplicatedStorage.Datas.Shop)

local function givePlayerTools(player, Data)
	task.wait(0.1)

	local starterPackItems = {}
	local starterPackData = ShopData[3373926350]
	if starterPackData and starterPackData.Rewards and starterPackData.Rewards.Items then
		for _, itemName in pairs(starterPackData.Rewards.Items) do
			starterPackItems[itemName] = true
		end
	end

	local ownsStarterPack = Data.BoughtStarterPack or false
	if not ownsStarterPack and Data.Items then
		local hasAllStarterItems = true
		for itemName, _ in pairs(starterPackItems) do
			if not Data.Items[itemName] then
				hasAllStarterItems = false
				break
			end
		end
		ownsStarterPack = hasAllStarterItems
	end

	if Data.Inventory then
		for itemName, owned in pairs(Data.Inventory) do
			if owned then
				local tool = ReplicatedStorage.Items:FindFirstChild(itemName)
				if tool then
					tool:Clone().Parent = player.Backpack
				end
			end
		end
	end

	if ownsStarterPack then
		for itemName, _ in pairs(starterPackItems) do
			if not (Data.Inventory and Data.Inventory[itemName]) then
				local tool = ReplicatedStorage.Items:FindFirstChild(itemName)
				if tool then
					tool:Clone().Parent = player.Backpack
				end
			end
		end
	end
end

local function setupPlayerTools(player)
	if not DataManagment.isDataReady(player) then
		local success = DataManagment.waitForData(player, 30)
		if not success then
			warn("Failed to get data for player: " .. player.Name)
			return
		end
	end

	local Data = DataManagment.GetDataMan(player)
	if not Data then return end

	if player.Character then
		givePlayerTools(player, Data)
	end

	player.CharacterAdded:Connect(function(character)
		givePlayerTools(player, Data)
	end)
end

for _, player in pairs(Players:GetPlayers()) do
	setupPlayerTools(player)
end

Players.PlayerAdded:Connect(setupPlayerTools)
