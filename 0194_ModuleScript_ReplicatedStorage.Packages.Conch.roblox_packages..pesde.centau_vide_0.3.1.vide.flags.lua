--[[
  Extracted from: ReplicatedStorage.Packages.Conch.roblox_packages..pesde.centau_vide@0.3.1.vide.flags
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local function inline_test(): string
    return debug.info(1, "n")
end

local is_O2 = inline_test() ~= "inline_test"

return { strict = not is_O2, batch = false }
