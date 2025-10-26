--[[
  Extracted from: ReplicatedStorage.Packages.Conch.roblox_packages..pesde.centau_vide@0.3.1.vide.read
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

if not game then script = require "test/relative-string" end

local function read<T>(value: T | () -> T): T
    return if type(value) == "function" then value() else value
end

return read
