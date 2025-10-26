--[[
  Extracted from: ReplicatedStorage.Controllers.ItemController
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: ItemController, time of decompilation: Sat Jul  5 18:09:11 2025 ]]
local l_Players_0 = game:GetService("Players");
local _ = game:GetService("StarterGui");
local l_ReplicatedStorage_0 = game:GetService("ReplicatedStorage");
local l_Packages_0 = l_ReplicatedStorage_0:WaitForChild("Packages");
local v4 = require(l_Packages_0.Net);
local v5 = require(l_ReplicatedStorage_0.Controllers.BackpackController);
local l_LocalPlayer_0 = l_Players_0.LocalPlayer;
local l_PlayerGui_0 = l_LocalPlayer_0.PlayerGui;
local l_Backpack_0 = l_LocalPlayer_0.Backpack;
local l_Backpack_1 = l_PlayerGui_0:WaitForChild("BackpackGui").Backpack;
local l_Hotbar_0 = l_Backpack_1.Hotbar;
local _ = l_Backpack_1.Inventory;
local l_Highlight_0 = Instance.new("Highlight");
l_Highlight_0.Name = "MainHighlight";
l_Highlight_0.DepthMode = Enum.HighlightDepthMode.Occluded;
l_Highlight_0.FillColor = Color3.fromRGB(255, 0, 0);
l_Highlight_0.FillTransparency = 0.5;
l_Highlight_0.OutlineColor = Color3.fromRGB(155, 0, 0);
l_Highlight_0.OutlineTransparency = 0.8;
l_Highlight_0.Parent = workspace;
l_Highlight_0.Adornee = script;
local v13 = {};
local function v21(v14) --[[ Line: 30 ]] --[[ Name: CooldownFunction ]]
    -- upvalues: l_Hotbar_0 (copy)
    local l_v14_Attribute_0 = v14:GetAttribute("CurrentSlot");
    local v16 = tonumber(v14:GetAttribute("CooldownTime") or 0);
    local l_l_Hotbar_0_FirstChild_0 = l_Hotbar_0:FindFirstChild(l_v14_Attribute_0);
    if not l_l_Hotbar_0_FirstChild_0 then
        return;
    else
        local l_Icon_0 = l_l_Hotbar_0_FirstChild_0:FindFirstChild("Icon");
        if not l_Icon_0 then
            return;
        else
            local v19 = v16 > 0;
            local l_CooldownTextLabel_0 = l_Icon_0:FindFirstChild("CooldownTextLabel");
            if l_CooldownTextLabel_0 then
                l_CooldownTextLabel_0.Text = v16;
                l_CooldownTextLabel_0.Visible = v19;
            end;
            l_Icon_0.ImageColor3 = v19 and Color3.fromRGB(90, 90, 90) or Color3.fromRGB(255, 255, 255);
            return;
        end;
    end;
end;
local function v23(v22) --[[ Line: 54 ]] --[[ Name: SetupTool ]]
    -- upvalues: v21 (copy)
    v22:GetAttributeChangedSignal("CooldownTime"):Connect(function() --[[ Line: 55 ]]
        -- upvalues: v21 (ref), v22 (copy)
        v21(v22);
    end);
    v22:GetAttributeChangedSignal("CurrentSlot"):Connect(function() --[[ Line: 59 ]]
        -- upvalues: v21 (ref), v22 (copy)
        v21(v22);
    end);
end;
v13.Load = function(_) --[[ Line: 64 ]] --[[ Name: Load ]]
    for _, v26 in script:GetChildren() do
        if v26:IsA("ModuleScript") then
            local l_status_0, l_result_0 = pcall(require, v26);
            if l_status_0 and l_result_0 and l_result_0.Start then
                l_result_0:Start();
            end;
        end;
    end;
end;
v13.Start = function(_) --[[ Line: 77 ]] --[[ Name: Start ]]
    -- upvalues: v5 (copy), l_LocalPlayer_0 (copy), l_Backpack_0 (copy), v23 (copy), v4 (copy)
    local function v30() --[[ Line: 78 ]] --[[ Name: updateBlockTools ]]
        -- upvalues: v5 (ref), l_LocalPlayer_0 (ref)
        v5:SetEnabled("BlockTools", not l_LocalPlayer_0:GetAttribute("BlockTools"));
    end;
    l_LocalPlayer_0:GetAttributeChangedSignal("BlockTools"):Connect(v30);
    task.spawn(v30);
    for _, v32 in l_Backpack_0:GetChildren() do
        if v32:IsA("Tool") then
            task.spawn(v23, v32);
        end;
    end;
    l_Backpack_0.ChildAdded:Connect(function(v33) --[[ Line: 91 ]]
        -- upvalues: v23 (ref)
        if v33:IsA("Tool") then
            v23(v33);
        end;
    end);
    v4:RemoteEvent("Tools/Cooldown").OnClientEvent:Connect(function(v34, v35) --[[ Line: 97 ]]
        for v36 = v35, 0, -1 do
            v34:SetAttribute("CooldownTime", v36);
            task.wait(1);
        end;
        v34:SetAttribute("CooldownTime", nil);
    end);
end;
return v13;