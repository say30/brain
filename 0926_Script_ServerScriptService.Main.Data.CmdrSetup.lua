--[[
  Extracted from: ServerScriptService.Main.Data.CmdrSetup
  Class: Script
  Source file: rickdev.rbxlx
]]

local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local CmdrService = require(ServerScriptService.Services.CmdrService)

local CONFIG = {
	COMMAND_GROUPS = {"DefaultAdmin", "DefaultUtil", "DefaultDebug", "CustomAdmin"},
	WELCOME_MESSAGE = "🎯 Admin access granted! Press F2 and type 'help' to get started.",
	WELCOME_COLOR = Color3.fromRGB(85, 255, 127),
	STARTUP_DELAY = 1
}

local cmdrService: CmdrService.CmdrServiceType

local function sendWelcomeMessage(player: Player)
	task.spawn(function()
		task.wait(2)

		if not player.Parent then return end

		local success, _ = pcall(function()
			local cmdr = cmdrService:GetCmdr()
			if cmdr and cmdr.RemoteEvent then
				cmdr.RemoteEvent:FireClient(player, "AddLine", CONFIG.WELCOME_MESSAGE, CONFIG.WELCOME_COLOR)
			end
		end)
	end)
end

local function onPlayerJoined(player: Player)
	local isAuthorized = cmdrService:IsAuthorized(player)

	if isAuthorized then
		sendWelcomeMessage(player)
	end
end

local function setupPlayerEvents()
	Players.PlayerAdded:Connect(onPlayerJoined)

	for _, player in ipairs(Players:GetPlayers()) do
		task.spawn(onPlayerJoined, player)
	end
end

local function waitForRequiredDependencies()
	local function waitFor(childParent, childName)
		local obj = childParent:WaitForChild(childName, 30)
		if not obj then
			return false
		end
		return true
	end

	if not waitFor(ReplicatedStorage, "Datas") then return false end
	if not waitFor(ReplicatedStorage.Datas, "Animals") then return false end
	if not waitFor(ReplicatedStorage.Datas, "Mutations") then return false end

	if not waitFor(ServerScriptService.Services, "DataManagment") then return false end

	return true
end

local function initializeCmdr()
	if not waitForRequiredDependencies() then
		return false
	end

	cmdrService = CmdrService.new()
	cmdrService:Initialize()
	cmdrService:SetWebhookUrl("")
	cmdrService:RegisterDefaultCommands(CONFIG.COMMAND_GROUPS)
	cmdrService:RegisterCustomTypes()
	cmdrService:RegisterCustomCommands()

	return true
end

local function main()
	task.wait(CONFIG.STARTUP_DELAY)

	if not initializeCmdr() then
	end

	setupPlayerEvents()

	_G.CmdrService = cmdrService
end

main()