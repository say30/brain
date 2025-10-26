--[[
  Extracted from: ServerScriptService.Services.CommandsService.Commands.executeallevents
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local module = function(Conch, Config)
	Conch.register("executeallevents", {
		permissions = { Config.RequiredRole or "super-user" },
		arguments = function()
			return {
				{
					kind = "argument",
					type = "number",
					name = "Duration",
					optional = true,
				}
			}
		end,
		callback = function(duration)
			local svc = _G and _G.EventService
			if not svc then
				return false, "EventService not initialised"
			end

			local events = svc.GetAllEvents and svc:GetAllEvents() or svc.Events
			if not events then
				return false, "No events available to start"
			end

			local results = {}
			for _, eventName in ipairs(events) do
				if not string.find(eventName, "Phase") then
					local ok = svc:StartEvent(eventName, duration)
					table.insert(results, ok and (eventName .. ": ✅") or (eventName .. ": ❌"))
				else
					table.insert(results, eventName .. ": ⏭️ (skipped)")
				end
			end

			return "executed"
		end,
	})
end

return module
