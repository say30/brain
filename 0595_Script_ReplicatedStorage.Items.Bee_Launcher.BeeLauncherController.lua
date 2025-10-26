--[[
  Extracted from: ReplicatedStorage.Items.Bee Launcher.BeeLauncherController
  Class: Script
  Source file: rickdev.rbxlx
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage:WaitForChild("Packages")
local Net = require(Packages.Net)
local RemoteEvent = Net:RemoteEvent("BeeLauncher/Shoot")
local tool = script.Parent

RemoteEvent.OnServerEvent:Connect(function(player, targetPlayer)
	if not targetPlayer or not Players:GetPlayerFromCharacter(targetPlayer.Character) then return end
	local character = player.Character
	local targetCharacter = targetPlayer.Character
	if not character or not targetCharacter then return end
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	local targetHumanoidRootPart = targetCharacter:FindFirstChild("HumanoidRootPart")
	if not humanoidRootPart or not targetHumanoidRootPart then return end
	local distance = (humanoidRootPart.Position - targetHumanoidRootPart.Position).Magnitude
	if distance > 30 then return end
	RemoteEvent:FireClient(targetPlayer)
end)
tool.Equipped:Connect(function()
	local player = script:FindFirstAncestorWhichIsA("Player") or Players:GetPlayerFromCharacter(script.Parent.Parent)
	if player and player:GetAttribute("Stealing") then
		tool.Parent = player.Backpack
	end
end)