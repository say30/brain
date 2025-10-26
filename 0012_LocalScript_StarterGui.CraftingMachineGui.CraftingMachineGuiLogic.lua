--[[
  Extracted from: StarterGui.CraftingMachineGui.CraftingMachineGuiLogic
  Class: LocalScript
  Source file: rickdev.rbxlx
]]

-- 

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local OpenCraftingMachineGui = ReplicatedStorage:FindFirstChild("OpenCraftingMachineGui")
local RequestCraftingMachineData = ReplicatedStorage:FindFirstChild("RequestCraftingMachineData")
local SyncCraftingMachineData = ReplicatedStorage:FindFirstChild("SyncCraftingMachineData")
local CraftAnimal = ReplicatedStorage:FindFirstChild("CraftAnimal")
local SpawnCraftedAnimal = ReplicatedStorage:FindFirstChild("SpawnCraftedAnimal")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local gui = script.Parent
local frame = gui:FindFirstChild("MainFrame")

local closeBtn = frame and frame:FindFirstChild("CloseBtn")
local titleLabel = frame and frame:FindFirstChild("Title")
local timerFrame = frame and frame:FindFirstChild("TimerFrame")
local timerLabel = timerFrame and timerFrame:FindFirstChild("TimerLabel")
local leftFrame = frame and frame:FindFirstChild("LeftFrame")
local animalListFrame = leftFrame and leftFrame:FindFirstChild("AnimalList")
local leftLabel = leftFrame and leftFrame:FindFirstChild("LeftLabel")
local rightFrame = frame and frame:FindFirstChild("RightFrame")
local reqListFrame = rightFrame and rightFrame:FindFirstChild("ReqList")
local craftBtn = rightFrame and rightFrame:FindFirstChild("CraftBtn")
local spawnBtn = rightFrame and rightFrame:FindFirstChild("SpawnBtn")
local rightLabel = rightFrame and rightFrame:FindFirstChild("RightLabel")

local selectedRecipeName = nil
local currentGlobalData = nil
local playerBase = {}
local craftingInProgress = false
local timerEndTime = nil
local craftTimers = {}

local function updateTimer()
	if not timerEndTime or not timerLabel then return end
	local now = os.time()
	local remain = timerEndTime - now
	if remain < 0 then remain = 0 end
	local min = math.floor(remain / 60)
	local sec = remain % 60
	timerLabel.Text = string.format("Refreshing in: %02d:%02d", min, sec)
	local colorTween = TweenService:Create(timerLabel, TweenInfo.new(0.5), {TextColor3 = Color3.fromRGB(200, 220, 255 - math.floor(remain % 60 * 4) )})
	colorTween:Play()
end

local function updateReqList(recipe)
	if not reqListFrame then return end
	for _, child in reqListFrame:GetChildren() do
		if child:IsA("TextLabel") then
			child:Destroy()
		end
	end
	if not recipe then return end
	local canCraft = true
	local missing = {}
	local y = 0
	for i, animal in recipe.Requires do
		local haveAnimal = playerBase[animal]
		local reqLabel = Instance.new("TextLabel")
		reqLabel.Text = animal
		reqLabel.Size = UDim2.new(1, -16, 0, 36)
		reqLabel.Position = UDim2.new(0, 8, 0, y)
		reqLabel.BackgroundColor3 = haveAnimal and Color3.fromRGB(40, 120, 40) or Color3.fromRGB(0, 0, 0)
		reqLabel.BackgroundTransparency = 0.3
		reqLabel.TextColor3 = Color3.fromRGB(255,255,255)
		reqLabel.Font = Enum.Font.GothamBold
		reqLabel.TextSize = 20
		reqLabel.Parent = reqListFrame
		local reqCorner = Instance.new("UICorner")
		reqCorner.CornerRadius = UDim.new(0, 10)
		reqCorner.Parent = reqLabel
		if not haveAnimal then
			canCraft = false
			table.insert(missing, animal)
		end
		y = y + 40
	end
	local canSpawn = false
	if selectedRecipeName and craftTimers[selectedRecipeName] then
		local now = os.time()
		local endTime = craftTimers[selectedRecipeName]
		if now >= endTime then
			canSpawn = true
		end
	end
	if craftBtn then
		craftBtn.BackgroundColor3 = canCraft and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(80, 80, 80)
		craftBtn.Active = canCraft and not canSpawn
		craftBtn.AutoButtonColor = canCraft and not canSpawn
		craftBtn.Text = canCraft and (canSpawn and "Wait for spawn" or "Craft") or "Craft"
		craftBtn.TextTransparency = canCraft and 0 or 0.3
		craftBtn.TextColor3 = canCraft and Color3.fromRGB(255,255,255) or Color3.fromRGB(200,200,200)
	end
	if spawnBtn then
		spawnBtn.Visible = canSpawn
	end
end

