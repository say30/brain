--[[
  Extracted from: ReplicatedStorage.Items.Boogie Bomb.BoogieScript
  Class: LocalScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: BoogieScript, time of decompilation: Tue Jun 24 14:16:10 2025 ]]
local _ = game:GetService("RunService");
local _ = game:GetService("TweenService");
local _ = game:GetService("StarterPlayer");
local l_ReplicatedStorage_0 = game:GetService("ReplicatedStorage");
local _ = game:GetService("ServerScriptService");
local _ = l_ReplicatedStorage_0:WaitForChild("Models").ToolsExtras;
local l_Packages_0 = l_ReplicatedStorage_0:WaitForChild("Packages");
local v7 = require(l_Packages_0.Net);
local v8 = require(l_Packages_0.Debounce);
local l_Parent_0 = script.Parent;
local l_Parent_1 = l_Parent_0.Parent.Parent;
l_Parent_0.Activated:Connect(function() --[[ Line: 20 ]]
    -- upvalues: v8 (copy), l_Parent_1 (copy), v7 (copy)
    if v8(("ItemUse/BoogieTimeThrow/%*"):format(l_Parent_1.Name), 10) then
        return;
    else
        v7:RemoteEvent("BoogieBomb/Throw"):FireServer();
        return;
    end;
end);