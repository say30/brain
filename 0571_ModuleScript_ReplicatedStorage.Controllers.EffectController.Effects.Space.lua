--[[
  Extracted from: ReplicatedStorage.Controllers.EffectController.Effects.Space
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local u1 = game:GetService("ReplicatedStorage")
game:GetService("TweenService")
require(script:FindFirstAncestor("Effects").Parent.Types)
local v2 = {}
local u3 = require(u1.Controllers.EffectController)
local u4 = require(u1.Controllers.SoundController)
local u5 = require(u1.Controllers.CycleController)
local v6 = require(u1.Packages.Trove)
require(u1.Packages.Net)
local _ = script.Name
local u7 = v6.new()
local _ = workspace.CurrentCamera
function v2.OnStart(_) --[[Anonymous function at line 19]]
    --[[
    Upvalues:
        [1] = u1
        [2] = u7
        [3] = u4
        [4] = u5
        [5] = u3
    --]]
    u1:SetAttribute("Effect_Space", true)
    u7:Add(function() --[[Anonymous function at line 21]]
        --[[
        Upvalues:
            [1] = u1
        --]]
        u1:SetAttribute("Effect_Space", nil)
    end)
    u4:UpdateOST()
    u5:Update()
    local u8 = u7:Extend()
    local u9 = true
    u7:Add(function() --[[Anonymous function at line 33]]
        --[[
        Upvalues:
            [1] = u9
        --]]
        u9 = false
    end)
    local u10 = nil
    local function v15() --[[Anonymous function at line 39]]
        --[[
        Upvalues:
            [1] = u1
            [2] = u9
            [3] = u10
            [4] = u3
            [5] = u4
            [6] = u5
            [7] = u8
        --]]
        local v11 = u1:GetAttribute("NyanCatsEvent")
        local v12
        if u9 then
            if v11 then
                v12 = script.Nyan
            else
                v12 = script.Space
            end
        else
            v12 = nil
        end
        if v12 ~= u10 then
            u10 = v12
            u3:Activate("Blink")
            u4:UpdateOST()
            u5:Update()
            u8:Destroy()
            if v12 then
                local v13 = u8:Clone(v12)
                v13.Parent = workspace
                v13.spacemeshbg.Transparency = 0
                for _, v14 in v13:GetDescendants() do
                    if v14:IsA("ParticleEmitter") or v14:IsA("Beam") then
                        v14.Enabled = true
                    end
                end
            end
        end
    end
    u1:GetAttributeChangedSignal("NyanCatsEvent"):Connect(v15)
    u7:Add(task.spawn(v15))
    u7:Add(v15)
end
function v2.OnStop(_) --[[Anonymous function at line 75]]
    --[[
    Upvalues:
        [1] = u7
    --]]
    u7:Destroy()
end
function v2.OnLoad(_) --[[Anonymous function at line 79]] end
return v2