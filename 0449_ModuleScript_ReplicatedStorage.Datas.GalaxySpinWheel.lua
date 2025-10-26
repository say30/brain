--[[
  Extracted from: ReplicatedStorage.Datas.GalaxySpinWheel
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local v1 = {
    ["Rewards"] = {
        {
            ["Type"] = "Animal",
            ["Display"] = "<stroke thickness=\'2\'><font color=\'#9220d5\'>Galaxy</font>\nBisonte Giuppitere\n<font color=\'#2bff5c\'>$300K/s</font></stroke>",
            ["Icon"] = "rbxassetid://81188989177592",
            ["Index"] = "Bisonte Giuppitere",
            ["Mutation"] = "Galaxy",
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
            ["Display"] = "Alien Slap",
            ["Icon"] = "rbxassetid://89070555394271",
            ["Index"] = "Alien Slap",
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
            ["Icon"] = "rbxassetid://98903143335097",
            ["Display"] = "2x Server Luck\n15m",
            ["Index"] = 1,
            ["Weight"] = 2
        }
    }
}
local v2 = {
    [4] = {
        ["Type"] = "Item",
        ["Display"] = "Blackhole Bomb",
        ["Icon"] = "rbxassetid://27295735",
        ["Index"] = "Blackhole Bomb",
        ["Weight"] = 0.5
    }
}
v1.AltRewards = v2
return v1