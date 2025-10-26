--[[
  Extracted from: ServerScriptService.Main.Items.CakeTrap
  Class: Script
  Source file: rickdev.rbxlx
]]

local Players = game:GetService("Players")
local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage:WaitForChild("Packages")
local RagdollModule = require(ReplicatedStorage.Packages.Ragdoll)
local Net = require(Packages.Net)

local trapDebounce = {}
local activeTraps = {}

local TRAP_LIFETIME = 120

local function getCharacterFromPart(part)
	local character = part.Parent
	if character and character:FindFirstChildOfClass("Humanoid") then
		return character, character:FindFirstChildOfClass("Humanoid")
	end
	return nil, nil
end

Net:RemoteEvent("CakceTrap/Place").OnServerEvent:Connect(function(player)
	if not player.Character then return end

	if trapDebounce[player] and tick() - trapDebounce[player] < 2 then
		return
	end
	trapDebounce[player] = tick()

	local tool = player.Character:FindFirstChildWhichIsA("Tool")
	if not tool or tool.Name ~= "Cake Trap" then return end

	local handle = tool:FindFirstChild("Handle")
	if not handle then return end

	local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
	if not humanoidRootPart then return end

	local trap = handle:Clone()
	trap.Name = "PlacedTrap"
	trap.Anchored = true
	trap.CanCollide = false
	tool:Destroy()

	local forwardDirection = humanoidRootPart.CFrame.LookVector
	local trapPosition = humanoidRootPart.Position + forwardDirection * 3

	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.FilterDescendantsInstances = {player.Character, trap}

	local raycast = workspace:Raycast(trapPosition + Vector3.new(0, 5, 0), Vector3.new(0, -100, 0), raycastParams)
	local groundY = raycast and raycast.Position.Y or (trapPosition.Y - 5)

	trapPosition = Vector3.new(trapPosition.X, groundY + trap.Size.Y/2, trapPosition.Z)
	trap.CFrame = CFrame.new(trapPosition)
	trap.Parent = workspace

	Debris:AddItem(trap, TRAP_LIFETIME)

	activeTraps[trap] = {
		owner = player,
		placed = tick()
	}

	local touchConnection
	touchConnection = trap.Touched:Connect(function(hit)
		local character, humanoid = getCharacterFromPart(hit)
		if character and humanoid and character ~= player.Character then
			local targetPlayer = Players:GetPlayerFromCharacter(character)
			if targetPlayer then
				local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
				if humanoidRootPart then
					local bodyVelocity = Instance.new("BodyVelocity")
					bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
					bodyVelocity.Velocity = Vector3.new(0, 60, 0)
					bodyVelocity.Parent = humanoidRootPart
					Debris:AddItem(bodyVelocity, 0.3)
					RagdollModule.TimedRagdoll(character, 5)
				end
				touchConnection:Disconnect()
				activeTraps[trap] = nil
				trap:Destroy()
			end
		end
	end)

	trap.AncestryChanged:Connect(function()
		if not trap.Parent then
			activeTraps[trap] = nil
			if touchConnection then
				touchConnection:Disconnect()
			end
		end
	end)
end)

Players.PlayerRemoving:Connect(function(player)
	trapDebounce[player] = nil
	for trap, data in pairs(activeTraps) do
		if data.owner == player then
			if trap and trap.Parent then
				trap:Destroy()
			end
			activeTraps[trap] = nil
		end
	end
end)