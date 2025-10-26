--[[
  Extracted from: ReplicatedStorage.Packages.Gradients.Effects.Zebra
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local u1 = require(script.Parent.Parent.ColorSequenceUtils)
local u2 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
    ColorSequenceKeypoint.new(0.015625, Color3.new(1, 1, 1)),
    ColorSequenceKeypoint.new(0.1458333283662796, Color3.new(1, 1, 1)),
    ColorSequenceKeypoint.new(0.2482638955116272, Color3.new(1, 1, 1)),
    ColorSequenceKeypoint.new(0.3559027910232544, Color3.new(1, 1, 1)),
    ColorSequenceKeypoint.new(0.4970000088214874, Color3.new(1, 1, 1)),
    ColorSequenceKeypoint.new(0.503000020980835, Color3.new(0, 0, 0)),
    ColorSequenceKeypoint.new(0.647569477558136, Color3.new(0, 0, 0)),
    ColorSequenceKeypoint.new(0.7829861044883728, Color3.new(0, 0, 0)),
    ColorSequenceKeypoint.new(0.890625, Color3.new(0, 0, 0)),
    ColorSequenceKeypoint.new(0.9774305820465088, Color3.new(0, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0))
})
local u3 = 0
return {
    ["simulate"] = function(p4) --[[Function name: simulate, line 22]]
        --[[
        Upvalues:
            [1] = u3
            [2] = u1
            [3] = u2
        --]]
        u3 = u3 + p4 * 0.5
        return {
            ["main"] = u1.calculateColorSequence(u2, u3),
            ["stroke"] = u1.calculateColorSequence(u2, u3 + 0.5)
        }
    end,
    ["apply"] = function(u5) --[[Function name: apply, line 29]]
        local u6 = {}
        local function v11(p7, p8) --[[Anonymous function at line 40]]
            --[[
            Upvalues:
                [1] = u6
            --]]
            local u9 = p7:FindFirstChildWhichIsA(p8)
            if not u9 then
                u9 = Instance.new(p8)
                u9.Parent = p7
                local v10 = u6
                table.insert(v10, 1, function() --[[Anonymous function at line 45]]
                    --[[
                    Upvalues:
                        [1] = u9
                    --]]
                    u9:Destroy()
                end)
            end
            return u9
        end
        if u5:IsA("TextLabel") then
            local v12 = Color3.new(1, 1, 1)
            local u13 = u5.TextColor3
            u5.TextColor3 = v12
            local u14 = "TextColor3"
            table.insert(u6, 1, function() --[[Anonymous function at line 35]]
                --[[
                Upvalues:
                    [1] = u5
                    [2] = u14
                    [3] = u13
                --]]
                u5[u14] = u13
            end)
        end
        local u15 = v11(u5, "UIGradient")
        local u16 = v11(u5, "UIStroke")
        local u17 = v11(u16, "UIGradient")
        local v18 = Color3.new(1, 1, 1)
        local u19 = u16.Color
        u16.Color = v18
        local u20 = "Color"
        table.insert(u6, 1, function() --[[Anonymous function at line 35]]
            --[[
            Upvalues:
                [1] = u16
                [2] = u20
                [3] = u19
            --]]
            u16[u20] = u19
        end)
        local u21 = u16.Thickness
        u16.Thickness = 1
        local u22 = "Thickness"
        table.insert(u6, 1, function() --[[Anonymous function at line 35]]
            --[[
            Upvalues:
                [1] = u16
                [2] = u22
                [3] = u21
            --]]
            u16[u22] = u21
        end)
        local u23 = u16.Transparency
        u16.Transparency = 0
        local u24 = "Transparency"
        table.insert(u6, 1, function() --[[Anonymous function at line 35]]
            --[[
            Upvalues:
                [1] = u16
                [2] = u24
                [3] = u23
            --]]
            u16[u24] = u23
        end)
        local u25 = u16:GetPropertyChangedSignal("Thickness"):Connect(function() --[[Anonymous function at line 65]]
            --[[
            Upvalues:
                [1] = u16
            --]]
            if u16.Thickness ~= 1 then
                u16.Thickness = 1
            end
        end)
        local u26 = u15.Rotation
        u15.Rotation = 90
        local u27 = "Rotation"
        table.insert(u6, 1, function() --[[Anonymous function at line 35]]
            --[[
            Upvalues:
                [1] = u15
                [2] = u27
                [3] = u26
            --]]
            u15[u27] = u26
        end)
        local v28 = NumberSequence.new(0)
        local u29 = u15.Transparency
        u15.Transparency = v28
        local u30 = "Transparency"
        table.insert(u6, 1, function() --[[Anonymous function at line 35]]
            --[[
            Upvalues:
                [1] = u15
                [2] = u30
                [3] = u29
            --]]
            u15[u30] = u29
        end)
        local u31 = u17.Rotation
        u17.Rotation = 90
        local u32 = "Rotation"
        table.insert(u6, 1, function() --[[Anonymous function at line 35]]
            --[[
            Upvalues:
                [1] = u17
                [2] = u32
                [3] = u31
            --]]
            u17[u32] = u31
        end)
        local v33 = NumberSequence.new(0)
        local u34 = u17.Transparency
        u17.Transparency = v33
        local u35 = "Transparency"
        table.insert(u6, 1, function() --[[Anonymous function at line 35]]
            --[[
            Upvalues:
                [1] = u17
                [2] = u35
                [3] = u34
            --]]
            u17[u35] = u34
        end)
        return {
            ["main"] = u15,
            ["stroke"] = u17,
            ["cleanup"] = function() --[[Function name: cleanup, line 81]]
                --[[
                Upvalues:
                    [1] = u25
                    [2] = u6
                --]]
                u25:Disconnect()
                for _, v36 in u6 do
                    v36()
                end
            end
        }
    end
}