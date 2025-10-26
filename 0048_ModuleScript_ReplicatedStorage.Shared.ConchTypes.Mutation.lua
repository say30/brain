--[[
  Extracted from: ReplicatedStorage.Shared.ConchTypes.Mutation
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Conch = require(ReplicatedStorage.Packages.Conch)

local MutationTypes = {"Normal"}

for Mutations in pairs(require(ReplicatedStorage.Datas.Mutations)) do
	table.insert(MutationTypes, Mutations)
end

return Conch.register_type("Mutation", Conch.args.enum_new(MutationTypes))