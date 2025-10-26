--[[
  Extracted from: ReplicatedStorage.Controllers.PlotController
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: PlotController, time of decompilation: Sat Jul 12 13:53:23 2025 ]]
local l_ReplicatedStorage_0 = game:GetService("ReplicatedStorage");
local l_TweenService_0 = game:GetService("TweenService");
local l_Players_0 = game:GetService("Players");
local l_Controllers_0 = l_ReplicatedStorage_0:WaitForChild("Controllers");
local _ = require(l_Controllers_0.CharacterController);
local v5 = require(l_Controllers_0.SoundController);
local l_Packages_0 = l_ReplicatedStorage_0:WaitForChild("Packages");
local v7 = require(l_Packages_0.Observers);
local v8 = require(l_Packages_0.Trove);
local v9 = require(l_Packages_0.Net);
local v10 = require(l_ReplicatedStorage_0.Shared.VFX);
local l_Datas_0 = l_ReplicatedStorage_0:WaitForChild("Datas");
local v12 = require(l_Datas_0.Animals);
local l_Classes_0 = l_ReplicatedStorage_0:WaitForChild("Classes");
local v14 = require(l_Classes_0.PlotClient);
local l_Animals_0 = l_ReplicatedStorage_0:WaitForChild("Animations").Animals;
local v16 = require(l_ReplicatedStorage_0.Shared.Animals);
local v17 = require(l_ReplicatedStorage_0.Controllers.AnimationSyncController);
local v18 = v9:RemoteEvent("PlotService/Open");
local l_LocalPlayer_0 = l_Players_0.LocalPlayer;
local v20 = nil;
local v21 = {};
local function _(v22) --[[ Line: 38 ]] --[[ Name: round ]]
	return math.floor(v22 * 100) / 100;
