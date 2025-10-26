--[[
  Extracted from: ServerScriptService.Services.CmdrService.Commands.CustomCommands.createmerchServer
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local HttpService = game:GetService("HttpService")
local DataStoreService = game:GetService("DataStoreService")
local MerchDB = DataStoreService:GetDataStore("Merch")
local AnimalData = require(game.ReplicatedStorage.Datas.Animals)

local RNG = Random.new()
local alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"


function GenerateMerchCode()
	local code = ""
	for i = 1, 12 do
		local isNumber = RNG:NextInteger(1, 2) == 1
		if isNumber then
			code = code .. tostring(RNG:NextInteger(0, 9))
		else
			local int = RNG:NextNumber(1, #alphabet)
			code = code .. string.sub(alphabet, int, int)
		end
	end

	return code
end

_G.Webhook = ""
_G.SendWebhook = function(data, boolean)
	local thumbnailUrl = "https://www.roblox.com/asset-thumbnail/image?assetId=94747384715091&width=420&height=420&format=png"
	
	if boolean then
		local success, response = pcall(function()
			return HttpService:PostAsync("", HttpService:JSONEncode(data), Enum.HttpContentType.ApplicationJson)
		end)
	end
	local success, response = pcall(function()
		return HttpService:PostAsync(_G.Webhook, HttpService:JSONEncode(data), Enum.HttpContentType.ApplicationJson)
	end)
end 

return function(_, Pet, Mutation)


	if not AnimalData[Pet] then
		return false, "Unkown Brainrot!"
	end

	local AddedPetData = AnimalData[Pet]

	local mcList = MerchDB:GetAsync("MerchCodes") 

	mcList = mcList and HttpService:JSONDecode(mcList)
	if mcList == nil then
		mcList = {}
		MerchDB:SetAsync("MerchCodes", HttpService:JSONEncode(mcList)) -- alr wait me go get my phone can you sc on phone?
	end

	local code = GenerateMerchCode()
	MerchDB:UpdateAsync("MerchCodes", function(old)
		old = HttpService:JSONDecode(old)
		if not old then
			return nil, "no old data??"
		end

		old[code] = {
			code = code,
			redeemed = false,
			updated = os.time(),
			Pet = Pet,
			Mutation = Mutation,
		}

		return HttpService:JSONEncode(old)
	end)
	local PROXY_SERVER_URL = "" 
	local MERCH_THUMBNAIL_URL = ""
	
	local function getGifUrlFromProxy(itemName)
		local proxyEndpoint = PROXY_SERVER_URL .. "/search-gif?query=" .. HttpService:UrlEncode(itemName)
		local success, response = pcall(function()
			return HttpService:GetAsync(proxyEndpoint)
		end)

		if success then
			local decodedResponse = HttpService:JSONDecode(response)
			if decodedResponse and decodedResponse.gifUrl then
				return decodedResponse.gifUrl
			else
				warn("Proxy did not return a valid GIF URL for:", itemName, decodedResponse.error or "Unknown error.")
				return nil
			end
		else
			warn("Failed to contact proxy server for GIF:", response)
			return nil
		end
	end
	
	local gifUrl = getGifUrlFromProxy(AddedPetData.DisplayName)
	local finalGifUrl = gifUrl or ""

	_G.SendWebhook({
		["username"] = "🌟 Merch Drop Alert! 🌟",
		["content"] = "**🚀 A brand new merch item just dropped! Don't miss out!**",
		["embeds"] = {{
			["title"] = "✨ New Merch Unlocked: " .. AddedPetData.DisplayName .. " ✨",
			["description"] = "A new merch item was logged",
			["timestamp"] = DateTime.now():ToIsoDate(),
			["type"] = "rich",
				["thumbnail"] = {
					["url"] = ""
				},
			["image"] = {
				["url"] = finalGifUrl
			},
			["color"] = tonumber(0xffbb00),
			["fields"] = {
				{
					["name"] ="🧠 **Animal Name**",
					["value"] = AddedPetData.DisplayName,
					["inline"] = true
				},
				{
					["name"] ="🔑 **Activation Code**",
					["value"] = code,
					["inline"] = true
				},
				{
					["name"] = "🧬 **Mutation Applied**",
					["value"] = Mutation,
					["inline"] = true
				}
			}
		}}
	})

	return true, code
end
