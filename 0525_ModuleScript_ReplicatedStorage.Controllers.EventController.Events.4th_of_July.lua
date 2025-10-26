--[[
  Extracted from: ReplicatedStorage.Controllers.EventController.Events.4th of July
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: 4th of July, time of decompilation: Fri Jul  4 20:46:27 2025 ]]
local l_ReplicatedStorage_0 = game:GetService("ReplicatedStorage");
local l_TweenService_0 = game:GetService("TweenService");
local l_RunService_0 = game:GetService("RunService");
local _ = game:GetService("Players");
local _ = game:GetService("Debris");
local _ = require(l_ReplicatedStorage_0.Shared.EventTypes);
local v6 = {};
local v7 = require(l_ReplicatedStorage_0.Controllers.AnimalController);
local v8 = require(l_ReplicatedStorage_0.Controllers.SoundController);
local v9 = require(l_ReplicatedStorage_0.Controllers.EventController);
local v10 = require(l_ReplicatedStorage_0.Controllers.CycleController);
local _ = require(l_ReplicatedStorage_0.Packages.Synchronizer);
local v12 = require(l_ReplicatedStorage_0.Shared.ShakePresets);
local _ = require(l_ReplicatedStorage_0.Packages.Observers);
local v14 = require(l_ReplicatedStorage_0.Packages.Trove);
local v15 = require(l_ReplicatedStorage_0.Packages.Net);
local v16 = v15:RemoteEvent("EventService/4th of July/SpawnEffect");
local v17 = v15:RemoteEvent("EventService/4th of July/CreateFirework");
local v18 = v15:RemoteEvent("EventService/4th of July/ExplodeTraitEffect");
local l_Name_0 = script.Name;
local v20 = v14.new();
local v21 = RaycastParams.new();
v21.FilterType = Enum.RaycastFilterType.Include;
v21.FilterDescendantsInstances = {
	workspace.Map, 
	workspace.Plots
};
@native
local function _(v22, v23, v24, v25) --[[ Line: 33 ]] --[[ Name: quadBezier ]]
	return (1 - v22) ^ 2 * v23 + (1 - v22) * 2 * v22 * v24 + v22 ^ 2 * v25;
end;
local function v31(v27) --[[ Line: 37 ]] --[[ Name: getTargetPosition ]]
	-- upvalues: v7 (copy)
	local v28 = v7:GetAnimals()[v27];
	if not v28 then
		return (Vector3.new(0, 0, 0, 0));
	else
		local _ = nil;
		local l_AnimalModel_0 = v28.AnimalModel;
		return (if l_AnimalModel_0.PrimaryPart then l_AnimalModel_0.PrimaryPart.CFrame else l_AnimalModel_0:GetPivot()).Position + Vector3.new(0, v28.AnimalModel:GetExtentsSize().Y * 0.5, 0);
	end;
