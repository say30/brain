--[[
  Extracted from: ServerScriptService.Services.MonetizationService.LuckyBlockHandler
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local MarketplaceService = game:GetService("MarketplaceService")

local DataManagement = require(ServerScriptService.Services.DataManagment)
local ShopData = require(ReplicatedStorage.Datas.Shop)
local LuckyBlocks = require(ReplicatedStorage.Datas.LuckyBlocks)
local Net = require(ReplicatedStorage.Packages.Net)

local NotificationEvent = Net:RemoteEvent("NotificationService/Notify")

local LuckyBlockHandler = {}
LuckyBlockHandler.__index = LuckyBlockHandler

function LuckyBlockHandler.new(monetizationService)
	local self = setmetatable({}, LuckyBlockHandler)
	self._monetizationService = monetizationService
	self._purchaseRemote = Net:RemoteEvent("ShopService/Purchase")

	self:_setupRemoteEvents()
	return self
end

function LuckyBlockHandler:Initialize()
	for luckyBlockName, luckyBlockData in pairs(LuckyBlocks) do
		if luckyBlockData.ProductId then
			self._monetizationService:RegisterProduct(luckyBlockData.ProductId, "LuckyBlock", self)
		end
	end
end

function LuckyBlockHandler:_setupRemoteEvents()
	self._purchaseRemote.OnServerEvent:Connect(function(player, productId)
		if not self:CanHandleProduct(productId) then
			return
		end

		self:PromptPurchase(player, productId)
	end)
end

function LuckyBlockHandler:CanHandleProduct(productId)
	local productInfo = ShopData[productId]
	return productInfo and productInfo.Type == "LuckyBlock"
end

function LuckyBlockHandler:PromptPurchase(player, productId)
	if not self._monetizationService:IsDataReady(player) then 
		return false 
	end

	local hasEmptySlot = self:_hasEmptySlot(player)
	if not hasEmptySlot then
		NotificationEvent:FireClient(player, "<font color=\"#FA0103\">You can't purchase this product, base is full!</font>", 5)
		return false
	end

	local marketplaceInfo = MarketplaceService:GetProductInfo(tonumber(productId), Enum.InfoType.Product)
	if not marketplaceInfo then
		return false
	end

	return self._monetizationService:PromptProductPurchase(player, tonumber(productId))
end

function LuckyBlockHandler:ProcessPurchase(player, productId, receiptInfo)
	if not self._monetizationService:IsDataReady(player) then
		return false
	end

	local productInfo = ShopData[productId]
	if not productInfo or productInfo.Type ~= "LuckyBlock" then
		return false
	end

	local hasEmptySlot = self:_hasEmptySlot(player)
	if not hasEmptySlot then
		NotificationEvent:FireClient(player, "No empty slots available!", 5)
		return false
	end

	local luckyBlockData = nil
	local luckyBlockName = nil
	for name, data in pairs(LuckyBlocks) do
		if data.ProductId == productId then
			luckyBlockData = data
			luckyBlockName = name
			break
		end
	end

	if not luckyBlockData then
		return false
	end

	local success, slotNumber = pcall(function()
		local mutation = nil
		if ReplicatedStorage:GetAttribute("GalaxyEvent") == true then
			mutation = "Galaxy"
		end

		local slot = DataManagement.addAnimal(player, luckyBlockName, mutation, nil)

		local animalList = DataManagement.getAnimalList(player)
		if animalList[slot] and typeof(animalList[slot]) == "table" then
			animalList[slot].Timer = 0
		end

		return slot
	end)

	if success and slotNumber then
		self._monetizationService:LogPurchase(player, productId, "LuckyBlock", luckyBlockName)
		return true
	else
		NotificationEvent:FireClient(player, "There was an error adding a Lucky Block to your plot.", 5)
		return false
	end
end

function LuckyBlockHandler:OnPurchaseFinished(player, productId, isPurchased)
	if isPurchased then
	else
	end
end

function LuckyBlockHandler:_hasEmptySlot(player)
	if not DataManagement.isDataReady(player) then
		return false
	end

	local animalList = DataManagement.getAnimalList(player)
	if not animalList then
		return false
	end

	local maxAnimals = DataManagement.GetMaxAnimals(player)
	for i = 1, maxAnimals do
		if animalList[i] == "Empty" or animalList[i] == nil then
			return true
		end
	end

	return false
end

return LuckyBlockHandler