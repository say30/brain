--[[
  Extracted from: ReplicatedStorage.Controllers.SpeedController
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: SpeedController, time of decompilation: Sat Jun 28 18:35:02 2025 ]]
local l_ReplicatedStorage_0 = game:GetService("ReplicatedStorage");
local l_RunService_0 = game:GetService("RunService");
local l_StarterPlayer_0 = game:GetService("StarterPlayer");
local l_Players_0 = game:GetService("Players");
local l_Controllers_0 = l_ReplicatedStorage_0:WaitForChild("Controllers");
local v5 = require(l_Controllers_0.CharacterController);
local l_LocalPlayer_0 = l_Players_0.LocalPlayer;
local v21 = {
    GetCurrentJumpHeight = function(_) --[[ Line: 17 ]] --[[ Name: GetCurrentJumpHeight ]]
        -- upvalues: l_StarterPlayer_0 (copy), v5 (copy), l_LocalPlayer_0 (copy)
        local l_CharacterJumpHeight_0 = l_StarterPlayer_0.CharacterJumpHeight;
        local l_v5_Character_0, _, _ = v5:GetCharacter();
        if not l_v5_Character_0 then
            return 0;
        else
            local l_Tool_0 = l_v5_Character_0:FindFirstChildOfClass("Tool");
            if l_Tool_0 then
                local l_l_Tool_0_Attribute_0 = l_Tool_0:GetAttribute("JumpModifier");
                if l_l_Tool_0_Attribute_0 then
                    l_CharacterJumpHeight_0 = l_CharacterJumpHeight_0 * l_l_Tool_0_Attribute_0;
                end;
            end;
            if l_LocalPlayer_0:GetAttribute("Stealing") then
                l_CharacterJumpHeight_0 = l_CharacterJumpHeight_0 * 0.6;
            end;
            return (math.clamp(l_CharacterJumpHeight_0, 0, 1e999));
        end;
    end, 
    GetCurrentWalkSpeed = function(_) --[[ Line: 44 ]] --[[ Name: GetCurrentWalkSpeed ]]
        -- upvalues: l_StarterPlayer_0 (copy), v5 (copy), l_LocalPlayer_0 (copy)
        local l_CharacterWalkSpeed_0 = l_StarterPlayer_0.CharacterWalkSpeed;
        local l_v5_Character_1, _, _ = v5:GetCharacter();
        if not l_v5_Character_1 then
            return 0;
        else
            local l_Tool_1 = l_v5_Character_1:FindFirstChildOfClass("Tool");
            if l_Tool_1 then
                local l_l_Tool_1_Attribute_0 = l_Tool_1:GetAttribute("SpeedModifier");
                if l_l_Tool_1_Attribute_0 then
                    l_CharacterWalkSpeed_0 = l_CharacterWalkSpeed_0 * l_l_Tool_1_Attribute_0;
                end;
            end;
            if l_LocalPlayer_0:GetAttribute("Stealing") then
                l_CharacterWalkSpeed_0 = l_CharacterWalkSpeed_0 * 0.6;
            end;
            return (math.clamp(l_CharacterWalkSpeed_0, 0, 1e999));
        end;
    end
};
v21.Start = function(_) --[[ Line: 71 ]] --[[ Name: Start ]]
    -- upvalues: l_RunService_0 (copy), v5 (copy), v21 (copy)
    l_RunService_0.RenderStepped:Connect(function(_) --[[ Line: 73 ]]
        -- upvalues: v5 (ref), v21 (ref)
        local l_v5_Character_2, v25, _ = v5:GetCharacter();
        if not l_v5_Character_2 then
            return;
        else
            v25.WalkSpeed = v21:GetCurrentWalkSpeed();
            v25.JumpHeight = v21:GetCurrentJumpHeight();
            return;
        end;
    end);
end;
return v21;