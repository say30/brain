--[[
  Extracted from: ServerScriptService.Services.CommandsService.Commands.spawnluckyblock
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local module = function(Conch, Config)
	Conch.register("spawnluckyblock", {
		permissions = { Config.RequiredRole or "super-user" },
		arguments = function()
			return
				{
					kind = "argument",
					type = "LuckyBlock",
					name = "Lucky Block",
				},
			{
				kind = "argument",
				type = "number",
				name = "Amount",
				optional = true,
			},
			{
				kind = "argument",
				type = "Mutation",
				name = "Mutation",
				optional = true,
			}
		end,
		callback = function(brainrot, amount, mutation)
			amount = tonumber(amount) or 1
			if amount < 1 then
				return false, "Amount must be at least 1"
			end

			local roadService = _G and _G.RoadAnimalService
			if not roadService or not roadService.Spawner then
				return false, "RoadAnimalService not running"
			end

			local mutParam
			if mutation == "Normal" or mutation == "" or mutation == nil then
				mutParam = nil
			else
				mutParam = mutation
			end

			local successCount = 0
			for i = 1, amount do
				roadService.Spawner:SpawnSpecificAnimal(brainrot, nil, mutParam, amount)
			end

			if successCount == 0 then
				return false, string.format("Failed to spawn any %s", brainrot)
			end

			return "spawned"
		end,
	})
end

return module 