--[[
  Extracted from: ServerScriptService.Services.EventService.Events.x6Event
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local Workspace = game:GetService("Workspace")

local x6Event = {}
x6Event.__index = x6Event

function x6Event.new(eventService)
	local self = setmetatable({}, x6Event)
	self._eventService = eventService
	self._isActive = false
	self._x6EventFolder = nil
	self._sounds = {}
	return self
end

function x6Event:Start(eventEntry)
	if self._isActive then
		return
	end
	self._isActive = true
	print("[x6Event] Starting x6 event")

	-- Play start sound
	local startSound = Instance.new("Sound")
	startSound.SoundId = "rbxassetid://1234567890" -- Placeholder sound ID
	startSound.Parent = Workspace
	startSound:Play()
	print("[x6Event] Playing start sound: rbxassetid://1234567890")
	self._sounds[#self._sounds + 1] = startSound

	-- Spawn the x6Event folder in the Workspace
	local x6EventFolder = ReplicatedStorage:FindFirstChild("x6Event")
	if x6EventFolder then
		self._x6EventFolder = x6EventFolder:Clone()
		self._x6EventFolder.Parent = Workspace
		print("[x6Event] Spawned x6Event folder in Workspace")

		-- If x6Event contains a model with a PrimaryPart, position it
		local primaryModel = self._x6EventFolder:FindFirstChildWhichIsA("Model")
		if primaryModel and primaryModel.PrimaryPart then
			primaryModel:SetPrimaryPartCFrame(CFrame.new(Vector3.new(0, 10, 0))) -- Adjust position as needed
			print("[x6Event] Positioned x6Event model at (0, 10, 0)")
		end

		-- Enable a particle effect (e.g., on a part named "Effect")
		local effectPart = self._x6EventFolder:FindFirstChild("Effect")
		if effectPart then
			local attachment = effectPart:FindFirstChildWhichIsA("Attachment")
			if attachment then
				local particle = attachment:FindFirstChild("x6Particle")
				if particle and particle:IsA("ParticleEmitter") then
					particle.Enabled = true
					print("[x6Event] Enabled x6Particle effect")
				else
					warn("[x6Event] ParticleEmitter 'x6Particle' not found in Effect.Attachment")
				end
			else
				warn("[x6Event] Attachment not found in x6Event.Effect")
			end
		else
			warn("[x6Event] Effect part not found in x6Event folder")
		end
	else
		warn("[x6Event] x6Event folder not found in ReplicatedStorage")
	end

	-- Clean up after 20 seconds
	task.delay(20, function()
		if self._isActive then
			self:Stop(eventEntry)
			print("[x6Event] Called Stop for cleanup")
		end
	end)

	-- Notify clients of the event
	local notificationEvent = ReplicatedStorage.Packages.Net:RemoteEvent("NotificationService/Notify")
	for _, player in pairs(Players:GetPlayers()) do
		notificationEvent:FireClient(
			player,
			"✨ x6 Event Started! Experience the x6 magic!",
			5
		)
	end
end

function x6Event:Stop(eventEntry)
	if not self._isActive then
		warn("[x6Event] Stop called but event is not active")
		return
	end
	self._isActive = false
	print("[x6Event] Stopping x6 event")

	-- Clean up the x6Event folder
	if self._x6EventFolder and self._x6EventFolder.Parent then
		self._x6EventFolder:Destroy()
		self._x6EventFolder = nil
		print("[x6Event] Destroyed x6Event folder")
	else
		warn("[x6Event] x6Event folder already nil or not in Workspace")
	end

	-- Clean up sounds
	for _, sound in pairs(self._sounds) do
		if sound and sound.Parent then
			sound:Stop()
			sound:Destroy()
			print("[x6Event] Destroyed sound: " .. sound.SoundId)
		end
	end
	self._sounds = {}

	-- Notify clients of the event end
	local notificationEvent = ReplicatedStorage.Packages.Net:RemoteEvent("NotificationService/Notify")
	for _, player in pairs(Players:GetPlayers()) do
		notificationEvent:FireClient(
			player,
			"✨ x6 Event Ended!",
			3
		)
	end
end

return x6Event