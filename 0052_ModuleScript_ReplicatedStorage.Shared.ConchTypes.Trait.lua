--[[
  Extracted from: ReplicatedStorage.Shared.ConchTypes.Trait
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Conch = require(ReplicatedStorage.Packages.Conch)

require(ReplicatedStorage.Datas.Animals)

local Traits = {}

for Trait in pairs(require(ReplicatedStorage.Datas.Traits)) do
	table.insert(Traits, Trait)
end

return Conch.register_type("Trait", Conch.args.enum_new(Traits))