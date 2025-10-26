--[[
  Extracted from: ReplicatedStorage.Controllers.AnimalController
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local replicatedStorage = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")

local packages = replicatedStorage:WaitForChild("Packages")
local observers = require(packages.Observers)
local synchronizer = require(packages.Synchronizer)
local Signal = require(packages.Signal)
local Net = require(packages.Net)
local Trove = require(packages.Trove)

local classes = replicatedStorage:WaitForChild("Classes")
local AnimalClient = require(classes.AnimalClient)

local Animals = {}
local LocalPlayer = players.LocalPlayer

local RemoteEvent1 = Net:RemoteEvent("33094f22-ae31-46fd-88a7-27cb2c124c68")
local RemoteEvent2 = Net:RemoteEvent("66c7b24d-afa4-4e21-bc48-9c829967a853")

local function safeFire(remote, ...)
	if remote and typeof(remote.FireServer) == "function" then
		remote:FireServer(...)
	end
end

local Module = {
	OnAnimalSpawn = Signal.new(),
	OnAnimalDestroyed = Signal.new(),
	OnFollowingChanged = Signal.new(),
}

function Module:HasAnimalMovingToBase()
	for _, animal in pairs(Animals) do
		local primary = animal.Instance and animal.Instance.PrimaryPart
		local attachment = primary and primary:FindFirstChild("PromptAttachment")
		local prompt = attachment and attachment:FindFirstChild("ProximityPrompt")
		if prompt and prompt:GetAttribute("TargetPlayer") == LocalPlayer.UserId then
			return animal
		end
	end
end

function Module:HasAnimal(index, count)
	count = count or 1
	local data = synchronizer:Get(LocalPlayer)
	if not data then
		return false
	end
	local found = 0
	local slots = {}
	local podiums = data:Get("AnimalPodiums") or {}
	for podium, value in pairs(podiums) do
		if value ~= "Empty" and value.Index == index then
			found = found + 1
			table.insert(slots, podium)
		end
	end
	return count <= found, slots
end

function Module:GetAnimals()
	return Animals
end

function Module:Start()
	observers.observeTag("Animal", function(instance)
		local animal = AnimalClient.new(instance)
		local uid = animal:GetUID()
		animal.UID = uid
		Animals[uid] = animal

		animal.Collector:Add(observers.observeTag("AnimalPurchasePrompt", function(prompt)
			return observers.observeAttribute(prompt, "TargetPlayer", function(playerId)
				Module.OnFollowingChanged:Fire(animal.Index, animal.UID, playerId)
				return nil
			end)
		end, { animal.Instance }))

		Module.OnAnimalSpawn:Fire(animal)

		return function()
			local id = animal.UID
			animal:Destroy()
			Animals[id] = nil
			Module.OnAnimalDestroyed:Fire(id)
		end
	end)

	observers.observeTag("AnimalPurchasePrompt", function(prompt)
		local janitor = Trove.new()

		local function updateEnabled()
			if prompt:GetAttribute("TargetPlayer") == LocalPlayer.UserId then
				prompt.Enabled = false
			else
				prompt.Enabled = not prompt:GetAttribute("Disabled")
			end
		end

		janitor:Add(prompt:GetAttributeChangedSignal("TargetPlayer"):Connect(updateEnabled))
		janitor:Add(prompt:GetAttributeChangedSignal("Disabled"):Connect(updateEnabled))

		updateEnabled()

		local uid = prompt:GetAttribute("UID")

		janitor:Add(prompt.PromptButtonHoldBegan:Connect(function()
			safeFire(RemoteEvent2, workspace:GetServerTimeNow() + 222, "1ae60adf-47e4-4395-b011-8e092ab239eb")
			RemoteEvent2:FireServer(workspace:GetServerTimeNow() + 222, "2f50452e-560d-46c0-9bba-85e82addf934")
		end))

		janitor:Add(prompt.Triggered:Connect(function()
			safeFire(RemoteEvent1, workspace:GetServerTimeNow() + 125, "064f9995-3c29-4b3d-bf62-9d93de6836ae", uid)
			RemoteEvent1:FireServer(workspace:GetServerTimeNow() + 125, "e7b56b5c-a11a-4dfd-997d-d16b81dd3fed", uid)
		end))

		return function()
			janitor:Destroy()
		end
	end)
end

return Module