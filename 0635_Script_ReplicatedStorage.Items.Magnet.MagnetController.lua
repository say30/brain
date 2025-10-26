--[[
  Extracted from: ReplicatedStorage.Items.Magnet.MagnetController
  Class: Script
  Source file: rickdev.rbxlx
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage:WaitForChild("Packages")
local Net = require(Packages.Net)
local RemoteEvent = Net:RemoteEvent("UseItem")

local MAGNET_RANGE = 50
local ATTRACTION_FORCE = 50
local ATTRACTION_DURATION = 4 

local function findNearestPlayer(sourcePlayer, sourcePosition)
	local nearestPlayer = nil
	local nearestDistance = math.huge

	for _, player in pairs(Players:GetPlayers()) do
		if player ~= sourcePlayer and player.Character then
			local character = player.Character
			local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
			local humanoid = character:FindFirstChild("Humanoid")

			if humanoidRootPart and humanoid and humanoid.Health > 0 then
				local hasForceField = false
				for _, child in pairs(character:GetChildren()) do
					if child:IsA("ForceField") then
						hasForceField = true
						break
					end
				end

				if not hasForceField then
					local distance = (humanoidRootPart.Position - sourcePosition).Magnitude
					if distance <= MAGNET_RANGE and distance < nearestDistance then
						nearestDistance = distance
						nearestPlayer = player
					end
				end
			end
		end
	end

	return nearestPlayer, nearestDistance
end

local function createMagneticConnection(sourcePlayer, targetPlayer)
	local sourceCharacter = sourcePlayer.Character
	local targetCharacter = targetPlayer.Character

	if not sourceCharacter or not targetCharacter then return end

	local sourceRootPart = sourceCharacter:FindFirstChild("HumanoidRootPart")
	local targetRootPart = targetCharacter:FindFirstChild("HumanoidRootPart")
	local targetHumanoid = targetCharacter:FindFirstChild("Humanoid")

	if not sourceRootPart or not targetRootPart or not targetHumanoid then return end

	local attachment1 = Instance.new("Attachment")
	attachment1.Parent = sourceRootPart

	local attachment2 = Instance.new("Attachment")
	attachment2.Parent = targetRootPart

	local ropeConstraint = Instance.new("RopeConstraint")
	ropeConstraint.Attachment0 = attachment1
	ropeConstraint.Attachment1 = attachment2
	ropeConstraint.Length = 20
	ropeConstraint.Visible = false
	ropeConstraint.Parent = sourceRootPart

	local bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.MaxForce = Vector3.new(8000, 0, 8000)
	bodyVelocity.Parent = targetRootPart

	local connection
	local cleanupPerformed = false
	local magnetEffect

	local function cleanup()
		if cleanupPerformed then return end
		cleanupPerformed = true

		if connection then
			connection:Disconnect()
			connection = nil
		end

		if ropeConstraint and ropeConstraint.Parent then
			ropeConstraint:Destroy()
		end
		if attachment1 and attachment1.Parent then
			attachment1:Destroy()
		end
		if attachment2 and attachment2.Parent then
			attachment2:Destroy()
		end
		if bodyVelocity and bodyVelocity.Parent then
			bodyVelocity:Destroy()
		end
		if magnetEffect and magnetEffect.Parent then
			magnetEffect:Destroy()
		end
	end

	local sourcePlayerLeftConnection
	local targetPlayerLeftConnection

	sourcePlayerLeftConnection = Players.PlayerRemoving:Connect(function(player)
		if player == sourcePlayer then
			cleanup()
			if sourcePlayerLeftConnection then
				sourcePlayerLeftConnection:Disconnect()
			end
			if targetPlayerLeftConnection then
				targetPlayerLeftConnection:Disconnect()
			end
		end
	end)

	targetPlayerLeftConnection = Players.PlayerRemoving:Connect(function(player)
		if player == targetPlayer then
			cleanup()
			if sourcePlayerLeftConnection then
				sourcePlayerLeftConnection:Disconnect()
			end
			if targetPlayerLeftConnection then
				targetPlayerLeftConnection:Disconnect()
			end
		end
	end)

	connection = game:GetService("RunService").Heartbeat:Connect(function()
		if not sourcePlayer.Parent or not targetPlayer.Parent or
			not sourceCharacter.Parent or not targetCharacter.Parent or
			not sourceRootPart.Parent or not targetRootPart.Parent or
			not bodyVelocity.Parent then
			cleanup()
			if sourcePlayerLeftConnection then sourcePlayerLeftConnection:Disconnect() end
			if targetPlayerLeftConnection then targetPlayerLeftConnection:Disconnect() end
			return
		end

		if targetHumanoid.Health <= 0 then
			cleanup()
			if sourcePlayerLeftConnection then sourcePlayerLeftConnection:Disconnect() end
			if targetPlayerLeftConnection then targetPlayerLeftConnection:Disconnect() end
			return
		end

		local distance = (sourceRootPart.Position - targetRootPart.Position).Magnitude
		local direction = (sourceRootPart.Position - targetRootPart.Position).Unit

		local pullForce = 60
		if distance < 10 then
			pullForce = 35
		elseif distance < 5 then
			pullForce = 15
		end

		bodyVelocity.Velocity = direction * pullForce
	end)

	magnetEffect = Instance.new("SelectionBox")
	magnetEffect.Adornee = targetCharacter
	magnetEffect.Color3 = Color3.fromRGB(255, 0, 255)
	magnetEffect.LineThickness = 0.2
	magnetEffect.Transparency = 0.5
	magnetEffect.Parent = targetCharacter

	task.spawn(function()
		task.wait(ATTRACTION_DURATION)
		cleanup()
		if sourcePlayerLeftConnection then sourcePlayerLeftConnection:Disconnect() end
		if targetPlayerLeftConnection then targetPlayerLeftConnection:Disconnect() end
	end)
end

RemoteEvent.OnServerEvent:Connect(function(player)
	local character = player.Character
	if not character then return end

	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	if not humanoidRootPart then return end

	local tool = character:FindFirstChildWhichIsA("Tool")
	if not tool or tool.Name ~= "Magnet" then return end

	if not tool.Enabled then return end
	tool.Enabled = false

	local nearestPlayer, distance = findNearestPlayer(player, humanoidRootPart.Position)

	if nearestPlayer then
		createMagneticConnection(player, nearestPlayer)
	end

	task.spawn(function()
		task.wait(3)
		if tool and tool.Parent then
			tool.Enabled = true
		end
	end)
end)

local tool = script.Parent
tool.Equipped:Connect(function()
	local player = script:FindFirstAncestorWhichIsA("Player") or Players:GetPlayerFromCharacter(script.Parent.Parent)
	if player and player:GetAttribute("Stealing") then
		tool.Parent = player.Backpack
	end
end)