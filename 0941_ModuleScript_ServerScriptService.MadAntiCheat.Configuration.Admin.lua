--[[
  Extracted from: ServerScriptService.MadAntiCheat.Configuration.Admin
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Madonox
-- 2022

return {
	["groups"] = {
		[1] = {}; -- [GroupID] = {insert rank IDs}
	};
	["users"] = {
		1; -- User IDs, or User Names
	};
	["externalAdmins"] = { -- If users admined in external admin modules get admin in MadAntiCheat.
		["adonis"] = true;
	}
}