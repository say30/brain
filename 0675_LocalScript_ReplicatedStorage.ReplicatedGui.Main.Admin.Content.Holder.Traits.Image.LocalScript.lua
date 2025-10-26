--[[
  Extracted from: ReplicatedStorage.ReplicatedGui.Main.Admin.Content.Holder.Traits.Image.LocalScript
  Class: LocalScript
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Traits = require(ReplicatedStorage.Datas.Traits)
local TraitIcons = {}

for _, traitData in pairs(Traits) do
	table.insert(TraitIcons, traitData.Icon)
end

local ImageLabel = script.Parent

spawn(function()
	local index = 1
	while true do
		ImageLabel.Image = TraitIcons[index]

		index = index + 1
		if index > #TraitIcons then
			index = 1
		end

		task.wait(1)
	end
end)
