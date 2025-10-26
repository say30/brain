--[[
  Extracted from: ServerScriptService.Services.CommandsService.Commands.setrebirth
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local module = function(Conch, Config)
	Conch.register("setrebirth", {
		permissions = { Config.RequiredRole or "set-rebirth" },
		arguments = function()
			return {
				kind = "argument",
				type = "number",
				name = "Amount",
			}
		end,
		callback = function(amount)
			if amount == nil then
				return
			end

			if amount > 14 then
				return
			end

			local ctx = Conch.get_command_context()
			local player = ctx and ctx.executor and ctx.executor.player

			if not player then
				return
			end

			local success, result = pcall(function()
				local DataManagement = require(game.ServerScriptService.Services.DataManagment)
				local Synchronizer = require(game.ReplicatedStorage.Packages.Synchronizer)
				local PlotsService = require(game.ServerScriptService.Services.Plots)
				local PlotConstants = require(game.ServerScriptService.Services.Plots.PlotConstants)
				local ReplicatedStorage = game:GetService("ReplicatedStorage")

				local data = DataManagement.GetDataMan(player)
				if not data then
					return false
				end

				local playerSync = Synchronizer:Get(player)
				if not playerSync then
					return false
				end

				data.Rebirths = amount

				local Bases = require(ReplicatedStorage.Datas.Bases)
				local maxAnimals = Bases[amount] and Bases[amount].MaxAnimals or 6

				for i = 1, maxAnimals do
					data.AnimalList[i] = PlotConstants.STATES.EMPTY
				end

				if PlotsService.HandlePlayerRebirth then
					PlotsService.HandlePlayerRebirth(player, amount)
				else
					local plot = PlotsService.getPlot(player)
					if plot then
						local animalManager = plot.GetAnimalManager and plot:GetAnimalManager()
						if animalManager and animalManager.ClearAllAnimals then
							animalManager:ClearAllAnimals()
						end
					end
				end

				if playerSync then
					playerSync:Set("Rebirth", data.Rebirths)
					playerSync:Set("Coins", data.Coins)

					task.spawn(function()
						task.wait(0.1)
						playerSync:Set("AnimalAddedOrRemoved", data.AnimalList)
						task.wait(0.05)
						playerSync:Set("AnimalPodiums", data.AnimalList)
					end)
				end

				return true
			end)

			if success and result then
				return "set"
			else
				return
			end
		end,
	})
end

return module