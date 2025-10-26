--[[
  Extracted from: ServerScriptService.Services.Plots.Plot.PlotGold
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local PlotGold = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local DataManagement = require(ServerScriptService.Services.DataManagment)

local Color27 = Color3.fromRGB(27, 42, 53)
local Color91 = Color3.fromRGB(91, 93, 105)
local Color69 = Color3.fromRGB(69, 71, 80)
local Color99 = Color3.fromRGB(99, 95, 98)

local TargetBright = Color3.fromRGB(237, 178, 0)
local TargetDark   = Color3.fromRGB(215, 111, 1)

local function buildIgnoreChecker(plot)
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

	return IGNORE_PARTS, hasIgnoredAncestor
end

function PlotGold.apply(plot)
	if not plot or not plot.plotModel then return end

	if not DataManagement.isDataReady(plot.owner) then
		DataManagement.waitForData(plot.owner, 15)
	end

	local data = DataManagement.GetDataMan(plot.owner)
	if not data or not data.Index then return end

	local Animals = require(ReplicatedStorage.Datas.Animals)
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

	if hasFullSet("Rainbow") or hasFullSet("Diamond") then return end
	if not hasFullSet("Gold") then return end

	local IGNORE_PARTS, hasIgnoredAncestor = buildIgnoreChecker(plot)

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

			local col = descendant.Color
			if col == Color27 then
				descendant.Color = TargetBright
			elseif col == Color91 or col == Color69 then
				descendant.Color = TargetDark
			elseif col == Color99 and descendant.Name == "structure base home" then
				descendant.Color = TargetDark
			end
		end
	end
end

return PlotGold