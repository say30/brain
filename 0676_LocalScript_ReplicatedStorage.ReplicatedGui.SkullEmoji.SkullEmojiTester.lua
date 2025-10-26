--[[
  Extracted from: ReplicatedStorage.ReplicatedGui.SkullEmoji.SkullEmojiTester
  Class: LocalScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local v1 = game:GetService("ReplicatedStorage")
local v2 = require(v1.Controllers.SkullEmojiEffectController)
task.wait(1)
while true do
    v2:Play()
    task.wait(4)
end