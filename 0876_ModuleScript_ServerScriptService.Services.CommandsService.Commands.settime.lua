--[[
  Extracted from: ServerScriptService.Services.CommandsService.Commands.settime
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local module = function(Conch, Config)
	Conch.register("settime", {
		permissions = { Config.RequiredRole or "set-time" },
		arguments = function()
			return {
				kind = "argument",
				type = "number",
				name = "amount",
			}
		end,

		callback = function(amount)
			if amount == nil then
				return "amount must not be nil!"
			end

			local Lighting = game:GetService("Lighting")
			Lighting.TimeOfDay = amount


			return "set"
		end,
	})
end

return module