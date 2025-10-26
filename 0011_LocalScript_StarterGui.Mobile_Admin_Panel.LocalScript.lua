--[[
  Extracted from: StarterGui.Mobile Admin Panel.LocalScript
  Class: LocalScript
  Source file: rickdev.rbxlx
]]

--- Thanks ! RYZ3N https://discord.gg/GQRz9JxK
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Whitelist
local allowedUserIds = {
	[1619785398] = true, 
	[87654321] = true,
	[11223344] = true,
}

if not allowedUserIds[LocalPlayer.UserId] then
	return
end

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AdminControlPanel"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main toggle button
local toggleButton = Instance.new("ImageButton")
toggleButton.Name = "AdminPanelToggle"
toggleButton.Size = UDim2.new(0, 50, 0, 50)
toggleButton.Position = UDim2.new(1, -70, 0.5, -25)
toggleButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
toggleButton.BorderSizePixel = 0
toggleButton.Parent = screenGui

-- Gradient background
local btnGradient = Instance.new("UIGradient")
btnGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 80, 80)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 30))
}
btnGradient.Rotation = 90
btnGradient.Parent = toggleButton

-- Make button circular
local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(1, 0)
btnCorner.Parent = toggleButton

-- Icon inside button
toggleButton.Image = "rbxassetid://6031280882" -- Gear icon
toggleButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.BackgroundTransparency = 0

-- Hover grow effect
toggleButton.MouseEnter:Connect(function()
	toggleButton:TweenSize(UDim2.new(0, 58, 0, 58), "Out", "Quad", 0.2, true)
end)
toggleButton.MouseLeave:Connect(function()
	toggleButton:TweenSize(UDim2.new(0, 50, 0, 50), "Out", "Quad", 0.2, true)
end)

-- Main frame with modern styling
local frame = Instance.new("Frame")
frame.Name = "AdminPanelFrame"
frame.Size = UDim2.new(0, 500, 0, 340)
frame.Position = UDim2.new(0.5, -250, 1, 20) -- start off-screen (bottom)
frame.BorderSizePixel = 0
frame.Visible = false
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.Parent = screenGui

-- Gradient background for frame
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 45, 45)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 20))
}
gradient.Rotation = 90
gradient.Parent = frame

-- Rounded frame
local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 12)
frameCorner.Parent = frame

-- Subtle shadow effect
local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.Size = UDim2.new(1, 10, 1, 10)
shadow.Position = UDim2.new(0, -5, 0, -5)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://5554236805"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.8
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 118, 118)
shadow.Parent = frame
shadow.ZIndex = -1

-- Title bar for dragging with gradient text
local titleContainer = Instance.new("Frame")
titleContainer.Size = UDim2.new(1, 0, 0, 40)
titleContainer.BackgroundTransparency = 1
titleContainer.Parent = frame

local title = Instance.new("TextLabel")
title.Text = "Admin Control Panel"
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.Parent = titleContainer

-- Gradient text effect
local titleGradient = Instance.new("UIGradient")
titleGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 150, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 100, 255))
}
titleGradient.Rotation = 45
titleGradient.Parent = title

-- Tab container on the left
local tabContainer = Instance.new("Frame")
tabContainer.Size = UDim2.new(0, 120, 1, -40)
tabContainer.Position = UDim2.new(0, 0, 0, 40)
tabContainer.BackgroundTransparency = 1
tabContainer.Parent = frame

-- Content container on the right
local contentContainer = Instance.new("Frame")
contentContainer.Size = UDim2.new(1, -120, 1, -40)
contentContainer.Position = UDim2.new(0, 120, 0, 40)
contentContainer.BackgroundTransparency = 1
contentContainer.Parent = frame

-- Tab buttons
local tabs = {
	{Name = "Animal Spawner", Icon = "🐾"},
	{Name = "Event Controller", Icon = "⚡"}
}

local currentTab = "Animal Spawner"

