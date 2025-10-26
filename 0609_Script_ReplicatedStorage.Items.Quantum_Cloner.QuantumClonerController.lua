--[[
  Extracted from: ReplicatedStorage.Items.Quantum Cloner.QuantumClonerController
  Class: Script
  Source file: rickdev.rbxlx
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage:WaitForChild("Packages")
local Net = require(Packages.Net)
local Debounce = require(Packages.Debounce)

local function CloneCharacter(player)
	if not player.Character then
		warn("No character found for player: " .. player.Name)
		return
	end

	local equippedTool = player.Character:FindFirstChildOfClass("Tool")
	if not equippedTool or equippedTool.Name ~= "Quantum Cloner" then
		warn("Player " .. player.Name .. " does not have Quantum Cloner equipped")
		return
	end

	player.Character.Archivable = true
	local existingClone = workspace:FindFirstChild(player.UserId .. "_Clone")
	if existingClone then
		existingClone:Destroy()
	end

	local character = workspace:FindFirstChild(player.Name)
	if not character then
		return
	end
	if not character.Parent then
		return
	end
	local clone = character:Clone()
	if not clone then
		return
	end

	clone.Name = player.UserId .. "_Clone"

	for _, descendant in pairs(clone:GetDescendants()) do
		if descendant:IsA("Script") or descendant:IsA("LocalScript") then
			descendant:Destroy()
		end
	end

	local humanoid = clone:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid.WalkSpeed = 0
		humanoid.JumpHeight = 0
		humanoid.Health = 1
		humanoid.MaxHealth = 1
	else
		warn("No humanoid found in clone for player: " .. player.Name)
	end

	clone.Parent = workspace
end

local function TeleportToClone(player)
	if not player.Character then
		return
	end

	local equippedTool = player.Character:FindFirstChildOfClass("Tool")
	if not equippedTool or equippedTool.Name ~= "Quantum Cloner" then
		warn("Player " .. player.Name .. " does not have Quantum Cloner equipped for teleport")
		return
	end

	local clone = workspace:FindFirstChild(player.UserId .. "_Clone")
	if not clone or not clone:FindFirstChild("HumanoidRootPart") or not clone:FindFirstChildOfClass("Humanoid") then
		return
	end

	local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
	if humanoidRootPart then
		humanoidRootPart.CFrame = clone.HumanoidRootPart.CFrame
		clone:Destroy()
	else
	end
end

Net:RemoteEvent("UseItem").OnServerEvent:Connect(function(player)
	CloneCharacter(player)
end)

Net:RemoteEvent("QuantumCloner/OnTeleport").OnServerEvent:Connect(function(player)
	TeleportToClone(player)
end)


Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function()
		local clone = workspace:FindFirstChild(player.UserId .. "_Clone")
		if clone then
			clone:Destroy()
		end
	end)
end)

Players.PlayerRemoving:Connect(function(player)
	local clone = workspace:FindFirstChild(player.UserId .. "_Clone")
	if clone then
		clone:Destroy()
	end
end)
local tool = script.Parent
tool.Equipped:Connect(function()
	local player = script:FindFirstAncestorWhichIsA("Player") or Players:GetPlayerFromCharacter(script.Parent.Parent)
	if player and player:GetAttribute("Stealing") then
		tool.Parent = player.Backpack
	end
end)