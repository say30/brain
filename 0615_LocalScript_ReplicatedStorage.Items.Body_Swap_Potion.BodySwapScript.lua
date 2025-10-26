--[[
  Extracted from: ReplicatedStorage.Items.Body Swap Potion.BodySwapScript
  Class: LocalScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: BodySwapScript, time of decompilation: Tue Jun 24 14:16:14 2025 ]]
local l_Players_0 = game:GetService("Players");
local l_RunService_0 = game:GetService("RunService");
local l_ReplicatedStorage_0 = game:GetService("ReplicatedStorage");
local _ = l_ReplicatedStorage_0:WaitForChild("Models").ToolsExtras;
local l_Packages_0 = l_ReplicatedStorage_0:WaitForChild("Packages");
local v5 = require(l_Packages_0.Net);
local v6 = require(l_Packages_0.Debounce);
local l_Parent_0 = script.Parent;
local l_Parent_1 = l_Parent_0.Parent.Parent;
local l_Highlight_0 = Instance.new("Highlight");
l_Highlight_0.DepthMode = Enum.HighlightDepthMode.Occluded;
l_Highlight_0.FillColor = Color3.fromRGB(255, 0, 0);
l_Highlight_0.FillTransparency = 0.5;
l_Highlight_0.OutlineColor = Color3.fromRGB(155, 0, 0);
l_Highlight_0.OutlineTransparency = 0.8;
l_Highlight_0.Parent = workspace;
l_Highlight_0.Adornee = script;
local v10 = nil;
local function v20() --[[ Line: 30 ]] --[[ Name: GetNearestPlayer ]]
    -- upvalues: l_Parent_1 (copy), l_Players_0 (copy)
    local l_Character_0 = l_Parent_1.Character;
    if not l_Character_0 then
        return;
    else
        local l_HumanoidRootPart_0 = l_Character_0:FindFirstChild("HumanoidRootPart");
        if not l_HumanoidRootPart_0 then
            return;
        else
            local v13 = nil;
            local v14 = 1e999;
            for _, v16 in l_Players_0:GetPlayers() do
                if v16 ~= l_Parent_1 then
                    local l_Character_1 = v16.Character;
                    local v18 = l_Character_1 and l_Character_1:FindFirstChild("HumanoidRootPart");
                    if v18 then
                        local l_Magnitude_0 = (l_HumanoidRootPart_0.Position - v18.Position).Magnitude;
                        if l_Magnitude_0 <= 50 and l_Magnitude_0 < v14 then
                            v14 = l_Magnitude_0;
                            v13 = l_Character_1;
                        end;
                    end;
                end;
            end;
            return v13, l_Players_0:GetPlayerFromCharacter(v13);
        end;
    end;
end;
l_Parent_0.Activated:Connect(function() --[[ Line: 60 ]]
    -- upvalues: v6 (copy), l_Parent_1 (copy), v5 (copy), v10 (ref)
    if v6(("ItemUse/BodySwapFire/%*"):format(l_Parent_1.Name), 30) then
        return;
    else
        v5:RemoteEvent("BodySwap/Fire"):FireServer(v10);
        return;
    end;
end);
l_Parent_0.Equipped:Connect(function() --[[ Line: 67 ]]
    -- upvalues: l_RunService_0 (copy), v20 (copy), v10 (ref), l_Highlight_0 (copy)
    l_RunService_0:BindToRenderStep("BodySwap", Enum.RenderPriority.Character.Value + 1, function() --[[ Line: 68 ]]
        -- upvalues: v20 (ref), v10 (ref), l_Highlight_0 (ref)
        local v21, v22 = v20();
        if v21 and v21 ~= v10 then
            l_Highlight_0.Adornee = v21;
            v10 = v22;
            return;
        else
            l_Highlight_0.Adornee = script;
            v10 = nil;
            return;
        end;
    end);
end);
l_Parent_0.Unequipped:Connect(function() --[[ Line: 80 ]]
    -- upvalues: l_RunService_0 (copy), l_Highlight_0 (copy), v10 (ref)
    l_RunService_0:UnbindFromRenderStep("BodySwap");
    l_Highlight_0.Adornee = script;
    v10 = nil;
end);