local function createTabButton(tabData, index)
	local tabButton = Instance.new("TextButton")
	tabButton.Size = UDim2.new(1, -10, 0, 40)
	tabButton.Position = UDim2.new(0, 5, 0, (index-1) * 45)
	tabButton.Text = " " .. tabData.Icon .. "  " .. tabData.Name
	tabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
	tabButton.Font = Enum.Font.Gotham
	tabButton.TextSize = 14
	tabButton.TextXAlignment = Enum.TextXAlignment.Left
	tabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	tabButton.Parent = tabContainer

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = tabButton

	tabButton.MouseEnter:Connect(function()
		if currentTab ~= tabData.Name then
			TweenService:Create(tabButton, TweenInfo.new(0.15), {
				BackgroundColor3 = Color3.fromRGB(45, 45, 45)
			}):Play()
		end
	end)

	tabButton.MouseLeave:Connect(function()
		if currentTab ~= tabData.Name then
			TweenService:Create(tabButton, TweenInfo.new(0.15), {
				BackgroundColor3 = Color3.fromRGB(35, 35, 35)
			}):Play()
		end
	end)

	tabButton.MouseButton1Click:Connect(function()
		currentTab = tabData.Name
		-- Update all tab buttons
		for _, child in ipairs(tabContainer:GetChildren()) do
			if child:IsA("TextButton") then
				if child.Text:find(tabData.Name) then
					TweenService:Create(child, TweenInfo.new(0.15), {
						BackgroundColor3 = Color3.fromRGB(60, 60, 60),
						TextColor3 = Color3.fromRGB(255, 255, 255)
					}):Play()
				else
					TweenService:Create(child, TweenInfo.new(0.15), {
						BackgroundColor3 = Color3.fromRGB(35, 35, 35),
						TextColor3 = Color3.fromRGB(200, 200, 200)
					}):Play()
				end
			end
		end

		-- Show appropriate content
		for _, child in ipairs(contentContainer:GetChildren()) do
			child.Visible = (child.Name == tabData.Name)
		end
	end)

	return tabButton
end

-- Create tab buttons
for i, tab in ipairs(tabs) do
	createTabButton(tab, i)
end

-- ANIMAL SPAWNER CONTENT
local animalSpawnerFrame = Instance.new("Frame")
animalSpawnerFrame.Name = "Animal Spawner"
animalSpawnerFrame.Size = UDim2.new(1, 0, 1, 0)
animalSpawnerFrame.BackgroundTransparency = 1
animalSpawnerFrame.Visible = true
animalSpawnerFrame.Parent = contentContainer

-- Input boxes for animal spawner
local function createInputField(labelText, yPos, parent)
	-- Label with gradient text
	local label = Instance.new("TextLabel")
	label.Text = labelText
	label.Size = UDim2.new(1, -20, 0, 20)
	label.Position = UDim2.new(0, 10, 0, yPos)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(200, 200, 200)
	label.Font = Enum.Font.Gotham
	label.TextSize = 16
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = parent

	-- Text box with modern styling
	local box = Instance.new("TextBox")
	box.Size = UDim2.new(1, -20, 0, 35)
	box.Position = UDim2.new(0, 10, 0, yPos + 20)
	box.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	box.TextColor3 = Color3.fromRGB(255, 255, 255)
	box.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
	box.ClearTextOnFocus = false
	box.Font = Enum.Font.Gotham
	box.TextSize = 16
	box.Parent = parent

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = box

	return box
end

local animalNameBox = createInputField("Animal Name", 20, animalSpawnerFrame)
animalNameBox.PlaceholderText = "Enter animal name"

local mutationBox = createInputField("Mutation (optional)", 80, animalSpawnerFrame)
mutationBox.PlaceholderText = "Enter mutation"

local traitsBox = createInputField("Traits (e.g. [\"Taco\"])", 140, animalSpawnerFrame)
traitsBox.PlaceholderText = "Enter traits as a list"

-- Spawn Button with gradient
local spawnButton = Instance.new("TextButton")
spawnButton.Text = "Spawn Animal"
spawnButton.Size = UDim2.new(0.5, -15, 0, 40)
spawnButton.Position = UDim2.new(0, 10, 0, 210)
spawnButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
spawnButton.TextColor3 = Color3.fromRGB(255, 255, 255)
spawnButton.Font = Enum.Font.GothamBold
spawnButton.TextSize = 18
spawnButton.Parent = animalSpawnerFrame

