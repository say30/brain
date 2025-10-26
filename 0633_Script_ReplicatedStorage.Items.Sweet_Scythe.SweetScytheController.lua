--[[
  Extracted from: ReplicatedStorage.Items.Sweet Scythe.SweetScytheController
  Class: Script
  Source file: rickdev.rbxlx
]]

local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")

local TARGET_EFFECT = "Freeze"
local RANGE = 300
local SPAWN_OFFSETS = {
	Vector3.new(5, 0, 0),
	Vector3.new(-2.5, 0, 4.33),
	Vector3.new(-2.5, 0, -4.33)
}
local SPAWN_COUNT = 3
local SPAWN_DELAY = 0.5

local function applyEffect(target, gingerbread)
	local targetHumanoid = target:FindFirstChild("Humanoid")
	local targetTorso = target:FindFirstChild("Torso")
	if targetHumanoid and targetTorso then
		local creator = gingerbread:FindFirstChild("creator")
		local plr = Players:GetPlayerFromCharacter(target)
		if plr and creator and plr == creator.Value then
			return
		end
		for _, v in pairs(targetHumanoid:GetChildren()) do
			if v.Name == "creator" then
				v:Destroy()
			end
		end
		local newCt = creator:Clone()
		Debris:AddItem(newCt, 1)
		newCt.Parent = targetHumanoid
		if TARGET_EFFECT == "Freeze" then
			targetTorso.Anchored = true
			task.wait(5)
			if targetTorso then
				targetTorso.Anchored = false
			end
		elseif TARGET_EFFECT == "Burn" then
			local fire = Instance.new("Fire")
			fire.Parent = targetTorso
			Debris:AddItem(fire, 5)
			for i = 1, 5 do
				if targetHumanoid and targetHumanoid.Health > 0 then
					targetHumanoid:TakeDamage(2)
					task.wait(1)
				end
			end
		elseif TARGET_EFFECT == "Knockback" then
			local bodyVelocity = Instance.new("BodyVelocity")
			bodyVelocity.MaxForce = Vector3.new(math.huge, 0, math.huge)
			bodyVelocity.Velocity = (targetTorso.Position - gingerbread.Torso.Position).Unit * 50
			bodyVelocity.Parent = targetTorso
			Debris:AddItem(bodyVelocity, 0.2)
		end
	end
end

local function setupGingerbreadCookie(clone, creatorPlayer)
	local torso = clone:WaitForChild("Torso")
	local head = clone:WaitForChild("Head")
	local humanoid = clone:WaitForChild("Humanoid")

	local creator = Instance.new("ObjectValue")
	creator.Name = "creator"
	creator.Value = creatorPlayer
	creator.Parent = clone

	clone.PrimaryPart = torso
	clone.Parent = game.Workspace

	local alive = true
	local attacker = nil

	torso.Touched:Connect(function(hit)
		if hit and hit.Parent and hit.Parent.Name ~= clone.Name and alive then
			applyEffect(hit.Parent, clone)
		end
	end)

	humanoid:GetPropertyChangedSignal("Health"):Connect(function()
		if humanoid.Health <= 0 then
			alive = false
			humanoid:Destroy()
			local fire = Instance.new("Fire")
			fire.Parent = torso
			if head then
				head:Destroy()
			end
			task.wait(4)
			clone:Destroy()
		elseif not attacker then
			local creatorTag = humanoid:FindFirstChild("creator")
			if creatorTag and creatorTag.Value then
				local attackerPlayer = creatorTag.Value
				local attackerChar = attackerPlayer.Character
				if attackerChar then
					attacker = attackerChar:FindFirstChild("Torso")
				end
			end
		end
	end)

	task.spawn(function()
		local nextMove = 0
		while alive do
			task.wait(0.1)
			local currentTime = tick()
			if currentTime > nextMove then
				nextMove = currentTime + 0.5 + math.random()
				if attacker then
					local closest = RANGE
					local target = nil
					for _, v in ipairs(game.Workspace:GetChildren()) do
						if v and v:IsA("Model") and v.Name ~= clone.Name then
							local t = v:FindFirstChild("Torso")
							local h = v:FindFirstChild("Humanoid")
							if t and h and h.Health > 0 then
								local plr = Players:GetPlayerFromCharacter(v)
								if not plr or plr ~= creator.Value then
									local mag = (t.Position - torso.Position).Magnitude
									if mag < closest and t == attacker then
										target = t
										closest = mag
									end
								end
							end
						end
					end
					if target then
						local point = target.Position + (Vector3.new(math.random() - 0.5, math.random() - 0.5, math.random() - 0.5) * 6)
						humanoid:MoveTo(point)
						if math.random() < 0.15 then
							humanoid.Jump = true
						end
					end
				else
					local creatorChar = creatorPlayer.Character
					if creatorChar and creatorChar:FindFirstChild("HumanoidRootPart") then
						humanoid:MoveTo(creatorChar.HumanoidRootPart.Position)
						if math.random() < 0.15 then
							humanoid.Jump = true
						end
					end
				end
			end
		end
	end)

	Debris:AddItem(clone, 10)
end

script.Parent.Activated:Connect(function()
	local player = Players:GetPlayerFromCharacter(script.Parent.Parent)
	local basePosition = script.Parent:IsA("Tool") and player.Character and player.Character.HumanoidRootPart.Position or script.Parent.Position
	local gingerbreadModel = ServerStorage:FindFirstChild("Gingerbread Cookie")
	if gingerbreadModel then
		for i = 1, SPAWN_COUNT do
			local spawnPos = basePosition + SPAWN_OFFSETS[i]
			local clone = gingerbreadModel:Clone()
			clone:MoveTo(spawnPos)
			setupGingerbreadCookie(clone, player)
			task.wait(SPAWN_DELAY)
		end
	end
end)