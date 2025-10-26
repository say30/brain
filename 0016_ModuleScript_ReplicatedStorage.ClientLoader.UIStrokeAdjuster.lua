--[[
  Extracted from: ReplicatedStorage.ClientLoader.UIStrokeAdjuster
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

--// Awesom3_Eric
--// 1/25/2024 @ 12:01AM
--// UIStrokeAdjuster


----------------------------------------------------
--[[
Edited by Meat_Make 12/2/2024

Changes::

- UIStrokeAdjuster's TagScreenGui and TagBillboardGui now correctly validates passed inputs
- Fixed issue where UIStrokeAdjuster did not work if tagged objects exists before the Module is required
- Module now has a initialization function that only runs once. Meaning multiple scripts can require the module without trouble. 

]]
----------------------------------------------------

--[[== CONFIGURATIONS ==]]--

-- Paste the following code into the command bar and change the Studio_Viewport_Size to the values in the output bar:
-- print(workspace.CurrentCamera.ViewportSize)
local Studio_Viewport_Size = Vector2.new(1616, 880)

-- Set to true to automatically tag BillboardGuis and ScreenGuis recursively in PlayerGui
-- It's advised to use the :TagScreenGui() and :TagBillboardGui() features for the best performance
local Auto_Tag = false

-- Stroke sizes update every Update_Delay seconds
local Update_Delay = 1

-- Change if you want lol
local Billboard_Tag = "Billboard"
local Screen_Gui_Tag = "ScreenGui"
local Screen_Stroke_Tag = "ScreenStroke"
local Default_Billboard_Distance = 10 -- Estimated distance if "Distance" attribute of BillboardGui is not set

--


--[[== CODE ==]]--

--|| Initialization ||--

-- Services
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")

-- Player
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui", 100)

-- Variables
local camera = workspace.CurrentCamera





--|| Utility Functions ||--

-- Returns average resolution of Vector2
local function getBox(vector: Vector2): number
	return math.min(vector.X, vector.Y)
end

-- Returns ratio of current viewport size to studio viewport size
local function getScreenRatio(): number
	return getBox(camera.ViewportSize)/getBox(Studio_Viewport_Size)
end

-- Recursively tags instance with tag based on objectType
-- Listens for added instances
local function tagRecursive(instance: Instance, objectType: string, tag: string)
	if instance:IsA(objectType) then
		CollectionService:AddTag(instance, tag)
	end
	for _, child in instance:GetChildren() do
		tagRecursive(child, objectType, tag)
	end
	instance.ChildAdded:Connect(function(child)
		tagRecursive(child, objectType, tag)
	end)
end

-- Returns position of part or model (for relative BillboardGui position)
local function getInstancePosition(instance: Instance): Vector3
	if instance:IsA("Part") then
		return instance.Position
	elseif instance:IsA("Model") then
		local cf, size = instance:GetBoundingBox()
		return cf.Position
	end
	return Vector3.new(0, 0, 0)
end



--|| ScreenGui Updating ||--

local ScreenStrokes = {}



-- Updates ScreenGui strokes
local function updateScreenGuiStrokes()
	for uiStroke, originalThickness in ScreenStrokes do
		if not uiStroke.Parent then
			ScreenStrokes[uiStroke] = nil
		else
			uiStroke.Thickness = originalThickness * getScreenRatio()
		end
	end
end





--|| BillboardGui Updating ||--

--Edit



-- Automatically tag ScreenGuis and BillboardGuis in PlayerGui if Auto_Tag == true
if Auto_Tag then
	tagRecursive(PlayerGui, "ScreenGui", Screen_Gui_Tag)
	tagRecursive(PlayerGui, "BillboardGui", Billboard_Tag)
end

---------------------------------------------------- init function
local initialized = false

function init()
	local function newScreenGuiTag(screenGui)
		tagRecursive(screenGui, "UIStroke", Screen_Stroke_Tag)
	end

	local function newScreenStrokeTag(uiStroke)
		ScreenStrokes[uiStroke] = uiStroke.Thickness
		uiStroke.Thickness *= getScreenRatio()
	end

	local function newBillboardTag(billboardGui)

		-- Index BillboardGui's UIStrokes recursively
		local BillboardStrokes = {}
		local function getUiStrokeFromInstance(instance: Instance)
			if instance:IsA("UIStroke") then
				BillboardStrokes[instance] = instance.Thickness
			end
			for _, uiStroke in instance:GetChildren() do
				getUiStrokeFromInstance(uiStroke)
			end
			instance.ChildAdded:Connect(getUiStrokeFromInstance)
		end
		getUiStrokeFromInstance(billboardGui)

		-- Update UIStrokes every Update_Delay seconds
		local start = tick()
		local update; update = RunService.Heartbeat:Connect(function()
			if tick() - start > Update_Delay then return end
			start = tick()

			-- Disconnect if BillboardGui is deleted
			if not billboardGui.Parent then
				update:Disconnect()
			else
				-- Update
				local adornee = billboardGui.Adornee
				local origin = adornee and getInstancePosition(adornee) or getInstancePosition(billboardGui.Parent)
				local magnitude = (camera.CFrame.Position - origin).Magnitude
				local distanceRatio = ((billboardGui:GetAttribute("Distance") or Default_Billboard_Distance)/magnitude)
				for stroke, originalThickness in BillboardStrokes do
					if not stroke.Parent then
						BillboardStrokes[stroke] = nil
					else
						stroke.Thickness = originalThickness * distanceRatio * getScreenRatio()
					end
				end
			end
		end)
	end

	------------ DETECT ANY TAGS THAT WERE CREATED RUNTIME

	-- Recurisvely tags UIStrokes in ScreenGui
	CollectionService:GetInstanceAddedSignal(Screen_Gui_Tag):Connect(function(screenGui: ScreenGui)
		newScreenGuiTag(screenGui)
	end)


	-- Indexes UIStroke in ScreenStrokes to update
	CollectionService:GetInstanceAddedSignal(Screen_Stroke_Tag):Connect(function(uiStroke: UIStroke)
		newScreenStrokeTag(uiStroke)
	end)

	-- Initializes thickness update on BillboardGui's UIStrokes
	CollectionService:GetInstanceAddedSignal(Billboard_Tag):Connect(function(billboardGui: BillboardGui)
		newBillboardTag(billboardGui)
	end)

	------------ DETECT ANY TAGS THAT WERE CREATED BEFORE INIT

	local TaggedScreenGui = CollectionService:GetTagged(Screen_Gui_Tag)
	for _, obj in ipairs(TaggedScreenGui) do
		if obj:IsA("ScreenGui") then
			newScreenGuiTag(obj)
		end

	end


	local TaggedScreenStroke = CollectionService:GetTagged(Screen_Stroke_Tag)
	for _, obj in ipairs(TaggedScreenStroke) do
		if obj:IsA("UIStroke") then
			newScreenStrokeTag(obj)
		end
	end

	local TaggedBillboards = CollectionService:GetTagged(Billboard_Tag)
	for _, obj in ipairs(TaggedBillboards) do
		if obj:IsA("BillboardGui") and obj:IsDescendantOf(workspace) then
			newBillboardTag(obj)
		end

	end

	-- Updates UIStrokes thickness in ScreenStrokes when camera viewport size changes
	camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScreenGuiStrokes)
end

if not initialized then
	initialized = true
	init() -- initializes module
end
----------------------------------------------------

--|| Module Functions ||--
local UIStrokeAdjuster = {}

function UIStrokeAdjuster:TagScreenGui(screenGui: ScreenGui)
	if screenGui:IsA("ScreenGui") then
		CollectionService:AddTag(screenGui, Screen_Gui_Tag)
	end
end

function UIStrokeAdjuster:TagBillboardGui(billboardGui: BillboardGui)
	if billboardGui:IsA("BillboardGui") then
		CollectionService:AddTag(billboardGui, Billboard_Tag)
	end
end



return UIStrokeAdjuster