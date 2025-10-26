--[[
  Extracted from: ReplicatedStorage.Controllers.BackpackController
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: BackpackController, time of decompilation: Sat Jul  5 18:09:13 2025 ]]
local v0 = require(script.Utils.Satchel);
local v1 = {
    States = {}
};
v1.Update = function(_) --[[ Line: 8 ]] --[[ Name: Update ]]
    -- upvalues: v0 (copy), v1 (copy)
    v0:SetBackpackEnabled(next(v1.States) == nil);
end;
v1.SetEnabled = function(_, v4, v5) --[[ Line: 12 ]] --[[ Name: SetEnabled ]]
    -- upvalues: v1 (copy)
    v1.States[v4] = not v5 or nil;
    v1:Update();
end;
return v1;