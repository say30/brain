--[[
  Extracted from: ReplicatedStorage.Packages.Conch.roblox_packages..pesde.centau_vide@0.3.1.vide.mount
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

if not game then script = require "test/relative-string" end

local root = require(script.Parent.root)
local apply = require(script.Parent.apply)

local function mount<T>(component: () -> T, target: Instance?): () -> ()
    return root(function()
        local result = component()
        if target then apply(target, { result }) end
    end)
end

return mount :: (<T>(component: () -> T, target: Instance) -> () -> ()) & ((component: () -> ()) -> () -> ())
