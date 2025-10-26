--[[
  Extracted from: ServerScriptService.Services.BubblegumEventService
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")
local Packages = ReplicatedStorage.Packages
local Net = require(Packages.Net)
local Synchronizer = require(Packages.Synchronizer)
local DataManagment = require(ServerScriptService.Services.DataManagment)
local plotsService = require(script.Parent.Plots)

local BubblegumEventService = {}
BubblegumEventService.__index = BubblegumEventService

function BubblegumEventService.new()
	local self = setmetatable({}, BubblegumEventService)

	self.globalCandyDeliveryCount = 0
	self._deliveryDebounce = {}
	self._eventActive = false
	self._timerEnd = 0

	ReplicatedStorage:SetAttribute("BubblegumEvent", false)
	self:_setupRemoteEvents()
	self:_updateBillboardGui()

	return self
end

function BubblegumEventService:_setupRemoteEvents()
	local DeliveryEvent = Net:RemoteEvent("BubblegumEventService/Delivery")

	DeliveryEvent.OnServerEvent:Connect(function(player, actionId)
		self:handleCandyDelivery(player, actionId)
	end)
end

function BubblegumEventService:handleCandyDelivery(player, actionId)
	local currentTime = tick()
	if self._deliveryDebounce[player] and (currentTime - self._deliveryDebounce[player]) < 2 then
		return
	end
	self._deliveryDebounce[player] = currentTime

	if not DataManagment.isDataReady(player) then
		return
	end

	if not player:GetAttribute("Stealing") then
		return
	end

	local stealingPlot = player:GetAttribute("StealingPlot")
	local stealingSlot = player:GetAttribute("StealingSlot")

	if not stealingPlot or not stealingSlot then
		return
	end

	local targetPlot = Synchronizer:Get(stealingPlot)
	if not targetPlot then
		return
	end

	local animalList = targetPlot:Get("AnimalList") or {}
	local animal = animalList[stealingSlot]

	if not animal or typeof(animal) ~= "table" or not animal.Steal or animal.Mutation ~= "Candy" then
		return
	end

	local playerPlotModel = plotsService.getPlotModel(player)
	if not playerPlotModel then
		return
	end

	local isInDeliveryArea = self:_isPlayerInBubblegumMachineDeliveryArea(player, workspace.BubbleGumMachine)
	if not isInDeliveryArea then
		return
	end

	self.globalCandyDeliveryCount = self.globalCandyDeliveryCount + 1

	self:_cleanupDelivery(player, targetPlot, animalList, stealingSlot)
	self:_updateBillboardGui()
	for _ ,b in workspace:WaitForChild("BubbleGumMachine").Vfx.Placed:GetDescendants() do
		if b:IsA("ParticleEmitter") then
			b:Emit(20)
		end
	end

	local notificationEvent = Net:RemoteEvent("NotificationService/Notify")
	notificationEvent:FireClient(
		player,
		string.format("You have added a <font color=\"#D4AF37\"><b>Candy mutation brainrot</b></font> to the counter!", self.globalCandyDeliveryCount),
		3
	)

	if self.globalCandyDeliveryCount >= 10 and not self._eventActive then
		notificationEvent:FireClient(
			player,
			" <font color='#ff55ff'><b>Bubblegum Machine</b></font> has been activated!",
			6
		)
		self:_triggerBubblegumEvent()
	end
end

function BubblegumEventService:_isPlayerInBubblegumMachineDeliveryArea(player, BubbleGumMachine)
	if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
		return false
	end

	local humanoidRootPart = player.Character.HumanoidRootPart
	local deliveryHitbox = BubbleGumMachine:FindFirstChild("DeliveryHitbox")

	if not deliveryHitbox or not deliveryHitbox:IsA("BasePart") then
		return false
	end

	local distance = (humanoidRootPart.Position - deliveryHitbox.Position).Magnitude
	local hitboxRadius = math.max(deliveryHitbox.Size.X, deliveryHitbox.Size.Y, deliveryHitbox.Size.Z) / 2
	local maxValidDistance = hitboxRadius + 10

	return distance <= maxValidDistance
end

function BubblegumEventService:_cleanupDelivery(player, targetPlot, animalList, stealingSlot)
	animalList[stealingSlot] = "Empty"
	targetPlot:Set("AnimalList", animalList)
	targetPlot:Set("AnimalPodiums", animalList)

	local targetOwner = targetPlot:Get("Owner")
	if targetOwner then
		DataManagment.removeAnimal(targetOwner, stealingSlot)
		local targetPlayerSync = Synchronizer:Get(targetOwner)
		if targetPlayerSync then
			local targetData = DataManagment.GetDataMan(targetOwner)
			if targetData then
				targetPlayerSync:Set("AnimalAddedOrRemoved", targetData.AnimalList)
				targetPlayerSync:Set("AnimalPodiums", targetData.AnimalList)
			end
		end
	end

	player:SetAttribute("Stealing", false)
	player:SetAttribute("StealingPlot", nil)
	player:SetAttribute("StealingSlot", nil)
end

function BubblegumEventService:_updateBillboardGui()
	local tank = workspace.BubbleGumMachine:FindFirstChild("Tank")
	if tank and tank:FindFirstChild("BillboardGui") then
		if self._eventActive then
			local timeLeft = math.max(0, math.floor(self._timerEnd - tick()))
			local minutes = math.floor(timeLeft / 60)
			local seconds = timeLeft % 60
			tank.BillboardGui.DisplayText.Text = string.format("%d:%02d", minutes, seconds)
		else
			tank.BillboardGui.DisplayText.Text = string.format("%d/10", self.globalCandyDeliveryCount)
		end
	end
end

function BubblegumEventService:_triggerBubblegumEvent()
	self._eventActive = true
	self._timerEnd = tick() + 900

	local VFX = workspace.BubbleGumMachine:WaitForChild("Vfx")
	local Enabled = VFX:WaitForChild("Enabled")
	local Top = VFX:WaitForChild("Goal")

	for _, top in Top:GetDescendants() do
		if top:IsA("ParticleEmitter") then
			top.Enabled = true
		end
	end
	for _, top in Enabled:GetDescendants() do
		if top:IsA("ParticleEmitter") or top:IsA("Beam") then
			top.Enabled = true
		end
	end

	self.globalCandyDeliveryCount = 0
	self:_updateBillboardGui()

	task.spawn(function()
		while tick() < self._timerEnd do
			self:_updateBillboardGui()
			task.wait(1)
		end
		self._eventActive = false
		ReplicatedStorage:SetAttribute("BubblegumEvent", false)
		ReplicatedStorage:SetAttribute("BubblegumEventTimer", 0)

		for _, top in Top:GetDescendants() do
			if top:IsA("ParticleEmitter") then
				top.Enabled = false
			end
		end
		for _, top in Enabled:GetDescendants() do
			if top:IsA("ParticleEmitter") or top:IsA("Beam") then
				top.Enabled = false
			end
		end
	end)
end

function BubblegumEventService:IsEnabled()
	return self._eventActive
end

function BubblegumEventService:Enable()
	if self._eventActive then
		return false
	end
	ReplicatedStorage:SetAttribute("BubblegumEvent", true)
	ReplicatedStorage:SetAttribute("BubblegumEventTimer", workspace:GetServerTimeNow() + 900)
	self:_triggerBubblegumEvent()
	return true
end

return BubblegumEventService