local function updateAnimalList()
	if not animalListFrame or not currentGlobalData or not currentGlobalData.AvailableRecipes then return end
	for _, child in animalListFrame:GetChildren() do
		if child:IsA("GuiObject") then
			child:Destroy()
		end
	end

	local y = 0
	for recipeName, recipe in currentGlobalData.AvailableRecipes do
		-- Container Frame (styled like your screenshot)
		local recipeFrame = Instance.new("Frame")
		recipeFrame.Size = UDim2.new(1, -16, 0, 60)
		recipeFrame.Position = UDim2.new(0, 8, 0, y)
		recipeFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15) -- solid black background
		recipeFrame.BorderSizePixel = 0
		recipeFrame.Parent = animalListFrame

		-- Rounded corners
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 8)
		corner.Parent = recipeFrame

		-- Colored outline
		local stroke = Instance.new("UIStroke")
		stroke.Thickness = 3
		stroke.Color = Color3.fromRGB(0, 0, 0) -- purple border
		stroke.Parent = recipeFrame

		-- Recipe name label
		local label = Instance.new("TextLabel")
		label.Text = recipeName
		label.Size = UDim2.new(1, -20, 1, 0)
		label.Position = UDim2.new(0, 10, 0, 0)
		label.BackgroundTransparency = 1
		label.TextColor3 = Color3.fromRGB(255, 255, 255) -- purple text
		label.Font = Enum.Font.GothamBold
		label.TextSize = 22
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Parent = recipeFrame

		-- Overlay invisible button
		local btn = Instance.new("TextButton")
		btn.BackgroundTransparency = 1
		btn.Size = UDim2.new(1, 0, 1, 0)
		btn.Text = ""
		btn.Parent = recipeFrame

		btn.MouseButton1Click:Connect(function()
			selectedRecipeName = recipeName
			updateReqList(recipe)
			if rightLabel then
				rightLabel.Text = "Selected: " .. recipeName
			end
		end)

		y = y + 70
	end

	animalListFrame.CanvasSize = UDim2.new(0, 0, 0, y)
end

if craftBtn then
	craftBtn.MouseButton1Click:Connect(function()
		if not selectedRecipeName or craftingInProgress or not CraftAnimal then return end
		craftBtn.Text = "Crafting..."
		craftBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
		craftingInProgress = true
		CraftAnimal:FireServer(selectedRecipeName)
	end)
end

if spawnBtn then
	spawnBtn.MouseButton1Click:Connect(function()
		if not selectedRecipeName or not SpawnCraftedAnimal then return end
		spawnBtn.Visible = false
		SpawnCraftedAnimal:FireServer(selectedRecipeName)
	end)
end

if closeBtn then
	closeBtn.MouseButton1Click:Connect(function()
		gui.Enabled = false
	end)
end

if OpenCraftingMachineGui then
	OpenCraftingMachineGui.OnClientEvent:Connect(function()
		gui.Enabled = true
		if gui.Parent ~= playerGui then
			gui.Parent = playerGui
		end
		if RequestCraftingMachineData then
			RequestCraftingMachineData:FireServer()
		end
	end)
end

if SyncCraftingMachineData then
	SyncCraftingMachineData.OnClientEvent:Connect(function(globalData)
		currentGlobalData = globalData
		if globalData.PlayerBases and globalData.PlayerBases[player.UserId] then
			playerBase = {}
			for k, v in globalData.PlayerBases[player.UserId] do
				playerBase[k] = v
			end
		else
			playerBase = {}
		end
		timerEndTime = globalData.NextUpdateTime or (os.time() + 1800)
		craftTimers = globalData.CraftTimers or {}
		updateAnimalList()
		if selectedRecipeName and currentGlobalData.AvailableRecipes[selectedRecipeName] then
			updateReqList(currentGlobalData.AvailableRecipes[selectedRecipeName])
		else
			if reqListFrame then
				for _, child in reqListFrame:GetChildren() do
					if child:IsA("TextLabel") then
						child:Destroy()
					end
				end
			end
			if craftBtn then
				craftBtn.Text = "Craft"
				craftBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
				craftBtn.Active = false
			end
			if spawnBtn then
				spawnBtn.Visible = false
			end
			if rightLabel then
				rightLabel.Text = "Selected: None"
			end
		end
	end)
end

if CraftAnimal then
	CraftAnimal.OnClientEvent:Connect(function(result)
		craftingInProgress = false
		local msg = Instance.new("TextLabel")
		if result.success then
			msg.Text = "Crafted: " .. tostring(result.result)
			msg.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
		else
			msg.Text = "Failed: " .. tostring(result.result)
			msg.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
		end
		msg.Size = UDim2.new(0, 300, 0, 50)
		msg.Position = UDim2.new(0.5, -150, 0, 10)
		msg.TextColor3 = Color3.new(1,1,1)
		msg.Font = Enum.Font.GothamBold
		msg.TextSize = 28
		msg.Parent = gui
		local msgCorner = Instance.new("UICorner")
		msgCorner.CornerRadius = UDim.new(0, 12)
		msgCorner.Parent = msg
		task.delay(2, function()
			msg:Destroy()
		end)
		if RequestCraftingMachineData then
			RequestCraftingMachineData:FireServer()
		end
	end)
end

game:GetService("UserInputService").InputBegan:Connect(function(input, gp)
	if gui.Enabled and input.KeyCode == Enum.KeyCode.Escape then
		gui.Enabled = false
	end
end)

spawn(function()
	while true do
		if gui.Enabled then
			updateTimer()
		end
		task.wait(1)
	end
end)
