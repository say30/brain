--[[
  Extracted from: ServerScriptService.Services.Plots.AnimalManager
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local PlotConstants = require(script.Parent.PlotConstants)
local DataManagement = require(ServerScriptService.Services.DataManagment)
local Animals = require(ReplicatedStorage.Shared.Animals)

local AnimalManager = {}
AnimalManager.__index = AnimalManager

function AnimalManager.new(plot)
	local self = setmetatable({}, AnimalManager)

	self.plot = plot

	return self
end

function AnimalManager:ValidateAndRepairAnimalList(animalList)
	local needsRepair = false
	local cleanedList = {}

	for i, animal in pairs(animalList) do
		if animal == PlotConstants.STATES.EMPTY or animal == nil then
			cleanedList[i] = PlotConstants.STATES.EMPTY
		elseif typeof(animal) == "table" then
			if animal.Index then
				cleanedList[i] = animal
			else
				cleanedList[i] = PlotConstants.STATES.EMPTY
				needsRepair = true
			end
		else
			cleanedList[i] = PlotConstants.STATES.EMPTY
			needsRepair = true
		end
	end

	if needsRepair then
		self:_updateAnimalListEverywhere(cleanedList)
	end

	return cleanedList
end

function AnimalManager:ClaimCoins(slot)
	local owner = self.plot:GetOwner()
	local animalList = self.plot:GetAnimalList()
	local animal = animalList[slot]

	if not animal or typeof(animal) ~= "table" or not animal.LastCollect then
		return false, 0
	end

	local currentTime = workspace:GetServerTimeNow()
	local regularCoins = math.floor((currentTime - animal.LastCollect) * 
		Animals:GetGeneration(animal.Index, animal.Mutation, animal.Traits or {}, owner))

	local offlineCoins = 0
	if animal.OfflineGain then
		offlineCoins = math.floor(animal.OfflineGain * 
			Animals:GetGeneration(animal.Index, animal.Mutation, animal.Traits or {}, owner))
	end

	local totalCoins = regularCoins + offlineCoins

	if totalCoins <= 0 then
		return false, 0
	end

	DataManagement.addCoins(owner, totalCoins)

	animalList[slot].LastCollect = currentTime
	animalList[slot].OfflineGain = nil

	DataManagement.updateAnimal(owner, slot, {
		LastCollect = currentTime,
		OfflineGain = nil
	})

	self.plot:SetAnimalList(animalList)

	task.wait(0.1)

	local Synchronizer = require(ReplicatedStorage.Packages.Synchronizer)
	local playerSync = Synchronizer:Get(owner)
	if playerSync then
		local updatedData = DataManagement.GetDataMan(owner)
		if updatedData then
			playerSync:Set("Coins", updatedData.Coins)
		end
	end

	return true, totalCoins
end

function AnimalManager:SellAnimal(slot)
	local owner = self.plot:GetOwner()
	local animalList = self.plot:GetAnimalList()
	local animal = animalList[slot]

	if not animal or typeof(animal) ~= "table" or not animal.Index then
		return false, 0
	end

	local sellValue = Animals:GetSellValue(animal.Index)

	DataManagement.addCoins(owner, sellValue)

	DataManagement.removeAnimal(owner, slot)

	local updatedAnimalList = DataManagement.getAnimalList(owner)
	self.plot:SetAnimalList(updatedAnimalList)

	task.wait(0.1)
	local Synchronizer = require(ReplicatedStorage.Packages.Synchronizer)
	local playerSync = Synchronizer:Get(owner)
	if playerSync then
		local updatedData = DataManagement.GetDataMan(owner)
		if updatedData then
			playerSync:Set("Coins", updatedData.Coins)
		end
	end

	return true, sellValue
end

function AnimalManager:AddAnimal(animalIndex, mutation, traits)
	local owner = self.plot:GetOwner()

	local addedSlot = DataManagement.addAnimal(owner, animalIndex, mutation, traits)

	if not addedSlot then
		return false, nil
	end

	local updatedAnimalList = DataManagement.getAnimalList(owner)
	self.plot:SetAnimalList(updatedAnimalList)

	local Synchronizer = require(ReplicatedStorage.Packages.Synchronizer)
	local playerSync = Synchronizer:Get(owner)
	if playerSync then
		playerSync:Set("AnimalAddedOrRemoved", updatedAnimalList)
		playerSync:Set("AnimalPodiums", updatedAnimalList)
	end

	return true, addedSlot
end

function AnimalManager:RemoveAnimal(slot)
	local owner = self.plot:GetOwner()

	local removedAnimal = DataManagement.removeAnimal(owner, slot)

	if not removedAnimal then
		return false, nil
	end

	local updatedAnimalList = DataManagement.getAnimalList(owner)
	self.plot:SetAnimalList(updatedAnimalList)

	local Synchronizer = require(ReplicatedStorage.Packages.Synchronizer)
	local playerSync = Synchronizer:Get(owner)
	if playerSync then
		playerSync:Set("AnimalAddedOrRemoved", updatedAnimalList)
		playerSync:Set("AnimalPodiums", updatedAnimalList)
	end

	return true, removedAnimal
end

function AnimalManager:FindEmptySlot()
	local owner = self.plot:GetOwner()

	if not DataManagement.isDataReady(owner) then
		return nil
	end

	local animalList = DataManagement.getAnimalList(owner)
	if not animalList then
		return nil
	end

	for slot, animal in pairs(animalList) do
		if animal == PlotConstants.STATES.EMPTY or animal == nil then
			return slot
		end
	end

	return nil
end

function AnimalManager:GetNonEmptySlots()
	local owner = self.plot:GetOwner()

	if not DataManagement.isDataReady(owner) then
		return {}
	end

	local animalList = DataManagement.getAnimalList(owner)
	if not animalList then
		return {}
	end

	local nonEmptySlots = {}
	for slot, animal in pairs(animalList) do
		if animal and animal ~= PlotConstants.STATES.EMPTY and typeof(animal) == "table" and animal.Index then
			table.insert(nonEmptySlots, slot)
		end
	end

	return nonEmptySlots
end

function AnimalManager:HasValidAnimal(slot)
	local animalList = self.plot:GetAnimalList()
	local animal = animalList[slot]

	return animal and typeof(animal) == "table" and animal.Index ~= nil
end

function AnimalManager:SetStealState(slot, isBeingStolen)
	local animalList = self.plot:GetAnimalList()

	if animalList[slot] and typeof(animalList[slot]) == "table" then

		animalList[slot].Steal = isBeingStolen

		local sync = self.plot:GetSynchronizer()
		if sync then
			sync:Set(("AnimalList.%d.Steal"):format(slot), isBeingStolen)
		end
	end
end

function AnimalManager:GetAnimal(slot)
	local animalList = self.plot:GetAnimalList()
	return animalList[slot]
end

function AnimalManager:_updateAnimalListEverywhere(animalList)
	local owner = self.plot:GetOwner()

	self.plot:SetAnimalList(animalList)

	local playerData = DataManagement.GetDataMan(owner)
	if playerData then
		playerData.AnimalList = animalList
	end

	local Synchronizer = require(ReplicatedStorage.Packages.Synchronizer)
	local playerSync = Synchronizer:Get(owner)
	if playerSync then
		playerSync:Set("AnimalAddedOrRemoved", animalList)
		playerSync:Set("AnimalPodiums", animalList)
	end
end

return AnimalManager 