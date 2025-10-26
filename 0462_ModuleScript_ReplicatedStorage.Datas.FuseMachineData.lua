--[[
  Extracted from: ReplicatedStorage.Datas.FuseMachineData
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Thanks For Angelus Decompiles --> https://discord.gg/CYXme7yEG9

-- Decompiled with Velocity Script Decompiler
local v1 = game:GetService("ReplicatedStorage")
local v2 = require(v1.Packages.Net)
local v3 = {
    ["FuseSlots"] = 4,
    ["FuseTime"] = {
        ["Common"] = 1,
        ["Rare"] = 1,
        ["Epic"] = 1,
        ["Legendary"] = 1,
        ["Mythic"] = 1,
        ["Brainrot God"] = 1,
        ["Secret"] = 1
    },
    ["RevealNowProductId"] = 3354160217,
    ["FFlagDefaults"] = {
        ["FuseMachine/Disabled"] = false,
        ["FuseMachine/CanStealBrainrot"] = true,
        ["FuseMachine/CostMultiplier"] = 1.25
    },
    ["Remotes"] = {
        ["RemoveBrainrot"] = v2:RemoteFunction("FuseMachine/RemoveBrainrot"),
        ["ClaimBrainrot"] = v2:RemoteFunction("FuseMachine/ClaimBrainrot"),
        ["ConfirmFusion"] = v2:RemoteFunction("FuseMachine/ConfirmFusion"),
        ["Delivery"] = v2:RemoteFunction("FuseMachine/Delivery"),
        ["FuseAnimation"] = v2:RemoteEvent("FuseMachine/FuseAnimation")
    }
}
return v3