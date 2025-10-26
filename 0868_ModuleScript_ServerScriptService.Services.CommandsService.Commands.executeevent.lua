--[[
  Extracted from: ServerScriptService.Services.CommandsService.Commands.executeevent
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local module = function(Conch, Config)
	Conch.register("executeevent", {
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
			local svc = _G and _G.EventService
			if not svc then
				return false, "EventService not initialised"
			end
			local ok = svc:StartEvent(eventName, duration)
			return "executed"
		end,
	})
end

return module 