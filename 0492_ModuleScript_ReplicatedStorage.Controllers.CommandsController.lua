--[[
  Extracted from: ReplicatedStorage.Controllers.CommandsController
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local u1 = game:GetService("ReplicatedStorage")
local u2 = require(u1.Packages.Net)
return {
	["Start"] = function(_) --[[Function name: Start, line 8]]
        --[[
        Upvalues:
            [1] = u2
            [2] = u1
        --]]
		if u2:Invoke("CommandsService/ViewCommands") then
			local u3 = require(u1.Packages.Conch)
			require(u1.Shared.ConchTypes)
			u3.initiate_default_lifecycle()
			u3.ui.bind_to(Enum.KeyCode.F2)
			u2:Connect("CommandsService/OpenCommandBar", function() --[[Anonymous function at line 19]]
                --[[
                Upvalues:
                    [1] = u3
                --]]
				u3.ui.opened(true)
			end)
		end
	end
}