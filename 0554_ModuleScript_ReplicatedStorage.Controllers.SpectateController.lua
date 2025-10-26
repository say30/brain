--[[
  Extracted from: ReplicatedStorage.Controllers.SpectateController
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Controllers = ReplicatedStorage:WaitForChild("Controllers")
local Classes = ReplicatedStorage:WaitForChild("Classes")
local Camera = workspace.CurrentCamera

local Net = require(ReplicatedStorage.Packages.Net)
local InterfaceController = require(Controllers.InterfaceController)
local AnimatedButton = require(Classes.AnimatedButton)
local NotificationController = require(Controllers.NotificationController)
local RemoteEvent = Net:RemoteEvent("ShopService/Purchase")

local SpectateUI = Player:WaitForChild("PlayerGui"):WaitForChild("Main"):WaitForChild("Spectate")
local TrollUI = Player:WaitForChild("PlayerGui"):WaitForChild("Main"):WaitForChild("Troll")
local Playerlist = {}
local currIndex = 1

local db = false

local currentTarget = nil

local notifyIfOpen

local function UpdatePlayers()
	Playerlist = {}
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= Player then
			table.insert(Playerlist, plr)
		end
	end
	if currIndex > #Playerlist then
		currIndex = 1
	end

	if #Playerlist == 0 then
		currentTarget = nil
		Camera.CameraSubject = Player.Character:FindFirstChild("Humanoid") or Player.Character:FindFirstChildWhichIsA("BasePart")
		notifyIfOpen("No other players to spectate!")
	end
end

local function UpdateCamera(player)
	SpectateUI.Frame.PlayerName.Text = player.Name
	Camera.CameraSubject = player.Character:FindFirstChild("Humanoid") or player.Character:FindFirstChildWhichIsA("BasePart")
	currentTarget = player
end

local TrollProductIds = {
	["Kill"] = 3341181646,
	["Fling"] = 3341181173,
	["Goto"] = 3341182175,
	["ResetData"] = 3341180637,
}

notifyIfOpen = function(msg)
	local ui = InterfaceController:Get("Spectate")
	if ui and ui:IsOpened() then
		NotificationController:Error(msg)
	end
end

local SpectateController = {}

SpectateController.Start = function()
	InterfaceController:Register("Spectate", SpectateUI, "TopSpectate");
	InterfaceController:Register("Troll", TrollUI, "TopSpectate");

	local spectateUIInterface = InterfaceController:Get("Spectate")
	local trollUIInterface = InterfaceController:Get("Troll")

	local function resetCameraToSelf()
		if Player.Character then
			Camera.CameraSubject = Player.Character:FindFirstChild("Humanoid") or Player.Character:FindFirstChildWhichIsA("BasePart")
		end
	end

	if spectateUIInterface then
		if spectateUIInterface:IsOpened() then
			spectateUIInterface:Close()
		end
		spectateUIInterface.OnClose:Connect(function()
			resetCameraToSelf()
			currentTarget = nil
		end)
	end

	if trollUIInterface and trollUIInterface:IsOpened() then
		trollUIInterface:Close()
	end

	UpdatePlayers()
	Players.PlayerAdded:Connect(UpdatePlayers)
	Players.PlayerRemoving:Connect(UpdatePlayers)

	local AnimatedButton1 = AnimatedButton.new(SpectateUI.Next)
	AnimatedButton1:Animate()

	AnimatedButton1.OnActivated:Connect(function()
		if not db then
			db = true
			currIndex += 1
			if currIndex > #Playerlist then
				currIndex = 1
			end

			local selectedPlayer = Playerlist[currIndex]
			warn(selectedPlayer)
			if selectedPlayer then
				UpdateCamera(selectedPlayer)
			end

			if #Playerlist == 0 then
				notifyIfOpen("No other players to spectate!")
				db = false
				return
			end

			db = false
		end
	end)

	local AnimatedButton2 = AnimatedButton.new(SpectateUI.Last)
	AnimatedButton2:Animate()

	AnimatedButton2.OnActivated:Connect(function()
		if not db then
			db = true
			currIndex -= 1
			if currIndex < 1 then
				currIndex = #Playerlist
			end

			local selectedPlayer = Playerlist[currIndex]
			warn(selectedPlayer)
			if selectedPlayer then
				UpdateCamera(selectedPlayer)
			end

			if #Playerlist == 0 then
				notifyIfOpen("No other players to spectate!")
				db = false
				return
			end

			db = false
		end
	end)
	local AnimatedButton3 = AnimatedButton.new(TrollUI.Fling)
	local AnimatedButton4 = AnimatedButton.new(TrollUI.Kill)
	local AnimatedButton5 = AnimatedButton.new(TrollUI.GoTO)

	local ResetButton
	for _, n in ipairs({"ResetData", "Reset", "ResetButton"}) do
		local candidate = TrollUI:FindFirstChild(n)
		if candidate then
			ResetButton = candidate
			break
		end
	end

	if not ResetButton then
		warn("[SpectateController] Reset button not found in TrollUI. Expected an object named 'ResetData', 'Reset', or 'ResetButton'.")
	end

	local AnimatedButton6
	if ResetButton then
		AnimatedButton6 = AnimatedButton.new(ResetButton)
		AnimatedButton6:Animate()
	end

	AnimatedButton3:Animate()
	AnimatedButton4:Animate()
	AnimatedButton5:Animate()

	AnimatedButton3.OnActivated:Connect(function()
		if db then return end
		if not currentTarget or not currentTarget.Parent then
			notifyIfOpen("No valid target selected!")
			return
		end
		db = true
		local productId = TrollProductIds.Fling
		RemoteEvent:FireServer(productId, currentTarget.UserId)
		NotificationController:Notify(string.format("<font color=\"#FFA500\">Prompting purchase: Fling %s</font>", currentTarget.Name), 3)
		task.delay(2, function()
			db = false
		end)
	end)
	AnimatedButton4.OnActivated:Connect(function()
		if db then return end
		if not currentTarget or not currentTarget.Parent then
			notifyIfOpen("No valid target selected!")
			return
		end
		db = true
		local productId = TrollProductIds.Kill
		RemoteEvent:FireServer(productId, currentTarget.UserId)
		NotificationController:Notify(string.format("<font color=\"#FFA500\">Prompting purchase: Kill %s</font>", currentTarget.Name), 3)
		task.delay(2, function()
			db = false
		end)
	end)

	AnimatedButton5.OnActivated:Connect(function()
		if db then return end
		if not currentTarget or not currentTarget.Parent then
			notifyIfOpen("No valid target selected!")
			return
		end
		db = true
		local productId = TrollProductIds.Goto
		RemoteEvent:FireServer(productId, currentTarget.UserId)
		NotificationController:Notify(string.format("<font color=\"#FFA500\">Prompting purchase: Goto %s</font>", currentTarget.Name), 3)
		task.delay(2, function()
			db = false
		end)
	end)

	if AnimatedButton6 then
		AnimatedButton6.OnActivated:Connect(function()
			if db then return end
			if not currentTarget or not currentTarget.Parent then
				notifyIfOpen("No valid target selected!")
				return
			end
			db = true
			local productId = TrollProductIds.ResetData
			RemoteEvent:FireServer(productId, currentTarget.UserId)
			NotificationController:Notify(string.format("<font color=\"#FFA500\">Prompting purchase: Reset data of %s</font>", currentTarget.Name), 3)
			task.delay(2, function()
				db = false
			end)
		end)
	end
end

return SpectateController
