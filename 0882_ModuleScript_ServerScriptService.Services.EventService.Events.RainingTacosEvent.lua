--[[
  Extracted from: ServerScriptService.Services.EventService.Events.RainingTacosEvent
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")
local HttpService = game:GetService("HttpService")

local Packages = ReplicatedStorage.Packages
local Net = require(Packages.Net)
local RoadAnimalService = require(ServerScriptService.Services.RoadAnimalService)

local RainingTacosEvent = {}
RainingTacosEvent.__index = RainingTacosEvent

function RainingTacosEvent.new()
	local self = setmetatable({}, RainingTacosEvent)

	self._shootRemote = Net:RemoteEvent("EventService/RainingTacos/Shoot")
	self._activeConnections = {}
	self._shootTimer = nil
	self._recentlyTargeted = {}

	return self
end

function RainingTacosEvent:Start()
	self._shootTimer = task.spawn(function()
		while true do
			task.wait(math.random(1, 3))

			local CollectionService = game:GetService("CollectionService")
			local roadAnimals = CollectionService:GetTagged("Animal")

			local activeRoadAnimals = {}
			local movingAnimalsFolder = workspace:FindFirstChild("MovingAnimals")
			for _, animal in pairs(roadAnimals) do
				if animal.Parent == movingAnimalsFolder and animal.PrimaryPart and string.find(animal.Name, "RoadAnimal_") then
					table.insert(activeRoadAnimals, animal)
				end
			end
			local roadAnimals = activeRoadAnimals

			if #roadAnimals > 0 then
				local availableAnimals = {}
				local currentTime = workspace:GetServerTimeNow()

				for animalName, lastTargeted in pairs(self._recentlyTargeted) do
					if (currentTime - lastTargeted) > 15 then
						self._recentlyTargeted[animalName] = nil
					end
				end

				for _, animal in pairs(roadAnimals) do
					local lastTargeted = self._recentlyTargeted[animal.Name]
					if not lastTargeted or (currentTime - lastTargeted) > 10 then
						table.insert(availableAnimals, animal)
					end
				end

				if #availableAnimals > 0 then
					local targetAnimal = availableAnimals[math.random(1, #availableAnimals)]
					local animalId = targetAnimal.Name

					if not self:_hasTacoTrait(targetAnimal) then
						self._recentlyTargeted[animalId] = currentTime

						local arrivalTime = currentTime + 2.5

						self._shootRemote:FireAllClients(animalId, arrivalTime)

						task.delay(5.1, function()
							self:_applyTacoTrait(targetAnimal)
						end)
					end
				end
			end
		end
	end)
end

function RainingTacosEvent:_hasTacoTrait(animalTemplate)
	if not animalTemplate or not animalTemplate.Parent then
		return false
	end

	local currentTraitsJson = animalTemplate:GetAttribute("Traits")
	local currentTraits = {}

	if currentTraitsJson then
		local success, decoded = pcall(function()
			return HttpService:JSONDecode(currentTraitsJson)
		end)
		if success and type(decoded) == "table" then
			currentTraits = decoded
		end
	end

	for _, trait in ipairs(currentTraits) do
		if trait == "Taco" then
			return true
		end
	end

	return false
end

function RainingTacosEvent:_applyTacoTrait(animalTemplate)
	if not animalTemplate or not animalTemplate.Parent then
		return
	end

	local currentTraitsJson = animalTemplate:GetAttribute("Traits")
	local currentTraits = {}

	if currentTraitsJson then
		local success, decoded = pcall(function()
			return HttpService:JSONDecode(currentTraitsJson)
		end)
		if success and type(decoded) == "table" then
			currentTraits = decoded
		end
	end

	local hasTacoTrait = false
	for _, trait in ipairs(currentTraits) do
		if trait == "Taco" then
			hasTacoTrait = true
			break
		end
	end

	if not hasTacoTrait then
		table.insert(currentTraits, "Taco")

		local newTraitsJson = HttpService:JSONEncode(currentTraits)
		animalTemplate:SetAttribute("Traits", newTraitsJson)
	end
end

function RainingTacosEvent:Stop()
	if self._shootTimer then
		task.cancel(self._shootTimer)
		self._shootTimer = nil
	end

	for _, connection in pairs(self._activeConnections) do
		if connection then
			connection:Disconnect()
		end
	end
	self._activeConnections = {}
end

return RainingTacosEvent
