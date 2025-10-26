--[[
  Extracted from: ReplicatedStorage.Controllers.EventController.Events.Rainbow
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local v1 = game:GetService("ReplicatedStorage")
game:GetService("TweenService")
game:GetService("RunService")
game:GetService("Lighting")
game:GetService("Players")
require(v1.Shared.EventTypes)
local v2 = {}
require(v1.Controllers.AnimalController)
local u3 = require(v1.Controllers.SoundController)
require(v1.Controllers.EventController)
local u4 = require(v1.Controllers.CycleController)
local v5 = require(v1.Packages.Trove)
require(v1.Packages.Net)
local u6 = require(v1.Shared.VFX)
local _ = script.Name
local u7 = workspace.Events.Rainbow
local u8 = v5.new()
function v2.OnStart(_) --[[Anonymous function at line 25]]
    --[[
    Upvalues:
        [1] = u4
        [2] = u3
        [3] = u6
        [4] = u7
        [5] = u8
    --]]
    u4:Update()
    u3:UpdateOST()
    u6.emit(u7.Emit)
    u8:Add(task.spawn(function() --[[Anonymous function at line 31]]
        --[[
        Upvalues:
            [1] = u3
            [2] = u7
        --]]
        u3:PlaySound("Sounds.Sfx.RainbowActivatedEffect", u7.SoundParts.RainbowActivatedEffect.Position)
    end))
    u8:Add(task.spawn(function() --[[Anonymous function at line 35]]
        --[[
        Upvalues:
            [1] = u3
            [2] = u7
        --]]
        u3:PlaySound("Sounds.Sfx.RainbowMachineEnabled", u7.SoundParts.RainbowMachineEnabled.Position)
    end))
    u8:Add(task.spawn(function() --[[Anonymous function at line 39]]
        --[[
        Upvalues:
            [1] = u7
        --]]
        local v9 = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 1) })
        local v10 = u7.Enabled.RainbowMain.RainbowHandle.Wiggler.Attachment3:GetChildren()
        for _, v11 in v10 do
            v11.Transparency = v9
            v11.Enabled = true
        end
        local v12 = workspace:GetServerTimeNow()
        while true do
            local v13 = workspace:GetServerTimeNow()
            local v14 = (v13 - v12) % 3.5 / 3.5
            local v15 = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1 - v14, 1), NumberSequenceKeypoint.new(1, 0) })
            if v13 - v12 >= 3.5 then
                break
            end
            for _, v16 in v10 do
                v16.Transparency = v15
            end
            task.wait()
        end
        for _, v17 in v10 do
            v17.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 0) })
        end
    end))
    u6.enable(u7.Enabled)
    u8:Add(function() --[[Anonymous function at line 82]]
        --[[
        Upvalues:
            [1] = u6
            [2] = u7
        --]]
        u6.disable(u7.Enabled)
    end)
end
function v2.OnStop(_) --[[Anonymous function at line 87]]
    --[[
    Upvalues:
        [1] = u8
    --]]
    u8:Destroy()
end
function v2.OnLoad(_) --[[Anonymous function at line 91]] end
return v2