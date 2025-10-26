--[[
  Extracted from: ServerScriptService.Services.EventService.Events.Phase 2: Galaxy Introduction
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Task = task

local Module = {}
Module.__index = Module

local DELAY_SECONDS = 47

function Module.new(eventService)
	local self = setmetatable({}, Module)
	self._eventService = eventService
	self._active = false
	self._storedPlot = nil
	self._rocketShip = nil
	self._spawnThread = nil
	return self
end

function Module:_debug(msg)
	print(("[DEBUG][GalaxyPhase] %s"):format(msg))
end

function Module:_getRocketTemplate()
	return script.Rocketship
end

function Module:_scheduleSpawn()
	if self._spawnThread then
		self:_debug("Spawn thread already scheduled; skipping")
		return
	end

	self:_debug(("Scheduling RocketShip spawn in %d seconds..."):format(DELAY_SECONDS))
	self._spawnThread = Task.delay(DELAY_SECONDS, function()
		self:_debug("Delay fired; checking active state...")
		self._spawnThread = nil
		if not self._active then
			self:_debug("Module inactive at delay fire; skipping spawn")
			return
		end

		-- Avoid double-spawn if already present
		if Workspace:FindFirstChild("RocketShip") then
			self:_debug("RocketShip already in workspace; skipping clone")
			return
		end

		local rocketTemplate = self:_getRocketTemplate()
		if not rocketTemplate then
			self:_debug("Rocket template not found; spawn skipped")
			return
		end

		local ok, cloneOrErr = pcall(function()
			local clone = rocketTemplate:Clone()
			clone.Name = "RocketShip"
			clone.Parent = Workspace
			self._rocketShip = clone
			return clone
		end)

		if ok and cloneOrErr then
			self:_debug(("RocketShip cloned to workspace (%s)"):format(cloneOrErr:GetFullName()))
		else
			self:_debug(("Error cloning RocketShip: %s"):format(tostring(cloneOrErr)))
		end
	end)
end

function Module:Start()
	if self._active then
		self:_debug("Start called but already active; ignoring")
		return
	end
	self._active = true
	self:_debug("Start called; module is now active")

	local plot = Workspace.Plots and Workspace.Plots:FindFirstChild("2")
	if plot then
		self._storedPlot = plot
		self:_debug(("Found plot '%s'; moving to ReplicatedStorage"):format(plot.Name))
		plot.Parent = ReplicatedStorage
	else
		self:_debug("Plot '2' not found under Workspace.Plots")
		self._storedPlot = nil
	end

	self:_scheduleSpawn()
end

function Module:Stop()
	if not self._active then
		self:_debug("Stop called but already inactive; ignoring")
		return
	end
	self._active = false
	self:_debug("Stop called; module is now inactive")

	-- Cancel pending delay if possible (task.delay returns a thread in modern Roblox)
	if self._spawnThread then
		local ok, err = pcall(function()
			Task.cancel(self._spawnThread)
		end)
		if ok then
			self:_debug("Pending spawn delay canceled")
		else
			self:_debug(("Failed to cancel spawn delay (non-fatal): %s"):format(tostring(err)))
		end
		self._spawnThread = nil
	end

	-- Restore plot if we moved it
	if self._storedPlot and self._storedPlot.Parent == ReplicatedStorage then
		self:_debug(("Restoring plot '%s' to Workspace.Plots"):format(self._storedPlot.Name))
		self._storedPlot.Parent = Workspace.Plots
	else
		self:_debug("No stored plot to restore or already restored")
	end
	self._storedPlot = nil

	-- Cleanup RocketShip if exists
	local rocket = self._rocketShip
	if not rocket or not rocket.Parent then
		rocket = Workspace:FindFirstChild("RocketShip")
	end

	if rocket then
		self:_debug("Destroying RocketShip from workspace")
		rocket:Destroy()
	else
		self:_debug("No RocketShip found to destroy; skipping")
	end

	self._rocketShip = nil
end

return Module
