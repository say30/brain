--[[
  Extracted from: ServerScriptService.Services.RoadAnimalService.RoadPityDisplay
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local RoadPityDisplay = {}
RoadPityDisplay.__index = RoadPityDisplay

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

function RoadPityDisplay.new(Config)
	local self = setmetatable({}, RoadPityDisplay)

	self.Config = Config
	self.IsRunning = false
	self.Connection = nil
	self.PityTimers = {}

	self.RoadPanel = nil
	self.MainFrame = nil
	self.LegendaryLabel = nil
	self.MythicLabel = nil

	return self
end

function RoadPityDisplay:Initialize()
	local GameData = require(ReplicatedStorage.Datas.Game)
	local PittyList = GameData.RoadSpawn.PittyList

	for _, PittyData in ipairs(PittyList) do
		local RarityName = PittyData[1]
		local TimeInterval = PittyData[2]

		if RarityName == "Legendary" or RarityName == "Mythic" then
			self.PityTimers[RarityName] = {
				MaxTime = TimeInterval,
				CurrentTime = TimeInterval,
				LastUpdate = tick()
			}
		end
	end

	self:_setupUIReferences()

	if self.Config.DEBUG.PRINT_SPAWN_INFO then
		print("🎯 RoadPityDisplay initialized with timers:", self.PityTimers)
	end
end

function RoadPityDisplay:_setupUIReferences()
	self.RoadPanel = workspace:FindFirstChild("RoadPanel")
	if not self.RoadPanel then
		warn("RoadPanel not found in workspace!")
		return false
	end

	local SurfaceGui = self.RoadPanel:FindFirstChild("SurfaceGui")
	if not SurfaceGui then
		warn("SurfaceGui not found in RoadPanel!")
		return false
	end

	self.MainFrame = SurfaceGui:FindFirstChild("MainFrame")
	if not self.MainFrame then
		warn("MainFrame not found in SurfaceGui!")
		return false
	end

	self.LegendaryLabel = self.MainFrame:FindFirstChild("Legendary")
	self.MythicLabel = self.MainFrame:FindFirstChild("Mythic")

	if not (self.LegendaryLabel and self.MythicLabel) then
		warn("One or more pity labels not found in MainFrame!")
		return false
	end

	for _, Label in ipairs({self.LegendaryLabel, self.MythicLabel}) do
		Label.RichText = true
	end

	if self.Config.DEBUG.PRINT_SPAWN_INFO then
		print("🖥️ RoadPityDisplay UI references setup successfully")
	end

	return true
end

function RoadPityDisplay:Start()
	if self.IsRunning then
		return
	end

	if not self.RoadPanel then
		if not self:_setupUIReferences() then
			warn("Failed to setup UI references for RoadPityDisplay")
			return
		end
	end

	self.IsRunning = true

	self.Connection = RunService.Heartbeat:Connect(function()
		self:_updateCountdowns()
	end)

	self:_updateCountdowns()

	if self.Config.DEBUG.PRINT_SPAWN_INFO then
		print("🎯 RoadPityDisplay started")
	end
end

function RoadPityDisplay:Stop()
	if not self.IsRunning then
		return
	end

	self.IsRunning = false

	if self.Connection then
		self.Connection:Disconnect()
		self.Connection = nil
	end

	if self.Config.DEBUG.PRINT_SPAWN_INFO then
		print("🛑 RoadPityDisplay stopped")
	end
end

function RoadPityDisplay:_formatTime(Seconds)
	local Minutes = math.floor(Seconds / 60)
	local RemainingSeconds = Seconds % 60
	return string.format("%02d:%02d", Minutes, RemainingSeconds)
end

function RoadPityDisplay:_updateCountdowns()
	if not self.IsRunning or not self.MainFrame then
		return
	end

	local CurrentTick = tick()

	for RarityName, TimerData in pairs(self.PityTimers) do
		local DeltaTime = CurrentTick - TimerData.LastUpdate
		TimerData.LastUpdate = CurrentTick

		TimerData.CurrentTime = TimerData.CurrentTime - DeltaTime

		if TimerData.CurrentTime < 0 then
			TimerData.CurrentTime = 0
		end

		local TimeString = self:_formatTime(math.ceil(math.max(0, TimerData.CurrentTime)))

		if RarityName == "Legendary" and self.LegendaryLabel then
			if TimerData.CurrentTime <= 0 then
				self.LegendaryLabel.Text = "Guaranteed <font color=\"rgb(255,255,0)\">Legendary</font> in 0"
			else
				self.LegendaryLabel.Text = "Guaranteed <font color=\"rgb(255,255,0)\">Legendary</font> in " .. TimeString
			end
		elseif RarityName == "Mythic" and self.MythicLabel then
			if TimerData.CurrentTime <= 0 then
				self.MythicLabel.Text = "Guaranteed <font color=\"rgb(255,0,0)\">Mythic</font> in 0"
			else
				self.MythicLabel.Text = "Guaranteed <font color=\"rgb(255,0,0)\">Mythic</font> in " .. TimeString
			end
		end
	end
end

function RoadPityDisplay:GetTimeRemaining(RarityName)
	local TimerData = self.PityTimers[RarityName]
	if TimerData then
		return math.ceil(TimerData.CurrentTime)
	end
	return 0
end

function RoadPityDisplay:ResetTimer(RarityName)
	local TimerData = self.PityTimers[RarityName]
	if TimerData then
		TimerData.CurrentTime = TimerData.MaxTime
		TimerData.LastUpdate = tick()

		if self.Config.DEBUG.PRINT_SPAWN_INFO then
			print(("🔄 Manually reset pity timer for %s"):format(RarityName))
		end
	end
end

return RoadPityDisplay