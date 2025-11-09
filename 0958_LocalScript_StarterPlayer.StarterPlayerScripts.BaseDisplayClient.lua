--[[
  Location: StarterPlayerScripts.BaseDisplayClient
  Class: LocalScript
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local Net = require(ReplicatedStorage.Packages.Net)
local BaseConfig = require(ReplicatedStorage:WaitForChild("BaseConfig"))

local baseStateUpdateEvent = Net:RemoteEvent("BaseService/BaseStateUpdate")
local requestBaseState = Net:RemoteFunction("BaseService/RequestBaseState")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BaseStatusGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 20, 28)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 0
mainFrame.Size = UDim2.new(0, 340, 0, 460)
mainFrame.Position = UDim2.new(0, 24, 0, 120)
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.BackgroundTransparency = 1
titleLabel.Size = UDim2.new(1, -32, 0, 36)
titleLabel.Position = UDim2.new(0, 16, 0, 12)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 22
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Text = "Pods de base"
titleLabel.Parent = mainFrame

local summaryLabel = Instance.new("TextLabel")
summaryLabel.Name = "Summary"
summaryLabel.BackgroundTransparency = 1
summaryLabel.Size = UDim2.new(1, -32, 0, 22)
summaryLabel.Position = UDim2.new(0, 16, 0, 52)
summaryLabel.Font = Enum.Font.Gotham
summaryLabel.TextSize = 16
summaryLabel.TextColor3 = Color3.fromRGB(210, 215, 225)
summaryLabel.TextXAlignment = Enum.TextXAlignment.Left
summaryLabel.Text = "Chargement des pods..."
summaryLabel.Parent = mainFrame

local podsContainer = Instance.new("ScrollingFrame")
podsContainer.Name = "PodsContainer"
podsContainer.BackgroundTransparency = 1
podsContainer.BorderSizePixel = 0
podsContainer.ScrollBarThickness = 6
podsContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
podsContainer.CanvasSize = UDim2.new()
podsContainer.Size = UDim2.new(1, -32, 1, -132)
podsContainer.Position = UDim2.new(0, 16, 0, 86)
podsContainer.Parent = mainFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 6)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = podsContainer

local tooltip = Instance.new("TextLabel")
tooltip.Name = "Tooltip"
tooltip.BackgroundColor3 = Color3.fromRGB(28, 30, 40)
tooltip.BackgroundTransparency = 0.1
tooltip.BorderSizePixel = 0
tooltip.Visible = false
tooltip.ZIndex = 5
tooltip.TextColor3 = Color3.new(1, 1, 1)
tooltip.TextSize = 16
tooltip.TextWrapped = true
tooltip.TextXAlignment = Enum.TextXAlignment.Left
tooltip.TextYAlignment = Enum.TextYAlignment.Top
tooltip.Size = UDim2.new(0, 220, 0, 60)
tooltip.Position = UDim2.new(0, 0, 0, 0)
tooltip.Font = Enum.Font.Gotham
tooltip.Parent = mainFrame

local tooltipCorner = Instance.new("UICorner")
tooltipCorner.CornerRadius = UDim.new(0, 8)
tooltipCorner.Parent = tooltip

local function hideTooltip()
        tooltip.Visible = false
end

tooltip.MouseLeave:Connect(hideTooltip)

local function formatAssignment(assignment)
        if assignment == nil then
                return "Libre"
        end

        local assignmentType = typeof(assignment)
        if assignmentType == "string" or assignmentType == "number" or assignmentType == "boolean" then
                return tostring(assignment)
        end

        if assignmentType == "table" then
                if assignment.Name then
                        return tostring(assignment.Name)
                end

                local preview = {}
                for key, value in pairs(assignment) do
                        table.insert(preview, string.format("%s: %s", key, tostring(value)))
                        if #preview >= 2 then
                                break
                        end
                end

                if #preview > 0 then
                        return table.concat(preview, "  ")
                end
        end

        return "Occupé"
end

local function showTooltipFor(button, text)
        tooltip.Text = text
        tooltip.Visible = true
        local relative = mainFrame.AbsolutePosition
        local buttonPos = button.AbsolutePosition
        local offsetX = (buttonPos.X - relative.X) + button.AbsoluteSize.X + 12
        local offsetY = buttonPos.Y - relative.Y - 12
        tooltip.Position = UDim2.fromOffset(offsetX, offsetY)
