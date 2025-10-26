--[[
  Extracted from: ReplicatedStorage.Shared.SharedEventUtils
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("RunService")
local u3 = require(v1.Utils.MathUtils)
require(v1.Packages.Trove)
local u4 = 0
local u5 = {}
local u6 = {}
local u7 = CFrame.new(-410.752, -9.782, 59.406):Inverse()
local function v10(p8, p9) --[[Anonymous function at line 17]]
    --[[
    Upvalues:
        [1] = u4
        [2] = u5
        [3] = u6
    --]]
	u4 = u4 + 1
	u5[u4] = p8
	u6[u4] = p9
end
local function v12(p11) --[[Anonymous function at line 23]]
    --[[
    Upvalues:
        [1] = u3
        [2] = u7
    --]]
	return u3.isPointInVolume_direct(p11, u7, Vector3.new(20, 661.5, 401))
end
local function v13() --[[Anonymous function at line 27]]
    --[[
    Upvalues:
        [1] = u5
        [2] = u6
        [3] = u4
    --]]
	debug.profilebegin("SharedEventUtils:StepParts")
	workspace:BulkMoveTo(u5, u6, Enum.BulkMoveMode.FireCFrameChanged)
	u4 = 0
	table.clear(u5)
	table.clear(u6)
	debug.profileend()
end
local function v19(u14, p15, p16) --[[Anonymous function at line 36]]
	local u17 = p15:LoadAnimation(p16)
	local function u18() --[[Anonymous function at line 39]]
        --[[
        Upvalues:
            [1] = u17
        --]]
		u17:Stop(0)
		u17:Destroy()
	end
	u14:Add(u18)
	return u17, function() --[[Anonymous function at line 45]]
        --[[
        Upvalues:
            [1] = u14
            [2] = u18
        --]]
		u14:Remove(u18)
	end
end
if v2:IsServer() then
	v2.PostSimulation:Connect(v13)
else
	v2.PreRender:Connect(v13)
end
return {
	["pushPartCFrame"] = v10,
	["isPointInCarpet"] = v12,
	["loadAnimation"] = v19
}