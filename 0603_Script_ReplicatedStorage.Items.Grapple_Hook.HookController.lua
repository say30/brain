--[[
  Extracted from: ReplicatedStorage.Items.Grapple Hook.HookController
  Class: Script
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage:WaitForChild("Packages")
local Net = require(Packages.Net)
local Debounce = require(Packages.Debounce)

Net:RemoteEvent("Begin/Hook").OnServerEvent:Connect(function(player, magnitude)
	local character = player.Character
	if not character then return end

	local tool = character:FindFirstChildWhichIsA("Tool")
	if not tool or tool.Name ~= "Grapple Hook" then return end

	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	if not humanoidRootPart then return end

	if Debounce(("ItemUse/GrappleHook/%*"):format(player.Name), 3) then return end

	if magnitude < 0.08333333333333333 or magnitude > 0.8333333333333334 then return end

	local bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
	bodyVelocity.Velocity = (humanoidRootPart.Position - tool.Handle.Position).Unit * 100
	bodyVelocity.P = 2000
	bodyVelocity.Parent = humanoidRootPart

	task.delay(magnitude, function()
		bodyVelocity:Destroy()
	end)
end)
local tool = script.Parent
local Players = game:GetService("Players")
tool.Equipped:Connect(function()
	local player = script:FindFirstAncestorWhichIsA("Player") or Players:GetPlayerFromCharacter(script.Parent.Parent)
	if player and player:GetAttribute("Stealing") then
		tool.Parent = player.Backpack
	end
end)