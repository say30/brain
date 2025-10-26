--[[
  Extracted from: ReplicatedStorage.Controllers.CombatController
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: CombatController, time of decompilation: Sat Jun 28 18:35:02 2025 ]]
local l_ReplicatedStorage_0 = game:GetService("ReplicatedStorage");
local l_Controllers_0 = l_ReplicatedStorage_0:WaitForChild("Controllers");
local v2 = require(l_Controllers_0.CharacterController);
local l_Packages_0 = l_ReplicatedStorage_0:WaitForChild("Packages");
local v4 = require(l_Packages_0.Net):RemoteEvent("CombatService/ApplyImpulse");
local v11 = {
    ApplyImpulse = function(_, v6, v7) --[[ Line: 17 ]] --[[ Name: ApplyImpulse ]]
        -- upvalues: v2 (copy)
        local l_v2_Character_0, _, v10 = v2:GetCharacter();
        if not l_v2_Character_0 then
            return;
        else
            v10:ApplyImpulse(v7 * v6);
            return;
        end;
    end
};
v11.Start = function(_) --[[ Line: 27 ]] --[[ Name: Start ]]
    -- upvalues: v4 (copy), v11 (copy)
    v4.OnClientEvent:Connect(function(...) --[[ Line: 29 ]]
        -- upvalues: v11 (ref)
        v11:ApplyImpulse(...);
    end);
end;
return v11;