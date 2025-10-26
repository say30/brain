--[[
  Extracted from: ReplicatedStorage.Packages.Moonlite.Specials
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local v1 = script.Parent
local u2 = game:GetService("RunService")
require(v1.Types)
local u3 = {}
local u4 = {
    ["Camera"] = {
        ["AttachToPart"] = true,
        ["LookAtPart"] = true
    },
    ["Humanoid"] = {
        ["AddAccessory"] = true,
        ["ChangeState"] = true,
        ["EquipTool"] = true,
        ["MoveTo"] = true,
        ["Move"] = true,
        ["PlayEmote"] = true,
        ["RemoveAccessories"] = true,
        ["TakeDamage"] = true,
        ["UnequipTools"] = true
    },
    ["ParticleEmitter"] = {
        ["Emit"] = true,
        ["Clear"] = true
    },
    ["Sound"] = {
        ["PlayOnce"] = true,
        ["SetTime"] = true,
        ["Play"] = true,
        ["Resume"] = true,
        ["Pause"] = true,
        ["Stop"] = true
    }
}
local function u14(u5, u6, p7) --[[Anonymous function at line 114]]
    --[[
    Upvalues:
        [1] = u2
    --]]
    if p7 and not u5._cameraRenderBound then
        u2:BindToRenderStep("MoonliteRenderCamera", 1000, function() --[[Function name: updateCamera, line 116]]
            --[[
            Upvalues:
                [1] = u5
                [2] = u6
            --]]
            local v8 = u5._cameraAttachToPart
            local v9 = u5._cameraLookAtPart
            if v8 then
                local v10 = v8.CFrame
                if v9 then
                    v10 = CFrame.new(v10.Position, v9.Position)
                end
                u6.CFrame = v10
            end
        end)
        u5._cameraRenderBound = true
        local v11 = u5._cameraAttachToPart
        local v12 = u5._cameraLookAtPart
        if v11 then
            local v13 = v11.CFrame
            if v12 then
                v13 = CFrame.new(v13.Position, v12.Position)
            end
            u6.CFrame = v13
        end
        if not u5.KeepCameraType then
            u6.CameraType = Enum.CameraType.Scriptable
            return
        end
    elseif not p7 and u5._cameraRenderBound then
        u2:UnbindFromRenderStep("MoonliteRenderCamera")
        if not u5.KeepCameraType then
            u6.CameraType = Enum.CameraType.Custom
        end
        u5._cameraRenderBound = false
    end
end
local v15 = {}
local u20 = {
    ["Get"] = function(_, p16) --[[Function name: Get, line 151]]
        return p16._cameraAttachToPart
    end,
    ["Set"] = function(p17, p18, p19) --[[Function name: Set, line 155]]
        --[[
        Upvalues:
            [1] = u14
        --]]
        if p17 then
            p19._activeCamera = p18
            p19._cameraAttachToPart = p17
            u14(p19, p18, true)
        else
            p19._cameraAttachToPart = nil
            u14(p19, p18, false)
        end
    end
}
function v15.AttachToPart(u21, u22) --[[Anonymous function at line 79]]
    --[[
    Upvalues:
        [1] = u20
    --]]
    local v23 = u20.Get
    assert(v23)
    return {
        ["Get"] = function() --[[Function name: Get, line 83]]
            --[[
            Upvalues:
                [1] = u20
                [2] = u21
                [3] = u22
            --]]
            return u20.Get(u21, u22)
        end,
        ["Set"] = function(p24) --[[Function name: Set, line 87]]
            --[[
            Upvalues:
                [1] = u20
                [2] = u21
                [3] = u22
            --]]
            u20.Set(p24, u21, u22)
        end
    }
end
local u29 = {
    ["Get"] = function(_, p25) --[[Function name: Get, line 168]]
        return p25._cameraLookAtPart
    end,
    ["Set"] = function(p26, p27, p28) --[[Function name: Set, line 172]]
        --[[
        Upvalues:
            [1] = u14
        --]]
        if p26 then
            p28._activeCamera = p27
            p28._cameraLookAtPart = p26
            u14(p28, p27, true)
            if p28._updateCamera then
                p28._updateCamera()
                return
            end
        else
            p28._cameraLookAtPart = nil
            if not p28._cameraAttachToPart then
                u14(p28, p27, false)
            end
        end
    end
}
function v15.LookAtPart(u30, u31) --[[Anonymous function at line 79]]
    --[[
    Upvalues:
        [1] = u29
    --]]
    local v32 = u29.Get
    assert(v32)
    return {
        ["Get"] = function() --[[Function name: Get, line 83]]
            --[[
            Upvalues:
                [1] = u29
                [2] = u30
                [3] = u31
            --]]
            return u29.Get(u30, u31)
        end,
        ["Set"] = function(p33) --[[Function name: Set, line 87]]
            --[[
            Upvalues:
                [1] = u29
                [2] = u30
                [3] = u31
            --]]
            u29.Set(p33, u30, u31)
        end
    }
end
u3.Camera = v15
u3.Terrain = {}
for _, u34 in Enum.Material:GetEnumItems() do
    if pcall(function() --[[Anonymous function at line 199]]
        --[[
        Upvalues:
            [1] = u34
        --]]
        workspace.Terrain:GetMaterialColor(u34)
    end) then
        local u38 = {
            ["Get"] = function(p35) --[[Function name: Get, line 205]]
                --[[
                Upvalues:
                    [1] = u34
                --]]
                return p35:GetMaterialColor(u34)
            end,
            ["Set"] = function(p36, p37) --[[Function name: Set, line 209]]
                --[[
                Upvalues:
                    [1] = u34
                --]]
                p37:SetMaterialColor(u34, p36)
            end
        }
        u3.Terrain[("MC_%*"):format(u34.Name)] = function(u39, u40) --[[Anonymous function at line 79]]
            --[[
            Upvalues:
                [1] = u38
            --]]
            local v41 = u38.Get
            assert(v41)
            return {
                ["Get"] = function() --[[Function name: Get, line 83]]
                    --[[
                    Upvalues:
                        [1] = u38
                        [2] = u39
                        [3] = u40
                    --]]
                    return u38.Get(u39, u40)
                end,
                ["Set"] = function(p42) --[[Function name: Set, line 87]]
                    --[[
                    Upvalues:
                        [1] = u38
                        [2] = u39
                        [3] = u40
                    --]]
                    u38.Set(p42, u39, u40)
                end
            }
        end
    end
end
local u43 = Color3.new(1, 1, 1)
local v44 = {}
local u48 = {
    ["Get"] = function(p45) --[[Function name: Get, line 224]]
        return p45:GetPivot()
    end,
    ["Set"] = function(p46, p47) --[[Function name: Set, line 228]]
        p47:PivotTo(p46)
    end
}
function v44.CFrame(u49, u50) --[[Anonymous function at line 79]]
    --[[
    Upvalues:
        [1] = u48
    --]]
    local v51 = u48.Get
    assert(v51)
    return {
        ["Get"] = function() --[[Function name: Get, line 83]]
            --[[
            Upvalues:
                [1] = u48
                [2] = u49
                [3] = u50
            --]]
            return u48.Get(u49, u50)
        end,
        ["Set"] = function(p52) --[[Function name: Set, line 87]]
            --[[
            Upvalues:
                [1] = u48
                [2] = u49
                [3] = u50
            --]]
            u48.Set(p52, u49, u50)
        end
    }
end
local u64 = {
    ["Get"] = function(p53) --[[Function name: Get, line 234]]
        --[[
        Upvalues:
            [1] = u43
        --]]
        local v54 = u43
        return p53:GetAttribute((("__moonlite_%*"):format("Color"))) or v54
    end,
    ["Set"] = function(p55, p56) --[[Function name: Set, line 238]]
        --[[
        Upvalues:
            [1] = u43
        --]]
        for _, v57 in p56:GetDescendants() do
            if v57:IsA("BasePart") then
                local v58 = v57.Color
                local v59 = v57:GetAttribute((("__moonlite_%*"):format("Color"))) or v58
                if v59 ~= p55 then
                    local v60 = ("__moonlite_%*"):format("Color")
                    local v61
                    if p55 == v59 then
                        v61 = nil
                    else
                        v61 = p55
                    end
                    v57:SetAttribute(v60, v61)
                    v57.Color = p55
                end
            end
        end
        local v62 = u43
        local v63 = ("__moonlite_%*"):format("Color")
        if p55 == v62 then
            p55 = nil
        end
        p56:SetAttribute(v63, p55)
    end
}
function v44.Color(u65, u66) --[[Anonymous function at line 79]]
    --[[
    Upvalues:
        [1] = u64
    --]]
    local v67 = u64.Get
    assert(v67)
    return {
        ["Get"] = function() --[[Function name: Get, line 83]]
            --[[
            Upvalues:
                [1] = u64
                [2] = u65
                [3] = u66
            --]]
            return u64.Get(u65, u66)
        end,
        ["Set"] = function(p68) --[[Function name: Set, line 87]]
            --[[
            Upvalues:
                [1] = u64
                [2] = u65
                [3] = u66
            --]]
            u64.Set(p68, u65, u66)
        end
    }
end
local u72 = {
    ["Get"] = function(p69) --[[Function name: Get, line 255]]
        return p69:GetScale()
    end,
    ["Set"] = function(p70, p71) --[[Function name: Set, line 259]]
        p71:ScaleTo(p70)
    end
}
function v44.Scale(u73, u74) --[[Anonymous function at line 79]]
    --[[
    Upvalues:
        [1] = u72
    --]]
    local v75 = u72.Get
    assert(v75)
    return {
        ["Get"] = function() --[[Function name: Get, line 83]]
            --[[
            Upvalues:
                [1] = u72
                [2] = u73
                [3] = u74
            --]]
            return u72.Get(u73, u74)
        end,
        ["Set"] = function(p76) --[[Function name: Set, line 87]]
            --[[
            Upvalues:
                [1] = u72
                [2] = u73
                [3] = u74
            --]]
            u72.Set(p76, u73, u74)
        end
    }
end
local u84 = {
    ["Get"] = function(p77) --[[Function name: Get, line 265]]
        return p77:GetAttribute((("__moonlite_%*"):format("Reflectance"))) or 0
    end,
    ["Set"] = function(p78, p79) --[[Function name: Set, line 269]]
        if (p79:GetAttribute((("__moonlite_%*"):format("Reflectance"))) or 0) ~= p78 then
            for _, v80 in p79:GetDescendants() do
                if v80:IsA("BasePart") then
                    local v81 = v80.Reflectance
                    local v82 = v80:GetAttribute((("__moonlite_%*"):format("BaseReflectance"))) or v81
                    v80.Reflectance = v82 + (1 - v82) * p78
                end
            end
            local v83 = ("__moonlite_%*"):format("Reflectance")
            if p78 == 0 then
                p78 = nil
            end
            p79:SetAttribute(v83, p78)
        end
    end
}
function v44.Reflectance(u85, u86) --[[Anonymous function at line 79]]
    --[[
    Upvalues:
        [1] = u84
    --]]
    local v87 = u84.Get
    assert(v87)
    return {
        ["Get"] = function() --[[Function name: Get, line 83]]
            --[[
            Upvalues:
                [1] = u84
                [2] = u85
                [3] = u86
            --]]
            return u84.Get(u85, u86)
        end,
        ["Set"] = function(p88) --[[Function name: Set, line 87]]
            --[[
            Upvalues:
                [1] = u84
                [2] = u85
                [3] = u86
            --]]
            u84.Set(p88, u85, u86)
        end
    }
end
local u94 = {
    ["Get"] = function(p89) --[[Function name: Get, line 287]]
        return p89:GetAttribute((("__moonlite_%*"):format("Transparency"))) or 0
    end,
    ["Set"] = function(p90, p91) --[[Function name: Set, line 291]]
        if (p91:GetAttribute((("__moonlite_%*"):format("Transparency"))) or 0) ~= p90 then
            for _, v92 in p91:GetDescendants() do
                if v92:IsA("BasePart") then
                    v92.LocalTransparencyModifier = p90
                end
            end
            local v93 = ("__moonlite_%*"):format("Transparency")
            if p90 == 0 then
                p90 = nil
            end
            p91:SetAttribute(v93, p90)
        end
    end
}
function v44.Transparency(u95, u96) --[[Anonymous function at line 79]]
    --[[
    Upvalues:
        [1] = u94
    --]]
    local v97 = u94.Get
    assert(v97)
    return {
        ["Get"] = function() --[[Function name: Get, line 83]]
            --[[
            Upvalues:
                [1] = u94
                [2] = u95
                [3] = u96
            --]]
            return u94.Get(u95, u96)
        end,
        ["Set"] = function(p98) --[[Function name: Set, line 87]]
            --[[
            Upvalues:
                [1] = u94
                [2] = u95
                [3] = u96
            --]]
            u94.Set(p98, u95, u96)
        end
    }
end
u3.Model = v44
local v105 = {
    ["AddAccessory"] = function(u99) --[[Function name: AddAccessory, line 313]]
        return {
            ["Default"] = nil,
            ["Set"] = function(p100) --[[Function name: Set, line 319]]
                --[[
                Upvalues:
                    [1] = u99
                --]]
                if p100 then
                    pcall(u99.AddAccessory, u99, p100)
                end
            end
        }
    end,
    ["ChangeState"] = function(u101) --[[Function name: ChangeState, line 327]]
        return {
            ["Default"] = Enum.HumanoidStateType.None,
            ["Set"] = function(p102) --[[Function name: Set, line 331]]
                --[[
                Upvalues:
                    [1] = u101
                --]]
                u101:ChangeState(p102)
            end
        }
    end,
    ["EquipTool"] = function(u103) --[[Function name: EquipTool, line 337]]
        return {
            ["Default"] = nil,
            ["Set"] = function(p104) --[[Function name: Set, line 343]]
                --[[
                Upvalues:
                    [1] = u103
                --]]
                if p104 then
                    pcall(u103.EquipTool, u103, p104)
                end
            end
        }
    end
}
local function u107(p106) --[[Anonymous function at line 351]]
    p106.Jump = true
end
function v105.Jump(u108) --[[Anonymous function at line 95]]
    --[[
    Upvalues:
        [1] = u107
    --]]
    return {
        ["Default"] = false,
        ["Set"] = function(p109) --[[Function name: Set, line 99]]
            --[[
            Upvalues:
                [1] = u107
                [2] = u108
            --]]
            if p109 then
                u107(u108)
            end
        end
    }
end
function v105.MoveTo(u110) --[[Anonymous function at line 355]]
    local v111 = u110:GetAttribute("MoveToDefault")
    if typeof(v111) ~= "Vector3" then
        local v112 = u110.RootPart
        v111 = not v112 and Vector3.new(0, 0, 0) or v112.Position
        u110:SetAttribute("MoveToDefault", v111)
    end
    return {
        ["Default"] = v111,
        ["Set"] = function(p113) --[[Function name: Set, line 373]]
            --[[
            Upvalues:
                [1] = u110
            --]]
            u110:MoveTo(p113)
        end
    }
end
function v105.Move(u114) --[[Anonymous function at line 379]]
    local v115 = u114:GetAttribute("MoveDefault")
    if typeof(v115) ~= "Vector3" then
        local v116 = u114.RootPart
        v115 = not v116 and Vector3.new(0, 0, 0) or v116.CFrame.LookVector
        u114:SetAttribute("MoveDefault", v115)
    end
    return {
        ["Default"] = v115,
        ["Set"] = function(p117) --[[Function name: Set, line 397]]
            --[[
            Upvalues:
                [1] = u114
            --]]
            u114:Move(p117)
        end
    }
end
function v105.PlayEmote(u118) --[[Anonymous function at line 403]]
    return {
        ["Default"] = "",
        ["Set"] = function(p119) --[[Function name: Set, line 407]]
            --[[
            Upvalues:
                [1] = u118
            --]]
            u118:PlayEmote(p119)
        end
    }
end
local function u121(p120) --[[Anonymous function at line 413]]
    p120:RemoveAccessories()
end
function v105.RemoveAccessories(u122) --[[Anonymous function at line 95]]
    --[[
    Upvalues:
        [1] = u121
    --]]
    return {
        ["Default"] = false,
        ["Set"] = function(p123) --[[Function name: Set, line 99]]
            --[[
            Upvalues:
                [1] = u121
                [2] = u122
            --]]
            if p123 then
                u121(u122)
            end
        end
    }
end
function v105.Sit(u124) --[[Anonymous function at line 417]]
    return {
        ["Set"] = function(p125) --[[Function name: Set, line 419]]
            --[[
            Upvalues:
                [1] = u124
            --]]
            u124.Sit = p125
        end
    }
end
function v105.TakeDamage(u126) --[[Anonymous function at line 425]]
    return {
        ["Set"] = function(p127) --[[Function name: Set, line 427]]
            --[[
            Upvalues:
                [1] = u126
            --]]
            u126:TakeDamage(p127)
        end
    }
end
local function u129(p128) --[[Anonymous function at line 433]]
    p128:UnequipTools()
end
function v105.UnequipTools(u130) --[[Anonymous function at line 95]]
    --[[
    Upvalues:
        [1] = u129
    --]]
    return {
        ["Default"] = false,
        ["Set"] = function(p131) --[[Function name: Set, line 99]]
            --[[
            Upvalues:
                [1] = u129
                [2] = u130
            --]]
            if p131 then
                u129(u130)
            end
        end
    }
end
u3.Humanoid = v105
local v132 = {}
local function u134(p133) --[[Anonymous function at line 443]]
    p133:Clear()
end
function v132.Clear(u135) --[[Anonymous function at line 95]]
    --[[
    Upvalues:
        [1] = u134
    --]]
    return {
        ["Default"] = false,
        ["Set"] = function(p136) --[[Function name: Set, line 99]]
            --[[
            Upvalues:
                [1] = u134
                [2] = u135
            --]]
            if p136 then
                u134(u135)
            end
        end
    }
end
function v132.Emit(u137) --[[Anonymous function at line 447]]
    local v138 = u137:GetAttribute("EmitCount")
    return {
        ["Default"] = type(v138) ~= "number" and 0 or v138,
        ["Set"] = function(p139) --[[Function name: Set, line 457]]
            --[[
            Upvalues:
                [1] = u137
            --]]
            if p139 > 0 then
                u137:Emit(p139)
            end
        end
    }
end
u3.ParticleEmitter = v132
local v140 = {}
local function u143(p141) --[[Anonymous function at line 471]]
    local v142 = p141:Clone()
    v142.Parent = p141.Parent
    v142.PlayOnRemove = true
    v142:Destroy()
end
function v140.PlayOnce(u144) --[[Anonymous function at line 95]]
    --[[
    Upvalues:
        [1] = u143
    --]]
    return {
        ["Default"] = false,
        ["Set"] = function(p145) --[[Function name: Set, line 99]]
            --[[
            Upvalues:
                [1] = u143
                [2] = u144
            --]]
            if p145 then
                u143(u144)
            end
        end
    }
end
function v140.SetTime(u146) --[[Anonymous function at line 478]]
    return {
        ["Default"] = 0,
        ["Set"] = function(p147) --[[Function name: Set, line 482]]
            --[[
            Upvalues:
                [1] = u146
            --]]
            u146.TimePosition = p147
        end
    }
end
local function u149(p148) --[[Anonymous function at line 488]]
    p148:Play()
end
function v140.Play(u150) --[[Anonymous function at line 95]]
    --[[
    Upvalues:
        [1] = u149
    --]]
    return {
        ["Default"] = false,
        ["Set"] = function(p151) --[[Function name: Set, line 99]]
            --[[
            Upvalues:
                [1] = u149
                [2] = u150
            --]]
            if p151 then
                u149(u150)
            end
        end
    }
end
local function u153(p152) --[[Anonymous function at line 492]]
    p152:Resume()
end
function v140.Resume(u154) --[[Anonymous function at line 95]]
    --[[
    Upvalues:
        [1] = u153
    --]]
    return {
        ["Default"] = false,
        ["Set"] = function(p155) --[[Function name: Set, line 99]]
            --[[
            Upvalues:
                [1] = u153
                [2] = u154
            --]]
            if p155 then
                u153(u154)
            end
        end
    }
end
local function u157(p156) --[[Anonymous function at line 496]]
    p156:Pause()
end
function v140.Pause(u158) --[[Anonymous function at line 95]]
    --[[
    Upvalues:
        [1] = u157
    --]]
    return {
        ["Default"] = false,
        ["Set"] = function(p159) --[[Function name: Set, line 99]]
            --[[
            Upvalues:
                [1] = u157
                [2] = u158
            --]]
            if p159 then
                u157(u158)
            end
        end
    }
end
local function u161(p160) --[[Anonymous function at line 500]]
    p160:Stop()
end
function v140.Stop(u162) --[[Anonymous function at line 95]]
    --[[
    Upvalues:
        [1] = u161
    --]]
    return {
        ["Default"] = false,
        ["Set"] = function(p163) --[[Function name: Set, line 99]]
            --[[
            Upvalues:
                [1] = u161
                [2] = u162
            --]]
            if p163 then
                u161(u162)
            end
        end
    }
end
u3.Sound = v140
local u164 = {}
local u165 = {}
local u166 = {}
local u178 = {
    ["__index"] = function(p167, p168) --[[Function name: __index, line 524]]
        --[[
        Upvalues:
            [1] = u165
            [2] = u3
        --]]
        local v169 = p167._target
        local v170 = v169.ClassName
        local v171 = u165[v170]
        if v171 == nil then
            v171 = {}
            for v172, v173 in u3 do
                if v169:IsA(v172) then
                    for v174, v175 in v173 do
                        v171[v174] = v175
                    end
                end
            end
            u165[v170] = v171
        end
        local v176 = v171[p168]
        local v177
        if v176 then
            v177 = v176(v169, p167._work)
            rawset(p167, p168, v177)
        else
            v177 = nil
        end
        return v177
    end
}
return {
    ["Get"] = function(p179, u180, p181) --[[Function name: get, line 562]]
        --[[
        Upvalues:
            [1] = u166
            [2] = u178
        --]]
        local v182 = u166[u180]
        if not v182 then
            local v183 = u178
            local u184 = setmetatable({
                ["_target"] = u180,
                ["_work"] = p179
            }, v183)
            u180.Destroying:Connect(function() --[[Anonymous function at line 572]]
                --[[
                Upvalues:
                    [1] = u166
                    [2] = u180
                    [3] = u184
                --]]
                if u166[u180] == u184 then
                    u166[u180] = nil
                end
            end)
            local v185 = u184
            u166[u180] = assert(v185)
            v182 = u184
        end
        return v182[p181]
    end,
    ["Static"] = function(p186, p187) --[[Function name: static, line 586]]
        --[[
        Upvalues:
            [1] = u164
            [2] = u4
        --]]
        local v188 = p186.ClassName
        if not u164[v188] then
            local v189 = {}
            for v190, v191 in pairs(u4) do
                if p186:IsA(v190) then
                    for v192, v193 in v191 do
                        v189[v192] = v193
                    end
                end
            end
            u164[v188] = v189
        end
        return u164[v188][p187] == true
    end,
    ["Index"] = u3
}