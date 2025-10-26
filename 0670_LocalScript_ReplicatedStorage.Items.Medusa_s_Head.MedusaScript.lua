--[[
  Extracted from: ReplicatedStorage.Items.Medusa's Head.MedusaScript
  Class: LocalScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local u1 = game:GetService("RunService")
local u2 = game:GetService("TweenService")
game:GetService("StarterPlayer")
local v3 = game:GetService("ReplicatedStorage")
game:GetService("ServerScriptService")
local u4 = v3:WaitForChild("Models").ToolsExtras
local v5 = v3:WaitForChild("Packages")
local u6 = require(v5.Net)
local u7 = require(v5.Debounce)
local v8 = script.Parent
local u9 = v8.Parent.Parent
local u10 = nil
local u11 = nil
local u12 = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
local u13 = nil
local u14 = nil
local function u19(p15) --[[Anonymous function at line 42]]
    --[[
    Upvalues:
        [1] = u13
        [2] = u2
        [3] = u12
    --]]
    if u13 then
        local u16 = Instance.new("NumberValue", script)
        u16.Value = p15 and 0.0001 or 0.6
        u16.Changed:Connect(function(p17) --[[Anonymous function at line 49]]
            --[[
            Upvalues:
                [1] = u13
            --]]
            if u13 then
                u13:ScaleTo(p17)
            end
        end)
        local v18 = u2:Create(u16, u12, {
            ["Value"] = p15 and 0.6 or 0.0001
        })
        v18:Play()
        v18.Completed:Connect(function() --[[Anonymous function at line 57]]
            --[[
            Upvalues:
                [1] = u16
            --]]
            u16:Destroy()
        end)
        v18.Completed:Wait()
    end
end
local function u21() --[[Anonymous function at line 63]]
    --[[
    Upvalues:
        [1] = u10
        [2] = u11
        [3] = u9
    --]]
    if not (u10 and u11) then
        local v20 = u9.Character:WaitForChild("Humanoid"):WaitForChild("Animator")
        u10 = v20:LoadAnimation(script.Idle)
        u10.Priority = Enum.AnimationPriority.Action
        u10.Looped = true
        u11 = v20:LoadAnimation(script.Attack)
        u11.Priority = Enum.AnimationPriority.Action4
        u11.Looped = false
    end
end
v8.Activated:Connect(function() --[[Anonymous function at line 82]]
    --[[
    Upvalues:
        [1] = u6
        [2] = u11
        [3] = u7
        [4] = u9
    --]]
    local v22, v23 = pcall(function() --[[Anonymous function at line 87]]
        --[[
        Upvalues:
            [1] = u6
        --]]
        return u6:Invoke("UseItem")
    end)
    if v22 and type(v23) == "number" then
        if u11 then
            u11:Play()
        end
        u7(("ItemUse/MedusaAttackAnimation/%*"):format(u9.Name), v23 - workspace:GetServerTimeNow())
    end
end)
v8.Equipped:Connect(function() --[[Anonymous function at line 102]]
    --[[
    Upvalues:
        [1] = u13
        [2] = u14
        [3] = u21
        [4] = u10
        [5] = u4
        [6] = u9
        [7] = u19
        [8] = u1
    --]]
    if u13 then
        u13:Destroy()
    end
    if u14 then
        u14:Disconnect()
    end
    u21()
    u10:Play()
    u13 = u4.Ring:Clone()
    u13.Name = ("%*.Ring"):format(u9.Name)
    u13:PivotTo(u9.Character:GetPivot())
    u13.Parent = workspace
    u19(true)
    local v24 = u9.Character
    if v24 then
        v24 = v24:FindFirstChildOfClass("Humanoid")
    end
    if v24 then
        v24.Died:Once(function() --[[Anonymous function at line 30]]
            --[[
            Upvalues:
                [1] = u9
                [2] = u14
            --]]
            local v25 = workspace:FindFirstChild((("%*.Ring"):format(u9.Name)))
            if v25 then
                v25:Destroy()
            end
            if u14 then
                u14:Disconnect()
            end
        end)
    end
    u14 = u1.Heartbeat:Connect(function() --[[Anonymous function at line 121]]
        --[[
        Upvalues:
            [1] = u9
            [2] = u13
        --]]
        local v26 = u9.Character
        if v26 then
            v26 = v26:FindFirstChild("HumanoidRootPart")
        end
        if v26 and v26.Parent then
            if u13 then
                u13:PivotTo(v26:GetPivot() * CFrame.new(0, -3, 0))
            end
        end
    end)
end)
v8.Unequipped:Connect(function() --[[Anonymous function at line 133]]
    --[[
    Upvalues:
        [1] = u14
        [2] = u19
        [3] = u13
        [4] = u10
        [5] = u11
    --]]
    if u14 then
        u14:Disconnect()
        u14 = nil
    end
    u19(false)
    if u14 then
        u14:Disconnect()
        u14 = nil
    end
    if u13 then
        u13:Destroy()
        u13 = nil
    end
    if u10 and u10.IsPlaying then
        u10:Stop()
    end
    if u11 and u11.IsPlaying then
        u11:Stop()
    end
end)