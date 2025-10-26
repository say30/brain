--[[
  Extracted from: ReplicatedStorage.Shared.Updates
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled with Velocity Script Decompiler
local v1 = game:GetService("ReplicatedStorage")
local v2 = v1:WaitForChild("Packages")
require(v1.Datas.ServerData)
local v_u_3 = require(v2.FFlags)
local v4 = require(v2.Signal)
local v_u_5 = require(v2.Timer)
local v_u_6 = {
	["List"] = {},
	["Methods"] = {},
	["OnUpdateEnabled"] = v4.new(),
	["OnUpdateDisabled"] = v4.new()
}
function v_u_6.Methods.IsEnabled(p7)
	-- upvalues: (copy) v_u_6, (copy) v_u_3
	local v8 = v_u_6.List[p7]
	if v8 then
		return workspace:GetServerTimeNow() >= v_u_3:GetInstant(v8.FFlag, v8.UnixTimeStamp)
	else
		return false
	end
end
function v_u_6.Methods.GetUpdateTime(p9)
	-- upvalues: (copy) v_u_6, (copy) v_u_3
	local v10 = v_u_6.List[p9]
	if v10 then
		return v_u_3:GetInstant(v10.FFlag, v10.UnixTimeStamp)
	end
end
function v_u_6.Methods.GetTimeLeft(p11)
	-- upvalues: (copy) v_u_6, (copy) v_u_3
	local v12 = v_u_6.List[p11]
	if v12 then
		return v_u_3:GetInstant(v12.FFlag, v12.UnixTimeStamp) - workspace:GetServerTimeNow()
	end
end
v_u_6.List["Update-08/23/2025"] = {
	["UnixTimeStamp"] = 1755957600,
	["FFlag"] = "Update-08/23/2025"
}
v_u_6.List["Update-08/30/2025"] = {
	["UnixTimeStamp"] = 1756580400,
	["FFlag"] = "Update-08/30/2025"
}
v_u_6.List["Update-09/06/2025"] = {
	["UnixTimeStamp"] = 1757185200,
	["FFlag"] = "Update-09/06/2025"
}
(function()
	-- upvalues: (copy) v_u_5, (copy) v_u_6, (copy) v_u_3
	local v13 = v_u_5.new(1)
	local v_u_14 = {}
	v13.Tick:Connect(function()
		-- upvalues: (ref) v_u_6, (copy) v_u_14, (ref) v_u_3
		for v15, v16 in v_u_6.List do
			if v_u_14[v15] then
				if v_u_14[v15] ~= v_u_3:GetInstant(v15, v16.UnixTimeStamp) and not v_u_6.Methods.IsEnabled(v15) then
					v_u_14[v15] = nil
					v_u_6.OnUpdateDisabled:Fire(v15)
				end
			elseif v_u_6.Methods.IsEnabled(v15) then
				v_u_14[v15] = v_u_3:GetInstant(v15, v16.UnixTimeStamp)
				v_u_6.OnUpdateEnabled:Fire(v15)
			end
		end
	end)
	v13:Start()
	for v_u_17, v_u_18 in v_u_6.List do
		if v_u_6.Methods.IsEnabled(v_u_17) then
			v_u_6.OnUpdateEnabled:Fire(v_u_17)
		else
			task.spawn(function()
				-- upvalues: (ref) v_u_6, (copy) v_u_17, (ref) v_u_3, (copy) v_u_18
				while not v_u_6.Methods.IsEnabled(v_u_17) do
					local v19 = v_u_3:GetInstant(v_u_18.FFlag, v_u_18.UnixTimeStamp) - workspace:GetServerTimeNow()
					task.wait((math.clamp(v19, 0.01, (1 / 0))))
				end
				v_u_6.OnUpdateEnabled:Fire(v_u_17)
			end)
		end
	end
end)()
return v_u_6