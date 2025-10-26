--[[
  Extracted from: ReplicatedStorage.Controllers.EventController.Events.Tung Tung Attack
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: Tung Tung Attack, time of decompilation: Sat Jul  5 18:09:18 2025 ]]
local _ = game:GetService("PathfindingService");
local l_ReplicatedStorage_0 = game:GetService("ReplicatedStorage");
local _ = game:GetService("TweenService");
local _ = game:GetService("RunService");
local _ = game:GetService("Lighting");
local _ = game:GetService("Players");
local _ = require(l_ReplicatedStorage_0.Shared.EventTypes);
local v7 = {};
local v8 = require(l_ReplicatedStorage_0.Controllers.AnimalController);
local v9 = require(l_ReplicatedStorage_0.Controllers.SoundController);
local v10 = require(l_ReplicatedStorage_0.Controllers.EventController);
local v11 = require(l_ReplicatedStorage_0.Controllers.CycleController);
local _ = require(l_ReplicatedStorage_0.Packages.Synchronizer);
local v13 = require(l_ReplicatedStorage_0.Shared.ShakePresets);
local v14 = require(l_ReplicatedStorage_0.Shared.TweenPivot);
local v15 = require(l_ReplicatedStorage_0.Packages.Observers);
local v16 = require(l_ReplicatedStorage_0.Packages.Trove);
local v17 = require(l_ReplicatedStorage_0.Packages.Net);
local l_Name_0 = script.Name;
local v19 = v17:RemoteEvent("EventService/Tung Tung Attack/Hit");
local v20 = v16.new();
local v21 = {};
v7.OnStart = function(_) --[[ Line: 36 ]] --[[ Name: OnStart ]]
    -- upvalues: v10 (copy), l_Name_0 (copy), v11 (copy), v9 (copy), v20 (copy), v14 (copy), v15 (copy), v21 (copy), v13 (copy)
    local l_v10_ActiveEventData_0 = v10:GetActiveEventData(l_Name_0);
    assert(l_v10_ActiveEventData_0);
    local l_workspace_ServerTimeNow_0 = workspace:GetServerTimeNow();
    v11:Update();
    v9:UpdateOST();
    local v25 = script["Tung Tung Tung Sahur"]:Clone();
    local l_v25_Pivot_0 = v25:GetPivot();
    v25:PivotTo(l_v25_Pivot_0 - Vector3.new(0, 40, 0, 0));
    v25.Parent = workspace;
    local v27 = script.VFX:Clone();
    v27.Parent = workspace;
    local v28 = v25.AnimationController.Animator:LoadAnimation(script.GiantTungTung);
    v28.Looped = false;
    v28.Priority = Enum.AnimationPriority.Action4;
    v28:Play(0);
    local v29 = v25.AnimationController.Animator:LoadAnimation(script.GiantTungTungIdle);
    v29.Looped = true;
    v29.Priority = Enum.AnimationPriority.Idle;
    v29:Play(0);
    v20:Add(task.spawn(function() --[[ Line: 64 ]]
        -- upvalues: v28 (copy), v9 (ref), v20 (ref), v14 (ref), v25 (copy), l_v25_Pivot_0 (copy)
        while v28.Length == 0 do
            task.wait();
        end;
        v9:PlaySound("Sounds.Events.Tung Tung Attack.BigTungTungSpawn");
        v28:Stop(0);
        v28.TimePosition = 0;
        v28:Play(0);
        v20:Add(v14(v25, TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), l_v25_Pivot_0)):Play();
    end));
    v20:Add(function() --[[ Line: 78 ]]
        -- upvalues: v14 (ref), v25 (copy), l_v25_Pivot_0 (copy), v27 (copy), v29 (copy), v28 (copy)
        v14(v25, TweenInfo.new(3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), l_v25_Pivot_0 - Vector3.new(0, 40, 0, 0)):Play();
        for _, v31 in v27:GetDescendants() do
            if v31:IsA("ParticleEmitter") then
                v31.Enabled = false;
            end;
        end;
        task.wait(5);
        v25:Destroy();
        v29:Stop(0);
        v29:Destroy();
        v28:Stop(0);
        v28:Destroy();
    end);
    local v32 = Random.new();
    v20:Add(v15.observeTag("BabyTungTung", function(v33) --[[ Line: 99 ]]
        -- upvalues: v21 (ref), v32 (copy)
        local v34 = true;
        local v36 = task.spawn(function() --[[ Line: 101 ]]
            -- upvalues: v34 (ref), v21 (ref), v32 (ref), v33 (copy)
			local v36 = task.spawn(function()
				while v34 do
					task.wait(v32:NextNumber(2, 4))
				end
			end)
        end);
        return function() --[[ Line: 116 ]]
            -- upvalues: v34 (ref), v36 (copy)
            v34 = false;
            pcall(task.cancel, v36);
        end;
    end));
    local v37 = l_v10_ActiveEventData_0.startedAt + 10 - l_workspace_ServerTimeNow_0;
    local v38 = script.Caves:Clone();
    local v39 = script.Caves2:Clone();
    for _, v41 in {
        v38["1"], 
        v38["2"], 
        v38["3"], 
        v39["4"], 
        v39["5"], 
        v39["6"]
    } do
        v9:PlaySound("Sounds.Events.Tung Tung Attack.Cave", v41:GetPivot().Position);
    end;
    v38.Parent = workspace;
    v39.Parent = workspace;
    v20:Add(v14(v38, TweenInfo.new(v37, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), v38:GetPivot() * CFrame.new(0, 0, 6))):Play();
    v20:Add(v14(v39, TweenInfo.new(v37, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), v39:GetPivot() * CFrame.new(0, 0, 6))):Play();
    local v42 = v13.BumpS:Clone();
    v20:Add(v42);
    v42.Sustain = true;
    v20:Add(v13.BindShakeToCamera(v42, workspace.CurrentCamera));
    v42:Start();
    v20:Add(task.delay(v37, function() --[[ Line: 152 ]]
        -- upvalues: v42 (copy), v27 (copy)
        v42:StopSustain();
        for _, v44 in v27.Cave:GetDescendants() do
            if v44:IsA("ParticleEmitter") then
                v44.Enabled = true;
            end;
        end;
    end));
