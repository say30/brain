--[[
  Extracted from: ReplicatedStorage.Controllers.EventController.Events.La Vacca Saturno Saturnita
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: La Vacca Saturno Saturnita, time of decompilation: Sat Jun 28 18:35:10 2025 ]]
local l_ReplicatedStorage_0 = game:GetService("ReplicatedStorage");
local _ = game:GetService("TweenService");
local l_RunService_0 = game:GetService("RunService");
local _ = game:GetService("Players");
local _ = game:GetService("Debris");
local _ = require(l_ReplicatedStorage_0.Shared.EventTypes);
local v6 = {};
local _ = l_ReplicatedStorage_0.Models.Events["La Vacca"];
local v8 = require(l_ReplicatedStorage_0.Controllers.AnimalController);
local v9 = require(l_ReplicatedStorage_0.Controllers.EffectController);
local v10 = require(l_ReplicatedStorage_0.Controllers.SoundController);
local v11 = require(l_ReplicatedStorage_0.Controllers.EventController);
local v12 = require(l_ReplicatedStorage_0.Controllers.CycleController);
local v13 = require(l_ReplicatedStorage_0.Shared.ShakePresets);
local v14 = require(l_ReplicatedStorage_0.Packages.Observers);
local _ = require(l_ReplicatedStorage_0.Shared.TweenPivot);
local v16 = require(l_ReplicatedStorage_0.Packages.Trove);
local _ = require(l_ReplicatedStorage_0.Packages.Shake);
local v18 = require(l_ReplicatedStorage_0.Packages.Net):RemoteEvent("EventService/LaVacca/Comet");
local l_Name_0 = script.Name;
local v20 = v16.new();
local l_CurrentCamera_0 = workspace.CurrentCamera;
v6.OnStart = function(_) --[[ Line: 32 ]] --[[ Name: OnStart ]]
    -- upvalues: v11 (copy), l_Name_0 (copy), v20 (copy), l_ReplicatedStorage_0 (copy), l_RunService_0 (copy), v14 (copy), v9 (copy), v10 (copy), v12 (copy), v18 (copy), v8 (copy), l_CurrentCamera_0 (copy), v13 (copy)
    local l_v11_ActiveEventData_0 = v11:GetActiveEventData(l_Name_0);
    assert(l_v11_ActiveEventData_0);
    local _ = workspace:GetServerTimeNow();
    local v25 = l_v11_ActiveEventData_0.startedAt + 11 - workspace:GetServerTimeNow();
    if v25 > 0 then
        local v26 = v20:Extend();
        local v27 = v26:Add(Instance.new("Model"));
        local v28 = v26:Add(Instance.new("Part"));
        v28.Name = "Center";
        v28.Transparency = 1;
        v28.Anchored = true;
        v28.CanCollide = false;
        v28.CanQuery = false;
        v28.CanTouch = false;
        v28.Size = Vector3.new(1, 1, 1, 0);
        v28.Position = l_ReplicatedStorage_0:GetAttribute("LaVaccaCenter") or workspace.MapCenter.Position;
        v28.Parent = v27;
        v27.PrimaryPart = v28;
        v27.Parent = workspace;
        local v29 = table.create(3);
        v26:Add(function() --[[ Line: 68 ]]
            -- upvalues: v29 (copy)
            table.clear(v29);
        end);
        local v30 = 0;
        do
            local l_v30_0 = v30;
            v26:Add(l_RunService_0.PreRender:Connect(function(v32) --[[ Line: 73 ]]
                -- upvalues: l_v30_0 (ref), v29 (copy)
                debug.profilebegin("La Vacca Event");
                l_v30_0 = l_v30_0 + v32;
                for v33, v34 in v29 do
                    if v34.target and v34.targetAttachment then
                        v34.beam.First.Enabled = true;
                        v34.beam.Second.Enabled = true;
                        local v35 = math.clamp(l_v30_0 - v33 + 1, 0, 1);
                        local l_WorldPosition_0 = v34.beam.WorldPosition;
                        v34.targetAttachment.Position = l_WorldPosition_0 + (v34.target:GetPivot().Position - l_WorldPosition_0) * v35;
                    end;
                end;
                debug.profileend();
            end));
            local v37 = {};
            v26:Add(v14.observeTag("LaVaccaModel", function(v38) --[[ Line: 96 ]]
                -- upvalues: v37 (copy), v27 (copy), v29 (copy), v14 (ref)
                table.insert(v37, v38);
                v38.Parent = v27;
                local v39 = script.PlayerVFX.Beam:Clone();
                v39.Parent = v38.PrimaryPart;
                v29[v38:GetAttribute("LaVaccaIndex")] = {
                    beam = v39, 
                    target = nil
                };
                local v43 = v14.observeTag("LaVaccaModel", function(v40) --[[ Line: 108 ]]
                    -- upvalues: v38 (copy), v39 (copy), v29 (ref)
                    if v40 == v38 then
                        return nil;
                    elseif v40:GetAttribute("LaVaccaIndex") ~= v38:GetAttribute("LaVaccaIndex") % 3 + 1 then
                        return nil;
                    else
                        local l_Attachment_0 = Instance.new("Attachment");
                        l_Attachment_0.Position = v39.WorldPosition;
                        l_Attachment_0.Parent = workspace.Terrain;
                        local v42 = v29[v38:GetAttribute("LaVaccaIndex")];
                        v42.target = v40.PrimaryPart;
                        v42.beam.First.Attachment0 = l_Attachment_0;
                        v42.beam.Second.Attachment0 = l_Attachment_0;
                        v42.targetAttachment = l_Attachment_0;
                        return function() --[[ Line: 127 ]]
                            -- upvalues: l_Attachment_0 (copy)
                            l_Attachment_0:Destroy();
                        end;
                    end;
                end);
                return function() --[[ Line: 132 ]]
                    -- upvalues: v29 (ref), v38 (copy), v39 (copy), v43 (copy), v37 (ref)
                    v29[v38:GetAttribute("LaVaccaIndex")] = nil;
                    v39:Destroy();
                    v43();
                    local v44 = table.find(v37, v38);
                    if v44 then
                        table.remove(v37, v44);
                    end;
                end;
            end));
            local l_CFrame_0 = v28.CFrame;
            local v46 = v26:Clone(script.SummonVFX);
            v46:PivotTo(l_CFrame_0);
            v46.Parent = workspace;
            local v47 = v26:Clone(script.SummonVFXBeam);
            v47:PivotTo(l_CFrame_0);
            v47.Parent = workspace;
            v26:Add(l_RunService_0.PostSimulation:Connect(function(_) --[[ Line: 155 ]]
                -- upvalues: l_v11_ActiveEventData_0 (copy), v27 (copy), l_CFrame_0 (copy), v47 (copy), v26 (copy)
                debug.profilebegin("La Vacca Event Animation");
                local l_workspace_ServerTimeNow_1 = workspace:GetServerTimeNow();
                if l_workspace_ServerTimeNow_1 < l_v11_ActiveEventData_0.startedAt + 3 then
                    return;
                else
                    local v50 = math.clamp(1 - (l_v11_ActiveEventData_0.startedAt + 11 - l_workspace_ServerTimeNow_1) / 8, 0, 1);
                    local v51 = v50 * v50 * 3.141592653589793 * 2 * 8;
                    local v52 = v50 * v50 * 150;
                    v27:PivotTo(l_CFrame_0 * CFrame.Angles(0, v51, 0) * CFrame.new(0, v52, 0));
                    v47.Beams.Position = Vector3.new(0, v52, 0);
                    if v50 >= 1 then
                        v26:Clean();
                    end;
                    debug.profileend();
                    return;
                end;
            end));
            v26:Add(v14.observeTag("LaVaccaPlayerVFX", function(v53) --[[ Line: 177 ]]
                local v54 = script.PlayerVFX.Torso:Clone();
                v54.Parent = v53;
                return function() --[[ Line: 181 ]]
                    -- upvalues: v54 (copy)
                    v54:Destroy();
                end;
            end, {
                workspace
            }));
        end;
    end;
    v20:Add(task.delay(v25, function() --[[ Line: 187 ]]
        -- upvalues: v9 (ref), l_Name_0 (ref), v20 (ref), l_ReplicatedStorage_0 (ref), v10 (ref), v12 (ref)
        v9:Run(l_Name_0, "Space");
        v9:Activate("Blink");
        v20:Add(function() --[[ Line: 191 ]]
            -- upvalues: v9 (ref)
            v9:Activate("Blink");
        end);
        l_ReplicatedStorage_0:SetAttribute("LaVaccaEvent", true);
        v10:UpdateOST();
        v12:Update();
        v20:Add(function() --[[ Line: 199 ]]
            -- upvalues: l_ReplicatedStorage_0 (ref), v9 (ref), l_Name_0 (ref)
            l_ReplicatedStorage_0:SetAttribute("LaVaccaEvent", nil);
            v9:Stop(l_Name_0, "Space");
        end);
    end));
    v20:Add(v18.OnClientEvent:Connect(function(v55, v56) --[[ Line: 205 ]]
        -- upvalues: v8 (ref), v10 (ref), l_ReplicatedStorage_0 (ref), l_RunService_0 (ref), l_CurrentCamera_0 (ref), v13 (ref), v20 (ref)
        local v57 = v8:GetAnimals()[v56];
        if not v57 then
            return;
        else
            local _ = function() --[[ Line: 211 ]] --[[ Name: getTargetPosition ]]
                -- upvalues: v57 (copy)
                local _ = nil;
                local l_AnimalModel_0 = v57.AnimalModel;
                return (if l_AnimalModel_0.PrimaryPart then l_AnimalModel_0.PrimaryPart.CFrame else l_AnimalModel_0:GetPivot()).Position + Vector3.new(0, v57.AnimalModel:GetExtentsSize().Y * 0.5, 0);
            end;
            local v61 = CFrame.new(v55);
            task.spawn(function() --[[ Line: 226 ]]
                -- upvalues: v10 (ref), l_ReplicatedStorage_0 (ref), v57 (copy)
                local l_v10_0 = v10;
                local l_CommetActivation_0 = l_ReplicatedStorage_0.Sounds.Events["La Vacca Saturno Saturnita"].CommetActivation;
                local _ = nil;
                local l_AnimalModel_1 = v57.AnimalModel;
                l_v10_0:PlaySound(l_CommetActivation_0, (if l_AnimalModel_1.PrimaryPart then l_AnimalModel_1.PrimaryPart.CFrame else l_AnimalModel_1:GetPivot()).Position + Vector3.new(0, v57.AnimalModel:GetExtentsSize().Y * 0.5, 0));
            end);
            local v66 = script.Comet:Clone();
            v66:PivotTo(v61);
            v66.Parent = workspace;
            local v67 = 0;
            local v68 = nil;
            v68 = l_RunService_0.PreRender:Connect(function(v69) --[[ Line: 237 ]]
                -- upvalues: v68 (ref), v67 (ref), v57 (copy), v66 (copy), v61 (copy), v10 (ref), l_ReplicatedStorage_0 (ref), l_CurrentCamera_0 (ref), v13 (ref), v20 (ref)
                if not v68 or not v68.Connected then
                    return;
                else
                    debug.profilebegin("La Vacca Commet Hit");
                    v67 = v67 + v69;
                    local l_new_0 = CFrame.new;
                    local _ = nil;
                    local l_AnimalModel_2 = v57.AnimalModel;
                    l_new_0 = l_new_0((if l_AnimalModel_2.PrimaryPart then l_AnimalModel_2.PrimaryPart.CFrame else l_AnimalModel_2:GetPivot()).Position + Vector3.new(0, v57.AnimalModel:GetExtentsSize().Y * 0.5, 0));
                    local v73 = math.clamp(v67 / 1, 0, 1);
                    v66:PivotTo(v61:Lerp(l_new_0, v73));
                    if v73 >= 1 then
                        v68:Disconnect();
                        task.spawn(function() --[[ Line: 253 ]]
                            -- upvalues: v10 (ref), l_ReplicatedStorage_0 (ref), v57 (ref)
                            local l_v10_1 = v10;
                            local l_CommetHit_0 = l_ReplicatedStorage_0.Sounds.Events["La Vacca Saturno Saturnita"].CommetHit;
                            local _ = nil;
                            local l_AnimalModel_3 = v57.AnimalModel;
                            l_v10_1:PlaySound(l_CommetHit_0, (if l_AnimalModel_3.PrimaryPart then l_AnimalModel_3.PrimaryPart.CFrame else l_AnimalModel_3:GetPivot()).Position + Vector3.new(0, v57.AnimalModel:GetExtentsSize().Y * 0.5, 0));
                        end);
                        if (l_CurrentCamera_0.CFrame.Position - l_new_0.Position).Magnitude <= 70 then
                            l_AnimalModel_2 = v13.Bump:Clone();
                            v20:Add(l_AnimalModel_2);
                            l_AnimalModel_2.Sustain = true;
                            v20:Add(v13.BindShakeToCamera(l_AnimalModel_2, l_CurrentCamera_0));
                            l_AnimalModel_2:Start();
                            local l_l_AnimalModel_2_0 = l_AnimalModel_2 --[[ copy: 4 -> 11 ]];
                            v20:Add(task.delay(0.3, function() --[[ Line: 265 ]]
                                -- upvalues: l_l_AnimalModel_2_0 (copy)
                                l_l_AnimalModel_2_0:StopSustain();
                            end));
                        end;
                        l_AnimalModel_2 = script.CometBurst:Clone();
                        l_AnimalModel_2:PivotTo(l_new_0);
                        l_AnimalModel_2.Anchored = false;
                        local l_WeldConstraint_0 = Instance.new("WeldConstraint");
                        l_WeldConstraint_0.Part0 = l_AnimalModel_2;
                        l_WeldConstraint_0.Part1 = v57.AnimalModel.PrimaryPart;
                        l_WeldConstraint_0.Parent = l_AnimalModel_2;
                        l_AnimalModel_2.Parent = workspace;
                        for _, v81 in v66:GetDescendants() do
                            if v81:IsA("BasePart") then
                                v81.Transparency = 1;
                            elseif v81:IsA("ParticleEmitter") then
                                v81.Enabled = false;
                                v81:Clear();
                            end;
                        end;
                        for _, v83 in l_AnimalModel_2:GetDescendants() do
                            if v83:IsA("ParticleEmitter") then
                                task.delay(v83:GetAttribute("EmitDelay") or 0, function() --[[ Line: 293 ]]
                                    -- upvalues: v83 (copy)
                                    v83:Emit(v83:GetAttribute("EmitCount"));
                                end);
                            end;
                        end;
                        task.delay(2, function() --[[ Line: 299 ]]
                            -- upvalues: v66 (ref), l_AnimalModel_2 (copy)
                            v66:Destroy();
                            l_AnimalModel_2:Destroy();
                        end);
                    end;
                    debug.profileend();
                    return;
                end;
            end);
            return;
        end;
    end));
end;
v6.OnStop = function(_) --[[ Line: 310 ]] --[[ Name: OnStop ]]
    -- upvalues: v20 (copy)
    v20:Destroy();
end;
v6.OnLoad = function(_) --[[ Line: 314 ]] --[[ Name: OnLoad ]]

end;
return v6;