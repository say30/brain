--[[
  Extracted from: ReplicatedStorage.Items.Cake Trap.CakeTrapScript
  Class: LocalScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: TrapScript, time of decompilation: Sat Jul  5 18:09:35 2025 ]]
local _ = game:GetService("StarterPlayer");
local l_ReplicatedStorage_0 = game:GetService("ReplicatedStorage");
local _ = game:GetService("ServerScriptService");
local l_Packages_0 = l_ReplicatedStorage_0:WaitForChild("Packages");
local v4 = require(l_Packages_0.Net);
local v5 = require(l_Packages_0.Debounce);
local l_Parent_0 = script.Parent;
local l_Parent_1 = l_Parent_0.Parent.Parent;
l_Parent_0.Activated:Connect(function() --[[ Line: 14 ]]
    -- upvalues: v5 (copy), l_Parent_1 (copy), v4 (copy)
    if v5(("ItemUse/PlaceTrapClient/%*"):format(l_Parent_1.Name), 2) then
        return;
    else
		v4:RemoteEvent("CakceTrap/Place"):FireServer();
        return;
    end;
end);