--[[
  Extracted from: ReplicatedStorage.Items.Subspace Mine.SubspaceMineScript
  Class: LocalScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

game:GetService("StarterPlayer")
local v1 = game:GetService("ReplicatedStorage")
game:GetService("ServerScriptService")
local v2 = v1:WaitForChild("Packages")
local u3 = require(v2.Net)
require(v2.Debounce)
local v4 = script.Parent
local _ = v4.Parent.Parent
v4.Activated:Connect(function() --[[Anonymous function at line 14]]
    --[[
    Upvalues:
        [1] = u3
    --]]
    u3:RemoteEvent("UseItem"):FireServer()
end)