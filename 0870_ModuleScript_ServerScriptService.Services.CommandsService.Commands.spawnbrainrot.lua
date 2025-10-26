--[[
  Extracted from: ServerScriptService.Services.CommandsService.Commands.spawnbrainrot
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local module = function(Conch, Config)
	Conch.register("spawnbrainrot", {
		permissions = { Config.RequiredRole or "super-user" },
		arguments = function()
			return
				{
					kind = "argument",
					type = "Brainrot",
					name = "Brainrot",
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
				return false, "buddy."
			end

			local roadService = _G and _G.RoadAnimalService

			local mutParam
			if mutation == "Normal" or mutation == "" or mutation == nil then
				mutParam = nil
			else
				mutParam = mutation
			end

			local successCount = 0
			for i = 1, amount do
				local ok, res = pcall(function()
					return roadService.Spawner:SpawnSpecificAnimal(brainrot, nil, mutParam)
				end)
				if ok and res then
					successCount = successCount + 1
				end
			end

			if successCount == 0 then
				return false, string.format("Failed to spawn any %s", brainrot)
			end

			return "spawned"
		end,
	})
end

return module 