--[[
  Extracted from: ServerScriptService.Services.CmdrService.Types.MutationName
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Mutations = require(ReplicatedStorage.Datas.Mutations)

return function(registry)
	local mutationNameType = {
		Transform = function(text)
			local mutationNames = {"Default"}
			local matchingMutations = {}

			for mutationName, mutationData in pairs(Mutations) do
				table.insert(mutationNames, mutationName)
			end

			local lowerText = text:lower()
			for _, mutationName in ipairs(mutationNames) do
				if mutationName:lower():find(lowerText, 1, true) then
					table.insert(matchingMutations, mutationName)
				end
			end

			table.sort(matchingMutations, function(a, b)
				local aExact = a:lower() == lowerText
				local bExact = b:lower() == lowerText
				if aExact and not bExact then return true end
				if bExact and not aExact then return false end
				return a < b
			end)

			return matchingMutations
		end,

		Validate = function(mutations)
			return #mutations > 0, "No mutation with that name could be found."
		end,

		Autocomplete = function(mutations)
			return mutations
		end,

		Parse = function(mutations)
			local mutation = mutations[1]
			return mutation == "Default" and nil or mutation
		end,
	}

	registry:RegisterType("mutationName", mutationNameType)
end 