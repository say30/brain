--[[
  Extracted from: ReplicatedStorage.Controllers.EventController.Events.Meowl.Map.OwlTree.LeavesAnimated.LeavesSway
  Class: Script
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2025-10-18 19:25:20
-- Luau version 6, Types version 3
-- Time taken: 0.000221 seconds

local any_LoadAnimation_result1 = script.Parent.AnimationController:WaitForChild("Animator"):LoadAnimation(script.Parent.AnimationController.LeavesSway)
any_LoadAnimation_result1.Looped = true
any_LoadAnimation_result1:Play()