--[[
  Extracted from: ReplicatedStorage.Controllers.EventController.Events.Molten
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local u1 = game:GetService("ReplicatedStorage")
local u2 = game:GetService("TweenService")
game:GetService("RunService")
local u3 = game:GetService("Lighting")
game:GetService("Players")
require(u1.Shared.EventTypes)
local v4 = {}
local u5 = require(u1.Controllers.EffectController)
local u6 = require(u1.Controllers.SoundController)
local u7 = require(u1.Controllers.EventController)
local u8 = require(u1.Controllers.CycleController)
local u9 = require(u1.Shared.ShakePresets)
require(u1.Packages.Observers)
local v10 = require(u1.Packages.Trove)
require(u1.Packages.Net)
local u11 = require(u1.Shared.VFX)
local u12 = script.Name
local u13 = v10.new()
function v4.OnStart(_) --[[Anonymous function at line 25]]
    --[[
    Upvalues:
        [1] = u7
        [2] = u12
        [3] = u6
        [4] = u1
        [5] = u13
        [6] = u2
        [7] = u9
        [8] = u11
        [9] = u5
        [10] = u3
        [11] = u8
    --]]
	local v14 = u7:GetActiveEventData(u12)
	assert(v14)
	task.spawn(function() --[[Anonymous function at line 29]]
        --[[
        Upvalues:
            [1] = u6
        --]]
		u6:PlaySound("Sounds.Events.Molten.LavaActivate")
	end)
	local u15 = u1.Models.Events.Molten.Craters:Clone()
	u15.Parent = workspace
	local u16 = u15:GetChildren()
	table.sort(u16, function(p17, p18) --[[Anonymous function at line 41]]
		local v19 = p17.Name
		local v20 = tonumber(v19)
		local v21 = p18.Name
		return v20 < tonumber(v21)
	end)
	local u22 = {}
	for _, v23 in u16 do
		u22[v23] = v23.PrimaryPart:GetPivot()
	end
	u13:Add(function() --[[Anonymous function at line 50]]
        --[[
        Upvalues:
            [1] = u16
            [2] = u2
            [3] = u22
            [4] = u15
        --]]
		for _, v24 in u16 do
			local v25 = v24:GetExtentsSize()
			local v26 = u2
			local v27 = v24.PrimaryPart
			local v28 = TweenInfo.new(1 + math.random() + math.random(), Enum.EasingStyle.Quad, Enum.EasingDirection.In)
			local v29 = {}
			local v30 = u22[v24]
			local v31 = v25.Y * 1.1
			v29.CFrame = v30 - Vector3.new(0, v31, 0)
			v26:Create(v27, v28, v29):Play()
		end
		task.wait(3)
		u15:Destroy()
	end)
	local u32 = u9.BumpS:Clone()
	u13:Add(u32)
	u32.Sustain = true
	u13:Add(u9.BindShakeToCamera(u32, workspace.CurrentCamera))
	u32:Start()
	local v33 = v14.startedAt + 4 - workspace:GetServerTimeNow()
	u13:Add(task.delay(v33, function() --[[Anonymous function at line 72]]
        --[[
        Upvalues:
            [1] = u32
        --]]
		u32:StopSustain()
	end))
	local u34 = u13:Clone(script.MoltenWeather)
	u11.disable(u34)
	u34.Parent = workspace
	u13:Add(task.delay(v33, function() --[[Anonymous function at line 80]]
        --[[
        Upvalues:
            [1] = u5
            [2] = u3
            [3] = u13
            [4] = u11
            [5] = u34
        --]]
		u5:Activate("Blink")
		local u35 = u3:FindFirstChild("Atmosphere")
		if u35 then
			u35.Parent = script
			u13:Add(function() --[[Anonymous function at line 86]]
                --[[
                Upvalues:
                    [1] = u35
                    [2] = u3
                --]]
				u35.Parent = u3
			end)
		end
		u13:Clone(script.AtmosphereMolten).Parent = u3
		local u36 = u3:FindFirstChild("Cartoon")
		if u36 then
			u36.Parent = script
			u13:Add(function() --[[Anonymous function at line 96]]
                --[[
                Upvalues:
                    [1] = u36
                    [2] = u3
                --]]
				u36.Parent = u3
			end)
		end
		u13:Clone(script.SkyMolten).Parent = u3
		u11.enable(u34)
	end))
	u13:Add(function() --[[Anonymous function at line 106]]
        --[[
        Upvalues:
            [1] = u5
        --]]
		u5:Activate("Blink")
	end)
	u5:Run("MoltenEvent", "GrassRecolor")
	u13:Add(function() --[[Anonymous function at line 111]]
        --[[
        Upvalues:
            [1] = u5
        --]]
		u5:Stop("MoltenEvent", "GrassRecolor")
	end)
	local v37 = Random.new()
	for _, v38 in ipairs(u16) do
		local v39 = v38:GetExtentsSize()
		local v40 = v38:GetPrimaryPartCFrame()
		v38:PivotTo(v40 * CFrame.new(0, -v39.Y * 1.1, 0))
		u2:Create(v38.PrimaryPart, TweenInfo.new(v37:NextNumber(3, 7), Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			["CFrame"] = v40
		}):Play()
	end
	u8:Update()
	u6:UpdateOST()
end
function v4.OnStop(_) --[[Anonymous function at line 135]]
    --[[
    Upvalues:
        [1] = u13
    --]]
	u13:Destroy()
end
function v4.OnLoad(_) --[[Anonymous function at line 139]] end
return v4