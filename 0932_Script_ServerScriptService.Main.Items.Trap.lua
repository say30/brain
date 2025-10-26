--[[
  Extracted from: ServerScriptService.Main.Items.Trap
  Class: Script
  Source file: rickdev.rbxlx
]]

local Players = game:GetService("Players")
local Debris = game:GetService("Debris")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage:WaitForChild("Packages")
local Net = require(Packages.Net)

local trapDebounce = {}
local playerTrapDebounce = {}

local activeTraps = {}
local trappedPlayers = {}

local TRAP_LIFETIME = 120

local function getCharacterFromPart(part)
	local character = part.Parent
	if character and character:FindFirstChildOfClass("Humanoid") then
		return character, character:FindFirstChildOfClass("Humanoid")
	end
	return nil, nil
end

local function createTrappedGUI(character)
	local overheadsFolder = ReplicatedStorage:FindFirstChild("Overheads")
	if not overheadsFolder then
		return nil
	end

	local animalOverheadTemplate = overheadsFolder:FindFirstChild("AnimalOverhead")
	if not animalOverheadTemplate then
		return nil
	end

	local trappedOverhead = animalOverheadTemplate:Clone()
	trappedOverhead.DisplayName.Text = "TRAPPED!"
	trappedOverhead.DisplayName.TextColor3 = Color3.fromRGB(255, 100, 100)
	trappedOverhead.DisplayName.TextStrokeTransparency = 0
	trappedOverhead.DisplayName.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)

	trappedOverhead.Generation.Visible = false
	trappedOverhead.Price.Visible = false
	trappedOverhead.Rarity.Visible = false
	trappedOverhead.Mutation.Visible = false

	local overheadAttachment = Instance.new("Attachment")
	overheadAttachment.Name = "TrappedOverhead"
	overheadAttachment.CFrame = CFrame.new(0, 2, 0)

	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	if humanoidRootPart then
		overheadAttachment.Parent = humanoidRootPart
		trappedOverhead.Parent = overheadAttachment
		return trappedOverhead, overheadAttachment
	end

	return nil, nil
end

local function updateCountdown(gui, timeLeft)
	if gui and gui.Parent then
		gui.DisplayName.Text = string.format("TRAPPED! %ds", math.ceil(timeLeft))
	end
end

local function isPlayerTrapped(player)
	return trappedPlayers[player] ~= nil
end

local function trapPlayer(character, humanoid, trap)
	local player = Players:GetPlayerFromCharacter(character)
	if not player then return end

	if isPlayerTrapped(player) then 
		return 
	end

	if playerTrapDebounce[player] and tick() - playerTrapDebounce[player] < 1 then
		return
	end
	playerTrapDebounce[player] = tick()

	local originalWalkSpeed = humanoid.WalkSpeed
	local originalJumpPower = humanoid.JumpPower
	local originalJumpHeight = humanoid.JumpHeight

	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	local originalAnchored = false
	if humanoidRootPart then
		originalAnchored = humanoidRootPart.Anchored
		humanoidRootPart.Anchored = true
	end

	humanoid.WalkSpeed = 0
	humanoid.JumpPower = 0
	humanoid.JumpHeight = 0

	local trappedGUI, attachment = createTrappedGUI(character)

	trappedPlayers[player] = {
		originalWalkSpeed = originalWalkSpeed,
		originalJumpPower = originalJumpPower,
		originalJumpHeight = originalJumpHeight,
		originalAnchored = originalAnchored,
		humanoidRootPart = humanoidRootPart,
		gui = trappedGUI,
		attachment = attachment,
		startTime = tick(),
		trap = trap
	}

	local trapSound = trap:FindFirstChild("Sound")
	if trapSound then
		trapSound:Play()
	end

	local connection
	connection = RunService.Heartbeat:Connect(function()
		local trapData = trappedPlayers[player]
		if not trapData then
			connection:Disconnect()
			return
		end

		local timeLeft = 10 - (tick() - trapData.startTime)
		if timeLeft <= 0 then
			if humanoid and humanoid.Parent then
				humanoid.WalkSpeed = trapData.originalWalkSpeed
				humanoid.JumpPower = trapData.originalJumpPower
				humanoid.JumpHeight = trapData.originalJumpHeight
			end

			if trapData.humanoidRootPart and trapData.humanoidRootPart.Parent then
				trapData.humanoidRootPart.Anchored = trapData.originalAnchored
			end

			if trapData.attachment then
				trapData.attachment:Destroy()
			end

			if trapData.trap and trapData.trap.Parent then
				trapData.trap:Destroy()
			end

			trappedPlayers[player] = nil
			connection:Disconnect()
		else
			updateCountdown(trapData.gui, timeLeft)
		end
	end)

	local playerLeavingConnection
	playerLeavingConnection = Players.PlayerRemoving:Connect(function(leavingPlayer)
		if leavingPlayer == player then
			local tp = trappedPlayers[player]
			trappedPlayers[player] = nil
			if tp and tp.trap and tp.trap.Parent then
				tp.trap:Destroy()
			end
			connection:Disconnect()
			playerLeavingConnection:Disconnect()
		end
	end)
end

Net:RemoteEvent("Trap/Place").OnServerEvent:Connect(function(player)
	if not player.Character then return end

	if trapDebounce[player] and tick() - trapDebounce[player] < 2 then
		return
	end
	trapDebounce[player] = tick()

	local tool = player.Character:FindFirstChildWhichIsA("Tool")
	if not tool or tool.Name ~= "Trap" then return end

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

			if targetPlayer and not isPlayerTrapped(targetPlayer) then
				trapPlayer(character, humanoid, trap)
				touchConnection:Disconnect()
				activeTraps[trap] = nil
			else
				--print("Trap ignored - player", targetPlayer and targetPlayer.Name or "unknown", "is already trapped")
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
	playerTrapDebounce[player] = nil
	trappedPlayers[player] = nil

	for trap, data in pairs(activeTraps) do
		if data.owner == player then
			if trap and trap.Parent then
				trap:Destroy()
			end
			activeTraps[trap] = nil
		end
	end
end)