--[[
  Extracted from: ReplicatedStorage.Items.Flying Carpet.MouseIcon
  Class: LocalScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: MouseIcon, time of decompilation: Tue Jun 24 14:16:11 2025 ]]
Mouse_Icon = "rbxasset://textures/GunCursor.png";
Reloading_Icon = "rbxasset://textures/GunWaitCursor.png";
Tool = script.Parent;
Mouse = nil;
UpdateIcon = function() --[[ Line: 8 ]] --[[ Name: UpdateIcon ]]
    if Mouse then
        Mouse.Icon = Tool.Enabled and Mouse_Icon or Reloading_Icon;
    end;
end;
OnEquipped = function(v0) --[[ Line: 14 ]] --[[ Name: OnEquipped ]]
    Mouse = v0;
    UpdateIcon();
end;
OnChanged = function(v1) --[[ Line: 19 ]] --[[ Name: OnChanged ]]
    if v1 == "Enabled" then
        UpdateIcon();
    end;
end;
Tool.Equipped:connect(OnEquipped);
Tool.Changed:connect(OnChanged);