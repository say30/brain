--[[
  Extracted from: ReplicatedStorage.Items.Gravity Coil.GravityController
  Class: Script
  Source file: rickdev.rbxlx
]]

local PlayerSpeed = 32
local Players = game:GetService("Players")
local tool = script.Parent
script.Parent.Equipped:Connect(function()
	local player = script:FindFirstAncestorWhichIsA("Player") or Players:GetPlayerFromCharacter(script.Parent.Parent)
	if player and player:GetAttribute("Stealing") then
		tool.Parent = player.Backpack
	end
	script.Parent:SetAttribute("JumpModifier",1.9)
end)

script.Parent.Unequipped:Connect(function()
	script.Parent:SetAttribute("JumpModifier",0)
end)
