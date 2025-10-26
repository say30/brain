--[[
  Extracted from: ReplicatedStorage.Packages.Gradients
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local v1 = game:GetService("RunService")
local v2 = game:GetService("ReplicatedStorage")
if v1:IsServer() then
    return {
        ["apply"] = function(u3, p4) --[[Function name: apply, line 7]]
            local u5 = ("Gradients_%*"):format(p4)
            u3:AddTag(u5)
            return function() --[[Anonymous function at line 10]]
                --[[
                Upvalues:
                    [1] = u3
                    [2] = u5
                --]]
                u3:RemoveTag(u5)
            end
        end
    }
end
local v6 = require(v2.Packages.Observers)
local u7 = {}
local u8 = {}
for _, v9 in script.Effects:GetChildren() do
    u7[v9.Name] = require(v9)
    u8[v9.Name] = {}
end
v1.PostSimulation:Connect(function(p10) --[[Anonymous function at line 59]]
    --[[
    Upvalues:
        [1] = u8
        [2] = u7
    --]]
    debug.profilebegin("Gradients:Simulate")
    for v11, v12 in u8 do
        if #v12 ~= 0 then
            debug.profilebegin(v11)
            debug.profilebegin("Simulate")
            local v13 = u7[v11].simulate(p10)
            debug.profileend()
            debug.profilebegin("Apply")
            for _, v14 in v12 do
                v14.main.Color = v13.main
                if v14.stroke and v13.stroke then
                    v14.stroke.Color = v13.stroke
                end
            end
            debug.profileend()
            debug.profileend()
        end
    end
    debug.profileend()
end)
local function u24(p15, p16) --[[Anonymous function at line 31]]
    --[[
    Upvalues:
        [1] = u7
        [2] = u8
    --]]
    local v17 = typeof(p16) == "string"
    assert(v17, "effect is not a string")
    local v18 = u7[p16]
    local u19 = assert(v18, "Effect not found").apply(p15, p16)
    local v20 = u8[p16]
    local v21 = {
        ["main"] = u19.main,
        ["stroke"] = u19.stroke
    }
    table.insert(v20, v21)
    local u22 = nil
    local function v23() --[[Anonymous function at line 43]]
        --[[
        Upvalues:
            [1] = u22
            [2] = u19
        --]]
        if u22 then
            u22:Disconnect()
            u22 = nil
        end
        if u19 and u19.cleanup then
            u19.cleanup()
            u19 = nil
        end
    end
    u22 = p15.Destroying:Connect(v23)
    return v23
end
for u25 in u8 do
    v6.observeTag(("Gradients_%*"):format(u25), function(p26) --[[Anonymous function at line 85]]
        --[[
        Upvalues:
            [1] = u24
            [2] = u25
        --]]
        return u24(p26, u25)
    end)
end
return {
    ["apply"] = u24
}