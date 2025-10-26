--[[
  Extracted from: ReplicatedStorage.Controllers.EventController
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Net = require(ReplicatedStorage.Packages.Net)
local Synchronizer = require(ReplicatedStorage.Packages.Synchronizer)
local EventTypes = require(ReplicatedStorage.Shared.EventTypes)

local SynchronizerInstance

local EventController = {
	Events = {}
}

function EventController:GetActiveEvents()
	if SynchronizerInstance == nil then
		return {}
	end
	return SynchronizerInstance:Get("ActiveEvents") or {}
end

function EventController:GetActiveEventData(EventName)
	for Index, EventData in self:GetActiveEvents() do
		if EventData.eventName == EventName then
			return EventData, Index
		end
	end
	return nil, nil
end

function EventController:IsActive(EventName)
	local EventData, Index = self:GetActiveEventData(EventName)
	return EventData ~= nil, Index
end

function EventController:Execute(EventName)
	local Event = self.Events[EventName]
	if not Event then
		return false
	end
	if type(Event.OnStart) == "function" then
		Event:OnStart()
	end
	return true
end

function EventController:Cancel(EventName)
	local Event = self.Events[EventName]
	if not Event then
		return false
	end
	if type(Event.OnStop) == "function" then
		Event:OnStop()
	end
	return true
end

function EventController:Load()
	for _, Module in script.Events:GetChildren() do
		if Module:IsA("ModuleScript") then
			local Success, Event = coroutine.resume(coroutine.create(require), Module)
			if not Success or type(Event) ~= "table" then
				warn(("Event %s failed to load:\n%s"):format(Module:GetFullName(), Event == nil and "yielded (possibly)" or Event))
			else
				if type(Event.OnLoad) == "function" then
					local LoadSuccess, LoadError = coroutine.resume(coroutine.create(Event.OnLoad), Event)
					if not LoadSuccess then
						warn(("Event %s failed to call Load function:\n%s"):format(Module:GetFullName(), LoadError == nil and "yielded (possibly)" or LoadError))
						continue
					end
				end
				self.Events[Module.Name] = Event
			end
		end
	end
end

function EventController:Start()
	task.wait(1)

	local MaxRetries = 10
	local RetryDelay = 0.5
	local RetryCount = 0

	local function TryGetSynchronizer()
		local Success, Result = pcall(function()
			return Synchronizer:Get("Events")
		end)
		if Success and Result then
			return Result
		end
		Success, Result = pcall(function()
			return Synchronizer:Wait("Events")
		end)
		if Success and Result then
			return Result
		end
		return nil
	end

	local function AttemptConnection()
		while RetryCount < MaxRetries do
			local Sync = TryGetSynchronizer()
			if Sync then
				SynchronizerInstance = Sync
				return true
			end
			RetryCount = RetryCount + 1
			if RetryCount < MaxRetries then
				task.wait(RetryDelay)
				RetryDelay = math.min(RetryDelay * 1.5, 5)
			end
		end
		return false
	end

	if not AttemptConnection() then
		return
	end

	SynchronizerInstance:OnArrayInserted("ActiveEvents", function(EventData)
		self:Execute(EventData.eventName)
	end)

	SynchronizerInstance:OnArrayRemoved("ActiveEvents", function(EventData)
		self:Cancel(EventData.eventName)
	end)

	for _, ActiveEvent in self:GetActiveEvents() do
		task.spawn(function()
			self:Execute(ActiveEvent.eventName)
		end)
	end
end

return EventController