end;
return {
	GetMyPlot = function(_) --[[ Line: 44 ]] --[[ Name: GetMyPlot ]]
		-- upvalues: v20 (ref)
		return v20;
	end, 
	Start = function(_) --[[ Line: 48 ]] --[[ Name: Start ]]
		-- upvalues: v18 (copy), v21 (copy), v12 (copy), v8 (copy), v5 (copy), v10 (copy), l_ReplicatedStorage_0 (copy), v16 (copy), l_Animals_0 (copy), v17 (copy), l_TweenService_0 (copy), v7 (copy), v14 (copy), l_LocalPlayer_0 (copy), v20 (ref)
		v18.OnClientEvent:Connect(function(v26, v27, v28, v29, v30, v31) --[[ Line: 49 ]]
			-- upvalues: v21 (ref), v12 (ref), v8 (ref), v5 (ref), v10 (ref), l_ReplicatedStorage_0 (ref), v16 (ref), l_Animals_0 (ref), v17 (ref), l_TweenService_0 (ref)
			local v32 = v21[v26];
			if not v32 then
				return;
			else
				local v33 = v12[v28];
				if not v33 or not v33.LuckyBlock then
					return;
				else
					local l_FirstChild_0 = v32.PlotModel.AnimalPodiums:FindFirstChild(v27);
					if not l_FirstChild_0 then
						return;
					else
						while l_FirstChild_0:GetAttribute("DeferDisplay") and l_FirstChild_0:IsDescendantOf(workspace) do
							task.wait(0.1);
						end;
						if not l_FirstChild_0:IsDescendantOf(workspace) then
							return;
						else
							l_FirstChild_0:SetAttribute("DeferDisplay", v29);
							task.spawn(v32.UpdateAnimalPodiums, v32);
							local l_Spawn_0 = l_FirstChild_0.Base.Spawn;
							local v36 = v8.new();
							v5:PlaySound("Sounds.Sfx.Lucky Blocks.SpinStart", l_Spawn_0.CFrame.Position + Vector3.new(0, 3, 0, 0));
							local v37 = v36:Add(v10.copy(v10.Library.Misc.LuckyBlockUnbox, l_Spawn_0.CFrame + Vector3.new(0, 3, 0, 0)));
							v10.emit(v37);
							local v38 = {};
							local v39 = 0;
							for v40 in v33.LuckyBlock.Animals do
								local l_FirstChild_1 = l_ReplicatedStorage_0.Models.Animals:FindFirstChild(v40);
								if l_FirstChild_1 then
									local v42 = v36:Clone(l_FirstChild_1);
									v42.PrimaryPart.Anchored = true;
									v42.Parent = workspace.CurrentCamera;
									for _, v44 in v42:GetDescendants() do
										if v44:IsA("ParticleEmitter") then
											v44:Destroy();
										end;
									end;
									if v30 then
										v16:ApplyMutation(v42, v40, v30);
									end;
									if v31 then
										v36:Add(v16:ApplyTraits(v42, v40, v31));
									end;
									for _, v46 in v42:GetDescendants() do
										if v46:IsA("Trail") then
											v46:Destroy();
										end;
									end;
									local v47 = v42:FindFirstChildOfClass("AnimationController") or v36:Add(Instance.new("AnimationController", v42));
									local v48 = v47:FindFirstChildOfClass("Animator") or v36:Add(Instance.new("Animator", v47));
									local l_l_Animals_0_FirstChild_0 = l_Animals_0:FindFirstChild(v40);
									local v50 = l_l_Animals_0_FirstChild_0 and l_l_Animals_0_FirstChild_0:FindFirstChild("Idle");
									if v50 and v48 then
										local v51 = v48:LoadAnimation(v50);
										v51.Looped = true;
										v51:Play();
										local v52 = v17:Add(v51);
										v36:Add(function() --[[ Line: 131 ]]
											-- upvalues: v52 (copy), v51 (copy)
											v52();
											v51:Stop(0);
											v51:Destroy();
										end);
									end;
									table.insert(v38, v42);
									if v40 == v29 then
										v39 = #v38;
									end;
								end;
							end;
							local v53 = v36:Add(Instance.new("NumberValue"));
							v53.Value = 0;
							v36:Add(v53.Changed:Connect(function(v54) --[[ Line: 147 ]]
								-- upvalues: l_Spawn_0 (copy), v38 (copy)
								local l_l_Spawn_0_Pivot_0 = l_Spawn_0:GetPivot();
								for v56, v57 in v38 do
									local v58 = math.sin(math.clamp((v54 - (v56 - 1)) % #v38 * 0.5, 0, 1) * 3.141592653589793);
									local l_v57_Attribute_0 = v57:GetAttribute("DefaultScale");
									if l_v57_Attribute_0 == nil then
										l_v57_Attribute_0 = v57:GetScale();
										v57:SetAttribute("DefaultScale", l_v57_Attribute_0);
									end;
									v57:PivotTo(l_l_Spawn_0_Pivot_0);
									v57:ScaleTo((math.clamp(l_v57_Attribute_0 * v58 * 1.01, 0.001, l_v57_Attribute_0)));
								end;
							end));
							local v60 = #v38 * 12 + v39;
							local v61 = v36:Add(l_TweenService_0:Create(v53, TweenInfo.new(6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
								Value = v60
							}));
							v61:Play();
							task.wait(v61.TweenInfo.Time * 0.82);
							v53.Value = v60;
							v61:Cancel();
							v36:Clean();
							v5:PlaySound("Sounds.Sfx.Lucky Blocks.SpinEnd", l_Spawn_0.CFrame.Position + Vector3.new(0, 3, 0, 0));
							l_FirstChild_0:SetAttribute("DeferDisplay", nil);
							v32:UpdateAnimalPodiums();
							return;
						end;
					end;
				end;
			end;
		end);
		v7.observeTag("Plot", function(v62) --[[ Line: 183 ]]
			-- upvalues: v14 (ref), v21 (ref), l_LocalPlayer_0 (ref), v20 (ref)
			local v63 = v14.new(v62);
			local l_v63_UID_0 = v63:GetUID();
			v21[l_v63_UID_0] = v63;
			if v63:GetOwner() == l_LocalPlayer_0 then
				v20 = v63;
			end;
			return function() --[[ Line: 193 ]]
				-- upvalues: v63 (copy), v21 (ref), l_v63_UID_0 (copy)
				v63:Destroy();
				v21[l_v63_UID_0] = nil;
			end;
		end);
	end
};