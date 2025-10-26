--[[
  Extracted from: ReplicatedStorage.Controllers.SpawnEffectsController
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local v1 = game:GetService("ReplicatedStorage")
local u2 = require(v1.Packages.Net)
local u3 = require(v1.Shared.VFX)
return {
	["Start"] = function(_) --[[Function name: Start, line 7]]
        --[[
        Upvalues:
            [1] = u2
            [2] = u3
        --]]
		u2:RemoteEvent("GameService/SpawnEffect").OnClientEvent:Connect(function(p4, _) --[[Anonymous function at line 9]]
            --[[
            Upvalues:
                [1] = u3
            --]]
			local v5 = script[p4]:Clone()
			v5.Parent = workspace
			u3.emit(v5)
			for _, v6 in v5:GetDescendants() do
				if v6:IsA("Sound") then
					v6:Play()
				end
			end
			task.wait(6)
			v5:Destroy()
		end)
	end
}