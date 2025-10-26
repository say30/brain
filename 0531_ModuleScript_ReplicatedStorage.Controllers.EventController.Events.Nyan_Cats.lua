--[[
  Extracted from: ReplicatedStorage.Controllers.EventController.Events.Nyan Cats
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: Nyan Cats, time of decompilation: Sat Jun 28 18:35:10 2025 ]]
local l_ReplicatedStorage_0 = game:GetService("ReplicatedStorage");
local _ = game:GetService("TweenService");
local l_RunService_0 = game:GetService("RunService");
local _ = game:GetService("Players");
local _ = game:GetService("Debris");
local _ = require(l_ReplicatedStorage_0.Shared.EventTypes);
local v6 = {};
local v7 = require(l_ReplicatedStorage_0.Controllers.AnimalController);
local v8 = require(l_ReplicatedStorage_0.Controllers.EffectController);
local v9 = require(l_ReplicatedStorage_0.Controllers.SoundController);
local v10 = require(l_ReplicatedStorage_0.Controllers.EventController);
local v11 = require(l_ReplicatedStorage_0.Controllers.CycleController);
local _ = require(l_ReplicatedStorage_0.Packages.Synchronizer);
local v13 = require(l_ReplicatedStorage_0.Shared.ShakePresets);
local _ = require(l_ReplicatedStorage_0.Packages.Observers);
local _ = require(l_ReplicatedStorage_0.Shared.TweenPivot);
local v16 = require(l_ReplicatedStorage_0.Packages.Trove);
local _ = require(l_ReplicatedStorage_0.Packages.Shake);
local v18 = require(l_ReplicatedStorage_0.Packages.Net);
local v19 = v18:RemoteEvent("EventService/NyanCats/Struck");
local l_Name_0 = script.Name;
local v21 = v16.new();
local l_CurrentCamera_0 = workspace.CurrentCamera;
@native
local function _(v23, v24, v25, v26) --[[ Line: 31 ]] --[[ Name: quadBezier ]]
    return (1 - v23) ^ 2 * v24 + (1 - v23) * 2 * v23 * v25 + v23 ^ 2 * v26;
