--[[
  Extracted from: ReplicatedStorage.Controllers.EventController.ClientEventUtils
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Thanks For Angelus Decompiles --> https://discord.gg/CYXme7yEG9

-- Decompiled with Velocity Script Decompiler
local v1 = game:GetService("ReplicatedStorage")
game:GetService("RunService")
local v_u_2 = require(v1.Controllers.AnimalController)
return {
    ["getAnimalPosition"] = function(p3, p4)
        -- upvalues: (copy) v_u_2
        local v5 = v_u_2:GetAnimals()[p3]
        if v5 then
            local v6 = v5.AnimalModel:GetPivot().Position
            if p4 and p4.top then
                local v7 = v5.AnimalModel:GetExtentsSize().Y * 0.5
                return v6 + Vector3.new(0, v7, 0)
            else
                if p4 and p4.bottom then
                    local v8 = v5.AnimalModel:GetExtentsSize().Y * 0.5
                    v6 = v6 - Vector3.new(0, v8, 0)
                end
                return v6
            end
        else
            return Vector3.new(0, 0, 0)
        end
    end
}