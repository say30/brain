--[[
  Extracted from: ReplicatedStorage.Controllers.ItemController.CandyLauncherController
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: CandyLauncherController, time of decompilation: Sat Jul  5 18:09:12 2025 ]]
local l_Players_0 = game:GetService("Players");
local l_Lighting_0 = game:GetService("Lighting");
local l_ReplicatedStorage_0 = game:GetService("ReplicatedStorage");
local l_PlayerScripts_0 = l_Players_0.LocalPlayer.PlayerScripts;
local l_CurrentCamera_0 = workspace.CurrentCamera;
local _ = require(l_PlayerScripts_0:WaitForChild("PlayerModule")):GetControls();
local l_Packages_0 = l_ReplicatedStorage_0:WaitForChild("Packages");
local v7 = require(l_Packages_0.Net):RemoteEvent("CandlyLauncher/Launch");
local v8 = {};
v7.OnClientEvent:Connect(function(v9) --[[ Line: 19 ]]
    -- upvalues: l_CurrentCamera_0 (copy), l_Lighting_0 (copy)
    if v9 ~= "TurnIntoJelly" then
        return;
    else
        l_CurrentCamera_0.FieldOfView = 20;
        local v10 = script.ColorCorrection:Clone();
        v10.Parent = l_Lighting_0;
        task.delay(5, function() --[[ Line: 28 ]]
            -- upvalues: l_CurrentCamera_0 (ref), v10 (copy)
            l_CurrentCamera_0.FieldOfView = 70;
            v10:Destroy();
        end);
        return;
    end;
end);
return v8;