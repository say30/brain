--[[
  Extracted from: ServerScriptService.Services.CmdrService.Commands.CustomCommands.addlimitedstockServer
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local DataStoreService = game:GetService("DataStoreService")

local LIMITED_PETS = {
	[1] = {
		dataStore = DataStoreService:GetDataStore("LimitedPetStore103"),
		itemKey = "LimitedPet",
		name = "La Vacca Saturno Saturnita",
		maxQuantity = 200,
		modelName = "LimitedTimePet"
	},
	[2] = {
		dataStore = DataStoreService:GetDataStore("Limited2Pet1053"),
		itemKey = "LimitedPet2",
		name = "La Grande Combinasion",
		maxQuantity = 200,
		modelName = "LimitedTimePet2"
	},
	[3] = {
		dataStore = DataStoreService:GetDataStore("Limited2Pet10222"),
		itemKey = "LimitedPet3",
		name = "Garama and Madundung",
		maxQuantity = 362,
		modelName = "LimitedTimePet3"
	}
}

local function updatePetGui(petConfig, amount)
	local model = workspace:FindFirstChild(petConfig.modelName)
	if not model then
		warn("Model not found: " .. petConfig.modelName)
		return
	end

	local prompt = model:FindFirstChild("Root") and model.Root:FindFirstChild("ProximityPrompt")
	local quantityGui = model:FindFirstChild("GuiPart") and model.GuiPart:FindFirstChild("BillboardGui") and model.GuiPart.BillboardGui:FindFirstChild("Quantity")

	if quantityGui then
		if amount <= 0 then
			quantityGui.Text = "Out of Stock!"
			quantityGui.TextColor3 = Color3.fromRGB(255, 0, 0)
			if prompt then
				prompt.Enabled = false
			end
		else
			quantityGui.Text = amount .. "/" .. petConfig.maxQuantity .. " Left!"
			quantityGui.TextColor3 = Color3.fromRGB(85, 170, 0)
			if prompt then
				prompt.Enabled = true
			end
		end
	end
end

return function(context, petNumber, amount)
	if petNumber < 1 or petNumber > 3 then
		return "❌ Invalid pet number. Use 1, 2, or 3."
	end

	if amount <= 0 then
		return "❌ Amount must be greater than 0."
	end

	local petConfig = LIMITED_PETS[petNumber]
	if not petConfig then
		return "❌ Pet configuration not found."
	end

	local success, result = pcall(function()
		return petConfig.dataStore:UpdateAsync(petConfig.itemKey, function(current)
			current = current or petConfig.maxQuantity
			local newAmount = current + amount

			return newAmount
		end)
	end)

	if success and result then
		updatePetGui(petConfig, result)
		return string.format("✅ Added %d stock to Limited Pet %d (%s). New total: %d", 
			amount, petNumber, petConfig.name, result)
	else
		return string.format("❌ Failed to update stock for Limited Pet %d: %s", 
			petNumber, tostring(result))
	end
end