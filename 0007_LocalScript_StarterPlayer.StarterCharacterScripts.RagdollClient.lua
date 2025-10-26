--[[
  Extracted from: StarterPlayer.StarterCharacterScripts.RagdollClient
  Class: LocalScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: RagdollClient, time of decompilation: Sun Jun 22 15:17:08 2025 ]]
local l_CurrentCamera_0 = workspace.CurrentCamera;
local l_Character_0 = game.Players.LocalPlayer.Character;
local l_Head_0 = l_Character_0:WaitForChild("Head");
local l_Humanoid_0 = l_Character_0:WaitForChild("Humanoid");
local l_Ragdoll_0 = game.ReplicatedStorage:WaitForChild("Packages").Ragdoll.Ragdoll;
local function _(v5) --[[ Line: 8 ]] --[[ Name: _ ]]
    -- upvalues: l_CurrentCamera_0 (copy), l_Head_0 (copy), l_Humanoid_0 (copy)
    if v5 == "Focus" then
        l_CurrentCamera_0.CameraSubject = l_Head_0;
        l_Humanoid_0.RootPart.CanCollide = false;
        return;
    else
        if v5 == "Unfocus" then
            l_CurrentCamera_0.CameraSubject = l_Humanoid_0;
            l_Humanoid_0.RootPart.CanCollide = true;
        end;
        return;
    end;
end;
local function _(v7) --[[ Line: 22 ]] --[[ Name: _ ]]
    if v7 == "Stop" then
        return;
    else
        if v7 == "Aan" then

        end;
        return;
    end;
end;
l_Ragdoll_0.OnClientEvent:Connect(function(v9, v10) --[[ Line: 32 ]]
    -- upvalues: l_Humanoid_0 (copy), l_CurrentCamera_0 (copy), l_Head_0 (copy)
    if l_Humanoid_0 then
        if v9 == "Make" then
            l_Humanoid_0:ChangeState(Enum.HumanoidStateType.Physics);
            l_CurrentCamera_0.CameraSubject = l_Head_0;
            l_Humanoid_0.RootPart.CanCollide = false;
        elseif v9 == "Destroy" then
            l_Humanoid_0:ChangeState(Enum.HumanoidStateType.GettingUp);
            l_CurrentCamera_0.CameraSubject = l_Humanoid_0;
            l_Humanoid_0.RootPart.CanCollide = true;
        end;
        if v9 == nil and v10 == "manualM" then
            l_Humanoid_0:ChangeState(Enum.HumanoidStateType.Physics);
            l_CurrentCamera_0.CameraSubject = l_Head_0;
            l_Humanoid_0.RootPart.CanCollide = false;
        end;
        if v9 == nil and v10 == "manualD" then
            l_Humanoid_0:ChangeState(Enum.HumanoidStateType.GettingUp);
            l_CurrentCamera_0.CameraSubject = l_Humanoid_0;
            l_Humanoid_0.RootPart.CanCollide = true;
        end;
    end;
end);
if script.Parent == game.Workspace then
    error("Dude wont run *******, and this print neither XD");
end;