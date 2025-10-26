--[[
  Extracted from: ReplicatedStorage.Loader
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")

local Modules = {}
local IsServer = RunService:IsServer()
local Container = IsServer and ServerScriptService.Services or ReplicatedStorage:WaitForChild("Controllers")
local RequiredModules = 0
local LoadedModules = 0

task.spawn(require, ReplicatedStorage.Packages.FFlags)
task.spawn(require, ReplicatedStorage.Components.Npc)

if IsServer then
	local Folder = Instance.new("Folder")
	Folder.Name = "ReplicatedGui"
	Folder.Parent = ReplicatedStorage
	for _, Child in StarterGui:GetChildren() do
		Child.Parent = Folder
	end
else
	local PlayerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
	for _, Child in ReplicatedStorage:WaitForChild("ReplicatedGui"):GetChildren() do
		Child.Parent = PlayerGui
	end
end

task.spawn(require, ReplicatedStorage.Packages.FFlags)

for _, Module in Container:GetChildren() do
	if Module:IsA("ModuleScript") then
		local Success, Result = pcall(require, Module)
		if not Success then
			warn(Result)
		else
			Modules[Module.Name] = Result
			RequiredModules += 1
		end
	end
end

LoadedModules = 0
for _, Module in Modules do
	task.spawn(function()
		if Module.Load then
			Module:Load()
		end
		LoadedModules += 1
	end)
end
while RequiredModules ~= LoadedModules do
	task.wait()
end

LoadedModules = 0
for _, Module in Modules do
	task.spawn(function()
		if Module.Start then
			Module:Start()
		end
		LoadedModules += 1
	end)
end
while RequiredModules ~= LoadedModules do
	task.wait()
end

LoadedModules = 0
for _, Module in Modules do
	task.spawn(function()
		if Module.PosStart then
			Module:PosStart()
		end
		LoadedModules += 1
	end)
end

local Components = IsServer and ServerScriptService.Components or ReplicatedStorage:WaitForChild("Components")
for _, Component in Components:GetChildren() do
	if Component:IsA("ModuleScript") then
		require(Component)
	end
end

return Modules