end;
v6.OnStart = function(_) --[[ Line: 55 ]] --[[ Name: OnStart ]]
	-- upvalues: v9 (copy), l_Name_0 (copy), l_ReplicatedStorage_0 (copy), v20 (copy), v8 (copy), v10 (copy), v12 (copy), l_TweenService_0 (copy), v17 (copy), v21 (copy), l_RunService_0 (copy), v31 (copy)
	local l_v9_ActiveEventData_0 = v9:GetActiveEventData(l_Name_0);
	assert(l_v9_ActiveEventData_0);
	l_ReplicatedStorage_0:SetAttribute("4thOfJulyEvent", true);
	v20:Add(function() --[[ Line: 60 ]]
		-- upvalues: l_ReplicatedStorage_0 (ref)
		l_ReplicatedStorage_0:SetAttribute("4thOfJulyEvent", nil);
	end);
	v8:UpdateOST();
	v10:Update();
	local v34 = l_ReplicatedStorage_0.Models.Events["4th of July"].Fireworks:Clone();
	v34.Parent = workspace;
	local l_v34_Children_0 = v34:GetChildren();
	table.sort(l_v34_Children_0, function(v36, v37) --[[ Line: 71 ]]
		return tonumber(v36.Name) < tonumber(v37.Name);
	end);
	local v38 = {};
	for _, v40 in l_v34_Children_0 do
		v38[v40] = v40.CFrame;
	end;
	local v41 = v12.BumpS:Clone();
	v20:Add(v41);
	v41.Sustain = true;
	v20:Add(v12.BindShakeToCamera(v41, workspace.CurrentCamera));
	v41:Start();
	v20:Add(task.delay(l_v9_ActiveEventData_0.startedAt + 4 - workspace:GetServerTimeNow(), function() --[[ Line: 86 ]]
		-- upvalues: v41 (copy)
		v41:StopSustain();
	end));
	v20:Add(function() --[[ Line: 90 ]]
		-- upvalues: l_v34_Children_0 (copy), l_TweenService_0 (ref), v38 (copy), v34 (copy)
		for _, v43 in l_v34_Children_0 do
			l_TweenService_0:Create(v43, TweenInfo.new(1 + math.random() + math.random(), Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
				CFrame = v38[v43] - Vector3.new(0, v43.Size.Y * 1.1, 0)
			}):Play();
		end;
		task.wait(3);
		v34:Destroy();
	end);
	v20:Add(v17.OnClientEvent:Connect(function(v44) --[[ Line: 102 ]]
		-- upvalues: l_v34_Children_0 (copy), v38 (copy), l_ReplicatedStorage_0 (ref), v8 (ref), l_TweenService_0 (ref), v21 (ref), l_RunService_0 (ref), v31 (ref)
		for _, v46 in v44 do
			local v47 = l_v34_Children_0[v46.Chosen];
			local v48 = script.Firework:Clone();
			v48.CFrame = v38[v47];
			v48.Parent = workspace;
			local v49 = script.FireworkStartup:Clone();
			v49.CFrame = v38[v47] + Vector3.new(0, v47.Size.Y * 0.5 - v49.Size.Y * 0.5, 0);
			v49.Parent = workspace;
			for _, v51 in v49:GetDescendants() do
				if v51:IsA("ParticleEmitter") then
					v51:Emit(v51:GetAttribute("EmitCount"));
				end;
			end;
			local v52 = l_ReplicatedStorage_0.Sounds.Events["4th of July"]["Trail Sound Ball"]:Clone();
			v52.Parent = v48;
			--task.spawn(function()
				--pcall(function()
					--v8:PlaySound(v52);
				--end);
			--end);
			local v53 = l_ReplicatedStorage_0.Sounds.Events["4th of July"].Shot:Clone();
			v53.Parent = v49;
			--task.spawn(function()
				--pcall(function()
				--	v8:PlaySound(v53);
				--end);
			--end);
			task.delay(2, function() --[[ Line: 134 ]]
				-- upvalues: v49 (copy)
				v49:Destroy();
			end);
			local v54 = v38[v47] - Vector3.new(0, v47.Size.Y, 0);
			local v55 = v38[v47] + Vector3.new(0, v46.Height, 0);
			local v56 = v46.Height / 20;
			local v57 = l_TweenService_0:Create(v48, TweenInfo.new(v56, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				CFrame = v55
			});
			v57:Play();
			task.delay(v56 * 0.8, function() --[[ Line: 146 ]]
				-- upvalues: v57 (copy), v8 (ref), l_ReplicatedStorage_0 (ref), v55 (copy), v46 (copy), v48 (copy), v54 (copy), v21 (ref), l_RunService_0 (ref), v31 (ref)
				v57:Destroy();
				--task.spawn(function()
					--pcall(function()
						--v8:PlaySound(l_ReplicatedStorage_0.Sounds.Events["4th of July"]["Firework Explosion"], v55.Position);
					--end);
				--end);
				local v58 = script.Effects[tostring(v46.FireworkEffect)]:Clone();
				v58.CFrame = v55;
				v58.Parent = workspace;
				for _, v60 in v58:GetDescendants() do
					if v60:IsA("ParticleEmitter") then
						v60:Emit(v60:GetAttribute("EmitCount"));
					end;
				end;
				v48:Destroy();
				task.delay(4, function() --[[ Line: 163 ]]
					-- upvalues: v58 (copy)
					v58:Destroy();
				end);
				for _, v62 in v46.Falloffs do
					local v63 = nil;
					if typeof(v62) == "Vector3" then
						v63 = v54 + v62;
						local v64 = workspace:Raycast((v55 + v62).Position, Vector3.new(-0, -200, -0, -0), v21);
						if v64 then
							v63 = CFrame.new(v64.Position);
						end;
					end;
					local v65 = script.Falloff:Clone();
					v65.CFrame = v55;
					v65.Parent = workspace;
					local v66 = 0;
					local v67 = nil;
					do
						local l_v63_0, l_v66_0, l_v67_0 = v63, v66, v67;
						l_v67_0 = l_RunService_0.PostSimulation:Connect(function(v71) --[[ Line: 185 ]]
							-- upvalues: l_v66_0 (ref), l_v63_0 (ref), v62 (copy), v31 (ref), v65 (copy), v55 (ref), v46 (ref), l_v67_0 (ref)
							l_v66_0 = l_v66_0 + v71;
							local v72 = l_v63_0 or type(v62) == "string" and CFrame.new((v31(v62))) or CFrame.identity;
							local v73 = l_v66_0 / 2.3;
							local l_v65_0 = v65;
							local l_new_0 = CFrame.new;
							local l_Position_0 = v55.Position;
							local v77 = v55.Position + Vector3.new(0, v46.Height, 0) + (v72.Position - v55.Position) * Vector3.new(1, 0, 1, 0) * 0.7;
							local l_Position_1 = v72.Position;
							l_v65_0.CFrame = l_new_0((1 - v73) ^ 2 * l_Position_0 + (1 - v73) * 2 * v73 * v77 + v73 ^ 2 * l_Position_1);
							if v73 >= 1 and type(v62) ~= "string" then
								l_v65_0 = script.GroundImpact:Clone();
								l_v65_0.CFrame = v72 + Vector3.new(0, l_v65_0.Size.Y * 0.5, 0);
								l_v65_0.Parent = workspace;
								for _, v80 in l_v65_0:GetDescendants() do
									if v80:IsA("ParticleEmitter") then
										v80:Emit(v80:GetAttribute("EmitCount"));
									end;
								end;
								for _, v82 in v65:GetDescendants() do
									if v82:IsA("ParticleEmitter") then
										v82.Enabled = false;
									end;
								end;
								task.delay(3, function() --[[ Line: 226 ]]
									-- upvalues: v65 (ref), l_v65_0 (copy)
									v65:Destroy();
									l_v65_0:Destroy();
								end);
								l_v67_0:Disconnect();
							end;
						end);
					end;
				end;
			end);
		end;
	end));
	local v83 = Random.new();
	for _, v85 in l_v34_Children_0 do
		v85.CFrame = v38[v85] - Vector3.new(0, v85.Size.Y * 1.1, 0);
		local v86 = l_TweenService_0:Create(v85, TweenInfo.new(v83:NextNumber(3, 7), Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			CFrame = v38[v85]
		});
		local v87 = v20:Add(function() --[[ Line: 247 ]]
			-- upvalues: v86 (copy)
			v86:Cancel();
			v86:Destroy();
		end);
		v86.Completed:Once(function() --[[ Line: 252 ]]
			-- upvalues: v20 (ref), v87 (copy)
			v20:Remove(v87);
		end);
		v86:Play();
	end;