end;
v6.OnStart = function(_) --[[ Line: 35 ]] --[[ Name: OnStart ]]
    -- upvalues: v10 (copy), l_Name_0 (copy), l_ReplicatedStorage_0 (copy), v21 (copy), v8 (copy), v9 (copy), v11 (copy), l_RunService_0 (copy), v19 (copy), v7 (copy), l_CurrentCamera_0 (copy), v13 (copy)
    local l_v10_ActiveEventData_0 = v10:GetActiveEventData(l_Name_0);
    assert(l_v10_ActiveEventData_0);
    l_ReplicatedStorage_0:SetAttribute("NyanCatsEvent", true);
    v21:Add(function() --[[ Line: 40 ]]
        -- upvalues: l_ReplicatedStorage_0 (ref)
        l_ReplicatedStorage_0:SetAttribute("NyanCatsEvent", nil);
    end);
    v8:Run(l_Name_0, "Space");
    v8:Activate("Blink");
    v21:Add(function() --[[ Line: 47 ]]
        -- upvalues: v8 (ref)
        v8:Activate("Blink");
    end);
    v9:UpdateOST();
    v11:Update();
    v21:Add(function() --[[ Line: 54 ]]
        -- upvalues: v8 (ref), l_Name_0 (ref)
        v8:Stop(l_Name_0, "Space");
    end);
    local l_Position_0 = workspace.MapCenter.CFrame.Position;
    local function v39(v31, v32, v33) --[[ Line: 65 ]] --[[ Name: getCatPosition ]]
        -- upvalues: l_Position_0 (copy)
        local v34 = math.ceil(v31 / 10);
        local v35 = (v31 % 10 + 1) / 10;
        local v36 = (v32 or 0) + v34 + v35 * 3.141592653589793 * 2;
        local v37 = l_Position_0 + vector.create(0, v34 * 15 + 35, 0);
        local v38 = vector.create(math.cos(v36) * 270 * 0.5, v33 or math.sin(os.clock() * 6) * 1.5, math.sin(v36) * 420 * 0.5);
        return CFrame.lookAt(v37 + v38, v37);
    end;
    local v40 = table.create(30);
    for v41 = 1, 30 do
        local v42 = v21:Clone(script.NyanCat);
        v42.Parent = workspace;
        local v43 = v42.AnimationController.Animator:LoadAnimation(script.Animation);
        v43.Looped = true;
        v43:Play();
        v21:Add(function() --[[ Line: 91 ]]
            -- upvalues: v43 (copy)
            v43:Stop(0);
            v43:Destroy();
        end);
        v40[v41] = {
            model = v42, 
            scale = v42:GetScale(), 
            rootPart = v42.RootPart, 
            state = {
                type = "hovering"
            }, 
            visualState = {
                cframe = v39(v41)
            }
        };
    end;
    local v44 = table.create(30);
    local v45 = table.create(30);
    v21:Add(l_RunService_0.PostSimulation:Connect(function(v46) --[[ Line: 118 ]]
        -- upvalues: l_v10_ActiveEventData_0 (copy), v40 (copy), v39 (copy), v44 (copy), v45 (copy)
        debug.profilebegin("Nyan Cats");
        local l_workspace_ServerTimeNow_0 = workspace:GetServerTimeNow();
        local v48 = math.rad((l_workspace_ServerTimeNow_0 - l_v10_ActiveEventData_0.startedAt) * 10);
        local v49 = math.sin(l_workspace_ServerTimeNow_0 * 6) * 1.5;
        for v50, v51 in v40 do
            local v52 = nil;
            if v51.state.type == "hovering" then
                v51.visualState.startCFrame = nil;
                v52 = v39(v50, v48, v49);
            elseif v51.state.type == "follow" or v51.state.type == "restore" then
                local v53 = v51.state.type == "restore";
                if v51.visualState.lastState ~= v51.state.type then
                    v51.visualState.timer = 0;
                    v51.visualState.startCFrame = v51.visualState.cframe;
                    v51.visualState.lastState = v51.state.type;
                    v51.visualState.p1 = v51.visualState.cframe * if v53 then CFrame.new(0, 100, 0) else CFrame.new(0, 40, -100);
                end;
                local l_visualState_0 = v51.visualState;
                l_visualState_0.timer = l_visualState_0.timer + v46;
                l_visualState_0 = v51.state.lerpTime or 3;
                local v55 = if v53 then v39(v50, v48, v49).Position else v51.state.value;
                local v56 = math.clamp(v51.visualState.timer / l_visualState_0, 0, 1);
                local l_Position_1 = v51.visualState.startCFrame.Position;
                local l_Position_2 = v51.visualState.p1.Position;
                local v59 = (1 - v56) ^ 2 * l_Position_1 + (1 - v56) * 2 * v56 * l_Position_2 + v56 ^ 2 * v55;
                v52 = CFrame.lookAt(v59, v55 + Vector3.new(9.999999974752427E-7, 9.999999974752427E-7, 9.999999974752427E-7, 0)) * CFrame.Angles(0, -1.5707963267948966 * math.clamp(v51.visualState.timer / (l_visualState_0 * 0.5), 0, 1), 0);
                l_Position_1 = if v53 then math.lerp(0.5, v51.scale, v56) else math.lerp(v51.scale, 0.5, v56);
                v51.model:ScaleTo(l_Position_1);
                if v53 and v56 >= 1 then
                    v51.state = {
                        type = "hovering"
                    };
                end;
            end;
            v51.visualState.cframe = v52;
            v44[v50] = v51.rootPart;
            v45[v50] = v52;
        end;
        workspace:BulkMoveTo(v44, v45, Enum.BulkMoveMode.FireCFrameChanged);
        debug.profileend();
    end));
    v21:Add(v19.OnClientEvent:Connect(function(v60, v61, v62) --[[ Line: 178 ]]
        -- upvalues: v7 (ref), l_RunService_0 (ref), v40 (copy), v9 (ref), l_ReplicatedStorage_0 (ref), l_CurrentCamera_0 (ref), v13 (ref), v21 (ref)
        local v63 = v7:GetAnimals()[v61];
        if not v63 then
            return;
        else
            local _ = function() --[[ Line: 184 ]] --[[ Name: getTargetPosition ]]
                -- upvalues: v63 (copy)
                local _ = nil;
                local l_AnimalModel_0 = v63.AnimalModel;
                return (if l_AnimalModel_0.PrimaryPart then l_AnimalModel_0.PrimaryPart.CFrame else l_AnimalModel_0:GetPivot()).Position + Vector3.new(0, v63.AnimalModel:GetExtentsSize().Y * 0.5, 0);
            end;
            local v67 = v62 + 3 - workspace:GetServerTimeNow();
            local v72 = l_RunService_0.PreRender:Connect(function() --[[ Line: 199 ]]
                -- upvalues: v40 (ref), v60 (copy), v63 (copy), v67 (copy)
                debug.profilebegin("Update Nycan Cat Follow Target");
                local v68 = v40[v60];
                local v69 = {
                    type = "follow"
                };
                local _ = nil;
                local l_AnimalModel_1 = v63.AnimalModel;
                v69.value = (if l_AnimalModel_1.PrimaryPart then l_AnimalModel_1.PrimaryPart.CFrame else l_AnimalModel_1:GetPivot()).Position + Vector3.new(0, v63.AnimalModel:GetExtentsSize().Y * 0.5, 0);
                v69.lerpTime = v67;
                v68.state = v69;
                debug.profileend();
            end);
            task.wait(v67);
            v72:Disconnect();
            v40[v60].state = {
                type = "restore"
            };
            local v73 = nil;
            local l_AnimalModel_2 = v63.AnimalModel;
            local v75 = (if l_AnimalModel_2.PrimaryPart then l_AnimalModel_2.PrimaryPart.CFrame else l_AnimalModel_2:GetPivot()).Position + Vector3.new(0, v63.AnimalModel:GetExtentsSize().Y * 0.5, 0);
            task.spawn(function() --[[ Line: 218 ]]
                -- upvalues: v9 (ref), l_ReplicatedStorage_0 (ref), v75 (copy)
                v9:PlaySound(l_ReplicatedStorage_0.Sounds.Events["Nyan Cats"].Hit, v75);
            end);
            v73 = script.StruckVFX:Clone();
            v73:PivotTo(CFrame.new(v75));
            v73.Anchored = false;
            l_AnimalModel_2 = Instance.new("WeldConstraint");
            l_AnimalModel_2.Part0 = v73;
            l_AnimalModel_2.Part1 = v63.AnimalModel.PrimaryPart;
            l_AnimalModel_2.Parent = v73;
            v73.Parent = workspace;
            for _, v77 in v73:GetDescendants() do
                if v77:IsA("ParticleEmitter") then
                    task.delay(v77:GetAttribute("EmitDelay") or 0, function() --[[ Line: 236 ]]
                        -- upvalues: v77 (copy)
                        v77:Emit(v77:GetAttribute("EmitCount"));
                    end);
                end;
            end;
            task.delay(2, function() --[[ Line: 242 ]]
                -- upvalues: v73 (copy)
                v73:Destroy();
            end);
            if (l_CurrentCamera_0.CFrame.Position - v75).Magnitude <= 70 then
                local v78 = v13.Bump:Clone();
                v21:Add(v78);
                v78.Sustain = true;
                v21:Add(v13.BindShakeToCamera(v78, l_CurrentCamera_0));
                v78:Start();
                v21:Add(task.delay(0.3, function() --[[ Line: 254 ]]
                    -- upvalues: v78 (copy)
                    v78:StopSustain();
                end));
            end;
            return;
        end;
    end));
