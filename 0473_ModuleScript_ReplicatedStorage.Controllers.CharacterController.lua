--[[
  Extracted from: ReplicatedStorage.Controllers.CharacterController
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: CharacterController, time of decompilation: Sat Jun 28 18:35:00 2025 ]]
local l_ReplicatedStorage_0 = game:GetService("ReplicatedStorage");
local l_Players_0 = game:GetService("Players");
local l_RunService_0 = game:GetService("RunService");
local l_Packages_0 = l_ReplicatedStorage_0:WaitForChild("Packages");
local v4 = require(l_Packages_0.Signal);
local l_LocalPlayer_0 = l_Players_0.LocalPlayer;
local v6 = {
    OnCharacterAdded = v4.new(), 
    OnSetCFrame = v4.new()
};
v6.WaitForCharacter = function(_, v8) --[[ Line: 19 ]] --[[ Name: WaitForCharacter ]]
    -- upvalues: v6 (copy)
    local v9 = nil;
    local v10 = nil;
    local v11 = nil;
    while not v9 do
        local l_v6_Character_0, v13, v14 = v6:GetCharacter(v8);
        v9 = l_v6_Character_0;
        v10 = v13;
        v11 = v14;
        task.wait();
    end;
    return v9, v10, v11;
end;
v6.GetCharacter = function(_, v16) --[[ Line: 31 ]] --[[ Name: GetCharacter ]]
    -- upvalues: l_LocalPlayer_0 (copy)
    local l_Character_0 = (v16 or l_LocalPlayer_0).Character;
    if not l_Character_0 then
        return;
    else
        local l_Humanoid_0 = l_Character_0:FindFirstChild("Humanoid");
        if not l_Humanoid_0 then
            return;
        else
            local l_HumanoidRootPart_0 = l_Character_0:FindFirstChild("HumanoidRootPart");
            if not l_HumanoidRootPart_0 then
                return;
            else
                return l_Character_0, l_Humanoid_0, l_HumanoidRootPart_0;
            end;
        end;
    end;
end;
v6.SetCFrame = function(_, v21) --[[ Line: 48 ]] --[[ Name: SetCFrame ]]
    -- upvalues: v6 (copy)
    local l_v6_Character_1, _, v24 = v6:GetCharacter();
    if not l_v6_Character_1 then
        return;
    else
        v24.CFrame = v21;
        v6.OnSetCFrame:Fire(v21);
        return;
    end;
end;
v6.Start = function(_) --[[ Line: 58 ]] --[[ Name: Start ]]
    -- upvalues: v6 (copy), l_LocalPlayer_0 (copy), l_RunService_0 (copy)
    local v26 = 2.08;
    local function v32(v27) --[[ Line: 73 ]] --[[ Name: onCharacterAdded ]]
        -- upvalues: v6 (ref), v26 (ref)
        v6.OnCharacterAdded:Fire(v27);
        local l_Humanoid_1 = v27:WaitForChild("Humanoid");
        if not l_Humanoid_1 then
            return;
        else
            v26 = l_Humanoid_1.HipHeight;
            local v29 = 0;
            l_Humanoid_1.StateChanged:Connect(function(v30, v31) --[[ Line: 84 ]]
                -- upvalues: l_Humanoid_1 (copy), v29 (ref)
                if l_Humanoid_1.Health <= 0 then
                    return;
                else
                    if v30 == Enum.HumanoidStateType.Jumping and v31 == Enum.HumanoidStateType.Jumping or v30 == Enum.HumanoidStateType.Freefall and v31 == Enum.HumanoidStateType.Jumping then
                        v29 = v29 + 1;
                        task.delay(60, function() --[[ Line: 94 ]]
                            -- upvalues: v29 (ref)
                            v29 = v29 - 1;
                        end);
                        if v29 >= 5 then
                            l_Humanoid_1.Health = 0;
                        end;
                    end;
                    return;
                end;
            end);
            return;
        end;
    end;
    l_LocalPlayer_0.CharacterAdded:Connect(v32);
    if l_LocalPlayer_0.Character then
        task.spawn(v32, l_LocalPlayer_0.Character);
    end;
    l_RunService_0.PreSimulation:Connect(function(_) --[[ Line: 110 ]]
        -- upvalues: v6 (ref), v26 (ref)
        local l_v6_Character_2, v35, _ = v6:GetCharacter();
        if not l_v6_Character_2 or not v35 then
            return;
        else
            v35.HipHeight = v26;
            return;
        end;
    end);
end;
return v6;