end;
v7.OnStop = function(_) --[[ Line: 163 ]] --[[ Name: OnStop ]]
    -- upvalues: v20 (copy)
    v20:Destroy();
end;
v7.OnLoad = function(_) --[[ Line: 167 ]] --[[ Name: OnLoad ]]
    -- upvalues: v19 (copy), v8 (copy)
    v19.OnClientEvent:Connect(function(v47) --[[ Line: 168 ]]
        -- upvalues: v8 (ref)
        local v48 = nil;
        local v49 = nil;
        if type(v47) == "string" then
            local v50 = v8:GetAnimals()[v47];
            if not v50 then
                return;
            else
                local l_v50_0 = v50 --[[ copy: 3 -> 10 ]];
                local _ = function() --[[ Line: 177 ]] --[[ Name: getTargetPosition ]]
                    -- upvalues: l_v50_0 (copy)
                    local _ = nil;
                    local l_AnimalModel_0 = l_v50_0.AnimalModel;
                    return (if l_AnimalModel_0.PrimaryPart then l_AnimalModel_0.PrimaryPart.CFrame else l_AnimalModel_0:GetPivot()).Position + Vector3.new(0, l_v50_0.AnimalModel:GetExtentsSize().Y * 0.5, 0);
                end;
                local _ = nil;
                local l_AnimalModel_1 = v50.AnimalModel;
                v48 = (if l_AnimalModel_1.PrimaryPart then l_AnimalModel_1.PrimaryPart.CFrame else l_AnimalModel_1:GetPivot()).Position + Vector3.new(0, v50.AnimalModel:GetExtentsSize().Y * 0.5, 0);
                v49 = v50.AnimalModel.PrimaryPart;
            end;
        else
            v48 = v47:GetPivot().Position;
            v49 = v47;
        end;
        local v57 = script.TungTungHit:Clone();
        v57:PivotTo(CFrame.new(v48));
        v57.Anchored = false;
        local l_WeldConstraint_0 = Instance.new("WeldConstraint");
        l_WeldConstraint_0.Part0 = v57;
        l_WeldConstraint_0.Part1 = v49;
        l_WeldConstraint_0.Parent = v57;
        v57.Parent = workspace;
        for _, v60 in v57:GetDescendants() do
            if v60:IsA("ParticleEmitter") then
                task.delay(v60:GetAttribute("EmitDelay") or 0, function() --[[ Line: 210 ]]
                    -- upvalues: v60 (copy)
                    v60:Emit(v60:GetAttribute("EmitCount"));
                end);
            end;
        end;
    end);
end;
return v7;