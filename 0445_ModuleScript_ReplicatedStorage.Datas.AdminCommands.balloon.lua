--[[
  Extracted from: ReplicatedStorage.Datas.AdminCommands.balloon
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: balloon, time of decompilation: Sat Jul 12 14:22:11 2025 ]]
return {
    name = "balloon", 
    icon = "rbxassetid://122227641631583", 
    cooldown = 30, 
    description = "You will jump higher for 15 seconds!", 
    effects = {
        Victim = function() --[[ Line: 11 ]]
            workspace.Gravity = 29.429999999999996;
            task.delay(15, function() --[[ Line: 14 ]]
                workspace.Gravity = 196.2;
            end);
        end
    }
};