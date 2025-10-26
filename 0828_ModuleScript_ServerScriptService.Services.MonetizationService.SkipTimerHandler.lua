--[[
  Extracted from: ServerScriptService.Services.MonetizationService.SkipTimerHandler
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")

local Packages = ReplicatedStorage.Packages
local Net = require(Packages.Net)
local DataManagement = require(ServerScriptService.Services.DataManagment)

local SkipTimerHandler = {}
SkipTimerHandler.__index = SkipTimerHandler

local SKIP_TIMER_PRODUCT_ID = 3373876887

function SkipTimerHandler.new(monetizationService)
	local self = setmetatable({}, SkipTimerHandler)
	self._monetizationService = monetizationService
	self._purchaseRemote = Net:RemoteEvent("ShopService/Purchase")
	self:_setupRemoteEvents()
	return self
end

function SkipTimerHandler:_setupRemoteEvents()
	self._purchaseRemote.OnServerEvent:Connect(function(player, productId)
		if tonumber(productId) == SKIP_TIMER_PRODUCT_ID then
			self:PromptPurchase(player, productId)
		end
	end)
end

function SkipTimerHandler:PromptPurchase(player, productId)
	if not self._monetizationService:IsDataReady(player) then
		warn("[SkipTimerHandler] Player data not ready for purchase: " .. player.Name)
		return false
	end

	if tonumber(productId) ~= SKIP_TIMER_PRODUCT_ID then
		warn("[SkipTimerHandler] Invalid product ID: " .. tostring(productId))
		return false
	end

	local marketplaceInfo = self._monetizationService:GetProductInfo(tonumber(productId))
	if not marketplaceInfo then
		warn("[SkipTimerHandler] Failed to get marketplace info for: " .. tostring(productId))
		return false
	end

	return self._monetizationService:PromptProductPurchase(player, tonumber(productId))
end

function SkipTimerHandler:ProcessPurchase(player, productId, receiptInfo)
	if not self._monetizationService:IsDataReady(player) then
		warn("[SkipTimerHandler] Player data not ready for processing: " .. player.Name)
		return false
	end

	if tonumber(productId) ~= SKIP_TIMER_PRODUCT_ID then
		warn("[SkipTimerHandler] Invalid product ID: " .. tostring(productId))
		return false
	end

	local success, err = pcall(function()
		DataManagement.setHourPickCooldown(player, 0)

		local UpdateCooldownEvent = Net:RemoteEvent("Update/Player/Cooldown")
		UpdateCooldownEvent:FireClient(player, 0)
	end)

	if success then
		self._monetizationService:LogPurchase(player, productId, "SkipTimer", "1HourPick Timer Reset")
		DataManagement.setHourPickCooldown(player, 0)
		if _G.ResetHourPickCooldown then
			_G.ResetHourPickCooldown(player)
		end
		return true
	else
		warn("[SkipTimerHandler] Failed to reset timer for player: " .. player.Name .. " Error: " .. tostring(err))
		return false
	end
end

function SkipTimerHandler:OnPurchaseFinished(player, productId, isPurchased)
	if isPurchased then
		self._monetizationService:LogPurchase(player, productId, "SkipTimer", "Purchase Completed")
	end
end

return SkipTimerHandler