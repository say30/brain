--[[
  Extracted from: ReplicatedStorage.Controllers.EventController.Events.Raining Tacos
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: Raining Tacos, time of decompilation: Sat Jun 28 18:35:10 2025 ]]
local l_ReplicatedStorage_0 = game:GetService("ReplicatedStorage");
local _ = game:GetService("TweenService");
local l_RunService_0 = game:GetService("RunService");
local _ = game:GetService("Players");
local _ = require(l_ReplicatedStorage_0.Shared.EventTypes);
local v5 = {};
local v6 = require(l_ReplicatedStorage_0.Controllers.AnimalController);
local v7 = require(l_ReplicatedStorage_0.Controllers.SoundController);
local v8 = require(l_ReplicatedStorage_0.Controllers.EventController);
local v9 = require(l_ReplicatedStorage_0.Controllers.CycleController);
local v10 = require(l_ReplicatedStorage_0.Packages.Spring);
local v11 = require(l_ReplicatedStorage_0.Packages.Trove);
local _ = require(l_ReplicatedStorage_0.Packages.Shake);
local v13 = require(l_ReplicatedStorage_0.Packages.Net):RemoteEvent("EventService/RainingTacos/Shoot");
local l_Name_0 = script.Name;
local v15 = v11.new();
local _ = workspace.CurrentCamera;
@native
local function _(v17, v18, v19, v20) --[[ Line: 26 ]] --[[ Name: quadBezier ]]
	return (1 - v17) ^ 2 * v18 + (1 - v17) * 2 * v17 * v19 + v17 ^ 2 * v20;
