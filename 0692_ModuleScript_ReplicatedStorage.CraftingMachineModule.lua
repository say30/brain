--[[
  Extracted from: ReplicatedStorage.CraftingMachineModule
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local CraftingMachine = {}

CraftingMachine.Recipes = {
	["Las Capuchinas"] = {
		Requires = {"Ballerina Cappuccina", "Ballerina Cappuccina", "Tralalita Tralala", "Tralalita Tralala"},
		Result = "Las Capuchinas"
	},
	["Los Bros"] = {
		Requires = {"Los Tungtungtungcitos", "Los Tralaleritos", "Los Combinasionas", "La Grande Combinasion"},
		Result = "Los Bros"
	},
	["La Karkerkar Combinasion"] = {
		Requires = {"La Grande Combinasion", "La Grande Combinasion", "Karkerkar Kurkur", "Karkerkar Kurkur"},
		Result = "La Karkerkar Combinasion"
	},
	["Las Sis"] = {
		Requires = {"Las Capuchinas", "Los Combinasionas", "Las Tralaleritas", "Las Tralaleritas"},
		Result = "Las Sis"
	},
	["Fragola La La La"] = {
		Requires = {"Odin Din Din Dun", "Odin Din Din Dun", "Odin Din Din Dun", "Sammyni Spyderini"},
		Result = "Fragola La La La"
	},
	["Antonio"] = {
		Requires = {"Frigo Camelo", "Bombardiro Crocodilo", "Ganganzelli Trulala", "Ganganzelli Trulala"},
		Result = "Antonio"
	},
	["Los Noobinis"] = {
		Requires = {"Noobini Pizzanini", "Noobini Pizzanini", "Noobini Pizzanini", "Carrotini Brainini"},
		Result = "Los Noobinis"
	},
	["Orcalita Orcala"] = {
		Requires = {"Orcalero Orcala", "Orcalero Orcala", "Tralalita Tralala", "Espresso Signora"},
		Result = "Orcalita Orcala"
	},
	["Tralaledon"] = {
		Requires = {"Tralalero Tralala", "Tralalero Tralala", "Tralalero Tralala", "Nuclearo Dinossauro"},
		Result = "Tralaledon"
	},
	["Celularcini Viciosini"] = {
		Requires = {"La Grande Combinasion", "La Grande Combinasion", "Pot Hotspot", "Job Job Job Sahur"},
		Result = "Celularcini Viciosini"
	},
	["La Sahur Combinasion"] = {
		Requires = {"Ta Ta Ta Ta Sahur", "Te Te Te Sahur", "Job Job Job Sahur", "Graipuss Medussi"},
		Result = "La Sahur Combinasion"
	},
	["Trenostruzzo Turbo 4000"] = {
		Requires = {"Girafa Celestre", "Girafa Celestre", "Trenostruzzo Turbo 3000", "Trenostruzzo Turbo 3000"},
		Result = "Trenostruzzo Turbo 4000"
	},
}

local function getNext30MinuteMark(now)
	local dateTable = os.date("*t", now)
	local minute = dateTable.min
	local second = dateTable.sec
	local addMinutes = 0
	if minute < 30 then
		addMinutes = 30 - minute
	else
		addMinutes = 60 - minute
	end
	local nextTime = now + addMinutes * 60 - second
	return nextTime
end

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Workspace = game:GetService("Workspace")


if not CraftingMachine.GlobalData then
	CraftingMachine.GlobalData = {
		NextUpdateTime = getNext30MinuteMark(os.time()),
		AvailableRecipes = {},
		CraftTimers = {},
		PlayerBases = {}
	}
end

local function getRandomRecipes(n)
	local allNames = {}
	for k, _ in CraftingMachine.Recipes do
		table.insert(allNames, k)
	end
	local selected = {}
	while #selected < n and #allNames > 0 do
		local idx = math.random(1, #allNames)
		table.insert(selected, allNames[idx])
		table.remove(allNames, idx)
	end
	local result = {}
	for i, name in selected do
		result[name] = CraftingMachine.Recipes[name]
	end
	return result
end

function CraftingMachine:GlobalRefresh()

	self.GlobalData.NextUpdateTime = getNext30MinuteMark(os.time())
	self.GlobalData.AvailableRecipes = getRandomRecipes(5)
	self.GlobalData.CraftTimers = {}
end

function CraftingMachine:InitGlobal()

	local now = os.time()
	if (not next(self.GlobalData.AvailableRecipes)) or (self.GlobalData.NextUpdateTime <= now) then
		self:GlobalRefresh()
	end
end

function CraftingMachine:GetPlayerBase(player)
	local animalList = {}
	local DataManagment = nil
	local ok, dm = pcall(function()
		return require(ServerScriptService.Services.DataManagment)
	end)
	if ok then DataManagment = dm end
	if DataManagment and DataManagment.getAnimalList then
		local list = DataManagment.getAnimalList(player)
		for k, entry in list do
			if entry and typeof(entry) == "table" then
				local entryName = entry.Index or entry.Name or entry.DisplayName or entry[1]
				if entryName then
					animalList[entryName] = true
				end
			end
		end
	end
	local plotsFolder = Workspace:FindFirstChild("Plots")
	if plotsFolder then
		local playerPlot = nil
		for _, plot in plotsFolder:GetChildren() do
			local ownerName = plot:GetAttribute("Owner") or plot.Name
			local ownerId = plot:GetAttribute("OwnerId")
			if ownerName == player.Name or ownerId == player.UserId then
				playerPlot = plot
				break
			end
		end
		if playerPlot then
			for _, obj in playerPlot:GetDescendants() do
				animalList[obj.Name] = true
			end
		end
	end
	return animalList
end

function CraftingMachine:CanCraft(player, recipeName)
	local recipe = self.GlobalData.AvailableRecipes[recipeName]
	if not recipe then return false end
	local animalList = self:GetPlayerBase(player)
	for k, req in recipe.Requires do
		if not animalList[req] then
			return false
		end
	end
	return true
end

function CraftingMachine:Craft(player, recipeName)
	local recipe = self.GlobalData.AvailableRecipes[recipeName]
	if not recipe then return false, "Recipe not available" end
	if not self:CanCraft(player, recipeName) then
		return false, "Missing required animals"
	end
	local DataManagment = nil
	local ok, dm = pcall(function()
		return require(ServerScriptService.Services.DataManagment)
	end)
	if ok then DataManagment = dm end
	local function removeAnimalByName(player, animalName)
		if DataManagment and DataManagment.getAnimalList then
			local animalList = DataManagment.getAnimalList(player)
			local foundSlot = nil
			for k, entry in animalList do
				if entry and typeof(entry) == "table" then
					local entryName = entry.Index or entry.Name or entry.DisplayName or entry[1]
					if entryName == animalName then
						foundSlot = k
						break
					end
				end
			end
			if foundSlot then
				animalList[foundSlot] = "Empty"
				if DataManagment.setAnimalList then
					DataManagment.setAnimalList(player, animalList)
				end
			end
		end
	end
	for k, animalName in recipe.Requires do
		removeAnimalByName(player, animalName)
	end
	if DataManagment and DataManagment.addAnimal then
		DataManagment.addAnimal(player, recipe.Result)
	end
	self.GlobalData.CraftTimers[recipeName] = os.time() + 1800
	return true, recipe.Result
end

function CraftingMachine:GetGlobalData(players)
	local data = {}
	for _, player in players do
		data[player.UserId] = self:GetPlayerBase(player)
	end
	self.GlobalData.PlayerBases = data
	return self.GlobalData
end

return CraftingMachine

