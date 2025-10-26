--[[
  Extracted from: ReplicatedStorage.Controllers.ItemController.WebSlingerController
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: WebSlingerController, time of decompilation: Sat Jul  5 18:09:11 2025 ]]
local l_Players_0 = game:GetService("Players");
local _ = game:GetService("Lighting");
local _ = game:GetService("TweenService");
local l_ReplicatedStorage_0 = game:GetService("ReplicatedStorage");
local _ = l_Players_0.LocalPlayer;
local _ = workspace.CurrentCamera;
local l_Controllers_0 = l_ReplicatedStorage_0:WaitForChild("Controllers");
local _ = require(l_Controllers_0.CharacterController);
local l_Packages_0 = l_ReplicatedStorage_0:WaitForChild("Packages");
local _ = require(l_Packages_0.Net);
return {};