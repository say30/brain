--[[
  Extracted from: ServerScriptService.Services.CommandsService.Commands.stopevent
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local module = function(Conch, Config)
	Conch.register("stopevent", {
		permissions = { Config.RequiredRole or "super-user" },
		arguments = function()
			return {
				kind = "argument",
				type = "Event",
				name = "Event",
			}
		end,
		callback = function(eventName)
			local svc = _G and _G.EventService
			if not svc then
				return false, "EventService not initialised"
			end
			local ok = svc:StopEvent(eventName)
			return "stopped"
		end,
	})
end

return module 