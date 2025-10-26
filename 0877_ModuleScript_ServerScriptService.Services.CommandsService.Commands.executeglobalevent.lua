--[[
  Extracted from: ServerScriptService.Services.CommandsService.Commands.executeglobalevent
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- // THIS IS UNTESTED MAY NOT WORK

local MessagingService = game:GetService("MessagingService")

local module = function(Conch, Config)
	Conch.register("executeglobalevent", {
		permissions = { Config.RequiredRole or "super-user" },
		arguments = function()
			return
				{
					kind = "argument",
					type = "Event",
					name = "Event",
				},
			{
				kind = "argument",
				type = "number",
				name = "Duration",
				optional = true,
			}
		end,
		callback = function(eventName, duration)
			local success, err = pcall(function()
				MessagingService:PublishAsync("4a6b4703-251a-4564-8840-0169367d6827", {
					Event = eventName,
					Duration = duration,
				})
			end)

			if not success then
				return false, "Failed to publish global event: " .. tostring(err)
			end

			return "executed"
		end,
	})

	MessagingService:SubscribeAsync("4a6b4703-251a-4564-8840-0169367d6827", function(message)
		local data = message.Data
		if typeof(data) == "table" and data.Event then
			local svc = _G and _G.EventService
			if svc then
				svc:StartEvent(data.Event, data.Duration)
				print("[GlobalEvent] Started event:", data.Event, "Duration:", data.Duration)
			else
				warn("[GlobalEvent] EventService not initialised")
			end
		end
	end)
end

return module
