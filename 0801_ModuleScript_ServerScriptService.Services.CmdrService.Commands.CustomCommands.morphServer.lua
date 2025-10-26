--[[
  Extracted from: ServerScriptService.Services.CmdrService.Commands.CustomCommands.morphServer
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local DataManagement = require(ServerScriptService.Services.DataManagment)
local Animals = require(ReplicatedStorage.Datas.Animals)
local Mutations = require(ReplicatedStorage.Datas.Mutations)



return function(context,player,targetplayer)
	local targetUserId = Players:GetUserIdFromNameAsync(targetplayer)
	if not targetUserId then
		return false,"Make Sure You Put the right username Not Display."
	end
	
	local Character = player.Character
		if not Character then
			return
		end

		local Humanoid, HumanoidRootPart = Character:WaitForChild("Humanoid"), Character:WaitForChild("HumanoidRootPart")
		if not Humanoid or not HumanoidRootPart then
			return
		end

		local Appearance = Players:GetHumanoidDescriptionFromUserId(targetUserId)
		if not Appearance then
			return
		end

		pcall(function()
			Humanoid:ApplyDescription(Appearance)
		end)

	return "Succesfully Morphed to"..targetplayer
end 