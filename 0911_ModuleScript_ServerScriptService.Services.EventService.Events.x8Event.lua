--[[
  Extracted from: ServerScriptService.Services.EventService.Events.x8Event
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local Workspace = game:GetService("Workspace")

local x8Event = {}
x8Event.__index = x8Event

function x8Event.new(eventService)
	local self = setmetatable({}, x8Event)
	self._eventService = eventService
	self._isActive = false
	self._x8EventFolder = nil
	self._sounds = {}
	self._textLabels = {}
	return self
end

function x8Event:Start(eventEntry)
	if self._isActive then
		return
	end
	self._isActive = true
	print("[x8Event] Starting x8 event")

	-- Play start sound
	local startSound = Instance.new("Sound")
	startSound.SoundId = "rbxassetid://1234567890" -- Placeholder sound ID
	startSound.Parent = Workspace
	startSound:Play()
	print("[x8Event] Playing start sound: rbxassetid://1234567890")
	self._sounds[#self._sounds + 1] = startSound

	-- Spawn the x8Event folder in the Workspace
	local x8EventFolder = ReplicatedStorage:FindFirstChild("x8Event")
	if x8EventFolder then
		self._x8EventFolder = x8EventFolder:Clone()
		self._x8EventFolder.Parent = Workspace
		print("[x8Event] Spawned x8Event folder in Workspace")

		-- If x8Event contains a model with a PrimaryPart, position it
		local primaryModel = self._x8EventFolder:FindFirstChildWhichIsA("Model")
		if primaryModel and primaryModel.PrimaryPart then
			primaryModel:SetPrimaryPartCFrame(CFrame.new(Vector3.new(0, 10, 0))) -- Adjust position as needed
			print("[x8Event] Positioned x8Event model at (0, 10, 0)")
		end

		-- Enable a particle effect (e.g., on a part named "Effect")
		local effectPart = self._x8EventFolder:FindFirstChild("Effect")
		if effectPart then
			local attachment = effectPart:FindFirstChildWhichIsA("Attachment")
			if attachment then
				local particle = attachment:FindFirstChild("x8Particle")
				if particle and particle:IsA("ParticleEmitter") then
					particle.Enabled = true
					print("[x8Event] Enabled x8Particle effect")
				else
					warn("[x8Event] ParticleEmitter 'x8Particle' not found in Effect.Attachment")
				end
			else
				warn("[x8Event] Attachment not found in x8Event.Effect")
			end
		else
			warn("[x8Event] Effect part not found in x8Event folder")
		end
	else
		warn("[x8Event] x8Event folder not found in ReplicatedStorage")
	end

	-- Hi 
	for _, player in pairs(Players:GetPlayers()) do
		local playerGui = player:FindFirstChild("PlayerGui")
		if playerGui then
			local screenGui = Instance.new("ScreenGui")
			screenGui.Parent = playerGui
			screenGui.IgnoreGuiInset = true

			local textLabel = Instance.new("TextLabel")
			textLabel.Size = UDim2.new(0, 400, 0, 100)
			textLabel.Position = UDim2.new(0.5, -200, 1, -120) -- Center bottom
			textLabel.AnchorPoint = Vector2.new(0.5, 1)
			textLabel.Text = "SMUG ACTIVE X8"
			textLabel.Font = Enum.Font.SourceSansPro
			textLabel.TextSize = 48
			textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			textLabel.BackgroundTransparency = 1
			textLabel.TextStrokeTransparency = 0.2
			textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
			textLabel.Parent = screenGui

			-- Animate text moving slightly upward
			local tweenInfo = TweenInfo.new(
				1, -- Duration
				Enum.EasingStyle.Quad,
				Enum.EasingDirection.Out
			)
			local tween = TweenService:Create(
				textLabel,
				tweenInfo,
				{ Position = UDim2.new(0.5, -200, 1, -150) } -- Move up slightly
			)
			tween:Play()

			self._textLabels[player] = screenGui
			print("[x8Event] Created SMUG ACTIVE X8 text label for player: " .. player.Name)
		end
	end

	-- Clean up after 20 seconds
	task.delay(20, function()
		if self._isActive then
			self:Stop(eventEntry)
			print("[x8Event] Called Stop for cleanup")
		end
	end)

	-- Notify clients of the event
	local notificationEvent = ReplicatedStorage.Packages.Net:RemoteEvent("NotificationService/Notify")
	for _, player in pairs(Players:GetPlayers()) do
		notificationEvent:FireClient(
			player,
			"✨ x8 Event Started! Experience the x8 magic!",
			5
		)
	end
end

function x8Event:Stop(eventEntry)
	if not self._isActive then
		warn("[x8Event] Stop called but event is not active")
		return
	end
	self._isActive = false
	print("[x8Event] Stopping x8 event")

	-- Clean up the x8Event folder
	if self._x8EventFolder and self._x8EventFolder.Parent then
		self._x8EventFolder:Destroy()
		self._x8EventFolder = nil
		print("[x8Event] Destroyed x8Event folder")
	else
		warn("[x8Event] x8Event folder already nil or not in Workspace")
	end

	-- Clean up sounds
	for _, sound in pairs(self._sounds) do
		if sound and sound.Parent then
			sound:Stop()
			sound:Destroy()
			print("[x8Event] Destroyed sound: " .. sound.SoundId)
		end
	end
	self._sounds = {}

	-- Clean up text labels
	for player, screenGui in pairs(self._textLabels) do
		if screenGui and screenGui.Parent then
			screenGui:Destroy()
			print("[x8Event] Destroyed text label for player: " .. player.Name)
		end
	end
	self._textLabels = {}

	-- Notify clients of the event end
	local notificationEvent = ReplicatedStorage.Packages.Net:RemoteEvent("NotificationService/Notify")
	for _, player in pairs(Players:GetPlayers()) do
		notificationEvent:FireClient(
			player,
			"✨ x8 Event Ended!",
			3
		)
	end
end

return x8Event