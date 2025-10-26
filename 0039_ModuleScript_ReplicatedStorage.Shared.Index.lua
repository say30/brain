--[[
  Extracted from: ReplicatedStorage.Shared.Index
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage:WaitForChild("Packages")
local Synchronizer = require(Packages.Synchronizer)
local Datas = ReplicatedStorage:WaitForChild("Datas")
local Mutations = require(Datas.Mutations)
local Animals = require(Datas.Animals)

local IndexModule = {}

function IndexModule:CanShowInIndex(AnimalName)
	local Animal = Animals[AnimalName]
	if Animal then
		if Animal.IsEnabled and not Animal.IsEnabled() then
			return false
		end
		return not Animal.HideFromIndex
	end
	return false
end

function IndexModule:IsComplete(Player, MutationName)
	local Data = Synchronizer:Get(Player)
	if not Data then
		return false
	end

	local IndexData = Data:Get("Index")
	local Completed = 0
	local Total = 0

	for Name, Animal in pairs(Animals) do
		if self:CanShowInIndex(Name) then
			if not Animal.IgnoreIndexCounter then
				Total += 1
			end

			local AnimalIndex = IndexData[Name]
			if AnimalIndex and AnimalIndex[MutationName or "Default"] then
				Completed += 1
			end
		end
	end

	return Completed >= Total
end

function IndexModule:GetIndexAnimals(Player, MutationName)
	local Data = Synchronizer:Get(Player)
	if not Data then
		return nil
	end

	local IndexData = Data:Get("Index")
	local Completed = 0
	local Total = 0

	for Name, Animal in pairs(Animals) do
		if self:CanShowInIndex(Name) then
			if not Animal.IgnoreIndexCounter then
				Total += 1
			end

			local AnimalIndex = IndexData[Name]
			if AnimalIndex and AnimalIndex[MutationName or "Default"] then
				Completed += 1
			end
		end
	end

	return Completed, Total
end

function IndexModule:GetMultipliers(Player)
	local Multiplier = 0
	local Data = Synchronizer:Get(Player)
	if not Data then
		return Multiplier
	end

	local Count = 0
	if self:IsComplete(Player) then
		Count += 1
	end

	for MutationName, Mutation in pairs(Mutations) do
		if not Mutation.LimitedMutation then
			if self:IsComplete(Player, MutationName) then
				Count += 1
			end
		end
	end

	Multiplier += Count * 0.5
	return Multiplier
end

return IndexModule