--[[
  Extracted from: ReplicatedStorage.Shared.VFX
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local v1 = game:GetService("ReplicatedStorage")
local u2 = game:GetService("RunService")
local u3 = require(v1.Packages.Observers)
local u4 = require(v1.Packages.Timer)
local u5 = require(v1.Shared.SharedEventUtils)
local u25 = {
	["Library"] = script.Library,
	["copy"] = function(p6, p7, p8) --[[Function name: copy, line 17]]
		if p8 == nil then
			if p6:IsA("Attachment") then
				p8 = workspace.Terrain
			else
				p8 = workspace.CurrentCamera
			end
		end
		local v9 = p6:Clone()
		if v9:IsA("Attachment") then
			if typeof(p7) ~= "CFrame" then
				p7 = CFrame.new(p7)
			end
			v9.WorldCFrame = p7
		elseif v9:IsA("PVInstance") then
			if typeof(p7) ~= "CFrame" then
				p7 = CFrame.new(p7)
			end
			v9:PivotTo(p7)
		else
			v9:Destroy()
			error("Can\'t move Container")
		end
		v9.Parent = p8
		return v9
	end,
	["weld"] = function(p10, p11) --[[Function name: weld, line 38]]
		local v12 = Instance.new("Weld")
		v12.Part0 = p10
		v12.Part1 = p11
		v12.Parent = p10
		return v12
	end,
	["weldPosition"] = function(u13, u14) --[[Function name: weldPosition, line 48]]
        --[[
        Upvalues:
            [1] = u2
            [2] = u5
        --]]
		u13.Anchored = true
		local u15 = u2.PostSimulation:Connect(function() --[[Anonymous function at line 51]]
            --[[
            Upvalues:
                [1] = u5
                [2] = u13
                [3] = u14
            --]]
			u5.pushPartCFrame(u13, CFrame.new(u14:GetPivot().Position))
		end)
		local u16 = u13.Destroying:Once(function() --[[Anonymous function at line 55]]
            --[[
            Upvalues:
                [1] = u15
            --]]
			u15:Disconnect()
		end)
		return function() --[[Anonymous function at line 59]]
            --[[
            Upvalues:
                [1] = u15
                [2] = u16
            --]]
			u15:Disconnect()
			u16:Disconnect()
		end
	end,
	["rescale"] = function(p17, p18) --[[Function name: rescale, line 66]]
		local v19 = p17.Parent
		local v20 = Instance.new("Model")
		p17.Parent = v20
		v20:ScaleTo(p18)
		p17.Parent = v19
	end,
	["enable"] = function(p21) --[[Function name: enable, line 75]]
		for _, v22 in p21:GetDescendants() do
			if v22:IsA("ParticleEmitter") then
				v22.Enabled = true
			elseif v22:IsA("Beam") then
				v22.Enabled = true
			end
		end
	end,
	["disable"] = function(p23) --[[Function name: disable, line 86]]
		for _, v24 in p23:GetDescendants() do
			if v24:IsA("ParticleEmitter") then
				v24.Enabled = false
			elseif v24:IsA("Beam") then
				v24.Enabled = false
			end
		end
	end
}
local function u30(u26) --[[Anonymous function at line 100]]
	local v27 = tonumber(u26:GetAttribute("EmitCount"))
	if not v27 then
		local v28 = u26.Name
		v27 = tonumber(v28) or 0
	end
	local v29 = tonumber(u26:GetAttribute("EmitDuration")) or 0
	u26:Emit(v27)
	if v29 > 0 then
		u26.Enabled = true
		task.delay(v29, function() --[[Anonymous function at line 107]]
            --[[
            Upvalues:
                [1] = u26
            --]]
			u26.Enabled = false
		end)
	end
end
function u25.emit(u31) --[[Anonymous function at line 113]]
    --[[
    Upvalues:
        [1] = u30
    --]]
	for _, v32 in u31:GetDescendants() do
		if v32:IsA("ParticleEmitter") then
			local v33 = v32:GetAttribute("EmitDelay")
			if v33 == nil then
				u30(v32)
			else
				task.delay(v33, u30, v32)
			end
		end
	end
	if u31:IsA("ParticleEmitter") then
		local v34 = u31:GetAttribute("EmitDelay")
		local u35 = u31:GetAttribute("EmitCount")
		if not u35 then
			local v36 = u31.Name
			u35 = tonumber(v36) or 0
		end
		if v34 ~= nil then
			task.delay(v34, function() --[[Anonymous function at line 134]]
                --[[
                Upvalues:
                    [1] = u31
                    [2] = u35
                --]]
				u31:Emit(u35)
			end)
			return
		end
		u31:Emit(u35)
	end
end
function u25.emitLoop(p37, p38) --[[Anonymous function at line 143]]
	p37:SetAttribute("LoopTimer", p38)
	p37:AddTag("EmitLoop")
end
if u2:IsClient() then
	u3.observeTag("EmitLoop", function(u39) --[[Anonymous function at line 149]]
        --[[
        Upvalues:
            [1] = u3
            [2] = u4
            [3] = u25
        --]]
		return u3.observeAttribute(u39, "LoopTimer", function(p40) --[[Anonymous function at line 150]]
            --[[
            Upvalues:
                [1] = u4
                [2] = u25
                [3] = u39
            --]]
			if type(p40) ~= "number" then
				return nil
			end
			local u41 = u4.Simple(p40, function() --[[Anonymous function at line 155]]
                --[[
                Upvalues:
                    [1] = u25
                    [2] = u39
                --]]
				u25.emit(u39)
			end, true)
			return function() --[[Anonymous function at line 159]]
                --[[
                Upvalues:
                    [1] = u41
                --]]
				u41:Disconnect()
			end
		end)
	end, { workspace })
end
return u25