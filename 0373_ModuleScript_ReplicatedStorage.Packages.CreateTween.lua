--[[
  Extracted from: ReplicatedStorage.Packages.CreateTween
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local u1 = game:GetService("TweenService")
return function(p2, p3, p4, p5) --[[Anonymous function at line 4]]
    --[[
    Upvalues:
        [1] = u1
    --]]
    local u6 = u1:Create(p2, p3, p4)
    u6.Completed:Once(function() --[[Anonymous function at line 6]]
        --[[
        Upvalues:
            [1] = u6
        --]]
        u6:Destroy()
    end)
    if p5 ~= false then
        u6:Play()
    end
    return u6
end