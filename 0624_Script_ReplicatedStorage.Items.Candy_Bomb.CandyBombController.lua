--[[
  Extracted from: ReplicatedStorage.Items.Candy Bomb.CandyBombController
  Class: Script
  Source file: rickdev.rbxlx
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage:WaitForChild("Packages")
local Net = require(Packages.Net)
local UseItem = Net:RemoteEvent("CandyBomb/Throw")

UseItem.OnServerEvent:Connect(function(player)
	local character = player.Character
	if not character then return end
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	if not humanoidRootPart then return end
	for _, targetPlayer in Players:GetPlayers() do
		if targetPlayer ~= player then
			local targetCharacter = targetPlayer.Character
			if targetCharacter then
				local targetHumanoidRootPart = targetCharacter:FindFirstChild("HumanoidRootPart")
				if targetHumanoidRootPart then
					local distance = (humanoidRootPart.Position - targetHumanoidRootPart.Position).Magnitude
					if distance <= 30 then
						UseItem:FireClient(targetPlayer, "CandyEffect", 10)
					end
				end
			end
		end
	end
end)

local tool = script.Parent
tool.Equipped:Connect(function()
	local player = script:FindFirstAncestorWhichIsA("Player") or Players:GetPlayerFromCharacter(script.Parent.Parent)
	if player and player:GetAttribute("Stealing") then
		tool.Parent = player.Backpack
	end
end)