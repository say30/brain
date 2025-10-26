--[[
  Extracted from: ReplicatedStorage.Controllers.EffectController.Effects.Blink
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local u1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("TweenService")
require(script:FindFirstAncestor("Effects").Parent.Types)
local v3 = {}
local _ = script.Name
local u4 = Instance.new("ColorCorrectionEffect")
u4.Brightness = 0
u4.TintColor = Color3.fromRGB(255, 255, 255)
u4.Parent = workspace.CurrentCamera
local u5 = v2:Create(u4, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
    ["Brightness"] = 0
})
function v3.Activate(_) --[[Anonymous function at line 19]]
    --[[
    Upvalues:
        [1] = u4
        [2] = u1
        [3] = u5
    --]]
    u4.Brightness = u1:GetAttribute("WaterEvent") and 2 or 1
    u5:Cancel()
    u5:Play()
end
return v3