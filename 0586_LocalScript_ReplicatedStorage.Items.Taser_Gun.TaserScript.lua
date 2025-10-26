--[[
  Extracted from: ReplicatedStorage.Items.Taser Gun.TaserScript
  Class: LocalScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: TaserScript, time of decompilation: Tue Jun 24 14:16:10 2025 ]]
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
    if v5(("ItemUse/TaserGun/%*"):format(l_Parent_1.Name), 5) then
        return;
    else
        local l_Target_0 = game.Players.LocalPlayer:GetMouse().Target;
        if not l_Target_0 then
            return;
        else
            local l_l_Target_0_FirstAncestorOfClass_0 = l_Target_0:FindFirstAncestorOfClass("Model");
            if not l_l_Target_0_FirstAncestorOfClass_0 then
                return;
            elseif not l_l_Target_0_FirstAncestorOfClass_0:FindFirstChildOfClass("Humanoid") then
                return;
            else
                v4:RemoteEvent("TaserGun/ShotPlayer"):FireServer(l_l_Target_0_FirstAncestorOfClass_0);
                return;
            end;
        end;
    end;
end);