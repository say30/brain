--[[
  Extracted from: ReplicatedStorage.Packages.Moonlite
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local v1 = {}
require(script.Types)
local u2 = require(script.Specials)
local u3 = require(script.EaseFuncs)
local v4 = game:GetService("RunService")
game:GetService("HttpService")
local u5 = {}
u5.__index = u5
local u6 = {
    ["Instance"] = true,
    ["boolean"] = true,
    ["string"] = true,
    ["nil"] = true
}
local u7 = {}
local function u11(p8, p9, p10) --[[Anonymous function at line 99]]
    if type(p8) == "number" then
        return math.lerp(p8, p9, p10)
    else
        return p8:Lerp(p9, p10)
    end
end
local function u18(p12) --[[Anonymous function at line 107]]
    --[[
    Upvalues:
        [1] = u18
    --]]
    local v13 = {}
    for v16, v17 in next, p12 do
        if type(v16) == "table" then
            local v16 = u18(v16)
        end
        if type(v17) == "table" then
            local v17 = u18(v17)
        end
        v13[v16] = v17
    end
    return v13
end
local function u20(p19) --[[Anonymous function at line 116]]
    return table.concat(p19.InstanceNames, ".")
end
local function u33(u21, p22) --[[Anonymous function at line 145]]
    if not u21 then
        return nil
    end
    local u23 = #u21.InstanceNames
    local u24 = p22 or game
    local v31, v32 = pcall(function() --[[Anonymous function at line 153]]
        --[[
        Upvalues:
            [1] = u23
            [2] = u21
            [3] = u24
        --]]
        for v25 = 2, u23 do
            local v26 = u21.InstanceNames[v25]
            local v27 = u21.InstanceTypes[v25]
            if v26 == "CoreGui" then
                u21.InstanceNames[v25] = "ReplicatedStorage"
                u21.InstanceTypes[v25] = "ReplicatedStorage"
                v26 = u21.InstanceNames[v25]
                v27 = u21.InstanceTypes[v25]
            end
            local v28 = u24:FindFirstChild(v26)
            local v29 = typeof(v28) == "Instance"
            assert(v29)
            local v30 = v28.ClassName == v27
            assert(v30)
            u24 = v28
        end
    end)
    if v31 then
        return u24
    end
    warn("!! PATH RESOLVE FAILED:", table.concat(u21.InstanceNames, "."), "\n", v32)
    return nil
end
local function u50(p34) --[[Anonymous function at line 181]]
    local v35 = {}
    local v36 = {}
    for _, v37 in p34:GetDescendants() do
        if v37:IsA("Motor6D") and v37.Active then
            local v38 = v37.Part1
            if v38 then
                v38 = v38.Name
            end
            if v38 then
                v35[v38] = {
                    ["Name"] = v38,
                    ["Joint"] = v37,
                    ["Children"] = {}
                }
            end
        elseif v37:IsA("Bone") then
            local v39 = v37.Name
            v35[v39] = {
                ["Name"] = v39,
                ["Joint"] = v37,
                ["Children"] = {}
            }
        end
    end
    for v40, v41 in v35 do
        local v42 = v41.Joint
        if v42:IsA("Motor6D") then
            local v43 = v42.Part0
            if v43 then
                local v44 = v35[v43.Name]
                if v44 then
                    v44.Children[v40] = v41
                    v41.Parent = v44
                end
            end
        elseif v42:IsA("Bone") then
            local v45 = v42.Parent
            if v45 then
                local v46 = v35[v45.Name]
                if v46 then
                    v46.Children[v40] = v41
                    v41.Parent = v46
                end
            end
        end
    end
    for _, v47 in v35 do
        local v48 = v47.Name
        local v49 = v47.Parent
        while v49 do
            v48 = ("%*.%*"):format(v49.Name, v48)
            v49 = v49.Parent
        end
        v36[v48] = v47
    end
    return v36
end
local function u58(p51) --[[Anonymous function at line 248]]
    local v52 = p51:FindFirstChild("Type")
    local v53 = p51:FindFirstChild("Params")
    local v54 = {}
    local v55
    if v52 and v52:IsA("StringValue") then
        v55 = v52.Value
    else
        v55 = nil
    end
    v54.Type = assert(v55)
    v54.Params = {}
    if v53 then
        for _, v56 in v53:GetChildren() do
            if v56:IsA("ValueBase") then
                local v57 = v56.Value
                v54.Params[v56.Name] = v57
            end
        end
    end
    return v54
end
local function u65(p59) --[[Anonymous function at line 273]]
    local v60 = p59:FindFirstChild("Style")
    local v61
    if v60 then
        v61 = v60:IsA("StringValue")
    else
        v61 = v60
    end
    assert(v61, "No style in legacy ease!")
    local v62 = p59:FindFirstChild("Direction")
    local v63
    if v62 then
        v63 = v62:IsA("StringValue")
    else
        v63 = v62
    end
    assert(v63, "No direction in legacy ease!")
    local v64 = {
        ["Type"] = v60.Value,
        ["Params"] = {
            ["Direction"] = v62.Value
        }
    }
    return v64
end
local function u72(p66) --[[Anonymous function at line 289]]
    if not p66:IsA("ValueBase") then
        return p66:GetAttribute("Value")
    end
    local v67 = p66.Name
    local v68
    if tonumber(v67) then
        local v69 = p66.Parent
        v68 = assert(v69)
    else
        v68 = p66
    end
    local v70 = p66.Value
    local v71 = v68:FindFirstChild("EnumType")
    if v71 and v71:IsA("StringValue") then
        return Enum[v71.Value][v70]
    end
    if v68:FindFirstChild("Vector2") then
        return Vector2.new(v70.X, v70.Y)
    end
    if v68:FindFirstChild("ColorSequence") then
        return ColorSequence.new(v70)
    end
    if v68:FindFirstChild("NumberSequence") then
        return NumberSequence.new(v70)
    end
    if v68:FindFirstChild("NumberRange") then
        v70 = NumberRange.new(v70)
    end
    return v70
end
local function u78(p73, u74, u75) --[[Anonymous function at line 317]]
    --[[
    Upvalues:
        [1] = u2
    --]]
    local v76 = u74 and u2.Get(p73._scratch, u74, u75)
    if v76 then
        local v77 = v76.Get
        if v77 then
            return pcall(v77, u74)
        else
            return true, v76.Default
        end
    else
        return pcall(function() --[[Anonymous function at line 332]]
            --[[
            Upvalues:
                [1] = u74
                [2] = u75
            --]]
            return u74[u75]
        end)
    end
end
local function u85(p79, u80, u81, u82, p83) --[[Anonymous function at line 337]]
    --[[
    Upvalues:
        [1] = u2
    --]]
    local v84 = u80 and u2.Get(p79._scratch, u80, u81)
    if not v84 then
        return pcall(function() --[[Anonymous function at line 354]]
            --[[
            Upvalues:
                [1] = u80
                [2] = u81
                [3] = u82
            --]]
            u80[u81] = u82
        end)
    end
    if v84.Get == nil and (p83 and u82 == true) then
        u82 = false
    end
    return pcall(v84.Set, u82)
end
local function u105(p86) --[[Anonymous function at line 359]]
    --[[
    Upvalues:
        [1] = u72
        [2] = u58
        [3] = u65
    --]]
    local v87 = p86.Name
    local v88 = tonumber(v87)
    assert(v88, "Bad frame number")
    local v89 = p86:FindFirstChild("Values")
    assert(v89, "No value folder!")
    local v90 = v89:FindFirstChild("0")
    assert(v90, "No starting value!")
    local v91 = {}
    local v92 = 0
    for _, v93 in v89:GetChildren() do
        local v94 = v93.Name
        local v95 = tonumber(v94)
        if v95 then
            local v96, v97 = pcall(u72, v93)
            if v96 then
                v91[v95] = v97
                v92 = math.max(v95, v92)
            end
        end
    end
    local v98 = p86:FindFirstChild("Eases")
    local v99 = p86:FindFirstChild("Ease")
    local v100 = {}
    if v98 then
        for _, v101 in v98:GetChildren() do
            local v102 = v101.Name
            local v103 = tonumber(v102)
            local v104 = ("Bad index on ease @%*"):format((v101:GetFullName()))
            assert(v103, v104)
            v100[v103] = u58(v101)
        end
    elseif v99 then
        v100[v92] = u65(v99)
    end
    return {
        ["FrameIndex"] = v88,
        ["FrameCount"] = v92,
        ["Values"] = v91,
        ["Eases"] = v100
    }
end
local function u124(p106, p107) --[[Anonymous function at line 410]]
    --[[
    Upvalues:
        [1] = u105
    --]]
    local v108 = {}
    local v109 = {}
    local v110 = {}
    for _, v111 in p106:GetChildren() do
        local v112 = v111.Name
        local v113 = tonumber(v112)
        if v113 then
            v108[v113] = u105(v111)
            table.insert(v109, v113)
        end
    end
    table.sort(v109)
    for v114 = 2, #v109 do
        local v115 = v108[v109[v114 - 1]]
        local v116 = v108[v109[v114]]
        v115.Next = v116
        v116.Prev = v115
    end
    local v117 = v108[v109[1]]
    while v117 do
        local v118 = v117.FrameIndex
        local v119 = nil
        for v120 = 0, v117.FrameCount do
            local v121 = v117.Eases[v120] or v119
            local v122 = v117.Values[v120]
            if v122 ~= nil then
                if p107 then
                    v122 = p107(v122)
                end
                local v123 = {
                    ["Time"] = v118 + v120,
                    ["Value"] = v122,
                    ["Ease"] = v121
                }
                table.insert(v110, v123)
                if v121 then
                    v119 = v121
                end
            end
        end
        v117 = v117.Next
    end
    return v110
end
local function u176(p125, p126, p127) --[[Anonymous function at line 474]]
    --[[
    Upvalues:
        [1] = u33
        [2] = u50
        [3] = u72
        [4] = u124
        [5] = u2
    --]]
    local v128 = p125._data
    if v128 then
        v128 = p125._save
    end
    assert(v128, "This track is already compiled from source")
    local v129 = table.find(p125._data.Items, p126)
    if v129 then
        local v130 = p126.Path
        local v131 = v130.ItemType
        local v132 = p126.Override or u33(v130, p125._root)
        local v133 = p125._save:FindFirstChild((tostring(v129)))
        if v132 and v133 then
            assert(v132)
            assert(v133)
            local v134 = v133:FindFirstChild("Rig")
            local v135 = v133:FindFirstChild("MarkerTrack")
            if v134 and v131 == "Rig" then
                local v136 = u50(v132)
                for _, v137 in v134:GetChildren() do
                    if v137.Name == "_joint" then
                        local v138 = v137:FindFirstChild("_hier")
                        local u139 = v137:FindFirstChild("default")
                        local v140 = v137:FindFirstChild("_keyframes")
                        if u139 then
                            u139 = u72(u139)
                        end
                        local v141 = v138 and v140 and v136[u72(v138)]
                        if v141 then
                            local v142 = v141.Joint
                            local v143 = {}
                            local v144 = {
                                ["Default"] = CFrame.identity
                            }
                            local v145
                            if v142:IsA("Motor6D") then
                                v145 = u124(v140, function(p146) --[[Anonymous function at line 526]]
                                    --[[
                                    Upvalues:
                                        [1] = u139
                                    --]]
                                    return p146:Inverse() * u139
                                end)
                            else
                                v145 = u124(v140, function(p147) --[[Anonymous function at line 529]]
                                    return p147
                                end)
                            end
                            v144.Sequence = v145
                            v143.Transform = v144
                            p127[v142] = {
                                ["Props"] = v143,
                                ["Target"] = v142
                            }
                        end
                    end
                end
            end
            local v148 = {}
            for _, v149 in v133:GetChildren() do
                if v149:IsA("Folder") and (v149 ~= v135 and v149.Name ~= "Rig") then
                    local v150 = v149:FindFirstChild("default")
                    local v151 = v149.Name
                    if v150 then
                        v150 = u72(v150)
                    end
                    local v152 = u2.Static(v132, v151)
                    local v153 = {
                        ["Default"] = v150
                    }
                    if v152 == false then
                        v152 = nil
                    end
                    v153.Static = v152
                    v153.Sequence = u124(v149)
                    v148[v151] = v153
                end
            end
            p127[v132] = {
                ["Props"] = v148,
                ["Target"] = v132
            }
            if v135 then
                local v154 = {}
                p125._markers[v132] = v154
                for _, v155 in v135:GetChildren() do
                    if v155:FindFirstChild("name") then
                        local v156 = v155.Name
                        local v157 = tonumber(v156)
                        local v158 = assert(v157)
                        local v159 = v155:FindFirstChild("width")
                        local v160
                        if v159 then
                            v160 = v159:IsA("ValueBase")
                        else
                            v160 = v159
                        end
                        assert(v160)
                        local v161 = v159.Value
                        local v162 = v155:FindFirstChild("name")
                        local v163
                        if v162 then
                            v163 = v162:IsA("ValueBase")
                        else
                            v163 = v162
                        end
                        assert(v163)
                        local v164 = v162.Value
                        local v165 = {}
                        local v166 = v155:FindFirstChild("KFMarkers")
                        if v166 then
                            for _, v167 in v166:GetChildren() do
                                if v167:IsA("ValueBase") then
                                    local v168 = v167.Value
                                    local v169 = v167:FindFirstChild("Val")
                                    local v170
                                    if v169 then
                                        v170 = v169:IsA("ValueBase")
                                    else
                                        v170 = v169
                                    end
                                    assert(v170)
                                    v165[v168] = v169.Value
                                end
                            end
                        end
                        local v171 = v154[v158]
                        if not v171 then
                            v171 = {
                                ["StartMarkers"] = {},
                                ["EndMarkers"] = {}
                            }
                            v154[v158] = v171
                        end
                        if v161 > 0 then
                            local v172 = v158 + v161
                            local v173 = p125.Frames
                            local v174 = math.min(v172, v173)
                            local v175 = v154[v174]
                            if not v175 then
                                v175 = {
                                    ["StartMarkers"] = {},
                                    ["EndMarkers"] = {}
                                }
                                v154[v174] = v175
                            end
                            v175.EndMarkers[v164] = v165
                        end
                        v171.StartMarkers[v164] = v165
                    end
                end
            end
        end
    else
        return
    end
end
local function u199(p177) --[[Anonymous function at line 627]]
    --[[
    Upvalues:
        [1] = u6
        [2] = u11
    --]]
    return typeof(p177) == "ColorSequence" and function(p178, p179, p180) --[[Anonymous function at line 629]]
        local v181 = p178.Keypoints[1].Value
        local v182 = p179.Keypoints[1].Value
        local v183
        if type(v181) == "number" then
            v183 = math.lerp(v181, v182, p180)
        else
            v183 = v181:Lerp(v182, p180)
        end
        return ColorSequence.new(v183)
    end or (typeof(p177) == "NumberSequence" and function(p184, p185, p186) --[[Anonymous function at line 634]]
        local v187 = p184.Keypoints[1].Value
        local v188 = p185.Keypoints[1].Value
        local v189
        if type(v187) == "number" then
            v189 = math.lerp(v187, v188, p186)
        else
            v189 = v187:Lerp(v188, p186)
        end
        return NumberSequence.new(v189)
    end or (typeof(p177) == "NumberRange" and function(p190, p191, p192) --[[Anonymous function at line 639]]
        local v193 = p190.Min
        local v194 = p191.Min
        local v195
        if type(v193) == "number" then
            v195 = math.lerp(v193, v194, p192)
        else
            v195 = v193:Lerp(v194, p192)
        end
        return NumberRange.new(v195)
    end or (u6[typeof(p177)] and function(p196, p197, p198) --[[Anonymous function at line 644]]
        if p198 >= 1 then
            return p197
        else
            return p196
        end
    end or u11)))
end
local function u221(p200, p201) --[[Anonymous function at line 656]]
    --[[
    Upvalues:
        [1] = u199
        [2] = u3
    --]]
    local v202 = p200._buffer
    local v203 = p200._elements
    for v204, v205 in p201 do
        local v206 = {}
        v202[v204] = v206
        table.insert(v203, v204)
        for v207, v208 in v205.Props do
            if v208.Sequence[1] then
                local v209 = v208.Default
                local v210 = u199(v208.Sequence[1].Value)
                local v211 = 0
                local v212 = nil
                for _, v213 in v208.Sequence do
                    if not v206[v213.Time] then
                        v206[v213.Time] = {}
                    end
                    local v214 = v213.Time - v211
                    v206[v213.Time][v207] = v213.Value
                    if v214 <= 1 then
                        v209 = v213.Value
                        v212 = v213.Ease
                        v211 = v213.Time
                    else
                        if not v208.Static then
                            local v215 = u3.Get(v212)
                            for v216 = 0, v214 do
                                local v217 = v215(v216 / v214)
                                local v218 = v211 + v216
                                if not v206[v218] then
                                    v206[v218] = {}
                                end
                                v206[v218][v207] = v210(v209, v213.Value, v217)
                            end
                        end
                        v212 = v213.Ease
                        v209 = v213.Value
                        v211 = v213.Time
                    end
                end
                if not v208.Static and v211 < p200.Frames then
                    local v219 = v206[v211][v207]
                    for v220 = v211, p200.Frames do
                        if not v206[v220] then
                            v206[v220] = {}
                        end
                        v206[v220][v207] = v219
                    end
                end
            end
        end
    end
end
local function u226(p222) --[[Anonymous function at line 725]]
    --[[
    Upvalues:
        [1] = u176
        [2] = u221
    --]]
    local v223 = p222._data
    if v223 then
        v223 = p222._save
    end
    assert(v223, "This track is already compiled from source")
    table.clear(p222._buffer)
    table.clear(p222._elements)
    table.clear(p222._markers)
    local v224 = {}
    for _, v225 in p222._data.Items do
        u176(p222, v225, v224)
    end
    u221(p222, v224)
    p222._compiled = true
end
local function u233(p227) --[[Anonymous function at line 742]]
    --[[
    Upvalues:
        [1] = u7
        [2] = u85
    --]]
    local v228 = u7[p227]
    if v228 then
        if p227.RestoreDefaults then
            for v229, v230 in v228 do
                for v231, v232 in v230 do
                    u85(p227, v229, v231, v232)
                end
            end
            u85(p227, workspace.CurrentCamera, "AttachToPart", nil)
            u85(p227, workspace.CurrentCamera, "LookAtPart", nil)
        end
        table.clear(p227._lastSteppedFrames)
        u7[p227] = nil
    end
end
local function u251(p234, p235) --[[Anonymous function at line 765]]
    --[[
    Upvalues:
        [1] = u85
    --]]
    local v236 = p234.TimePosition * p234.FrameRate
    local v237 = math.floor(v236)
    if p234.Frames < v237 then
        if not p234.Looped then
            p234._completed:Fire(Enum.PlaybackState.Completed)
            return true
        end
        p234.TimePosition = 0
        p234.CurrentFrame = 0
        table.clear(p234._lastSteppedFrames)
        p234._onLoop:Fire()
        v237 = 0
    end
    for v238 = p234.CurrentFrame, v237 do
        for v239, v240 in p234._buffer do
            if p234._locks[v239] == nil then
                local v241 = v240[v238] or p234._lastSteppedFrames[v239]
                if v241 then
                    p234._lastSteppedFrames[v239] = v241
                    for v242, v243 in v241 do
                        u85(p234, v239, v242, v243)
                    end
                end
            end
        end
        for v244, v245 in p234._markers do
            local v246 = v245[v238]
            if v246 then
                for v247, v248 in v246.StartMarkers do
                    if p234._markerSignals[v247] then
                        p234._markerSignals[v247]:Fire(v244, v248)
                    end
                end
                for v249, v250 in v246.EndMarkers do
                    if p234._endMarkerSignals[v249] then
                        p234._endMarkerSignals[v249]:Fire(v244, v250)
                    end
                end
            end
        end
    end
    p234.CurrentFrame = v237
    p234.TimePosition = p234.TimePosition + p235
    return false
end
function v1.CreatePlayer(p252, p253) --[[Anonymous function at line 823]]
    --[[
    Upvalues:
        [1] = u18
        [2] = u5
    --]]
    local v254 = Instance.new("BindableEvent")
    local v255 = Instance.new("BindableEvent")
    local v256 = u18(p252)
    local v257 = {
        ["Completed"] = v254.Event,
        ["OnLoop"] = v255.Event,
        ["Looped"] = v256.Information.Looped,
        ["Frames"] = v256.Information.Length,
        ["FrameRate"] = v256.Information.FPS or 60,
        ["RestoreDefaults"] = true,
        ["TimePosition"] = 0,
        ["CurrentFrame"] = 0,
        ["_moduleInfo"] = v256,
        ["_compiled"] = false,
        ["_completed"] = v254,
        ["_onLoop"] = v255,
        ["_markers"] = {},
        ["_markerSignals"] = {},
        ["_endMarkerSignals"] = {},
        ["_locks"] = {},
        ["_elements"] = {},
        ["_buffer"] = {},
        ["_lastSteppedFrames"] = {},
        ["_scratch"] = {},
        ["_root"] = p253
    }
    local v258 = u5
    return setmetatable(v257, v258)
end
function u5.Compile(p259) --[[Anonymous function at line 861]]
    --[[
    Upvalues:
        [1] = u226
        [2] = u33
        [3] = u221
    --]]
    if p259._save then
        u226(p259)
        return p259
    else
        if p259._moduleInfo then
            local v260 = {}
            for v261, v262 in p259._moduleInfo.Compiled do
                local v263 = v262.Path or v261
                local v264 = v262.Override or u33(v263, p259._root)
                if v264 then
                    for _, v265 in v262.Props do
                        local v266 = v265.Default
                        if type(v266) == "table" then
                            local v267 = v266.ItemType
                            if type(v267) == "string" then
                                v266 = v266.Override or u33(v266, p259._root)
                            end
                        end
                        v265.Default = v266
                        for _, v268 in v265.Sequence do
                            local v269 = v268.Value
                            if type(v269) == "table" then
                                local v270 = v269.ItemType
                                if type(v270) == "string" then
                                    v269 = v269.Override or u33(v269, p259._root)
                                end
                            end
                            v268.Value = v269
                        end
                    end
                    v260[v264] = v262
                end
            end
            u221(p259, v260)
            p259._compiled = true
        end
        return p259
    end
end
function u5.Destroy(p271) --[[Anonymous function at line 899]]
    for _, v272 in p271._markerSignals do
        v272:Destroy()
    end
    for _, v273 in p271._endMarkerSignals do
        v273:Destroy()
    end
    p271._completed:Destroy()
    table.clear(p271._markerSignals)
    table.clear(p271._endMarkerSignals)
end
function u5.IsPlaying(p274) --[[Anonymous function at line 913]]
    --[[
    Upvalues:
        [1] = u7
    --]]
    return u7[p274] ~= nil
end
function u5.GetTimeLength(p275) --[[Anonymous function at line 917]]
    return p275.Frames / p275.FrameRate
end
function u5.GetMarkerReachedSignal(p276, p277) --[[Anonymous function at line 921]]
    if not p276._markerSignals[p277] then
        p276._markerSignals[p277] = Instance.new("BindableEvent")
    end
    return p276._markerSignals[p277].Event
end
function u5.GetMarkerEndedSignal(p278, p279) --[[Anonymous function at line 929]]
    if not p278._endMarkerSignals[p279] then
        p278._endMarkerSignals[p279] = Instance.new("BindableEvent")
    end
    return p278._endMarkerSignals[p279].Event
end
function u5.GetSetting(p280, p281) --[[Anonymous function at line 937]]
    return p280._scratch[p281]
end
function u5.SetSetting(p282, p283, p284) --[[Anonymous function at line 941]]
    p282._scratch[p283] = p284
end
function u5.GetElements(p285) --[[Anonymous function at line 945]]
    return table.clone(p285._elements)
end
function u5.LockElement(p286, p287, p288) --[[Anonymous function at line 949]]
    if not p286._locks[p287] then
        p286._locks[p287] = {}
    end
    if p288 then
        p286._locks[p287][p288 or "Default"] = true
    end
    return true
end
function u5.UnlockElement(p289, p290, p291) --[[Anonymous function at line 961]]
    local v292 = p289._locks[p290]
    if v292 then
        v292[p291 or "Default"] = nil
        if not next(v292) then
            p289._locks[p290] = nil
        end
    end
    return true
end
function u5.IsElementLocked(p293, p294) --[[Anonymous function at line 975]]
    return p293._locks[p294] ~= nil
end
function u5.ReplaceElementByPath(p295, p296, p297) --[[Anonymous function at line 979]]
    --[[
    Upvalues:
        [1] = u20
    --]]
    local v298 = string.lower(p296)
    if p295._data then
        for _, v299 in p295._data.Items do
            local v300 = v299.Path
            if string.lower(u20(v300)) == v298 and (v300.ItemType == "Rig" or p297:IsA(v300.ItemType)) then
                v299.Override = p297
                return true
            end
        end
    elseif p295._moduleInfo then
        local v301 = false
        for v302, v303 in p295._moduleInfo.Compiled do
            local v304 = v303.Path or v302
            local v305 = v304.ItemType
            if string.lower(u20(v304)) == v298 and (v305 == "Rig" or p297:IsA(v304.ItemType)) then
                v303.Override = p297
                v301 = true
            end
            for _, v306 in v303.Props do
                local v307 = v306.Default
                if type(v307) == "table" then
                    local v308 = v307.ItemType
                    if type(v308) == "string" and (v298 == string.lower(u20(v307)) and (v307.ItemType == "Rig" or p297:IsA(v307.ItemType))) then
                        v303.Override = p297
                        v301 = true
                    end
                end
                for _, v309 in v306.Sequence do
                    local v310 = v309.Value
                    if type(v310) == "table" then
                        local v311 = v310.ItemType
                        if type(v311) == "string" and (v298 == string.lower(u20(v310)) and (v310.ItemType == "Rig" or p297:IsA(v310.ItemType))) then
                            v303.Override = p297
                            v301 = true
                        end
                    end
                end
            end
        end
        return v301
    end
    return false
end
function u5.FindElement(p312, p313) --[[Anonymous function at line 1036]]
    for _, v314 in p312._elements do
        if v314 and v314.Name == p313 then
            return v314
        end
    end
    return nil
end
function u5.FindElementOfType(p315, p316) --[[Anonymous function at line 1046]]
    for _, v317 in p315._elements do
        if v317 and v317:IsA(p316) then
            return v317
        end
    end
    return nil
end
function u5.Stop(p318) --[[Anonymous function at line 1056]]
    --[[
    Upvalues:
        [1] = u233
    --]]
    p318.TimePosition = 0
    p318.CurrentFrame = 0
    table.clear(p318._lastSteppedFrames)
    task.spawn(u233, p318)
    p318._completed:Fire(Enum.PlaybackState.Cancelled)
end
function u5.Reset(p319) --[[Anonymous function at line 1064]]
    --[[
    Upvalues:
        [1] = u251
    --]]
    p319.TimePosition = 0
    p319.CurrentFrame = 0
    u251(p319, 0)
    return true
end
function u5.Play(p320) --[[Anonymous function at line 1072]]
    --[[
    Upvalues:
        [1] = u7
        [2] = u78
    --]]
    local v321 = p320._compiled
    assert(v321, "Track is not compiled.")
    if not u7[p320] then
        if p320.TimePosition >= p320:GetTimeLength() then
            p320.TimePosition = 0
            p320.CurrentFrame = 0
        end
        table.clear(p320._lastSteppedFrames)
        local v322 = {}
        for v323, v324 in p320._buffer do
            if v324[0] then
                local v325 = {}
                v322[v323] = v325
                for v326 in v324[0] do
                    local v327, v328 = u78(p320, v323, v326)
                    if v327 then
                        v325[v326] = v328
                    end
                end
            end
        end
        u7[p320] = v322
        p320._completed:Fire(Enum.PlaybackState.Playing)
    end
end
v4.PreSimulation:Connect(function(p329) --[[Anonymous function at line 1107]]
    --[[
    Upvalues:
        [1] = u7
        [2] = u251
        [3] = u233
    --]]
    for v330 in u7 do
        if u251(v330, p329) then
            u233(v330)
        end
    end
end)
function v1.instanceToMoonAnimPath(p331) --[[Anonymous function at line 120]]
    local v332, v333, v334
    if p331:IsDescendantOf(game) then
        v332 = p331
        v333 = {}
        v334 = {}
    else
        error("Instance is not descendant of game")
        v332 = p331
        v333 = {}
        v334 = {}
    end
    while p331 ~= game do
        local v335 = p331.Name
        table.insert(v333, 1, v335)
        local v336 = p331.ClassName
        table.insert(v334, 1, v336)
        p331 = p331.Parent
    end
    table.insert(v333, 1, "game")
    table.insert(v334, 1, "DataModel")
    return {
        ["InstanceTypes"] = v334,
        ["ItemType"] = v332.ClassName,
        ["InstanceNames"] = v333
    }
end
v1.resolveAnimPath = u33
v1.toPathString = u20
return v1