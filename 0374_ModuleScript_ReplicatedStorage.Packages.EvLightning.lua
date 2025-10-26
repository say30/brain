--[[
  Extracted from: ReplicatedStorage.Packages.EvLightning
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local u1 = game:GetService("Debris")
local u2 = Instance.new("Part")
u2.Anchored = true
u2.CanCollide = false
u2.CanQuery = false
u2.CanTouch = false
u2.TopSurface = Enum.SurfaceType.Smooth
u2.BottomSurface = Enum.SurfaceType.Smooth
local u19 = {
    ["GetOptions"] = function(p3) --[[Function name: GetOptions, line 74]]
        return table.clone(p3.options)
    end,
    ["GetLines"] = function(p4) --[[Function name: GetLines, line 78]]
        local v5 = table.clone(p4.lines)
        for _, v6 in p4.branches do
            local v7 = v6:GetLines()
            table.move(v7, 1, #v7, #v5 + 1, v5)
        end
        return v5
    end,
    ["IsDestroyed"] = function(p8) --[[Function name: IsDestroyed, line 87]]
        return p8.destroyed or false
    end,
    ["IsDrawn"] = function(p9) --[[Function name: IsDrawn, line 91]]
        return p9.drew or false
    end,
    ["Draw"] = function(p10, p11) --[[Function name: Draw, line 95]]
        --[[
        Upvalues:
            [1] = u2
            [2] = u1
        --]]
        local v12 = Instance.new("Model")
        v12.Name = "LightningBolt"
        p10.model = v12
        for _, v13 in p10:GetLines() do
            local v14 = u2:Clone()
            local v15 = p10.thickness - v13.depth * 2 * 0.1
            v14.Material = p10.material
            v14.Color = p10.color
            local v16 = (v13.goal - v13.origin).Magnitude + 0.5
            v14.Size = Vector3.new(v15, v15, v16)
            v14.CFrame = CFrame.lookAt((v13.goal + v13.origin) * 0.5, v13.goal)
            v14.Transparency = v13.transparency
            v14.Parent = v12
        end
        v12.Parent = p11 or workspace.CurrentCamera
        p10.drew = true
        local v17 = p10.options.decay
        if v17 then
            u1:AddItem(v12, tonumber(v17) or 0)
            p10.destroyed = true
        end
    end,
    ["Destroy"] = function(p18) --[[Function name: Destroy, line 121]]
        if p18.model then
            p18.model:Destroy()
            p18.destroyed = true
        end
    end
}
local function u48(p20, p21, p22) --[[Anonymous function at line 128]]
    --[[
    Upvalues:
        [1] = u19
        [2] = u48
    --]]
    local v23 = typeof(p20) == "Vector3"
    assert(v23, "LightningBolt: `origin` must be a Vector3")
    local v24 = typeof(p21) == "Vector3"
    assert(v24, "LightningBolt: `goal` must be a Vector3")
    local v25 = p22 or {}
    local v26 = Random.new
    local v27
    if v25 then
        v27 = v25.seed
    else
        v27 = nil
    end
    local v28 = v26(v27)
    local v29 = {}
    local v30 = {
        ["options"] = v25 or {},
        ["random"] = v28,
        ["origin"] = p20,
        ["goal"] = p21,
        ["depth"] = v25.max_depth or 0,
        ["thickness"] = v25.thickness or 1,
        ["rep"] = v25.bends or 6,
        ["color"] = v25.color or Color3.fromRGB(255, 255, 255),
        ["material"] = v25.material or Enum.Material.Neon,
        ["branches"] = v29
    }
    local v31 = {
        ["__index"] = u19
    }
    local v32 = setmetatable(v30, v31)
    local v33 = {
        {
            ["origin"] = p20,
            ["goal"] = p21,
            ["transparency"] = v25.transparency or 0.4,
            ["depth"] = v32.depth
        }
    }
    v32.lines = v33
    for _ = 1, v32.rep do
        for v34 = 1, #v33 do
            local v35 = v33[v34]
            local v36 = v35.goal
            local v37 = v35.origin + (v36 - v35.origin) * (v28:NextInteger(40, 60) / 100)
            local v38 = v28:NextNumber()
            local v39 = v28:NextInteger(-530, 530) / 100
            local v40 = 3.141592653589793 * v38 * 2
            local v41 = math.sin(v40) * v39
            local v42 = 3.141592653589793 * v38 * 2
            local v43 = math.cos(v42) * v39
            v35.goal = (CFrame.lookAt(v37, v35.goal) * CFrame.new(v41, v43, 0)).Position
            local v44 = {
                ["origin"] = v35.goal,
                ["goal"] = v36,
                ["transparency"] = v35.transparency,
                ["depth"] = v35.depth
            }
            table.insert(v33, v44)
            if v35.depth <= (v25.max_depth or 3) then
                local v45 = (p20 - v35.goal).Magnitude / (p20 - p21).Magnitude
                if v28:NextInteger(1, 100) < (v25.fork_chance or 50) * v45 then
                    local v46 = v32:GetOptions()
                    v46.depth = v35.depth + 1
                    v46.bends = v46.fork_bends or 2
                    local v47 = u48(v35.goal, v35.goal + (v35.goal - v35.origin).Unit * v28:NextInteger(20, 40), v46)
                    table.insert(v29, v47)
                end
            end
        end
    end
    return v32
end
return {
    ["create"] = u48
}