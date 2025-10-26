--[[
  Extracted from: ReplicatedStorage.Packages.FFlags
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: FFlags, time of decompilation: Sat Jul 12 14:20:53 2025 ]]
if game:GetService("RunService"):IsServer() then
    return require(script.Server);
else
    return require(script.Client);
end;