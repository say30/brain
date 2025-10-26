--[[
  Extracted from: ReplicatedStorage.Packages.Moonlite.EaseFuncs
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local u1 = {}
local v2 = script.Parent
require(v2.Types)
function u1.Linear(p3, p4, p5, p6) --[[Anonymous function at line 21]]
    return p5 * p3 / p6 + p4
end
function u1.Constant(p7, _, _, p8) --[[Anonymous function at line 29]]
    return p7 == p8 and 1 or 0
end
function u1.InSine(p9, p10, p11, p12) --[[Anonymous function at line 37]]
    local v13 = -p11
    local v14 = p9 / p12 * 1.5707963267948966
    return v13 * math.cos(v14) + p11 + p10
end
function u1.OutSine(p15, p16, p17, p18) --[[Anonymous function at line 41]]
    local v19 = p15 / p18 * 1.5707963267948966
    return p17 * math.sin(v19) + p16
end
function u1.InOutSine(p20, p21, p22, p23) --[[Anonymous function at line 45]]
    local v24 = -p22 / 2
    local v25 = 3.141592653589793 * p20 / p23
    return v24 * (math.cos(v25) - 1) + p21
end
function u1.OutInSine(p26, p27, p28, p29) --[[Anonymous function at line 49]]
    --[[
    Upvalues:
        [1] = u1
    --]]
    if p26 < p29 / 2 then
        return u1.OutSine(p26 * 2, p27, p28 / 2, p29)
    else
        return u1.InSine(p26 * 2 - p29, p27 + p28 / 2, p28 / 2, p29)
    end
end
function u1.InQuad(p30, p31, p32, p33) --[[Anonymous function at line 61]]
    local v34 = p30 / p33
    return p32 * math.pow(v34, 2) + p31
end
function u1.OutQuad(p35, p36, p37, p38) --[[Anonymous function at line 66]]
    local v39 = p35 / p38
    return -p37 * v39 * (v39 - 2) + p36
end
function u1.InOutQuad(p40, p41, p42, p43) --[[Anonymous function at line 71]]
    local v44 = p40 / p43 * 2
    if v44 < 1 then
        return p42 / 2 * math.pow(v44, 2) + p41
    else
        return -p42 / 2 * ((v44 - 1) * (v44 - 3) - 1) + p41
    end
end
function u1.OutInQuad(p45, p46, p47, p48) --[[Anonymous function at line 81]]
    --[[
    Upvalues:
        [1] = u1
    --]]
    if p45 < p48 / 2 then
        return u1.OutQuad(p45 * 2, p46, p47 / 2, p48)
    else
        return u1.InQuad(p45 * 2 - p48, p46 + p47 / 2, p47 / 2, p48)
    end
end
function u1.InCubic(p49, p50, p51, p52) --[[Anonymous function at line 93]]
    local v53 = p49 / p52
    return p51 * math.pow(v53, 3) + p50
end
function u1.OutCubic(p54, p55, p56, p57) --[[Anonymous function at line 98]]
    local v58 = p54 / p57 - 1
    return p56 * (math.pow(v58, 3) + 1) + p55
end
function u1.InOutCubic(p59, p60, p61, p62) --[[Anonymous function at line 103]]
    local v63 = p59 / p62 * 2
    if v63 < 1 then
        return p61 / 2 * v63 * v63 * v63 + p60
    end
    local v64 = v63 - 2
    return p61 / 2 * (v64 * v64 * v64 + 2) + p60
end
function u1.OutInCubic(p65, p66, p67, p68) --[[Anonymous function at line 114]]
    --[[
    Upvalues:
        [1] = u1
    --]]
    if p65 < p68 / 2 then
        return u1.OutCubic(p65 * 2, p66, p67 / 2, p68)
    else
        return u1.InCubic(p65 * 2 - p68, p66 + p67 / 2, p67 / 2, p68)
    end
end
function u1.InQuart(p69, p70, p71, p72) --[[Anonymous function at line 126]]
    local v73 = p69 / p72
    return p71 * math.pow(v73, 4) + p70
end
function u1.OutQuart(p74, p75, p76, p77) --[[Anonymous function at line 131]]
    local v78 = p74 / p77 - 1
    return -p76 * (math.pow(v78, 4) - 1) + p75
end
function u1.InOutQuart(p79, p80, p81, p82) --[[Anonymous function at line 136]]
    local v83 = p79 / p82 * 2
    if v83 < 1 then
        return p81 / 2 * math.pow(v83, 4) + p80
    end
    local v84 = v83 - 2
    return -p81 / 2 * (math.pow(v84, 4) - 2) + p80
end
function u1.OutInQuart(p85, p86, p87, p88) --[[Anonymous function at line 147]]
    --[[
    Upvalues:
        [1] = u1
    --]]
    if p85 < p88 / 2 then
        return u1.OutQuart(p85 * 2, p86, p87 / 2, p88)
    else
        return u1.InQuart(p85 * 2 - p88, p86 + p87 / 2, p87 / 2, p88)
    end
end
function u1.InQuint(p89, p90, p91, p92) --[[Anonymous function at line 159]]
    local v93 = p89 / p92
    return p91 * math.pow(v93, 5) + p90
end
function u1.OutQuint(p94, p95, p96, p97) --[[Anonymous function at line 164]]
    local v98 = p94 / p97 - 1
    return p96 * (math.pow(v98, 5) + 1) + p95
end
function u1.InOutQuint(p99, p100, p101, p102) --[[Anonymous function at line 169]]
    local v103 = p99 / p102 * 2
    if v103 < 1 then
        return p101 / 2 * math.pow(v103, 5) + p100
    end
    local v104 = v103 - 2
    return p101 / 2 * (math.pow(v104, 5) + 2) + p100
end
function u1.OutInQuint(p105, p106, p107, p108) --[[Anonymous function at line 180]]
    --[[
    Upvalues:
        [1] = u1
    --]]
    if p105 < p108 / 2 then
        return u1.OutQuint(p105 * 2, p106, p107 / 2, p108)
    else
        return u1.InQuint(p105 * 2 - p108, p106 + p107 / 2, p107 / 2, p108)
    end
end
function u1.InSextic(p109, p110, p111, p112) --[[Anonymous function at line 192]]
    local v113 = p109 / p112
    return p111 * math.pow(v113, 6) + p110
end
function u1.OutSextic(p114, p115, p116, p117) --[[Anonymous function at line 197]]
    local v118 = p114 / p117 - 1
    return -p116 * (math.pow(v118, 6) - 1) + p115
end
function u1.InOutSextic(p119, p120, p121, p122) --[[Anonymous function at line 202]]
    local v123 = p119 / p122 * 2
    if v123 < 1 then
        return p121 / 2 * math.pow(v123, 6) + p120
    end
    local v124 = v123 - 2
    return -p121 / 2 * (math.pow(v124, 6) - 2) + p120
end
function u1.OutInSextic(p125, p126, p127, p128) --[[Anonymous function at line 213]]
    --[[
    Upvalues:
        [1] = u1
    --]]
    if p125 < p128 / 2 then
        return u1.OutSextic(p125 * 2, p126, p127 / 2, p128)
    else
        return u1.InSextic(p125 * 2 - p128, p126 + p127 / 2, p127 / 2, p128)
    end
end
function u1.InExpo(p129, p130, p131, p132) --[[Anonymous function at line 225]]
    if p129 == 0 then
        return p130
    end
    local v133 = 10 * (p129 / p132 - 1)
    return p131 * math.pow(2, v133) + p130 - p131 * 0.001
end
function u1.OutExpo(p134, p135, p136, p137) --[[Anonymous function at line 233]]
    if p134 == p137 then
        return p135 + p136
    end
    local v138 = p136 * 1.001
    local v139 = -10 * p134 / p137
    return v138 * (-math.pow(2, v139) + 1) + p135
end
function u1.InOutExpo(p140, p141, p142, p143) --[[Anonymous function at line 241]]
    if p140 == 0 then
        return p141
    end
    if p140 == p143 then
        return p141 + p142
    end
    local v144 = p140 / p143 * 2
    if v144 < 1 then
        local v145 = p142 / 2
        local v146 = 10 * (v144 - 1)
        return v145 * math.pow(2, v146) + p141 - p142 * 0.0005
    end
    local v147 = v144 - 1
    local v148 = p142 / 2 * 1.0005
    local v149 = -10 * v147
    return v148 * (-math.pow(2, v149) + 2) + p141
end
function u1.OutInExpo(p150, p151, p152, p153) --[[Anonymous function at line 260]]
    --[[
    Upvalues:
        [1] = u1
    --]]
    if p150 < p153 / 2 then
        return u1.OutExpo(p150 * 2, p151, p152 / 2, p153)
    else
        return u1.InExpo(p150 * 2 - p153, p151 + p152 / 2, p152 / 2, p153)
    end
end
function u1.InCirc(p154, p155, p156, p157) --[[Anonymous function at line 272]]
    local v158 = p154 / p157
    local v159 = -p156
    local v160 = 1 - math.pow(v158, 2)
    return v159 * (math.sqrt(v160) - 1) + p155
end
function u1.OutCirc(p161, p162, p163, p164) --[[Anonymous function at line 277]]
    local v165 = p161 / p164 - 1
    local v166 = 1 - math.pow(v165, 2)
    return p163 * math.sqrt(v166) + p162
end
function u1.InOutCirc(p167, p168, p169, p170) --[[Anonymous function at line 282]]
    local v171 = p167 / p170 * 2
    if v171 < 1 then
        local v172 = -p169 / 2
        local v173 = 1 - v171 * v171
        return v172 * (math.sqrt(v173) - 1) + p168
    end
    local v174 = v171 - 2
    local v175 = p169 / 2
    local v176 = 1 - v174 * v174
    return v175 * (math.sqrt(v176) + 1) + p168
end
function u1.OutInCirc(p177, p178, p179, p180) --[[Anonymous function at line 293]]
    --[[
    Upvalues:
        [1] = u1
    --]]
    if p177 < p180 / 2 then
        return u1.OutCirc(p177 * 2, p178, p179 / 2, p180)
    else
        return u1.InCirc(p177 * 2 - p180, p178 + p179 / 2, p179 / 2, p180)
    end
end
function u1.InBack(p181, p182, p183, p184, p185) --[[Anonymous function at line 305]]
    local v186 = p185 or 1.70158
    local v187 = p181 / p184
    return p183 * v187 * v187 * ((v186 + 1) * v187 - v186) + p182
end
function u1.OutBack(p188, p189, p190, p191, p192) --[[Anonymous function at line 314]]
    local v193 = p192 or 1.70158
    local v194 = p188 / p191 - 1
    return p190 * (v194 * v194 * ((v193 + 1) * v194 + v193) + 1) + p189
end
function u1.InOutBack(p195, p196, p197, p198, p199) --[[Anonymous function at line 323]]
    local v200 = (p199 or 1.70158) * 1.525
    local v201 = p195 / p198 * 2
    if v201 < 1 then
        return p197 / 2 * (v201 * v201 * ((v200 + 1) * v201 - v200)) + p196
    end
    local v202 = v201 - 2
    return p197 / 2 * (v202 * v202 * ((v200 + 1) * v202 + v200) + 2) + p196
end
function u1.OutInBack(p203, p204, p205, p206, p207) --[[Anonymous function at line 339]]
    --[[
    Upvalues:
        [1] = u1
    --]]
    if p203 < p206 / 2 then
        return u1.OutBack(p203 * 2, p204, p205 / 2, p206, p207)
    else
        return u1.InBack(p203 * 2 - p206, p204 + p205 / 2, p205 / 2, p206, p207)
    end
end
function u1.OutBounce(p208, p209, p210, p211) --[[Anonymous function at line 351]]
    local v212 = p208 / p211
    if v212 < 0.36363636363636365 then
        return p210 * (7.5625 * v212 * v212) + p209
    elseif v212 < 0.7272727272727273 then
        local v213 = v212 - 0.5454545454545454
        return p210 * (7.5625 * v213 * v213 + 0.75) + p209
    elseif v212 < 0.9090909090909091 then
        local v214 = v212 - 0.8181818181818182
        return p210 * (7.5625 * v214 * v214 + 0.9375) + p209
    else
        local v215 = v212 - 0.9545454545454546
        return p210 * (7.5625 * v215 * v215 + 0.984375) + p209
    end
end
function u1.InBounce(p216, p217, p218, p219) --[[Anonymous function at line 368]]
    --[[
    Upvalues:
        [1] = u1
    --]]
    return p218 - u1.OutBounce(p219 - p216, 0, p218, p219) + p217
end
function u1.InOutBounce(p220, p221, p222, p223) --[[Anonymous function at line 372]]
    --[[
    Upvalues:
        [1] = u1
    --]]
    if p220 < p223 / 2 then
        return u1.InBounce(p220 * 2, 0, p222, p223) * 0.5 + p221
    else
        return u1.OutBounce(p220 * 2 - p223, 0, p222, p223) * 0.5 + p222 * 0.5 + p221
    end
end
function u1.OutInBounce(p224, p225, p226, p227) --[[Anonymous function at line 380]]
    --[[
    Upvalues:
        [1] = u1
    --]]
    if p224 < p227 / 2 then
        return u1.OutBounce(p224 * 2, p225, p226 / 2, p227)
    else
        return u1.InBounce(p224 * 2 - p227, p225 + p226 / 2, p226 / 2, p227)
    end
end
function u1.ElasticBlend(p228, p229, p230, p231, p232, p233) --[[Anonymous function at line 392]]
    if p229 ~= 0 then
        local v234 = math.abs(p232)
        p233 = p231 == 0 and 0 or p233 * (p231 / math.abs(p229))
        local v235 = p228 * p230
        if math.abs(v235) < v234 then
            local v236 = p228 * p230
            local v237 = math.abs(v236) / v234
            p233 = p233 * v237 + (1 - v237)
        end
    end
    return p233
end
function u1.InElastic(p238, p239, p240, p241, p242, p243) --[[Anonymous function at line 411]]
    --[[
    Upvalues:
        [1] = u1
    --]]
    local v244 = 1
    if p238 == 0 then
        return p239
    end
    local v245 = p238 / p241
    if v245 == 1 then
        return p239 + p240
    end
    local v246 = v245 - 1
    if not p243 or p243 == 0 then
        p243 = p241 * 0.3
    end
    local v247
    if p242 == nil or p242 < math.abs(p240) then
        v247 = p243 / 4
        v244 = u1.ElasticBend(v246, p240, p241, p242, v247, v244)
    else
        local v248 = p243 / 6.283185307179586
        local v249 = p240 / p242
        v247 = v248 * math.asin(v249)
        p240 = p242
    end
    local v250 = -v244
    local v251 = 10 * v246
    local v252 = p240 * math.pow(2, v251)
    local v253 = (v246 * p241 - v247) * 6.283185307179586 / p243
    return v250 * (v252 * math.sin(v253)) + p239
end
function u1.OutElastic(p254, p255, p256, p257, p258, p259) --[[Anonymous function at line 442]]
    --[[
    Upvalues:
        [1] = u1
    --]]
    local v260 = 1
    if p254 == 0 then
        return p255
    end
    local v261 = p254 / p257
    if v261 == 1 then
        return p255 + p256
    end
    local v262 = -v261
    if not p259 or p259 == 0 then
        p259 = p257 * 0.3
    end
    local v263
    if p258 == nil or p258 < math.abs(p256) then
        v263 = p259 / 4
        v260 = u1.ElasticBlend(v262, p256, p257, p258, v263, v260)
        p258 = p256
    else
        local v264 = p259 / 6.283185307179586
        local v265 = p256 / p258
        v263 = v264 * math.asin(v265)
    end
    local v266 = 10 * v262
    local v267 = p258 * math.pow(2, v266)
    local v268 = (v262 * p257 - v263) * 6.283185307179586 / p259
    return v260 * (v267 * math.sin(v268)) + p256 + p255
end
function u1.InOutElastic(p269, p270, p271, p272, p273, p274) --[[Anonymous function at line 473]]
    --[[
    Upvalues:
        [1] = u1
    --]]
    local v275 = 1
    if p269 == 0 then
        return p270
    end
    local v276 = p269 / (p272 / 2)
    if v276 == 2 then
        return p270 + p271
    end
    local v277 = v276 - 1
    if not p274 or p274 == 0 then
        p274 = p272 * 0.44999999999999996
    end
    local v278
    if p273 == nil or p273 < math.abs(p271) then
        v278 = p274 / 4
        v275 = u1.ElasticBlend(v277, p271, p272, p273, v278, v275)
        p273 = p271
    else
        local v279 = p274 / 6.283185307179586
        local v280 = p271 / p273
        v278 = v279 * math.asin(v280)
    end
    if v277 < 0 then
        local v281 = v275 * -0.5
        local v282 = 10 * v277
        local v283 = p273 * math.pow(2, v282)
        local v284 = (v277 * p272 - v278) * 6.283185307179586 / p274
        return v281 * (v283 * math.sin(v284)) + p270
    end
    local v285 = -v277
    local v286 = v275 * 0.5
    local v287 = 10 * v285
    local v288 = p273 * math.pow(2, v287)
    local v289 = (v285 * p272 - v278) * 6.283185307179586 / p274
    return v286 * (v288 * math.sin(v289)) + p271 + p270
end
function u1.OutInElastic(p290, p291, p292, p293, p294, p295) --[[Anonymous function at line 511]]
    --[[
    Upvalues:
        [1] = u1
    --]]
    if p290 < p293 / 2 then
        return u1.OutElastic(p290 * 2, p291, p292 / 2, p293, p294, p295)
    else
        return u1.InElastic(p290 * 2 - p293, p291 + p292 / 2, p292 / 2, p293, p294, p295)
    end
end
local u296 = game:GetService("HttpService")
local u297 = {
    ["Type"] = "Linear",
    ["Params"] = {}
}
local u298 = {}
local function u308(p299) --[[Anonymous function at line 534]]
    --[[
    Upvalues:
        [1] = u297
        [2] = u296
        [3] = u298
        [4] = u1
        [5] = u308
    --]]
    local v300 = p299 or u297
    local v301 = u296:JSONEncode(v300)
    if u298[v301] == nil then
        local v302 = v300.Params
        local v303 = v300.Type or "Linear"
        local u304 = u1[("%*%*"):format(v302.Direction or "In", v303)] or u1[v303]
        if not u304 then
            return u308(u297)
        end
        local u305 = nil
        local u306 = nil
        if v303 == "Elastic" then
            u305 = v302.Amplitude or 1
            u306 = v302.Period or 0.3
        elseif v303 == "Back" then
            u305 = v302.Overshoot or 1.70158
        end
        u298[v301] = function(p307) --[[Anonymous function at line 558]]
            --[[
            Upvalues:
                [1] = u304
                [2] = u305
                [3] = u306
            --]]
            return u304(p307, 0, 1, 1, u305, u306)
        end
    end
    return u298[v301]
end
return {
    ["Get"] = u308
}