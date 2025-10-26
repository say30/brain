--[[
  Extracted from: ReplicatedStorage.Shared.ConchTypes.ServerLuck
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Conch = require(ReplicatedStorage.Packages.Conch)

local ServerLucks = {}

for Name, Data in pairs(require(ReplicatedStorage.Datas.ServerLuck)) do
	ServerLucks[tostring(Data.Multiplier)] = Name
end

return Conch.register_type("ServerLuck", Conch.args.enum_map(ServerLucks))
