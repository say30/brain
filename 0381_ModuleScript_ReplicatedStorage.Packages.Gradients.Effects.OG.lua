--[[
  Extracted from: ReplicatedStorage.Packages.Gradients.Effects.OG
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local v_u_1 = require(script.Parent.Parent.ColorSequenceUtils)
local v_u_2 = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.new(1, 1, 0)), ColorSequenceKeypoint.new(0.5, Color3.new(0, 0, 0)), ColorSequenceKeypoint.new(1, Color3.new(1, 1, 0)) })
local v_u_3 = 0
return {
    ["simulate"] = function(p4)
        v_u_3 = v_u_3 + p4 * 1
        return {
            ["main"] = v_u_1.calculateColorSequence(v_u_2, v_u_3)
        }
    end,
    ["apply"] = function(p_u_5)
        local v_u_6 = {}
        local function v11(p7, p8)
            local v_u_9 = p7:FindFirstChildWhichIsA(p8)
            if not v_u_9 then
                v_u_9 = Instance.new(p8)
                v_u_9.Parent = p7
                local v10 = v_u_6
                table.insert(v10, 1, function()
                    v_u_9:Destroy()
                end)
            end
            return v_u_9
        end
        if p_u_5:IsA("TextLabel") then
            local v12 = Color3.new(1, 1, 1)
            local v_u_13 = p_u_5.TextColor3
            p_u_5.TextColor3 = v12
            local v_u_14 = "TextColor3"
            table.insert(v_u_6, 1, function()
                p_u_5[v_u_14] = v_u_13
            end)
        end
        local v_u_15 = v11(p_u_5, "UIGradient")
        local v_u_16 = v11(p_u_5, "UIStroke")
        local v_u_17 = v11(v_u_16, "UIGradient")
        local v18 = Color3.new(0, 0, 0)
        local v_u_19 = v_u_16.Color
        v_u_16.Color = v18
        local v_u_20 = "Color"
        table.insert(v_u_6, 1, function()
            v_u_16[v_u_20] = v_u_19
        end)
        local v_u_21 = v_u_15.Rotation
        v_u_15.Rotation = 90
        local v_u_22 = "Rotation"
        table.insert(v_u_6, 1, function()
            v_u_15[v_u_22] = v_u_21
        end)
        local v23 = NumberSequence.new(0)
        local v_u_24 = v_u_15.Transparency
        v_u_15.Transparency = v23
        local v_u_25 = "Transparency"
        table.insert(v_u_6, 1, function()
            v_u_15[v_u_25] = v_u_24
        end)
        local v_u_26 = v_u_17.Rotation
        v_u_17.Rotation = 90
        local v_u_27 = "Rotation"
        table.insert(v_u_6, 1, function()
            v_u_17[v_u_27] = v_u_26
        end)
        local v28 = NumberSequence.new(0)
        local v_u_29 = v_u_17.Transparency
        v_u_17.Transparency = v28
        local v_u_30 = "Transparency"
        table.insert(v_u_6, 1, function()
            v_u_17[v_u_30] = v_u_29
        end)
        return {
            ["main"] = v_u_15,
            ["stroke"] = v_u_17,
            ["cleanup"] = function()
                for _, v31 in v_u_6 do
                    v31()
                end
            end
        }
    end
}