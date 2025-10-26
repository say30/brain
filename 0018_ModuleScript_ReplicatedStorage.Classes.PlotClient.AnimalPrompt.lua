--[[
  Extracted from: ReplicatedStorage.Classes.PlotClient.AnimalPrompt
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Thanks For Angelus Decompiles --> https://discord.gg/CYXme7yEG9

-- Decompiled with Velocity Script Decompiler
local v1 = game:GetService("ReplicatedStorage")
game:GetService("RunService")
local v2 = v1:WaitForChild("Packages")
local v_u_3 = require(v2.Trove)
local v4 = require(v2.Net)
local v5 = v1:WaitForChild("Utils")
local v_u_6 = require(v5.NumberUtils)
local v7 = v1:WaitForChild("Shared")
local v_u_8 = require(v7.Animals)
local v_u_9 = Instance.new("RemoteEvent").FireServer
local v_u_10 = v4:RemoteEvent("d8276bf9-acc4-4361-9149-ffd91b3fed52")
local v_u_11 = {}
v_u_11.__index = v_u_11
function v_u_11.GetState(p12)
	return p12.State
end
function v_u_11.SetState(p13, p14, p15)
	-- upvalues: (copy) v_u_6, (copy) v_u_8
	p13.State = p14
	local v16 = p13.ProximityPrompt
	local v17 = p13.AnimalIndex
	v16.ObjectText = (not v17 or (string.find(v17, "None") or p14 == "Sell")) and "" or v17
	v16.Enabled = p14 ~= "None"
	v16:SetAttribute("State", p14)
	if p14 == "Sell" then
		v16.ActionText = not v17 and "" or ("Sell: $%*"):format((v_u_6:ToString(v_u_8:GetSellValue(v17), 2)))
	elseif p14 == "Open" then
		v16.ActionText = "Open"
	elseif p14 == "Steal" then
		v16.ActionText = "Steal"
	elseif p14 == "Grab" then
		v16.ActionText = "Grab"
	elseif p14 == "Place" then
		v16.ActionText = "Place"
	elseif p14 == "FuseMachineReturn" then
		v16.ActionText = "Return"
	end
	if p15 then
		p13.TargetCallback = p15
	end
end
function v_u_11.SetCallback(p18, p19)
	p18.TargetCallback = p19
end
function v_u_11.new(p20, p21, p22, p23)
	-- upvalues: (copy) v_u_11, (copy) v_u_3, (copy) v_u_9, (copy) v_u_10
	local v24 = v_u_11
	local v_u_25 = setmetatable({}, v24)
	v_u_25.Index = p20
	v_u_25.AnimalIndex = p21
	v_u_25.Collector = v_u_3.new()
	local v_u_26 = Instance.new("ProximityPrompt")
	v_u_26.HoldDuration = 1.5
	v_u_26.RequiresLineOfSight = true
	v_u_26.Style = Enum.ProximityPromptStyle.Custom
	if p23 then
		for v27, v28 in p23 do
			v_u_26[v27] = v28
		end
	end
	v_u_25.ProximityPrompt = v_u_26
	v_u_26.Parent = p22
	v_u_25.Collector:Add(v_u_26)
	v_u_25.Collector:Add(v_u_26.Changed:Connect(function()
		-- upvalues: (copy) v_u_26
		v_u_26.HoldDuration = 1.5
		v_u_26.RequiresLineOfSight = true
		v_u_26.MaxActivationDistance = 10
	end))
	v_u_25.Collector:Add(v_u_26.PromptButtonHoldBegan:Connect(function()
		-- upvalues: (copy) v_u_26
		v_u_26.HoldDuration = 1.5
		v_u_26.RequiresLineOfSight = true
		v_u_26.MaxActivationDistance = 10
	end))
	v_u_25.Collector:Add(v_u_26.Triggered:Connect(function()
		-- upvalues: (copy) v_u_25
		if v_u_25.TargetCallback then
			v_u_25.TargetCallback()
		end
	end))
	v_u_25.Collector:Add(v_u_26.PromptButtonHoldBegan:Connect(function()
		-- upvalues: (copy) v_u_25, (ref) v_u_9, (ref) v_u_10
		if v_u_25.State == "Steal" then
			v_u_9(v_u_10, workspace:GetServerTimeNow() + 71, "e48572ed-dadc-4d9b-9124-315d813815db")
			v_u_10:FireServer(workspace:GetServerTimeNow() + 71, "614ca939-6c52-4dab-b3ab-5cde12e0a5f2")
		end
	end))
	return v_u_25
end
function v_u_11.Destroy(p29)
	p29.Collector:Destroy()
end
return v_u_11