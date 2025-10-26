--[[
  Extracted from: ServerScriptService.Services.CmdrService.Commands.CustomCommands.startglobaleventServer
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local MessagingService = game:GetService("MessagingService")
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function startGlobalEvent(eventName, duration)
	local EventService = _G.EventService
	if not EventService then
		return false, "EventService is not available"
	end

	if not EventService:GetEventInfo(eventName) then
		return false, "Event '" .. eventName .. "' not found"
	end

	local success = EventService:StartEvent(eventName, duration)
	if success then
		return true, "Event started successfully"
	else
		return false, "Failed to start event (may already be active)"
	end
end

local function stopGlobalEvent(eventName)
	local EventService = _G.EventService
	if not EventService then
		return false, "EventService is not available"
	end

	local success = EventService:StopEvent(eventName)
	if success then
		return true, "Event stopped successfully"
	else
		return false, "Failed to stop event (may not be active)"
	end
end

local function startRandomGlobalEvent()
	local EventService = _G.EventService
	if not EventService then
		return false, "EventService is not available"
	end

	local success = EventService:StartRandomEvent()
	if success then
		return true, "Random event started successfully"
	else
		return false, "Failed to start random event (no events available)"
	end
end

local function stopAllGlobalEvents()
	local EventService = _G.EventService
	if not EventService then
		return false, "EventService is not available"
	end

	local stoppedEvents = EventService:ForceStopAllEvents()
	if #stoppedEvents > 0 then
		return true, string.format("Stopped %d events: %s", #stoppedEvents, table.concat(stoppedEvents, ", "))
	else
		return false, "No active events to stop"
	end
end

return function(context, action, eventName, duration)
	local player = context.Executor

	if not _G.GlobalEventSubscriptionsSet then
		_G.GlobalEventSubscriptionsSet = true

		MessagingService:SubscribeAsync("GlobalEventStart", function(message)
			local data = message.Data
			if data.FromServer == game.JobId then return end

			local success, result = pcall(function()
				return startGlobalEvent(data.EventName, data.Duration)
			end)

			if not success then
				warn("Failed to start global event:", result)
			end
		end)

		MessagingService:SubscribeAsync("GlobalEventStop", function(message)
			local data = message.Data
			if data.FromServer == game.JobId then return end

			local success, result = pcall(function()
				return stopGlobalEvent(data.EventName)
			end)

			if not success then
				warn("Failed to stop global event:", result)
			end
		end)

		MessagingService:SubscribeAsync("GlobalEventRandom", function(message)
			local data = message.Data
			if data.FromServer == game.JobId then return end

			local success, result = pcall(function()
				return startRandomGlobalEvent()
			end)

			if not success then
				warn("Failed to start random global event:", result)
			end
		end)

		MessagingService:SubscribeAsync("GlobalEventStopAll", function(message)
			local data = message.Data
			if data.FromServer == game.JobId then return end

			local success, result = pcall(function()
				return stopAllGlobalEvents()
			end)

			if not success then
				warn("Failed to stop all global events:", result)
			end
		end)
	end

	action = action:lower()

	if action == "start" then
		if not eventName then
			return "❌ Global event name is required for start action!"
		end

		local success, result = startGlobalEvent(eventName, duration)
		if not success then
			return "❌ Failed to start event locally: " .. tostring(result)
		end

		local publishSuccess, publishError = pcall(function()
			MessagingService:PublishAsync("GlobalEventStart", {
				EventName = eventName,
				Duration = duration,
				FromServer = game.JobId,
				Executor = context.Executor.Name
			})
		end)

		if not publishSuccess then
			warn("Failed to publish global event start message:", publishError)
			return "⚠️ Event started locally but failed to broadcast globally: " .. tostring(publishError)
		end

		return "✅ Successfully started '" .. eventName .. "' globally across all servers!"

	elseif action == "stop" then
		if not eventName then
			return "❌ Global event name is required for stop action!"
		end

		local success, result = stopGlobalEvent(eventName)
		if not success then
			return "❌ Failed to stop event locally: " .. tostring(result)
		end

		local publishSuccess, publishError = pcall(function()
			MessagingService:PublishAsync("GlobalEventStop", {
				EventName = eventName,
				FromServer = game.JobId,
				Executor = context.Executor.Name
			})
		end)

		if not publishSuccess then
			warn("Failed to publish global event stop message:", publishError)
			return "⚠️ Event stopped locally but failed to broadcast globally: " .. tostring(publishError)
		end

		return "✅ Successfully stopped '" .. eventName .. "' globally across all servers!"

	elseif action == "list" then
		local EventService = _G.EventService
		if not EventService then
			return "❌ EventService is not initialized!"
		end

		local registeredEvents = EventService:GetAllRegisteredEvents()
		local eventNames = {}

		for name, info in pairs(registeredEvents) do
			local status = info.isActive and " (ACTIVE)" or ""
			table.insert(eventNames, name .. status)
		end

		if #eventNames == 0 then
			return "No events registered."
		end

		return "Registered events:\n" .. table.concat(eventNames, "\n")

	elseif action == "status" then
		local EventService = _G.EventService
		if not EventService then
			return "❌ EventService is not initialized!"
		end

		local status = EventService:GetEventStatus()
		local activeEvents = EventService:GetActiveEvents()

		local result = {
			string.format("Event Service Status:"),
			string.format("• Registered Events: %d", status.registeredCount),
			string.format("• Active Events: %d", status.activeCount)
		}

		if #status.activeEvents > 0 then
			table.insert(result, "\nActive Events:")
			for _, eventName in pairs(status.activeEvents) do
				local eventInfo = activeEvents[eventName]
				local timeRemaining = math.floor(eventInfo.timeRemaining)
				table.insert(result, string.format("• %s (%ds remaining)", eventName, timeRemaining))
			end
		end

		return table.concat(result, "\n")

	elseif action == "random" then
		local success, result = startRandomGlobalEvent()
		if not success then
			return "❌ Failed to start random event locally: " .. tostring(result)
		end

		local publishSuccess, publishError = pcall(function()
			MessagingService:PublishAsync("GlobalEventRandom", {
				FromServer = game.JobId,
				Executor = context.Executor.Name
			})
		end)

		if not publishSuccess then
			warn("Failed to publish global random event message:", publishError)
			return "⚠️ Random event started locally but failed to broadcast globally: " .. tostring(publishError)
		end

		return "✅ Successfully started a random event globally across all servers!"

	elseif action == "stopall" then
		local success, result = stopAllGlobalEvents()
		if not success then
			return "❌ Failed to stop all events locally: " .. tostring(result)
		end

		local publishSuccess, publishError = pcall(function()
			MessagingService:PublishAsync("GlobalEventStopAll", {
				FromServer = game.JobId,
				Executor = context.Executor.Name
			})
		end)

		if not publishSuccess then
			warn("Failed to publish global stop all events message:", publishError)
			return "⚠️ Events stopped locally but failed to broadcast globally: " .. tostring(publishError)
		end

		return "✅ Successfully stopped all events globally across all servers!"

	else
		return "❌ Invalid action! Use: start, stop, list, status, random, stopall"
	end
end 