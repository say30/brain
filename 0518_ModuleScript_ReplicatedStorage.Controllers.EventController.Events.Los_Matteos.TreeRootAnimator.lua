--[[
  Extracted from: ReplicatedStorage.Controllers.EventController.Events.Los Matteos.TreeRootAnimator
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local u1 = game:GetService("RunService")
local v2 = game:GetService("ReplicatedStorage")
local v3 = require(v2.Packages.Observers)
local u4 = require(v2.Packages.Trove)
local u5 = {
    "StartX",
    "StartZ",
    "Direction",
    "FromLength",
    "ToLength",
    "TweenDuration",
    "TweenId",
    "ThicknessY",
    "PauseUntil"
}
local u6 = {}
local u7 = {}
local u8 = {}
local u9 = nil
local function u14(p10) --[[Anonymous function at line 37]]
    --[[
    Upvalues:
        [1] = u5
    --]]
    local v11 = {}
    for _, v12 in u5 do
        local v13 = p10:GetAttribute(v12)
        if typeof(v13) ~= "number" and typeof(v13) ~= "Vector2" then
            return nil
        end
        v11[v12] = v13
    end
    v11.Elapsed = 0
    v11.Part = p10
    return v11
end
local function u29(p15, p16) --[[Anonymous function at line 55]]
    local v17 = p15.Part.Position.Y
    local v18 = p16 or p15.FromLength
    local v19 = (v18 - 1) * 0.5
    local v20
    if p15.Direction.X == 0 then
        local v21 = p15.StartX + 0.5
        local v22 = p15.StartZ + p15.Direction.Y * v19
        v20 = Vector3.new(v21, v17, v22)
    else
        local v23 = p15.StartX + p15.Direction.X * v19
        local v24 = p15.StartZ + 0.5
        v20 = Vector3.new(v23, v17, v24)
    end
    local v25 = p15.Direction.X == 0 and 2 or math.max(1, v18)
    local v26 = p15.Direction.Y == 0 and 2 or math.max(1, v18)
    local v27 = p15.Part
    local v28 = p15.ThicknessY
    v27.Size = Vector3.new(v25, v28, v26)
    p15.Part.CFrame = CFrame.new(v20)
end
local function u44(p30) --[[Anonymous function at line 132]]
    --[[
    Upvalues:
        [1] = u14
        [2] = u8
        [3] = u7
        [4] = u6
        [5] = u29
        [6] = u9
        [7] = u1
    --]]
    local v31 = u14(p30)
    if v31 then
        local v32 = v31.TweenId
        if u8[p30] == v32 then
            return
        else
            u8[p30] = v32
            if workspace:GetServerTimeNow() < v31.PauseUntil then
                u7[p30] = v31
                u6[p30] = nil
            else
                u6[p30] = v31
                u7[p30] = nil
            end
            u29(v31)
            if not (u9 and u9.Connected) then
                u9 = u1.PostSimulation:Connect(function(p33) --[[Anonymous function at line 80]]
                    --[[
                    Upvalues:
                        [1] = u6
                        [2] = u9
                        [3] = u7
                        [4] = u29
                    --]]
                    if next(u6) == nil and (u9 ~= nil and u9.Connected) then
                        u9:Disconnect()
                        u9 = nil
                    else
                        local v34 = workspace:GetServerTimeNow()
                        for v35, v36 in u7 do
                            if v36.PauseUntil <= v34 then
                                u6[v35] = v36
                                u7[v35] = nil
                                u29(v36)
                            else
                                u29(v36)
                            end
                        end
                        local v37 = 0
                        for v38, v39 in u6 do
                            if v34 < v39.PauseUntil then
                                u7[v38] = v39
                                u6[v38] = nil
                                u29(v39)
                            else
                                v39.Elapsed = v39.Elapsed + p33
                                local v40 = v39.TweenDuration
                                local v41 = math.max(v40, 0.011111111111111112)
                                local v42 = v39.Elapsed / v41
                                local v43 = math.clamp(v42, 0, 1)
                                u29(v39, v39.FromLength + (v39.ToLength - v39.FromLength) * v43)
                                if v43 >= 1 then
                                    u6[v38] = nil
                                end
                            end
                            v37 = v37 + 1
                            if v37 >= 3 then
                                break
                            end
                        end
                    end
                end)
            end
        end
    else
        return
    end
end
return v3.observeTag("RootRunTween", function(u45) --[[Anonymous function at line 165]]
    --[[
    Upvalues:
        [1] = u4
        [2] = u44
        [3] = u6
        [4] = u7
        [5] = u29
        [6] = u14
        [7] = u9
        [8] = u1
        [9] = u8
    --]]
    if not u45:IsA("BasePart") then
        return nil
    end
    local u46 = u4.new()
    u44(u45)
    u46:Add(u45:GetAttributeChangedSignal("TweenId"):Connect(function() --[[Anonymous function at line 176]]
        --[[
        Upvalues:
            [1] = u44
            [2] = u45
        --]]
        u44(u45)
    end))
    u46:Add(u45:GetAttributeChangedSignal("PauseUntil"):Connect(function() --[[Anonymous function at line 180]]
        --[[
        Upvalues:
            [1] = u45
            [2] = u6
            [3] = u7
            [4] = u29
            [5] = u14
            [6] = u9
            [7] = u1
        --]]
        local v47 = u45:GetAttribute("PauseUntil") or 0
        local v48 = workspace:GetServerTimeNow()
        local v49 = u6[u45]
        local v50 = u7[u45]
        if v48 < v47 then
            if v49 then
                v49.PauseUntil = v47
                u7[u45] = v49
                u6[u45] = nil
                u29(v49)
            elseif v50 then
                v50.PauseUntil = v47
                u29(v50)
            else
                local v51 = u14(u45)
                if v51 then
                    u7[u45] = v51
                    u29(v51)
                end
            end
            if u9 and u9.Connected then
                return
            end
            u9 = u1.PostSimulation:Connect(function(p52) --[[Anonymous function at line 80]]
                --[[
                Upvalues:
                    [1] = u6
                    [2] = u9
                    [3] = u7
                    [4] = u29
                --]]
                if next(u6) == nil and (u9 ~= nil and u9.Connected) then
                    u9:Disconnect()
                    u9 = nil
                else
                    local v53 = workspace:GetServerTimeNow()
                    for v54, v55 in u7 do
                        if v55.PauseUntil <= v53 then
                            u6[v54] = v55
                            u7[v54] = nil
                            u29(v55)
                        else
                            u29(v55)
                        end
                    end
                    local v56 = 0
                    for v57, v58 in u6 do
                        if v53 < v58.PauseUntil then
                            u7[v57] = v58
                            u6[v57] = nil
                            u29(v58)
                        else
                            v58.Elapsed = v58.Elapsed + p52
                            local v59 = v58.TweenDuration
                            local v60 = math.max(v59, 0.011111111111111112)
                            local v61 = v58.Elapsed / v60
                            local v62 = math.clamp(v61, 0, 1)
                            u29(v58, v58.FromLength + (v58.ToLength - v58.FromLength) * v62)
                            if v62 >= 1 then
                                u6[v57] = nil
                            end
                        end
                        v56 = v56 + 1
                        if v56 >= 3 then
                            break
                        end
                    end
                end
            end)
        end
    end))
    return function() --[[Anonymous function at line 212]]
        --[[
        Upvalues:
            [1] = u46
            [2] = u6
            [3] = u45
            [4] = u8
        --]]
        u46:Destroy()
        u6[u45] = nil
        u8[u45] = nil
    end
end)