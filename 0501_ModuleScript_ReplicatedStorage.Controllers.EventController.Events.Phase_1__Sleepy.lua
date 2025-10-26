--[[
  Extracted from: ReplicatedStorage.Controllers.EventController.Events.Phase 1: Sleepy
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local u1 = game:GetService("ReplicatedStorage")
local u2 = game:GetService("ContentProvider")
local u3 = game:GetService("Lighting")
local u4 = game:GetService("Players")
local u5 = game:GetService("Debris")
require(u1.Shared.EventTypes)
local v6 = {}
local v7 = require(u1.Packages.Net)
local v8 = require(u1.Packages.Trove)
local u9 = require(u1.Packages.FFlags)
local u10 = require(u1.Packages.CreateTween)
local u11 = require(script.Parent.Parent)
local u12 = require(u1.Controllers.NotificationController)
local u13 = require(u1.Controllers.SkullEmojiEffectController)
local u14 = require(u1.Shared.VFX)
local u15 = require(u1.Controllers.AnimalController)
local u16 = require(u1.Controllers.SoundController)
local u17 = script.Name
local u18 = v8.new()
local u19 = v8.new()
local u20 = u4.LocalPlayer
local u21 = Random.new()
local u22 = {}
local u23 = nil
local u24 = nil
local u25 = nil
local u26 = nil
local u27 = v7:RemoteEvent((("EventService/%*/PlaySleepVFX"):format(u17)))
local u28 = u1.Models.Events.Sleepy
local u29 = workspace.Events["Phase 1: Sleepy"]
local u30 = u1.Animations.Events["Phase 1: Sleepy"]
local function u42() --[[Anonymous function at line 46]]
    --[[
    Upvalues:
        [1] = u25
        [2] = u23
        [3] = u20
        [4] = u22
        [5] = u4
    --]]
    if u25 or u23 then
        return
    else
        u25 = time()
        local v31 = {}
        local v32, v33 = pcall(u20.GetFriendsOnline, u20, 15)
        if v32 then
            for _, v34 in v33 do
                local v35 = v34.VisitorId
                table.insert(v31, v35)
                local v36 = u22
                local v37 = v34.VisitorId
                table.insert(v36, v37)
            end
        end
        if #v31 >= 15 then
            return v31
        else
            local v38, v39 = pcall(u4.GetFriendsAsync, u4, u20.UserId)
            if v38 and v39 then
                for _, v40 in v39:GetCurrentPage() do
                    if not table.find(u22, v40.Id) then
                        local v41 = v40.Id
                        table.insert(v31, v41)
                    end
                end
                return v31
            else
                warn((("Players:GetFriendsAsync() failed: %*"):format(v39)))
                return nil
            end
        end
    end
end
local function u47(u43) --[[Anonymous function at line 88]]
    --[[
    Upvalues:
        [1] = u19
        [2] = u29
    --]]
    local u44 = u19:Clone(script.NPCTemplate)
    u44:PivotTo(CFrame.new(0, 100000, 0))
    u44.Parent = u29
    local v45, v46 = pcall(function() --[[Anonymous function at line 92]]
        --[[
        Upvalues:
            [1] = u44
            [2] = u43
        --]]
        return u44.Humanoid:ApplyDescription(u43)
    end)
    if v45 then
        u19:Add(task.delay(3, function() --[[Anonymous function at line 102]]
            --[[
            Upvalues:
                [1] = u44
                [2] = u29
            --]]
            if u44.Parent == u29 then
                u44.Parent = nil
            end
        end))
        return u44
    end
    warn((("Failed to createNPC(): %*"):format(v46)))
    u44:Destroy()
    return nil
end
local function u50(p48) --[[Anonymous function at line 113]]
    for _, v49 in Enum.HumanoidStateType:GetEnumItems() do
        if v49 ~= Enum.HumanoidStateType.None then
            p48:SetStateEnabled(v49, false)
        end
    end
end
local function u66(p51, p52) --[[Anonymous function at line 124]]
    --[[
    Upvalues:
        [1] = u26
        [2] = u24
        [3] = u23
        [4] = u19
        [5] = u22
        [6] = u21
        [7] = u4
        [8] = u47
        [9] = u50
        [10] = u5
    --]]
    if not (u26 or u24) or p52 then
        u26 = time()
        local v53 = {}
        if p52 or not u23 then
            for _ = 1, p51 do
                local v54 = u19
                local v55 = script.BaconTemplate
                table.insert(v53, v54:Clone(v55))
            end
            return v53
        end
        local v56 = table.clone(u22 or {})
        local v57 = table.clone(u23 or {})
        while #v53 < p51 do
            local u58 = nil
            local v59 = nil
            local v60
            if #v56 > 0 then
                v60 = v56
            else
                v60 = v57
            end
            if #v60 > 0 then
                local v61 = u21:NextInteger(1, #v60)
                u58 = v60[v61]
                table.remove(v60, v61)
            end
            if u58 then
                local v62, v63 = pcall(function() --[[Anonymous function at line 156]]
                    --[[
                    Upvalues:
                        [1] = u4
                        [2] = u58
                    --]]
                    return u4:GetHumanoidDescriptionFromUserId(u58)
                end)
                if v62 then
                    v59 = v63 or v59
                end
            end
            local v64
            if v59 then
                v59.BackAccessory = 0
                v59.BodyTypeScale = 0
                v59.ProportionScale = 0
                v59.DepthScale = 1
                v59.HeadScale = 1
                v59.HeightScale = 1
                v59.WidthScale = 1
                v64 = u47(v59)
            else
                v64 = nil
            end
            local v65 = v64 or u19:Clone(script.BaconTemplate)
            u50(v65.Humanoid)
            u5:AddItem(v65, 300)
            table.insert(v53, v65)
        end
        return v53
    end
end
function v6.OnStart(_) --[[Anonymous function at line 192]]
    --[[
    Upvalues:
        [1] = u11
        [2] = u17
        [3] = u1
        [4] = u16
        [5] = u18
        [6] = u4
        [7] = u10
        [8] = u3
        [9] = u13
        [10] = u12
        [11] = u19
        [12] = u29
        [13] = u30
        [14] = u28
        [15] = u21
        [16] = u50
        [17] = u25
        [18] = u42
        [19] = u23
        [20] = u26
        [21] = u24
        [22] = u66
    --]]
    local v67 = u11:GetActiveEventData(u17)
    assert(v67)
    u1:SetAttribute("Phase1SleepyEvent", true)
    u16:UpdateOST()
    u18:Add(function() --[[Anonymous function at line 199]]
        --[[
        Upvalues:
            [1] = u1
            [2] = u16
        --]]
        u1:SetAttribute("Phase1SleepyEvent", nil)
        u16:UpdateOST()
    end)
    local u68 = v67.endsAt - 10
    local u69 = workspace:GetServerTimeNow()
    local v70 = u68 - workspace:GetServerTimeNow()
    local v71 = math.max(v70, 0)
    local v72 = math.min(v71, 4)
    local u73 = math.max(0.1, v72)
    local u74 = TweenInfo.new(u73, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
    local v75 = v71 - u73
    local u76 = math.max(v75, 0)
    u18:Add(task.delay(u76, function() --[[Anonymous function at line 219]]
        --[[
        Upvalues:
            [1] = u69
            [2] = u68
            [3] = u76
            [4] = u18
            [5] = u4
            [6] = u10
            [7] = u74
            [8] = u3
            [9] = u73
            [10] = u13
            [11] = u12
        --]]
        if u68 >= u69 and u76 ~= 0 then
            local v77 = u18:Clone(script.ImageLabel)
            v77.Size = UDim2.fromScale(10, 10)
            v77.Parent = u4.LocalPlayer.PlayerGui:WaitForChild("CoinsShop")
            u10(v77, u74, {
                ["Size"] = UDim2.fromScale(2, 1.5)
            })
            local u78 = u18:Add(Instance.new("BlurEffect"))
            u78.Size = 0
            u78.Parent = u3
            u10(u78, u74, {
                ["Size"] = 10
            })
            task.wait(u73)
            u18:Add(task.delay(u68 + 0.1 + 4 - workspace:GetServerTimeNow(), function() --[[Anonymous function at line 244]]
                --[[
                Upvalues:
                    [1] = u18
                    [2] = u78
                --]]
                u18:Remove(u78)
            end))
            u13:Play(4.5, "Lower")
            task.delay(0.5, function() --[[Anonymous function at line 254]]
                --[[
                Upvalues:
                    [1] = u12
                --]]
                u12:Notify("YOU FELL ASLEEP", 4)
            end)
        end
    end))
    u19:Add(task.delay(v67.endsAt + 45 - workspace:GetServerTimeNow(), function() --[[Anonymous function at line 259]]
        --[[
        Upvalues:
            [1] = u19
        --]]
        u19:Destroy()
    end))
    local function u110(p79, p80, u81) --[[Anonymous function at line 265]]
        --[[
        Upvalues:
            [1] = u19
            [2] = u10
        --]]
        local function v97(u82, u83, u84, p85) --[[Anonymous function at line 266]]
            --[[
            Upvalues:
                [1] = u19
                [2] = u81
                [3] = u10
            --]]
            local u86 = u82.CFrame
            local v87 = p85 and 0 or u83.X
            local v88 = p85 and 0 or u83.Z
            local v89 = Vector3.new(v87, 0, v88)
            local v90 = u86 * CFrame.new(0, -(u83.Y - v89.Y) / 2, 0)
            u82.Size = v89
            u82.CFrame = v90
            local u91 = u82.Transparency
            u82.Transparency = 1
            local v92 = u19
            local v93 = task.delay
            local v94
            if u81 then
                v94 = u81(u84)
            else
                v94 = u84
            end
            v92:Add(v93(v94, function() --[[Anonymous function at line 277]]
                --[[
                Upvalues:
                    [1] = u82
                    [2] = u91
                    [3] = u81
                    [4] = u84
                    [5] = u10
                    [6] = u83
                    [7] = u86
                --]]
                u82.Transparency = u91
                local v95 = not u81 and 1 or u81(u84 + 1)
                local v96 = TweenInfo.new(v95, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
                u10(u82, v96, {
                    ["Size"] = u83
                })
                u10(u82, v96, {
                    ["CFrame"] = u86
                })
            end))
        end
        local v98 = {}
        local v99 = (1 / 0)
        local v100 = (-1 / 0)
        for _, v101 in p79:GetDescendants() do
            if v101:IsA("BasePart") and v101.Transparency < 1 then
                table.insert(v98, v101)
                local v102 = v101.Position.Y
                v99 = math.min(v99, v102)
                local v103 = v101.Position.Y
                v100 = math.max(v100, v103)
            end
        end
        table.sort(v98, function(p104, p105) --[[Anonymous function at line 303]]
            return p104.Position.Y < p105.Position.Y
        end)
        local v106 = v100 - v99
        for _, v107 in v98 do
            local v108 = v107.Color.R * 255 < 90
            local v109 = (v107.Position.Y - v99) / v106 * p80
            if v108 then
                v109 = v109 + 0.2
            end
            v97(v107, v107.Size, v109, v108)
        end
    end
    local u111 = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.In, 0, false, 4)
    local function u126(p112, p113, p114, p115) --[[Anonymous function at line 322]]
        --[[
        Upvalues:
            [1] = u19
            [2] = u1
            [3] = u29
            [4] = u30
            [5] = u28
            [6] = u21
            [7] = u10
            [8] = u111
            [9] = u110
        --]]
        local v116 = p112:FindFirstChild("Head")
        local v117 = p112.PrimaryPart
        if not (v116 and v117) then
            return false
        end
        v117.Anchored = true
        p112:PivotTo(p114)
        u19:Clone(u1.Models.Traits.Sleepy.Sleepy.Attachment).Parent = v116
        p112.Parent = u29.NPCs
        for _, v118 in p112:GetChildren() do
            if v118:IsA("BasePart") then
                v118.CanCollide = false
                v118.CollisionGroup = "PlayerNoCollision"
            end
        end
        u19:Add(p112.Humanoid.Animator:LoadAnimation(u30.SleepIdle)):Play()
        local v119 = p113:GetExtentsSize()
        if not p115 then
            local v120 = v119.X
            local v121 = v119.Z
            local v122 = math.max(v120, v121) / 2
            p115 = CFrame.new(0, 0, v122 + 0.5)
        end
        local v123 = p114 * p115
        p113:PivotTo(v123)
        local v124 = Instance.new("Part")
        v124.Transparency = 1
        v124.CanCollide = false
        v124.CanQuery = false
        v124.CanTouch = false
        v124.Anchored = true
        v124.Name = "Hitbox"
        v124.Size = v119
        v124.CFrame = v123 * CFrame.new(0, v119.Y, 0)
        v124.Parent = p113
        p113.PrimaryPart = v124
        local v125 = u19:Clone(u28.GrowTimer)
        v125.TextLabel.Text = ("%* years left"):format((u21:NextInteger(2, 10)))
        v125.Parent = v124
        v125.TextLabel.TextTransparency = 1
        v125.TextLabel.UIStroke.Transparency = 1
        u10(v125.TextLabel, u111, {
            ["TextTransparency"] = 0
        })
        u10(v125.TextLabel.UIStroke, u111, {
            ["Transparency"] = 0
        })
        p113.Parent = u29.Plants
        u110(p113, 4)
        return true
    end
    task.defer(function() --[[Anonymous function at line 397]]
        --[[
        Upvalues:
            [1] = u19
            [2] = u28
            [3] = u50
            [4] = u126
            [5] = u29
            [6] = u25
            [7] = u42
            [8] = u23
            [9] = u26
            [10] = u24
            [11] = u66
            [12] = u21
        --]]
        local u127 = {}
        local v128 = u19:Clone(u28["Jandel R15"])
        u50(v128.Humanoid)
        u126(v128, u19:Clone(u28.Beanstalk), u29.JandelSpawn:GetPivot(), CFrame.new(0, 0, 3.5))
        u127[v128] = v128
        local function v131(p129) --[[Anonymous function at line 412]]
            --[[
            Upvalues:
                [1] = u127
            --]]
            for _, v130 in u127 do
                if (p129 - v130:GetPivot().Position).Magnitude < 15 then
                    return false
                end
            end
            return true
        end
        if not u25 then
            task.spawn(u42)
        end
        local v132 = time()
        local v133 = v132 - (u25 or v132)
        if not u23 and v133 < 5 then
            task.wait(5 - v133)
        end
        local v134 = time()
        if not u24 and v134 - (u26 or v134) < 5 then
            task.wait(5 - v133)
        end
        local v135 = u24 or u66(15, true)
        if not v135 then
            warn("No NPCs generated by generateNPCs")
            return
        end
        for _, v136 in v135 do
            u127[v136] = v136
            local v137 = u29.PlantSpawns:GetChildren()
            local v138 = v137[u21:NextInteger(1, #v137)]
            local v139 = v138.Position
            local v140 = v138.Size
            local v141 = 0
            local v142 = nil
            while true do
                if v141 >= 20 then
                    v146 = v142
                    break
                end
                v141 = v141 + 1
                local v143 = v139.X + u21:NextNumber(-v140.X * 0.5, v140.X * 0.5)
                local v144 = v139.Y + v140.Y * 0.5
                local v145 = v139.Z + u21:NextNumber(-v140.Z * 0.5, v140.Z * 0.5)
                local v146 = Vector3.new(v143, v144, v145)
                if v131(v146) then
                    break
                end
                if v141 ~= 20 then
                    v146 = v142
                end
                v142 = v146
            end
            local v147 = CFrame.new(0, -0.4, 0)
            local v148 = CFrame.Angles(0, u21:NextNumber(0, 6.283185307179586), 0)
            local v149 = CFrame.new(v146) * v147 * v148
            local v150 = u28.Plants:GetChildren()
            if not u126(v136, u19:Clone(v150[u21:NextInteger(1, #v150)]), v149) then
                u127[v136] = nil
                v136:Destroy()
            end
        end
    end)
end
function v6.OnStop(_) --[[Anonymous function at line 499]]
    --[[
    Upvalues:
        [1] = u18
    --]]
    u18:Destroy()
end
function v6.OnLoad(_) --[[Anonymous function at line 503]]
    --[[
    Upvalues:
        [1] = u27
        [2] = u15
        [3] = u18
        [4] = u28
        [5] = u14
        [6] = u5
        [7] = u16
        [8] = u1
        [9] = u9
        [10] = u23
        [11] = u42
        [12] = u24
        [13] = u66
        [14] = u2
    --]]
    u27.OnClientEvent:Connect(function(p151) --[[Anonymous function at line 504]]
        --[[
        Upvalues:
            [1] = u15
            [2] = u18
            [3] = u28
            [4] = u14
            [5] = u5
            [6] = u16
            [7] = u1
        --]]
        local v152 = u15:GetAnimals()[p151]
        if v152 then
            local v153 = v152.AnimalModel
            local v154 = v152.AnimalModel
            if v154 then
                v154 = v153.PrimaryPart
            end
            local v155 = v152.Instance
            local v156
            if v155 then
                v156 = v155.PrimaryPart
            else
                v156 = v155
            end
            if v156 and v154 then
                local v157 = u18:Clone(u28.SleepyImpact.SleepyImpact)
                v157:PivotTo(v156.CFrame * CFrame.new(0, (v157.Size.Y + v153:GetExtentsSize().Y) / 2, 0))
                v157.Parent = v155
                u14.weld(v157, v154)
                u14.emit(v157)
                u5:AddItem(v157, 5)
                u16:PlaySound(u1.Sounds.Events["Phase 1: Sleepy"].Hit, v156.CFrame.Position, false)
            end
        else
            return
        end
    end)
    task.defer(function() --[[Anonymous function at line 536]]
        --[[
        Upvalues:
            [1] = u9
            [2] = u23
            [3] = u42
            [4] = u24
            [5] = u66
        --]]
        if not u9:GetInstant("DisableFriendsAvatarPreloading", true) then
            u23 = u42()
            u24 = u66(15)
        end
    end)
    task.spawn(pcall, function() --[[Anonymous function at line 546]]
        --[[
        Upvalues:
            [1] = u2
        --]]
        u2:PreloadAsync(script:GetChildren())
    end)
    task.spawn(pcall, function() --[[Anonymous function at line 550]]
        --[[
        Upvalues:
            [1] = u2
            [2] = u1
        --]]
        u2:PreloadAsync(u1.Models.Events["Phase 1: Sleepy"])
    end)
end
return v6