end;
v5.OnStart = function(_) --[[ Line: 30 ]] --[[ Name: OnStart ]]
	-- upvalues: v8 (copy), l_Name_0 (copy), l_ReplicatedStorage_0 (copy), v15 (copy), v7 (copy), v9 (copy), v10 (copy), l_RunService_0 (copy), v13 (copy), v6 (copy)
	assert((v8:GetActiveEventData(l_Name_0)));
	l_ReplicatedStorage_0:SetAttribute("RainingTacosEvent", true);
	v15:Add(function() --[[ Line: 35 ]]
		-- upvalues: l_ReplicatedStorage_0 (ref), v7 (ref), v9 (ref)
		l_ReplicatedStorage_0:SetAttribute("RainingTacosEvent", nil);
		v7:UpdateOST();
		v9:Update();
	end);
	v7:UpdateOST();
	v9:Update();
	local v23 = v15:Clone(script.Cannon);
	v23.Parent = workspace;
	local v24 = script.TacoAmbient:Clone();
	v15:Add(function() --[[ Line: 48 ]]
		-- upvalues: v24 (copy)
		for _, v26 in v24:GetDescendants() do
			if v26:IsA("ParticleEmitter") then
				v26.Enabled = false;
			end;
		end;
		task.wait(5);
		v24:Destroy();
	end);
	v24:PivotTo(workspace.MapCenter.CFrame + Vector3.new(0, 40, 0, 0));
	v24.Parent = workspace;
	local v27 = v23.Top["Meshes/tacolauncher_Cube.004"]["Meshes/tacolauncher_Cube.003"];
	local v28 = v23.Bottom.RootPart["Meshes/tacolauncher_Cube.004"];
	local v29 = v10.new(0);
	v29.Speed = 6.5;
	v29.Damper = 0.85;
	local v30 = v10.new(0);
	v30.Speed = 9;
	v30.Damper = 0.6;
	v15:Add(l_RunService_0.PostSimulation:Connect(function(_) --[[ Line: 74 ]]
		-- upvalues: v27 (copy), v29 (copy), v28 (copy), v30 (copy)
		debug.profilebegin("Raining Tacos Cannon Spring");
		v27.C1 = CFrame.new(v29.Position, 0, 0);
		v28.C1 = CFrame.Angles(0, 0, -math.rad(v30.Position));
		debug.profileend();
	end));
	v15:Add(v13.OnClientEvent:Connect(function(v32, v33) --[[ Line: 81 ]]
		-- upvalues: v6 (ref), v7 (ref), l_ReplicatedStorage_0 (ref), v23 (copy), v30 (copy), v29 (copy), l_RunService_0 (ref)
		local v34 = v6:GetAnimals()[v32];
		if not v34 then
			return;
		else
			local _ = function() --[[ Line: 87 ]] --[[ Name: getTargetPosition ]]
				-- upvalues: v34 (copy)
				local _ = nil;
				local l_AnimalModel_0 = v34.AnimalModel;
				return (if l_AnimalModel_0.PrimaryPart then l_AnimalModel_0.PrimaryPart.CFrame else l_AnimalModel_0:GetPivot()).Position + Vector3.new(0, v34.AnimalModel:GetExtentsSize().Y * 0.5, 0);
			end;
			local v38 = script.Taco:Clone();
			v38.Parent = workspace;
			task.spawn(function() --[[ Line: 103 ]]
				-- upvalues: v7 (ref), l_ReplicatedStorage_0 (ref), v23 (ref)
				v7:PlaySound(l_ReplicatedStorage_0.Sounds.Events["Raining Tacos"].Shoot, v23:GetPivot().Position);
			end);
			task.spawn(function() --[[ Line: 107 ]]
				-- upvalues: v30 (ref), v29 (ref)
				v30:Impulse(650);
				task.wait(0.05);
				v29:Impulse(35);
			end);
			local l_Position_0 = v23.ShootPart.CFrame.Position;
			local v40 = nil;
			v40 = l_RunService_0.PreRender:Connect(function() --[[ Line: 116 ]]
				-- upvalues: v34 (copy), l_Position_0 (copy), v33 (copy), v38 (copy), v40 (ref), v7 (ref), l_ReplicatedStorage_0 (ref)
				debug.profilebegin("Raining Tacos");
				local v41 = nil;
				local l_AnimalModel_1 = v34.AnimalModel;
				local v43 = (if l_AnimalModel_1.PrimaryPart then l_AnimalModel_1.PrimaryPart.CFrame else l_AnimalModel_1:GetPivot()).Position + Vector3.new(0, v34.AnimalModel:GetExtentsSize().Y * 0.5, 0);
				v41 = l_Position_0 + (v43 - l_Position_0) * 0.5 + Vector3.new(0, 60, 0, 0);
				l_AnimalModel_1 = 1 - (v33 + 2.5 - workspace:GetServerTimeNow()) / 2.5;
				local v44 = math.clamp(l_AnimalModel_1, 0, 1);
				local l_l_Position_0_0 = l_Position_0;
				local v46 = (1 - v44) ^ 2 * l_l_Position_0_0 + (1 - v44) * 2 * v44 * v41 + v44 ^ 2 * v43;
				l_l_Position_0_0 = math.clamp(l_AnimalModel_1, 0, 1) + 0.1;
				local l_l_Position_0_1 = l_Position_0;
				v44 = (1 - l_l_Position_0_0) ^ 2 * l_l_Position_0_1 + (1 - l_l_Position_0_0) * 2 * l_l_Position_0_0 * v41 + l_l_Position_0_0 ^ 2 * v43;
				v38.CFrame = CFrame.lookAt(v46, v44);
				if l_AnimalModel_1 >= 1 then
					v40:Disconnect();
					task.spawn(function() --[[ Line: 132 ]]
						-- upvalues: v7 (ref), l_ReplicatedStorage_0 (ref), v43 (copy)
						v7:PlaySound(l_ReplicatedStorage_0.Sounds.Events["Raining Tacos"].Hit, v43);
					end);
					v38:Destroy();
					l_l_Position_0_0 = script.StruckVFX:Clone();
					l_l_Position_0_0:PivotTo(CFrame.new(v43));
					l_l_Position_0_0.Anchored = false;
					l_l_Position_0_1 = Instance.new("WeldConstraint");
					l_l_Position_0_1.Part0 = l_l_Position_0_0;
					l_l_Position_0_1.Part1 = v34.AnimalModel.PrimaryPart;
					l_l_Position_0_1.Parent = l_l_Position_0_0;
					l_l_Position_0_0.Parent = workspace;
					for _, v49 in l_l_Position_0_0:GetDescendants() do
						if v49:IsA("ParticleEmitter") then
							task.delay(v49:GetAttribute("EmitDelay") or 0, function() --[[ Line: 152 ]]
								-- upvalues: v49 (copy)
								v49:Emit(v49:GetAttribute("EmitCount"));
							end);
						end;
					end;
					task.delay(2, function() --[[ Line: 158 ]]
						-- upvalues: l_l_Position_0_0 (copy)
						l_l_Position_0_0:Destroy();
					end);
				end;
				debug.profileend();
			end);
			return;
		end;
	end));
end;
v5.OnStop = function(_) --[[ Line: 168 ]] --[[ Name: OnStop ]]
	-- upvalues: v15 (copy)
	v15:Destroy();
end;
v5.OnLoad = function(_) --[[ Line: 172 ]] --[[ Name: OnLoad ]]

end;
return v5;