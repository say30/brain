--[[
  Extracted from: ReplicatedStorage.Packages.Spr
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local v1 = game:GetService("RunService")
local u2 = math.exp
local u3 = math.sin
local u4 = math.cos
local u5 = math.min
local u6 = math.max
local u7 = math.sqrt
local u8 = math.atan2
local u9 = math.round
local u10 = {}
u10.__index = u10
function u10.new(p11, p12, p13, p14, p15) --[[Anonymous function at line 91]]
    --[[
    Upvalues:
        [1] = u10
    --]]
    local v16 = p15.toIntermediate(p13)
    local v17 = {
        ["d"] = p11,
        ["f"] = p12,
        ["g"] = v16,
        ["p"] = v16,
        ["v"] = table.create(#v16, 0),
        ["typedat"] = p15,
        ["rawGoal"] = p14
    }
    local v18 = u10
    return setmetatable(v17, v18)
end
function u10.setGoal(p19, p20) --[[Anonymous function at line 107]]
    p19.rawGoal = p20
    p19.g = p19.typedat.toIntermediate(p20)
end
function u10.setDampingRatio(p21, p22) --[[Anonymous function at line 112]]
    p21.d = p22
end
function u10.setFrequency(p23, p24) --[[Anonymous function at line 116]]
    p23.f = p24
end
function u10.canSleep(p25) --[[Anonymous function at line 120]]
    local v26 = 0
    for _, v27 in p25.v do
        v26 = v26 + v27 ^ 2
    end
    if v26 > 0.0001 then
        return false
    end
    local v28 = p25.p
    local v29 = p25.g
    local v30 = 0
    for v31, v32 in v28 do
        v30 = v30 + (v29[v31] - v32) ^ 2
    end
    return v30 <= 6.781684027777778e-8
end
function u10.step(p33, p34) --[[Anonymous function at line 132]]
    --[[
    Upvalues:
        [1] = u2
        [2] = u7
        [3] = u4
        [4] = u3
    --]]
    local v35 = p33.d
    local v36 = p33.f * 6.283185307179586
    local v37 = p33.g
    local v38 = p33.p
    local v39 = p33.v
    if v35 == 1 then
        local v40 = u2(-v36 * p34)
        local v41 = p34 * v40
        local v42 = v40 + v41 * v36
        local v43 = v40 - v41 * v36
        local v44 = v41 * v36 * v36
        for v45 = 1, #v38 do
            local v46 = v38[v45] - v37[v45]
            v38[v45] = v46 * v42 + v39[v45] * v41 + v37[v45]
            v39[v45] = v39[v45] * v43 - v46 * v44
        end
    elseif v35 < 1 then
        local v47 = u2(-v35 * v36 * p34)
        local v48 = u7(1 - v35 * v35)
        local v49 = u4(p34 * v36 * v48)
        local v50 = u3(p34 * v36 * v48)
        local v51
        if v48 > 0.00001 then
            v51 = v50 / v48
        else
            local v52 = p34 * v36
            v51 = v52 + (v52 * v52 * (v48 * v48) * (v48 * v48) / 20 - v48 * v48) * (v52 * v52 * v52) / 6
        end
        local v53
        if v36 * v48 > 0.00001 then
            v53 = v50 / (v36 * v48)
        else
            local v54 = v36 * v48
            v53 = p34 + (p34 * p34 * (v54 * v54) * (v54 * v54) / 20 - v54 * v54) * (p34 * p34 * p34) / 6
        end
        for v55 = 1, #v38 do
            local v56 = v38[v55] - v37[v55]
            v38[v55] = (v56 * (v49 + v51 * v35) + v39[v55] * v53) * v47 + v37[v55]
            v39[v55] = (v39[v55] * (v49 - v51 * v35) - v56 * (v51 * v36)) * v47
        end
    else
        local v57 = u7(v35 * v35 - 1)
        local v58 = -v36 * (v35 + v57)
        local v59 = -v36 * (v35 - v57)
        local v60 = u2(v58 * p34)
        local v61 = u2(v59 * p34)
        for v62 = 1, #v38 do
            local v63 = v38[v62] - v37[v62]
            local v64 = (v39[v62] - v63 * v58) / (2 * v36 * v57)
            local v65 = v60 * (v63 - v64)
            v38[v62] = v65 + v64 * v61 + v37[v62]
            v39[v62] = v65 * v58 + v64 * v61 * v59
        end
    end
    return p33.typedat.fromIntermediate(p33.p)
end
local u66 = {}
u66.__index = u66
function u66.new(p67, p68, p69, p70) --[[Anonymous function at line 248]]
    --[[
    Upvalues:
        [1] = u66
    --]]
    local v71 = {
        ["d"] = p67,
        ["f"] = p68,
        ["g"] = p70:Orthonormalize(),
        ["p"] = p69:Orthonormalize(),
        ["v"] = Vector3.new(0, 0, 0)
    }
    local v72 = u66
    return setmetatable(v71, v72)
end
function u66.setGoal(p73, p74) --[[Anonymous function at line 261]]
    p73.g = p74:Orthonormalize()
end
function u66.setDampingRatio(p75, p76) --[[Anonymous function at line 265]]
    p75.d = p76
end
function u66.setFrequency(p77, p78) --[[Anonymous function at line 269]]
    p77.f = p78
end
local function u91(p79, p80) --[[Anonymous function at line 286]]
    --[[
    Upvalues:
        [1] = u6
        [2] = u7
        [3] = u8
    --]]
    local v81 = p79.XVector
    local v82 = p80.XVector
    local v83 = v81.X * v82.X + v81.Y * v82.Y + v81.Z * v82.Z
    local v84 = p79.YVector
    local v85 = p80.YVector
    local v86 = v84.X * v85.X + v84.Y * v85.Y + v84.Z * v85.Z
    local v87 = p79.ZVector
    local v88 = p80.ZVector
    local v89 = v87.X * v88.X + v87.Y * v88.Y + v87.Z * v88.Z
    local v90 = v83 + v86 + v89 - 1
    return u8(u7((u6(0, 1 - v90 * v90 * 0.25))), v90 * 0.5)
end
local function u114(p92, p93) --[[Anonymous function at line 295]]
    --[[
    Upvalues:
        [1] = u4
        [2] = u3
    --]]
    local v94 = u4(p93)
    local v95 = u3(p93)
    local v96 = p92.X
    local v97 = p92.Y
    local v98 = p92.Z
    local v99 = v96 * v97 * (1 - v94)
    local v100 = v97 * v98 * (1 - v94)
    local v101 = v98 * v96 * (1 - v94)
    local v102 = v96 * v96 * (1 - v94) + v94
    local v103 = v99 + v98 * v95
    local v104 = v101 - v97 * v95
    local v105 = Vector3.new(v102, v103, v104)
    local v106 = v99 - v98 * v95
    local v107 = v97 * v97 * (1 - v94) + v94
    local v108 = v100 + v96 * v95
    local v109 = Vector3.new(v106, v107, v108)
    local v110 = v101 + v97 * v95
    local v111 = v100 - v96 * v95
    local v112 = v98 * v98 * (1 - v94) + v94
    local v113 = Vector3.new(v110, v111, v112)
    return CFrame.fromMatrix(Vector3.new(0, 0, 0), v105, v109, v113):Orthonormalize()
end
function u66.canSleep(p115) --[[Anonymous function at line 330]]
    local v116 = p115.p
    local v117 = p115.g
    local v118 = v116.XVector
    local v119 = v117.XVector
    local v120 = v118.X * v119.X + v118.Y * v119.Y + v118.Z * v119.Z
    local v121 = v116.YVector
    local v122 = v117.YVector
    local v123 = v121.X * v122.X + v121.Y * v122.Y + v121.Z * v122.Z
    local v124 = v116.ZVector
    local v125 = v117.ZVector
    local v126 = v124.X * v125.X + v124.Y * v125.Y + v124.Z * v125.Z
    return v120 + v123 + v126 > 2.9999999695382584 and p115.v.Magnitude < 0.0017453292519943296
end
function u66.step(p127, p128) --[[Anonymous function at line 336]]
    --[[
    Upvalues:
        [1] = u91
        [2] = u2
        [3] = u114
        [4] = u7
        [5] = u4
        [6] = u3
    --]]
    local v129 = p127.d
    local v130 = p127.f * 6.283185307179586
    local v131 = p127.g
    local v132 = p127.p
    local v133 = p127.v
    local v134 = (v132 * v131:Inverse()):ToAxisAngle()
    local v135 = u91(v132, v131)
    local v136 = v134.Unit * v135
    local v137 = u2(-v129 * v130 * p128)
    local v138, v139
    if v129 == 1 then
        local v140 = (v136 * (1 + v130 * p128) + v133 * p128) * v137
        local v141 = CFrame.identity
        local v142 = v140.Magnitude
        if v142 > 1e-6 then
            v141 = u114(v140.Unit, v142)
        end
        v138 = v141 * v131
        v139 = (v133 * (1 - p128 * v130) - v136 * (p128 * v130 * v130)) * v137
    elseif v129 < 1 then
        local v143 = u7(1 - v129 * v129)
        local v144 = u4(p128 * v130 * v143)
        local v145 = u3(p128 * v130 * v143)
        local v146 = v145 / (v130 * v143)
        local v147 = v145 / v143
        local v148 = (v136 * (v144 + v147 * v129) + v133 * v146) * v137
        local v149 = CFrame.identity
        local v150 = v148.Magnitude
        if v150 > 1e-6 then
            v149 = u114(v148.Unit, v150)
        end
        v138 = v149 * v131
        v139 = (v133 * (v144 - v147 * v129) - v136 * (v147 * v130)) * v137
    else
        local v151 = u7(v129 * v129 - 1)
        local v152 = -v130 * (v129 + v151)
        local v153 = -v130 * (v129 - v151)
        local v154 = (v133 - v136 * v152) / (2 * v130 * v151)
        local v155 = (v136 - v154) * u2(v152 * p128)
        local v156 = v154 * u2(v153 * p128)
        local v157 = v155 + v156
        local v158 = CFrame.identity
        local v159 = v157.Magnitude
        if v159 > 1e-6 then
            v158 = u114(v157.Unit, v159)
        end
        v138 = v158 * v131
        v139 = v155 * v152 + v156 * v153
    end
    p127.p = v138
    p127.v = v139
    return v138
end
local u165 = {
    ["springType"] = u10.new,
    ["toIntermediate"] = function(p160) --[[Function name: toIntermediate, line 392]]
        return { p160.X, p160.Y, p160.Z }
    end,
    ["fromIntermediate"] = function(p161) --[[Function name: fromIntermediate, line 396]]
        local v162 = p161[1]
        local v163 = p161[2]
        local v164 = p161[3]
        return Vector3.new(v162, v163, v164)
    end
}
local u166 = {}
u166.__index = u166
function u166.new(p167, p168, p169, p170, _) --[[Anonymous function at line 406]]
    --[[
    Upvalues:
        [1] = u10
        [2] = u165
        [3] = u66
        [4] = u166
    --]]
    local v171 = {
        ["rawGoal"] = p170,
        ["_position"] = u10.new(p167, p168, p169.Position, p170.Position, u165),
        ["_rotation"] = u66.new(p167, p168, p169.Rotation, p170.Rotation)
    }
    local v172 = u166
    return setmetatable(v171, v172)
end
function u166.setGoal(p173, p174) --[[Anonymous function at line 423]]
    p173.rawGoal = p174
    p173._position:setGoal(p174.Position)
    p173._rotation:setGoal(p174.Rotation)
end
function u166.setDampingRatio(p175, p176) --[[Anonymous function at line 429]]
    p175._position.d = p176
    p175._rotation.d = p176
end
function u166.setFrequency(p177, p178) --[[Anonymous function at line 434]]
    p177._position.f = p178
    p177._rotation.f = p178
end
function u166.canSleep(p179) --[[Anonymous function at line 439]]
    local v180 = p179._position:canSleep()
    if v180 then
        v180 = p179._rotation:canSleep()
    end
    return v180
end
function u166.step(p181, p182) --[[Anonymous function at line 443]]
    local v183 = p181._position:step(p182)
    return p181._rotation:step(p182) + v183
end
local function u197(p184) --[[Anonymous function at line 462]]
    local v185 = p184.R
    local v186 = p184.G
    local v187 = p184.B
    local v188 = v185 < 0.0404482362771076 and v185 / 12.92 or 0.87941546140213 * (v185 + 0.055) ^ 2.4
    local v189 = v186 < 0.0404482362771076 and v186 / 12.92 or 0.87941546140213 * (v186 + 0.055) ^ 2.4
    local v190 = v187 < 0.0404482362771076 and v187 / 12.92 or 0.87941546140213 * (v187 + 0.055) ^ 2.4
    local v191 = 0.9257063972951867 * v188 - 0.8333736323779866 * v189 - 0.09209820666085898 * v190
    local v192 = 0.2125862307855956 * v188 + 0.7151703037034108 * v189 + 0.0722004986433362 * v190
    local v193 = 3.6590806972265884 * v188 + 11.442689580057424 * v189 + 4.114991502426484 * v190
    local v194 = v192 > 0.008856451679035631 and 116 * v192 ^ 0.3333333333333333 - 16 or 903.296296296296 * v192
    local v195, v196
    if v193 > 1e-14 then
        v195 = v194 * v191 / v193
        v196 = v194 * (9 * v192 / v193 - 0.46832)
    else
        v195 = -0.19783 * v194
        v196 = -0.46832 * v194
    end
    return { v194, v195, v196 }
end
local function u209(p198) --[[Anonymous function at line 491]]
    --[[
    Upvalues:
        [1] = u5
    --]]
    local v199 = p198[1]
    if v199 < 0.0197955 then
        return Color3.new(0, 0, 0)
    end
    local v200 = p198[2] / v199 + 0.19783
    local v201 = p198[3] / v199 + 0.46832
    local v202 = (v199 + 16) / 116
    local v203 = v202 > 0.20689655172413793 and v202 * v202 * v202 or v202 * 0.12841854934601665 - 0.01771290335807126
    local v204 = v203 * v200 / v201
    local v205 = v203 * ((3 - v200 * 0.75) / v201 - 5)
    local v206 = v204 * 7.2914074 - v203 * 1.537208 - v205 * 0.4986286
    local v207 = v204 * -2.180094 + v203 * 1.8757561 + v205 * 0.0415175
    local v208 = v204 * 0.1253477 - v203 * 0.2040211 + v205 * 1.0569959
    if v206 < 0 and (v206 < v207 and v206 < v208) then
        v207 = v207 - v206
        v208 = v208 - v206
        v206 = 0
    elseif v207 < 0 and v207 < v208 then
        v206 = v206 - v207
        v208 = v208 - v207
        v207 = 0
    elseif v208 < 0 then
        v206 = v206 - v208
        v207 = v207 - v208
        v208 = 0
    end
    return Color3.new(u5(v206 < 0.0031306684425 and 12.92 * v206 or 1.055 * v206 ^ 0.4166666666666667 - 0.055, 1), u5(v207 < 0.0031306684425 and 12.92 * v207 or 1.055 * v207 ^ 0.4166666666666667 - 0.055, 1), (u5(v208 < 0.0031306684425 and 12.92 * v208 or 1.055 * v208 ^ 0.4166666666666667 - 0.055, 1)))
end
local u229 = {
    ["boolean"] = {
        ["springType"] = u10.new,
        ["toIntermediate"] = function(p210) --[[Function name: toIntermediate, line 537]]
            return { p210 and 1 or 0 }
        end,
        ["fromIntermediate"] = function(p211) --[[Function name: fromIntermediate, line 541]]
            return p211[1] >= 0.5
        end
    },
    ["number"] = {
        ["springType"] = u10.new,
        ["toIntermediate"] = function(p212) --[[Function name: toIntermediate, line 549]]
            return { p212 }
        end,
        ["fromIntermediate"] = function(p213) --[[Function name: fromIntermediate, line 553]]
            return p213[1]
        end
    },
    ["NumberRange"] = {
        ["springType"] = u10.new,
        ["toIntermediate"] = function(p214) --[[Function name: toIntermediate, line 561]]
            return { p214.Min, p214.Max }
        end,
        ["fromIntermediate"] = function(p215) --[[Function name: fromIntermediate, line 565]]
            return NumberRange.new(p215[1], p215[2])
        end
    },
    ["UDim"] = {
        ["springType"] = u10.new,
        ["toIntermediate"] = function(p216) --[[Function name: toIntermediate, line 573]]
            return { p216.Scale, p216.Offset }
        end,
        ["fromIntermediate"] = function(p217) --[[Function name: fromIntermediate, line 577]]
            --[[
            Upvalues:
                [1] = u9
            --]]
            return UDim.new(p217[1], (u9(p217[2])))
        end
    },
    ["UDim2"] = {
        ["springType"] = u10.new,
        ["toIntermediate"] = function(p218) --[[Function name: toIntermediate, line 585]]
            local v219 = p218.X
            local v220 = p218.Y
            return {
                v219.Scale,
                v219.Offset,
                v220.Scale,
                v220.Offset
            }
        end,
        ["fromIntermediate"] = function(p221) --[[Function name: fromIntermediate, line 591]]
            --[[
            Upvalues:
                [1] = u9
            --]]
            return UDim2.new(p221[1], u9(p221[2]), p221[3], (u9(p221[4])))
        end
    },
    ["Vector2"] = {
        ["springType"] = u10.new,
        ["toIntermediate"] = function(p222) --[[Function name: toIntermediate, line 599]]
            return { p222.X, p222.Y }
        end,
        ["fromIntermediate"] = function(p223) --[[Function name: fromIntermediate, line 603]]
            return Vector2.new(p223[1], p223[2])
        end
    },
    ["Vector3"] = u165,
    ["Color3"] = {
        ["springType"] = u10.new,
        ["toIntermediate"] = u197,
        ["fromIntermediate"] = u209
    },
    ["ColorSequence"] = {
        ["springType"] = u10.new,
        ["toIntermediate"] = function(p224) --[[Function name: toIntermediate, line 620]]
            --[[
            Upvalues:
                [1] = u197
            --]]
            local v225 = p224.Keypoints
            local v226 = u197(v225[1].Value)
            local v227 = u197(v225[#v225].Value)
            return {
                v226[1],
                v226[2],
                v226[3],
                v227[1],
                v227[2],
                v227[3]
            }
        end,
        ["fromIntermediate"] = function(p228) --[[Function name: fromIntermediate, line 632]]
            --[[
            Upvalues:
                [1] = u209
            --]]
            return ColorSequence.new(u209({ p228[1], p228[2], p228[3] }), u209({ p228[4], p228[5], p228[6] }))
        end
    },
    ["CFrame"] = {
        ["springType"] = u166.new,
        ["toIntermediate"] = error,
        ["fromIntermediate"] = error
    }
}
local u236 = {
    ["Pivot"] = {
        ["class"] = "PVInstance",
        ["get"] = function(p230) --[[Function name: get, line 658]]
            return p230:GetPivot()
        end,
        ["set"] = function(p231, p232) --[[Function name: set, line 661]]
            p231:PivotTo(p232)
        end
    },
    ["Scale"] = {
        ["class"] = "Model",
        ["get"] = function(p233) --[[Function name: get, line 667]]
            return p233:GetScale()
        end,
        ["set"] = function(p234, p235) --[[Function name: set, line 670]]
            p234:ScaleTo((math.clamp(p235, 1.402e-45, 16777216)))
        end
    }
}
local u237 = {}
local u238 = {}
local u239 = {}
local function u252(p240, p241) --[[Anonymous function at line 702]]
    --[[
    Upvalues:
        [1] = u236
        [2] = u239
    --]]
    for v242, v243 in p240 do
        for v244, v245 in v243 do
            if v245:canSleep() then
                v243[v244] = nil
                local v246 = v245.rawGoal
                local v247 = u236[v244]
                if v247 and v242:IsA(v247.class) then
                    v247.set(v242, v246)
                else
                    v242[v244] = v246
                end
            else
                local v248 = v245:step(p241)
                local v249 = u236[v244]
                if v249 and v242:IsA(v249.class) then
                    v249.set(v242, v248)
                else
                    v242[v244] = v248
                end
            end
        end
        if not next(v243) then
            p240[v242] = nil
            local v250 = u239[v242]
            if v250 then
                u239[v242] = nil
                for _, v251 in v250 do
                    task.spawn(v251)
                end
            end
        end
    end
end
v1.PreSimulation:Connect(function(p253) --[[Anonymous function at line 731]]
    --[[
    Upvalues:
        [1] = u252
        [2] = u237
    --]]
    u252(u237, p253)
end)
v1.PostSimulation:Connect(function(p254) --[[Anonymous function at line 735]]
    --[[
    Upvalues:
        [1] = u252
        [2] = u238
    --]]
    u252(u238, p254)
end)
return table.freeze({
    ["target"] = function(p255, p256, p257, p258) --[[Function name: target, line 748]]
        --[[
        Upvalues:
            [1] = u238
            [2] = u237
            [3] = u236
            [4] = u229
        --]]
        if not ("Instance"):find((typeof(p255))) then
            error(("bad argument #%* to %* (%* expected, got %*)"):format(1, "spr.target", "Instance", (typeof(p255))), 3)
        end
        if not ("number"):find((typeof(p256))) then
            error(("bad argument #%* to %* (%* expected, got %*)"):format(2, "spr.target", "number", (typeof(p256))), 3)
        end
        if not ("number"):find((typeof(p257))) then
            error(("bad argument #%* to %* (%* expected, got %*)"):format(3, "spr.target", "number", (typeof(p257))), 3)
        end
        if not ("table"):find((typeof(p258))) then
            error(("bad argument #%* to %* (%* expected, got %*)"):format(4, "spr.target", "table", (typeof(p258))), 3)
        end
        if p256 ~= p256 or p256 < 0 then
            error(("expected damping ratio >= 0; got %.2f"):format(p256), 2)
        end
        if p257 ~= p257 or p257 < 0 then
            error(("expected undamped frequency >= 0; got %.2f"):format(p257), 2)
        end
        local v259
        if p255:IsA("Camera") then
            v259 = u238
        else
            v259 = u237
        end
        local v260 = v259[p255]
        if not v260 then
            v260 = {}
            v259[p255] = v260
        end
        for v261, v262 in p258 do
            local v263 = u236[v261]
            local v264
            if v263 and p255:IsA(v263.class) then
                v264 = v263.get(p255)
            else
                v264 = p255[v261]
            end
            if typeof(v262) ~= typeof(v264) then
                error(("bad property %* to spr.target (%* expected, got %*)"):format(v261, typeof(v264), (typeof(v262))), 2)
            end
            if p257 == (1 / 0) then
                local v265 = u236[v261]
                if v265 and p255:IsA(v265.class) then
                    v265.set(p255, v262)
                else
                    p255[v261] = v262
                end
                v260[v261] = nil
            else
                local v266 = v260[v261]
                if not v266 then
                    local v267 = u229[typeof(v262)]
                    if not v267 then
                        error("unsupported type: " .. typeof(v262), 2)
                    end
                    v266 = v267.springType(p256, p257, v264, v262, v267)
                    v260[v261] = v266
                end
                v266:setGoal(v262)
                v266:setDampingRatio(p256)
                v266:setFrequency(p257)
            end
        end
        if not next(v260) then
            v259[p255] = nil
        end
    end,
    ["stop"] = function(p268, p269) --[[Function name: stop, line 807]]
        --[[
        Upvalues:
            [1] = u237
            [2] = u238
        --]]
        if not ("Instance"):find((typeof(p268))) then
            error(("bad argument #%* to %* (%* expected, got %*)"):format(1, "spr.stop", "Instance", (typeof(p268))), 3)
        end
        if not ("string|nil"):find((typeof(p269))) then
            error(("bad argument #%* to %* (%* expected, got %*)"):format(2, "spr.stop", "string|nil", (typeof(p269))), 3)
        end
        if p269 then
            local v270 = u237[p268] or u238[p268]
            if v270 then
                v270[p269] = nil
                return
            end
        else
            u237[p268] = nil
            u238[p268] = nil
        end
    end,
    ["completed"] = function(p271, p272) --[[Function name: completed, line 824]]
        --[[
        Upvalues:
            [1] = u239
        --]]
        if not ("Instance"):find((typeof(p271))) then
            error(("bad argument #%* to %* (%* expected, got %*)"):format(1, "spr.completed", "Instance", (typeof(p271))), 3)
        end
        if not ("function"):find((typeof(p272))) then
            error(("bad argument #%* to %* (%* expected, got %*)"):format(2, "spr.completed", "function", (typeof(p272))), 3)
        end
        local v273 = u239[p271]
        if v273 then
            table.insert(v273, p272)
        else
            u239[p271] = { p272 }
        end
    end
})