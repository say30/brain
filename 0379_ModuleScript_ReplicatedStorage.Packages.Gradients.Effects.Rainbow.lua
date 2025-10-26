--[[
  Extracted from: ReplicatedStorage.Packages.Gradients.Effects.Rainbow
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local u1 = require(script.Parent.Parent.ColorSequenceUtils)
local u2 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.new(1, 0, 0)),
    ColorSequenceKeypoint.new(0.1510416716337204, Color3.new(0.615686297416687, 0, 1)),
    ColorSequenceKeypoint.new(0.3072916567325592, Color3.new(0.06666667014360428, 0, 1)),
    ColorSequenceKeypoint.new(0.4965277910232544, Color3.new(0, 1, 1)),
    ColorSequenceKeypoint.new(0.6649305820465088, Color3.new(0.01568627543747425, 1, 0)),
    ColorSequenceKeypoint.new(0.8385416865348816, Color3.new(1, 1, 0)),
    ColorSequenceKeypoint.new(1, Color3.new(1, 0, 0))
})
local u3 = 0
return {
    ["simulate"] = function(p4) --[[Function name: simulate, line 17]]
        --[[
        Upvalues:
            [1] = u3
            [2] = u1
            [3] = u2
        --]]
        u3 = u3 + p4 * 0.5
        return {
            ["main"] = u1.calculateColorSequence(u2, u3)
        }
    end,
    ["apply"] = function(p5) --[[Function name: apply, line 29]]
        local u6 = {}
        local u7 = p5:FindFirstChildWhichIsA("UIGradient")
        local u8
        if u7 then
            u8 = u7.Color
        else
            u8 = nil
        end
        if not u7 then
            u7 = Instance.new("UIGradient")
            u7.Parent = p5
            table.insert(u6, u7)
        end
        local v9 = u7
        assert(v9)
        return {
            ["main"] = u7,
            ["cleanup"] = function() --[[Function name: cleanup, line 47]]
                --[[
                Upvalues:
                    [1] = u8
                    [2] = u7
                    [3] = u6
                --]]
                if u8 then
                    u7.Color = u8
                end
                for _, v10 in u6 do
                    v10:Destroy()
                end
            end
        }
    end
}