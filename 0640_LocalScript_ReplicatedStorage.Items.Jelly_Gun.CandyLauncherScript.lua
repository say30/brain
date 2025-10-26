--[[
  Extracted from: ReplicatedStorage.Items.Jelly Gun.CandyLauncherScript
  Class: LocalScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: CandyLauncherScript, time of decompilation: Sat Jul  5 18:09:38 2025 ]]
local _ = game:GetService("Players");
local _ = game:GetService("RunService");
local l_CollectionService_0 = game:GetService("CollectionService");
local l_ReplicatedStorage_0 = game:GetService("ReplicatedStorage");
local _ = l_ReplicatedStorage_0:WaitForChild("Models").ToolsExtras;
local l_Packages_0 = l_ReplicatedStorage_0:WaitForChild("Packages");
local v6 = require(l_Packages_0.Net);
local _ = require(l_Packages_0.Debounce);
local l_Parent_0 = script.Parent;
local l_Parent_1 = l_Parent_0.Parent.Parent;
l_Parent_0.Activated:Connect(function() --[[ Line: 19 ]]
    -- upvalues: l_Parent_1 (copy), l_CollectionService_0 (copy), v6 (copy), l_Parent_0 (copy)
    local l_l_Parent_1_Mouse_0 = l_Parent_1:GetMouse();
    l_l_Parent_1_Mouse_0.TargetFilter = table.unpack(l_CollectionService_0:GetTagged("ExcludeFromRaycast"));
	v6:RemoteEvent("CandlyLauncher/Launch"):FireServer(l_l_Parent_1_Mouse_0.Hit, l_Parent_0.Handle);
end);