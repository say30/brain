--[[
  Extracted from: ReplicatedStorage.Controllers.ItemController.FreezeRayController
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: FreezeRayController, time of decompilation: Sat Jul  5 18:09:12 2025 ]]
local l_Debris_0 = game:GetService("Debris");
local l_Players_0 = game:GetService("Players");
local _ = game:GetService("RunService");
local l_SoundService_0 = game:GetService("SoundService");
local l_TweenService_0 = game:GetService("TweenService");
local _ = game:GetService("CollectionService");
local l_ReplicatedStorage_0 = game:GetService("ReplicatedStorage");
local _ = game:GetService("ServerScriptService");
local l_Packages_0 = l_ReplicatedStorage_0:WaitForChild("Packages");
local v9 = require(l_Packages_0.Net);
local _ = require(l_Packages_0.Debounce);
local l_UI_0 = l_SoundService_0:WaitForChild("ToolsSounds").UI;
local l_LocalPlayer_0 = l_Players_0.LocalPlayer;
local l_MainFrame_0 = l_LocalPlayer_0.PlayerGui:WaitForChild("ToolsScreen").MainFrame;
local v14 = {};
local v15 = {};
v9:RemoteEvent("FreezeRay/Escape").OnClientEvent:Connect(function(v16) --[[ Line: 26 ]]
    -- upvalues: l_MainFrame_0 (copy), l_TweenService_0 (copy), l_UI_0 (copy), l_Debris_0 (copy), v9 (copy), v15 (copy), l_LocalPlayer_0 (copy)
    if v16 ~= "ShowTargets" then
        return;
    else
        for _ = 1, 10 do
            local v18 = script.Target:Clone();
            v18.Size = UDim2.new();
            v18.Position = UDim2.new(math.random(10, 90) / 100, 0, math.random(10, 90) / 100, 0);
            v18.Parent = l_MainFrame_0;
            l_TweenService_0:Create(v18, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
                Size = UDim2.new(0.079, 0, 0.125, 0)
            }):Play();
            local v19 = l_UI_0.FreezeRayShow:Clone();
            v19.Parent = l_UI_0;
            task.wait();
            v19:Play();
            l_Debris_0:AddItem(v19, 2);
            v18.MouseButton1Down:Connect(function() --[[ Line: 48 ]]
                -- upvalues: v9 (ref), v18 (copy), l_UI_0 (ref), l_Debris_0 (ref), v15 (ref)
                v9:RemoteEvent("FreezeRay/Escape"):FireServer();
                if v18 and v18.Parent then
                    local v20 = l_UI_0.FreezeRaySuccess:Clone();
                    v20.Parent = l_UI_0;
                    task.wait();
                    v20:Play();
                    l_Debris_0:AddItem(v20, 2);
                    table.remove(v15, table.find(v15, v18));
                    v18:Destroy();
                end;
            end);
            task.delay(math.random(4, 6), function() --[[ Line: 63 ]]
                -- upvalues: v18 (copy), v15 (ref), l_UI_0 (ref), l_Debris_0 (ref)
                if v18 and v18.Parent then
                    table.remove(v15, table.find(v15, v18));
                    v18:Destroy();
                    local v21 = l_UI_0.FreezeRayWrong:Clone();
                    v21.Parent = l_UI_0;
                    task.wait();
                    v21:Play();
                    l_Debris_0:AddItem(v21, 2);
                end;
            end);
            table.insert(v15, v18);
            if l_LocalPlayer_0:GetAttribute("StopFreeze") then
                for _, v23 in v15 do
                    if v23 and v23.Parent then
                        v23:Destroy();
                    end;
                end;
                table.clear(v15);
                return;
            else
                local v24 = math.random(1, 3) / 10;
                task.wait(0.7 + v24);
            end;
        end;
        return;
    end;
end);
return v14;