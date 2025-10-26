--[[
  Extracted from: ReplicatedStorage.Items.Rage Table.TableController
  Class: Script
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Packages = ReplicatedStorage:WaitForChild("Packages")
local Net = require(Packages.Net)
local RagdollModule = require(ReplicatedStorage.Packages.Ragdoll)

local COOLDOWN_DURATION = 5
local Cooldowns = {}

local ThrowTableTemplate = Instance.new("Part")
ThrowTableTemplate.FormFactor = Enum.FormFactor.Custom
ThrowTableTemplate.Size = Vector3.new(4.8, 2.43, 3.63)
ThrowTableTemplate.CanCollide = true
local tmesh = Instance.new("SpecialMesh")
tmesh.MeshId = "http://www.roblox.com/asset/?id=111868131"
tmesh.TextureId = "http://www.roblox.com/asset/?id=111867655"
tmesh.Parent = ThrowTableTemplate

local function FindAttachedHumanoid(part)
	local current = part
	while current and current.Parent do
		if current.Parent:FindFirstChild("Humanoid") then
			return current.Parent
		end
		current = current.Parent
	end
	return nil
end

Net:RemoteEvent("Table/LaunchTable").OnServerEvent:Connect(function(player)
	local now = tick()
	if Cooldowns[player] and now - Cooldowns[player] < COOLDOWN_DURATION then
		return
	end
	Cooldowns[player] = now

	local character = player.Character
	if not character then return end

	local tool = character:FindFirstChildWhichIsA("Tool")
	if not tool or tool.Name ~= "Rage Table" then return end

	tool:SetAttribute("CooldownTime", COOLDOWN_DURATION)
	task.spawn(function()
		for i = COOLDOWN_DURATION - 1, 0, -1 do
			task.wait(1)
			if tool and tool:IsDescendantOf(game) then
				tool:SetAttribute("CooldownTime", i)
			end
		end
	end)

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local torso = character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
	if not humanoid or humanoid.Health <= 0 or not torso then return end

	humanoid.WalkSpeed = 0

	local lookGyro = Instance.new("BodyGyro")
	lookGyro.MaxTorque = Vector3.new(0, math.huge, 0)
	lookGyro.CFrame = torso.CFrame - torso.CFrame.Position
	lookGyro.Parent = torso

	local tableClone = ThrowTableTemplate:Clone()
	tableClone.CFrame = torso.CFrame + Vector3.new(0, 0, 3)
	tableClone.Parent = workspace

	local angularVelocity = Instance.new("BodyAngularVelocity")
	angularVelocity.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
	angularVelocity.AngularVelocity = (torso.CFrame * CFrame.Angles(0, math.pi / 2, 0)).LookVector * 5
	angularVelocity.Parent = tableClone

	local velocity = Instance.new("BodyVelocity")
	velocity.MaxForce = Vector3.new(math.huge, 0, math.huge)
	velocity.Velocity = torso.CFrame.LookVector * 15
	velocity.Parent = tableClone

	local touched = false
	local connection
	connection = tableClone.Touched:Connect(function(part)
		if touched then return end
		if part:IsDescendantOf(character) then return end
		if part.Parent == workspace.Terrain or part.Anchored then return end

		local targetCharacter = FindAttachedHumanoid(part)
		if targetCharacter and targetCharacter ~= character then
			touched = true
			local targetHumanoid = targetCharacter:FindFirstChildOfClass("Humanoid")
			if targetHumanoid and targetHumanoid.Health > 0 then
				local root = targetCharacter:FindFirstChild("HumanoidRootPart")
				if root then
					local wasAnchored = root.Anchored
					root.Anchored = true
					task.delay(1.5, function()
						if root then root.Anchored = wasAnchored end
					end)
				end

				targetHumanoid.BreakJointsOnDeath = false
				RagdollModule.TimedRagdoll(targetCharacter, 3)
				task.delay(3, function()
					if targetHumanoid then
						targetHumanoid.BreakJointsOnDeath = true
					end
				end)

				tableClone.Velocity = Vector3.new(0, 0, 0)
				angularVelocity:Destroy()
				velocity:Destroy()
				if connection then connection:Disconnect() end

				task.delay(2, function()
					if tableClone then tableClone:Destroy() end
				end)
			end
		end
	end)

	task.delay(6, function()
		if lookGyro then lookGyro:Destroy() end
		humanoid.WalkSpeed = 16
	end)

	task.delay(8, function()
		if connection then connection:Disconnect() end
		if tableClone and tableClone.Parent then
			tableClone:Destroy()
		end
	end)
end)

local tool = script.Parent
tool:SetAttribute("CooldownTime", 0)

tool.Equipped:Connect(function()
	local player = script:FindFirstAncestorWhichIsA("Player") or Players:GetPlayerFromCharacter(script.Parent.Parent)
	if player and player:GetAttribute("Stealing") then
		tool.Parent = player.Backpack
	end
end)
