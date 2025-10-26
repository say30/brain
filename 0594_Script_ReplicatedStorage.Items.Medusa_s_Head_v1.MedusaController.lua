--[[
  Extracted from: ReplicatedStorage.Items.Medusa's Head v1.MedusaController
  Class: Script
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Debris = game:GetService("Debris")
local Packages = ReplicatedStorage:WaitForChild("Packages")
local Net = require(Packages.Net)
local RagdollModule = require(ReplicatedStorage.Packages.Ragdoll)

local debounce = {}
local COOLDOWN = 25 -- cooldown in seconds

local function TagHumanoid(humanoid, player)
	local Creator_Tag = Instance.new("ObjectValue")
	Creator_Tag.Name = "creator"
	Creator_Tag.Value = player
	Debris:AddItem(Creator_Tag, 2)
	Creator_Tag.Parent = humanoid
end

Net:RemoteFunction("MedusaHead/Transform").OnServerInvoke = function(player)
	if not player.Character then
		return
	end
	local tool = player.Character:FindFirstChildWhichIsA("Tool")

	local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
	if not humanoid or humanoid.Health <= 0 then
		return
	end
	local head = player.Character:FindFirstChild("Head")
	if not head then
		return
	end
	player.Character.Archivable = true

	-- Cooldown check
	if debounce[player] and tick() - debounce[player] < COOLDOWN then
		return 0
	end

	local regionPos = head.Position
	local radius = 15 
	for _, targetPlayer in pairs(Players:GetPlayers()) do
		if targetPlayer ~= player and targetPlayer.Character then
			targetPlayer.Character.Archivable = true

			local targetCharacter = targetPlayer.Character
			local targetHumanoid = targetCharacter:FindFirstChildOfClass("Humanoid")
			local targetRootPart = targetCharacter:FindFirstChild("HumanoidRootPart")
			if targetHumanoid and targetRootPart and targetHumanoid.Health > 0 then
				local distance = (targetRootPart.Position - regionPos).Magnitude
				if distance <= radius then
					local forceFieldExists = false
					for _, v in pairs(targetCharacter:GetChildren()) do
						if v:IsA("ForceField") then
							forceFieldExists = true
							break
						end
					end
					if not forceFieldExists then
						TagHumanoid(targetHumanoid, player)
						local stoneClone = targetCharacter:Clone()
						stoneClone.Parent = workspace
						stoneClone.HumanoidRootPart.CFrame = targetCharacter.HumanoidRootPart.CFrame
						for _, v in pairs(stoneClone:GetChildren()) do
							if v:IsA("BasePart") then
								v.Anchored = true
								v.BrickColor = BrickColor.new("Dark stone grey")
								v.Material = Enum.Material.SmoothPlastic
							elseif v:IsA("Humanoid") then
								v:Destroy()
							end
						end
						Debris:AddItem(stoneClone, 5)
						RagdollModule.TimedRagdoll(targetCharacter, 5)
					end
				end
			end
		end
	end
	debounce[player] = tick()
	return 5
end

local tool = script.Parent
tool.Equipped:Connect(function()
	local player = script:FindFirstAncestorWhichIsA("Player") or Players:GetPlayerFromCharacter(script.Parent.Parent)
	if player and player:GetAttribute("Stealing") then
		tool.Parent = player.Backpack
	end
end)
