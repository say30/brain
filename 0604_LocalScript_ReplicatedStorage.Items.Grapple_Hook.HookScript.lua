--[[
  Extracted from: ReplicatedStorage.Items.Grapple Hook.HookScript
  Class: LocalScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: HookScript, time of decompilation: Tue Jun 24 14:16:11 2025 ]]
local _ = game:GetService("StarterPlayer");
local l_ReplicatedStorage_0 = game:GetService("ReplicatedStorage");
local _ = game:GetService("ServerScriptService");
local l_Packages_0 = l_ReplicatedStorage_0:WaitForChild("Packages");
local v4 = require(l_Packages_0.Net);
local v5 = require(l_Packages_0.Debounce);
local l_Parent_0 = script.Parent;
local l_Handle_0 = l_Parent_0.Handle;
local l_Beam_0 = l_Handle_0:WaitForChild("Beam");
local _ = l_Handle_0.RopeAttachment;
local l_Parent_1 = l_Parent_0.Parent.Parent;
local l_Hit_0 = script.Hit;
local l_Fire_0 = script.Fire;
local function _(v13) --[[ Line: 23 ]] --[[ Name: PlayerChecker ]]
    if v13.Parent:FindFirstChild("Humanoid") then
        return true;
    elseif v13.Parent.Parent:FindFirstChild("Humanoid") then
        return true;
    else
        return false;
    end;
end;
l_Parent_0.Activated:Connect(function() --[[ Line: 33 ]]
    -- upvalues: l_Parent_1 (copy), v5 (copy), l_Fire_0 (copy), v4 (copy), l_Beam_0 (copy), l_Hit_0 (copy)
    if l_Parent_1:GetAttribute("Stealing") then
        return;
    else
        local l_l_Parent_1_Mouse_0 = l_Parent_1:GetMouse();
        local l_Hit_1 = l_l_Parent_1_Mouse_0.Hit;
        local l_Target_0 = l_l_Parent_1_Mouse_0.Target;
        if not l_Target_0 or l_Target_0.Parent:FindFirstChild("Humanoid") and true or l_Target_0.Parent.Parent:FindFirstChild("Humanoid") and true or false then
            return;
        else
            local l_Position_0 = l_Hit_1.Position;
            local l_Character_0 = l_Parent_1.Character;
            if not l_Character_0 then
                return;
            else
                local l_l_Character_0_FirstChildWhichIsA_0 = l_Character_0:FindFirstChildWhichIsA("Tool", true);
                if not l_l_Character_0_FirstChildWhichIsA_0 then
                    return;
                elseif l_l_Character_0_FirstChildWhichIsA_0.Name ~= "Grapple Hook" then
                    return;
                else
                    local l_HumanoidRootPart_0 = l_Character_0:FindFirstChild("HumanoidRootPart");
                    if not l_HumanoidRootPart_0 then
                        return;
                    else
                        local l_Unit_0 = (l_Position_0 - l_HumanoidRootPart_0.Position).Unit;
                        local l_Magnitude_0 = (l_Position_0 - l_HumanoidRootPart_0.Position).Magnitude;
                        if l_Magnitude_0 >= 10 and l_Magnitude_0 <= 100 then
                            if v5(("ItemUse/GrappleHook/%*"):format(l_Parent_1.Name), 3) then
                                return;
                            else
                                l_Fire_0:Play();
                                v4:RemoteEvent("Begin/Hook"):FireServer(l_Magnitude_0 / 120);
                                local l_Part_0 = Instance.new("Part");
                                l_Part_0.Anchored = true;
                                l_Part_0.CanCollide = false;
                                l_Part_0.Transparency = 1;
                                l_Part_0.Position = l_Position_0;
                                l_Part_0.Size = Vector3.new(0.10000000149011612, 0.10000000149011612, 0.10000000149011612, 0);
                                l_Part_0.Parent = workspace;
                                local l_Attachment_0 = Instance.new("Attachment");
                                l_Attachment_0.Position = Vector3.new(0, 0, 0, 0);
                                l_Attachment_0.Parent = l_Part_0;
                                l_Beam_0.Attachment0 = l_Attachment_0;
                                local l_BodyVelocity_0 = Instance.new("BodyVelocity");
                                l_BodyVelocity_0.MaxForce = Vector3.new(1e999, 1e999, 1e999, 0);
                                l_BodyVelocity_0.Velocity = l_Unit_0 * 100;
                                l_BodyVelocity_0.P = 2000;
                                l_BodyVelocity_0.Parent = l_HumanoidRootPart_0;
                                l_Hit_0:Play();
                                task.delay(l_Magnitude_0 / 120, function() --[[ Line: 97 ]]
                                    -- upvalues: l_BodyVelocity_0 (copy), l_Attachment_0 (copy), l_Part_0 (copy), l_Beam_0 (ref)
                                    l_BodyVelocity_0:Destroy();
                                    l_Attachment_0:Destroy();
                                    l_Part_0:Destroy();
                                    l_Beam_0.Attachment0 = nil;
                                end);
                            end;
                        end;
                        return;
                    end;
                end;
            end;
        end;
    end;
end);