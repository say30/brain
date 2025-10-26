--[[
  Extracted from: ReplicatedStorage.Datas.AdminCommands.inverse
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: inverse, time of decompilation: Sat Jul 12 14:22:11 2025 ]]
local l_Players_0 = game:GetService("Players");
local l_ReplicatedStorage_0 = game:GetService("ReplicatedStorage");

return {
	name = "inverse", 
	icon = "rbxassetid://86269342686094", 
	cooldown = 60, 
	description = "Your controls are inverted for 10 seconds!", 
	effects = {
		Victim = function() --[[ Line: 14 ]]
			-- upvalues: l_Players_0 (copy)
			local l_PlayerScripts_0 = l_Players_0.LocalPlayer:WaitForChild("PlayerScripts");
			local l_Controls_0 = require(l_PlayerScripts_0:WaitForChild("PlayerModule")):GetControls();
			local originalMoveFunction = l_Controls_0.moveFunction;
			l_Controls_0.moveFunction = function(v6, v7, v8) --[[ Line: 22 ]]
				v6:Move(-v7, v8);
			end;
			task.delay(10, function() --[[ Line: 26 ]]
				-- upvalues: l_Controls_0 (copy), originalMoveFunction (copy)
				l_Controls_0.moveFunction = originalMoveFunction;
			end);
		end
	}
};