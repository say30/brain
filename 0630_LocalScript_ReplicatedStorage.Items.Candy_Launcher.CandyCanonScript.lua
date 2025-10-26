--[[
  Extracted from: ReplicatedStorage.Items.Candy Launcher.CandyCanonScript
  Class: LocalScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: PaintballScript, time of decompilation: Sat Jul  5 18:09:37 2025 ]]
local _ = game:GetService("StarterPlayer");
local l_CollectionService_0 = game:GetService("CollectionService");
local l_ReplicatedStorage_0 = game:GetService("ReplicatedStorage");
local _ = game:GetService("ServerScriptService");
local l_Packages_0 = l_ReplicatedStorage_0:WaitForChild("Packages");
local v5 = require(l_Packages_0.Net);
local l_Parent_0 = script.Parent;
local _ = l_Parent_0.Parent.Parent;
l_Parent_0.Activated:Connect(function() --[[ Line: 12 ]]
    -- upvalues: l_CollectionService_0 (copy), v5 (copy), l_Parent_0 (copy)
    local l_Mouse_0 = game.Players.LocalPlayer:GetMouse();
    l_Mouse_0.TargetFilter = table.unpack(l_CollectionService_0:GetTagged("ExcludeFromRaycast"));
    v5:RemoteEvent("UseItem"):FireServer(l_Mouse_0.Hit, l_Parent_0.Handle);
end);