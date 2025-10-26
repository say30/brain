--[[
  Extracted from: ReplicatedStorage.Controllers.ConfirmationController
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: ConfirmationController, time of decompilation: Sat Jul 12 13:53:49 2025 ]]
local l_ReplicatedStorage_0 = game:GetService("ReplicatedStorage");
local l_Players_0 = game:GetService("Players");
local v2 = require(l_ReplicatedStorage_0.Packages.Signal);
local v3 = require(l_ReplicatedStorage_0.Classes.AnimatedButton);
local l_Confirmation_0 = l_Players_0.LocalPlayer.PlayerGui:WaitForChild("Confirmation");
local l_Template_0 = l_Confirmation_0:WaitForChild("Template");
local v6 = {};
local v7 = false;
v6.IsInPrompt = function(_) --[[ Line: 18 ]] --[[ Name: IsInPrompt ]]
    -- upvalues: v7 (ref)
    return v7;
end;
v6.Show = function(_, v10) --[[ Line: 22 ]] --[[ Name: Show ]]
    -- upvalues: v7 (ref), v2 (copy), l_Template_0 (copy), l_Confirmation_0 (copy), v3 (copy)
    while v7 do
        task.wait();
    end;
    v7 = true;
    v10 = v10 or "Do you really want to do this?";
    local v11 = v2.new();
    local v12 = l_Template_0:Clone();
    v12.Name = "Confirmation";
    v12.Parent = l_Confirmation_0;
    v12.Visible = true;
    local l_Description_0 = v12.Content.Description;
    local l_Close_0 = v12.Close;
    local l_Yes_0 = v12.Yes;
    local l_No_0 = v12.No;
    l_Description_0.Text = v10;
    local function _() --[[ Line: 46 ]] --[[ Name: cleanup ]]
        -- upvalues: v12 (copy)
        v12:Destroy();
    end;
    local function _(v18) --[[ Line: 50 ]] --[[ Name: respond ]]
        -- upvalues: v11 (copy)
        v11:Fire(v18);
    end;
    local v20 = v3.new(l_Yes_0);
    v20:Animate();
    v20.OnActivated:Connect(function() --[[ Line: 56 ]]
        -- upvalues: v11 (copy)
        v11:Fire(true);
    end);
    local v21 = v3.new(l_No_0);
    v21:Animate();
    v21.OnActivated:Connect(function() --[[ Line: 62 ]]
        -- upvalues: v11 (copy)
        v11:Fire(false);
    end);
    local v22 = v3.new(l_Close_0);
    v22:Animate();
    v22.OnActivated:Connect(function() --[[ Line: 68 ]]
        -- upvalues: v11 (copy)
        v11:Fire(false);
    end);
    local v23 = v11:Wait();
    v12:Destroy();
    v11:Destroy();
    v7 = false;
    return v23;
end;
return v6;