--[[
  Extracted from: ReplicatedStorage.Shared.Animals
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Animal System Module
-- Handles animal models, mutations, traits, pricing, and viewport display

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- Module Dependencies
local Packages = ReplicatedStorage:WaitForChild("Packages")
local Trove = require(Packages.Trove)

local Data = ReplicatedStorage:WaitForChild("Datas")
local AnimalsData = require(Data.Animals)
local GameData = require(Data.Game)
local RebirthData = require(Data.Rebirth)
local RaritiesData = require(Data.Rarities)
local MutationsData = require(Data.Mutations)
local MutationsTextures = require(Data.MutationsTextures)
local TraitsData = require(Data.Traits)

-- Asset References
local AnimalAnimations = ReplicatedStorage:WaitForChild("Animations").Animals
local MutationSurfaces = ReplicatedStorage:WaitForChild("MutationSurfaces")
local Models = ReplicatedStorage:WaitForChild("Models")
local AnimalModels = Models.Animals
local TraitModels = Models.Traits
local TraitVFX = ReplicatedStorage:WaitForChild("Vfx").Traits
local VFXFolder = ReplicatedStorage:WaitForChild("Vfx")

-- Module
local AnimalSystem = {}

-- Constants
local CAMERA_OFFSET_DIRECTION = Vector3.new(-1, 0.25, -1).Unit

-- Private Functions

--- Positions a camera to view a model optimally
--- @param camera Camera - The camera to position
--- @param model Model - The model to view
--- @param fieldOfView number - Camera field of view
--- @param distanceMultiplier number - Distance multiplier (default 0.8)
--- @param offsetMultiplier number - Offset multiplier (default 0.5)
local function positionCameraForModel(camera, model, fieldOfView, distanceMultiplier, offsetMultiplier)
	local _, modelSize = model:GetBoundingBox()
	local modelCFrame = model.PrimaryPart and model.PrimaryPart.CFrame or model:GetPivot()

	local sizeX, sizeY, sizeZ = modelSize.X, modelSize.Y, modelSize.Z
	local maxSize = math.max(sizeX, sizeY, sizeZ)
	local halfSize = maxSize * 0.5
	local halfFOV = fieldOfView * 0.5
	local radiansFOV = math.rad(halfFOV)

	local distance = halfSize / math.tan(radiansFOV) * (distanceMultiplier or 0.8)
	local offset = maxSize * (offsetMultiplier or 0.5)
	local cameraPosition = (modelCFrame * CFrame.new(CAMERA_OFFSET_DIRECTION * (distance + offset))).Position

	camera.CFrame = CFrame.new(cameraPosition, modelCFrame.Position)
end

-- Public Functions

--- Calculates the sell value of an animal
--- @param animalName string - Name of the animal
--- @return number - Sell value
function AnimalSystem:GetSellValue(animalName)
	local basePrice = self:GetPrice(animalName)
	local sellValue = basePrice * GameData.Animal.SellModifier
	return math.ceil(sellValue)
end

--- Applies a mutation to an animal model
--- @param model Model - The animal model
--- @param animalName string - Name of the animal
--- @param mutationName string - Name of the mutation
--- @return function - Cleanup function
function AnimalSystem:ApplyMutation(model, animalName, mutationName)
	local trove = Trove.new()

	-- Clean up when model is removed
	trove:Add(model.AncestryChanged:Connect(function(_, parent)
		if not parent then
			trove:Destroy()
		end
	end))

	local mutationData = MutationsData[mutationName]
	local mutationSurface = MutationSurfaces[animalName]

	-- Get palette for mutation
	local paletteAttribute = string.format("%s*Palette", mutationName)
	local palette = model:GetAttribute(paletteAttribute) or model:GetAttribute("Palette") or 1

	if not (mutationData and mutationData.Palettes[palette]) then
		palette = 1
	end

	local modifiedParts = {}

	if mutationName == "Rainbow" then
		-- Handle rainbow mutation
		trove:Add(function()
			model:RemoveTag("RainbowModel")
		end)

		for _, part in model:GetDescendants() do
			if part:IsA("BasePart") and not part:GetAttribute("IgnoreRainbowColor") then
				local surfaceAppearance = part:FindFirstChildOfClass("SurfaceAppearance")

				if surfaceAppearance then
					trove:Add(function()
						local currentSurface = part:FindFirstChildOfClass("SurfaceAppearance")
						if currentSurface then
							currentSurface:Destroy()
						end
						surfaceAppearance:Clone().Parent = part
					end)
				else
					local originalColor = part.Color
					trove:Add(function()
						part.Color = originalColor
					end)

					local originalMaterialVariant = part.MaterialVariant
					if originalMaterialVariant == "Strawberry Stud Light" or originalMaterialVariant == "Strawberry Stud Dark" then
						part.MaterialVariant = ""
						trove:Add(function()
							part.MaterialVariant = originalMaterialVariant
						end)
					end
				end
			end
		end

		model:AddTag("RainbowModel")
	else
		-- Handle other mutations
		local colorPalette = mutationData.Palettes[palette]

		for _, part in model:GetDescendants() do
			if part:IsA("BasePart") and not part:GetAttribute("IgnoreColor") then
				local colorAttribute = string.format("%s*Color", mutationName)
				local colorIndex = part:GetAttribute(colorAttribute) or part:GetAttribute("Color") or 1
				local newColor = colorPalette[colorIndex]

				if not newColor then
					newColor = colorPalette[math.clamp(colorIndex, 1, #colorPalette)]
				end

				local surfaceAppearance = part:FindFirstChildOfClass("SurfaceAppearance")

				if surfaceAppearance then
					surfaceAppearance:Destroy()
					local newSurface = trove:Clone(mutationSurface)
					newSurface.Color = newColor
					newSurface.Parent = part

					trove:Add(function()
						local currentSurface = part:FindFirstChildOfClass("SurfaceAppearance")
						if currentSurface then
							currentSurface:Destroy()
						end
						surfaceAppearance:Clone().Parent = part
					end)
				else
					local originalMaterialVariant = part.MaterialVariant

					if originalMaterialVariant == "Strawberry Stud Light" or originalMaterialVariant == "Strawberry Stud Dark" then
						modifiedParts[part] = true
						part.MaterialVariant = string.format("%s* Strawberry Stud Light", mutationName)

						trove:Add(function()
							part.MaterialVariant = originalMaterialVariant
						end)
					end

					if originalMaterialVariant ~= "Strawberry Stud Light" then
						local originalColor = part.Color
						part.Color = newColor

						trove:Add(function()
							part.Color = originalColor
						end)
					end
				end
			end
		end
	end

	-- Apply special material effects
	if mutationName == "Lava" then
		for _, part in model:GetDescendants() do
			if part:IsA("BasePart") and not (part:GetAttribute("IgnoreColor") or modifiedParts[part]) then
				local colorAttribute = string.format("%s*Color", mutationName)
				local colorIndex = part:GetAttribute(colorAttribute) or part:GetAttribute("Color")

				if colorIndex == 1 then
					local originalMaterial = part.Material
					part.Material = Enum.Material.Neon

					trove:Add(function()
						part.Material = originalMaterial
					end)
				end
			end
		end
	elseif mutationName == "Galaxy" then
		for _, part in model:GetDescendants() do
			if part:IsA("BasePart") and not (part:GetAttribute("IgnoreColor") or modifiedParts[part]) then
				local colorAttribute = string.format("%s*Color", mutationName)
				local colorIndex = part:GetAttribute(colorAttribute) or part:GetAttribute("Color")

				if colorIndex == 1 then
					local originalMaterial = part.Material
					part.Material = Enum.Material.Neon

					trove:Add(function()
						part.Material = originalMaterial
					end)
				end

				local originalMaterialVariant = part.MaterialVariant
				part.MaterialVariant = "Galaxy Stud"

				trove:Add(function()
					part.MaterialVariant = originalMaterialVariant
				end)
			end
		end
	end

	-- Apply VFX
	local vfxFolder = VFXFolder:FindFirstChild(mutationName)
	local vfxInstance = model:FindFirstChild("VfxInstance")

	if vfxFolder and vfxInstance then
		for _, vfx in vfxFolder:GetChildren() do
			trove:Clone(vfx).Parent = vfxInstance
		end
	end

	return trove:WrapClean()
end

--- Applies traits to an animal model
--- @param model Model - The animal model
--- @param animalName string - Name of the animal
--- @param traits table - Array of trait names
--- @return function - Cleanup function
function AnimalSystem:ApplyTraits(model, animalName, traits)
	local trove = Trove.new()
	local hasMatteoHat = table.find(traits, "Matteo Hat") ~= nil
	local hasLightning = table.find(traits, "Lightning") ~= nil

	for _, traitName in traits do
		local traitData = TraitsData[traitName]
		if not traitData then
			continue
		end

		-- Apply per-animal trait models
		local animalTraitFolder = Models.TraitsPerAnimal:FindFirstChild(traitName)
		if animalTraitFolder then
			local traitModel = animalTraitFolder:FindFirstChild(animalName)
			if traitModel then
				local clonedTrait = trove:Clone(traitModel)
				clonedTrait.Name = string.format("_Trait.%s", traitName)

				for _, part in clonedTrait:GetChildren() do
					local attachment = part:FindFirstChildOfClass("Attachment")
					if attachment then
						local targetAttachment = model:FindFirstChild(attachment.Name, true)
						if targetAttachment then
							local constraint = Instance.new("RigidConstraint")
							constraint.Attachment0 = attachment
							constraint.Attachment1 = targetAttachment
							constraint.Parent = part
						end
					end
				end

				clonedTrait.Parent = model
			end
		end

		-- Apply generic trait models
		local genericTraitModel = TraitModels:FindFirstChild(traitName)
		if genericTraitModel then
			local clonedTrait = trove:Clone(genericTraitModel)
			clonedTrait.Name = string.format("_Trait.%s", traitName)

			for _, part in clonedTrait:GetChildren() do
				local hasValidAttachment = false

				for _, attachment in part:GetChildren() do
					local targetAttachment = model:FindFirstChild(attachment.Name, true)
					if targetAttachment then
						hasValidAttachment = true

						-- Special positioning for Taco trait with Matteo Hat
						if traitName == "Taco" and hasMatteoHat then
							attachment.Position = attachment.Position + Vector3.new(0, -1.33, 0)
						end

						local constraint = Instance.new("RigidConstraint")
						constraint.Attachment0 = attachment
						constraint.Attachment1 = targetAttachment
						constraint.Parent = part

						if traitData.Modify then
							traitData.Modify(part, attachment, targetAttachment)
						end
					end
				end

				if not hasValidAttachment then
					part:Destroy()
				end
			end

			clonedTrait.Parent = model

			-- Special handling for Lightning trait animation
			if hasLightning then
				local animator = clonedTrait:FindFirstChildWhichIsA("Animator", true)
				if animator then
					animator:SetAttribute("Animation", "Animations.Traits.Lightning")
					animator:AddTag("ClientLoadAnimation")
				end
			end
		end

		-- Apply trait VFX
		local traitVFXFolder = TraitVFX:FindFirstChild(traitName)
		if traitVFXFolder then
			for _, vfxPart in traitVFXFolder:GetChildren() do
				local targetPart = model:FindFirstChild(vfxPart.Name)
				if targetPart then
					local vfxClone = trove:Clone(vfxPart)
					vfxClone.Massless = true
					vfxClone.CanCollide = false
					vfxClone.CanQuery = false
					vfxClone.CanTouch = false
					vfxClone.Transparency = 1
					vfxClone.CFrame = targetPart.CFrame
					vfxClone.Name = string.format("_%s", vfxPart.Name)

					local weld = Instance.new("WeldConstraint", vfxClone)
					weld.Part0 = targetPart
					weld.Part1 = vfxClone

					vfxClone.Parent = model

					if traitData.ModifyVFX then
						traitData.ModifyVFX(vfxClone, targetPart)
					end
				end
			end
		end

		-- Special handling for Strawberry trait
		if traitName == "Strawberry" and animalName ~= "Strawberry Elephant" then
			for _, part in model:GetDescendants() do
				if part:IsA("BasePart") then
					local originalMaterialVariant = part.MaterialVariant
					local originalColor = part.Color

					if part:HasTag("Strawberry") then
						part.Color = Color3.fromRGB(255, 255, 255)
						part.Material = Enum.Material.SmoothPlastic
						part.MaterialVariant = "Strawberry Stud Light"

						trove:Add(function()
							part.MaterialVariant = originalMaterialVariant
							part.Color = originalColor
						end)
					elseif part:HasTag("Strawberry2") then
						part.Color = Color3.fromRGB(193, 193, 193)
						part.Material = Enum.Material.SmoothPlastic
						part.MaterialVariant = "Strawberry Stud Light"

						trove:Add(function()
							part.MaterialVariant = originalMaterialVariant
							part.Color = originalColor
						end)
					elseif part:HasTag("Strawberry3") then
						part.Color = Color3.fromRGB(147, 147, 147)
						part.Material = Enum.Material.SmoothPlastic
						part.MaterialVariant = "Strawberry Stud Light"

						trove:Add(function()
							part.MaterialVariant = originalMaterialVariant
							part.Color = originalColor
						end)
					end
				end
			end
		end
	end

	return trove:WrapClean()
end

--- Creates an animated animal model
--- @param animalName string - Name of the animal
--- @param animationName string - Name of the animation
--- @return Model - The animated model
function AnimalSystem:GetAnimatedModel(animalName, animationName)
	local animalModel = AnimalModels:FindFirstChild(animalName)
	if not animalModel then
		warn(string.format("Animal not found '%s' in model folder", animalName))
		return
	end

	local clonedModel = animalModel:Clone()
	clonedModel.PrimaryPart.Anchored = true
	clonedModel.Parent = workspace

	-- Set up animation
	local animationFolder = AnimalAnimations:FindFirstChild(animalName)
	local animation = animationFolder and animationFolder:FindFirstChild(animationName)

	local animationController = clonedModel:FindFirstChild("AnimationController") or Instance.new("AnimationController", clonedModel)
	local animator = animationController:FindFirstChild("Animator") or Instance.new("Animator", animationController)

	if animation and animator then
		local loadedAnimation = animator:LoadAnimation(animation)
		loadedAnimation.Looped = true
		loadedAnimation:Play()
	end

	-- Configure parts
	for _, part in clonedModel:GetDescendants() do
		if part:IsA("BasePart") then
			part.Massless = true
			part.CanCollide = false
			part.CanQuery = false
			part.CanTouch = false
			part.Anchored = false
		end
	end

	return clonedModel
end

--- Attaches an animal model to a viewport frame
--- @param animalName string - Name of the animal
--- @param viewportFrame ViewportFrame - The viewport frame
--- @param enableAnimation boolean - Whether to enable animation
--- @param mutationName string - Name of mutation to apply (optional)
--- @return Trove, Model - Cleanup trove and the model
function AnimalSystem:AttachOnViewport(animalName, viewportFrame, enableAnimation, mutationName)
	local trove = Trove.new()
	local animalModel = AnimalModels:FindFirstChild(animalName)

	if not animalModel then
		warn(string.format("Animal not found '%s' in model folder", animalName))
		return trove
	end

	local clonedModel = animalModel:Clone()
	trove:Add(clonedModel)

	if enableAnimation then
		local worldModel = Instance.new("WorldModel")
		worldModel.Parent = viewportFrame
		trove:Add(worldModel)
		clonedModel.Parent = worldModel

		local function setupAnimation()
			task.wait()
			local animationFolder = AnimalAnimations:FindFirstChild(animalName)
			local idleAnimation = animationFolder and animationFolder:FindFirstChild("Idle")

			local animationController = clonedModel:FindFirstChild("AnimationController") or Instance.new("AnimationController", clonedModel)
			local animator = animationController:FindFirstChild("Animator") or Instance.new("Animator", animationController)

			if idleAnimation and animator then
				local loadedAnimation = animator:LoadAnimation(idleAnimation)
				loadedAnimation.Looped = true
				loadedAnimation:Play(0)
			end
		end

		if viewportFrame.Parent then
			trove:Add(task.defer(setupAnimation))
		else
			trove:Add(viewportFrame.AncestryChanged:Once(setupAnimation))
		end
	else
		clonedModel.Parent = viewportFrame
	end

	-- Set up camera
	local camera = Instance.new("Camera")
	camera.FieldOfView = 50
	camera.Parent = viewportFrame
	viewportFrame.CurrentCamera = camera
	trove:Add(camera)

	positionCameraForModel(camera, clonedModel, camera.FieldOfView, 0.75, 0.7)

	-- Clean up when viewport is removed
	trove:Add(viewportFrame.AncestryChanged:Connect(function(_, parent)
		if not parent then
			trove:Destroy()
		end
	end))

	-- Apply mutation if specified
	if mutationName and mutationName ~= "Default" then
		trove:Add(self:ApplyMutation(clonedModel, animalName, mutationName))
	end

	return trove, clonedModel
end

--- Gets a list of animals by rarity
--- @param rarityName string - Name of the rarity
--- @return table - Array of animal names
function AnimalSystem:GetListOfRarity(rarityName)
	local animals = {}

	for animalName, animalData in AnimalsData do
		if animalData.Rarity == rarityName then
			table.insert(animals, animalName)
		end
	end

	return animals
end

--- Gets a sorted list of animals
--- @param sortBy string - "Rarity" or "Price"
--- @param ascending boolean - Whether to sort in ascending order
--- @return table - Sorted array of animal names
function AnimalSystem:GetList(sortBy, ascending)
	local animals = {}

	-- Filter enabled animals
	for animalName, animalData in AnimalsData do
		if not animalData.IsEnabled or animalData.IsEnabled() then
			table.insert(animals, animalName)
		end
	end

	if sortBy == "Rarity" then
		table.sort(animals, function(a, b)
			local dataA = AnimalsData[a]
			local dataB = AnimalsData[b]

			local rarityA = dataA and dataA.Rarity
			local rarityB = dataB and dataB.Rarity

			local weightA = rarityA and (RaritiesData[rarityA] and RaritiesData[rarityA].Weight) or 0
			local weightB = rarityB and (RaritiesData[rarityB] and RaritiesData[rarityB].Weight) or 0

			if ascending then
				return weightA < weightB
			else
				return weightB < weightA
			end
		end)
	elseif sortBy == "Price" then
		table.sort(animals, function(a, b)
			local dataA = AnimalsData[a]
			local dataB = AnimalsData[b]

			local priceA = dataA and dataA.Price or 0
			local priceB = dataB and dataB.Price or 0

			if ascending then
				return priceA < priceB
			else
				return priceB < priceA
			end
		end)
	end

	return animals
end

--- Calculates the generation value of an animal
--- @param animalName string - Name of the animal
--- @param mutationName string - Name of mutation (optional)
--- @param traits table - Array of trait names (optional)
--- @param player Player - Player for cash multiplier (optional)
--- @return number - Generation value
function AnimalSystem:GetGeneration(animalName, mutationName, traits, player)
	local animalData = AnimalsData[animalName]
	if not animalData then
		return 0
	end

	-- Base generation value
	local baseValue = animalData.Generation or (animalData.Price * GameData.Game.AnimalGanerationModifier)

	-- Mutation multiplier
	local mutationMultiplier = 1
	if mutationName then
		local mutationData = MutationsData[mutationName]
		if mutationData then
			mutationMultiplier = mutationMultiplier + mutationData.Modifier
		end
	end

	-- Trait multipliers
	local hasSleepy = false
	if traits then
		for _, traitName in traits do
			local traitData = TraitsData[traitName]
			if traitData then
				if traitName == "Sleepy" then
					hasSleepy = true
				else
					mutationMultiplier = mutationMultiplier + traitData.MultiplierModifier
				end
			end
		end
	end

	local finalValue = baseValue * mutationMultiplier

	-- Sleepy trait reduces value by half
	if hasSleepy then
		finalValue = finalValue * 0.5
	end

	-- Player cash multiplier
	if player then
		local gameModule = require(ReplicatedStorage.Shared.Game)
		finalValue = finalValue * gameModule:GetPlayerCashMultiplayer(player)
	end

	return math.round(finalValue)
end

--- Gets the base price of an animal
--- @param animalName string - Name of the animal
--- @return number - Base price
function AnimalSystem:GetPrice(animalName)
	local animalData = AnimalsData[animalName]
	return animalData and animalData.Price or 0
end

return AnimalSystem