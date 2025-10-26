--[[
  Extracted from: ServerScriptService.Services.LikeService
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

--!strict

local LikeService = {}

local HttpService = game:GetService("HttpService")
local ServerScriptService = game:GetService("ServerScriptService")

local AnimalService = require(ServerScriptService.Services.RoadAnimalService.RoadAnimalSpawner)
local LikeBoard = workspace.Map.Codes.Main.SurfaceGui.MainFrame.ProgressBar.Bar

local likeMilestone = 10 
local hasInitialized = false

local function formatWithCommas(num: number): string
	return tostring(num):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
end

function LikeService.Get()
	local success, response = pcall(function()
		local rawResponse = HttpService:GetAsync("https://games.roproxy.com/v1/games/".. game.GameId .."/votes")
		return HttpService:JSONDecode(rawResponse)
	end)

	if success and response and typeof(response) == "table" and response.upVotes then
		local currentLikes = response.upVotes
		
		if not hasInitialized then
			likeMilestone = math.floor(currentLikes / 10) * 10 + 10
			hasInitialized = true
		end
		
		while currentLikes >= likeMilestone do
			AnimalService:SpawnAnimalChances({["Cocofanto Elefanto"] = 75, ["Tralalero Tralala"] = 25})

			likeMilestone += 10
		end
		
		local previousMilestone = likeMilestone - 10
		local progressInSegment = currentLikes - previousMilestone
		local progressScale = math.clamp(progressInSegment / 10, 0, 1)

		LikeBoard.ProgressText.Text = string.format("%s / %s", formatWithCommas(currentLikes), formatWithCommas(likeMilestone))
		LikeBoard.Parent.Parent.Message.RequiredLikes.Text = string.format("%s LIKES", formatWithCommas(likeMilestone))
		LikeBoard.Progress.Size = UDim2.new(progressScale, 0, 1, 0)
	end
end

function LikeService:Start()
	if game.PrivateServerId ~= "" then
		LikeBoard.Parent.Parent.Message.Visible = false
		LikeBoard.Parent.Parent.ProgressBar.Visible = false
		LikeBoard.Parent.Parent.PrivateServerMessage.Visible = true

		return
	end
	
	LikeService.Get()

	while true do
		task.wait(60)
		LikeService.Get()
	end
end

return LikeService