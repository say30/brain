--[[
  Extracted from: ServerScriptService.Services.MonetizationService.TrollHandler
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")

local Packages = ReplicatedStorage:WaitForChild("Packages")
local Net = require(Packages.Net)
local ShopData = require(ReplicatedStorage.Datas.Shop)
local DataManagement = require(ServerScriptService.Services.DataManagment)
local ProfileStore = require(ServerScriptService.Controllers.ProfileStore)

local NotificationEvent = Net:RemoteEvent("NotificationService/Notify")

local TrollHandler = {}
TrollHandler.__index = TrollHandler

function TrollHandler.new(monetizationService)
	local self = setmetatable({}, TrollHandler)

	self._monetizationService = monetizationService
	self._purchaseRemote = Net:RemoteEvent("ShopService/Purchase")
	self._pendingTargets = {}

	self:_setupRemoteEvents()

	return self
end

function TrollHandler:_isTrollProduct(productId)
	local info = ShopData[tonumber(productId)]
	return info and info.Type == "TrollAction"
end

function TrollHandler:_setupRemoteEvents()
	self._purchaseRemote.OnServerEvent:Connect(function(player, productId, targetUserId)
		if not self:_isTrollProduct(productId) then return end

		if typeof(targetUserId) ~= "number" then
			targetUserId = tonumber(targetUserId)
		end

		if not targetUserId then return end

		self._pendingTargets[player.UserId] = targetUserId
		self:PromptPurchase(player, productId)
	end)
end

function TrollHandler:PromptPurchase(player, productId)
	if not self._monetizationService:IsDataReady(player) then return false end

	return self._monetizationService:PromptProductPurchase(player, tonumber(productId))
end

local function notifyAll(message, duration)
	for _, plr in ipairs(Players:GetPlayers()) do
		NotificationEvent:FireClient(plr, message, duration or 4)
	end
end

local function safeHumanoid(player)
	if player and player.Character then
		return player.Character:FindFirstChildOfClass("Humanoid")
	end
end

local function safeRoot(player)
	if player and player.Character then
		return player.Character:FindFirstChild("HumanoidRootPart")
	end
end

function TrollHandler:ProcessPurchase(player, productId, receiptInfo)
	local productInfo = ShopData[productId]
	if not productInfo or productInfo.Type ~= "TrollAction" then
		return false
	end

	local targetUserId = self._pendingTargets[player.UserId]
	self._pendingTargets[player.UserId] = nil

	if not targetUserId then
		warn("[TrollHandler] No pending target for player", player.Name)
		return false
	end

	local targetPlayer = Players:GetPlayerByUserId(targetUserId)
	if not targetPlayer then
		warn("[TrollHandler] Target player not found")
		return false
	end

	local action = productInfo.Action

	if action == "Kill" then
		local hum = safeHumanoid(targetPlayer)
		if hum then hum.Health = 0 end
		notifyAll(string.format("<font color=\"#FF0000\">%s was eliminated by %s</font>", targetPlayer.Name, player.Name), 4)
	elseif action == "Fling" then
		local root = safeRoot(targetPlayer)
		if root then
			local oldImpulse = root:FindFirstChild("TrollFlingImpulse")
			if oldImpulse then
				oldImpulse:Destroy()
			end

			for _, child in ipairs(root:GetChildren()) do
				if child:IsA("BodyVelocity") or child:IsA("LinearVelocity") then
					child:Destroy()
				end
			end

			local bv = Instance.new("BodyVelocity")
			bv.Name = "TrollFlingImpulse"
			bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
			bv.P = 1e5
			bv.Velocity = Vector3.new(math.random(-450,450), math.random(700,900), math.random(-450,450))
			bv.Parent = root
			game:GetService("Debris"):AddItem(bv, 1.5)

			root.AssemblyAngularVelocity = Vector3.new(math.random(-350,350), math.random(-350,350), math.random(-350,350))
		end
		notifyAll(string.format("<font color=\"#FFA500\">%s was launched sky-high by %s!</font>", targetPlayer.Name, player.Name), 4)
	elseif action == "Goto" then
		local rootPlayer = safeRoot(player)
		local rootTarget = safeRoot(targetPlayer)
		if rootPlayer and rootTarget then
			rootPlayer.CFrame = rootTarget.CFrame + Vector3.new(0, 2, 0)
		end
		NotificationEvent:FireClient(player, string.format("<font color=\"#00FFFF\">Teleported to %s</font>", targetPlayer.Name), 3)
	elseif action == "ResetData" then
		local success = DataManagement.resetPlayerData(targetPlayer)

		if success then
			notifyAll(string.format("<font color=\"#FF00FF\">%s's data was reset by %s</font>", targetPlayer.Name, player.Name), 4)
		else
			warn("[TrollHandler] Failed to reset data for player:", targetPlayer.Name)
			NotificationEvent:FireClient(player, "<font color=\"#FF0000\">Failed to reset player's data. Please try again.</font>", 4)
		end
	end

	self._monetizationService:LogPurchase(player, productId, "TrollAction", action .. "->" .. targetUserId)
	return true
end

function TrollHandler:OnPurchaseFinished(player, productId, isPurchased)
end

return TrollHandler