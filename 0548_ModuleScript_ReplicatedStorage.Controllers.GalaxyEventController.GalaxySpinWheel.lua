--[[
  Extracted from: ReplicatedStorage.Controllers.GalaxyEventController.GalaxySpinWheel
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local u1 = game:GetService("ReplicatedStorage")
local u2 = game:GetService("RunService")
local v3 = game:GetService("Players")
local v4 = u1:WaitForChild("Datas")
local u5 = require(v4.GalaxySpinWheel)
local u6 = require(v4.Shop)
local v7 = u1:WaitForChild("Utils")
local u8 = require(v7.TimeUtils)
local u9 = require(v7.NumberUtils)
local v10 = u1:WaitForChild("Controllers")
require(v10.ShopController)
local u11 = require(v10.InterfaceController)
local v12 = u1:WaitForChild("Shared")
local u13 = require(v12.Marketplace)
local v14 = u1:WaitForChild("Packages")
local u15 = require(v14.Trove)
local u16 = require(v14.Timer)
local u17 = require(v14.Synchronizer)
local u18 = v3.LocalPlayer
local u19 = {}
u19.__index = u19
function u19.new(u20) --[[Anonymous function at line 81]]
    --[[
    Upvalues:
        [1] = u17
        [2] = u18
        [3] = u19
        [4] = u15
        [5] = u5
        [6] = u6
        [7] = u9
        [8] = u13
        [9] = u2
        [10] = u11
        [11] = u16
        [12] = u1
        [13] = u8
    --]]
    local u21 = u17:Wait(u18)
    local v22 = u19
    local u23 = setmetatable({}, v22)
    u23.Instance = u20
    u23.Collector = u15.new()
    local function u40() --[[Anonymous function at line 90]]
        --[[
        Upvalues:
            [1] = u20
            [2] = u5
            [3] = u21
            [4] = u6
            [5] = u9
            [6] = u13
        --]]
        local v24 = u20:WaitForChild("Main"):WaitForChild("SurfaceGui").Wheel
        local v25 = v24.Items
        local v26 = v24.Names
        local v27 = v24.Odds
        for v28 = 1, #u5.Rewards do
            local v29 = u5.Rewards[v28]
            if v29 then
                if v29.Type == "Item" and u21:Get((("Items.%*"):format(v29.Index))) then
                    v29 = u5.AltRewards[v28]
                end
                local v30 = v25:FindFirstChild(v28)
                local v31 = v26:FindFirstChild(v28)
                local v32 = v27:FindFirstChild(v28)
                local v33 = ""
                local v34
                if v29.Type == "Cash-Pack" then
                    local v35 = u6[v29.Index].Value
                    local v36 = u21:Get("Rebirth") or 0
                    if v36 > 0 then
                        v35 = v35 * (v36 <= 1 and 1.5 or v36)
                    end
                    v33 = ("$%*"):format((u9:ToString(v35, 2)))
                    v34 = u13:GetProductInfo(v29.Index, "Product").Icon
                else
                    v34 = v29.Icon
                end
                local v37 = v29.Display
                local v38 = v33 == "" and v37 and v37 or v33
                local v39 = ("%*%%"):format(v29.Weight)
                v30.Image = v34 or ""
                v31.Text = v38
                v32.Text = v39
            end
        end
    end
    u40()
    u23.Collector:Add(u21:OnDictionaryInserted("Items", function(_, p41) --[[Anonymous function at line 148]]
        --[[
        Upvalues:
            [1] = u5
            [2] = u40
        --]]
        local v42 = false
        for v43 = 1, #u5.Rewards do
            local v44 = u5.Rewards[v43]
            if v44.Type == "Item" and p41 == v44.Index then
                v42 = true
                break
            end
        end
        if v42 then
            u40()
        end
    end))
    u23.Collector:Add(u2.RenderStepped:Connect(function(p45) --[[Anonymous function at line 162]]
        --[[
        Upvalues:
            [1] = u23
        --]]
        local v46 = u23.Instance.Main
        local v47 = v46.CFrame
        local v48 = CFrame.Angles
        local v49 = p45 * 45
        v46.CFrame = v47 * v48(math.rad(v49), 0, 0)
    end))
    u23.Collector:Add(u23.Instance.Root.ProximityPrompt.Triggered:Connect(function() --[[Anonymous function at line 170]]
        --[[
        Upvalues:
            [1] = u11
        --]]
        u11:Toggle("GalaxyWheel", true)
    end))
    local v50 = u16.new(1)
    u23.Collector:Add(v50, "Destroy")
    u23.Collector:Add(v50.Tick:Connect(function() --[[Anonymous function at line 176]]
        --[[
        Upvalues:
            [1] = u1
            [2] = u21
            [3] = u23
            [4] = u8
        --]]
        if u1:GetAttribute("GalaxyEvent") then
            if u21:Get("GalaxySpinWheel.LastFreeClaimed") == u1:GetAttribute("GalaxyEventLastTime") then
                local v51 = u23.Instance.Overhead.BillboardGui.Countdown
                local v52 = "Free Spin in %*"
                local v53 = u8
                local v54 = workspace:GetServerTimeNow()
                local v55
                if v54 < 1755961200 then
                    v55 = 1755961200 - v54
                else
                    local v56 = os.date("!*t", workspace:GetServerTimeNow()).wday
                    local v57 = (v56 == 1 or v56 == 7) and 3600 or 10800
                    v55 = v57 - v54 % v57
                end
                v51.Text = v52:format((v53:D(v55)))
            else
                u23.Instance.Overhead.BillboardGui.Countdown.Text = "SPIN NOW"
            end
        else
            local v58 = u23.Instance.Overhead.BillboardGui.Countdown
            local v59 = "Free Spin in %*"
            local v60 = u8
            local v61 = workspace:GetServerTimeNow()
            local v62
            if v61 < 1755961200 then
                v62 = 1755961200 - v61
            else
                local v63 = os.date("!*t", workspace:GetServerTimeNow()).wday
                local v64 = (v63 == 1 or v63 == 7) and 3600 or 10800
                v62 = v64 - v61 % v64
            end
            v58.Text = v59:format((v60:D(v62)))
            return
        end
    end))
    v50:StartNow()
    return u23
end
function u19.Destroy(p65) --[[Anonymous function at line 194]]
    p65.Collector:Destroy()
end
return u19