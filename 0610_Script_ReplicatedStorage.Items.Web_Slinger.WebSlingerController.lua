--[[
  Extracted from: ReplicatedStorage.Items.Web Slinger.WebSlingerController
  Class: Script
  Source file: rickdev.rbxlx
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage:WaitForChild("Packages")
local Net = require(Packages.Net)
local RemoteEvent = Net:RemoteEvent("WebSlinger/ShotWeb")

RemoteEvent.OnServerEvent:Connect(function(player, mouseHit, handle)
	local character = player.Character
	if not character or not handle then return end
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	if not humanoidRootPart then return end
	local distance = (humanoidRootPart.Position - mouseHit.Position).Magnitude
	if distance > 50 then return end

	local ray = Ray.new(humanoidRootPart.Position, (mouseHit.Position - humanoidRootPart.Position).Unit * distance)
	local hitPart, hitPosition = workspace:FindPartOnRayWithIgnoreList(ray, {character})

	if hitPart and hitPart.Parent and Players:GetPlayerFromCharacter(hitPart.Parent) then
		local hitPlayer = Players:GetPlayerFromCharacter(hitPart.Parent)
		local hitCharacter = hitPlayer.Character
		local hitHumanoidRootPart = hitCharacter and hitCharacter:FindFirstChild("HumanoidRootPart")
		local hitHumanoid = hitCharacter and hitCharacter:FindFirstChild("Humanoid")

		if hitHumanoidRootPart and hitHumanoid then
			local rope = Instance.new("RopeConstraint")
			rope.Name = "WebRope"
			rope.Attachment0 = Instance.new("Attachment", humanoidRootPart)
			rope.Attachment1 = Instance.new("Attachment", hitHumanoidRootPart)
			rope.Length = distance
			rope.Visible = true
			rope.Thickness = 0.1
			rope.Color = BrickColor.new("White")
			rope.Parent = workspace

			local bodyVelocity = Instance.new("BodyVelocity")
			bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
			bodyVelocity.Velocity = (humanoidRootPart.Position - hitHumanoidRootPart.Position).Unit * 20
			bodyVelocity.Parent = hitHumanoidRootPart

			hitHumanoid.Sit = true
			hitHumanoid.PlatformStand = true

			game:GetService("Debris"):AddItem(rope, 5)
			game:GetService("Debris"):AddItem(bodyVelocity, 0.5)

			spawn(function()
				wait(5)
				if hitHumanoid then
					hitHumanoid.PlatformStand = false
					hitHumanoid.Sit = false
				end
			end)
		end
	end

	local newCFrame = CFrame.new(mouseHit.Position, humanoidRootPart.Position)
	RemoteEvent:FireClient(player, newCFrame)
end)

local tool = script.Parent
tool.Equipped:Connect(function()
	local player = script:FindFirstAncestorWhichIsA("Player") or Players:GetPlayerFromCharacter(script.Parent.Parent)
	if player and player:GetAttribute("Stealing") then
		tool.Parent = player.Backpack
	end
end)