end;
v6.OnStop = function(_) --[[ Line: 261 ]] --[[ Name: OnStop ]]
    -- upvalues: v21 (copy)
    v21:Destroy();
end;
v6.OnLoad = function(_) --[[ Line: 265 ]] --[[ Name: OnLoad ]]
    -- upvalues: v18 (copy)
    v18:RemoteEvent("EventService/NyanCats/SpawnEffect").OnClientEvent:Connect(function(v81) --[[ Line: 266 ]]
        local v82 = script.NyanCatSpawningVFX:Clone();
        for _, v84 in v82:GetDescendants() do
            if v84:IsA("ParticleEmitter") or v84:IsA("Beam") then
                v84.Enabled = true;
            end;
        end;
        v82.Parent = workspace;
        task.wait(v81 + 9 - workspace:GetServerTimeNow());
        local v85 = script.NyanCatSpawnVFX:Clone();
        v85.Parent = workspace;
        for _, v87 in v85:GetDescendants() do
            if v87:IsA("ParticleEmitter") then
                task.delay(v87:GetAttribute("EmitDelay") or 0, function() --[[ Line: 282 ]]
                    -- upvalues: v87 (copy)
                    v87:Emit(v87:GetAttribute("EmitCount"));
                end);
            end;
        end;
        for _, v89 in v82:GetDescendants() do
            if v89:IsA("ParticleEmitter") or v89:IsA("Beam") then
                v89.Enabled = false;
            end;
        end;
        task.wait(3);
        v85:Destroy();
        v82:Destroy();
    end);
end;
return v6;