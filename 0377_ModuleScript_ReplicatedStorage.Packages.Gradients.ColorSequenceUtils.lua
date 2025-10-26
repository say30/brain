--[[
  Extracted from: ReplicatedStorage.Packages.Gradients.ColorSequenceUtils
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local function u12(p1, p2) --[[Anonymous function at line 3]]
    local v3 = p2 + 1
    local v4 = {}
    for v5 = 0, 2 do
        for v6 = 1, #p1 do
            local v7 = {
                ["Time"] = p1[v6].Time + v5,
                ["Value"] = p1[v6].Value
            }
            table.insert(v4, v7)
        end
    end
    for v8 = 1, #v4 - 1 do
        local v9 = v4[v8]
        local v10 = v4[v8 + 1]
        if v9.Time <= v3 and v3 < v10.Time then
            local v11 = (v3 - v9.Time) / (v10.Time - v9.Time)
            return Color3.new((v10.Value.R - v9.Value.R) * v11 + v9.Value.R, (v10.Value.G - v9.Value.G) * v11 + v9.Value.G, (v10.Value.B - v9.Value.B) * v11 + v9.Value.B)
        end
    end
end
return {
    ["calculateColorSequence"] = function(p13, p14) --[[Function name: calculateColorSequence, line 31]]
        --[[
        Upvalues:
            [1] = u12
        --]]
        local v15 = 100
        local v16 = 5
        local v17 = {}
        for _, v18 in p13.Keypoints do
            local v19 = ColorSequenceKeypoint.new((v18.Time + p14) % 1, v18.Value)
            if v19.Time <= v15 then
                v17[v16 - 1] = v19
                v16 = v16 - 1
                v15 = v19.Time
            else
                v17[#v17 + 1] = v19
            end
        end
        local v20 = {}
        for _, v21 in v17 do
            table.insert(v20, v21)
        end
        table.sort(v20, function(p22, p23) --[[Anonymous function at line 52]]
            return p22.Time < p23.Time
        end)
        if v20[1].Time ~= 0 then
            local v24 = ColorSequenceKeypoint.new(0, u12(v20, 0))
            table.insert(v20, 1, v24)
        end
        if v20[#v20].Time ~= 1 then
            local v25 = ColorSequenceKeypoint.new(1, u12(v20, 1))
            table.insert(v20, v25)
        end
        return ColorSequence.new(v20)
    end
}