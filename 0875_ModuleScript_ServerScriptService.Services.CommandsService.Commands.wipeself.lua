--[[
  Extracted from: ServerScriptService.Services.CommandsService.Commands.wipeself
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local module = function(Conch, Config)
	Conch.register("wipeself", {
		permissions = { Config.RequiredRole or "wipe-self" },
		arguments = function()
			return
		end,

		callback = function()
			local ctx = Conch.get_command_context()
			local player = ctx and ctx.executor and ctx.executor.player

			local DataManagement = require(game.ServerScriptService.Services.DataManagment)

			DataManagement.resetPlayerData(player)
			return "resetted"
		end,
	})
end

return module