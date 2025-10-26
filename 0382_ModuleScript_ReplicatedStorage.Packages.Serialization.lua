--[[
  Extracted from: ReplicatedStorage.Packages.Serialization
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

game:GetService("ServerScriptService")
local v1 = game:GetService("ReplicatedStorage")
local u2 = require(v1.Packages.Squash)
local v3 = u2.T
local _ = u2.uint
local u4 = u2.vlq()
local v5 = u2.boolean()
local u6 = u2.string()
local v7 = u2.number(4)
local _ = u2.Vector2
local v8 = u2.array
local v9 = u2.map
local v10 = u2.opt
local v11 = u2.record
local u12 = { "boolean", "number" }
local function u27() --[[Anonymous function at line 23]]
    --[[
    Upvalues:
        [1] = u6
        [2] = u27
        [3] = u4
        [4] = u2
        [5] = u12
    --]]
    return {
        ["ser"] = function(p13, p14) --[[Function name: ser, line 25]]
            --[[
            Upvalues:
                [1] = u6
                [2] = u27
                [3] = u4
                [4] = u2
                [5] = u12
            --]]
            local v15 = typeof(p14)
            if v15 == "nil" then
                u6.ser(p13, "nil")
                return
            elseif v15 == "table" then
                local v16 = 0
                for v17, v18 in p14 do
                    v16 = v16 + 1
                    u27().ser(p13, v17)
                    u27().ser(p13, v18)
                end
                u4.ser(p13, v16)
                u6.ser(p13, "table")
            else
                local v19 = u2[v15]
                if not v19 then
                    error((("not found for %*"):format(v15)))
                end
                if typeof(v19) == "function" or v15 == "string" then
                    local v20
                    if v15 == "string" then
                        v20 = nil
                    else
                        v20 = table.find(u12, v15) and 8 or u2.number(8)
                    end
                    v19 = v19(v20)
                end
                v19.ser(p13, p14)
                u6.ser(p13, v15)
            end
        end,
        ["des"] = function(p21) --[[Function name: des, line 55]]
            --[[
            Upvalues:
                [1] = u6
                [2] = u4
                [3] = u27
                [4] = u2
                [5] = u12
            --]]
            local v22 = u6.des(p21)
            if v22 == "nil" then
                return nil
            end
            if v22 == "table" then
                local v23 = {}
                for _ = 1, u4.des(p21) do
                    local v24 = u27().des(p21)
                    v23[u27().des(p21)] = v24
                end
                return v23
            end
            local v25 = u2[v22]
            if not v25 then
                error((("not found for %*"):format(v22)))
            end
            if typeof(v25) == "function" or v22 == "string" then
                local v26
                if v22 == "string" then
                    v26 = nil
                else
                    v26 = table.find(u12, v22) and 8 or u2.number(8)
                end
                v25 = v25(v26)
            end
            return v25.des(p21)
        end
    }
end
local v28 = {
    ["Information"] = v3(v11({
        ["Looped"] = v3(v5),
        ["Length"] = v3(u4),
        ["FPS"] = v3(v10(u4))
    }))
}
local v29 = {
    ["Path"] = v11({
        ["InstanceNames"] = v3(v8(u6)),
        ["InstanceTypes"] = v3(v8(u6)),
        ["ItemType"] = v3(u6)
    })
}
local v30 = {
    ["Default"] = v3(u27()),
    ["Static"] = v3(v10(v5))
}
local v31 = {}
local v32 = {
    ["Params"] = v11({
        ["Direction"] = v3(v10(u6)),
        ["Overshoot"] = v3(v10(v7)),
        ["Amplitude"] = v3(v10(v7)),
        ["Period"] = v3(v10(v7))
    }),
    ["Type"] = v3(u6)
}
v31.Ease = v3(v10(v11(v32)))
v31.Time = v3(u4)
v31.Value = v3(u27())
v30.Sequence = v3(v8(v11(v31)))
v29.Props = v3(v10(v9(u6, v11(v30))))
v28.Compiled = v3(v8(v11(v29)))
return v11(v28)