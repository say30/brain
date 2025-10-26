--[[
  Extracted from: ReplicatedStorage.Controllers.ItemController.NightVisionController
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: NightVisionController, time of decompilation: Sat Jul 12 14:21:20 2025 ]]
local l_Players_0 = game:GetService("Players");
local _ = game:GetService("Lighting");
local l_ReplicatedStorage_0 = game:GetService("ReplicatedStorage");
local l_LocalPlayer_0 = l_Players_0.LocalPlayer;
local l_Packages_0 = l_ReplicatedStorage_0:WaitForChild("Packages");
local v5 = require(l_Packages_0.Net):RemoteEvent("UseItem");
local l_NightVision_0 = script.NightVision;
local l_Nickname_0 = script.Nickname;
local v8 = false;
local v9 = {};
local function v15() --[[ Line: 19 ]] --[[ Name: Disable ]]
    -- upvalues: l_Players_0 (copy)
    for _, v11 in l_Players_0:GetPlayers() do
        task.spawn(function() --[[ Line: 21 ]]
            -- upvalues: v11 (copy)
            local v12 = v11.Character or v11.CharacterAdded:Wait();
            if v12 then
                for _, v14 in v12:GetDescendants() do
                    if v14.Name == "NightVisionGoogles" then
                        v14:Destroy();
                    end;
                end;
            end;
        end);
    end;
end;
local function v24(v16) --[[ Line: 34 ]] --[[ Name: CreateVisionPartsOnPlayer ]]
    -- upvalues: l_LocalPlayer_0 (copy), l_NightVision_0 (copy), l_Nickname_0 (copy)
    local v17 = v16.Character or v16.CharacterAdded:Wait();
    local l_Head_0 = v17:WaitForChild("Head");
	if v16.Name ~= l_LocalPlayer_0.Name then
        for _, v20 in v17:GetChildren() do
            if v20:IsA("BasePart") and v20:FindFirstChild("NightVisionGoogles") == nil then
                for v21 = 1, 6 do
                    local v22 = l_NightVision_0:Clone();
                    v22.Parent = v20;
                    v22.Face = v21 - 1;
                    v22.Name = "NightVisionGoogles";
                end;
            end;
        end;
        local v23 = l_Nickname_0:Clone();
        v23.TextLabel.Text = v16.Name;
        v23.Parent = l_Head_0;
        v23.Name = "NightVisionGoogles";
    end;
end;
local function v27() --[[ Line: 55 ]] --[[ Name: Enable ]]
    -- upvalues: l_Players_0 (copy), v24 (copy)
	for _, v26 in l_Players_0:GetPlayers() do
        task.spawn(function() --[[ Line: 57 ]]
            -- upvalues: v24 (ref), v26 (copy)
            v24(v26);
        end);
    end;
end;
v5.OnClientEvent:Connect(function(v28, v29) --[[ Line: 63 ]]
    -- upvalues: v15 (copy), v27 (copy), v8 (ref)
    if v28 ~= "EnableNightVision" then
        return;
    else
        if not v29 then
            v15();
        else
            v27();
        end;
        v8 = v29;
        return;
    end;
end);
l_Players_0.PlayerAdded:Connect(function(v30) --[[ Line: 75 ]]
    -- upvalues: v8 (ref), v24 (copy)
    if v8 then
        v24(v30);
    end;
end);
v9.Enable = v27;
v9.Disable = v15;
return v9;