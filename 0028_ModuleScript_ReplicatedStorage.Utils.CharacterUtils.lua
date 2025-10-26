--[[
  Extracted from: ReplicatedStorage.Utils.CharacterUtils
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: CharacterUtils, time of decompilation: Sat Jun 28 18:34:29 2025 ]]
local l_Players_0 = game:GetService("Players");
local l_RunService_0 = game:GetService("RunService");
return {
    GetCharacter = function(_, v3) --[[ Line: 10 ]] --[[ Name: GetCharacter ]]
        -- upvalues: l_RunService_0 (copy), l_Players_0 (copy)
        local v4 = nil;
        if l_RunService_0:IsServer() then
            if not v3 then
                return nil;
            else
                v4 = v3;
            end;
        else
            v4 = v3 or l_Players_0.LocalPlayer;
        end;
        local l_Character_0 = v4.Character;
        if not l_Character_0 then
            return nil;
        else
            local l_HumanoidRootPart_0 = l_Character_0:FindFirstChild("HumanoidRootPart");
            if not l_HumanoidRootPart_0 then
                return nil;
            else
                local l_Humanoid_0 = l_Character_0:FindFirstChild("Humanoid");
                if not l_Humanoid_0 then
                    return nil;
                else
                    return l_Character_0, l_HumanoidRootPart_0, l_Humanoid_0;
                end;
            end;
        end;
    end
};