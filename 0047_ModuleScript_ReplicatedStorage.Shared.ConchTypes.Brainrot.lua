--[[
  Extracted from: ReplicatedStorage.Shared.ConchTypes.Brainrot
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Conch = require(ReplicatedStorage.Packages.Conch)

local Brainrots = {}

for Name, Data in pairs(require(ReplicatedStorage.Datas.Animals)) do
	if not Data.LuckyBlock then
		table.insert(Brainrots, Name)
	end
end

return Conch.register_type("Brainrot", Conch.args.enum_new(Brainrots))