end;
v6.OnStop = function(_) --[[ Line: 260 ]] --[[ Name: OnStop ]]
	-- upvalues: v20 (copy)
	v20:Destroy();
end;
v6.OnLoad = function(_) --[[ Line: 264 ]] --[[ Name: OnLoad ]]
	-- upvalues: v18 (copy), v7 (copy), v31 (copy), v8 (copy), l_ReplicatedStorage_0 (copy), v16 (copy)
	v18.OnClientEvent:Connect(function(v90) --[[ Line: 265 ]]
		-- upvalues: v7 (ref), v31 (ref), v8 (ref), l_ReplicatedStorage_0 (ref)
		local v91 = v7:GetAnimals()[v90];
		if not v91 then
			return;
		else
			local v92 = script.FireworkBurst:Clone();
			v92.CFrame = CFrame.new((v31(v90)));
			v92.Anchored = false;
			local l_WeldConstraint_0 = Instance.new("WeldConstraint");
			l_WeldConstraint_0.Part0 = v92;
			l_WeldConstraint_0.Part1 = v91.AnimalModel.PrimaryPart;
			l_WeldConstraint_0.Parent = v92;
			v92.Parent = workspace;
			--task.spawn(function()
				--pcall(function()
					--v8:PlaySound(l_ReplicatedStorage_0.Sounds.Events["4th of July"]["Brainrot Hit"], v92.Position);
				--end);
			--end);
			for _, v95 in v92:GetDescendants() do
				if v95:IsA("ParticleEmitter") then
					task.delay(v95:GetAttribute("EmitDelay") or 0, function() --[[ Line: 286 ]]
						-- upvalues: v95 (copy)
						v95:Emit(v95:GetAttribute("EmitCount"));
					end);
				end;
			end;
			return;
		end;
	end);
	v16.OnClientEvent:Connect(function(v96) --[[ Line: 293 ]]
		local v97 = script.SpawnEffect:Clone();
		for _, v99 in v97.fx:GetDescendants() do
			if v99:IsA("ParticleEmitter") or v99:IsA("Beam") then
				v99.Enabled = true;
			end;
		end;
		v97.Parent = workspace;
		task.wait(v96 + 5 - workspace:GetServerTimeNow());
		for _, v101 in v97.explode:GetDescendants() do
			if v101:IsA("ParticleEmitter") then
				task.delay(v101:GetAttribute("EmitDelay") or 0, function() --[[ Line: 306 ]]
					-- upvalues: v101 (copy)
					v101:Emit(v101:GetAttribute("EmitCount"));
				end);
			end;
		end;
		for _, v103 in v97.fx:GetDescendants() do
			if v103:IsA("ParticleEmitter") or v103:IsA("Beam") then
				v103.Enabled = false;
			end;
		end;
		task.wait(3);
		v97:Destroy();
	end);
end;
return v6;