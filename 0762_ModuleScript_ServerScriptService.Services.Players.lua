--[[
  Extracted from: ServerScriptService.Services.Players
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Packages = ReplicatedStorage:WaitForChild("Packages")
local Data = ReplicatedStorage:WaitForChild("Datas")
local CollectionService = game:GetService("CollectionService")
local Player = game:GetService("Players")

local DataManagment = require(ServerScriptService.Services.DataManagment)
local Net = require(Packages.Net)
local Synchronizer = require(Packages.Synchronizer)
local Rebirths = require(Data.Rebirth)
local Friends = require(ReplicatedStorage:WaitForChild("Shared").Friends)
local Animals = require(ReplicatedStorage:WaitForChild("Shared").Animals)

local HttpServices = game:GetService("HttpService")
local CommunicationRoute = ReplicatedStorage.Packages.Synchronizer.CommunicationRoute

local PlayerSynchronizers = {}

local Players = {}

function Players.new(player: Player)
	if PlayerSynchronizers[player] then
		return PlayerSynchronizers[player]
	end

	if not DataManagment.isDataReady(player) then
		local success = DataManagment.waitForData(player, 30)
		if not success then
			return nil
		end
	end

	local Data = DataManagment.GetDataMan(player)
	if not Data then
		return nil
	end

	local success, plot = pcall(function()
		local plot = Synchronizer:Create(player, {})
		plot:AddListener(player)

		local leaderstats = Instance.new("Folder")
		leaderstats.Name = "leaderstats"
		leaderstats.Parent = player

		local steals = Instance.new("IntValue")
		steals.Name = "Steals"
		steals.Value = Data.Steals or 0
		steals.Parent = leaderstats

		local rebirths = Instance.new("IntValue")
		rebirths.Name = "Rebirths"
		rebirths.Value = Data.Rebirths or 0
		rebirths.Parent = leaderstats

		local coins = Instance.new("IntValue")
		coins.Name = "Cash"
		coins.Value = Data.Coins or 0
		coins.Parent = leaderstats

		plot:Set("Coins", Data.Coins or 0)
		plot:Set("Rebirth", Data.Rebirths or 0)
		plot:Set("Spins", Data.BloodmoonSpinWheelSpins or 0)
		plot:Set("PaidSpins", Data.BloodmoonSpinWheelPaidSpins or {})
		plot:Set("LastDailyDiscount", Data.BloodmoonSpinWheelLastDailyDiscount or 0)
		plot:Set("AnimalPodiums", Data.AnimalList or {})
		plot:Set("AnimalAddedOrRemoved", Data.AnimalList or {})
		plot:Set("Index", Data.Index or {})
		plot:Set("TimesJoined", Data.TimesJoined or 1)
		plot:Set("Steals", Data.Steals or 0)
		plot:Set("Settings",Data.Settings or {})
		plot:Set("Items", Data.Items or {})
		plot:Set("Gamepass", Data.Gamepass or {})
		plot:Set("AutoBuy", {})

		if Data.AutoBuySettings then
			for itemName, isEnabled in pairs(Data.AutoBuySettings) do
				plot:Set("AutoBuy." .. itemName, isEnabled)
			end
		end

		local rainbowSpinWheelData = Data.RainbowSpinWheel or {}
		rainbowSpinWheelData.Spins = rainbowSpinWheelData.Spins or 0
		rainbowSpinWheelData.PaidSpins = rainbowSpinWheelData.PaidSpins or {}
		rainbowSpinWheelData.LastDailyDiscount = rainbowSpinWheelData.LastDailyDiscount or 0
		rainbowSpinWheelData.LastFreeClaimed = rainbowSpinWheelData.LastFreeClaimed or 0
		plot:Set("RainbowSpinWheel", rainbowSpinWheelData)

		local BloodmoonSpinWheelData = Data.BloodmoonSpinWheel or {}
		BloodmoonSpinWheelData.Spins = BloodmoonSpinWheelData.Spins or 0
		BloodmoonSpinWheelData.PaidSpins = BloodmoonSpinWheelData.PaidSpins or {}
		BloodmoonSpinWheelData.LastDailyDiscount = BloodmoonSpinWheelData.LastDailyDiscount or 0
		BloodmoonSpinWheelData.LastFreeClaimed = BloodmoonSpinWheelData.LastFreeClaimed or 0
		plot:Set("BloodmoonSpinWheel", BloodmoonSpinWheelData)

		local CandySpinWheelData = Data.CandySpinWheel or {}
		CandySpinWheelData.Spins = CandySpinWheelData.Spins or 0
		CandySpinWheelData.PaidSpins = CandySpinWheelData.PaidSpins or {}
		CandySpinWheelData.LastDailyDiscount = CandySpinWheelData.LastDailyDiscount or 0
		CandySpinWheelData.LastFreeClaimed = CandySpinWheelData.LastFreeClaimed or 0
		plot:Set("CandySpinWheel", CandySpinWheelData)

		local MoltenSpinWheelData = Data.MoltenSpinWheel or {}
		MoltenSpinWheelData.Spins = MoltenSpinWheelData.Spins or 0
		MoltenSpinWheelData.PaidSpins = MoltenSpinWheelData.PaidSpins or {}
		MoltenSpinWheelData.LastDailyDiscount = MoltenSpinWheelData.LastDailyDiscount or 0
		MoltenSpinWheelData.LastFreeClaimed = MoltenSpinWheelData.LastFreeClaimed or 0
		plot:Set("MoltenSpinWheel", MoltenSpinWheelData)
		
		local GalaxySpinWheelData = Data.GalaxySpinWheel or {}
		GalaxySpinWheelData.Spins = GalaxySpinWheelData.Spins or 0
		GalaxySpinWheelData.PaidSpins = GalaxySpinWheelData.PaidSpins or {}
		GalaxySpinWheelData.LastDailyDiscount = GalaxySpinWheelData.LastDailyDiscount or 0
		GalaxySpinWheelData.LastFreeClaimed = GalaxySpinWheelData.LastFreeClaimed or 0
		plot:Set("GalaxySpinWheel", GalaxySpinWheelData)

		local rainbowEventData = Data.RainbowEvent or {}
		rainbowEventData.LastClaimed = rainbowEventData.LastClaimed or 0
		rainbowEventData.SkipPurchased = rainbowEventData.SkipPurchased or false
		plot:Set("RainbowEvent", rainbowEventData)

		plot:OnChanged("Coins", function(newValue)
			coins.Value = newValue or 0
		end, true)

		plot:OnChanged("Rebirth", function(newValue)
			rebirths.Value = newValue or 0
		end, true)

		plot:OnChanged("Steals", function(newValue)
			steals.Value = newValue or 0
		end, true)

		CommunicationRoute:FireClient(player, {{"ListenerAdded", player}})

		return plot
	end)

	if not success then
		return nil
	end

	PlayerSynchronizers[player] = plot
	return plot
end

function Players.getSynchronizer(player: Player)
	return PlayerSynchronizers[player]
end

function Players.waitForSynchronizer(player: Player, timeout: number?)
	local timeoutValue = timeout or 30
	local startTime = tick()

	while tick() - startTime < timeoutValue do
		if PlayerSynchronizers[player] then
			return PlayerSynchronizers[player]
		end
		task.wait(0.1)
	end

	return nil
end

function Players.hasSynchronizer(player: Player)
	return PlayerSynchronizers[player] ~= nil
end

Player.PlayerRemoving:Connect(function(player)
	if PlayerSynchronizers[player] then
		PlayerSynchronizers[player]:Destroy()
		PlayerSynchronizers[player] = nil
		DataManagment.saveProfile(player)
	end
end)

for _, player in pairs(Player:GetPlayers()) do
	task.spawn(function()
		pcall(function()
			Players.new(player)
		end)
	end)
end

Player.PlayerAdded:Connect(function(player)
	task.spawn(function()
		pcall(function()
			Players.new(player)
		end)
	end)
end)

return Players