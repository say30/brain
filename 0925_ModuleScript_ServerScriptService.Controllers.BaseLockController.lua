--[[
  Extracted from: ServerScriptService.Controllers.BaseLockController
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")

local Packages = ReplicatedStorage.Packages
local Data = ReplicatedStorage.Datas
local Services = game:GetService("ServerScriptService").Services

local Net = require(Packages.Net)
local Synchronizer = require(Packages.Synchronizer)
local DataManagement = require(Services.DataManagment)
local GameData = require(Data.Game)
local Rebirths = require(Data.Rebirth)

local NotificationEvent = Net:RemoteEvent("NotificationService/Notify")

local BASE_LOCK_DURATION = GameData.BlockBase.Duration or 60

local PlayerDebounce = {}

local BaseLockController = {}

function BaseLockController:Start()
	self:SetupPlotHitboxes()

	Players.PlayerRemoving:Connect(function(player)
		if PlayerDebounce[player.UserId] then
			PlayerDebounce[player.UserId] = nil
		end
	end)
end

function BaseLockController:GetLockDuration(player)
	if not player or not player.Parent then
		return BASE_LOCK_DURATION
	end

	local Data = DataManagement.GetDataMan(player)
	if not Data then 
		return BASE_LOCK_DURATION 
	end

	local Rebirth = Data.Rebirths <= 0 and 0 or (Rebirths[Data.Rebirths].Rewards.AdditionalLockTime)

	return BASE_LOCK_DURATION + Rebirth
end

function BaseLockController:UpdateLasersAndHitbox(plot, plotModel, isLocked, owner)
	if not plotModel then
		return
	end

	local MonetizationService = _G.MonetizationService
	if owner and MonetizationService and MonetizationService.GetBaseLockHandler then
		local success, handler = pcall(function()
			return MonetizationService:GetBaseLockHandler()
		end)
		if success and handler and handler.UpdateAllFloorStates then
			local updateSuccess = pcall(function()
				handler:UpdateAllFloorStates(owner)
			end)
			if updateSuccess then
				return
			end
		end
	end

	local Laser = plotModel:FindFirstChild("Laser")
	if not Laser then
		return
	end

	local LaserHitbox = plotModel:FindFirstChild("LaserHitbox")
	if not LaserHitbox then
		return
	end

	for _, hitbox in pairs(LaserHitbox:GetChildren()) do
		local hitboxFloor = hitbox:GetAttribute("Floor")
		if hitboxFloor and hitboxFloor >= 1 and hitboxFloor <= 3 then
			local floorKey = "BlockEndTime" .. (hitboxFloor == 1 and "FirstFloor" or hitboxFloor == 2 and "SecondFloor" or "ThirdFloor")
			local floorLocked = plot:Get(floorKey) ~= nil
			hitbox.CanCollide = floorLocked
			if not floorLocked then
				hitbox:SetAttribute("ServerControlled", true)
			else
				hitbox:SetAttribute("ServerControlled", nil)
			end
		else
			hitbox.CanCollide = isLocked
			if isLocked then
				hitbox:SetAttribute("ServerControlled", nil)
			end
		end
	end

	for _, laserModel in pairs(Laser:GetChildren()) do
		if laserModel:IsA("Model") then
			local laserFloor = laserModel:GetAttribute("Floor")
			if laserFloor and laserFloor >= 1 and laserFloor <= 3 then
				local floorKey = "BlockEndTime" .. (laserFloor == 1 and "FirstFloor" or laserFloor == 2 and "SecondFloor" or "ThirdFloor")
				local floorLocked = plot:Get(floorKey) ~= nil
				for _, laserPart in pairs(laserModel:GetDescendants()) do
					if laserPart:IsA("BasePart") then
						laserPart.Transparency = floorLocked and 0 or 1
					end
				end
			else
				for _, laserPart in pairs(laserModel:GetDescendants()) do
					if laserPart:IsA("BasePart") then
						laserPart.Transparency = isLocked and 0 or 1
					end
				end
			end
		else
			if laserModel:IsA("BasePart") then
				laserModel.Transparency = isLocked and 0 or 1
			end
		end
	end
end

function BaseLockController:SendNotification(player, success, message)
	if not player or not player.Parent then
		return
	end

	local color = success and "#92FF67" or "#FA0103"
	local formattedMessage = string.format("<font color=\"%s\">%s</font>", color, message)

	local success, err = pcall(function()
		NotificationEvent:FireClient(player, formattedMessage, 5, success and "Sounds.Sfx.Success" or "Sounds.Sfx.Error")
	end)

	if not success then
		-- Player likely left, silently ignore
	end
end

function BaseLockController:LockPlayerBase(player, plotUUID)
	if not player or not plotUUID then
		warn("[BaseLockController] Invalid player or plotUUID")
		return
	end

	local plot = Synchronizer:Get(plotUUID)
	if not plot then
		warn("[BaseLockController] Plot not found:", plotUUID)
		return
	end

	if plot:Get("Owner") ~= player then
		self:SendNotification(player, false, "You can only lock your own base!")
		return
	end

	local currentTime = workspace:GetServerTimeNow()
	if plot:Get("BlockEndTime") and currentTime < plot:Get("BlockEndTime") then
		self:SendNotification(player, false, "Your base is already locked!")
		return
	end

	local lockDuration = self:GetLockDuration(player)
	plot:Set("BlockEndTime", currentTime + lockDuration)
	plot:Set("BlockEndTimeFirstFloor", currentTime + lockDuration)
	plot:Set("BlockEndTimeSecondFloor", currentTime + lockDuration)
	plot:Set("BlockEndTimeThirdFloor", currentTime + lockDuration)

	local plotModel = workspace.Plots:FindFirstChild(plotUUID)
	if plotModel then
		self:UpdateLasersAndHitbox(plot, plotModel, true, player)
	end

	self:SendNotification(player, true, string.format("You locked your base for %d seconds!", lockDuration))

	local plotChannel = plot

	local function performUnlock()
		if plotChannel and plotChannel.Get == nil then
			return
		end
		if plotChannel:Get("BlockEndTime") == nil then
			return
		end

		plotChannel:Set("BlockEndTime", nil)
		plotChannel:Set("BlockEndTimeFirstFloor", nil)
		plotChannel:Set("BlockEndTimeSecondFloor", nil)
		plotChannel:Set("BlockEndTimeThirdFloor", nil)

		if plotModel and plotModel.Parent then
			if player and player.Parent then
				self:UpdateLasersAndHitbox(plotChannel, plotModel, false, player)
			else
				self:UpdateLasersAndHitbox(plotChannel, plotModel, false, nil)
			end
		end
	end

	local endTime = plot:Get("BlockEndTime")
	if endTime == nil then
		return
	end
	local now = workspace:GetServerTimeNow()
	local remaining = endTime - now
	if remaining > 0 then
		task.delay(remaining, performUnlock)
	else
		performUnlock()
	end
end

function BaseLockController:SetupPlotHitboxes()
	local plots = workspace.Plots
	if not plots then
		return
	end

	plots.ChildAdded:Connect(function(plot)
		if plot:IsA("Model") then
			self:SetupPlotBlockHitboxes(plot)
		end
	end)

	for _, plot in ipairs(plots:GetChildren()) do
		if plot:IsA("Model") then
			self:SetupPlotBlockHitboxes(plot)
		end
	end
end

function BaseLockController:SetupPlotBlockHitboxes(plot)
	if not plot then
		return
	end

	local plotUUID = plot.Name

	plot.DescendantAdded:Connect(function(child)
		if child.Name == "PlotBlock" and child:IsA("Model") then
			self:ConnectPlotBlockHitbox(child, plotUUID)
		end
	end)

	local plotBlocks = 0
	for _, child in ipairs(plot:GetDescendants()) do
		if child.Name == "PlotBlock" and child:IsA("Model") then
			self:ConnectPlotBlockHitbox(child, plotUUID)
			plotBlocks += 1
		end
	end
end

function BaseLockController:ConnectPlotBlockHitbox(plotBlock, plotUUID)
	if not plotBlock then
		return
	end

	local hitbox = plotBlock:FindFirstChild("Hitbox")
	if not hitbox then 
		return 
	end

	hitbox.Touched:Connect(function(hit)
		if not hit or not hit.Parent then 
			return 
		end

		local character = hit.Parent

		local player = Players:GetPlayerFromCharacter(character)
		if not player or not player.Parent then 
			return 
		end

		if PlayerDebounce[player.UserId] then 
			return 
		end

		PlayerDebounce[player.UserId] = true
		task.delay(1, function()
			if PlayerDebounce then
				PlayerDebounce[player.UserId] = nil
			end
		end)

		local plot = Synchronizer:Get(plotUUID)
		if not plot then 
			return 
		end

		local plotOwner = plot:Get("Owner")

		if plot:Get("Owner") ~= player then 
			return 
		end

		local blockEndTime = plot:Get("BlockEndTime")
		if blockEndTime then 
			local remainingTime = math.ceil(blockEndTime - workspace:GetServerTimeNow())
			self:SendNotification(player, false, "Your base is already locked!")
			return 
		end

		self:LockPlayerBase(player, plotUUID)
	end)
end

return BaseLockController