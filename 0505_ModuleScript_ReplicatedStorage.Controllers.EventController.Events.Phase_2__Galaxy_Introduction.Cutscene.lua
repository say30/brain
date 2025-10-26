--[[
  Extracted from: ReplicatedStorage.Controllers.EventController.Events.Phase 2: Galaxy Introduction.Cutscene
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local v1 = ""
for v2 = 1, 5 do
    local v3 = script[("Chunk_%*"):format((tostring(v2)))]
    v1 = v1 .. v3.Value
    v3.Value = ""
end
return v1