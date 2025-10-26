--[[
  Extracted from: ReplicatedStorage.Packages.Conch.roblox_packages..pesde.centau_vide@0.3.1.vide.changed
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

if not game then script = require "test/relative-string" end

local action = require(script.Parent.action)()
local cleanup = require(script.Parent.cleanup)

local function changed<T>(property: string, callback: (T) -> ())
    return action(function(instance)
        local con = instance:GetPropertyChangedSignal(property):Connect(function()
            callback((instance :: any)[property])
        end)

        cleanup(function()
            con:Disconnect()
        end)

        callback((instance :: any)[property])
    end)
end

return changed
