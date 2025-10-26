--[[
  Extracted from: ServerScriptService.Services.EventService.Events.Rain
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local CollectionService = game:GetService("CollectionService")

local Packages = ReplicatedStorage:WaitForChild("Packages")
local Net = require(Packages.Net)

local RainEvent = {}
RainEvent.__index = RainEvent

function RainEvent.new(eventService)
	local self = setmetatable({}, RainEvent)

	self._rainHitRemote = Net:RemoteEvent("EventService/Rain/Hit")
	self._isActive = false
	self._rainTask = nil

	return self
end

function RainEvent:Start()
	if self._isActive then return end
	self._isActive = true

	self._rainTask = task.spawn(function()
		while self._isActive do
			task.wait(math.random(3, 4))
			local targetAnimal = self:_pickRandomAnimal()
			if targetAnimal then
				self:_applyRainTrait(targetAnimal)
				self._rainHitRemote:FireAllClients(targetAnimal.Name)
			end
		end
	end)
end

function RainEvent:Stop()
	self._isActive = false
	if self._rainTask then
		task.cancel(self._rainTask)
		self._rainTask = nil
	end
end

function RainEvent:_pickRandomAnimal()
	local animals = CollectionService:GetTagged("Animal")
	if #animals == 0 then return nil end
	return animals[math.random(1, #animals)]
end

function RainEvent:_applyRainTrait(animal)
	if not animal or not animal.Parent then return end

	local currentTraitsJson = animal:GetAttribute("Traits")
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
		if trait == "Wet" then
			return
		end
	end

	table.insert(currentTraits, "Wet")
	animal:SetAttribute("Traits", HttpService:JSONEncode(currentTraits))
end

return RainEvent