--[[
  Extracted from: ServerScriptService.Services.CmdrService.Types.TraitName
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Traits = require(ReplicatedStorage.Datas.Traits)

return function(registry)
	local traitNameType = {
		Transform = function(text)
			local traitNames = {}
			local matchingTraits = {}

			for traitName, traitData in pairs(Traits) do
				table.insert(traitNames, traitName)
			end

			local lowerText = text:lower()
			for _, traitName in ipairs(traitNames) do
				if traitName:lower():find(lowerText, 1, true) then
					table.insert(matchingTraits, traitName)
				end
			end

			table.sort(matchingTraits, function(a, b)
				local aExact = a:lower() == lowerText
				local bExact = b:lower() == lowerText
				if aExact and not bExact then return true end
				if bExact and not aExact then return false end
				return a < b
			end)

			return matchingTraits
		end,

		Validate = function(traits)
			return #traits > 0, "No trait with that name could be found."
		end,

		Autocomplete = function(traits)
			return traits
		end,

		Parse = function(traits)
			return traits[1]
		end,
	}

	registry:RegisterType("traitName", traitNameType)
end