--[[
  Extracted from: ReplicatedStorage.Shared.Snapshot
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("RunService")
local v3 = game:GetService("Players")
local v4 = require(v1.Packages.Net)
local u5 = v4:RemoteEvent("Snapshot/RealiableChannel")
local u6 = v4:UnreliableRemoteEvent("Snapshot/UnrealiableChannel")
local u7 = v2:IsServer()
local u8 = CFrame.identity.Lerp
local u9 = CFrame.identity.ToOrientation
local u10 = CFrame.identity.FuzzyEq
local u11 = workspace.BulkMoveTo
local u12 = 0
local u13 = {}
local u14 = {}
local u15 = {}
local u16 = {}
local u17 = {}
local function v33(u18, p19) --[[Anonymous function at line 78]]
    --[[
    Upvalues:
        [1] = u7
        [2] = u13
        [3] = u12
        [4] = u14
        [5] = u15
        [6] = u16
        [7] = u17
    --]]
    local v20 = u7
    assert(v20, "create can only be used by server")
    if not u13[p19] then
        u12 = u12 + 1
        u12 = u12 % 65535
        local v21 = u12
        u13[p19] = v21
        u14[v21] = p19
        u15[tostring(v21)] = p19
        u16[tostring(v21)] = p19
    end
    u17[u18] = p19
    local u25 = p19.Destroying:Once(function() --[[Anonymous function at line 83]]
        --[[
        Upvalues:
            [1] = u18
            [2] = u17
            [3] = u13
            [4] = u12
            [5] = u14
            [6] = u15
            [7] = u16
        --]]
        local v22 = u18
        local v23 = u17[v22]
        if v23 then
            local v24 = u13[v23]
            if not v24 then
                u12 = u12 + 1
                u12 = u12 % 65535
                v24 = u12
                u13[v23] = v24
                u14[v24] = v23
                u15[tostring(v24)] = v23
                u16[tostring(v24)] = v23
            end
            u13[u14[v24]] = nil
            u14[v24] = nil
            u15[tostring(v24)] = nil
        end
        u17[v22] = nil
    end)
    local u29 = u18.Destroying:Once(function() --[[Anonymous function at line 87]]
        --[[
        Upvalues:
            [1] = u18
            [2] = u17
            [3] = u13
            [4] = u12
            [5] = u14
            [6] = u15
            [7] = u16
        --]]
        local v26 = u18
        local v27 = u17[v26]
        if v27 then
            local v28 = u13[v27]
            if not v28 then
                u12 = u12 + 1
                u12 = u12 % 65535
                v28 = u12
                u13[v27] = v28
                u14[v28] = v27
                u15[tostring(v28)] = v27
                u16[tostring(v28)] = v27
            end
            u13[u14[v28]] = nil
            u14[v28] = nil
            u15[tostring(v28)] = nil
        end
        u17[v26] = nil
    end)
    return function() --[[Anonymous function at line 91]]
        --[[
        Upvalues:
            [1] = u25
            [2] = u29
            [3] = u18
            [4] = u17
            [5] = u13
            [6] = u12
            [7] = u14
            [8] = u15
            [9] = u16
        --]]
        u25:Disconnect()
        u29:Disconnect()
        local v30 = u18
        local v31 = u17[v30]
        if v31 then
            local v32 = u13[v31]
            if not v32 then
                u12 = u12 + 1
                u12 = u12 % 65535
                v32 = u12
                u13[v31] = v32
                u14[v32] = v31
                u15[tostring(v32)] = v31
                u16[tostring(v32)] = v31
            end
            u13[u14[v32]] = nil
            u14[v32] = nil
            u15[tostring(v32)] = nil
        end
        u17[v30] = nil
    end
end
if u7 then
    local u34 = 0
    local u35 = {}
    v2.PostSimulation:Connect(function(p36) --[[Anonymous function at line 103]]
        --[[
        Upvalues:
            [1] = u34
            [2] = u16
            [3] = u5
            [4] = u6
            [5] = u17
            [6] = u13
            [7] = u12
            [8] = u14
            [9] = u15
            [10] = u35
            [11] = u10
            [12] = u9
        --]]
        u34 = u34 + p36
        if u34 >= 0.05 then
            u34 = 0
            debug.profilebegin("Snapshot:Step")
            if next(u16) then
                u5:FireAllClients(u16)
                table.clear(u16)
            end
            local u37 = workspace:GetServerTimeNow()
            local u38 = buffer.create(890)
            local u39 = 0
            local u40 = 0
            local function v44() --[[Anonymous function at line 124]]
                --[[
                Upvalues:
                    [1] = u40
                    [2] = u38
                    [3] = u37
                    [4] = u39
                    [5] = u6
                --]]
                if u40 ~= 0 then
                    debug.profilebegin("Snapshot:SendBuffer")
                    local v41 = buffer.create(u40 + 10)
                    buffer.copy(v41, 10, u38, 0, u40)
                    local v42 = u37
                    buffer.writef64(v41, 0, v42)
                    local v43 = u39
                    buffer.writeu16(v41, 8, v43)
                    u6:FireAllClients(v41)
                    u38 = buffer.create(890)
                    u39 = 0
                    u40 = 0
                    debug.profileend()
                end
            end
            debug.profilebegin("Snapshot:BuildBuffer")
            local v45 = u38
            local v46 = u39
            local v47 = u40
            for v48, v49 in u17 do
                local v50 = u13[v49]
                if not v50 then
                    u12 = u12 + 1
                    u12 = u12 % 65535
                    v50 = u12
                    u13[v49] = v50
                    u14[v50] = v49
                    u15[tostring(v50)] = v49
                    u16[tostring(v50)] = v49
                end
                local v51 = v48:GetPivot()
                local v52 = u35[v48]
                if not (v52 and u10(v51, v52)) then
                    if v47 + 26 > 900 then
                        v44()
                    end
                    u35[v48] = v51
                    u39 = v46 + 1
                    buffer.writeu16(v45, v47, v50)
                    local v53 = v47 + 2
                    local v54 = v51.X
                    buffer.writef32(v45, v53, v54)
                    local v55 = v47 + 6
                    local v56 = v51.Y
                    buffer.writef32(v45, v55, v56)
                    local v57 = v47 + 10
                    local v58 = v51.Z
                    buffer.writef32(v45, v57, v58)
                    local v59, v60, v61 = u9(v51)
                    local v62 = v47 + 14
                    buffer.writef32(v45, v62, v59)
                    local v63 = v47 + 18
                    buffer.writef32(v45, v63, v60)
                    local v64 = v47 + 22
                    buffer.writef32(v45, v64, v61)
                    u40 = v47 + 26
                    v46 = u39
                    v47 = u40
                end
            end
            debug.profileend()
            v44()
            debug.profileend()
        end
    end)
    local function v66(p65) --[[Anonymous function at line 182]]
        --[[
        Upvalues:
            [1] = u15
            [2] = u5
        --]]
        if next(u15) then
            u5:FireClient(p65, u15)
        end
    end
    v3.PlayerAdded:Connect(v66)
    for _, v67 in v3:GetPlayers() do
        task.defer(v66, v67)
    end
else
    local u68 = {}
    local u69 = 0
    local u70 = 0
    local function u78(p71, p72) --[[Anonymous function at line 201]]
        if #p72 < 2 then
            return nil, nil
        end
        local v73 = nil
        local v74 = nil
        for _, v75 in p72 do
            if v75.t <= p71 then
                v73 = v75
            end
            if p71 < v75.t then
                v74 = v75
                break
            end
        end
        local v76 = v73 or p72[1]
        local v77 = v74 or p72[2]
        if v76 and (v77 and v76.t == v77.t) then
            return nil, nil
        else
            return v76, v77
        end
    end
    local u79 = nil
    v2.PreRender:Connect(function(p80) --[[Anonymous function at line 228]]
        --[[
        Upvalues:
            [1] = u69
            [2] = u70
            [3] = u79
            [4] = u68
            [5] = u78
            [6] = u8
            [7] = u11
        --]]
        debug.profilebegin("Snapshot:Interpolate")
        debug.profilebegin("CalculateRenderTime")
        local v81 = u69 + (os.clock() - u70)
        u79 = (u79 or v81 - 0.2) + p80
        local v82 = 0.2 - (v81 - u79)
        if math.abs(v82) > 0.2 then
            u79 = v81 - 0.2
        elseif v82 > 0.01 then
            local v83 = v81 - 0.2
            local v84 = u79 - p80 * 0.1
            u79 = math.max(v83, v84)
        elseif v82 < -0.01 then
            local v85 = v81 - 0.2
            local v86 = u79 + p80 * 0.1
            u79 = math.min(v85, v86)
        end
        debug.profileend()
        debug.profilebegin("Interpolate Snapshots")
        local v87 = 0
        local v88 = {}
        local v89 = {}
        for v90, v91 in u68 do
            local v92, v93 = u78(u79, v91)
            if v92 and v93 then
                local v94 = (u79 - v92.t) / (v93.t - v92.t)
                local v95 = math.clamp(v94, 0, 1.1)
                v87 = v87 + 1
                v88[v87] = v90
                v89[v87] = u8(v92.cf, v93.cf, v95)
            end
        end
        debug.profileend()
        debug.profilebegin("BulkMoveTo")
        u11(workspace, v88, v89, Enum.BulkMoveMode.FireCFrameChanged)
        debug.profileend()
        debug.profileend()
    end)
    u6.OnClientEvent:Connect(function(p96) --[[Anonymous function at line 270]]
        --[[
        Upvalues:
            [1] = u69
            [2] = u70
            [3] = u14
            [4] = u68
        --]]
        local v97 = 0
        local v98 = buffer.readf64(p96, v97)
        local v99 = v97 + 8
        if v98 >= u69 then
            u69 = v98
            u70 = os.clock()
            local v100 = buffer.readu16(p96, v99)
            local v101 = v99 + 2
            for _ = 1, v100 do
                local v102 = buffer.readu16(p96, v101)
                local v103 = CFrame.new
                local v104 = v101 + 2
                local v105 = buffer.readf32(p96, v104)
                local v106 = v101 + 6
                local v107 = buffer.readf32(p96, v106)
                local v108 = v101 + 10
                local v109 = v103(v105, v107, (buffer.readf32(p96, v108)))
                local v110 = CFrame.fromOrientation
                local v111 = v101 + 14
                local v112 = buffer.readf32(p96, v111)
                local v113 = v101 + 18
                local v114 = buffer.readf32(p96, v113)
                local v115 = v101 + 22
                local v116 = v109 * v110(v112, v114, (buffer.readf32(p96, v115)))
                v101 = v101 + 26
                local v117 = u14[v102]
                if v117 and v117.Parent then
                    local v118 = {
                        ["t"] = v98,
                        ["cf"] = v116
                    }
                    if u68[v117] then
                        local v119 = u68[v117]
                        table.insert(v119, v118)
                    else
                        u68[v117] = { v118 }
                    end
                    if #u68[v117] > 100 then
                        table.remove(u68[v117], 1)
                    end
                end
            end
        end
    end)
    u5.OnClientEvent:Connect(function(p120) --[[Anonymous function at line 322]]
        --[[
        Upvalues:
            [1] = u13
            [2] = u14
            [3] = u15
            [4] = u68
        --]]
        for v121, u122 in p120 do
            local u123 = tonumber(v121)
            if typeof(u122) == "Instance" and u122.Parent then
                if u122:IsA("BasePart") then
                    u122.Anchored = true
                end
                u122.Destroying:Once(function() --[[Anonymous function at line 335]]
                    --[[
                    Upvalues:
                        [1] = u123
                        [2] = u13
                        [3] = u14
                        [4] = u15
                        [5] = u68
                        [6] = u122
                    --]]
                    local v124 = u123
                    u13[u14[v124]] = nil
                    u14[v124] = nil
                    u15[tostring(v124)] = nil
                    u68[u122] = nil
                end)
                u13[u122] = u123
                u14[u123] = u122
            end
        end
    end)
end
return {
    ["DELAY"] = 0.2,
    ["create"] = v33
}