--[[
  Extracted from: ReplicatedStorage.Items.Body Swap Potion.BodySwapController
  Class: Script
  Source file: rickdev.rbxlx
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage:WaitForChild("Packages")
local Net = require(Packages.Net)

local function swapBodies(player, targetPlayer)
	if not player or not targetPlayer then return end
	local char1 = player.Character
	local char2 = targetPlayer.Character
	if not char1 or not char2 then return end
	local humanoid1 = char1:FindFirstChildOfClass("Humanoid")
	local humanoid2 = char2:FindFirstChildOfClass("Humanoid")
	if not humanoid1 or not humanoid2 then return end
	local root1 = char1:FindFirstChild("HumanoidRootPart")
	local root2 = char2:FindFirstChild("HumanoidRootPart")
	if not root1 or not root2 then return end
	local pos1 = root1.Position
	local pos2 = root2.Position
	root1.Position = pos2
	root2.Position = pos1
end

Net:RemoteEvent("BodySwap/Fire").OnServerEvent:Connect(function(player, targetPlayer)
	if typeof(targetPlayer) == "Instance" and targetPlayer:IsA("Player") then
		swapBodies(player, targetPlayer)
	end
end)
local tool = script.Parent
tool.Equipped:Connect(function()
	local player = script:FindFirstAncestorWhichIsA("Player") or Players:GetPlayerFromCharacter(script.Parent.Parent)
	if player and player:GetAttribute("Stealing") then
		tool.Parent = player.Backpack
	end
end)