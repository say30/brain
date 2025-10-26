--[[
  Extracted from: ReplicatedStorage.Shared.Friends
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: Friends, time of decompilation: Sat Jun 28 18:34:41 2025 ]]
local l_ReplicatedStorage_0 = game:GetService("ReplicatedStorage");
local l_Players_0 = game:GetService("Players");
local l_RunService_0 = game:GetService("RunService");
local l_StarterGui_0 = game:GetService("StarterGui");
local l_Packages_0 = l_ReplicatedStorage_0:WaitForChild("Packages");
local v5 = require(l_Packages_0.Signal);
local v6 = require(l_Packages_0.Debounce);
local l_FriendMain_0 = script:WaitForChild("FriendMain");
local v8 = {};
local v9 = {
    OnFriendsUpdate = v5.new()
};
local function v16(v10) --[[ Line: 22 ]] --[[ Name: OnPlayerAdded ]]
    -- upvalues: v8 (copy), l_Players_0 (copy)
    v8[v10] = v8[v10] or {};
    local v11 = v8[v10];
    for _, v13 in l_Players_0:GetPlayers() do
        if v13 ~= v10 then
            local l_status_0, l_result_0 = pcall(function() --[[ Line: 29 ]]
                -- upvalues: v10 (copy), v13 (copy)
                return v10:IsFriendsWith(v13.UserId);
            end);
            if l_status_0 and l_result_0 then
                v8[v13] = v8[v13] or {};
                if not table.find(v11, v13) then
                    table.insert(v11, v13);
                end;
                if not table.find(v8[v13], v10) then
                    table.insert(v8[v13], v10);
                end;
            end;
        end;
    end;
end;
local function v21(v17) --[[ Line: 47 ]] --[[ Name: OnPlayerRemoving ]]
    -- upvalues: v8 (copy)
    for v18, v19 in v8 do
        if v18 ~= v17 then
            local v20 = table.find(v19, v17);
            if v20 then
                table.remove(v19, v20);
            end;
        end;
    end;
    v8[v17] = nil;
end;
v9.GetFriendBoostPercentage = function(_, v23) --[[ Line: 63 ]] --[[ Name: GetFriendBoostPercentage ]]
    -- upvalues: v9 (copy)
    if not v23 then
        return 0;
    else
        return math.clamp(v9:GetAmountOfFriendsOnline(v23), 0, 3) * 10;
    end;
end;
v9.GetFriendBoostModifier = function(_, v25) --[[ Line: 68 ]] --[[ Name: GetFriendBoostModifier ]]
    -- upvalues: v9 (copy)
    if not v25 then
        return 0;
    else
        return math.clamp(v9:GetAmountOfFriendsOnline(v25), 0, 3) / 10;
    end;
end;
v9.GetAmountOfFriendsOnline = function(_, v27) --[[ Line: 73 ]] --[[ Name: GetAmountOfFriendsOnline ]]
    -- upvalues: v8 (copy)
    local v28 = v8[v27];
    return v28 and #v28 or 0;
end;
v9.GetInGameFriends = function(_, v30) --[[ Line: 78 ]] --[[ Name: GetInGameFriends ]]
    -- upvalues: v8 (copy)
    return v8[v30] or {};
end;
v9.Start = function(_) --[[ Line: 82 ]] --[[ Name: Start ]]
    -- upvalues: l_RunService_0 (copy), l_FriendMain_0 (copy), v6 (copy), l_Players_0 (copy), v8 (copy), v16 (copy), v21 (copy), v9 (copy), l_StarterGui_0 (copy)
    if l_RunService_0:IsServer() then
        l_FriendMain_0.OnServerEvent:Connect(function(v32, v33, v34) --[[ Line: 86 ]]
            -- upvalues: v6 (ref), l_Players_0 (ref), v8 (ref), l_FriendMain_0 (ref)
            if v6(("Friends/Check/%*"):format(v32.Name), 0.1) then
                return;
            elseif v33 == true then
                if not v34 or not v34:IsDescendantOf(l_Players_0) or v34 == v32 then
                    return;
                else
                    local v35 = v8[v32];
                    if not v35 then
                        return;
                    else
                        local v36 = v8[v34];
                        if not v36 then
                            return;
                        elseif not v32:IsFriendsWith(v34.UserId) then
                            return;
                        else
                            if not table.find(v35, v34) then
                                table.insert(v35, v34);
                            end;
                            if not table.find(v36, v32) then
                                table.insert(v36, v32);
                            end;
                            l_FriendMain_0:FireClient(v32, v35);
                            l_FriendMain_0:FireClient(v34, v36);
                            return;
                        end;
                    end;
                end;
            else
                l_FriendMain_0:FireClient(v32, v8[v32] or {});
                return;
            end;
        end);
        l_Players_0.PlayerAdded:Connect(v16);
        l_Players_0.PlayerRemoving:Connect(v21);
        for _, v38 in l_Players_0:GetPlayers() do
            task.spawn(v16, v38);
        end;
        return;
    else
        local l_LocalPlayer_0 = l_Players_0.LocalPlayer;
        l_FriendMain_0.OnClientEvent:Connect(function(v40) --[[ Line: 133 ]]
            -- upvalues: v8 (ref), l_LocalPlayer_0 (copy), v9 (ref)
            v8[l_LocalPlayer_0] = v40;
            v9.OnFriendsUpdate:Fire();
        end);
        while true do
            local l_status_1, _ = pcall(function() --[[ Line: 139 ]]
                -- upvalues: l_StarterGui_0 (ref), l_FriendMain_0 (ref)
                return l_StarterGui_0:GetCore("PlayerFriendedEvent").Event:Connect(function(v41) --[[ Line: 140 ]]
                    -- upvalues: l_FriendMain_0 (ref)
                    l_FriendMain_0:FireServer(true, v41);
                end);
            end);
            if not l_status_1 then
                task.wait(0.1);
            else
                break;
            end;
        end;
        l_FriendMain_0:FireServer();
        task.spawn(function() --[[ Line: 153 ]]
            -- upvalues: l_FriendMain_0 (ref)
            while wait(15) do
                l_FriendMain_0:FireServer();
            end;
        end);
        return;
    end;
end;
v9:Start();
return v9;