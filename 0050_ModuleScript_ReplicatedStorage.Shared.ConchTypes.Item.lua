--[[
  Extracted from: ReplicatedStorage.Shared.ConchTypes.Item
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Conch = require(ReplicatedStorage.Packages.Conch)

require(ReplicatedStorage.Datas.Animals)
require(ReplicatedStorage.Datas.Items)

local Items = {}

for _, Item in ipairs(ReplicatedStorage.Items:GetChildren()) do
	table.insert(Items, Item.Name)
end

return Conch.register_type("Item", Conch.args.enum_new(Items))