--[[
  Extracted from: ServerScriptService.Services.CmdrService.Types.AnimalName
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Animals = require(ReplicatedStorage.Datas.Animals)

return function(registry)
	local animalNameType = {
		Transform = function(text)
			local animalNames = {}
			local matchingAnimals = {}

			for animalIndex, animalData in pairs(Animals) do
				table.insert(animalNames, animalIndex)
			end

			local lowerText = text:lower()
			for _, animalName in ipairs(animalNames) do
				if animalName:lower():find(lowerText, 1, true) then
					table.insert(matchingAnimals, animalName)
				end
			end

			table.sort(matchingAnimals, function(a, b)
				local aExact = a:lower() == lowerText
				local bExact = b:lower() == lowerText
				if aExact and not bExact then return true end
				if bExact and not aExact then return false end
				return a < b
			end)

			return matchingAnimals
		end,

		Validate = function(animals)
			return #animals > 0, "No animal with that name could be found."
		end,

		Autocomplete = function(animals)
			return animals
		end,

		Parse = function(animals)
			return animals[1]
		end,
	}

	registry:RegisterType("animalName", animalNameType)
end 