--[[
  Extracted from: ReplicatedStorage.Controllers.MoltenEventController
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
local u17 = require(v16.MoltenSpinWheel)
local u18 = require(v16.Shop)
local v19 = u1:WaitForChild("Classes")
local u20 = require(script.MoltenSpinWheel)
local u21 = require(v19.AnimatedButton)
local v22 = u1:WaitForChild("Shared")
local u23 = require(v22.Marketplace)
local u24 = v3.LocalPlayer
local u25 = u24.PlayerGui:WaitForChild("MoltenWheel").MoltenWheel
local u26 = nil
local u27 = false
local u28 = false
local u29 = v12:RemoteEvent("ShopService/Purchase")
local u30 = v12:RemoteEvent("MoltenEventService/Spin")
v12:RemoteFunction("MoltenEventService/RequestBuy")
local u31 = false
local v32 = {}
local function u51(p33, p34) --[[Anonymous function at line 83]]
    --[[
    Upvalues:
        [1] = u10
        [2] = u24
        [3] = u31
        [4] = u25
        [5] = u28
        [6] = u2
        [7] = u4
        [8] = u17
        [9] = u18
        [10] = u15
        [11] = u7
    --]]
    local v35 = u10:Wait(u24)
    if not u31 then
        u31 = true
        local u36 = u25.Wheel
        local v37 = u36:FindFirstChild("Spinning")
        local v38 = u28 and 1 or 0.8
        if v37 then
            v37.Looped = true
            v37.Volume = v38
            v37:Play()
        end
        local v39 = (p33 - 1) * -60 - (math.random() - 0.5) * 0.7 * 60
        local v40 = v39 + (u28 and 1 or 9) * 360
        local v41 = u28 and 0.5 or 5
        local u42 = nil
        local v44 = u2.PostSimulation:Connect(function() --[[Anonymous function at line 108]]
            --[[
            Upvalues:
                [1] = u36
                [2] = u42
                [3] = u25
                [4] = u4
            --]]
            local v43 = (u36.Rotation + 30) / 60 // 1
            if u42 ~= v43 then
                u42 = v43
                u25.Tick.Rotation = -40
                u4:Create(u25.Tick, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                    ["Rotation"] = 0
                }):Play()
            end
        end)
        local v45 = u4:Create(u36, TweenInfo.new(v41, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            ["Rotation"] = v40
        })
        if v37 then
            u4:Create(v37, TweenInfo.new(v41, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
                ["Volume"] = 0
            }):Play()
        end
        v45:Play()
        v45.Completed:Wait()
        v44:Disconnect()
        u36.Rotation = v39
        if v37 then
            v37:Stop()
            v37.Volume = v38
        end
        local v46 = p34 == true and u17.AltRewards[p33] or u17.Rewards[p33]
        local v47
        if v46.Type == "Cash-Pack" then
            local v48 = u18[v46.Index]
            if not u18 then
                return false
            end
            local v49 = v48.Value or 0
            local v50 = v35:Get("Rebirth") or 0
            if v50 > 0 then
                v49 = v49 * (v50 <= 1 and 1.5 or v50)
            end
            v47 = ("$%*"):format((u15:ToString(v49, 2)))
        else
            v47 = v46.Display
        end
        u7:Success((("You received %*!"):format(v47)))
        u31 = false
    end
end
function v32.SetupMoltenWheel(_) --[[Anonymous function at line 161]]
    --[[
    Upvalues:
        [1] = u26
        [2] = u6
        [3] = u25
        [4] = u10
        [5] = u24
        [6] = u27
        [7] = u17
        [8] = u18
        [9] = u15
        [10] = u23
        [11] = u31
        [12] = u21
        [13] = u28
        [14] = u29
        [15] = u30
        [16] = u1
        [17] = u14
        [18] = u51
        [19] = u11
        [20] = u9
        [21] = u20
    --]]
    u26 = u6:Register("MoltenWheel", u25, "TopQuint")
    u26:AttachCloseButton(u25.Close)
    u26:Close()
    local u52 = u10:Wait(u24)
    local function u54() --[[Anonymous function at line 168]]
        --[[
        Upvalues:
            [1] = u25
            [2] = u27
        --]]
        for _, v53 in u25.Wheel.Odds:GetChildren() do
            if v53:IsA("TextLabel") then
                v53.Visible = u27
            end
        end
    end
    local function u71() --[[Anonymous function at line 178]]
        --[[
        Upvalues:
            [1] = u25
            [2] = u17
            [3] = u52
            [4] = u18
            [5] = u15
            [6] = u23
        --]]
        local v55 = u25.Wheel
        local v56 = v55.Items
        local v57 = v55.Names
        local v58 = v55.Odds
        for v59 = 1, #u17.Rewards do
            local v60 = u17.Rewards[v59]
            if v60 then
                if v60.Type == "Item" and u52:Get((("Items.%*"):format(v60.Index))) then
                    v60 = u17.AltRewards[v59]
                end
                local v61 = v56:FindFirstChild(v59)
                local v62 = v57:FindFirstChild(v59)
                local v63 = v58:FindFirstChild(v59)
                local v64 = ""
                local v65
                if v60.Type == "Cash-Pack" then
                    local v66 = u18[v60.Index].Value
                    local v67 = u52:Get("Rebirth") or 0
                    if v67 > 0 then
                        v66 = v66 * (v67 <= 1 and 1.5 or v67)
                    end
                    v64 = ("$%*"):format((u15:ToString(v66, 2)))
                    v65 = u23:GetProductInfo(v60.Index, "Product").Icon
                else
                    v65 = v60.Icon
                end
                local v68 = v60.Display
                local v69 = v64 == "" and v68 and v68 or v64
                local v70 = ("%*%%"):format(v60.Weight)
                v61.Image = v65
                v62.Text = v69
                v63.Text = v70
            end
        end
    end
    u71()
    u54()
    u52:OnDictionaryInserted("Items", function(_, p72) --[[Anonymous function at line 232]]
        --[[
        Upvalues:
            [1] = u17
            [2] = u31
            [3] = u71
        --]]
        local v73 = false
        for v74 = 1, #u17.Rewards do
            local v75 = u17.Rewards[v74]
            if v75.Type == "Item" and p72 == v75.Index then
                v73 = true
                break
            end
        end
        if v73 then
            while u31 do
                task.wait()
            end
            u71()
        end
    end)
    local u76 = u25.FastSpin.Toggle
    local v77 = u21.new(u76)
    v77:Animate()
    v77.OnActivated:Connect(function() --[[Anonymous function at line 258]]
        --[[
        Upvalues:
            [1] = u28
            [2] = u76
        --]]
        u28 = not u28
        u76.Checkmark.Visible = u28
    end)
    u76.Checkmark.Visible = u28
    for _, u78 in u25.Buttons:GetChildren() do
        if u78:IsA("ImageButton") and u78.Name ~= "Spin" then
            local v79 = u21.new(u78)
            v79:Animate()
            v79.OnActivated:Connect(function() --[[Anonymous function at line 270]]
                --[[
                Upvalues:
                    [1] = u29
                    [2] = u78
                --]]
                u29:FireServer(u78:GetAttribute("ProductId"))
            end)
            local v80 = u23:GetProductInfo(u78:GetAttribute("ProductId"), "Product")
            u78.RbxAmount.Text = v80.PriceInRobux
        end
    end
    local u81 = u25.Buttons.Spin
    local v82 = u21.new(u81)
    v82:Animate()
    v82.OnActivated:Connect(function() --[[Anonymous function at line 281]]
        --[[
        Upvalues:
            [1] = u31
            [2] = u30
        --]]
        if u31 ~= true then
            u30:FireServer()
        end
    end)
    local v83 = u25.TogglePercentage
    local v84 = u21.new(v83)
    v84:Animate()
    v84.OnActivated:Connect(function() --[[Anonymous function at line 290]]
        --[[
        Upvalues:
            [1] = u27
            [2] = u54
        --]]
        u27 = not u27
        u54()
    end)
    local function u97() --[[Anonymous function at line 296]]
        --[[
        Upvalues:
            [1] = u1
            [2] = u52
            [3] = u81
            [4] = u14
            [5] = u25
        --]]
        local v85 = 0
        if u1:GetAttribute("MoltenEvent") then
            if u52:Get("MoltenSpinWheel.LastFreeClaimed") == u1:GetAttribute("MoltenEventLastTime") then
                local v86 = u81.Main.Timer
                local v87 = u14
                local v88 = os.date("!*t", workspace:GetServerTimeNow()).wday
                local v89 = (v88 == 1 or v88 == 7) and 3600 or 10800
                v86.Text = ("Free Spin in %*"):format((v87:D(v89 - workspace:GetServerTimeNow() % v89)))
            else
                v85 = v85 + 1
                u81.Main.Timer.Text = "SPIN NOW"
            end
        else
            local v90 = u81.Main.Timer
            local v91 = u14
            local v92 = os.date("!*t", workspace:GetServerTimeNow()).wday
            local v93 = (v92 == 1 or v92 == 7) and 3600 or 10800
            v90.Text = ("Free Spin in %*"):format((v91:D(v93 - workspace:GetServerTimeNow() % v93)))
        end
        local v94 = v85 + u52:Get("MoltenSpinWheel.Spins")
        u81.Main.Spins.Text = v94 > 1 and ("Spins (%*)"):format(v94) or ("Spin (%*)"):format(v94)
        u81.Main.UIGradient.Enabled = v94 <= 0
        local v95 = workspace:GetServerTimeNow() - u52:Get("MoltenSpinWheel.LastDailyDiscount") >= 86400
        u25.Buttons.Buy1.Visible = not v95
        u25.Buttons.Buy1Discount.Visible = v95
        local v96 = u52:Get("MoltenSpinWheel.PaidSpins.x3") >= 5
        u25.Buttons.Buy10.Visible = v96
        u25.Buttons.Buy3.Visible = not v96
    end
    u30.OnClientEvent:Connect(function(p98, p99) --[[Anonymous function at line 332]]
        --[[
        Upvalues:
            [1] = u97
            [2] = u51
        --]]
        task.spawn(u97)
        u51(p98, p99)
    end)
    u11.Simple(1, u97)
    u9.observeTag("MoltenSpinWheel", function(p100) --[[Anonymous function at line 339]]
        --[[
        Upvalues:
            [1] = u20
        --]]
        local u101 = u20.new(p100)
        return function() --[[Anonymous function at line 341]]
            --[[
            Upvalues:
                [1] = u101
            --]]
            u101:Destroy()
        end
    end)
end
function v32.Start(p102) --[[Anonymous function at line 433]]
    p102:SetupMoltenWheel()
end
return v32