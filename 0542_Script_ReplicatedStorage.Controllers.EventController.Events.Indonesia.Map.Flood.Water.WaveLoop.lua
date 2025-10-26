--[[
  Extracted from: ReplicatedStorage.Controllers.EventController.Events.Indonesia.Map.Flood.Water.WaveLoop
  Class: Script
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2025-10-18 19:25:23
-- Luau version 6, Types version 3
-- Time taken: 0.000367 seconds

local any_LoadAnimation_result1 = script.Parent.AnimationController:WaitForChild("Animator"):LoadAnimation(script.Parent.AnimationController.WaveLoop)
any_LoadAnimation_result1.Looped = true
any_LoadAnimation_result1:Play()
any_LoadAnimation_result1:AdjustSpeed(0.33)