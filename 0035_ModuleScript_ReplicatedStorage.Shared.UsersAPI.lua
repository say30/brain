--[[
  Extracted from: ReplicatedStorage.Shared.UsersAPI
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: UsersAPI, time of decompilation: Sat Jun 28 18:34:41 2025 ]]
local l_UserService_0 = game:GetService("UserService");
local v1 = {
    RequestQuota = 250, 
    UserCache = {}, 
    RequestBatch = {}, 
    ResumeThreads = {}
};
local function _(v2) --[[ Line: 24 ]] --[[ Name: addToBatch ]]
    -- upvalues: v1 (copy)
    if v1.UserCache[v2] then
        return;
    else
        if not table.find(v1.RequestBatch, v2) then
            table.insert(v1.RequestBatch, v2);
        end;
        return;
    end;
end;
local function _(v4) --[[ Line: 34 ]] --[[ Name: consumeQuota ]]
    -- upvalues: v1 (copy)
    local l_v1_0 = v1;
    l_v1_0.RequestQuota = l_v1_0.RequestQuota - v4;
    task.delay(60, function() --[[ Line: 36 ]]
        -- upvalues: v1 (ref), v4 (copy)
        local l_v1_1 = v1;
        l_v1_1.RequestQuota = l_v1_1.RequestQuota + v4;
    end);
end;
local function v24() --[[ Line: 41 ]] --[[ Name: tryUpdate ]]
    -- upvalues: v1 (copy), l_UserService_0 (copy)
    local v8 = #v1.RequestBatch;
    if v8 == 0 then
        return true, false;
    else
        local v9 = math.min(v8, v1.RequestQuota, 250);
        if v9 == 0 then
            return true, false;
        else
            local v10 = table.move(v1.RequestBatch, 1, v9, 1, {});
            local v11 = #v10;
            local l_v1_2 = v1;
            l_v1_2.RequestQuota = l_v1_2.RequestQuota - v11;
            local l_v11_0 = v11 --[[ copy: 3 -> 18 ]];
            task.delay(60, function() --[[ Line: 36 ]]
                -- upvalues: v1 (ref), l_v11_0 (copy)
                local l_v1_3 = v1;
                l_v1_3.RequestQuota = l_v1_3.RequestQuota + l_v11_0;
            end);
            v11, l_v1_2 = pcall(function() --[[ Line: 55 ]]
                -- upvalues: l_UserService_0 (ref), v10 (copy)
                return l_UserService_0:GetUserInfosByUserIdsAsync(v10);
            end);
            if not v11 or type(l_v1_2) ~= "table" then
                return false, false;
            else
                for _, v16 in v10 do
                    local v17 = nil;
                    for _, v19 in l_v1_2 do
                        if v19.Id == v16 then
                            v17 = v19;
                            break;
                        end;
                    end;
                    if not v17 then
                        v17 = {
                            IsLoaded = false, 
                            DisplayName = "Failed to load", 
                            HasVerifiedBadge = false, 
                            Id = v16, 
                            Username = "Failed to load"
                        };
                    else
                        v17.IsLoaded = true;
                        v1.UserCache[v16] = v17;
                    end;
                    local v20 = table.find(v1.RequestBatch, v16);
                    if v20 then
                        table.remove(v1.RequestBatch, v20);
                    end;
                    local v21 = v1.ResumeThreads[v16];
                    if v21 then
                        for _, v23 in v21 do
                            if coroutine.status(v23) == "suspended" then
                                task.spawn(v23, v17);
                            end;
                        end;
                        v1.ResumeThreads[v16] = nil;
                    end;
                end;
                return true, true;
            end;
        end;
    end;
end;
local function v25() --[[ Line: 107 ]] --[[ Name: start ]]
    -- upvalues: v24 (copy)
    while true do
        task.wait(5);
        v24();
    end;
end;
v1.AddToBatch = function(_, v27) --[[ Line: 115 ]] --[[ Name: AddToBatch ]]
    -- upvalues: v1 (copy)
    if type(v27) == "number" then
        if v1.UserCache[v27] then
            return;
        elseif not table.find(v1.RequestBatch, v27) then
            table.insert(v1.RequestBatch, v27);
            return;
        end;
    else
        for _, v29 in v27 do
            if not v1.UserCache[v29] and not table.find(v1.RequestBatch, v29) then
                table.insert(v1.RequestBatch, v29);
            end;
        end;
    end;
end;
v1.GetUser = function(_, v31) --[[ Line: 125 ]] --[[ Name: GetUser ]]
    -- upvalues: v1 (copy)
    assert(type(v31) == "number", "UsersAPI:GetUser | userId must be a number");
    if v31 <= 0 then
        local v32 = ("Player%*"):format(v31);
        return {
            IsLoaded = true, 
            DisplayName = v32, 
            HasVerifiedBadge = false, 
            Id = v31, 
            Username = v32
        };
    else
        local v33 = v1.UserCache[v31];
        if v33 and v33.IsLoaded then
            return v33;
        else
            local v34 = coroutine.running();
            if not v1.UserCache[v31] and not table.find(v1.RequestBatch, v31) then
                table.insert(v1.RequestBatch, v31);
            end;
            if not v1.ResumeThreads[v31] then
                v1.ResumeThreads[v31] = {
                    v34
                };
            else
                table.insert(v1.ResumeThreads[v31], v34);
            end;
            return coroutine.yield();
        end;
    end;
end;
task.spawn(v25);
return v1;