-- Button gradient
local spawnBtnGradient = Instance.new("UIGradient")
spawnBtnGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 180, 80)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 140, 40))
}
spawnBtnGradient.Rotation = 90
spawnBtnGradient.Parent = spawnButton

local btnCorner2 = Instance.new("UICorner")
btnCorner2.CornerRadius = UDim.new(0, 8)
btnCorner2.Parent = spawnButton

-- Hover effect for spawn button
spawnButton.MouseEnter:Connect(function()
	TweenService:Create(spawnBtnGradient, TweenInfo.new(0.15), {
		Color = ColorSequence.new{
			ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 200, 100)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 160, 60))
		}
	}):Play()
end)
spawnButton.MouseLeave:Connect(function()
	TweenService:Create(spawnBtnGradient, TweenInfo.new(0.15), {
		Color = ColorSequence.new{
			ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 180, 80)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 140, 40))
		}
	}):Play()
end)

-- Result label for animal spawner
local animalResultLabel = Instance.new("TextLabel")
animalResultLabel.Text = ""
animalResultLabel.Size = UDim2.new(0.5, -15, 0, 40)
animalResultLabel.Position = UDim2.new(0.5, 5, 0, 210)
animalResultLabel.BackgroundTransparency = 1
animalResultLabel.Font = Enum.Font.Gotham
animalResultLabel.TextSize = 16
animalResultLabel.TextWrapped = true
animalResultLabel.Parent = animalSpawnerFrame

-- Result label gradient
local animalResultGradient = Instance.new("UIGradient")
animalResultGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 220, 80)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 180, 40))
}
animalResultGradient.Rotation = 45
animalResultGradient.Parent = animalResultLabel

-- EVENT CONTROLLER CONTENT
local eventControllerFrame = Instance.new("Frame")
eventControllerFrame.Name = "Event Controller"
eventControllerFrame.Size = UDim2.new(1, 0, 1, 0)
eventControllerFrame.BackgroundTransparency = 1
eventControllerFrame.Visible = false
eventControllerFrame.Parent = contentContainer

-- Event controller content (from your script)
local function createLabel(text, posY)
	local lbl = Instance.new("TextLabel")
	lbl.Text = text
	lbl.Size = UDim2.new(0, 120, 0, 30)
	lbl.Position = UDim2.new(0, 15, 0, posY)
	lbl.BackgroundTransparency = 1
	lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
	lbl.Font = Enum.Font.Gotham
	lbl.TextSize = 18
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.Parent = eventControllerFrame
	return lbl
end

local function createBox(placeholder, posY)
	local box = Instance.new("TextBox")
	box.Size = UDim2.new(0, 210, 0, 30)
	box.Position = UDim2.new(0, 135, 0, posY)
	box.PlaceholderText = placeholder
	box.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
	box.TextColor3 = Color3.fromRGB(255, 255, 255)
	box.Font = Enum.Font.Gotham
	box.TextSize = 18
	box.Parent = eventControllerFrame
	Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
	return box
end

createLabel("Event Name:", 20)
local eventNameBox = createBox("Enter event name", 20)

createLabel("Duration (sec):", 60)
local durationBox = createBox("Enter duration (optional)", 60)

-- Result label for event controller
local eventResultLabel = Instance.new("TextLabel")
eventResultLabel.Text = ""
eventResultLabel.Size = UDim2.new(1, -20, 0, 60)
eventResultLabel.Position = UDim2.new(0, 10, 0, 100)
eventResultLabel.BackgroundTransparency = 1
eventResultLabel.TextColor3 = Color3.fromRGB(255, 220, 80)
eventResultLabel.Font = Enum.Font.GothamBold
eventResultLabel.TextSize = 16
eventResultLabel.TextWrapped = true
eventResultLabel.Parent = eventControllerFrame

-- Event buttons
local buttonData = {
	{Text = "Start Event", Action = "start"},
	{Text = "Stop Event", Action = "stop"},
	{Text = "List Events", Action = "list"},
	{Text = "Status", Action = "status"},
	{Text = "Random Event", Action = "random"},
	{Text = "Stop All", Action = "stopall"},
}

