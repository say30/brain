--[[
  Extracted from: ReplicatedStorage.Datas.Shop
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local v1 = game:GetService("ReplicatedStorage")
local u2 = game:GetService("ServerScriptService")
local v3 = v1.Packages
require(v3.Synchronizer)
local v4 = {
	[3312891057] = {
		["Display"] = "[Rainbow Machine] Fill Now",
		["Callback"] = function(_) --[[Function name: Callback, line 37]]
			return false
		end,
		["Type"] = "RainbowMachine"
	},
	[3337520317] = {
		["Display"] = "[Bubblegum Machine] Fill Now",
		["Callback"] = function(_) --[[Function name: Callback, line 51]]
			return false
		end,
		["Type"] = "RainbowMachine"
	},
	[3312944986] = {
		["Display"] = "1x Spin (Rainbow Wheel)",
		["Identifier"] = "x1",
		["Type"] = "RainbowSpinWheel",
		["Value"] = 1
	},
	[3312945232] = {
		["Display"] = "1x Spin (Rainbow Wheel) DISCOUNT",
		["Identifier"] = "x1",
		["Type"] = "RainbowSpinWheel",
		["Value"] = 1
	},
	[3312945488] = {
		["Display"] = "3x Spins (Rainbow Wheel)",
		["Identifier"] = "x3",
		["Type"] = "RainbowSpinWheel",
		["Value"] = 3
	},
	[3312944807] = {
		["Display"] = "10x Spins (Rainbow Wheel)",
		["Identifier"] = "x10",
		["Type"] = "RainbowSpinWheel",
		["Value"] = 10
	},
	[3307371795] = {
		["Display"] = "1x Spin (Bloodmoon Wheel)",
		["Identifier"] = "x1",
		["Type"] = "BloodmoonWheelSpin",
		["Value"] = 1
	},
	[3307372046] = {
		["Display"] = "1x Spin (Bloodmoon Wheel) DISCOUNT",
		["Identifier"] = "x1",
		["Type"] = "BloodmoonWheelSpin",
		["Value"] = 1
	},
	[3307372342] = {
		["Display"] = "3x Spins (Bloodmoon Wheel)",
		["Identifier"] = "x3",
		["Type"] = "BloodmoonWheelSpin",
		["Value"] = 3
	},
	[3307372798] = {
		["Display"] = "10x Spins (Bloodmoon Wheel)",
		["Identifier"] = "x10",
		["Type"] = "BloodmoonWheelSpin",
		["Value"] = 10
	},
	[3322567440] = {
		["Display"] = "1x Spin (Candy Wheel)",
		["Identifier"] = "x1",
		["Type"] = "CandyWheelSpin",
		["Value"] = 1
	},
	[3322568083] = {
		["Display"] = "1x Spin (Candy Wheel) DISCOUNT",
		["Identifier"] = "x1",
		["Type"] = "CandyWheelSpin",
		["Value"] = 1
	},
	[3322567771] = {
		["Display"] = "3x Spins (Candy Wheel)",
		["Identifier"] = "x3",
		["Type"] = "CandyWheelSpin",
		["Value"] = 3
	},
	[3322567871] = {
		["Display"] = "10x Spins (Candy Wheel)",
		["Identifier"] = "x10",
		["Type"] = "CandyWheelSpin",
		["Value"] = 10
	},
	[3345489415] = {
		["Display"] = "1x Spin (Molten Wheel)",
		["Identifier"] = "x1",
		["Type"] = "MoltenWheelSpin",
		["Value"] = 1
	},
	[3345489701] = {
		["Display"] = "1x Spin (Molten Wheel) DISCOUNT",
		["Identifier"] = "x1",
		["Type"] = "MoltenWheelSpin",
		["Value"] = 1
	},
	[3345489943] = {
		["Display"] = "3x Spins (Molten Wheel)",
		["Identifier"] = "x3",
		["Type"] = "MoltenWheelSpin",
		["Value"] = 3
	},
	[3345489151] = {
		["Display"] = "10x Spins (Molten Wheel)",
		["Identifier"] = "x10",
		["Type"] = "MoltenWheelSpin",
		["Value"] = 10
	},
	[3377020181] = {
		["Display"] = "1x Spin (Galaxy Wheel)",
		["Identifier"] = "x1",
		["Type"] = "GalaxyWheelSpin",
		["Value"] = 1
	},
	[3377020567] = {
		["Display"] = "1x Spin (Galaxy Wheel) DISCOUNT",
		["Identifier"] = "x1",
		["Type"] = "GalaxyWheelSpin",
		["Value"] = 1
	},
	[3377021022] = {
		["Display"] = "3x Spins (Galaxy Wheel)",
		["Identifier"] = "x3",
		["Type"] = "GalaxyWheelSpin",
		["Value"] = 3
	},
	[3377020761] = {
		["Display"] = "10x Spins (Galaxy Wheel)",
		["Identifier"] = "x10",
		["Type"] = "GalaxyWheelSpin",
		["Value"] = 10
	},
	[3296448740] = {
		["Display"] = "2x Server Luck",
		["Type"] = "ServerLuck",
		["Index"] = 1
	},
	[3296448922] = {
		["Display"] = "4x Server Luck",
		["Type"] = "ServerLuck",
		["Index"] = 2
	},
	[3296367737] = {
		["Display"] = "VIP",
		["Type"] = "GamepassProduct"
	},
	[3296367604] = {
		["Display"] = "Admin Commands",
		["Attribute"] = "AdminCommands",
		["Type"] = "GamepassProduct"
	},
	[3296367825] = {
		["Display"] = "2x Money",
		["Attribute"] = "2xMoney",
		["Type"] = "GamepassProduct"
	},
	[3290160693] = {
		["Display"] = "Cash Pack #1",
		["Type"] = "Coins",
		["Value"] = 3000
	},
	[3290160783] = {
		["Display"] = "Cash Pack #2",
		["Type"] = "Coins",
		["Value"] = 25000
	},
	[3290160857] = {
		["Display"] = "Cash Pack #3",
		["Type"] = "Coins",
		["Value"] = 100000
	},
	[3290160954] = {
		["Display"] = "Cash Pack #4",
		["Type"] = "Coins",
		["Value"] = 500000
	},
	[3290161030] = {
		["Display"] = "Cash Pack #5",
		["Type"] = "Coins",
		["Value"] = 1000000
	},
	[3290152459] = {
		["Display"] = "Blackhole Slap",
		["Type"] = "Item"
	},
	[3290152552] = {
		["Display"] = "Laser Gun",
		["Type"] = "Item"
	},
	[3290152513] = {
		["Display"] = "Flying Carpet",
		["Type"] = "Item"
	},
	[3290152611] = {
		["Display"] = "Ban Hammer",
		["Type"] = "Item"
	},
	[1227013099] = {
		["Display"] = "Admin Commands",
		["Attribute"] = "AdminCommands",
		["Type"] = "Gamepass"
	},
	[1229510262] = {
		["Display"] = "VIP",
		["Type"] = "Gamepass"
	},
	[1228591447] = {
		["Display"] = "2x Money",
		["Attribute"] = "2xMoney",
		["Type"] = "Gamepass"
	}
}
local v5 = {
	["Display"] = "Starter Pack",
	["Type"] = "StarterPack",
	["Rewards"] = {
		["Items"] = { "Blackhole Slap", "Coil Combo" },
		["Animals"] = { "Brr Brr Patapim" },
		["Coins"] = 1000
	}
}
v4[3290334159] = v5
v4[3301638537] = {
	["Display"] = "Unlock Base",
	["Type"] = "UnlockBase"
}
v4[3312023518] = {
	["Display"] = "Unlock First Floor",
	["Type"] = "UnlockBase"
}
v4[3312023590] = {
	["Display"] = "Unlock Second Floor",
	["Type"] = "UnlockBase"
}
v4[3312023715] = {
	["Display"] = "Unlock Third Floor",
	["Type"] = "UnlockBase"
}
v4[3329528158] = {
	["Display"] = "Mythic Lucky Block",
	["Type"] = "LuckyBlock",
	["Value"] = "Mythic Lucky Block"
}
v4[3329527999] = {
	["Display"] = "Brainrot God Lucky Block",
	["Type"] = "LuckyBlock",
	["Value"] = "Brainrot God Lucky Block"
}
v4[3329528437] = {
	["Display"] = "Secret Lucky Block",
	["Type"] = "LuckyBlock",
	["Value"] = "Secret Lucky Block"
}
v4[3354160217] = {
	["Display"] = "Reveal Now",
	["Type"] = "FuseMachineRevealNow",
	["Callback"] = function(p6) --[[Function name: Callback, line 361]]
        --[[
        Upvalues:
            [1] = u2
        --]]
		return require(u2.Services.FuseMachineService):PurchaseRevealNow(p6)
	end
}
return v4