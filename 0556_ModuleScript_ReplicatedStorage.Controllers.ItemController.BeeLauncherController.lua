--[[
  Extracted from: ReplicatedStorage.Controllers.ItemController.BeeLauncherController
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: BeeLauncherController, time of decompilation: Sat Jul  5 18:09:11 2025 ]]
local l_Players_0 = game:GetService("Players");
local l_Lighting_0 = game:GetService("Lighting");
local l_ReplicatedStorage_0 = game:GetService("ReplicatedStorage");
local l_PlayerScripts_0 = l_Players_0.LocalPlayer.PlayerScripts;
local l_CurrentCamera_0 = workspace.CurrentCamera;
local l_Controls_0 = require(l_PlayerScripts_0:WaitForChild("PlayerModule")):GetControls();
local l_Packages_0 = l_ReplicatedStorage_0:WaitForChild("Packages");
local v7 = require(l_Packages_0.Net);
local l_Buzzing_0 = script.Buzzing;
local v9 = v7:RemoteEvent("UseItem");
local l_moveFunction_0 = l_Controls_0.moveFunction;
local v11 = {};
v9.OnClientEvent:Connect(function(v12) --[[ Line: 23 ]]
    -- upvalues: l_CurrentCamera_0 (copy), l_Buzzing_0 (copy), l_Controls_0 (copy), l_Lighting_0 (copy), l_moveFunction_0 (copy)
    if v12 ~= "Bee Attack" then
        return;
    else
        l_CurrentCamera_0.FieldOfView = 20;
        l_Buzzing_0:Play();
        l_Controls_0.moveFunction = function(v13, v14, v15) --[[ Line: 30 ]]
            v13:Move(-v14, v15);
        end;
        local v16 = script.ColorCorrection:Clone();
        v16.Parent = l_Lighting_0;
        local l_BlurEffect_0 = Instance.new("BlurEffect");
        l_BlurEffect_0.Size = 10;
        l_BlurEffect_0.Name = "BeeBlur";
        l_BlurEffect_0.Parent = l_Lighting_0;
        task.delay(5, function() --[[ Line: 42 ]]
            -- upvalues: l_Controls_0 (ref), l_moveFunction_0 (ref), l_CurrentCamera_0 (ref), v16 (copy), l_BlurEffect_0 (copy)
            l_Controls_0.moveFunction = l_moveFunction_0;
            l_CurrentCamera_0.FieldOfView = 70;
            v16:Destroy();
            l_BlurEffect_0:Destroy();
        end);
        return;
    end;
end);
return v11;