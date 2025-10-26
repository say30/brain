--[[
  Extracted from: ServerScriptService.Services.MonetizationService.EventsHandler
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Packages = ReplicatedStorage.Packages
local Net = require(Packages.Net)
local Synchronizer = require(Packages.Synchronizer)
local ShopData = require(ReplicatedStorage.Datas.Shop)

local EventsHandler = {}
EventsHandler.__index = EventsHandler

-- List of all individual events
local AllEventsList = {
	"La Vacca Saturno Saturnita",
	"Matteo",
	"Nyan Cats",
	"Raining Tacos",
	"4th of July",
	"Tung Tung Attack",
	"Crab Rave",
	"Molten",
	"Concert",
	"Snow",
	"10B Visits",
	"Glitch",
	"Rainbow",
	"Water",
	"Brazil"
}

function EventsHandler.new(monetizationService)
	local self = setmetatable({}, EventsHandler)

	self._monetizationService = monetizationService
	self._purchaseRemote = Net:RemoteEvent("ShopService/Purchase")
	self._queuedEvents = {}

	self:_setupRemoteEvents()
	self:_setupSynchronizerListener()

	return self
end

function EventsHandler:_setupRemoteEvents()
	self._purchaseRemote.OnServerEvent:Connect(function(player, productId)
		if self:_isEventProduct(productId) then
			self:PromptPurchase(player, productId)
		end
	end)
end

function EventsHandler:_isEventProduct(productId)
	local info = ShopData[tonumber(productId)]
	return info and info.Type == "PaidEvent"
end

function EventsHandler:PromptPurchase(player, productId)
	if not self._monetizationService:IsDataReady(player) then return false end
	local productInfo = ShopData[tonumber(productId)]
	if not productInfo then return false end
	return self._monetizationService:PromptProductPurchase(player, tonumber(productId))
end

function EventsHandler:ProcessPurchase(player, productId, receiptInfo)
	local productInfo = ShopData[productId]
	if not productInfo or productInfo.Type ~= "PaidEvent" then
		return false
	end

	local eventName = productInfo.EventName or productInfo.Display
	local duration = 360

	local eventService = _G.EventService
	if not eventService then
		warn("[EventsHandler] EventService not available")
		return false
	end

	-- Handle AllEvents
	if eventName == "AllEvents" then
		for _, ev in ipairs(AllEventsList) do
			task.spawn(function()
				local success, result = pcall(function()
					return eventService:StartEvent(ev, duration)
				end)
				if not success then
					warn("[EventsHandler] Failed to start event: " .. ev .. " Error: " .. tostring(result))
				end
			end)
		end
	else
		local callSuccess, startResult = pcall(function()
			return eventService:StartEvent(eventName, duration)
		end)
		if not callSuccess then
			warn("[EventsHandler] Error starting event: " .. tostring(startResult))
		end
	end

	-- Queue if not started (optional)
	if not eventService:IsEventActive(eventName) then
		self._queuedEvents[eventName] = (self._queuedEvents[eventName] or 0) + 1
	end

	-- Notify all players
	local NotificationEvent = Net:RemoteEvent("NotificationService/Notify")
	local notifyMessage = (eventName == "AllEvents") and
		string.format("<font color=\"#00FFFF\">%s bought ALL EVENTS!</font>", player.Name) or
		string.format("<font color=\"#00FFFF\">%s bought '%s' event!</font>", player.Name, eventName)

	for _, plr in ipairs(Players:GetPlayers()) do
		NotificationEvent:FireClient(plr, notifyMessage, 4)
	end

	self._monetizationService:LogPurchase(player, productId, "PaidEvent", eventName)
	return true
end

function EventsHandler:_setupSynchronizerListener()
	task.spawn(function()
		local eventsSync = Synchronizer:Wait("Events")
		eventsSync:OnArrayRemoved("ActiveEvents", function(eventData)
			local evName = eventData.eventName
			if self._queuedEvents[evName] and self._queuedEvents[evName] > 0 then
				self._queuedEvents[evName] = self._queuedEvents[evName] - 1
				local eventService = _G.EventService
				if eventService then
					eventService:StartEvent(evName, 360)
				end
			end
		end)
	end)
end

function EventsHandler:OnPurchaseFinished(player, productId, isPurchased)
	-- Optional: add any post-purchase logic here
end

return EventsHandler
