--[[
  Extracted from: ServerScriptService.Services.Plots.PlotSecurity
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local PlotConstants = require(script.Parent.PlotConstants)
local Friends = require(ReplicatedStorage.Shared.Friends)

local PlotSecurity = {}
PlotSecurity.__index = PlotSecurity

function PlotSecurity.new(plot)
	local self = setmetatable({}, PlotSecurity)

	self.plot = plot

	return self
end

function PlotSecurity:CanPlayerAccess(player)
	local owner = self.plot:GetOwner()

	if player == owner then
		return true
	end

	if self:IsBaseLocked() then
		if self.plot:GetFriendsAllowed() then
			local inGameFriends = Friends:GetInGameFriends(owner)
			return table.find(inGameFriends, player) ~= nil
		end

		return false
	end

	return true
end

function PlotSecurity:CanPlayerAccessFloor(player, floor)
	local owner = self.plot:GetOwner()

	if player == owner then
		return true
	end

	if self:IsFloorLocked(floor) then
		if self.plot:GetFriendsAllowed() then
			local inGameFriends = Friends:GetInGameFriends(owner)
			return table.find(inGameFriends, player) ~= nil
		end

		return false
	end

	return true
end

function PlotSecurity:IsBaseLocked()
	local synchronizer = self.plot:GetSynchronizer()
	return synchronizer:Get("BlockEndTime") ~= nil
end

function PlotSecurity:IsFloorLocked(floor)
	if floor < 1 or floor > 3 then
		return false
	end

	local synchronizer = self.plot:GetSynchronizer()
	local floorKey = PlotConstants.FLOOR_KEYS[floor]
	return synchronizer:Get(floorKey) ~= nil
end

function PlotSecurity:IsInDelayPeriod()
	local synchronizer = self.plot:GetSynchronizer()
	return synchronizer:Get("BlockedDelayTime") ~= nil
end

function PlotSecurity:GetRemainingLockTime()
	if not self:IsBaseLocked() then
		return 0
	end

	local synchronizer = self.plot:GetSynchronizer()
	local lockEndTime = synchronizer:Get("BlockEndTime")
	local currentTime = workspace:GetServerTimeNow()

	return math.max(0, lockEndTime - currentTime)
end

function PlotSecurity:GetRemainingFloorLockTime(floor)
	if not self:IsFloorLocked(floor) then
		return 0
	end

	local synchronizer = self.plot:GetSynchronizer()
	local floorKey = PlotConstants.FLOOR_KEYS[floor]
	local lockEndTime = synchronizer:Get(floorKey)
	local currentTime = workspace:GetServerTimeNow()

	return math.max(0, lockEndTime - currentTime)
end

function PlotSecurity:GetRemainingDelayTime()
	if not self:IsInDelayPeriod() then
		return 0
	end

	local synchronizer = self.plot:GetSynchronizer()
	local delayEndTime = synchronizer:Get("BlockedDelayTime")
	local currentTime = workspace:GetServerTimeNow()

	return math.max(0, delayEndTime - currentTime)
end

function PlotSecurity:ToggleFriendsAccess()
	local currentState = self.plot:GetFriendsAllowed()
	local newState = not currentState

	self.plot:SetFriendsAllowed(newState)

	self:UpdateHitboxStates()

	return newState
end

function PlotSecurity:UpdateHitboxStates()
	local plotModel = self.plot:GetPlotModel()
	if not plotModel then
		return
	end

	local laserHitbox = plotModel:FindFirstChild("LaserHitbox")
	if not laserHitbox then
		return
	end

	local owner = self.plot:GetOwner()
	local inGameFriends = Friends:GetInGameFriends(owner)
	local friendsAllowed = self.plot:GetFriendsAllowed()

	for _, hitbox in pairs(laserHitbox:GetChildren()) do
		local floor = hitbox:GetAttribute("Floor")

		if floor and floor >= 1 and floor <= 3 then
			local isServerControlled = hitbox:GetAttribute("ServerControlled")
			if isServerControlled then
				continue
			end

			local floorLocked = self:IsFloorLocked(floor)

			for _, player in pairs(Players:GetPlayers()) do
				if player == owner then
					hitbox.CanCollide = false
				elseif floorLocked then
					local isFriend = table.find(inGameFriends, player) ~= nil
					hitbox.CanCollide = not (friendsAllowed and isFriend)
				else
					hitbox.CanCollide = false
				end
			end
		else
			local baseLocked = self:IsBaseLocked()

			for _, player in pairs(Players:GetPlayers()) do
				if player == owner then
					hitbox.CanCollide = false
				elseif baseLocked then
					local isFriend = table.find(inGameFriends, player) ~= nil
					hitbox.CanCollide = not (friendsAllowed and isFriend)
				else
					hitbox.CanCollide = false
				end
			end
		end
	end
end

function PlotSecurity:IsPlayerInStealHitbox(player)
	local character = player.Character
	if not character then
		return false
	end

	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	if not humanoidRootPart then
		return false
	end

	local plotModel = self.plot:GetPlotModel()
	if not plotModel then
		return false
	end

	local stealHitbox = plotModel:FindFirstChild("StealHitbox")
	if not stealHitbox then
		return true
	end

	local hitboxCFrame = stealHitbox.CFrame
	local hitboxSize = stealHitbox.Size
	local playerPosition = humanoidRootPart.Position

	local localPosition = hitboxCFrame:PointToObjectSpace(playerPosition)

	local halfSize = hitboxSize * 0.5
	local isInside = math.abs(localPosition.X) <= halfSize.X and
		math.abs(localPosition.Y) <= halfSize.Y and
		math.abs(localPosition.Z) <= halfSize.Z

	return isInside
end

function PlotSecurity:CanPlayerSteal(player)
	local owner = self.plot:GetOwner()

	if player == owner then
		return false, "Cannot steal from your own plot"
	end

	local isInHitbox = self:IsPlayerInStealHitbox(player)
	if not isInHitbox then
		local plotModel = self.plot:GetPlotModel()
		local stealHitbox = plotModel and plotModel:FindFirstChild("StealHitbox")
		if stealHitbox and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local rootPos = player.Character.HumanoidRootPart.Position
			local hitboxPos = stealHitbox.Position
			local distance = (rootPos - hitboxPos).Magnitude
			print("[PlotSecurity] Player", player.Name, "failed StealHitbox check. Distance:", distance, "HitboxSize:", stealHitbox.Size)
		end
		return false, "You must be inside the base to steal animals"
	end

	return true, nil
end

function PlotSecurity:ValidateStealAttempt(player, timestamp)
	if not timestamp then
		return false, "Invalid timestamp"
	end

	local serverTime = workspace:GetServerTimeNow()
	local adjustedTimestamp = timestamp - PlotConstants.SECURITY.TIMESTAMP_OFFSET

	if math.abs(serverTime - adjustedTimestamp) > PlotConstants.SECURITY.TIMESTAMP_TOLERANCE then
		return false, "Timestamp out of range"
	end

	local canSteal, reason = self:CanPlayerSteal(player)
	if not canSteal then
		return false, reason
	end

	return true, nil
end

function PlotSecurity:GetSecurityStatus()
	return {
		baseLocked = self:IsBaseLocked(),
		inDelayPeriod = self:IsInDelayPeriod(),
		friendsAllowed = self.plot:GetFriendsAllowed(),
		remainingLockTime = self:GetRemainingLockTime(),
		remainingDelayTime = self:GetRemainingDelayTime(),
		floorLocks = {
			[1] = self:IsFloorLocked(1),
			[2] = self:IsFloorLocked(2),
			[3] = self:IsFloorLocked(3),
		},
		floorLockTimes = {
			[1] = self:GetRemainingFloorLockTime(1),
			[2] = self:GetRemainingFloorLockTime(2),
			[3] = self:GetRemainingFloorLockTime(3),
		}
	}
end

return PlotSecurity