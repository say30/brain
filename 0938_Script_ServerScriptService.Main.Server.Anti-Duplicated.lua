--[[
  Extracted from: ServerScriptService.Main.Server.Anti-Duplicated
  Class: Script
  Source file: rickdev.rbxlx
]]

local Players = game:GetService("Players")

-- Tools that are allowed to have duplicates
local ExcludedTools = {
	["Trap"] = true,
	["Cake Trap"] = true,
}

-- Function to check and remove duplicate tools
local function RemoveDuplicateTools(player)
	local backpack = player:FindFirstChild("Backpack")
	if not backpack then return end

	local toolNames = {}

	for _, tool in ipairs(backpack:GetChildren()) do
		if tool:IsA("Tool") then
			if not ExcludedTools[tool.Name] then
				if toolNames[tool.Name] then
					-- Already exists, so remove this duplicate
					tool:Destroy()
				else
					toolNames[tool.Name] = true
				end
			end
		end
	end
end

-- Check every 0.01s for each player
task.spawn(function()
	while true do
		for _, player in ipairs(Players:GetPlayers()) do
			RemoveDuplicateTools(player)
		end
		task.wait(0.01)
	end
end)