local function createButton(index, text, action)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 165, 0, 36)
	btn.Position = UDim2.new(0, 15 + ((index-1)%2)*175, 0, 170 + math.floor((index-1)/2)*44)
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 18
	btn.Parent = eventControllerFrame
	btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)

	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

	local gradient = Instance.new("UIGradient", btn)
	gradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(90, 90, 90)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 50, 50))
	}
	gradient.Rotation = 90

	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, 175, 0, 40),
			BackgroundColor3 = Color3.fromRGB(110, 110, 110)
		}):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, 165, 0, 36),
			BackgroundColor3 = Color3.fromRGB(70, 70, 70)
		}):Play()
	end)

	btn.MouseButton1Click:Connect(function()
		local eventName = eventNameBox.Text ~= "" and eventNameBox.Text or nil
		local duration = tonumber(durationBox.Text)
		if (action == "start" or action == "stop") and not eventName then
			eventResultLabel.Text = "Please enter an event name!"
			return
		end
		local GlobalEventRequest = ReplicatedStorage:FindFirstChild("GlobalEventRequest")
		if GlobalEventRequest then
			GlobalEventRequest:FireServer(action, eventName, duration)
			eventResultLabel.Text = "Request sent..."
		else
			eventResultLabel.Text = "Error: GlobalEventRequest not found"
		end
	end)
end

for i, data in ipairs(buttonData) do
	createButton(i, data.Text, data.Action)
end

-- Toggle frame with slide animation
local frameOpenPos = UDim2.new(0.5, -250, 0.5, -170)
local frameClosedPos = UDim2.new(0.5, -250, 1, 20)

toggleButton.MouseButton1Click:Connect(function()
	if not frame.Visible then
		frame.Visible = true
		TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = frameOpenPos}):Play()
	else
		local tween = TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = frameClosedPos})
		tween:Play()
		tween.Completed:Connect(function()
			frame.Visible = false
		end)
	end
end)

-- Dragging system
local dragging, dragStart, startPos

local function updateDrag(input)
	local delta = input.Position - dragStart
	frame.Position = UDim2.new(
		startPos.X.Scale, startPos.X.Offset + delta.X,
		startPos.Y.Scale, startPos.Y.Offset + delta.Y
	)
end

titleContainer.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

titleContainer.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
		updateDrag(input)
	end
end)

-- Spawn logic for animal spawner
spawnButton.MouseButton1Click:Connect(function()
	local animalName = animalNameBox.Text
	local mutation = mutationBox.Text
	local traits = traitsBox.Text

	animalResultLabel.Text = "Sending request..."

	-- Check if the remote event exists
	local event = ReplicatedStorage:FindFirstChild("SpawnRoadAnimalRequest")
	if event then
		event:FireServer(animalName, mutation, traits)
	else
		animalResultLabel.Text = "Error: Remote event not found"
		warn("SpawnRoadAnimalRequest remote event not found in ReplicatedStorage")
	end
end)

-- Listen for response from server for animal spawner
local animalRemoteEvent = ReplicatedStorage:FindFirstChild("SpawnRoadAnimalRequest")
if animalRemoteEvent then
	animalRemoteEvent.OnClientEvent:Connect(function(resultText)
		animalResultLabel.Text = resultText
	end)
else
	warn("SpawnRoadAnimalRequest remote event not found in ReplicatedStorage")
end

-- Listen for response from server for event controller
local eventRemoteEvent = ReplicatedStorage:FindFirstChild("GlobalEventRequest")
if eventRemoteEvent then
	eventRemoteEvent.OnClientEvent:Connect(function(response)
		eventResultLabel.Text = tostring(response)
	end)
else
	warn("GlobalEventRequest remote event not found in ReplicatedStorage")
end

-- Set initial tab state
for _, child in ipairs(tabContainer:GetChildren()) do
	if child:IsA("TextButton") and child.Text:find("Animal Spawner") then
		TweenService:Create(child, TweenInfo.new(0.15), {
			BackgroundColor3 = Color3.fromRGB(60, 60, 60),
			TextColor3 = Color3.fromRGB(255, 255, 255)
		}):Play()
	end
end