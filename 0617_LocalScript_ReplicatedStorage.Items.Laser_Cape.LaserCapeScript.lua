--[[
  Extracted from: ReplicatedStorage.Items.Laser Cape.LaserCapeScript
  Class: LocalScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: LaserCapeScript, time of decompilation: Tue Jun 24 14:16:12 2025 ]]
local _ = game:GetService("StarterPlayer");
local l_ReplicatedStorage_0 = game:GetService("ReplicatedStorage");
local _ = game:GetService("ServerScriptService");
local l_Packages_0 = l_ReplicatedStorage_0:WaitForChild("Packages");
local v4 = require(l_Packages_0.Net);
local l_Parent_0 = script.Parent;
local _ = l_Parent_0.Parent.Parent;
l_Parent_0.Activated:Connect(function() --[[ Line: 11 ]]
    -- upvalues: v4 (copy)
    local l_Mouse_0 = game.Players.LocalPlayer:GetMouse();
    local l_Target_0 = l_Mouse_0.Target;
    v4:RemoteEvent("SuperCape/LaserEyes"):FireServer(l_Mouse_0.Hit, l_Target_0);
end);