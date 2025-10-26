--[[
  Extracted from: ReplicatedStorage.Controllers.EventController.Events.Phase 3: Sammy's Base
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local v1 = game:GetService("ReplicatedStorage")
game:GetService("Lighting")
game:GetService("Players")
game:GetService("Debris")
require(v1.Shared.EventTypes)
local v2 = {}
require(v1.Packages.Net)
local v3 = require(v1.Packages.Trove)
local u4 = require(v1.Packages.Observers)
local u5 = require(v1.Packages.CreateTween)
local u6 = require(script.Parent.Parent)
local u7 = script.Name
local u8 = v3.new()
function v2.OnStart(_) --[[Anonymous function at line 20]]
    --[[
    Upvalues:
        [1] = u6
        [2] = u7
        [3] = u8
        [4] = u4
        [5] = u5
    --]]
    local v9 = u6:GetActiveEventData(u7)
    assert(v9)
    u8:Add(u4.observeTag("SammyBaseStep", function(p10) --[[Anonymous function at line 24]]
        --[[
        Upvalues:
            [1] = u5
        --]]
        local v11 = p10:GetAttribute("Index") or 0
        local v12 = p10.Position
        local v13 = p10.Position
        local v14 = -(v11 % 1 * 2 - 1) * 2
        p10.Position = v13 + Vector3.new(v14, 0, 0)
        u5(p10, TweenInfo.new(0.5), {
            ["Transparency"] = 0,
            ["Position"] = v12
        })
        return nil
    end))
end
function v2.OnStop(_) --[[Anonymous function at line 37]]
    --[[
    Upvalues:
        [1] = u8
    --]]
    u8:Destroy()
end
function v2.OnLoad(_) --[[Anonymous function at line 41]] end
return v2