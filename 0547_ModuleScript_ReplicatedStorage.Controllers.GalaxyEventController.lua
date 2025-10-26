--[[
  Extracted from: ReplicatedStorage.Controllers.GalaxyEventController
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local u1 = game:GetService("ReplicatedStorage")
local u2 = game:GetService("RunService")
local v3 = game:GetService("Players")
local u4 = game:GetService("TweenService")
local v5 = u1:WaitForChild("Controllers")
local u6 = require(v5.InterfaceController)
require(v5.ShopController)
local u7 = require(v5.NotificationController)
require(v5.SoundController)
local v8 = u1:WaitForChild("Packages")
local u9 = require(v8.Observers)
local u10 = require(v8.Synchronizer)
local u11 = require(v8.Timer)
require(v8.Trove)
local v12 = require(v8.Net)
local v13 = u1:WaitForChild("Utils")
local u14 = require(v13.TimeUtils)
local u15 = require(v13.NumberUtils)
local v16 = u1:WaitForChild("Datas")
local u17 = require(v16.GalaxySpinWheel)
local u18 = require(v16.Shop)
local v19 = u1:WaitForChild("Classes")
local u20 = require(script.GalaxySpinWheel)
local u21 = require(v19.AnimatedButton)
local v22 = u1:WaitForChild("Shared")
local u23 = require(v22.Marketplace)
local u24 = v3.LocalPlayer
local u25 = u24.PlayerGui:WaitForChild("GalaxyWheel").GalaxyWheel
local u26 = nil
local u27 = false
local u28 = v12:RemoteEvent("ShopService/Purchase")
local u29 = v12:RemoteEvent("GalaxyEventService/Spin")
v12:RemoteFunction("GalaxyEventService/RequestBuy")
local u30 = false
local v31 = {}
local function u50(p32, p33) --[[Anonymous function at line 87]]
    --[[
    Upvalues:
        [1] = u10
        [2] = u24
        [3] = u30
        [4] = u25
        [5] = u27
        [6] = u2
        [7] = u4
        [8] = u17
        [9] = u18
        [10] = u15
        [11] = u7
    --]]
    local v34 = u10:Wait(u24)
    if not u30 then
        u30 = true
        local u35 = u25.Wheel
        local v36 = u35:FindFirstChild("Spinning")
        local v37 = u27 and 1 or 0.8
        if v36 then
            v36.Looped = true
            v36.Volume = v37
            v36:Play()
        end
        local v38 = (p32 - 1) * -60 - (math.random() - 0.5) * 0.7 * 60
        local v39 = v38 + (u27 and 1 or 9) * 360
        local v40 = u27 and 0.5 or 5
        local u41 = nil
        local v43 = u2.PostSimulation:Connect(function() --[[Anonymous function at line 112]]
            --[[
            Upvalues:
                [1] = u35
                [2] = u41
                [3] = u25
                [4] = u4
            --]]
            local v42 = (u35.Rotation + 30) / 60 // 1
            if u41 ~= v42 then
                u41 = v42
                u25.Tick.Rotation = -40
                u4:Create(u25.Tick, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                    ["Rotation"] = 0
                }):Play()
            end
        end)
        local v44 = u4:Create(u35, TweenInfo.new(v40, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            ["Rotation"] = v39
        })
        if v36 then
            u4:Create(v36, TweenInfo.new(v40, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
                ["Volume"] = 0
            }):Play()
        end
        v44:Play()
        v44.Completed:Wait()
        v43:Disconnect()
        u35.Rotation = v38
        if v36 then
            v36:Stop()
            v36.Volume = v37
        end
        local v45 = p33 == true and u17.AltRewards[p32] or u17.Rewards[p32]
        local v46
        if v45.Type == "Cash-Pack" then
            local v47 = u18[v45.Index]
            if not u18 then
                return false
            end
            local v48 = v47.Value or 0
            local v49 = v34:Get("Rebirth") or 0
            if v49 > 0 then
                v48 = v48 * (v49 <= 1 and 1.5 or v49)
            end
            v46 = ("$%*"):format((u15:ToString(v48, 2)))
        else
            v46 = v45.Display
        end
        u7:Success((("You received %*!"):format(v46)))
        u30 = false
    end
end
function v31.SetupGalaxyWheel(_) --[[Anonymous function at line 165]]
    --[[
    Upvalues:
        [1] = u26
        [2] = u6
        [3] = u25
        [4] = u10
        [5] = u24
        [6] = u17
        [7] = u18
        [8] = u15
        [9] = u23
        [10] = u30
        [11] = u21
        [12] = u27
        [13] = u28
        [14] = u29
        [15] = u1
        [16] = u14
        [17] = u50
        [18] = u11
        [19] = u9
        [20] = u20
    --]]
    u26 = u6:Register("GalaxyWheel", u25, "TopQuint")
    u26:AttachCloseButton(u25.Close)
    u26:Close()
    local u51 = u10:Wait(u24)
    local function u68() --[[Anonymous function at line 173]]
        --[[
        Upvalues:
            [1] = u25
            [2] = u17
            [3] = u51
            [4] = u18
            [5] = u15
            [6] = u23
        --]]
        local v52 = u25.Wheel
        local v53 = v52.Items
        local v54 = v52.Names
        local v55 = v52.Odds
        for v56 = 1, #u17.Rewards do
            local v57 = u17.Rewards[v56]
            if v57 then
                if v57.Type == "Item" and u51:Get((("Items.%*"):format(v57.Index))) then
                    v57 = u17.AltRewards[v56]
                end
                local v58 = v53:FindFirstChild(v56)
                local v59 = v54:FindFirstChild(v56)
                local v60 = v55:FindFirstChild(v56)
                local v61 = ""
                local v62
                if v57.Type == "Cash-Pack" then
                    local v63 = u18[v57.Index].Value
                    local v64 = u51:Get("Rebirth") or 0
                    if v64 > 0 then
                        v63 = v63 * (v64 <= 1 and 1.5 or v64)
                    end
                    v61 = ("$%*"):format((u15:ToString(v63, 2)))
                    v62 = u23:GetProductInfo(v57.Index, "Product").Icon
                else
                    v62 = v57.Icon
                end
                local v65 = v57.Display
                local v66 = v61 == "" and v65 and v65 or v61
                local v67 = ("%*%%"):format(v57.Weight)
                v58.Image = v62
                v59.Text = v66
                v60.Text = v67
            end
        end
    end
    u68()
    u51:OnDictionaryInserted("Items", function(_, p69) --[[Anonymous function at line 226]]
        --[[
        Upvalues:
            [1] = u17
            [2] = u30
            [3] = u68
        --]]
        local v70 = false
        for v71 = 1, #u17.Rewards do
            local v72 = u17.Rewards[v71]
            if v72.Type == "Item" and p69 == v72.Index then
                v70 = true
                break
            end
        end
        if v70 then
            while u30 do
                task.wait()
            end
            u68()
        end
    end)
    local u73 = u25.FastSpin.Toggle
    local v74 = u21.new(u73)
    v74:Animate()
    v74.OnActivated:Connect(function() --[[Anonymous function at line 252]]
        --[[
        Upvalues:
            [1] = u27
            [2] = u73
        --]]
        u27 = not u27
        u73.Checkmark.Visible = u27
    end)
    u73.Checkmark.Visible = u27
    for _, u75 in u25.Buttons:GetChildren() do
        if u75:IsA("ImageButton") and u75.Name ~= "Spin" then
            local v76 = u21.new(u75)
            v76:Animate()
            v76.OnActivated:Connect(function() --[[Anonymous function at line 264]]
                --[[
                Upvalues:
                    [1] = u28
                    [2] = u75
                --]]
                u28:FireServer(u75:GetAttribute("ProductId"))
            end)
            local v77 = u23:GetProductInfo(u75:GetAttribute("ProductId"), "Product")
            u75.RbxAmount.Text = v77.PriceInRobux
        end
    end
    local u78 = u25.Buttons.Spin
    local v79 = u21.new(u78)
    v79:Animate()
    v79.OnActivated:Connect(function() --[[Anonymous function at line 275]]
        --[[
        Upvalues:
            [1] = u30
            [2] = u29
        --]]
        if u30 ~= true then
            u29:FireServer()
        end
    end)
    local function u98() --[[Anonymous function at line 281]]
        --[[
        Upvalues:
            [1] = u1
            [2] = u51
            [3] = u78
            [4] = u14
            [5] = u25
        --]]
        local v80 = 0
        if u1:GetAttribute("GalaxyEvent") then
            if u51:Get("GalaxySpinWheel.LastFreeClaimed") == u1:GetAttribute("GalaxyEventLastTime") then
                local v81 = u78.Main.Timer
                local v82 = "Free Spin in %*"
                local v83 = u14
                local v84 = workspace:GetServerTimeNow()
                local v85
                if v84 < 1755961200 then
                    v85 = 1755961200 - v84
                else
                    local v86 = os.date("!*t", workspace:GetServerTimeNow()).wday
                    local v87 = (v86 == 1 or v86 == 7) and 3600 or 10800
                    v85 = v87 - v84 % v87
                end
                v81.Text = v82:format((v83:D(v85)))
            else
                v80 = v80 + 1
                u78.Main.Timer.Text = "SPIN NOW"
            end
        else
            local v88 = u78.Main.Timer
            local v89 = "Free Spin in %*"
            local v90 = u14
            local v91 = workspace:GetServerTimeNow()
            local v92
            if v91 < 1755961200 then
                v92 = 1755961200 - v91
            else
                local v93 = os.date("!*t", workspace:GetServerTimeNow()).wday
                local v94 = (v93 == 1 or v93 == 7) and 3600 or 10800
                v92 = v94 - v91 % v94
            end
            v88.Text = v89:format((v90:D(v92)))
        end
        local v95 = v80 + u51:Get("GalaxySpinWheel.Spins")
        u78.Main.Spins.Text = v95 > 1 and ("Spins (%*)"):format(v95) or ("Spin (%*)"):format(v95)
        u78.Main.UIGradient.Enabled = v95 <= 0
        local v96 = workspace:GetServerTimeNow() - u51:Get("GalaxySpinWheel.LastDailyDiscount") >= 86400
        u25.Buttons.Buy1.Visible = not v96
        u25.Buttons.Buy1Discount.Visible = v96
        local v97 = u51:Get("GalaxySpinWheel.PaidSpins.x3") >= 5
        u25.Buttons.Buy10.Visible = v97
        u25.Buttons.Buy3.Visible = not v97
    end
    u29.OnClientEvent:Connect(function(p99, p100) --[[Anonymous function at line 317]]
        --[[
        Upvalues:
            [1] = u98
            [2] = u50
        --]]
        task.spawn(u98)
        u50(p99, p100)
    end)
    u11.Simple(1, u98)
    u9.observeTag("GalaxySpinWheel", function(p101) --[[Anonymous function at line 324]]
        --[[
        Upvalues:
            [1] = u20
        --]]
        local u102 = u20.new(p101)
        return function() --[[Anonymous function at line 326]]
            --[[
            Upvalues:
                [1] = u102
            --]]
            u102:Destroy()
        end
    end)
end
function v31.Start(p103) --[[Anonymous function at line 418]]
    p103:SetupGalaxyWheel()
end
return v31