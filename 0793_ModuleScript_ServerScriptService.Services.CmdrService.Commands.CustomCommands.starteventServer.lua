--[[
  Extracted from: ServerScriptService.Services.CmdrService.Commands.CustomCommands.starteventServer
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

return function(context, eventName, duration)
	local EventService = _G.EventService
	if not EventService then
		return "EventService is not initialized!"
	end

	if not eventName then
		return "You must specify an event name or 'random'!"
	end

	eventName = eventName:lower()

	if eventName == "random" then
		local success = EventService:StartRandomEvent()
		if success then
			return "Successfully started a random event!"
		else
			return "Failed to start random event (no events available)"
		end
	else
		local success = EventService:StartEvent(eventName, duration)
		if success then
			return string.format("Successfully started event: %s", eventName)
		else
			return string.format("Failed to start event: %s", eventName)
		end
	end
end