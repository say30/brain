--[[
  Extracted from: ReplicatedStorage.Datas.MoltenSpinWheel
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local v1 = {
	["Rewards"] = {
		{
			["Type"] = "Animal",
			["Display"] = "<stroke thickness=\'2\'><font color=\'#ff0000\'>Lava</font>\nOrcalero Orcala\n<font color=\'#2bff5c\'>$400K/s</font></stroke>",
			["Icon"] = "rbxassetid://71180207409611",
			["Index"] = "Orcalero Orcala",
			["Mutation"] = "Lava",
			["Weight"] = 1
		},
		{
			["Type"] = "Cash-Pack",
			["Display"] = "Cash Pack #2",
			["Index"] = 3290160783,
			["Weight"] = 55
		},
		{
			["Type"] = "Cash-Pack",
			["Display"] = "Cash Pack #3",
			["Index"] = 3290160857,
			["Weight"] = 34
		},
		{
			["Type"] = "Item",
			["Display"] = "Lava Slap",
			["Icon"] = "rbxassetid://80560167115825",
			["Index"] = "Lava Slap",
			["Weight"] = 0.5
		},
		{
			["Type"] = "Cash-Pack",
			["Display"] = "Cash Pack #5",
			["Index"] = 3290161030,
			["Weight"] = 7.5
		},
		{
			["Type"] = "Server-Luck",
			["Icon"] = "rbxassetid://133438845174247",
			["Display"] = "6x Server Luck\n15m",
			["Index"] = 1,
			["Weight"] = 2
		}
	}
}
local v2 = {
	[4] = {
		["Type"] = "Item",
		["Display"] = "Lava Blaster",
		["Icon"] = "rbxassetid://204508521",
		["Index"] = "Lava Blaster",
		["Weight"] = 0.5
	}
}
v1.AltRewards = v2
return v1