--[[
  Extracted from: ServerScriptService.Services.EventService.Events.x4Event
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local Workspace = game:GetService("Workspace")

local x4Event = {}
x4Event.__index = x4Event

function x4Event.new(eventService)
	local self = setmetatable({}, x4Event)
	self._eventService = eventService
	self._isActive = false
	self._x4EventFolder = nil
	self._sounds = {}
	return self
end

function x4Event:Start(eventEntry)
	if self._isActive then
		return
	end
	self._isActive = true
	print("[x4Event] Starting x4 event")

	-- Play start sound
	local startSound = Instance.new("Sound")
	startSound.SoundId = "rbxassetid://1234567890" -- Placeholder sound ID
	startSound.Parent = Workspace
	startSound:Play()
	print("[x4Event] Playing start sound: rbxassetid://1234567890")
	self._sounds[#self._sounds + 1] = startSound

	-- Spawn the x4Event folder in the Workspace
	local x4EventFolder = ReplicatedStorage:FindFirstChild("x4Event")
	if x4EventFolder then
		self._x4EventFolder = x8EventFolder:Clone()
		self._x4EventFolder.Parent = Workspace
		print("[x4Event] Spawned x4Event folder in Workspace")

		-- If x4Event contains a model with a PrimaryPart, position it
		local primaryModel = self._x4EventFolder:FindFirstChildWhichIsA("Model")
		if primaryModel and primaryModel.PrimaryPart then
			primaryModel:SetPrimaryPartCFrame(CFrame.new(Vector3.new(0, 10, 0))) -- Adjust position as needed
			print("[x4Event] Positioned x4Event model at (0, 10, 0)")
		end

		-- Enable a particle effect (e.g., on a part named "Effect")
		local effectPart = self._x4EventFolder:FindFirstChild("Effect")
		if effectPart then
			local attachment = effectPart:FindFirstChildWhichIsA("Attachment")
			if attachment then
				local particle = attachment:FindFirstChild("x4Particle")
				if particle and particle:IsA("ParticleEmitter") then
					particle.Enabled = true
					print("[x4Event] Enabled x4Particle effect")
				else
					warn("[x4Event] ParticleEmitter 'x4Particle' not found in Effect.Attachment")
				end
			else
				warn("[x4Event] Attachment not found in x4Event.Effect")
			end
		else
			warn("[x4Event] Effect part not found in x4Event folder")
		end
	else
		warn("[x4Event] x4Event folder not found in ReplicatedStorage")
	end

	-- Clean up after 20 seconds
	task.delay(20, function()
		if self._isActive then
			self:Stop(eventEntry)
			print("[x4Event] Called Stop for cleanup")
		end
	end)

	-- Notify clients of the event
	local notificationEvent = ReplicatedStorage.Packages.Net:RemoteEvent("NotificationService/Notify")
	for _, player in pairs(Players:GetPlayers()) do
		notificationEvent:FireClient(
			player,
			"✨ x4 Event Started! Experience the x4 magic!",
			5
		)
	end
end

function x4Event:Stop(eventEntry)
	if not self._isActive then
		warn("[x4Event] Stop called but event is not active")
		return
	end
	self._isActive = false
	print("[x4Event] Stopping x4 event")

	-- Clean up the x4Event folder
	if self._x4EventFolder and self._x4EventFolder.Parent then
		self._x4EventFolder:Destroy()
		self._x4EventFolder = nil
		print("[x4Event] Destroyed x4Event folder")
	else
		warn("[x4Event] x4Event folder already nil or not in Workspace")
	end

	-- Clean up sounds
	for _, sound in pairs(self._sounds) do
		if sound and sound.Parent then
			sound:Stop()
			sound:Destroy()
			print("[x4Event] Destroyed sound: " .. sound.SoundId)
		end
	end
	self._sounds = {}

	-- Notify clients of the event end
	local notificationEvent = ReplicatedStorage.Packages.Net:RemoteEvent("NotificationService/Notify")
	for _, player in pairs(Players:GetPlayers()) do
		notificationEvent:FireClient(
			player,
			"✨ x4 Event Ended!",
			3
		)
	end
end

return x4Event
