--[[
  Extracted from: StarterPlayer.StarterCharacterScripts.CraftingMachineGuiClient.CraftingMachineGuiDataClient
  Class: LocalScript
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local SyncCraftingMachineData = ReplicatedStorage:WaitForChild("SyncCraftingMachineData")

SyncCraftingMachineData.OnClientEvent:Connect(function(requiredAnimals)
    local gui = Player.PlayerGui:FindFirstChild("CraftingMachineGui")
    if gui and gui:FindFirstChild("CraftsFrame") then
        local craftsFrame = gui.CraftsFrame
        for i = 1, #craftsFrame:GetChildren() do
            local child = craftsFrame:GetChildren()[i]
            if child:IsA("Frame") then
                child:Destroy()
            end
        end
        for i = 1, #requiredAnimals do
            local animalName = requiredAnimals[i]
            local craftFrame = Instance.new("Frame")
            craftFrame.Size = UDim2.new(1, 0, 0, 40)
            craftFrame.BackgroundTransparency = 1
            craftFrame.Name = "Craft_" .. animalName
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 0.5
            label.Text = animalName
            label.TextScaled = true
            label.Parent = craftFrame
            craftFrame.Parent = craftsFrame
        end
    end
end)

