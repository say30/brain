--[[
  Extracted from: ServerScriptService.Main.Player.ChatTags
  Class: Script
  Source file: rickdev.rbxlx
]]

local service = game:GetService("MarketplaceService")
local ServerScriptService = game:GetService("ServerScriptService")
local Configuration = require(ServerScriptService.Services.CmdrService.Configuration)
local chatServiceRunner = ServerScriptService:WaitForChild("ChatServiceRunner", math.huge)
local chatService = require(chatServiceRunner:WaitForChild("ChatService"))


local tags = {
	[0] = {TagText = "VIP", TagColor = Color3.fromRGB(255, 255, 0)},
}

chatService.SpeakerAdded:Connect(function(playerName)
	local speaker = chatService:GetSpeaker(playerName)
	local player = game.Players[playerName]
	local users = Configuration.GetAuthorizedUsers()
	warn(users)

	speaker:SetExtraData("Tags",{tags[0]})
	
end)

