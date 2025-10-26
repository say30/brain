--[[
  Extracted from: ReplicatedStorage.Controllers.EventController.Events.Bloodmoon
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: Bloodmoon, time of decompilation: Sat Jun 28 18:35:10 2025 ]]
local l_ReplicatedStorage_0 = game:GetService("ReplicatedStorage");
local _ = game:GetService("TweenService");
local _ = game:GetService("RunService");
local l_Lighting_0 = game:GetService("Lighting");
local _ = game:GetService("Players");
local _ = require(l_ReplicatedStorage_0.Shared.EventTypes);
local v6 = {};
local _ = require(l_ReplicatedStorage_0.Controllers.AnimalController);
local v8 = require(l_ReplicatedStorage_0.Controllers.SoundController);
local _ = require(l_ReplicatedStorage_0.Controllers.EventController);
local v10 = require(l_ReplicatedStorage_0.Controllers.CycleController);
local _ = require(l_ReplicatedStorage_0.Packages.Spring);
local v12 = require(l_ReplicatedStorage_0.Packages.Trove);
local _ = require(l_ReplicatedStorage_0.Packages.Shake);
local _ = require(l_ReplicatedStorage_0.Packages.Net);
local _ = script.Name;
local v16 = v12.new();
v6.OnStart = function(_) --[[ Line: 24 ]] --[[ Name: OnStart ]]
    -- upvalues: l_Lighting_0 (copy), v16 (copy), v10 (copy), v8 (copy)
  
    v16:Add(function() --[[ Line: 27 ]]
        -- upvalues: l_Atmosphere_0 (copy), l_Lighting_0 (ref)
        script.Atmosphere.Parent = l_Lighting_0;
    end);
    v16:Clone(script.AtmosphereBloodmoon).Parent = l_Lighting_0;
   
    v16:Add(function() --[[ Line: 35 ]]
        -- upvalues: l_Cartoon_0 (copy), l_Lighting_0 (ref)
        script.Cartoon.Parent = l_Lighting_0;
    end);
    v16:Clone(script.SkyBloodmoon).Parent = l_Lighting_0;
    v10:Update();
    v8:UpdateOST();
end;
v6.OnStop = function(_) --[[ Line: 45 ]] --[[ Name: OnStop ]]
    -- upvalues: v16 (copy)
    v16:Destroy();
end;
v6.OnLoad = function(_) --[[ Line: 49 ]] --[[ Name: OnLoad ]]

end;
return v6;