--[[
  Extracted from: ServerScriptService.Services.Plots.Plot.PlotRainbow
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local PlotRainbow = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local CollectionService = game:GetService("CollectionService")

local DataManagement = require(ServerScriptService.Services.DataManagment)

local Animals = require(ReplicatedStorage.Datas.Animals)

function PlotRainbow.apply(plot)
	if not plot or not plot.plotModel then return end

	if not DataManagement.isDataReady(plot.owner) then
		DataManagement.waitForData(plot.owner, 15)
	end

	local data = DataManagement.GetDataMan(plot.owner)
	if not data or not data.Index then return end

	local function hasFullSet(mutation)
		for id, animalData in pairs(Animals) do
			if not animalData.HideFromIndex then
				if not (data.Index[id] and data.Index[id][mutation]) then
					return false
				end
			end
		end
		return true
	end

	for animalId, _ in pairs(Animals) do
		local key = animalId
		if data.Index[key] == nil then
			key = tostring(animalId)
		end
		if not (data.Index[key] and data.Index[key]["Rainbow"]) then
			return
		end
	end

	local ignoreModels = {}

	local decorationsFolder = plot.plotModel:FindFirstChild("Decorations")
	if decorationsFolder then
		for _, part in ipairs(decorationsFolder:GetDescendants()) do
			if part:IsA("BasePart") and part.Color == Color3.fromRGB(112, 68, 43) then
				ignoreModels[part.Parent] = true
			end
		end
		for _, child in ipairs(decorationsFolder:GetChildren()) do
			if child:IsA("Model") and child:FindFirstChildWhichIsA("PointLight", true) then
				ignoreModels[child] = true
			end
		end
	end

	for _, directChild in ipairs(plot.plotModel:GetChildren()) do
		if directChild:IsA("Model") then
			ignoreModels[directChild] = true
		end
	end

	local IGNORE_FOLDERS = {
		AnimalPodiums = true,
		Laser = true,
		LaserHitbox = true,
		Purchases = true,
		Unlock = true,
	}

	local IGNORE_PARTS = {
		AnimalTarget = true,
		DeliveryHitbox = true,
		Multiplier = true,
		PlotSign = true,
		Spawn = true,
		StealHitbox = true,
		Root = true,
	}

	local function hasIgnoredAncestor(inst)
		local current = inst.Parent
		while current and current ~= plot.plotModel do
			if IGNORE_FOLDERS[current.Name] or ignoreModels[current] or current.Name == "FriendPanel" then
				return true
			end
			current = current.Parent
		end
		return false
	end

	for _, descendant in ipairs(plot.plotModel:GetDescendants()) do
		if descendant:IsA("BasePart") then
			if hasIgnoredAncestor(descendant) then continue end
			if IGNORE_PARTS[descendant.Name] then continue end

			local s = descendant.Size
			local dims = {math.round(s.X), math.round(s.Y), math.round(s.Z)}
			table.sort(dims)
			if dims[1] == 2 and dims[2] == 53 and dims[3] == 53 then
				continue
			end

			if descendant.Color == Color3.fromRGB(99, 95, 98) then
				if descendant.Name == "Part" then
					continue
				end
			end

			CollectionService:AddTag(descendant, "RainbowModel")
		end
	end
end

return PlotRainbow