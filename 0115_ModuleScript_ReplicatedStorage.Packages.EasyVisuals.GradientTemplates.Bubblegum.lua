--[[
  Extracted from: ReplicatedStorage.Packages.EasyVisuals.GradientTemplates.Bubblegum
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: Bubblegum, time of decompilation: Sat Jun 28 18:35:21 2025 ]]
return function() --[[ Line: 1 ]]
    local l_UIGradient_0 = Instance.new("UIGradient");
    l_UIGradient_0.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.new(0.9529411792755127, 0.3960784375667572, 0.6941176652908325)), 
        ColorSequenceKeypoint.new(0.5, Color3.new(1, 0.6549019813537598, 0.8901960849761963)), 
        ColorSequenceKeypoint.new(1, Color3.new(0.9529411792755127, 0.3960784375667572, 0.6941176652908325))
    });
    l_UIGradient_0.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0), 
        NumberSequenceKeypoint.new(0.09894459694623947, 0), 
        NumberSequenceKeypoint.new(0.5, 1), 
        NumberSequenceKeypoint.new(0.8997361660003662, 0), 
        NumberSequenceKeypoint.new(1, 0)
    });
    return l_UIGradient_0;
end;