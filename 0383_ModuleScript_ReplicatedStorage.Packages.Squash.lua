--[[
  Extracted from: ReplicatedStorage.Packages.Squash
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local function u10(p1, p2) --[[Anonymous function at line 31]]
    local v3 = p1.Buf
    local v4 = p1.Pos
    local v5 = buffer.len(v3)
    if v5 < v4 + p2 then
        local v6 = (p2 + v4) / v5
        local v7 = math.log(v6, 1.5)
        local v8 = math.ceil(v7)
        local v9 = buffer.create(v5 * 1.5 ^ v8)
        buffer.copy(v9, 0, v3, 0)
        p1.Buf = v9
    end
end
local function u15(p11, p12) --[[Anonymous function at line 43]]
    local v13 = p11.Buf
    local v14 = p11.Pos
    buffer.writeu8(v13, v14, p12)
    p11.Pos = p11.Pos + 1
end
local function u19(p16) --[[Anonymous function at line 48]]
    p16.Pos = p16.Pos - 1
    local v17 = p16.Buf
    local v18 = p16.Pos
    return buffer.readu8(v17, v18)
end
local function u24(p20, p21) --[[Anonymous function at line 53]]
    local v22 = p20.Buf
    local v23 = p20.Pos
    buffer.writeu16(v22, v23, p21)
    p20.Pos = p20.Pos + 2
end
local function u28(p25) --[[Anonymous function at line 58]]
    p25.Pos = p25.Pos - 2
    local v26 = p25.Buf
    local v27 = p25.Pos
    return buffer.readu16(v26, v27)
end
local function u36(p29, p30) --[[Anonymous function at line 63]]
    local v31 = p29.Buf
    local v32 = p29.Pos
    buffer.writeu8(v31, v32, p30)
    local v33 = p29.Buf
    local v34 = p29.Pos + 1
    local v35 = p30 // 256
    buffer.writeu16(v33, v34, v35)
    p29.Pos = p29.Pos + 3
end
local function u43(p37) --[[Anonymous function at line 69]]
    p37.Pos = p37.Pos - 3
    local v38 = p37.Buf
    local v39 = p37.Pos
    local v40 = buffer.readu8(v38, v39)
    local v41 = p37.Buf
    local v42 = p37.Pos + 1
    return v40 + buffer.readu16(v41, v42) * 256
end
local function u48(p44, p45) --[[Anonymous function at line 76]]
    local v46 = p44.Buf
    local v47 = p44.Pos
    buffer.writeu32(v46, v47, p45)
    p44.Pos = p44.Pos + 4
end
local function u52(p49) --[[Anonymous function at line 81]]
    p49.Pos = p49.Pos - 4
    local v50 = p49.Buf
    local v51 = p49.Pos
    return buffer.readu32(v50, v51)
end
local function u60(p53, p54) --[[Anonymous function at line 86]]
    local v55 = p53.Buf
    local v56 = p53.Pos
    buffer.writeu8(v55, v56, p54)
    local v57 = p53.Buf
    local v58 = p53.Pos + 1
    local v59 = p54 // 256
    buffer.writeu32(v57, v58, v59)
    p53.Pos = p53.Pos + 5
end
local function u67(p61) --[[Anonymous function at line 92]]
    p61.Pos = p61.Pos - 5
    local v62 = p61.Buf
    local v63 = p61.Pos
    local v64 = buffer.readu8(v62, v63)
    local v65 = p61.Buf
    local v66 = p61.Pos + 1
    return v64 + buffer.readu32(v65, v66) * 256
end
local function u75(p68, p69) --[[Anonymous function at line 99]]
    local v70 = p68.Buf
    local v71 = p68.Pos
    buffer.writeu16(v70, v71, p69)
    local v72 = p68.Buf
    local v73 = p68.Pos + 2
    local v74 = p69 // 65536
    buffer.writeu32(v72, v73, v74)
    p68.Pos = p68.Pos + 6
end
local function u82(p76) --[[Anonymous function at line 105]]
    p76.Pos = p76.Pos - 6
    local v77 = p76.Buf
    local v78 = p76.Pos
    local v79 = buffer.readu16(v77, v78)
    local v80 = p76.Buf
    local v81 = p76.Pos + 2
    return v79 + buffer.readu32(v80, v81) * 65536
end
local function u93(p83, p84) --[[Anonymous function at line 112]]
    local v85 = p83.Buf
    local v86 = p83.Pos
    buffer.writeu8(v85, v86, p84)
    local v87 = p83.Buf
    local v88 = p83.Pos + 1
    local v89 = p84 // 256
    buffer.writeu16(v87, v88, v89)
    local v90 = p83.Buf
    local v91 = p83.Pos + 3
    local v92 = p84 // 16777216
    buffer.writeu32(v90, v91, v92)
    p83.Pos = p83.Pos + 7
end
local function u104(p94) --[[Anonymous function at line 119]]
    p94.Pos = p94.Pos - 7
    local v95 = p94.Buf
    local v96 = p94.Pos
    local v97 = buffer.readu8(v95, v96)
    local v98 = p94.Buf
    local v99 = p94.Pos + 1
    local v100 = buffer.readu16(v98, v99)
    local v101 = p94.Buf
    local v102 = p94.Pos + 3
    local v103 = buffer.readu32(v101, v102)
    return v97 + v100 * 256 + v103 * 16777216
end
local function u112(p105, p106) --[[Anonymous function at line 127]]
    local v107 = p105.Buf
    local v108 = p105.Pos
    buffer.writeu32(v107, v108, p106)
    local v109 = p105.Buf
    local v110 = p105.Pos + 4
    local v111 = p106 // 4294967296
    buffer.writeu32(v109, v110, v111)
    p105.Pos = p105.Pos + 8
end
local function u119(p113) --[[Anonymous function at line 133]]
    p113.Pos = p113.Pos - 8
    local v114 = p113.Buf
    local v115 = p113.Pos
    local v116 = buffer.readu32(v114, v115)
    local v117 = p113.Buf
    local v118 = p113.Pos + 4
    return v116 + buffer.readu32(v117, v118) * 4294967296
end
local function u124(p120, p121) --[[Anonymous function at line 140]]
    local v122 = p120.Buf
    local v123 = p120.Pos
    buffer.writei8(v122, v123, p121)
    p120.Pos = p120.Pos + 1
end
local function u128(p125) --[[Anonymous function at line 145]]
    p125.Pos = p125.Pos - 1
    local v126 = p125.Buf
    local v127 = p125.Pos
    return buffer.readi8(v126, v127)
end
local function u133(p129, p130) --[[Anonymous function at line 150]]
    local v131 = p129.Buf
    local v132 = p129.Pos
    buffer.writei16(v131, v132, p130)
    p129.Pos = p129.Pos + 2
end
local function u137(p134) --[[Anonymous function at line 155]]
    p134.Pos = p134.Pos - 2
    local v135 = p134.Buf
    local v136 = p134.Pos
    return buffer.readi16(v135, v136)
end
local function u147(p138, p139) --[[Anonymous function at line 160]]
    local v140
    if p139 >= 0 then
        v140 = p139 * 2
    else
        v140 = -p139 * 2 - 1
    end
    local v141 = p138.Buf
    local v142 = p138.Pos
    local v143 = v140 % 256
    buffer.writeu8(v141, v142, v143)
    local v144 = p138.Buf
    local v145 = p138.Pos + 1
    local v146 = v140 // 256
    buffer.writeu16(v144, v145, v146)
    p138.Pos = p138.Pos + 3
end
local function u155(p148) --[[Anonymous function at line 167]]
    p148.Pos = p148.Pos - 3
    local v149 = p148.Buf
    local v150 = p148.Pos
    local v151 = buffer.readu8(v149, v150)
    local v152 = p148.Buf
    local v153 = p148.Pos + 1
    local v154 = v151 + buffer.readu16(v152, v153) * 256
    if v154 % 2 == 0 then
        return v154 // 2
    else
        return -((v154 + 1) // 2)
    end
end
local function u160(p156, p157) --[[Anonymous function at line 175]]
    local v158 = p156.Buf
    local v159 = p156.Pos
    buffer.writei32(v158, v159, p157)
    p156.Pos = p156.Pos + 4
end
local function u164(p161) --[[Anonymous function at line 180]]
    p161.Pos = p161.Pos - 4
    local v162 = p161.Buf
    local v163 = p161.Pos
    return buffer.readi32(v162, v163)
end
local function u173(p165, p166) --[[Anonymous function at line 185]]
    local v167
    if p166 >= 0 then
        v167 = p166 * 2
    else
        v167 = -p166 * 2 - 1
    end
    local v168 = p165.Buf
    local v169 = p165.Pos
    buffer.writeu8(v168, v169, v167)
    local v170 = p165.Buf
    local v171 = p165.Pos + 1
    local v172 = v167 // 256
    buffer.writeu32(v170, v171, v172)
    p165.Pos = p165.Pos + 5
end
local function u181(p174) --[[Anonymous function at line 192]]
    p174.Pos = p174.Pos - 5
    local v175 = p174.Buf
    local v176 = p174.Pos
    local v177 = buffer.readu8(v175, v176)
    local v178 = p174.Buf
    local v179 = p174.Pos + 1
    local v180 = v177 + buffer.readu32(v178, v179) * 256
    if v180 % 2 == 0 then
        return v180 // 2
    else
        return -((v180 + 1) // 2)
    end
end
local function u190(p182, p183) --[[Anonymous function at line 200]]
    local v184
    if p183 >= 0 then
        v184 = p183 * 2
    else
        v184 = -p183 * 2 - 1
    end
    local v185 = p182.Buf
    local v186 = p182.Pos
    buffer.writeu16(v185, v186, v184)
    local v187 = p182.Buf
    local v188 = p182.Pos + 2
    local v189 = v184 // 65536
    buffer.writeu32(v187, v188, v189)
    p182.Pos = p182.Pos + 6
end
local function u198(p191) --[[Anonymous function at line 207]]
    p191.Pos = p191.Pos - 6
    local v192 = p191.Buf
    local v193 = p191.Pos
    local v194 = buffer.readu16(v192, v193)
    local v195 = p191.Buf
    local v196 = p191.Pos + 2
    local v197 = v194 + buffer.readu32(v195, v196) * 65536
    if v197 % 2 == 0 then
        return v197 // 2
    else
        return -((v197 + 1) // 2)
    end
end
local function u210(p199, p200) --[[Anonymous function at line 215]]
    local v201
    if p200 >= 0 then
        v201 = p200 * 2
    else
        v201 = -p200 * 2 - 1
    end
    local v202 = p199.Buf
    local v203 = p199.Pos
    buffer.writeu8(v202, v203, v201)
    local v204 = p199.Buf
    local v205 = p199.Pos + 1
    local v206 = v201 // 256
    buffer.writeu16(v204, v205, v206)
    local v207 = p199.Buf
    local v208 = p199.Pos + 3
    local v209 = v201 // 16777216
    buffer.writeu32(v207, v208, v209)
    p199.Pos = p199.Pos + 7
end
local function u222(p211) --[[Anonymous function at line 223]]
    p211.Pos = p211.Pos - 7
    local v212 = p211.Buf
    local v213 = p211.Pos
    local v214 = buffer.readu8(v212, v213)
    local v215 = p211.Buf
    local v216 = p211.Pos + 1
    local v217 = buffer.readu16(v215, v216)
    local v218 = p211.Buf
    local v219 = p211.Pos + 3
    local v220 = buffer.readu32(v218, v219)
    local v221 = v214 + v217 * 256 + v220 * 16777216
    if v221 % 2 == 0 then
        return v221 // 2
    else
        return -((v221 + 1) // 2)
    end
end
local function u231(p223, p224) --[[Anonymous function at line 232]]
    local v225
    if p224 >= 0 then
        v225 = p224 * 2
    else
        v225 = -p224 * 2 - 1
    end
    local v226 = p223.Buf
    local v227 = p223.Pos
    buffer.writeu32(v226, v227, v225)
    local v228 = p223.Buf
    local v229 = p223.Pos + 4
    local v230 = v225 // 4294967296
    buffer.writeu32(v228, v229, v230)
    p223.Pos = p223.Pos + 8
end
local function u239(p232) --[[Anonymous function at line 239]]
    p232.Pos = p232.Pos - 8
    local v233 = p232.Buf
    local v234 = p232.Pos
    local v235 = buffer.readu32(v233, v234)
    local v236 = p232.Buf
    local v237 = p232.Pos + 4
    local v238 = v235 + buffer.readu32(v236, v237) * 4294967296
    if v238 % 2 == 0 then
        return v238 // 2
    else
        return -((v238 + 1) // 2)
    end
end
local function u244(p240, p241) --[[Anonymous function at line 247]]
    local v242 = p240.Buf
    local v243 = p240.Pos
    buffer.writef32(v242, v243, p241)
    p240.Pos = p240.Pos + 4
end
local function u248(p245) --[[Anonymous function at line 252]]
    p245.Pos = p245.Pos - 4
    local v246 = p245.Buf
    local v247 = p245.Pos
    return buffer.readf32(v246, v247)
end
local function u253(p249, p250) --[[Anonymous function at line 257]]
    local v251 = p249.Buf
    local v252 = p249.Pos
    buffer.writef64(v251, v252, p250)
    p249.Pos = p249.Pos + 8
end
local function u257(p254) --[[Anonymous function at line 262]]
    p254.Pos = p254.Pos - 8
    local v255 = p254.Buf
    local v256 = p254.Pos
    return buffer.readf64(v255, v256)
end
local function u287(p258, p259) --[[Anonymous function at line 302]]
    --[[
    Upvalues:
        [1] = u10
    --]]
    local v260 = p259 >= 562949953421312 and 8 or (p259 >= 4398046511104 and 7 or (p259 >= 34359738368 and 6 or (p259 >= 268435456 and 5 or (p259 >= 2097152 and 4 or (p259 >= 16384 and 3 or (p259 >= 128 and 2 or 1))))))
    u10(p258, v260)
    local v261 = p259 // 4294967296
    local v262 = p259 - v261 * 4294967296
    local v263 = v262 % 128
    local v264 = p258.Buf
    local v265 = p258.Pos
    buffer.writeu8(v264, v265, v263)
    p258.Pos = p258.Pos + 1
    if v260 >= 2 then
        v262 = v261 % 128 * 33554432 + v262 // 128
        v261 = v261 // 128
        local v266 = v262 % 128 + 128
        local v267 = p258.Buf
        local v268 = p258.Pos
        buffer.writeu8(v267, v268, v266)
        p258.Pos = p258.Pos + 1
    end
    if v260 >= 3 then
        v262 = v261 % 128 * 33554432 + v262 // 128
        v261 = v261 // 128
        local v269 = v262 % 128 + 128
        local v270 = p258.Buf
        local v271 = p258.Pos
        buffer.writeu8(v270, v271, v269)
        p258.Pos = p258.Pos + 1
    end
    if v260 >= 4 then
        v262 = v261 % 128 * 33554432 + v262 // 128
        v261 = v261 // 128
        local v272 = v262 % 128 + 128
        local v273 = p258.Buf
        local v274 = p258.Pos
        buffer.writeu8(v273, v274, v272)
        p258.Pos = p258.Pos + 1
    end
    if v260 >= 5 then
        v262 = v261 % 128 * 33554432 + v262 // 128
        v261 = v261 // 128
        local v275 = v262 % 128 + 128
        local v276 = p258.Buf
        local v277 = p258.Pos
        buffer.writeu8(v276, v277, v275)
        p258.Pos = p258.Pos + 1
    end
    if v260 >= 6 then
        v262 = v261 % 128 * 33554432 + v262 // 128
        v261 = v261 // 128
        local v278 = v262 % 128 + 128
        local v279 = p258.Buf
        local v280 = p258.Pos
        buffer.writeu8(v279, v280, v278)
        p258.Pos = p258.Pos + 1
    end
    if v260 >= 7 then
        v262 = v261 % 128 * 33554432 + v262 // 128
        v261 = v261 // 128
        local v281 = v262 % 128 + 128
        local v282 = p258.Buf
        local v283 = p258.Pos
        buffer.writeu8(v282, v283, v281)
        p258.Pos = p258.Pos + 1
    end
    if v260 == 8 then
        local v284 = (v261 % 128 * 33554432 + v262 // 128) % 128 + 128
        local v285 = p258.Buf
        local v286 = p258.Pos
        buffer.writeu8(v285, v286, v284)
        p258.Pos = p258.Pos + 1
    end
end
local function u320(p288) --[[Anonymous function at line 382]]
    p288.Pos = p288.Pos - 1
    local v289 = p288.Buf
    local v290 = p288.Pos
    local v291 = buffer.readu8(v289, v290)
    local v292 = v291 % 128
    if v291 < 128 then
        return v292
    end
    p288.Pos = p288.Pos - 1
    local v293 = p288.Buf
    local v294 = p288.Pos
    local v295 = buffer.readu8(v293, v294)
    local v296 = v292 * 128 + v295 % 128
    if v295 < 128 then
        return v296
    end
    p288.Pos = p288.Pos - 1
    local v297 = p288.Buf
    local v298 = p288.Pos
    local v299 = buffer.readu8(v297, v298)
    local v300 = v296 * 128 + v299 % 128
    if v299 < 128 then
        return v300
    end
    p288.Pos = p288.Pos - 1
    local v301 = p288.Buf
    local v302 = p288.Pos
    local v303 = buffer.readu8(v301, v302)
    local v304 = v300 * 128 + v303 % 128
    if v303 < 128 then
        return v304
    end
    p288.Pos = p288.Pos - 1
    local v305 = p288.Buf
    local v306 = p288.Pos
    local v307 = buffer.readu8(v305, v306)
    local v308 = v304 * 128 + v307 % 128
    if v307 < 128 then
        return v308
    end
    p288.Pos = p288.Pos - 1
    local v309 = p288.Buf
    local v310 = p288.Pos
    local v311 = buffer.readu8(v309, v310)
    local v312 = v308 * 128 + v311 % 128
    if v311 < 128 then
        return v312
    end
    p288.Pos = p288.Pos - 1
    local v313 = p288.Buf
    local v314 = p288.Pos
    local v315 = buffer.readu8(v313, v314)
    local v316 = v312 * 128 + v315 % 128
    if v315 < 128 then
        return v316
    end
    p288.Pos = p288.Pos - 1
    local v317 = p288.Buf
    local v318 = p288.Pos
    local v319 = buffer.readu8(v317, v318)
    return v316 * 128 + v319 % 128
end
local function u324(p321, p322) --[[Anonymous function at line 441]]
    --[[
    Upvalues:
        [1] = u320
    --]]
    local v323 = p322 or u320(p321)
    p321.Pos = p321.Pos - v323
    return buffer.readstring(p321.Buf, p321.Pos, v323)
end
local function v329(p325, p326) --[[Anonymous function at line 457]]
    --[[
    Upvalues:
        [1] = u320
    --]]
    local v327 = p326 or u320(p325)
    p325.Pos = p325.Pos - v327
    local v328 = buffer.create(v327)
    buffer.copy(v328, 0, p325.Buf, p325.Pos, v327)
    return v328
end
local v349 = {
    ["print"] = function(p330) --[[Function name: printcursor, line 465]]
        local v331 = {}
        local v332 = buffer.tostring(p330.Buf)
        __set_list(v331, 1, {string.byte(v332, 1, -1)})
        local v333 = 7
        for v334 = 1, p330.Pos do
            local v335 = v331[v334]
            local v336
            if v335 == 0 then
                v336 = 1
            else
                local v337 = 1 + v335
                local v338 = math.log10(v337)
                v336 = math.ceil(v338)
            end
            v333 = v333 + (v336 + 1)
        end
        local v339 = v331[p330.Pos + 1]
        if v339 then
            local v340
            if v339 == 0 then
                v340 = 1
            else
                local v341 = 1 + v339
                local v342 = math.log10(v341)
                v340 = math.ceil(v342)
            end
            v333 = v333 + v340 // 2
        end
        if #v331 == 0 or p330.Pos == buffer.len(p330.Buf) then
            table.insert(v331, " ")
        end
        print((("Pos: %* / %*\nBuf: { %* }\n%*^"):format(p330.Pos, buffer.len(p330.Buf), table.concat(v331, " "), (string.rep(" ", v333)))))
    end,
    ["cursor"] = function(p343, p344) --[[Function name: newcursor, line 11]]
        return {
            ["Buf"] = buffer.create(p343 or 8),
            ["Pos"] = p344 or 0
        }
    end,
    ["frombuffer"] = function(p345) --[[Function name: frombuffer, line 18]]
        return {
            ["Buf"] = p345,
            ["Pos"] = buffer.len(p345)
        }
    end,
    ["tobuffer"] = function(p346) --[[Function name: tobuffer, line 25]]
        local v347 = buffer.create(p346.Pos)
        buffer.copy(v347, 0, p346.Buf, 0, p346.Pos)
        return v347
    end,
    ["tryrealloc"] = u10,
    ["T"] = function(p348) --[[Function name: T, line 500]]
        return p348
    end
}
local u366 = {
    ["ser"] = function(p350, p351, p352, p353, p354, p355, p356, p357, p358) --[[Function name: ser, line 507]]
        --[[
        Upvalues:
            [1] = u10
        --]]
        u10(p350, 1)
        local v359 = (p351 and 1 or 0) + (p352 and 2 or 0) + (p353 and 4 or 0) + (p354 and 8 or 0) + (p355 and 16 or 0) + (p356 and 32 or 0) + (p357 and 64 or 0) + (p358 and 128 or 0)
        local v360 = p350.Buf
        local v361 = p350.Pos
        buffer.writeu8(v360, v361, v359)
        p350.Pos = p350.Pos + 1
    end,
    ["des"] = function(p362) --[[Function name: popbool, line 291]]
        p362.Pos = p362.Pos - 1
        local v363 = p362.Buf
        local v364 = p362.Pos
        local v365 = buffer.readu8(v363, v364)
        return v365 % 2 >= 1, v365 % 4 >= 2, v365 % 8 >= 4, v365 % 16 >= 8, v365 % 32 >= 16, v365 % 64 >= 32, v365 % 128 >= 64, v365 % 256 >= 128
    end
}
function v349.boolean() --[[Anonymous function at line 513]]
    --[[
    Upvalues:
        [1] = u366
    --]]
    return u366
end
local u367 = {}
function v349.uint(u368) --[[Anonymous function at line 520]]
    --[[
    Upvalues:
        [1] = u367
        [2] = u15
        [3] = u19
        [4] = u24
        [5] = u28
        [6] = u36
        [7] = u43
        [8] = u48
        [9] = u52
        [10] = u60
        [11] = u67
        [12] = u75
        [13] = u82
        [14] = u93
        [15] = u104
        [16] = u112
        [17] = u119
        [18] = u10
    --]]
    if u367[u368] then
        return u367[u368]
    end
    local u369 = nil
    local v370 = nil
    if u368 == 1 then
        u369 = u15
        v370 = u19
    elseif u368 == 2 then
        u369 = u24
        v370 = u28
    elseif u368 == 3 then
        u369 = u36
        v370 = u43
    elseif u368 == 4 then
        u369 = u48
        v370 = u52
    elseif u368 == 5 then
        u369 = u60
        v370 = u67
    elseif u368 == 6 then
        u369 = u75
        v370 = u82
    elseif u368 == 7 then
        u369 = u93
        v370 = u104
    elseif u368 == 8 then
        u369 = u112
        v370 = u119
    else
        error((("uint bytes must be integer between [1, 8], got %*"):format(u368)))
    end
    local v373 = {
        ["ser"] = function(p371, p372) --[[Function name: ser, line 547]]
            --[[
            Upvalues:
                [1] = u10
                [2] = u368
                [3] = u369
            --]]
            u10(p371, u368)
            u369(p371, p372)
        end,
        ["des"] = v370
    }
    u367[u368] = v373
    return v373
end
local u374 = {}
function v349.int(u375) --[[Anonymous function at line 560]]
    --[[
    Upvalues:
        [1] = u374
        [2] = u124
        [3] = u128
        [4] = u133
        [5] = u137
        [6] = u147
        [7] = u155
        [8] = u160
        [9] = u164
        [10] = u173
        [11] = u181
        [12] = u190
        [13] = u198
        [14] = u210
        [15] = u222
        [16] = u231
        [17] = u239
        [18] = u10
    --]]
    if u374[u375] then
        return u374[u375]
    end
    local u376 = nil
    local v377 = nil
    if u375 == 1 then
        u376 = u124
        v377 = u128
    elseif u375 == 2 then
        u376 = u133
        v377 = u137
    elseif u375 == 3 then
        u376 = u147
        v377 = u155
    elseif u375 == 4 then
        u376 = u160
        v377 = u164
    elseif u375 == 5 then
        u376 = u173
        v377 = u181
    elseif u375 == 6 then
        u376 = u190
        v377 = u198
    elseif u375 == 7 then
        u376 = u210
        v377 = u222
    elseif u375 == 8 then
        u376 = u231
        v377 = u239
    else
        error((("int bytes must be integer between [1, 8], got %*"):format(u375)))
    end
    local v380 = {
        ["ser"] = function(p378, p379) --[[Function name: ser, line 587]]
            --[[
            Upvalues:
                [1] = u10
                [2] = u375
                [3] = u376
            --]]
            u10(p378, u375)
            u376(p378, p379)
        end,
        ["des"] = v377
    }
    u374[u375] = v380
    return v380
end
local u381 = {}
function v349.number(u382) --[[Anonymous function at line 600]]
    --[[
    Upvalues:
        [1] = u381
        [2] = u244
        [3] = u248
        [4] = u253
        [5] = u257
        [6] = u10
    --]]
    if u381[u382] then
        return u381[u382]
    end
    local u383 = nil
    local v384 = nil
    if u382 == 4 then
        u383 = u244
        v384 = u248
    elseif u382 == 8 then
        u383 = u253
        v384 = u257
    else
        error((("number bytes must be integer 4 or 8, got %*"):format(u382)))
    end
    local v387 = {
        ["ser"] = function(p385, p386) --[[Function name: ser, line 615]]
            --[[
            Upvalues:
                [1] = u10
                [2] = u382
                [3] = u383
            --]]
            u10(p385, u382)
            u383(p385, p386)
        end,
        ["des"] = v384
    }
    u381[u382] = v387
    return v387
end
local u388 = {}
function v349.range(u389, p390) --[[Anonymous function at line 629]]
    --[[
    Upvalues:
        [1] = u388
        [2] = u15
        [3] = u19
        [4] = u24
        [5] = u28
        [6] = u36
        [7] = u43
        [8] = u48
        [9] = u52
        [10] = u60
        [11] = u67
        [12] = u75
        [13] = u82
        [14] = u93
        [15] = u104
        [16] = u112
        [17] = u119
        [18] = u10
    --]]
    local v391 = ("%*_%*"):format(u389, p390)
    local v392 = u388[v391]
    if v392 then
        return v392
    end
    local v393
    if u389 == u389 // 1 and p390 == p390 // 1 then
        v393 = u389 < p390
    else
        v393 = false
    end
    assert(v393, "min and max must be integers, and min < max")
    local v394 = p390 - u389
    local u395, u396, u397
    if v394 < 256 then
        u395 = u15
        u396 = u19
        u397 = 1
    elseif v394 < 65536 then
        u395 = u24
        u396 = u28
        u397 = 2
    elseif v394 < 16777216 then
        u395 = u36
        u396 = u43
        u397 = 3
    elseif v394 < 4294967296 then
        u395 = u48
        u396 = u52
        u397 = 4
    elseif v394 < 1099511627776 then
        u395 = u60
        u396 = u67
        u397 = 5
    elseif v394 < 281474976710656 then
        u395 = u75
        u396 = u82
        u397 = 6
    elseif v394 < 7.205759403792794e16 then
        u395 = u93
        u396 = u104
        u397 = 7
    else
        u395 = u112
        u396 = u119
        u397 = 8
    end
    local v401 = {
        ["ser"] = function(p398, p399) --[[Function name: ser, line 658]]
            --[[
            Upvalues:
                [1] = u10
                [2] = u397
                [3] = u395
                [4] = u389
            --]]
            u10(p398, u397)
            u395(p398, p399 - u389)
        end,
        ["des"] = function(p400) --[[Function name: des, line 662]]
            --[[
            Upvalues:
                [1] = u396
                [2] = u389
            --]]
            return u396(p400) + u389
        end
    }
    u388[v391] = v401
    return v401
end
local u405 = {
    ["ser"] = function(p402, p403) --[[Function name: ser, line 674]]
        --[[
        Upvalues:
            [1] = u10
            [2] = u287
        --]]
        u10(p402, #p403)
        local v404 = #p403
        buffer.writestring(p402.Buf, p402.Pos, p403)
        p402.Pos = p402.Pos + v404
        u287(p402, v404)
    end,
    ["des"] = u324
}
local u406 = {}
local v414 = {
    ["__call"] = function(_, u407) --[[Function name: __call, line 683]]
        --[[
        Upvalues:
            [1] = u405
            [2] = u406
            [3] = u10
            [4] = u287
            [5] = u324
        --]]
        if not u407 then
            return u405
        end
        if u406[u407] then
            return u406[u407]
        end
        local v413 = {
            ["ser"] = function(p408, p409) --[[Function name: ser, line 693]]
                --[[
                Upvalues:
                    [1] = u10
                    [2] = u407
                    [3] = u287
                --]]
                u10(p408, u407)
                local v410 = u407
                local v411 = v410 or #p409
                buffer.writestring(p408.Buf, p408.Pos, p409)
                p408.Pos = p408.Pos + v411
                if not v410 then
                    u287(p408, v411)
                end
            end,
            ["des"] = function(p412) --[[Function name: des, line 698]]
                --[[
                Upvalues:
                    [1] = u324
                    [2] = u407
                --]]
                return u324(p412, u407)
            end
        }
        u406[u407] = v413
        return v413
    end
}
local v415 = table.create(256)
local u416 = u320
local u417 = u287
local u418 = u366
local v443 = {
    ["convert"] = function(p419, p420, p421) --[[Function name: convert, line 707]]
        local v422 = {}
        for v423 = 1, #p420 do
            v422[string.byte(p420, v423)] = v423 - 1
        end
        local v424 = {}
        for v425 = 1, #p421 do
            v424[v425 - 1] = string.byte(p421, v425)
        end
        local v426 = {}
        for v427 = 1, #p419 do
            local v428 = v422[string.byte(p419, v427)]
            table.insert(v426, v428)
        end
        local v429 = #p420
        local v430 = #p421
        local v431 = {}
        while #v426 > 0 do
            local v432 = 0
            for v433 = 1, #v426 do
                local v434 = v426[v433] + v432 * v429
                local v435 = v434 / v430
                v426[v433] = math.floor(v435)
                v432 = v434 % v430
            end
            while #v426 > 0 and v426[1] == 0 do
                table.remove(v426, 1)
            end
            local v436 = v424[v432]
            local v437 = string.char(v436)
            table.insert(v431, 1, v437)
        end
        return table.concat(v431)
    end,
    ["alphabet"] = function(p438) --[[Function name: alphabet, line 745]]
        local v439 = table.create(#p438)
        local v440 = {}
        for v441 = 1, #p438 do
            local v442 = string.sub(p438, v441, v441)
            if not v440[v442] then
                v440[v442] = true
                table.insert(v439, v442)
            end
        end
        table.sort(v439)
        return table.concat(v439)
    end,
    ["binary"] = "01",
    ["octal"] = "01234567",
    ["decimal"] = "0123456789",
    ["duodecimal"] = "0123456789AB",
    ["hexadecimal"] = "0123456789ABCDEF"
}
for v444 = 0, 255 do
    v415[v444 + 1] = string.char(v444)
end
v443.utf8 = table.concat(v415)
v443.lower = "abcdefghijklmnopqrstuvwxyz"
v443.upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
v443.letters = v443.lower .. v443.upper
v443.punctuation = " .,?!:;\'\"-_"
v443.english = v443.letters .. v443.punctuation
v443.filepath = v443.letters .. ":/"
v443.datastore = " !#$%&\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[]^_`abcdefghijklmnopqrstuvwxyz{|}~"
v349.string = setmetatable(v443, v414)
local u445 = {}
local u446 = {}
function v349.opt(u447) --[[Anonymous function at line 784]]
    --[[
    Upvalues:
        [1] = u446
        [2] = u10
        [3] = u445
    --]]
    if u446[u447] then
        return u446[u447]
    end
    local v457 = {
        ["ser"] = function(p448, p449) --[[Function name: ser, line 790]]
            --[[
            Upvalues:
                [1] = u10
                [2] = u447
            --]]
            if p449 == nil then
                u10(p448, 1)
                local v450 = p448.Buf
                local v451 = p448.Pos
                buffer.writeu8(v450, v451, 0)
                p448.Pos = p448.Pos + 1
            else
                u447.ser(p448, p449)
                u10(p448, 1)
                local v452 = p448.Buf
                local v453 = p448.Pos
                buffer.writeu8(v452, v453, 1)
                p448.Pos = p448.Pos + 1
            end
        end,
        ["des"] = function(p454) --[[Function name: des, line 801]]
            --[[
            Upvalues:
                [1] = u447
            --]]
            p454.Pos = p454.Pos - 1
            local v455 = p454.Buf
            local v456 = p454.Pos
            if buffer.readu8(v455, v456) == 1 then
                return u447.des(p454)
            else
                return nil
            end
        end
    }
    u446[u447] = v457
    u445[v457] = u447
    return v457
end
local u461 = {
    ["ser"] = function(p458, p459) --[[Function name: ser, line 817]]
        --[[
        Upvalues:
            [1] = u10
            [2] = u417
        --]]
        u10(p458, buffer.len(p459))
        local v460 = buffer.len(p459)
        buffer.copy(p458.Buf, p458.Pos, p459, 0, v460)
        p458.Pos = p458.Pos + v460
        u417(p458, v460)
    end,
    ["des"] = v329
}
local u462 = {}
function v349.buffer(u463) --[[Anonymous function at line 824]]
    --[[
    Upvalues:
        [1] = u461
        [2] = u462
        [3] = u10
        [4] = u417
        [5] = u416
    --]]
    if not u463 then
        return u461
    end
    if u462[u463] then
        return u462[u463]
    end
    local v471 = {
        ["ser"] = function(p464, p465) --[[Function name: ser, line 834]]
            --[[
            Upvalues:
                [1] = u10
                [2] = u463
                [3] = u417
            --]]
            u10(p464, u463)
            local v466 = u463
            local v467 = v466 or buffer.len(p465)
            buffer.copy(p464.Buf, p464.Pos, p465, 0, v467)
            p464.Pos = p464.Pos + v467
            if not v466 then
                u417(p464, v467)
            end
        end,
        ["des"] = function(p468) --[[Function name: des, line 839]]
            --[[
            Upvalues:
                [1] = u463
                [2] = u416
            --]]
            local v469 = u463 or u416(p468)
            p468.Pos = p468.Pos - v469
            local v470 = buffer.create(v469)
            buffer.copy(v470, 0, p468.Buf, p468.Pos, v469)
            return v470
        end
    }
    u462[u463] = v471
    return v471
end
local u472 = {
    ["ser"] = u417,
    ["des"] = u416
}
function v349.vlq() --[[Anonymous function at line 853]]
    --[[
    Upvalues:
        [1] = u472
    --]]
    return u472
end
local function u537(p473, p474, p475) --[[Anonymous function at line 860]]
    local v476 = p475 or #p474
    if v476 == 0 then
        return
    else
        local v477 = v476 % 8
        local v478 = v476 - v477
        for v479 = 0, v478 - 1, 8 do
            local v480 = p474[v479 + 1]
            local v481 = p474[v479 + 2]
            local v482 = p474[v479 + 3]
            local v483 = p474[v479 + 4]
            local v484 = p474[v479 + 5]
            local v485 = p474[v479 + 6]
            local v486 = p474[v479 + 7]
            local v487 = p474[v479 + 8]
            local v488 = (v480 and 1 or 0) + (v481 and 2 or 0) + (v482 and 4 or 0) + (v483 and 8 or 0) + (v484 and 16 or 0) + (v485 and 32 or 0) + (v486 and 64 or 0) + (v487 and 128 or 0)
            local v489 = p473.Buf
            local v490 = p473.Pos
            buffer.writeu8(v489, v490, v488)
            p473.Pos = p473.Pos + 1
        end
        if v477 == 1 then
            local v491 = (p474[v478 + 1] and 1 or 0) + 0 + 0 + 0 + 0 + 0 + 0 + 0
            local v492 = p473.Buf
            local v493 = p473.Pos
            buffer.writeu8(v492, v493, v491)
            p473.Pos = p473.Pos + 1
            return
        elseif v477 == 2 then
            local v494 = (p474[v478 + 1] and 1 or 0) + (p474[v478 + 2] and 2 or 0) + 0 + 0 + 0 + 0 + 0 + 0
            local v495 = p473.Buf
            local v496 = p473.Pos
            buffer.writeu8(v495, v496, v494)
            p473.Pos = p473.Pos + 1
            return
        elseif v477 == 3 then
            local v497 = p474[v478 + 1]
            local v498 = p474[v478 + 2]
            local v499 = p474[v478 + 3]
            local v500 = (v497 and 1 or 0) + (v498 and 2 or 0) + (v499 and 4 or 0) + 0 + 0 + 0 + 0 + 0
            local v501 = p473.Buf
            local v502 = p473.Pos
            buffer.writeu8(v501, v502, v500)
            p473.Pos = p473.Pos + 1
            return
        elseif v477 == 4 then
            local v503 = p474[v478 + 1]
            local v504 = p474[v478 + 2]
            local v505 = p474[v478 + 3]
            local v506 = p474[v478 + 4]
            local v507 = (v503 and 1 or 0) + (v504 and 2 or 0) + (v505 and 4 or 0) + (v506 and 8 or 0) + 0 + 0 + 0 + 0
            local v508 = p473.Buf
            local v509 = p473.Pos
            buffer.writeu8(v508, v509, v507)
            p473.Pos = p473.Pos + 1
            return
        elseif v477 == 5 then
            local v510 = p474[v478 + 1]
            local v511 = p474[v478 + 2]
            local v512 = p474[v478 + 3]
            local v513 = p474[v478 + 4]
            local v514 = p474[v478 + 5]
            local v515 = (v510 and 1 or 0) + (v511 and 2 or 0) + (v512 and 4 or 0) + (v513 and 8 or 0) + (v514 and 16 or 0) + 0 + 0 + 0
            local v516 = p473.Buf
            local v517 = p473.Pos
            buffer.writeu8(v516, v517, v515)
            p473.Pos = p473.Pos + 1
            return
        elseif v477 == 6 then
            local v518 = p474[v478 + 1]
            local v519 = p474[v478 + 2]
            local v520 = p474[v478 + 3]
            local v521 = p474[v478 + 4]
            local v522 = p474[v478 + 5]
            local v523 = p474[v478 + 6]
            local v524 = (v518 and 1 or 0) + (v519 and 2 or 0) + (v520 and 4 or 0) + (v521 and 8 or 0) + (v522 and 16 or 0) + (v523 and 32 or 0) + 0 + 0
            local v525 = p473.Buf
            local v526 = p473.Pos
            buffer.writeu8(v525, v526, v524)
            p473.Pos = p473.Pos + 1
        elseif v477 == 7 then
            local v527 = p474[v478 + 1]
            local v528 = p474[v478 + 2]
            local v529 = p474[v478 + 3]
            local v530 = p474[v478 + 4]
            local v531 = p474[v478 + 5]
            local v532 = p474[v478 + 6]
            local v533 = p474[v478 + 7]
            local v534 = (v527 and 1 or 0) + (v528 and 2 or 0) + (v529 and 4 or 0) + (v530 and 8 or 0) + (v531 and 16 or 0) + (v532 and 32 or 0) + (v533 and 64 or 0) + 0
            local v535 = p473.Buf
            local v536 = p473.Pos
            buffer.writeu8(v535, v536, v534)
            p473.Pos = p473.Pos + 1
        end
    end
end
local function u581(p538, p539) --[[Anonymous function at line 892]]
    if p539 == 0 then
        return {}
    end
    local v540 = table.create(p539)
    local v541 = p539 // 8
    local v542 = v541 * 8
    local v543 = p539 % 8
    if v543 > 0 then
        p538.Pos = p538.Pos - 1
        local v544 = p538.Buf
        local v545 = p538.Pos
        local v546 = buffer.readu8(v544, v545)
        local v547 = v546 % 2 >= 1
        local v548 = v546 % 4 >= 2
        local v549 = v546 % 8 >= 4
        local v550 = v546 % 16 >= 8
        local v551 = v546 % 32 >= 16
        local v552 = v546 % 64 >= 32
        local v553 = v546 % 128 >= 64
        local _ = v546 % 256 >= 128
        v540[v542 + 1] = v547
        local v554 = v542 + 2
        if v543 <= 1 then
            v548 = nil
        end
        v540[v554] = v548
        local v555 = v542 + 3
        if v543 <= 2 then
            v549 = nil
        end
        v540[v555] = v549
        local v556 = v542 + 4
        if v543 <= 3 then
            v550 = nil
        end
        v540[v556] = v550
        local v557 = v542 + 5
        if v543 <= 4 then
            v551 = nil
        end
        v540[v557] = v551
        local v558 = v542 + 6
        if v543 <= 5 then
            v552 = nil
        end
        v540[v558] = v552
        local v559 = v542 + 7
        if v543 <= 6 then
            v553 = nil
        end
        v540[v559] = v553
    end
    for v560 = v541 - 1, 0, -1 do
        local v561 = v560 * 8
        local v562 = v561 + 1
        local v563 = v561 + 2
        local v564 = v561 + 3
        local v565 = v561 + 4
        local v566 = v561 + 5
        local v567 = v561 + 6
        local v568 = v561 + 7
        local v569 = v561 + 8
        p538.Pos = p538.Pos - 1
        local v570 = p538.Buf
        local v571 = p538.Pos
        local v572 = buffer.readu8(v570, v571)
        local v573 = v572 % 2 >= 1
        local v574 = v572 % 4 >= 2
        local v575 = v572 % 8 >= 4
        local v576 = v572 % 16 >= 8
        local v577 = v572 % 32 >= 16
        local v578 = v572 % 64 >= 32
        local v579 = v572 % 128 >= 64
        local v580 = v572 % 256 >= 128
        v540[v562] = v573
        v540[v563] = v574
        v540[v564] = v575
        v540[v565] = v576
        v540[v566] = v577
        v540[v567] = v578
        v540[v568] = v579
        v540[v569] = v580
    end
    return v540
end
local u582 = {}
function v349.array(u583, u584) --[[Anonymous function at line 924]]
    --[[
    Upvalues:
        [1] = u582
        [2] = u418
        [3] = u537
        [4] = u417
        [5] = u416
        [6] = u581
        [7] = u445
        [8] = u10
    --]]
    local v585 = u582[u583]
    local v586 = u584 or 0
    if v585 then
        if v585[v586] then
            return v585[v586]
        end
    else
        v585 = {}
        u582[u583] = v585
    end
    if u583 == u418 then
        local v595 = {
            ["ser"] = function(p587, p588) --[[Function name: ser, line 938]]
                --[[
                Upvalues:
                    [1] = u584
                    [2] = u537
                    [3] = u417
                --]]
                local v589 = u584
                local v590
                if type(v589) == "number" then
                    v590 = u584
                else
                    v590 = #p588
                end
                u537(p587, p588, v590)
                if u584 then
                    local v591 = u584
                    if type(v591) ~= "number" then
                        u584.ser(p587, v590)
                    end
                else
                    u417(p587, v590)
                end
            end,
            ["des"] = function(p592) --[[Function name: des, line 947]]
                --[[
                Upvalues:
                    [1] = u584
                    [2] = u416
                    [3] = u581
                --]]
                local v593
                if u584 then
                    local v594 = u584
                    if type(v594) == "number" then
                        v593 = u584
                    else
                        v593 = u584.des(p592)
                    end
                else
                    v593 = u416(p592)
                end
                return u581(p592, v593)
            end
        }
        v585[v586] = v595
        return v595
    elseif u445[u583] then
        local u596 = u445[u583]
        if u596 == u418 then
            local v617 = {
                ["ser"] = function(p597, p598) --[[Function name: ser, line 958]]
                    --[[
                    Upvalues:
                        [1] = u584
                        [2] = u10
                        [3] = u537
                        [4] = u417
                    --]]
                    local v599 = u584
                    local v600
                    if type(v599) == "number" then
                        v600 = u584
                    else
                        v600 = table.maxn(p598)
                    end
                    local v601 = table.create(v600)
                    local v602 = table.create(v600)
                    for v603 = 1, v600 do
                        local v604 = p598[v603]
                        if v604 == nil then
                            v602[v603] = false
                        else
                            table.insert(v601, v604)
                            v602[v603] = true
                        end
                    end
                    u10(p597, #v601 // 8 + 1 + (1 + v600 // 8))
                    u537(p597, v601)
                    u537(p597, v602)
                    if u584 then
                        local v605 = u584
                        if type(v605) ~= "number" then
                            u584.ser(p597, v600)
                        end
                    else
                        u417(p597, v600)
                    end
                end,
                ["des"] = function(p606) --[[Function name: des, line 983]]
                    --[[
                    Upvalues:
                        [1] = u584
                        [2] = u416
                        [3] = u581
                    --]]
                    local v607
                    if u584 then
                        local v608 = u584
                        if type(v608) == "number" then
                            v607 = u584
                        else
                            v607 = u584.des(p606)
                        end
                    else
                        v607 = u416(p606)
                    end
                    local v609 = u581(p606, v607)
                    local v610 = 0
                    for _, v611 in v609 do
                        v610 = v610 + (v611 and 1 or 0)
                    end
                    local v612 = u581(p606, v610)
                    local v613 = table.create(v607)
                    local v614 = 1
                    for v615, v616 in v609 do
                        if v616 then
                            v613[v615] = v612[v614]
                            v614 = v614 + 1
                        end
                    end
                    return v613
                end
            }
            v585[v586] = v617
            return v617
        else
            local v634 = {
                ["ser"] = function(p618, p619) --[[Function name: ser, line 1008]]
                    --[[
                    Upvalues:
                        [1] = u596
                        [2] = u584
                        [3] = u10
                        [4] = u537
                        [5] = u417
                    --]]
                    local v620 = u596.ser
                    local v621 = u584
                    local v622
                    if type(v621) == "number" then
                        v622 = u584
                    else
                        v622 = table.maxn(p619)
                    end
                    local v623 = table.create(v622)
                    for v624 = 1, v622 do
                        local v625 = p619[v624]
                        if v625 == nil then
                            v623[v624] = false
                        else
                            v620(p618, v625)
                            v623[v624] = true
                        end
                    end
                    u10(p618, 1 + v622 // 8)
                    u537(p618, v623)
                    if u584 then
                        local v626 = u584
                        if type(v626) ~= "number" then
                            u584.ser(p618, v622)
                        end
                    else
                        u417(p618, v622)
                    end
                end,
                ["des"] = function(p627) --[[Function name: des, line 1031]]
                    --[[
                    Upvalues:
                        [1] = u596
                        [2] = u584
                        [3] = u416
                        [4] = u581
                    --]]
                    local v628 = u596.des
                    local v629
                    if u584 then
                        local v630 = u584
                        if type(v630) == "number" then
                            v629 = u584
                        else
                            v629 = u584.des(p627)
                        end
                    else
                        v629 = u416(p627)
                    end
                    local v631 = u581(p627, v629)
                    local v632 = table.create(v629)
                    for v633 = v629, 1, -1 do
                        if v631[v633] then
                            v632[v633] = v628(p627)
                        end
                    end
                    return v632
                end
            }
            v585[v586] = v634
            return v634
        end
    else
        local v648 = {
            ["ser"] = function(p635, p636) --[[Function name: ser, line 1051]]
                --[[
                Upvalues:
                    [1] = u583
                    [2] = u584
                    [3] = u417
                --]]
                local v637 = u583.ser
                local v638 = u584
                local v639
                if type(v638) == "number" then
                    v639 = u584
                else
                    v639 = #p636
                end
                for v640 = 1, v639 do
                    v637(p635, p636[v640])
                end
                if u584 then
                    local v641 = u584
                    if type(v641) ~= "number" then
                        u584.ser(p635, v639)
                    end
                else
                    u417(p635, v639)
                end
            end,
            ["des"] = function(p642) --[[Function name: des, line 1064]]
                --[[
                Upvalues:
                    [1] = u583
                    [2] = u584
                    [3] = u416
                --]]
                local v643 = u583.des
                local v644
                if u584 then
                    local v645 = u584
                    if type(v645) == "number" then
                        v644 = u584
                    else
                        v644 = u584.des(p642)
                    end
                else
                    v644 = u416(p642)
                end
                local v646 = table.create(v644)
                for v647 = v644, 1, -1 do
                    v646[v647] = v643(p642)
                end
                return v646
            end
        }
        v585[v586] = v648
        return v648
    end
end
function v349.tuple(...) --[[Anonymous function at line 1082]]
    local u649 = { ... }
    local u650 = #u649
    return u650 ~= 1 and {
        ["ser"] = function(p651, ...) --[[Function name: ser, line 1090]]
            --[[
            Upvalues:
                [1] = u649
            --]]
            for v652, v653 in { ... } do
                u649[v652].ser(p651, v653)
            end
        end,
        ["des"] = function(p654) --[[Function name: des, line 1096]]
            --[[
            Upvalues:
                [1] = u650
                [2] = u649
            --]]
            local v655 = table.create(u650)
            for v656 = u650, 1, -1 do
                v655[v656] = u649[v656].des(p654)
            end
            return table.unpack(v655)
        end
    } or u649[1]
end
function v349.record(u657) --[[Anonymous function at line 1110]]
    --[[
    Upvalues:
        [1] = u445
        [2] = u418
        [3] = u10
        [4] = u537
        [5] = u581
    --]]
    local u658 = {}
    local u659 = {}
    local u660 = {}
    local u661 = {}
    for v662, v663 in u657 do
        if type(v662) == "string" then
            local v664 = u445[v663]
            if v664 == u418 then
                table.insert(u658, v662)
            elseif v664 then
                table.insert(u659, v662)
            elseif v663 == u418 then
                table.insert(u660, v662)
            else
                table.insert(u661, v662)
            end
        end
    end
    local u665 = #u661
    table.sort(u661)
    local u666 = #u660
    if u666 > 0 then
        table.sort(u660)
    end
    local u667 = #u659
    local u668 = {}
    if u667 > 0 then
        table.sort(u659)
        for v669, v670 in u659 do
            u668[v669] = u445[u657[v670]]
        end
    end
    local u671 = #u658
    if u671 > 0 then
        table.sort(u658)
    end
    return {
        ["ser"] = function(p672, p673) --[[Function name: ser, line 1153]]
            --[[
            Upvalues:
                [1] = u661
                [2] = u657
                [3] = u666
                [4] = u671
                [5] = u660
                [6] = u667
                [7] = u658
                [8] = u659
                [9] = u668
                [10] = u10
                [11] = u537
            --]]
            for _, v674 in u661 do
                local v675 = p673[v674]
                u657[v674].ser(p672, v675)
            end
            local v676 = table.create(u666 + u671)
            for v677, v678 in u660 do
                v676[v677] = p673[v678]
            end
            local v679 = u666
            local v680 = table.create(u671 + u667)
            for v681, v682 in u658 do
                local v683 = p673[v682]
                if v683 == nil then
                    v680[v681] = false
                else
                    v679 = v679 + 1
                    v676[v679] = v683
                    v680[v681] = true
                end
            end
            for v684, v685 in u659 do
                local v686 = v684 + u671
                local v687 = p673[v685]
                if v687 == nil then
                    v680[v686] = false
                else
                    u668[v684].ser(p672, v687)
                    v680[v686] = true
                end
            end
            u10(p672, v679 + u671 + u667)
            u537(p672, v676, v679)
            u537(p672, v680, u671 + u667)
        end,
        ["des"] = function(p688) --[[Function name: des, line 1195]]
            --[[
            Upvalues:
                [1] = u581
                [2] = u671
                [3] = u667
                [4] = u666
                [5] = u660
                [6] = u658
                [7] = u659
                [8] = u657
                [9] = u668
                [10] = u665
                [11] = u661
            --]]
            local v689 = u581(p688, u671 + u667)
            local v690 = u666
            local v691 = {}
            for v692 = 1, u671 do
                v690 = v690 + (v689[v692] and 1 or 0)
            end
            local v693 = u581(p688, v690)
            for v694, v695 in u660 do
                v691[v695] = v693[v694]
            end
            for v696 = u671, 1, -1 do
                if v689[v696] then
                    v691[u658[v696]] = v693[v690]
                    v690 = v690 - 1
                end
            end
            for v697 = u667, 1, -1 do
                if v689[v697 + u671] then
                    local v698 = u659[v697]
                    local _ = u657[v698]
                    v691[v698] = u668[v697].des(p688)
                end
            end
            for v699 = u665, 1, -1 do
                local v700 = u661[v699]
                v691[v700] = u657[v700].des(p688)
            end
            return v691
        end
    }
end
function v349.map(u701, u702, u703) --[[Anonymous function at line 1243]]
    --[[
    Upvalues:
        [1] = u417
        [2] = u416
    --]]
    return {
        ["ser"] = function(p704, p705) --[[Function name: ser, line 1245]]
            --[[
            Upvalues:
                [1] = u702
                [2] = u701
                [3] = u703
                [4] = u417
            --]]
            local v706 = 0
            for v707, v708 in p705 do
                u702.ser(p704, v708)
                u701.ser(p704, v707)
                v706 = v706 + 1
            end
            if u703 then
                local v709 = u703
                if type(v709) ~= "number" then
                    u703.ser(p704, v706)
                end
            else
                u417(p704, v706)
            end
        end,
        ["des"] = function(p710) --[[Function name: des, line 1259]]
            --[[
            Upvalues:
                [1] = u703
                [2] = u416
                [3] = u701
                [4] = u702
            --]]
            local v711 = {}
            local v712
            if u703 then
                local v713 = u703
                if type(v713) == "number" then
                    v712 = u703
                else
                    v712 = u703.des(p710)
                end
            else
                v712 = u416(p710)
            end
            for _ = 1, v712 do
                v711[u701.des(p710)] = u702.des(p710)
            end
            return v711
        end
    }
end
function v349.literal(...) --[[Anonymous function at line 1277]]
    --[[
    Upvalues:
        [1] = u10
    --]]
    local u714 = { ... }
    local u715 = {}
    for v716, v717 in u714 do
        u715[v717] = v716 - 1
    end
    return {
        ["ser"] = function(p718, p719) --[[Function name: ser, line 1286]]
            --[[
            Upvalues:
                [1] = u10
                [2] = u715
            --]]
            u10(p718, 1)
            local v720 = u715[p719]
            local v721 = p718.Buf
            local v722 = p718.Pos
            buffer.writeu8(v721, v722, v720)
            p718.Pos = p718.Pos + 1
        end,
        ["des"] = function(p723) --[[Function name: des, line 1291]]
            --[[
            Upvalues:
                [1] = u714
            --]]
            local v724 = u714
            p723.Pos = p723.Pos - 1
            local v725 = p723.Buf
            local v726 = p723.Pos
            return v724[buffer.readu8(v725, v726) + 1]
        end
    }
end
function v349.table(u727, u728) --[[Anonymous function at line 1299]]
    --[[
    Upvalues:
        [1] = u10
        [2] = u417
        [3] = u416
    --]]
    local u729 = {}
    local u730 = {}
    for v731 in u727 do
        local v732 = #u729 + 1
        u729[v732] = v731
        u730[v731] = v732
    end
    return {
        ["ser"] = function(p733, p734) --[[Function name: ser, line 1310]]
            --[[
            Upvalues:
                [1] = u727
                [2] = u730
                [3] = u10
                [4] = u728
                [5] = u417
            --]]
            local v735 = 0
            for v736, v737 in p734 do
                local v738 = typeof(v737)
                local v739 = u727[v738]
                if v739 then
                    local v740 = typeof(v736)
                    local v741 = u727[v740]
                    if v741 then
                        v739.ser(p733, v737)
                        local v742 = u730[v738] or error("")
                        u10(p733, 1)
                        local v743 = v742 - 1
                        local v744 = p733.Buf
                        local v745 = p733.Pos
                        buffer.writeu8(v744, v745, v743)
                        p733.Pos = p733.Pos + 1
                        v741.ser(p733, v736)
                        local v746 = u730[v740] or error("")
                        u10(p733, 1)
                        local v747 = v746 - 1
                        local v748 = p733.Buf
                        local v749 = p733.Pos
                        buffer.writeu8(v748, v749, v747)
                        p733.Pos = p733.Pos + 1
                        v735 = v735 + 1
                    end
                end
            end
            if u728 then
                local v750 = u728
                if type(v750) ~= "number" then
                    u728.ser(p733, v735)
                end
            else
                u417(p733, v735)
            end
        end,
        ["des"] = function(p751) --[[Function name: des, line 1345]]
            --[[
            Upvalues:
                [1] = u728
                [2] = u416
                [3] = u729
                [4] = u727
            --]]
            local v752 = {}
            local v753
            if u728 then
                local v754 = u728
                if type(v754) == "number" then
                    v753 = u728
                else
                    v753 = u728.des(p751)
                end
            else
                v753 = u416(p751)
            end
            for _ = 1, v753 do
                p751.Pos = p751.Pos - 1
                local v755 = p751.Buf
                local v756 = p751.Pos
                local v757 = u727[u729[buffer.readu8(v755, v756) + 1]].des(p751)
                p751.Pos = p751.Pos - 1
                local v758 = p751.Buf
                local v759 = p751.Pos
                v752[v757] = u727[u729[buffer.readu8(v758, v759) + 1]].des(p751)
            end
            return v752
        end
    }
end
local u794 = {
    ["ser"] = function(p760, p761) --[[Function name: ser, line 1369]]
        --[[
        Upvalues:
            [1] = u10
        --]]
        u10(p760, 2)
        local v762 = p761.Back
        local v763 = p761.Bottom
        local v764 = p761.Front
        local v765 = p761.Left
        local v766 = p761.Right
        local v767 = p761.Top
        local v768 = (v762 and 1 or 0) + (v763 and 2 or 0) + (v764 and 4 or 0) + (v765 and 8 or 0) + (v766 and 16 or 0) + (v767 and 32 or 0) + 0 + 0
        local v769 = p760.Buf
        local v770 = p760.Pos
        buffer.writeu8(v769, v770, v768)
        p760.Pos = p760.Pos + 1
        local v771 = p761.X
        local v772 = p761.Y
        local v773 = p761.Z
        local v774 = (v771 and 1 or 0) + (v772 and 2 or 0) + (v773 and 4 or 0) + 0 + 0 + 0 + 0 + 0
        local v775 = p760.Buf
        local v776 = p760.Pos
        buffer.writeu8(v775, v776, v774)
        p760.Pos = p760.Pos + 1
    end,
    ["des"] = function(p777) --[[Function name: des, line 1375]]
        p777.Pos = p777.Pos - 1
        local v778 = p777.Buf
        local v779 = p777.Pos
        local v780 = buffer.readu8(v778, v779)
        local v781 = v780 % 2 >= 1
        local v782 = v780 % 4 >= 2
        local v783 = v780 % 8 >= 4
        local _ = v780 % 16 >= 8
        local _ = v780 % 32 >= 16
        local _ = v780 % 64 >= 32
        local _ = v780 % 128 >= 64
        local _ = v780 % 256 >= 128
        p777.Pos = p777.Pos - 1
        local v784 = p777.Buf
        local v785 = p777.Pos
        local v786 = buffer.readu8(v784, v785)
        local v787 = v786 % 2 >= 1
        local v788 = v786 % 4 >= 2
        local v789 = v786 % 8 >= 4
        local v790 = v786 % 16 >= 8
        local v791 = v786 % 32 >= 16
        local v792 = v786 % 64 >= 32
        local _ = v786 % 128 >= 64
        local _ = v786 % 256 >= 128
        local v793 = Axes.new
        if v781 then
            v781 = Enum.Axis.X
        end
        if v782 then
            v782 = Enum.Axis.Y
        end
        if v783 then
            v783 = Enum.Axis.Z
        end
        if v787 then
            v787 = Enum.NormalId.Back
        end
        if v788 then
            v788 = Enum.NormalId.Bottom
        end
        if v789 then
            v789 = Enum.NormalId.Front
        end
        if v790 then
            v790 = Enum.NormalId.Left
        end
        if v791 then
            v791 = Enum.NormalId.Right
        end
        if v792 then
            v792 = Enum.NormalId.Top
        end
        return v793(v781, v782, v783, v787, v788, v789, v790, v791, v792)
    end
}
function v349.Axes() --[[Anonymous function at line 1391]]
    --[[
    Upvalues:
        [1] = u794
    --]]
    return u794
end
local u804 = {
    ["ser"] = function(p795, p796) --[[Function name: ser, line 1398]]
        --[[
        Upvalues:
            [1] = u10
        --]]
        u10(p795, 2)
        local v797 = p796.Number
        local v798 = p795.Buf
        local v799 = p795.Pos
        buffer.writeu16(v798, v799, v797)
        p795.Pos = p795.Pos + 2
    end,
    ["des"] = function(p800) --[[Function name: des, line 1403]]
        p800.Pos = p800.Pos - 2
        local v801 = p800.Buf
        local v802 = p800.Pos
        local v803 = buffer.readu16(v801, v802)
        return BrickColor.new(v803)
    end
}
function v349.BrickColor() --[[Anonymous function at line 1408]]
    --[[
    Upvalues:
        [1] = u804
    --]]
    return u804
end
local u805 = {}
function v349.EnumItem(p806) --[[Anonymous function at line 1416]]
    --[[
    Upvalues:
        [1] = u805
        [2] = u417
        [3] = u416
    --]]
    if u805[p806] then
        return u805[p806]
    end
    local v807 = p806:GetEnumItems()
    table.sort(v807, function(p808, p809) --[[Anonymous function at line 1422]]
        return p808.Value < p809.Value
    end)
    local u810 = table.create(#v807)
    local u811 = {}
    for v812, v813 in v807 do
        u811[v813] = v812
        u810[v812] = v813
    end
    local v817 = {
        ["ser"] = function(p814, p815) --[[Function name: ser, line 1434]]
            --[[
            Upvalues:
                [1] = u417
                [2] = u811
            --]]
            u417(p814, u811[p815])
        end,
        ["des"] = function(p816) --[[Function name: des, line 1438]]
            --[[
            Upvalues:
                [1] = u416
                [2] = u810
            --]]
            return u810[u416(p816)]
        end
    }
    u805[p806] = v817
    return v817
end
local u818 = v349.EnumItem
local u855 = {
    ["ser"] = function(p819, p820) --[[Function name: ser, line 1452]]
        --[[
        Upvalues:
            [1] = u10
            [2] = u417
            [3] = u818
        --]]
        u10(p819, #p820.CreatorName + 10 + #p820.SearchKeyword)
        local v821 = (p820.IncludeOffSale and 1 or 0) + 0 + 0 + 0 + 0 + 0 + 0 + 0
        local v822 = p819.Buf
        local v823 = p819.Pos
        buffer.writeu8(v822, v823, v821)
        p819.Pos = p819.Pos + 1
        local v824 = p820.Limit
        local v825 = p819.Buf
        local v826 = p819.Pos
        buffer.writeu8(v825, v826, v824)
        p819.Pos = p819.Pos + 1
        local v827 = p820.MinPrice
        local v828 = p819.Buf
        local v829 = p819.Pos
        buffer.writeu32(v828, v829, v827)
        p819.Pos = p819.Pos + 4
        local v830 = p820.MaxPrice
        local v831 = p819.Buf
        local v832 = p819.Pos
        buffer.writeu32(v831, v832, v830)
        p819.Pos = p819.Pos + 4
        local v833 = p820.CreatorName
        local v834 = #v833
        buffer.writestring(p819.Buf, p819.Pos, v833)
        p819.Pos = p819.Pos + v834
        u417(p819, v834)
        local v835 = p820.SearchKeyword
        local v836 = #v835
        buffer.writestring(p819.Buf, p819.Pos, v835)
        p819.Pos = p819.Pos + v836
        u417(p819, v836)
        u818(Enum.CatalogSortType).ser(p819, p820.SortType)
        u818(Enum.CatalogSortAggregation).ser(p819, p820.SortAggregation)
        u818(Enum.CatalogCategoryFilter).ser(p819, p820.CategoryFilter)
        u818(Enum.SalesTypeFilter).ser(p819, p820.SalesTypeFilter)
        for _, v837 in p820.AssetTypes do
            u818(Enum.AssetType).ser(p819, v837)
        end
        u417(p819, #p820.AssetTypes)
    end,
    ["des"] = function(p838) --[[Function name: des, line 1470]]
        --[[
        Upvalues:
            [1] = u416
            [2] = u818
        --]]
        local v839 = CatalogSearchParams.new()
        local v840 = u416(p838)
        local v841 = table.create(v840)
        for v842 = v840, 1, -1 do
            v841[v842] = u818(Enum.AssetType).des(p838)
        end
        v839.AssetTypes = v841
        v839.SalesTypeFilter = u818(Enum.SalesTypeFilter).des(p838)
        v839.CategoryFilter = u818(Enum.CatalogCategoryFilter).des(p838)
        v839.SortAggregation = u818(Enum.CatalogSortAggregation).des(p838)
        v839.SortType = u818(Enum.CatalogSortType).des(p838)
        local v843 = u416(p838)
        p838.Pos = p838.Pos - v843
        v839.SearchKeyword = buffer.readstring(p838.Buf, p838.Pos, v843)
        local v844 = u416(p838)
        p838.Pos = p838.Pos - v844
        v839.CreatorName = buffer.readstring(p838.Buf, p838.Pos, v844)
        p838.Pos = p838.Pos - 4
        local v845 = p838.Buf
        local v846 = p838.Pos
        v839.MaxPrice = buffer.readu32(v845, v846)
        p838.Pos = p838.Pos - 4
        local v847 = p838.Buf
        local v848 = p838.Pos
        v839.MinPrice = buffer.readu32(v847, v848)
        p838.Pos = p838.Pos - 1
        local v849 = p838.Buf
        local v850 = p838.Pos
        v839.Limit = buffer.readu8(v849, v850)
        p838.Pos = p838.Pos - 1
        local v851 = p838.Buf
        local v852 = p838.Pos
        local v853 = buffer.readu8(v851, v852)
        local v854 = v853 % 2 >= 1
        local _ = v853 % 4 >= 2
        local _ = v853 % 8 >= 4
        local _ = v853 % 16 >= 8
        local _ = v853 % 32 >= 16
        local _ = v853 % 64 >= 32
        local _ = v853 % 128 >= 64
        local _ = v853 % 256 >= 128
        v839.IncludeOffSale = v854
        return v839
    end
}
function v349.CatalogSearchParams() --[[Anonymous function at line 1492]]
    --[[
    Upvalues:
        [1] = u855
    --]]
    return u855
end
local u856 = (function() --[[Function name: cframeLookupEntries, line 1499]]
    return {
        CFrame.Angles(0, 0, 0),
        CFrame.Angles(1.5707963267948966, 0, 0),
        CFrame.Angles(0, 3.141592653589793, 3.141592653589793),
        CFrame.Angles(-1.5707963267948966, 0, 0),
        CFrame.Angles(0, 3.141592653589793, 1.5707963267948966),
        CFrame.Angles(0, 1.5707963267948966, 1.5707963267948966),
        CFrame.Angles(0, 0, 1.5707963267948966),
        CFrame.Angles(0, -1.5707963267948966, 1.5707963267948966),
        CFrame.Angles(-1.5707963267948966, -1.5707963267948966, 0),
        CFrame.Angles(0, -1.5707963267948966, 0),
        CFrame.Angles(1.5707963267948966, -1.5707963267948966, 0),
        CFrame.Angles(0, 1.5707963267948966, 3.141592653589793),
        CFrame.Angles(0, -1.5707963267948966, 3.141592653589793),
        CFrame.Angles(0, 3.141592653589793, 0),
        CFrame.Angles(-1.5707963267948966, -3.141592653589793, 0),
        CFrame.Angles(0, 0, 3.141592653589793),
        CFrame.Angles(1.5707963267948966, 3.141592653589793, 0),
        CFrame.Angles(0, 0, -1.5707963267948966),
        CFrame.Angles(0, -1.5707963267948966, -1.5707963267948966),
        CFrame.Angles(0, -3.141592653589793, -1.5707963267948966),
        CFrame.Angles(0, 1.5707963267948966, -1.5707963267948966),
        CFrame.Angles(1.5707963267948966, 1.5707963267948966, 0),
        CFrame.Angles(0, 1.5707963267948966, 0),
        CFrame.Angles(-1.5707963267948966, 1.5707963267948966, 0)
    }
end)()
local u861 = (function(p857) --[[Function name: cframeSpecialCaseLookup, line 1528]]
    local v858 = {}
    for v859, v860 in p857 do
        v858[Vector3.new(v860:ToOrientation())] = v859
    end
    return v858
end)(u856)
local function u885(p862, p863) --[[Anonymous function at line 1541]]
    --[[
    Upvalues:
        [1] = u861
        [2] = u10
    --]]
    local v864 = u861[Vector3.new(p863:ToOrientation())]
    if v864 then
        u10(p862, 1)
        local v865 = p862.Buf
        local v866 = p862.Pos
        buffer.writeu8(v865, v866, v864)
        p862.Pos = p862.Pos + 1
    else
        local v867, v868 = p863:ToAxisAngle()
        local v869 = v868 / 2
        local v870 = v867 * math.sin(v869)
        u10(p862, 7)
        local v871 = (v870.Z + 1) * 32768 - 1
        local v872 = math.round(v871)
        local v873 = (v870.Y + 1) * 32768 - 1
        local v874 = math.round(v873)
        local v875 = (v870.X + 1) * 32768 - 1
        local v876 = math.round(v875)
        local v877 = p862.Buf
        local v878 = p862.Pos
        buffer.writeu16(v877, v878, v872)
        p862.Pos = p862.Pos + 2
        local v879 = p862.Buf
        local v880 = p862.Pos
        buffer.writeu16(v879, v880, v874)
        p862.Pos = p862.Pos + 2
        local v881 = p862.Buf
        local v882 = p862.Pos
        buffer.writeu16(v881, v882, v876)
        p862.Pos = p862.Pos + 2
        local v883 = p862.Buf
        local v884 = p862.Pos
        buffer.writeu8(v883, v884, 0)
        p862.Pos = p862.Pos + 1
    end
end
local function u902(p886) --[[Anonymous function at line 1560]]
    --[[
    Upvalues:
        [1] = u856
    --]]
    p886.Pos = p886.Pos - 1
    local v887 = p886.Buf
    local v888 = p886.Pos
    local v889 = buffer.readu8(v887, v888)
    if v889 ~= 0 then
        return u856[v889]
    end
    p886.Pos = p886.Pos - 2
    local v890 = p886.Buf
    local v891 = p886.Pos
    local v892 = (buffer.readu16(v890, v891) + 1) * 0.000030517578125 - 1
    p886.Pos = p886.Pos - 2
    local v893 = p886.Buf
    local v894 = p886.Pos
    local v895 = (buffer.readu16(v893, v894) + 1) * 0.000030517578125 - 1
    p886.Pos = p886.Pos - 2
    local v896 = p886.Buf
    local v897 = p886.Pos
    local v898 = (buffer.readu16(v896, v897) + 1) * 0.000030517578125 - 1
    local v899 = v892 * v892 + v895 * v895 + v898 * v898
    local v900 = 1 - math.clamp(v899, 0, 1)
    local v901 = math.sqrt(v900)
    return CFrame.new(0, 0, 0, v892, v895, v898, v901)
end
local u903 = {
    ["ser"] = u885,
    ["des"] = u902
}
function v349.rotation() --[[Anonymous function at line 1577]]
    --[[
    Upvalues:
        [1] = u903
    --]]
    return u903
end
local u904 = {}
function v349.CFrame(p905) --[[Anonymous function at line 1585]]
    --[[
    Upvalues:
        [1] = u904
        [2] = u885
        [3] = u902
    --]]
    if u904[p905] then
        return u904[p905]
    end
    local u906 = p905.ser
    local u907 = p905.des
    local v915 = {
        ["ser"] = function(p908, p909) --[[Function name: ser, line 1593]]
            --[[
            Upvalues:
                [1] = u885
                [2] = u906
            --]]
            u885(p908, p909)
            local v910 = p909.Position
            u906(p908, v910.Z)
            u906(p908, v910.Y)
            u906(p908, v910.X)
        end,
        ["des"] = function(p911) --[[Function name: des, line 1602]]
            --[[
            Upvalues:
                [1] = u907
                [2] = u902
            --]]
            local v912 = u907(p911)
            local v913 = u907(p911)
            local v914 = u907(p911)
            return u902(p911) + Vector3.new(v912, v913, v914)
        end
    }
    u904[p905] = v915
    return v915
end
local u916 = v349.CFrame
local function u927(p917) --[[Anonymous function at line 1619]]
    local v918 = Color3.fromRGB
    p917.Pos = p917.Pos - 1
    local v919 = p917.Buf
    local v920 = p917.Pos
    local v921 = buffer.readu8(v919, v920)
    p917.Pos = p917.Pos - 1
    local v922 = p917.Buf
    local v923 = p917.Pos
    local v924 = buffer.readu8(v922, v923)
    p917.Pos = p917.Pos - 1
    local v925 = p917.Buf
    local v926 = p917.Pos
    return v918(v921, v924, (buffer.readu8(v925, v926)))
end
local u939 = {
    ["ser"] = function(p928, p929) --[[Function name: ser, line 1624]]
        --[[
        Upvalues:
            [1] = u10
        --]]
        u10(p928, 3)
        local v930 = p929.B * 255
        local v931 = p928.Buf
        local v932 = p928.Pos
        buffer.writeu8(v931, v932, v930)
        p928.Pos = p928.Pos + 1
        local v933 = p929.G * 255
        local v934 = p928.Buf
        local v935 = p928.Pos
        buffer.writeu8(v934, v935, v933)
        p928.Pos = p928.Pos + 1
        local v936 = p929.R * 255
        local v937 = p928.Buf
        local v938 = p928.Pos
        buffer.writeu8(v937, v938, v936)
        p928.Pos = p928.Pos + 1
    end,
    ["des"] = u927
}
function v349.Color3() --[[Anonymous function at line 1630]]
    --[[
    Upvalues:
        [1] = u939
    --]]
    return u939
end
local u959 = {
    ["ser"] = function(p940, p941) --[[Function name: ser, line 1644]]
        --[[
        Upvalues:
            [1] = u10
        --]]
        u10(p940, 4)
        local v942 = p941.Value
        local v943 = v942.B * 255
        local v944 = p940.Buf
        local v945 = p940.Pos
        buffer.writeu8(v944, v945, v943)
        p940.Pos = p940.Pos + 1
        local v946 = v942.G * 255
        local v947 = p940.Buf
        local v948 = p940.Pos
        buffer.writeu8(v947, v948, v946)
        p940.Pos = p940.Pos + 1
        local v949 = v942.R * 255
        local v950 = p940.Buf
        local v951 = p940.Pos
        buffer.writeu8(v950, v951, v949)
        p940.Pos = p940.Pos + 1
        local v952 = p941.Time * 255
        local v953 = p940.Buf
        local v954 = p940.Pos
        buffer.writeu8(v953, v954, v952)
        p940.Pos = p940.Pos + 1
    end,
    ["des"] = function(p955) --[[Function name: popcolorsequencekeypoint, line 1639]]
        --[[
        Upvalues:
            [1] = u927
        --]]
        local v956 = ColorSequenceKeypoint.new
        p955.Pos = p955.Pos - 1
        local v957 = p955.Buf
        local v958 = p955.Pos
        return v956(buffer.readu8(v957, v958) / 255, u927(p955))
    end
}
function v349.ColorSequenceKeypoint() --[[Anonymous function at line 1650]]
    --[[
    Upvalues:
        [1] = u959
    --]]
    return u959
end
local u983 = {
    ["ser"] = function(p960, p961) --[[Function name: ser, line 1657]]
        --[[
        Upvalues:
            [1] = u10
            [2] = u417
        --]]
        u10(p960, #p961.Keypoints * 4)
        for _, v962 in p961.Keypoints do
            local v963 = v962.Value
            local v964 = v963.B * 255
            local v965 = p960.Buf
            local v966 = p960.Pos
            buffer.writeu8(v965, v966, v964)
            p960.Pos = p960.Pos + 1
            local v967 = v963.G * 255
            local v968 = p960.Buf
            local v969 = p960.Pos
            buffer.writeu8(v968, v969, v967)
            p960.Pos = p960.Pos + 1
            local v970 = v963.R * 255
            local v971 = p960.Buf
            local v972 = p960.Pos
            buffer.writeu8(v971, v972, v970)
            p960.Pos = p960.Pos + 1
            local v973 = v962.Time * 255
            local v974 = p960.Buf
            local v975 = p960.Pos
            buffer.writeu8(v974, v975, v973)
            p960.Pos = p960.Pos + 1
        end
        u417(p960, #p961.Keypoints)
    end,
    ["des"] = function(p976) --[[Function name: des, line 1665]]
        --[[
        Upvalues:
            [1] = u416
            [2] = u927
        --]]
        local v977 = u416(p976)
        local v978 = table.create(v977)
        for v979 = v977, 1, -1 do
            local v980 = ColorSequenceKeypoint.new
            p976.Pos = p976.Pos - 1
            local v981 = p976.Buf
            local v982 = p976.Pos
            v978[v979] = v980(buffer.readu8(v981, v982) / 255, u927(p976))
        end
        return ColorSequence.new(v978)
    end
}
function v349.ColorSequence() --[[Anonymous function at line 1674]]
    --[[
    Upvalues:
        [1] = u983
    --]]
    return u983
end
local u999 = {
    ["ser"] = function(p984, p985) --[[Function name: ser, line 1681]]
        --[[
        Upvalues:
            [1] = u10
        --]]
        u10(p984, 6)
        local v986 = p985.UnixTimestampMillis
        local v987 = p984.Buf
        local v988 = p984.Pos
        buffer.writeu16(v987, v988, v986)
        local v989 = p984.Buf
        local v990 = p984.Pos + 2
        local v991 = v986 // 65536
        buffer.writeu32(v989, v990, v991)
        p984.Pos = p984.Pos + 6
    end,
    ["des"] = function(p992) --[[Function name: des, line 1685]]
        local v993 = DateTime.fromUnixTimestampMillis
        p992.Pos = p992.Pos - 6
        local v994 = p992.Buf
        local v995 = p992.Pos
        local v996 = buffer.readu16(v994, v995)
        local v997 = p992.Buf
        local v998 = p992.Pos + 2
        return v993(v996 + buffer.readu32(v997, v998) * 65536)
    end
}
function v349.DateTime() --[[Anonymous function at line 1689]]
    --[[
    Upvalues:
        [1] = u999
    --]]
    return u999
end
local u1022 = {
    ["ser"] = function(p1000, p1001) --[[Function name: ser, line 1696]]
        --[[
        Upvalues:
            [1] = u10
        --]]
        u10(p1000, 1)
        local v1002 = p1001.Back
        local v1003 = p1001.Bottom
        local v1004 = p1001.Front
        local v1005 = p1001.Left
        local v1006 = p1001.Right
        local v1007 = p1001.Top
        local v1008 = (v1002 and 1 or 0) + (v1003 and 2 or 0) + (v1004 and 4 or 0) + (v1005 and 8 or 0) + (v1006 and 16 or 0) + (v1007 and 32 or 0) + 0 + 0
        local v1009 = p1000.Buf
        local v1010 = p1000.Pos
        buffer.writeu8(v1009, v1010, v1008)
        p1000.Pos = p1000.Pos + 1
    end,
    ["des"] = function(p1011) --[[Function name: des, line 1701]]
        p1011.Pos = p1011.Pos - 1
        local v1012 = p1011.Buf
        local v1013 = p1011.Pos
        local v1014 = buffer.readu8(v1012, v1013)
        local v1015 = v1014 % 2 >= 1
        local v1016 = v1014 % 4 >= 2
        local v1017 = v1014 % 8 >= 4
        local v1018 = v1014 % 16 >= 8
        local v1019 = v1014 % 32 >= 16
        local v1020 = v1014 % 64 >= 32
        local _ = v1014 % 128 >= 64
        local _ = v1014 % 256 >= 128
        local v1021 = Faces.new
        if v1015 then
            v1015 = Enum.NormalId.Back
        end
        if v1016 then
            v1016 = Enum.NormalId.Bottom
        end
        if v1017 then
            v1017 = Enum.NormalId.Front
        end
        if v1018 then
            v1018 = Enum.NormalId.Left
        end
        if v1019 then
            v1019 = Enum.NormalId.Right
        end
        if v1020 then
            v1020 = Enum.NormalId.Top
        end
        return v1021(v1015, v1016, v1017, v1018, v1019, v1020)
    end
}
function v349.Faces() --[[Anonymous function at line 1713]]
    --[[
    Upvalues:
        [1] = u1022
    --]]
    return u1022
end
local u1038 = {
    ["ser"] = function(p1023, p1024) --[[Function name: ser, line 1720]]
        --[[
        Upvalues:
            [1] = u818
            [2] = u10
        --]]
        u818(Enum.KeyInterpolationMode).ser(p1023, p1024.Interpolation)
        u10(p1023, 8)
        local v1025 = p1024.Value
        local v1026 = p1023.Buf
        local v1027 = p1023.Pos
        buffer.writef32(v1026, v1027, v1025)
        p1023.Pos = p1023.Pos + 4
        local v1028 = p1024.Time
        local v1029 = p1023.Buf
        local v1030 = p1023.Pos
        buffer.writef32(v1029, v1030, v1028)
        p1023.Pos = p1023.Pos + 4
    end,
    ["des"] = function(p1031) --[[Function name: des, line 1727]]
        --[[
        Upvalues:
            [1] = u818
        --]]
        local v1032 = FloatCurveKey.new
        p1031.Pos = p1031.Pos - 4
        local v1033 = p1031.Buf
        local v1034 = p1031.Pos
        local v1035 = buffer.readf32(v1033, v1034)
        p1031.Pos = p1031.Pos - 4
        local v1036 = p1031.Buf
        local v1037 = p1031.Pos
        return v1032(v1035, buffer.readf32(v1036, v1037), (u818(Enum.KeyInterpolationMode).des(p1031)))
    end
}
function v349.FloatCurveKey() --[[Anonymous function at line 1731]]
    --[[
    Upvalues:
        [1] = u1038
    --]]
    return u1038
end
local u1056 = {
    ["ser"] = function(p1039, p1040) --[[Function name: ser, line 1738]]
        --[[
        Upvalues:
            [1] = u10
            [2] = u417
            [3] = u818
        --]]
        local v1041 = string.match(p1040.Family, "rbxasset://fonts/families/(.+).json") or error((("Invalid font family %*"):format(p1040.Family)))
        u10(p1039, #v1041 + 1)
        local v1042 = #v1041
        buffer.writestring(p1039.Buf, p1039.Pos, v1041)
        p1039.Pos = p1039.Pos + v1042
        u417(p1039, v1042)
        local v1043 = (p1040.Bold and 1 or 0) + 0 + 0 + 0 + 0 + 0 + 0 + 0
        local v1044 = p1039.Buf
        local v1045 = p1039.Pos
        buffer.writeu8(v1044, v1045, v1043)
        p1039.Pos = p1039.Pos + 1
        u818(Enum.FontWeight).ser(p1039, p1040.Weight)
        u818(Enum.FontStyle).ser(p1039, p1040.Style)
    end,
    ["des"] = function(p1046) --[[Function name: des, line 1747]]
        --[[
        Upvalues:
            [1] = u818
            [2] = u416
        --]]
        local v1047 = u818(Enum.FontStyle).des(p1046)
        local v1048 = u818(Enum.FontWeight).des(p1046)
        p1046.Pos = p1046.Pos - 1
        local v1049 = p1046.Buf
        local v1050 = p1046.Pos
        local v1051 = buffer.readu8(v1049, v1050)
        local v1052 = v1051 % 2 >= 1
        local _ = v1051 % 4 >= 2
        local _ = v1051 % 8 >= 4
        local _ = v1051 % 16 >= 8
        local _ = v1051 % 32 >= 16
        local _ = v1051 % 64 >= 32
        local _ = v1051 % 128 >= 64
        local _ = v1051 % 256 >= 128
        local v1053 = u416(p1046)
        p1046.Pos = p1046.Pos - v1053
        local v1054 = buffer.readstring(p1046.Buf, p1046.Pos, v1053)
        local v1055 = Font.new(("rbxasset://fonts/families/%*.json"):format(v1054), v1048, v1047)
        v1055.Bold = v1052
        return v1055
    end
}
function v349.Font() --[[Anonymous function at line 1757]]
    --[[
    Upvalues:
        [1] = u1056
    --]]
    return u1056
end
local u1057 = {}
function v349.NumberRange(p1058) --[[Anonymous function at line 1764]]
    --[[
    Upvalues:
        [1] = u1057
    --]]
    if u1057[p1058] then
        return u1057[p1058]
    end
    local u1059 = p1058.ser
    local u1060 = p1058.des
    local v1064 = {
        ["ser"] = function(p1061, p1062) --[[Function name: ser, line 1772]]
            --[[
            Upvalues:
                [1] = u1059
            --]]
            u1059(p1061, p1062.Max)
            u1059(p1061, p1062.Min)
        end,
        ["des"] = function(p1063) --[[Function name: des, line 1777]]
            --[[
            Upvalues:
                [1] = u1060
            --]]
            return NumberRange.new(u1060(p1063), u1060(p1063))
        end
    }
    u1057[p1058] = v1064
    return v1064
end
local u1065 = {}
function v349.NumberSequenceKeypoint(p1066) --[[Anonymous function at line 1789]]
    --[[
    Upvalues:
        [1] = u1065
        [2] = u10
    --]]
    if u1065[p1066] then
        return u1065[p1066]
    end
    local u1067 = p1066.ser
    local u1068 = p1066.des
    local v1080 = {
        ["ser"] = function(p1069, p1070) --[[Function name: ser, line 1797]]
            --[[
            Upvalues:
                [1] = u1067
                [2] = u10
            --]]
            u1067(p1069, p1070.Value)
            u1067(p1069, p1070.Envelope)
            u10(p1069, 4)
            local v1071 = p1070.Time
            local v1072 = p1069.Buf
            local v1073 = p1069.Pos
            buffer.writef32(v1072, v1073, v1071)
            p1069.Pos = p1069.Pos + 4
        end,
        ["des"] = function(p1074) --[[Function name: des, line 1804]]
            --[[
            Upvalues:
                [1] = u1068
            --]]
            p1074.Pos = p1074.Pos - 4
            local v1075 = p1074.Buf
            local v1076 = p1074.Pos
            local v1077 = buffer.readf32(v1075, v1076)
            local v1078 = u1068(p1074)
            local v1079 = u1068(p1074)
            return NumberSequenceKeypoint.new(v1077, v1079, v1078)
        end
    }
    u1065[p1066] = v1080
    return v1080
end
local u1081 = v349.NumberSequenceKeypoint
local u1082 = {}
function v349.NumberSequence(p1083) --[[Anonymous function at line 1819]]
    --[[
    Upvalues:
        [1] = u1082
        [2] = u1081
        [3] = u417
        [4] = u416
    --]]
    if u1082[p1083] then
        return u1082[p1083]
    end
    local u1084 = u1081(p1083).ser
    local u1085 = u1081(p1083).des
    local v1094 = {
        ["ser"] = function(p1086, p1087) --[[Function name: ser, line 1827]]
            --[[
            Upvalues:
                [1] = u1084
                [2] = u417
            --]]
            local v1088 = u1084
            for _, v1089 in p1087.Keypoints do
                v1088(p1086, v1089)
            end
            u417(p1086, #p1087.Keypoints)
        end,
        ["des"] = function(p1090) --[[Function name: des, line 1835]]
            --[[
            Upvalues:
                [1] = u416
                [2] = u1085
            --]]
            local v1091 = u416(p1090)
            local v1092 = table.create(v1091)
            for v1093 = v1091, 1, -1 do
                v1092[v1093] = u1085(p1090)
            end
            return NumberSequence.new(v1092)
        end
    }
    u1082[p1083] = v1094
    return v1094
end
local u1115 = {
    ["ser"] = function(p1095, p1096) --[[Function name: ser, line 1853]]
        --[[
        Upvalues:
            [1] = u10
            [2] = u417
            [3] = u818
        --]]
        u10(p1095, #p1096.CollisionGroup + 3)
        local v1097 = (p1096.BruteForceAllSlow and 1 or 0) + (p1096.RespectCanCollide and 2 or 0) + 0 + 0 + 0 + 0 + 0 + 0
        local v1098 = p1095.Buf
        local v1099 = p1095.Pos
        buffer.writeu8(v1098, v1099, v1097)
        p1095.Pos = p1095.Pos + 1
        local v1100 = p1096.MaxParts
        local v1101 = p1095.Buf
        local v1102 = p1095.Pos
        buffer.writeu16(v1101, v1102, v1100)
        p1095.Pos = p1095.Pos + 2
        local v1103 = p1096.CollisionGroup
        local v1104 = #v1103
        buffer.writestring(p1095.Buf, p1095.Pos, v1103)
        p1095.Pos = p1095.Pos + v1104
        u417(p1095, v1104)
        u818(Enum.RaycastFilterType).ser(p1095, p1096.FilterType)
    end,
    ["des"] = function(p1105) --[[Function name: des, line 1861]]
        --[[
        Upvalues:
            [1] = u818
            [2] = u416
        --]]
        local v1106 = OverlapParams.new()
        v1106.FilterType = u818(Enum.RaycastFilterType).des(p1105)
        local v1107 = u416(p1105)
        p1105.Pos = p1105.Pos - v1107
        v1106.CollisionGroup = buffer.readstring(p1105.Buf, p1105.Pos, v1107)
        p1105.Pos = p1105.Pos - 2
        local v1108 = p1105.Buf
        local v1109 = p1105.Pos
        v1106.MaxParts = buffer.readu16(v1108, v1109)
        p1105.Pos = p1105.Pos - 1
        local v1110 = p1105.Buf
        local v1111 = p1105.Pos
        local v1112 = buffer.readu8(v1110, v1111)
        local v1113 = v1112 % 2 >= 1
        local v1114 = v1112 % 4 >= 2
        local _ = v1112 % 8 >= 4
        local _ = v1112 % 16 >= 8
        local _ = v1112 % 32 >= 16
        local _ = v1112 % 64 >= 32
        local _ = v1112 % 128 >= 64
        local _ = v1112 % 256 >= 128
        v1106.BruteForceAllSlow = v1113
        v1106.RespectCanCollide = v1114
        return v1106
    end
}
function v349.OverlapParams() --[[Anonymous function at line 1870]]
    --[[
    Upvalues:
        [1] = u1115
    --]]
    return u1115
end
local u1135 = {
    ["ser"] = function(p1116, p1117) --[[Function name: ser, line 1877]]
        --[[
        Upvalues:
            [1] = u10
            [2] = u417
            [3] = u818
        --]]
        u10(p1116, #p1117.CollisionGroup + 1)
        local v1118 = p1117.BruteForceAllSlow
        local v1119 = p1117.RespectCanCollide
        local v1120 = p1117.IgnoreWater
        local v1121 = (v1118 and 1 or 0) + (v1119 and 2 or 0) + (v1120 and 4 or 0) + 0 + 0 + 0 + 0 + 0
        local v1122 = p1116.Buf
        local v1123 = p1116.Pos
        buffer.writeu8(v1122, v1123, v1121)
        p1116.Pos = p1116.Pos + 1
        local v1124 = p1117.CollisionGroup
        local v1125 = #v1124
        buffer.writestring(p1116.Buf, p1116.Pos, v1124)
        p1116.Pos = p1116.Pos + v1125
        u417(p1116, v1125)
        u818(Enum.RaycastFilterType).ser(p1116, p1117.FilterType)
    end,
    ["des"] = function(p1126) --[[Function name: des, line 1884]]
        --[[
        Upvalues:
            [1] = u818
            [2] = u416
        --]]
        local v1127 = RaycastParams.new()
        v1127.FilterType = u818(Enum.RaycastFilterType).des(p1126)
        local v1128 = u416(p1126)
        p1126.Pos = p1126.Pos - v1128
        v1127.CollisionGroup = buffer.readstring(p1126.Buf, p1126.Pos, v1128)
        p1126.Pos = p1126.Pos - 1
        local v1129 = p1126.Buf
        local v1130 = p1126.Pos
        local v1131 = buffer.readu8(v1129, v1130)
        local v1132 = v1131 % 2 >= 1
        local v1133 = v1131 % 4 >= 2
        local v1134 = v1131 % 8 >= 4
        local _ = v1131 % 16 >= 8
        local _ = v1131 % 32 >= 16
        local _ = v1131 % 64 >= 32
        local _ = v1131 % 128 >= 64
        local _ = v1131 % 256 >= 128
        v1127.BruteForceAllSlow = v1132
        v1127.RespectCanCollide = v1133
        v1127.IgnoreWater = v1134
        return v1127
    end
}
function v349.RaycastParams() --[[Anonymous function at line 1892]]
    --[[
    Upvalues:
        [1] = u1135
    --]]
    return u1135
end
local u1136 = {}
function v349.Vector3(p1137) --[[Anonymous function at line 1899]]
    --[[
    Upvalues:
        [1] = u1136
    --]]
    if u1136[p1137] then
        return u1136[p1137]
    end
    local u1138 = p1137.ser
    local u1139 = p1137.des
    local v1146 = {
        ["ser"] = function(p1140, p1141) --[[Function name: ser, line 1907]]
            --[[
            Upvalues:
                [1] = u1138
            --]]
            u1138(p1140, p1141.Z)
            u1138(p1140, p1141.Y)
            u1138(p1140, p1141.X)
        end,
        ["des"] = function(p1142) --[[Function name: des, line 1913]]
            --[[
            Upvalues:
                [1] = u1139
            --]]
            local v1143 = u1139(p1142)
            local v1144 = u1139(p1142)
            local v1145 = u1139
            return Vector3.new(v1143, v1144, v1145(p1142))
        end
    }
    u1136[p1137] = v1146
    return v1146
end
local u1147 = {}
function v349.PathWaypoint(p1148) --[[Anonymous function at line 1925]]
    --[[
    Upvalues:
        [1] = u1147
        [2] = u10
        [3] = u417
        [4] = u818
        [5] = u324
    --]]
    if u1147[p1148] then
        return u1147[p1148]
    end
    local u1149 = p1148.ser
    local u1150 = p1148.des
    local v1160 = {
        ["ser"] = function(p1151, p1152) --[[Function name: ser, line 1933]]
            --[[
            Upvalues:
                [1] = u10
                [2] = u417
                [3] = u818
                [4] = u1149
            --]]
            u10(p1151, #p1152.Label)
            local v1153 = p1152.Label
            local v1154 = #v1153
            buffer.writestring(p1151.Buf, p1151.Pos, v1153)
            p1151.Pos = p1151.Pos + v1154
            u417(p1151, v1154)
            u818(Enum.PathWaypointAction).ser(p1151, p1152.Action)
            u1149(p1151, p1152.Position.Z)
            u1149(p1151, p1152.Position.Y)
            u1149(p1151, p1152.Position.X)
        end,
        ["des"] = function(p1155) --[[Function name: des, line 1942]]
            --[[
            Upvalues:
                [1] = u1150
                [2] = u818
                [3] = u324
            --]]
            local v1156 = PathWaypoint.new
            local v1157 = u1150(p1155)
            local v1158 = u1150(p1155)
            local v1159 = u1150
            return v1156(Vector3.new(v1157, v1158, v1159(p1155)), u818(Enum.PathWaypointAction).des(p1155), u324(p1155))
        end
    }
    u1147[p1148] = v1160
    return v1160
end
local u1194 = {
    ["ser"] = function(p1161, p1162) --[[Function name: ser, line 1957]]
        --[[
        Upvalues:
            [1] = u10
        --]]
        u10(p1161, 20)
        local v1163 = p1162.ElasticityWeight
        local v1164 = p1161.Buf
        local v1165 = p1161.Pos
        buffer.writef32(v1164, v1165, v1163)
        p1161.Pos = p1161.Pos + 4
        local v1166 = p1162.FrictionWeight
        local v1167 = p1161.Buf
        local v1168 = p1161.Pos
        buffer.writef32(v1167, v1168, v1166)
        p1161.Pos = p1161.Pos + 4
        local v1169 = p1162.Elasticity
        local v1170 = p1161.Buf
        local v1171 = p1161.Pos
        buffer.writef32(v1170, v1171, v1169)
        p1161.Pos = p1161.Pos + 4
        local v1172 = p1162.Friction
        local v1173 = p1161.Buf
        local v1174 = p1161.Pos
        buffer.writef32(v1173, v1174, v1172)
        p1161.Pos = p1161.Pos + 4
        local v1175 = p1162.Density
        local v1176 = p1161.Buf
        local v1177 = p1161.Pos
        buffer.writef32(v1176, v1177, v1175)
        p1161.Pos = p1161.Pos + 4
    end,
    ["des"] = function(p1178) --[[Function name: des, line 1966]]
        local v1179 = PhysicalProperties.new
        p1178.Pos = p1178.Pos - 4
        local v1180 = p1178.Buf
        local v1181 = p1178.Pos
        local v1182 = buffer.readf32(v1180, v1181)
        p1178.Pos = p1178.Pos - 4
        local v1183 = p1178.Buf
        local v1184 = p1178.Pos
        local v1185 = buffer.readf32(v1183, v1184)
        p1178.Pos = p1178.Pos - 4
        local v1186 = p1178.Buf
        local v1187 = p1178.Pos
        local v1188 = buffer.readf32(v1186, v1187)
        p1178.Pos = p1178.Pos - 4
        local v1189 = p1178.Buf
        local v1190 = p1178.Pos
        local v1191 = buffer.readf32(v1189, v1190)
        p1178.Pos = p1178.Pos - 4
        local v1192 = p1178.Buf
        local v1193 = p1178.Pos
        return v1179(v1182, v1185, v1188, v1191, (buffer.readf32(v1192, v1193)))
    end
}
function v349.PhysicalProperties() --[[Anonymous function at line 1970]]
    --[[
    Upvalues:
        [1] = u1194
    --]]
    return u1194
end
local u1195 = {}
function v349.Ray(p1196) --[[Anonymous function at line 1977]]
    --[[
    Upvalues:
        [1] = u1195
    --]]
    if u1195[p1196] then
        return u1195[p1196]
    end
    local u1197 = p1196.ser
    local u1198 = p1196.des
    local v1210 = {
        ["ser"] = function(p1199, p1200) --[[Function name: ser, line 1985]]
            --[[
            Upvalues:
                [1] = u1197
            --]]
            u1197(p1199, p1200.Direction.Z)
            u1197(p1199, p1200.Direction.Y)
            u1197(p1199, p1200.Direction.X)
            u1197(p1199, p1200.Origin.Z)
            u1197(p1199, p1200.Origin.Y)
            u1197(p1199, p1200.Origin.X)
        end,
        ["des"] = function(p1201) --[[Function name: des, line 1994]]
            --[[
            Upvalues:
                [1] = u1198
            --]]
            local v1202 = Ray.new
            local v1203 = u1198(p1201)
            local v1204 = u1198(p1201)
            local v1205 = u1198
            local v1206 = Vector3.new(v1203, v1204, v1205(p1201))
            local v1207 = u1198(p1201)
            local v1208 = u1198(p1201)
            local v1209 = u1198
            return v1202(v1206, (Vector3.new(v1207, v1208, v1209(p1201))))
        end
    }
    u1195[p1196] = v1210
    return v1210
end
local u1211 = {}
function v349.RaycastResult(p1212) --[[Anonymous function at line 2012]]
    --[[
    Upvalues:
        [1] = u1211
        [2] = u10
        [3] = u818
    --]]
    if u1211[p1212] then
        return u1211[p1212]
    end
    local u1213 = p1212.ser
    local u1214 = p1212.des
    local v1230 = {
        ["ser"] = function(p1215, p1216) --[[Function name: ser, line 2020]]
            --[[
            Upvalues:
                [1] = u10
                [2] = u1213
                [3] = u818
            --]]
            u10(p1215, 4)
            local v1217 = p1216.Distance
            local v1218 = p1215.Buf
            local v1219 = p1215.Pos
            buffer.writef32(v1218, v1219, v1217)
            p1215.Pos = p1215.Pos + 4
            u1213(p1215, p1216.Position.Z)
            u1213(p1215, p1216.Position.Y)
            u1213(p1215, p1216.Position.X)
            u1213(p1215, p1216.Normal.Z)
            u1213(p1215, p1216.Normal.Y)
            u1213(p1215, p1216.Normal.X)
            u818(Enum.Material).ser(p1215, p1216.Material)
        end,
        ["des"] = function(p1220) --[[Function name: des, line 2032]]
            --[[
            Upvalues:
                [1] = u818
                [2] = u1214
            --]]
            local v1221 = {
                ["Material"] = u818(Enum.Material).des(p1220)
            }
            local v1222 = u1214(p1220)
            local v1223 = u1214(p1220)
            local v1224 = u1214
            v1221.Normal = Vector3.new(v1222, v1223, v1224(p1220))
            local v1225 = u1214(p1220)
            local v1226 = u1214(p1220)
            local v1227 = u1214
            v1221.Position = Vector3.new(v1225, v1226, v1227(p1220))
            p1220.Pos = p1220.Pos - 4
            local v1228 = p1220.Buf
            local v1229 = p1220.Pos
            v1221.Distance = buffer.readf32(v1228, v1229)
            v1221.Instance = nil
            return v1221
        end
    }
    u1211[p1212] = v1230
    return v1230
end
local u1231 = {}
function v349.Vector2(p1232) --[[Anonymous function at line 2050]]
    --[[
    Upvalues:
        [1] = u1231
    --]]
    if u1231[p1232] then
        return u1231[p1232]
    end
    local u1233 = p1232.ser
    local u1234 = p1232.des
    local v1238 = {
        ["ser"] = function(p1235, p1236) --[[Function name: ser, line 2058]]
            --[[
            Upvalues:
                [1] = u1233
            --]]
            u1233(p1235, p1236.Y)
            u1233(p1235, p1236.X)
        end,
        ["des"] = function(p1237) --[[Function name: des, line 2063]]
            --[[
            Upvalues:
                [1] = u1234
            --]]
            return Vector2.new(u1234(p1237), u1234(p1237))
        end
    }
    u1231[p1232] = v1238
    return v1238
end
local u1239 = {}
function v349.Rect(p1240) --[[Anonymous function at line 2075]]
    --[[
    Upvalues:
        [1] = u1239
    --]]
    if u1239[p1240] then
        return u1239[p1240]
    end
    local u1241 = p1240.ser
    local u1242 = p1240.des
    local v1246 = {
        ["ser"] = function(p1243, p1244) --[[Function name: ser, line 2083]]
            --[[
            Upvalues:
                [1] = u1241
            --]]
            u1241(p1243, p1244.Max.Y)
            u1241(p1243, p1244.Max.X)
            u1241(p1243, p1244.Min.Y)
            u1241(p1243, p1244.Min.X)
        end,
        ["des"] = function(p1245) --[[Function name: des, line 2090]]
            --[[
            Upvalues:
                [1] = u1242
            --]]
            return Rect.new(u1242(p1245), u1242(p1245), u1242(p1245), u1242(p1245))
        end
    }
    u1239[p1240] = v1246
    return v1246
end
local u1247 = {}
function v349.Region3(p1248) --[[Anonymous function at line 2101]]
    --[[
    Upvalues:
        [1] = u1247
    --]]
    if u1247[p1248] then
        return u1247[p1248]
    end
    local u1249 = p1248.ser
    local u1250 = p1248.des
    local v1264 = {
        ["ser"] = function(p1251, p1252) --[[Function name: ser, line 2109]]
            --[[
            Upvalues:
                [1] = u1249
            --]]
            local v1253 = p1252.Size
            u1249(p1251, v1253.Z)
            u1249(p1251, v1253.Y)
            u1249(p1251, v1253.X)
            local v1254 = p1252.CFrame.Position
            u1249(p1251, v1254.Z)
            u1249(p1251, v1254.Y)
            u1249(p1251, v1254.X)
        end,
        ["des"] = function(p1255) --[[Function name: des, line 2120]]
            --[[
            Upvalues:
                [1] = u1250
            --]]
            local v1256 = u1250(p1255)
            local v1257 = u1250(p1255)
            local v1258 = u1250
            local v1259 = Vector3.new(v1256, v1257, v1258(p1255))
            local v1260 = u1250(p1255)
            local v1261 = u1250(p1255)
            local v1262 = u1250
            local v1263 = 0.5 * Vector3.new(v1260, v1261, v1262(p1255))
            return Region3.new(v1259 - v1263, v1259 + v1263)
        end
    }
    u1247[p1248] = v1264
    return v1264
end
local u1308 = {
    ["ser"] = function(p1265, p1266) --[[Function name: ser, line 2133]]
        --[[
        Upvalues:
            [1] = u10
        --]]
        u10(p1265, 12)
        local v1267 = p1266.Max
        local v1268 = v1267.Z
        local v1269 = p1265.Buf
        local v1270 = p1265.Pos
        buffer.writei16(v1269, v1270, v1268)
        p1265.Pos = p1265.Pos + 2
        local v1271 = v1267.Y
        local v1272 = p1265.Buf
        local v1273 = p1265.Pos
        buffer.writei16(v1272, v1273, v1271)
        p1265.Pos = p1265.Pos + 2
        local v1274 = v1267.X
        local v1275 = p1265.Buf
        local v1276 = p1265.Pos
        buffer.writei16(v1275, v1276, v1274)
        p1265.Pos = p1265.Pos + 2
        local v1277 = p1266.Min
        local v1278 = v1277.Z
        local v1279 = p1265.Buf
        local v1280 = p1265.Pos
        buffer.writei16(v1279, v1280, v1278)
        p1265.Pos = p1265.Pos + 2
        local v1281 = v1277.Y
        local v1282 = p1265.Buf
        local v1283 = p1265.Pos
        buffer.writei16(v1282, v1283, v1281)
        p1265.Pos = p1265.Pos + 2
        local v1284 = v1277.X
        local v1285 = p1265.Buf
        local v1286 = p1265.Pos
        buffer.writei16(v1285, v1286, v1284)
        p1265.Pos = p1265.Pos + 2
    end,
    ["des"] = function(p1287) --[[Function name: des, line 2145]]
        local v1288 = Vector3int16.new
        p1287.Pos = p1287.Pos - 2
        local v1289 = p1287.Buf
        local v1290 = p1287.Pos
        local v1291 = buffer.readi16(v1289, v1290)
        p1287.Pos = p1287.Pos - 2
        local v1292 = p1287.Buf
        local v1293 = p1287.Pos
        local v1294 = buffer.readi16(v1292, v1293)
        p1287.Pos = p1287.Pos - 2
        local v1295 = p1287.Buf
        local v1296 = p1287.Pos
        local v1297 = v1288(v1291, v1294, (buffer.readi16(v1295, v1296)))
        local v1298 = Vector3int16.new
        p1287.Pos = p1287.Pos - 2
        local v1299 = p1287.Buf
        local v1300 = p1287.Pos
        local v1301 = buffer.readi16(v1299, v1300)
        p1287.Pos = p1287.Pos - 2
        local v1302 = p1287.Buf
        local v1303 = p1287.Pos
        local v1304 = buffer.readi16(v1302, v1303)
        p1287.Pos = p1287.Pos - 2
        local v1305 = p1287.Buf
        local v1306 = p1287.Pos
        local v1307 = v1298(v1301, v1304, (buffer.readi16(v1305, v1306)))
        return Region3int16.new(v1297, v1307)
    end
}
function v349.Region3int16() --[[Anonymous function at line 2151]]
    --[[
    Upvalues:
        [1] = u1308
    --]]
    return u1308
end
local u1309 = {}
function v349.RotationCurveKey(p1310) --[[Anonymous function at line 2158]]
    --[[
    Upvalues:
        [1] = u1309
        [2] = u916
        [3] = u818
        [4] = u10
    --]]
    if u1309[p1310] then
        return u1309[p1310]
    end
    local u1311 = u916(p1310).ser
    local u1312 = u916(p1310).des
    local v1322 = {
        ["ser"] = function(p1313, p1314) --[[Function name: ser, line 2166]]
            --[[
            Upvalues:
                [1] = u818
                [2] = u1311
                [3] = u10
            --]]
            u818(Enum.KeyInterpolationMode).ser(p1313, p1314.Interpolation)
            u1311(p1313, p1314.Value)
            u10(p1313, 4)
            local v1315 = p1314.Time
            local v1316 = p1313.Buf
            local v1317 = p1313.Pos
            buffer.writef32(v1316, v1317, v1315)
            p1313.Pos = p1313.Pos + 4
        end,
        ["des"] = function(p1318) --[[Function name: des, line 2173]]
            --[[
            Upvalues:
                [1] = u1312
                [2] = u818
            --]]
            local v1319 = RotationCurveKey.new
            p1318.Pos = p1318.Pos - 4
            local v1320 = p1318.Buf
            local v1321 = p1318.Pos
            return v1319(buffer.readf32(v1320, v1321), u1312(p1318), (u818(Enum.KeyInterpolationMode).des(p1318)))
        end
    }
    u1309[p1310] = v1322
    return v1322
end
local u1348 = {
    ["ser"] = function(p1323, p1324) --[[Function name: ser, line 2188]]
        --[[
        Upvalues:
            [1] = u10
            [2] = u417
            [3] = u818
        --]]
        u10(p1323, 9)
        local v1325 = p1324.DelayTime
        local v1326 = p1323.Buf
        local v1327 = p1323.Pos
        buffer.writef32(v1326, v1327, v1325)
        p1323.Pos = p1323.Pos + 4
        local v1328 = p1324.Time
        local v1329 = p1323.Buf
        local v1330 = p1323.Pos
        buffer.writef32(v1329, v1330, v1328)
        p1323.Pos = p1323.Pos + 4
        local v1331 = (p1324.Reverses and 1 or 0) + 0 + 0 + 0 + 0 + 0 + 0 + 0
        local v1332 = p1323.Buf
        local v1333 = p1323.Pos
        buffer.writeu8(v1332, v1333, v1331)
        p1323.Pos = p1323.Pos + 1
        u417(p1323, p1324.RepeatCount)
        u818(Enum.EasingDirection).ser(p1323, p1324.EasingDirection)
        u818(Enum.EasingStyle).ser(p1323, p1324.EasingStyle)
    end,
    ["des"] = function(p1334) --[[Function name: des, line 2198]]
        --[[
        Upvalues:
            [1] = u818
            [2] = u416
        --]]
        local v1335 = u818(Enum.EasingStyle).des(p1334)
        local v1336 = u818(Enum.EasingDirection).des(p1334)
        local v1337 = u416(p1334)
        p1334.Pos = p1334.Pos - 1
        local v1338 = p1334.Buf
        local v1339 = p1334.Pos
        local v1340 = buffer.readu8(v1338, v1339)
        local v1341 = v1340 % 2 >= 1
        local _ = v1340 % 4 >= 2
        local _ = v1340 % 8 >= 4
        local _ = v1340 % 16 >= 8
        local _ = v1340 % 32 >= 16
        local _ = v1340 % 64 >= 32
        local _ = v1340 % 128 >= 64
        local _ = v1340 % 256 >= 128
        p1334.Pos = p1334.Pos - 4
        local v1342 = p1334.Buf
        local v1343 = p1334.Pos
        local v1344 = buffer.readf32(v1342, v1343)
        p1334.Pos = p1334.Pos - 4
        local v1345 = p1334.Buf
        local v1346 = p1334.Pos
        local v1347 = buffer.readf32(v1345, v1346)
        return TweenInfo.new(v1344, v1335, v1336, v1337, v1341, v1347)
    end
}
function v349.TweenInfo() --[[Anonymous function at line 2208]]
    --[[
    Upvalues:
        [1] = u1348
    --]]
    return u1348
end
local u1349 = {}
function v349.UDim(p1350) --[[Anonymous function at line 2215]]
    --[[
    Upvalues:
        [1] = u1349
    --]]
    if u1349[p1350] then
        return u1349[p1350]
    end
    local u1351 = p1350.ser
    local u1352 = p1350.des
    local v1356 = {
        ["ser"] = function(p1353, p1354) --[[Function name: ser, line 2223]]
            --[[
            Upvalues:
                [1] = u1351
            --]]
            u1351(p1353, p1354.Offset)
            u1351(p1353, p1354.Scale)
        end,
        ["des"] = function(p1355) --[[Function name: des, line 2228]]
            --[[
            Upvalues:
                [1] = u1352
            --]]
            return UDim.new(u1352(p1355), u1352(p1355))
        end
    }
    u1349[p1350] = v1356
    return v1356
end
local u1357 = {}
function v349.UDim2(p1358) --[[Anonymous function at line 2240]]
    --[[
    Upvalues:
        [1] = u1357
    --]]
    if u1357[p1358] then
        return u1357[p1358]
    end
    local u1359 = p1358.ser
    local u1360 = p1358.des
    local v1364 = {
        ["ser"] = function(p1361, p1362) --[[Function name: ser, line 2248]]
            --[[
            Upvalues:
                [1] = u1359
            --]]
            u1359(p1361, p1362.Y.Offset)
            u1359(p1361, p1362.Y.Scale)
            u1359(p1361, p1362.X.Offset)
            u1359(p1361, p1362.X.Scale)
        end,
        ["des"] = function(p1363) --[[Function name: des, line 2255]]
            --[[
            Upvalues:
                [1] = u1360
            --]]
            return UDim2.new(u1360(p1363), u1360(p1363), u1360(p1363), u1360(p1363))
        end
    }
    u1357[p1358] = v1364
    return v1364
end
local u1380 = {
    ["ser"] = function(p1365, p1366) --[[Function name: ser, line 2267]]
        --[[
        Upvalues:
            [1] = u10
        --]]
        u10(p1365, 4)
        local v1367 = p1366.Y
        local v1368 = p1365.Buf
        local v1369 = p1365.Pos
        buffer.writei16(v1368, v1369, v1367)
        p1365.Pos = p1365.Pos + 2
        local v1370 = p1366.X
        local v1371 = p1365.Buf
        local v1372 = p1365.Pos
        buffer.writei16(v1371, v1372, v1370)
        p1365.Pos = p1365.Pos + 2
    end,
    ["des"] = function(p1373) --[[Function name: des, line 2273]]
        local v1374 = Vector2int16.new
        p1373.Pos = p1373.Pos - 2
        local v1375 = p1373.Buf
        local v1376 = p1373.Pos
        local v1377 = buffer.readi16(v1375, v1376)
        p1373.Pos = p1373.Pos - 2
        local v1378 = p1373.Buf
        local v1379 = p1373.Pos
        return v1374(v1377, (buffer.readi16(v1378, v1379)))
    end
}
function v349.Vector2int16() --[[Anonymous function at line 2277]]
    --[[
    Upvalues:
        [1] = u1380
    --]]
    return u1380
end
local u1402 = {
    ["ser"] = function(p1381, p1382) --[[Function name: ser, line 2284]]
        --[[
        Upvalues:
            [1] = u10
        --]]
        u10(p1381, 6)
        local v1383 = p1382.Z
        local v1384 = p1381.Buf
        local v1385 = p1381.Pos
        buffer.writei16(v1384, v1385, v1383)
        p1381.Pos = p1381.Pos + 2
        local v1386 = p1382.Y
        local v1387 = p1381.Buf
        local v1388 = p1381.Pos
        buffer.writei16(v1387, v1388, v1386)
        p1381.Pos = p1381.Pos + 2
        local v1389 = p1382.X
        local v1390 = p1381.Buf
        local v1391 = p1381.Pos
        buffer.writei16(v1390, v1391, v1389)
        p1381.Pos = p1381.Pos + 2
    end,
    ["des"] = function(p1392) --[[Function name: des, line 2291]]
        local v1393 = Vector3int16.new
        p1392.Pos = p1392.Pos - 2
        local v1394 = p1392.Buf
        local v1395 = p1392.Pos
        local v1396 = buffer.readi16(v1394, v1395)
        p1392.Pos = p1392.Pos - 2
        local v1397 = p1392.Buf
        local v1398 = p1392.Pos
        local v1399 = buffer.readi16(v1397, v1398)
        p1392.Pos = p1392.Pos - 2
        local v1400 = p1392.Buf
        local v1401 = p1392.Pos
        return v1393(v1396, v1399, (buffer.readi16(v1400, v1401)))
    end
}
function v349.Vector3int16() --[[Anonymous function at line 2295]]
    --[[
    Upvalues:
        [1] = u1402
    --]]
    return u1402
end
return v349