end

local function createLockIcon(parent, podIndex)
        local lockButton = Instance.new("ImageButton")
        lockButton.Name = "LockIcon"
        lockButton.AutoButtonColor = false
        lockButton.BackgroundTransparency = 1
        lockButton.Size = UDim2.new(0, 24, 0, 24)
        lockButton.Image = "rbxassetid://6031071053"
        lockButton.ImageColor3 = Color3.fromRGB(255, 204, 92)
        lockButton.Parent = parent

        local costText = BaseConfig.getFormattedCost(podIndex)
        lockButton.MouseEnter:Connect(function()
                showTooltipFor(lockButton, string.format("Coût d'ouverture : %s", costText))
        end)

        lockButton.MouseLeave:Connect(hideTooltip)

        return lockButton
end

local function createPodRow(podIndex, isUnlocked, isFuture, assignment)
        local row = Instance.new("Frame")
        row.Name = string.format("Pod_%02d", podIndex)
        row.BackgroundTransparency = 0.35
        row.BackgroundColor3 = isUnlocked and Color3.fromRGB(44, 120, 68) or Color3.fromRGB(72, 76, 88)
        row.Size = UDim2.new(1, 0, 0, 40)
        row.Parent = podsContainer

        local cornerInstance = Instance.new("UICorner")
        cornerInstance.CornerRadius = UDim.new(0, 8)
        cornerInstance.Parent = row

        local nameLabel = Instance.new("TextLabel")
        nameLabel.BackgroundTransparency = 1
        nameLabel.Size = UDim2.new(0.4, 0, 1, 0)
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextSize = 16
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.Text = string.format("Pod %02d", podIndex)
        nameLabel.TextColor3 = Color3.new(1, 1, 1)
        nameLabel.Parent = row

        local statusLabel = Instance.new("TextLabel")
        statusLabel.Name = "Status"
        statusLabel.BackgroundTransparency = 1
        statusLabel.Position = UDim2.new(0.4, 0, 0, 0)
        statusLabel.Size = UDim2.new(0.6, -36, 1, 0)
        statusLabel.Font = Enum.Font.Gotham
        statusLabel.TextSize = 15
        statusLabel.TextXAlignment = Enum.TextXAlignment.Left
        statusLabel.TextWrapped = true
        statusLabel.TextColor3 = isUnlocked and Color3.fromRGB(222, 255, 231) or Color3.fromRGB(235, 214, 160)
        statusLabel.Parent = row

        if isFuture then
                statusLabel.Text = "Verrouillé (mise à jour future)"
                createLockIcon(row, podIndex)
        elseif isUnlocked then
                statusLabel.TextColor3 = Color3.fromRGB(222, 255, 231)
                statusLabel.Text = formatAssignment(assignment)
        else
                statusLabel.Text = BaseConfig.getFormattedCost(podIndex)
                createLockIcon(row, podIndex)
        end

        return row
end

local function renderBase(baseState)
        for _, child in ipairs(podsContainer:GetChildren()) do
                if child:IsA("Frame") then
                        child:Destroy()
                end
        end

        local unlockedPods = baseState and baseState.UnlockedPods or BaseConfig.InitialUnlockedPods
        local assignedPods = baseState and baseState.AssignedPods or {}
        summaryLabel.Text = string.format("Pods débloqués : %d / %d", unlockedPods, BaseConfig.MaxUnlockablePod)

        for podIndex = 1, BaseConfig.MaximumPods do
                local isFuture = BaseConfig.isFuturePod(podIndex)
                local isUnlocked = not isFuture and podIndex <= unlockedPods
                local assignment = assignedPods[podIndex]
                createPodRow(podIndex, isUnlocked, isFuture, assignment)
        end
end

baseStateUpdateEvent.OnClientEvent:Connect(function(state)
        if typeof(state) ~= "table" then
                return
        end
        renderBase(state)
end)

local success, initialState = pcall(function()
        return requestBaseState:InvokeServer()
end)

if success and typeof(initialState) == "table" then
        renderBase(initialState)
else
        summaryLabel.Text = "Impossible de charger la base."
end

RunService.RenderStepped:Connect(function()
        if not screenGui.Enabled then
                hideTooltip()
        end
end)
