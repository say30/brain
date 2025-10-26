--[[
  Extracted from: ServerScriptService.Services.MonetizationService.BaseLockHandler
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local MarketplaceService = game:GetService("MarketplaceService")

local Packages = ReplicatedStorage.Packages
local Data = ReplicatedStorage.Datas
local Services = ServerScriptService.Services
local Net = require(Packages.Net)
local Synchronizer = require(Packages.Synchronizer)
local ShopData = require(Data.Shop)
local UnlockBaseData = require(Data.UnlockBase)
local Plots = require(ServerScriptService.Services.Plots)

local BaseLockHandler = {}
BaseLockHandler.__index = BaseLockHandler

function BaseLockHandler.new(monetizationService)
	local self = setmetatable({}, BaseLockHandler)

	self._monetizationService = monetizationService
	self._purchaseRemote = Net:RemoteEvent("ShopService/Purchase")

	self:_setupRemoteEvents()
	return self
end

function BaseLockHandler:_setupRemoteEvents()
	self._purchaseRemote.OnServerEvent:Connect(function(player, productId, plotOwnerUserId)
		if self:_isUnlockBaseProduct(productId) then
			if plotOwnerUserId then
				local plotOwner = game.Players:GetPlayerByUserId(plotOwnerUserId)
				if not plotOwner then
					warn("[BaseLockHandler] Plot owner not found for UserId:", plotOwnerUserId)
					return
				end
				self._pendingPlotOwners = self._pendingPlotOwners or {}
				self._pendingPlotOwners[player.UserId .. "_" .. productId] = plotOwner
			end
			self:PromptPurchase(player, productId)
		end
	end)
end

function BaseLockHandler:_isUnlockBaseProduct(productId)
	local productInfo = ShopData[tonumber(productId)]
	return productInfo and productInfo.Type == "UnlockBase"
end

function BaseLockHandler:_getFloorFromProductId(productId)
	for floor, data in pairs(UnlockBaseData) do
		if data.ProductId == productId then
			return floor
		end
	end
	return nil
end

function BaseLockHandler:PromptPurchase(player, productId)
	if not self._monetizationService:IsDataReady(player) then
		warn("[BaseLockHandler] Player data not ready for purchase:", player.Name)
		return false
	end

	local productInfo = ShopData[tonumber(productId)]
	if not productInfo then
		warn("[BaseLockHandler] Invalid product ID:", productId)
		return false
	end

	local marketplaceInfo = self._monetizationService:GetProductInfo(tonumber(productId))
	if not marketplaceInfo then
		warn("[BaseLockHandler] Failed to get marketplace info for:", productId)
		return false
	end

	return self._monetizationService:PromptProductPurchase(player, tonumber(productId))
end

function BaseLockHandler:ProcessPurchase(player, productId, receiptInfo)
	if not self._monetizationService:IsDataReady(player) then
		warn("[BaseLockHandler] Player data not ready for processing:", player.Name)
		return false
	end

	local targetPlayer = player
	local purchaseKey = player.UserId .. "_" .. productId
	if self._pendingPlotOwners and self._pendingPlotOwners[purchaseKey] then
		targetPlayer = self._pendingPlotOwners[purchaseKey]
		self._pendingPlotOwners[purchaseKey] = nil
		print(string.format("[BaseLockHandler] %s bought unlock for %s's base", player.Name, targetPlayer.Name))
	end

	local playerPlot = self._monetizationService:GetPlayerSynchronizer(targetPlayer)
	if not playerPlot then
		warn("[BaseLockHandler] No synchronizer found for player:", targetPlayer.Name)
		return false
	end

	local productInfo = ShopData[productId]
	if not productInfo or productInfo.Type ~= "UnlockBase" then
		warn("[BaseLockHandler] Invalid unlock base product:", productId)
		return false
	end

	local floor = self:_getFloorFromProductId(productId)
	if not floor then
		warn("[BaseLockHandler] Could not determine floor for product:", productId)
		return false
	end

	local floorKey = "BlockEndTime" .. (floor == 1 and "FirstFloor" or floor == 2 and "SecondFloor" or "ThirdFloor")
	playerPlot:Set(floorKey, nil)

	self:UpdateSpecificFloorState(targetPlayer, floor)

	self._monetizationService:LogPurchase(player, productId, "UnlockBase", "Floor " .. floor .. " unlocked for " .. targetPlayer.Name)

	print(string.format("[BaseLockHandler] Successfully unlocked floor %d for %s", floor, targetPlayer.Name))
	return true
end

function BaseLockHandler:UpdateSpecificFloorState(player, targetFloor)
	local plotModel = Plots.getPlotModel(player)
	local playerPlot = self._monetizationService:GetPlayerSynchronizer(player)

	if not plotModel or not playerPlot then
		warn("[BaseLockHandler] Missing plot model or synchronizer for:", player.Name)
		return
	end

	local floorKey = "BlockEndTime" .. (targetFloor == 1 and "FirstFloor" or targetFloor == 2 and "SecondFloor" or "ThirdFloor")
	local floorLocked = playerPlot:Get(floorKey) ~= nil

	local laserHitbox = plotModel:FindFirstChild("LaserHitbox")
	if laserHitbox then
		for _, hitbox in pairs(laserHitbox:GetChildren()) do
			local hitboxFloor = hitbox:GetAttribute("Floor")
			if hitboxFloor == targetFloor then
				hitbox.CanCollide = floorLocked
				if not floorLocked then
					hitbox:SetAttribute("ServerControlled", true)
				else
					hitbox:SetAttribute("ServerControlled", nil)
				end
				print(string.format("[BaseLockHandler] Floor %d hitbox CanCollide set to %s, ServerControlled: %s", 
					hitboxFloor, tostring(floorLocked), tostring(not floorLocked)))
			end
		end
	end

	local laser = plotModel:FindFirstChild("Laser")
	if laser then
		for _, laserModel in pairs(laser:GetChildren()) do
			if laserModel:IsA("Model") then
				local laserFloor = laserModel:GetAttribute("Floor")
				if laserFloor == targetFloor then
					for _, laserPart in pairs(laserModel:GetDescendants()) do
						if laserPart:IsA("BasePart") then
							laserPart.Transparency = floorLocked and 0 or 1
						end
					end
					print(string.format("[BaseLockHandler] Floor %d laser transparency set to %s", 
						laserFloor, tostring(floorLocked and 0 or 1)))
				end
			end
		end
	end

	print(string.format("[BaseLockHandler] Updated floor %d state for %s (locked: %s)", targetFloor, player.Name, tostring(floorLocked)))
end

function BaseLockHandler:UpdateAllFloorStates(player)
	local plotModel = Plots.getPlotModel(player)
	local playerPlot = self._monetizationService:GetPlayerSynchronizer(player)

	if not plotModel or not playerPlot then
		warn("[BaseLockHandler] Missing plot model or synchronizer for:", player.Name)
		return
	end

	local baseLocked = playerPlot:Get("BlockEndTime") ~= nil

	local laserHitbox = plotModel:FindFirstChild("LaserHitbox")
	if laserHitbox then
		for _, hitbox in pairs(laserHitbox:GetChildren()) do
			local hitboxFloor = hitbox:GetAttribute("Floor")
			if hitboxFloor and hitboxFloor >= 1 and hitboxFloor <= 3 then
				local floorKey = "BlockEndTime" .. (hitboxFloor == 1 and "FirstFloor" or hitboxFloor == 2 and "SecondFloor" or "ThirdFloor")
				local floorLocked = playerPlot:Get(floorKey) ~= nil

				hitbox.CanCollide = floorLocked
				if not floorLocked then
					hitbox:SetAttribute("ServerControlled", true)
				else
					hitbox:SetAttribute("ServerControlled", nil)
				end
				print(string.format("[BaseLockHandler] Floor %d hitbox set to %s, ServerControlled: %s", 
					hitboxFloor, tostring(floorLocked), tostring(not floorLocked)))
			else
				hitbox.CanCollide = baseLocked
			end
		end
	end

	local laser = plotModel:FindFirstChild("Laser")
	if laser then
		for _, laserModel in pairs(laser:GetChildren()) do
			if laserModel:IsA("Model") then
				local laserFloor = laserModel:GetAttribute("Floor")
				if laserFloor and laserFloor >= 1 and laserFloor <= 3 then
					local floorKey = "BlockEndTime" .. (laserFloor == 1 and "FirstFloor" or laserFloor == 2 and "SecondFloor" or "ThirdFloor")
					local floorLocked = playerPlot:Get(floorKey) ~= nil

					for _, laserPart in pairs(laserModel:GetDescendants()) do
						if laserPart:IsA("BasePart") then
							laserPart.Transparency = floorLocked and 0 or 1
						end
					end
					print(string.format("[BaseLockHandler] Floor %d laser visibility set to %s (floor: %s)", 
						laserFloor, tostring(floorLocked and 0 or 1), tostring(floorLocked)))
				else
					for _, laserPart in pairs(laserModel:GetDescendants()) do
						if laserPart:IsA("BasePart") then
							laserPart.Transparency = baseLocked and 0 or 1
						end
					end
				end
			end
		end
	end

	print(string.format("[BaseLockHandler] Updated all floor states for %s", player.Name))
end

function BaseLockHandler:OnPurchaseFinished(player, productId, isPurchased)
	if isPurchased then
		print(string.format("[BaseLockHandler] Purchase completed for %s: %s", player.Name, productId))
	else
		print(string.format("[BaseLockHandler] Purchase cancelled for %s: %s", player.Name, productId))
	end
end

function BaseLockHandler:IsFloorLocked(player, floor)
	local playerPlot = self._monetizationService:GetPlayerSynchronizer(player)
	if not playerPlot then
		return false
	end

	local floorKey = "BlockEndTime" .. (floor == 1 and "FirstFloor" or floor == 2 and "SecondFloor" or "ThirdFloor")
	local blockEndTime = playerPlot:Get(floorKey)

	if not blockEndTime then
		return false
	end

	local currentTime = workspace:GetServerTimeNow()
	return currentTime < blockEndTime
end

function BaseLockHandler:GetFloorUnlockProductId(floor)
	local data = UnlockBaseData[floor]
	return data and data.ProductId or nil
end

return BaseLockHandler