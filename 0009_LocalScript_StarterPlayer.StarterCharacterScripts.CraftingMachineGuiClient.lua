--[[
  Extracted from: StarterPlayer.StarterCharacterScripts.CraftingMachineGuiClient
  Class: LocalScript
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local OpenCraftingMachineGui = ReplicatedStorage:WaitForChild("c")

OpenCraftingMachineGui.OnClientEvent:Connect(function()
    local gui = Player.PlayerGui:FindFirstChild("CraftingMachineGui")
    if gui then
        gui.Enabled = true
    end
end)

