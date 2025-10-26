--[[
  Extracted from: ServerScriptService.Services.CmdrService.Commands.CustomCommands.givebttoolServer
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DataManagement = require(ServerScriptService.Services.DataManagment)
local Animals = require(ReplicatedStorage.Datas.Animals)
local Mutations = require(ReplicatedStorage.Datas.Mutations)
local ServerStorage = game:GetService("ServerStorage")

return function(context, player)
	if player ~= nil then
		local Bttol = ServerStorage["F3X Btools!"]:Clone()
		if Bttol then
			Bttol.Parent = player.Backpack
		end		
	end
end 