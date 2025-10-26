--[[
  Extracted from: ReplicatedStorage.Shared.ConchTypes.LuckyBlock
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Conch = require(ReplicatedStorage.Packages.Conch)

local LuckyBlocks = {}

for Name, Data in pairs(require(ReplicatedStorage.Datas.Animals)) do
	if Data.LuckyBlock then
		table.insert(LuckyBlocks, Name)
	end
end

return Conch.register_type("LuckyBlock", Conch.args.enum_new(LuckyBlocks))
