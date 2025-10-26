--[[
  Extracted from: ServerScriptService.Services.Plots.Plot
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")

local PlotConstants = require(script.Parent.PlotConstants)
local Synchronizer = require(ReplicatedStorage.Packages.Synchronizer)
local PlotRainbow = require(script.PlotRainbow)
local PlotDiamond = require(script.PlotDiamond)
local PlotGold = require(script.PlotGold)
local PlotCandy = require(script.PlotCandy)

local Plot = {}
Plot.__index = Plot

function Plot.new(owner, tier, initialData)
	local self = setmetatable({}, Plot)

	self.uuid = HttpService:GenerateGUID(false)

	self.owner = owner
	self.tier = tier
	self.plotModel = nil
	self.synchronizer = nil

	self.isActive = true
	self.isLocked = false

	self:_initializeSynchronizer(initialData or {})

	self:_createPlotModel()

	self:_initializePlotState()

	return self
end

function Plot:_initializeSynchronizer(initialData)
	self.synchronizer = Synchronizer:Create(self.uuid, {
		Owner = self.owner,
		AnimalList = initialData.AnimalList or {},
		FriendsAllowed = false,
		BlockedDelayTime = nil,
		BlockEndTime = nil,
		BlockEndTimeFirstFloor = nil,
		BlockEndTimeSecondFloor = nil,
		BlockEndTimeThirdFloor = nil,
	})

	for _, player in pairs(Players:GetPlayers()) do
		self.synchronizer:AddListener(player)
	end
end

function Plot:_createPlotModel()
	local BasesData = require(ReplicatedStorage.Datas.Bases)
	local tierData = BasesData[self.tier]

	local baseModel = tierData.Model

	local availableSlot = self:_findAvailablePlotSlot()

	local plotModel = baseModel:Clone()
	local pivotCFrame = availableSlot:GetPivot()
	local newPivotCFrame = CFrame.new(
		Vector3.new(pivotCFrame.X, -10, pivotCFrame.Z)
	) * CFrame.Angles(pivotCFrame:ToEulerAnglesXYZ())

	plotModel:PivotTo(newPivotCFrame)
	plotModel.PlotSign.YourBase.Enabled = false
	plotModel.Parent = workspace.Plots
	plotModel.Name = self.uuid
	plotModel:SetAttribute("Tier", self.tier)
	plotModel:SetAttribute("Owner", self.owner.UserId)

	CollectionService:AddTag(plotModel, "Plot")

	self.plotModel = plotModel

	self:_updatePlotVisuals(plotModel)

	self:_ensureBaseRewardsApplied()
	self:ApplyAppropriateSkin()

	self:_ensureSpawnPoint(plotModel)

	local animalPodiumsFolder = plotModel:FindFirstChild("AnimalPodiums")
	if animalPodiumsFolder then
		local BasesData = require(ReplicatedStorage.Datas.Bases)
		self:_optimizeAnimalPodiums(BasesData[self.tier].MaxAnimals)
	end

	availableSlot:Destroy()

	self:_ensurePurchaseGuiElements(plotModel)
end

function Plot:_ensureBaseRewardsApplied()
	local DataManagement = require(game.ServerScriptService.Services.DataManagment)
	local Animals = require(ReplicatedStorage.Datas.Animals)

	if not DataManagement.isDataReady(self.owner) then
		local success = DataManagement.waitForData(self.owner, 15)
	end

	local data = DataManagement.GetDataMan(self.owner)

	local function hasFullSet(mutation)
		local animalCount = 0
		local ownedCount = 0

		for id, animalData in pairs(Animals) do
			if not animalData.HideFromIndex then
				animalCount = animalCount + 1
				if data.Index[id] and data.Index[id][mutation] then
					ownedCount = ownedCount + 1
				end
			end
		end

		return ownedCount == animalCount
	end

	local mutations = {"Candy", "Rainbow", "Diamond", "Gold", "Default"}
	local appliedReward = false

	for _, mutation in pairs(mutations) do
		if hasFullSet(mutation) then
			if self.RefreshMultiplier then
				self:RefreshMultiplier()
			end

			if mutation == "Candy" and self.ApplyCandySkin then
				self:ApplyCandySkin()
				appliedReward = true
				break
			elseif mutation == "Rainbow" and self.ApplyRainbowSkin then
				self:ApplyRainbowSkin()
				appliedReward = true
				break
			elseif mutation == "Diamond" and self.ApplyDiamondSkin then
				self:ApplyDiamondSkin()
				appliedReward = true
				break
			elseif mutation == "Gold" and self.ApplyGoldSkin then
				self:ApplyGoldSkin()
				appliedReward = true
				break
			end
		end
	end
end

function Plot:_findAvailablePlotSlot()
	local plotsFolder = workspace:FindFirstChild("Plots")
	if not plotsFolder then
		return nil
	end

	local function tryClaim(candidate)
		if candidate and not candidate:GetAttribute("Owner") then
			candidate:SetAttribute("Owner", self.owner.UserId)
			if candidate:GetAttribute("Owner") == self.owner.UserId then
				return true
			else
				return false
			end
		end
		return false
	end

	for _, plot in pairs(plotsFolder:GetChildren()) do
		if CollectionService:HasTag(plot, "Plot") and tryClaim(plot) then
			return plot
		end
	end

	for _, plot in pairs(plotsFolder:GetChildren()) do
		if tryClaim(plot) then
			return plot
		end
	end

	return nil
end

function Plot:_updatePlotVisuals(plotModel)
	local plotSign = plotModel:FindFirstChild("PlotSign")
	if plotSign and plotSign.SurfaceGui then
		plotSign.SurfaceGui.Frame.TextLabel.Text = self.owner.Name .. "'s Base"
	end

	local multiplierDisplay = plotModel:FindFirstChild("Multiplier")
	if multiplierDisplay then
		local multiplier = self:_calculateMultiplier()
		multiplierDisplay.Main.Amount.Text = "x" .. multiplier
	end
end

function Plot:_calculateMultiplier()
	local DataManagement = require(game.ServerScriptService.Services.DataManagment)
	local Rebirths = require(ReplicatedStorage.Datas.Rebirth)
	local Mutations = require(ReplicatedStorage.Datas.Mutations)
	local playerData = DataManagement.GetDataMan(self.owner)
	if not playerData then return 1 end

	local totalMultiplier = 1
	local rebirthData = Rebirths[playerData.Rebirths]
	if rebirthData and rebirthData.Rewards and rebirthData.Rewards.Multiplier then
		totalMultiplier = totalMultiplier + rebirthData.Rewards.Multiplier
	end

	local index = playerData.Index or {}
	local mutationKeys = { Default = true, Gold = true, Diamond = true, Rainbow = true, Candy = true }

	local Animals = require(ReplicatedStorage.Datas.Animals)
	local completedSets = 0
	for mutation in pairs(mutationKeys) do
		local allOwned = true
		for animalName, animalData in pairs(Animals) do
			if not animalData.HideFromIndex then
				local entry = index[animalName]
				if not (entry and entry[mutation]) then
					allOwned = false
					break
				end
			end
		end
		if allOwned then
			completedSets += 1
		end
	end
	if completedSets > 0 then
		totalMultiplier = totalMultiplier + 0.5 * completedSets
	end

	return totalMultiplier
end

function Plot:_initializePlotState()
	local currentTime = workspace:GetServerTimeNow()
	self.synchronizer:Set("BlockedDelayTime", currentTime + PlotConstants.TIMING.DELAY_TIME)

	task.delay(PlotConstants.TIMING.DELAY_TIME, function()
		if not self.isActive then return end

		self:_startLockTimer()
	end)
end

function Plot:_startLockTimer()
	local currentTime = workspace:GetServerTimeNow()
	local lockDuration = self:_calculateLockDuration()

	self.synchronizer:Set("BlockedDelayTime", nil)

	local lockEndTime = currentTime + lockDuration
	self.synchronizer:Set("BlockEndTime", lockEndTime)
	self.synchronizer:Set("BlockEndTimeFirstFloor", lockEndTime)
	self.synchronizer:Set("BlockEndTimeSecondFloor", lockEndTime)
	self.synchronizer:Set("BlockEndTimeThirdFloor", lockEndTime)

	self.isLocked = true
	self:_updateLaserAndHitboxStates(true)

	task.delay(lockDuration, function()
		if not self.isActive then return end

		self:_unlockBase()
	end)
end

function Plot:_calculateLockDuration()
	local DataManagement = require(game.ServerScriptService.Services.DataManagment)
	local Rebirths = require(ReplicatedStorage.Datas.Rebirth)

	local playerData = DataManagement.GetDataMan(self.owner)
	if not playerData then 
		return PlotConstants.TIMING.DEFAULT_LOCK_TIME
	end

	local additionalTime = 0
	if playerData.Rebirths > 0 then
		local rebirthData = Rebirths[playerData.Rebirths]
		if rebirthData and rebirthData.Rewards and rebirthData.Rewards.AdditionalLockTime then
			additionalTime = rebirthData.Rewards.AdditionalLockTime
		end
	end

	return PlotConstants.TIMING.DEFAULT_LOCK_TIME + additionalTime
end

function Plot:_unlockBase()
	local lockEndTime = self.synchronizer:Get("BlockEndTime")
	if lockEndTime == nil then
		return
	end

	local now = workspace:GetServerTimeNow()
	local remaining = lockEndTime - now
	if remaining > 0 then
		task.delay(remaining, function()
			self:_unlockBase()
		end)
		return
	end

	self.synchronizer:Set("BlockEndTime", nil)
	self.synchronizer:Set("BlockEndTimeFirstFloor", nil)
	self.synchronizer:Set("BlockEndTimeSecondFloor", nil)
	self.synchronizer:Set("BlockEndTimeThirdFloor", nil)

	self.isLocked = false
	self:_updateLaserAndHitboxStates(false)
end

function Plot:_updateLaserAndHitboxStates(isLocked)
	if not self.plotModel then return end

	local MonetizationService = _G.MonetizationService
	if MonetizationService and MonetizationService.GetBaseLockHandler then
		local handler = MonetizationService:GetBaseLockHandler()
		if handler then
			handler:UpdateAllFloorStates(self.owner)
			return
		end
	end

	local laser = self.plotModel:FindFirstChild("Laser")
	local laserHitbox = self.plotModel:FindFirstChild("LaserHitbox")

	if not laser or not laserHitbox then return end

	for _, hitbox in pairs(laserHitbox:GetChildren()) do
		local floor = hitbox:GetAttribute("Floor")
		if floor and floor >= 1 and floor <= 3 then
			local floorKey = PlotConstants.FLOOR_KEYS[floor]
			local floorLocked = self.synchronizer:Get(floorKey) ~= nil
			hitbox.CanCollide = floorLocked

			if not floorLocked then
				hitbox:SetAttribute("ServerControlled", true)
			else
				hitbox:SetAttribute("ServerControlled", nil)
			end
		else
			hitbox.CanCollide = isLocked
			if isLocked then
				hitbox:SetAttribute("ServerControlled", nil)
			end
		end
	end

	for _, laserModel in pairs(laser:GetChildren()) do
		if laserModel:IsA("Model") then
			local floor = laserModel:GetAttribute("Floor")
			if floor and floor >= 1 and floor <= 3 then
				local floorKey = PlotConstants.FLOOR_KEYS[floor]
				local floorLocked = self.synchronizer:Get(floorKey) ~= nil
				for _, laserPart in pairs(laserModel:GetDescendants()) do
					if laserPart:IsA("BasePart") then
						laserPart.Transparency = floorLocked and 0 or 1
					end
				end
			else
				for _, laserPart in pairs(laserModel:GetDescendants()) do
					if laserPart:IsA("BasePart") then
						laserPart.Transparency = isLocked and 0 or 1
					end
				end
			end
		elseif laserModel:IsA("BasePart") then
			laserModel.Transparency = isLocked and 0 or 1
		end
	end
end

function Plot:GetUUID()
	return self.uuid
end

function Plot:GetOwner()
	return self.owner
end

function Plot:GetSynchronizer()
	return self.synchronizer
end

function Plot:GetPlotModel()
	return self.plotModel
end

function Plot:IsActive()
	return self.isActive
end

function Plot:IsLocked()
	return self.isLocked
end

function Plot:GetAnimalList()
	return self.synchronizer:Get("AnimalList") or {}
end

function Plot:SetAnimalList(animalList)
	self.synchronizer:Set("AnimalList", animalList)
	self.synchronizer:Set("AnimalPodiums", animalList)
end

function Plot:GetFriendsAllowed()
	return self.synchronizer:Get("FriendsAllowed") or false
end

function Plot:SetFriendsAllowed(allowed)
	self.synchronizer:Set("FriendsAllowed", allowed)
end

function Plot:AddListener(player)
	if self.synchronizer then
		self.synchronizer:AddListener(player)
	end
end

function Plot:RemoveListener(player)
	if self.synchronizer then
		self.synchronizer:RemoveListener(player)
	end
end

function Plot:TeleportOwnerToSpawn()
	if not self.owner then
		return false
	end

	if not self.owner.Character then
		return false
	end

	local humanoidRootPart = self.owner.Character:FindFirstChild("HumanoidRootPart")
	if not humanoidRootPart then
		return false
	end

	if not self.plotModel then
		return false
	end

	local spawn = self.plotModel:FindFirstChild("Spawn")
	if not spawn then
		spawn = self:_ensureSpawnPoint(self.plotModel)
	end

	if not spawn or not spawn.CFrame then
		return false
	end

	local success, err = pcall(function()
		humanoidRootPart.CFrame = spawn.CFrame
	end)
end

function Plot:UpdateForRebirth(newTier)
	if not self.plotModel then return end
	
	local Bases = require(ReplicatedStorage.Datas.Bases)
	local currentTierData = Bases[self.tier]
	local newTierData = Bases[newTier]

	local needsModelChange = not currentTierData or currentTierData.Model ~= newTierData.Model

	if needsModelChange then
		self:_recreateFullPlotModel(newTier)
	else
		self:_optimizeAnimalPodiums(newTierData.MaxAnimals)
		self.tier = newTier
		self.plotModel:SetAttribute("Tier", newTier)
	end

	self:_setupRebirthCharacterHandler()
end

function Plot:_recreateFullPlotModel(newTier)
	local currentPivot = self.plotModel:GetPivot()
	local oldSpawnCFrame
	local oldSpawnPart = self.plotModel:FindFirstChild("Spawn")
	if oldSpawnPart then
		oldSpawnCFrame = oldSpawnPart.CFrame
	else
		oldSpawnCFrame = currentPivot
	end

	self.plotModel:Destroy()

	local BasesData = require(ReplicatedStorage.Datas.Bases)
	local newTierData = BasesData[newTier]

	local baseModel = newTierData.Model

	local newPlotModel = baseModel:Clone()

	local targetPivotCFrame
	local newSpawnPart = newPlotModel:FindFirstChild("Spawn")
	if newSpawnPart and oldSpawnCFrame then
		local relative = newPlotModel:GetPivot():ToObjectSpace(newSpawnPart.CFrame)
		targetPivotCFrame = oldSpawnCFrame * relative:Inverse()
	else
		targetPivotCFrame = currentPivot
	end

	newPlotModel:PivotTo(targetPivotCFrame)
	self:_ensureSpawnPoint(newPlotModel)

	newPlotModel.PlotSign.YourBase.Enabled = false
	newPlotModel.Parent = workspace.Plots
	newPlotModel.Name = self.uuid
	newPlotModel:SetAttribute("Tier", newTier)
	newPlotModel:SetAttribute("Owner", self.owner.UserId)

	local animalPodiums = newPlotModel:FindFirstChild("AnimalPodiums")
	if not animalPodiums then
		animalPodiums = Instance.new("Folder")
		animalPodiums.Name = "AnimalPodiums"
		animalPodiums.Parent = newPlotModel
	end

	self.tier = newTier
	self:_tagPlotModelDelayed(newPlotModel)
	self.plotModel = newPlotModel
	self:_updatePlotVisuals(newPlotModel)
	self:ApplyAppropriateSkin()
	self:_updateLaserAndHitboxStates(false)
	self:_initializePlotState()

	local BasesData = require(ReplicatedStorage.Datas.Bases)
	self:_optimizeAnimalPodiums(BasesData[newTier].MaxAnimals)
end

function Plot:_optimizeAnimalPodiums(maxAnimals)
	local animalPodiums = self.plotModel:FindFirstChild("AnimalPodiums")
	
	local allPodiums = {}
	for _, child in pairs(animalPodiums:GetChildren()) do
		local podiumNumber = tonumber(child.Name)
		if podiumNumber then
			allPodiums[podiumNumber] = child
		end
	end

	local sortedPodiumNumbers = {}
	for podiumNumber, _ in pairs(allPodiums) do
		table.insert(sortedPodiumNumbers, podiumNumber)
	end
	table.sort(sortedPodiumNumbers)

	for _, podiumNumber in ipairs(sortedPodiumNumbers) do
		local podium = allPodiums[podiumNumber]
		if podiumNumber <= maxAnimals then
			if podium:IsA("BasePart") then
				podium.Transparency = 0
				podium.CanCollide = true
				podium.CanTouch = true
			end

			for _, child in pairs(podium:GetDescendants()) do
				if child:IsA("BasePart") then
					if child.Name == "Spawn" and child.Parent and child.Parent.Name == "Base" then
						child.Transparency = 1
						child.CanCollide = false
						child.CanQuery = false
						child.CanTouch = false
					elseif child.Name == "Hitbox" and child.Parent and child.Parent.Name == "Claim" then
						child.Transparency = 1
						child.CanCollide = false
						child.CanQuery = true
						child.CanTouch = true
					else
						child.Transparency = 0
						child.CanCollide = true
					end
				elseif child:IsA("SurfaceGui") or child:IsA("BillboardGui") then
					child.Enabled = true
				elseif child:IsA("ProximityPrompt") then
					child.Enabled = true
				end
			end
		else
			if podium:IsA("BasePart") then
				podium.Transparency = 1
				podium.CanCollide = false
				podium.CanTouch = false
			end

			for _, child in pairs(podium:GetDescendants()) do
				if child:IsA("BasePart") then
					child.Transparency = 1
					child.CanCollide = false
				elseif child:IsA("SurfaceGui") or child:IsA("BillboardGui") then
					child.Enabled = false
				elseif child:IsA("ProximityPrompt") then
					child.Enabled = false
				end
			end
		end
	end
end

function Plot:_setupRebirthCharacterHandler()
	local player = self.owner

	if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		task.wait(0.1)
		self:TeleportOwnerToSpawn()
		return
	end

	local connection
	connection = player.CharacterAdded:Connect(function(character)
		connection:Disconnect()

		local humanoidRootPart = character:WaitForChild("HumanoidRootPart", 5)
		if humanoidRootPart and self.plotModel then
			task.wait(PlotConstants.VISUAL.SPAWN_WAIT_TIME)

			if self.plotModel and self.plotModel:FindFirstChild("Spawn") then
				humanoidRootPart.CFrame = self.plotModel.Spawn.CFrame
			end
		end
	end)

	task.delay(30, function()
		if connection then
			connection:Disconnect()
		end
	end)
end

function Plot:Destroy()
	self.isActive = false

	if self.synchronizer then
		for _, player in pairs(Players:GetPlayers()) do
			self.synchronizer:RemoveListener(player)
		end

		self.synchronizer:Destroy()
	end

	if self.plotModel then
		local oldModel = self.plotModel
		local currentPivot = oldModel:GetPivot()
		local oldSpawnCFrame
		local oldSpawnPart = oldModel:FindFirstChild("Spawn")
		if oldSpawnPart then
			oldSpawnCFrame = oldSpawnPart.CFrame
		end

		oldModel:Destroy()

		local firstFloor = ReplicatedStorage.Bases.FirstFloor
		if firstFloor then
			local replacementPlot = firstFloor:Clone()

			local targetPivot = currentPivot
			local newSpawn = replacementPlot:FindFirstChild("Spawn")
			if oldSpawnCFrame and newSpawn then
				local relative = replacementPlot:GetPivot():ToObjectSpace(newSpawn.CFrame)
				targetPivot = oldSpawnCFrame * relative:Inverse()
			end

			replacementPlot:PivotTo(targetPivot)
			replacementPlot.PlotSign.YourBase.Enabled = false
			replacementPlot.PlotSign.SurfaceGui.Frame.TextLabel.Text = "None"
			replacementPlot:SetAttribute("Owner", nil)
			replacementPlot.Parent = workspace.Plots

			local animalPodiums = replacementPlot:FindFirstChild("AnimalPodiums")
			if animalPodiums then
				for _, podium in animalPodiums:GetDescendants() do
					if podium:IsA("BillboardGui") then
						podium.Enabled = false
					end
				end
			end

			local laser = replacementPlot:FindFirstChild("Laser")

			if laser then
				for _, obj in pairs(laser:GetDescendants()) do
					if obj:IsA("BasePart") then
						obj.Transparency = 1
					end
				end
			end

			local laserHitbox = replacementPlot:FindFirstChild("LaserHitbox")

			if laserHitbox then
				for _, hb in pairs(laserHitbox:GetDescendants()) do
					if hb:IsA("BasePart") then
						hb.CanCollide = false
					end
				end
			end

			self:_tagPlotModelDelayed(replacementPlot)
		end
	end
end

function Plot:_ensureSpawnPoint(model)
	if not model then return nil end
	local spawnPart = model:FindFirstChild("Spawn")
	if spawnPart and spawnPart:IsA("BasePart") then
		return spawnPart
	end

	spawnPart = Instance.new("Part")
	spawnPart.Name = "Spawn"
	spawnPart.Size = Vector3.new(4, 1, 4)
	spawnPart.Transparency = 1
	spawnPart.Anchored = true
	spawnPart.CanCollide = false

	local pivot = model:GetPivot()
	spawnPart.CFrame = pivot * CFrame.new(0, 3, 0)
	spawnPart.Parent = model

	return spawnPart
end

function Plot:ApplyRainbowSkin()
	PlotRainbow.apply(self)
end

function Plot:ApplyDiamondSkin()
	PlotDiamond.apply(self)
end

function Plot:ApplyGoldSkin()
	PlotGold.apply(self)
end

function Plot:ApplyCandySkin()
	PlotCandy.apply(self)
end

function Plot:ApplyAppropriateSkin()
	local DataManagement = require(game.ServerScriptService.Services.DataManagment)
	local Animals = require(ReplicatedStorage.Datas.Animals)

	local data = DataManagement.GetDataMan(self.owner)
	if not data or not data.Index then return end

	local function hasFullSet(mutation)
		for id, _ in pairs(Animals) do
			if not (data.Index[id] and data.Index[id][mutation]) then
				return false
			end
		end
		return true
	end

	if hasFullSet("Candy") then
		PlotCandy.apply(self)
	elseif hasFullSet("Rainbow") then
		PlotRainbow.apply(self)
	elseif hasFullSet("Diamond") then
		PlotDiamond.apply(self)
	elseif hasFullSet("Gold") then
		PlotGold.apply(self)
	end
end

function Plot:_tagPlotModelDelayed(model)
	if not model then return end
	task.defer(function()
		if model.Parent then
			CollectionService:AddTag(model, "Plot")
		end
	end)
end

function Plot:RefreshMultiplier()
	if not self.plotModel then return end
	local multiplierDisplay = self.plotModel:FindFirstChild("Multiplier")
	if multiplierDisplay then
		local multiplier = self:_calculateMultiplier()
		multiplierDisplay.Main.Amount.Text = "x" .. multiplier
	end
end

function Plot:_ensurePurchaseGuiElements(plotModel)
	local purchasesFolder = plotModel:FindFirstChild("Purchases")
	if not purchasesFolder then return end

	local templateBase
	local tier = plotModel:GetAttribute("Tier")
	local BasesData = require(ReplicatedStorage.Datas.Bases)
	local tierData = BasesData[tier] or BasesData[0]
	if tierData and tierData.Model then
		templateBase = tierData.Model
	end

	for _, purchase in ipairs(purchasesFolder:GetChildren()) do
		local main = purchase:FindFirstChild("Main")
		if not main then continue end

		local bGui = main:FindFirstChild("BillboardGui")
		if not (bGui and bGui:IsA("BillboardGui")) then
			if templateBase then
				local templatePurchase = templateBase:FindFirstChild("Purchases") and templateBase.Purchases:FindFirstChild(purchase.Name)
				local templateGui = templatePurchase and templatePurchase.Main:FindFirstChild("BillboardGui")
				if templateGui then
					bGui = templateGui:Clone()
					bGui.Parent = main
				end
			end
			if not bGui then
				bGui = Instance.new("BillboardGui")
				bGui.Name = "BillboardGui"
				bGui.Size = UDim2.new(0, 100, 0, 50)
				bGui.AlwaysOnTop = true
				bGui.Parent = main
			end
		end

		local function ensureLabel(childName)
			if bGui:FindFirstChild(childName) then return end

			local src
			if templateBase then
				local templatePurchase = templateBase:FindFirstChild("Purchases") and templateBase.Purchases:FindFirstChild(purchase.Name)
				local templateGui = templatePurchase and templatePurchase.Main:FindFirstChild("BillboardGui")
				if templateGui then
					src = templateGui:FindFirstChild(childName)
				end
			end

			if src then
				src:Clone().Parent = bGui
			else
				local lbl = Instance.new("TextLabel")
				lbl.Name = childName
				lbl.Size = UDim2.new(1, 0, 1, 0)
				lbl.BackgroundTransparency = 1
				lbl.Text = ""
				lbl.Visible = false
				lbl.Parent = bGui
			end
		end

		ensureLabel("RemainingTime")
		ensureLabel("Locked")
		ensureLabel("Delay")
		ensureLabel("LockStudio")
	end
end

return Plot