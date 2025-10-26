--[[
  Extracted from: ReplicatedStorage.Packages.FFlags.Server
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: Server, time of decompilation: Sat Jul 12 14:20:53 2025 ]]
local l_MemoryStoreService_0 = game:GetService("MemoryStoreService");
local l_ReplicatedStorage_0 = game:GetService("ReplicatedStorage");
local l_DataStoreService_0 = game:GetService("DataStoreService");
local l_RunService_0 = game:GetService("RunService");
local v4 = require(l_ReplicatedStorage_0.Packages.Replion);
local v5 = require(l_ReplicatedStorage_0.Packages.Signal);
local _ = require(script.Parent.Types);
local v7 = require(script.Parent.Environments);
local v8 = require(script.Parent.Overrides);
local v9 = Random.new();
local v10 = nil;
local v11 = nil;
local v12 = {
    _loaded = false, 
    _loadedSignal = v5.new(), 
    _updatedSignal = v5.new()
};
local function v18(v13, v14) --[[ Line: 61 ]] --[[ Name: waitForBudget ]]
    -- upvalues: l_DataStoreService_0 (copy)
    local v15 = v14 or 10;
    local v16 = os.clock();
    local l_v16_0 = v16;
    while l_DataStoreService_0:GetRequestBudgetForRequestType(v13) < 1 and l_v16_0 - v16 < v15 do
        task.wait();
        l_v16_0 = os.clock();
    end;
    return l_v16_0 - v16 < v15;
end;
v12.IsLoaded = function(v19) --[[ Line: 74 ]] --[[ Name: IsLoaded ]]
    return v19._loaded;
end;
v12.OnLoad = function(v20, v21) --[[ Line: 78 ]] --[[ Name: OnLoad ]]
    return v20._loadedSignal:Connect(v21);
end;
v12.OnUpdate = function(v22, v23) --[[ Line: 82 ]] --[[ Name: OnUpdate ]]
    return v22._updatedSignal:Connect(v23);
end;
v12.OnChange = function(_, v25, v26) --[[ Line: 86 ]] --[[ Name: OnChange ]]
    -- upvalues: v11 (ref)
    return v11:OnChange({
        "Values", 
        v25
    }, v26);
end;
v12.Get = function(v27, v28, v29) --[[ Line: 91 ]] --[[ Name: Get ]]
    -- upvalues: v11 (ref)
    if not v27:IsLoaded() then
        v27._loadedSignal:Wait();
    end;
    local v30 = v11:Get({
        "Values", 
        v28
    });
    if v30 == nil then
        return v29;
    else
        return v30;
    end;
end;
v12.GetInstant = function(_, v32, v33) --[[ Line: 104 ]] --[[ Name: GetInstant ]]
    -- upvalues: v11 (ref)
    local v34 = v11:Get({
        "Values", 
        v32
    });
    if v34 == nil then
        return v33;
    else
        return v34;
    end;
end;
v12.Set = function(_, v36, v37, v38) --[[ Line: 113 ]] --[[ Name: Set ]]
    -- upvalues: v10 (ref), v11 (ref), v8 (copy), l_MemoryStoreService_0 (copy), l_DataStoreService_0 (copy), v18 (copy)
    if v38 == v10 or v38 == "all" or v38 == "local" then
        v11:Set({
            "Values", 
            v36
        }, v37);
        v11:Set("LastChange", workspace:GetServerTimeNow());
    end;
    if v38 == "local" then
        if not v8[v10] then
            v8[v10] = {};
        end;
        v8[v10][v36] = v37;
        return true;
    else
        local function v48(v39) --[[ Line: 128 ]] --[[ Name: transformData ]]
            -- upvalues: v36 (copy), v38 (copy), v37 (copy)
            local l_UnixTimestamp_0 = DateTime.now().UnixTimestamp;
            local v41 = if v39 and typeof(v39) == "table" and typeof(v39.Values) == "table" then v39 else {
                Values = {}, 
                LastUpdate = l_UnixTimestamp_0
            };
            local v42 = false;
            for _, v44 in v41.Values do
                local v45 = v44[1];
                local v46 = v44[3];
                if v36 == v45 and v38 == v46 then
                    v42 = true;
                    v44[2] = v37;
                    if v38 == nil then
                        table.remove(v44, 3);
                    else
                        v44[3] = v38;
                    end;
                end;
            end;
            if not v42 then
                local v47 = {
                    v36, 
                    v37
                };
                if v38 ~= nil then
                    table.insert(v47, v38);
                end;
                table.insert(v41.Values, v47);
            end;
            return v41;
        end;
        for v49 = 1, 5 do
            local l_status_0, l_result_0 = pcall(function() --[[ Line: 177 ]]
                -- upvalues: l_MemoryStoreService_0 (ref), v49 (copy)
                return l_MemoryStoreService_0:GetHashMap((("FFlags-%*"):format(v49)));
            end);
            if not l_status_0 then
                warn((("Failed to save HashMap FFlags-%*/FFlags: %*"):format(v49, l_result_0)));
            else
                local l_status_1, l_result_1 = pcall(function() --[[ Line: 186 ]]
                    -- upvalues: l_result_0 (copy), v48 (copy)
                    return l_result_0:UpdateAsync("FFlags", v48, 3888000);
                end);
                if not l_status_1 then
                    warn((("Failed to update HashMap FFlags-%*/FFlags: %*"):format(v49, l_result_1)));
                end;
            end;
        end;
        for v54 = 1, 3 do
            local l_status_2, l_result_2 = pcall(function() --[[ Line: 201 ]]
                -- upvalues: l_DataStoreService_0 (ref), v54 (copy)
                return l_DataStoreService_0:GetDataStore((("FFlags-%*"):format(v54)));
            end);
            if not l_status_2 then
                warn((("Failed to save DataStore FFlags-%*/FFlags: %*"):format(v54, l_result_2)));
            elseif not v18(Enum.DataStoreRequestType.UpdateAsync, 30) then
                warn("No DataStore:UpdateAsync() request budget available");
                return false;
            else
                local l_status_3, l_result_3 = pcall(function() --[[ Line: 216 ]]
                    -- upvalues: l_result_2 (copy), v48 (copy)
                    return l_result_2:UpdateAsync("FFlags", v48);
                end);
                if not l_status_3 then
                    warn((("Failed to update DataStore FFlags-%*/FFlags: %*"):format(v54, l_result_3)));
                end;
            end;
        end;
        return true;
    end;
end;
v12._loadMemoryStore = function(_, v60) --[[ Line: 229 ]] --[[ Name: _loadMemoryStore ]]
    -- upvalues: v9 (copy), l_MemoryStoreService_0 (copy)
    local v61 = v60 or v9:NextInteger(1, 5);
    local l_status_4, l_result_4 = pcall(function() --[[ Line: 231 ]]
        -- upvalues: l_MemoryStoreService_0 (ref), v61 (copy)
        return l_MemoryStoreService_0:GetHashMap((("FFlags-%*"):format(v61)));
    end);
    if not l_status_4 then
        warn((("MemoryStoreService:GetHashMap() failed on 'FFlags-%*': %*"):format(v61, l_result_4)));
        return false;
    else
        local l_status_5, l_result_5 = pcall(function() --[[ Line: 240 ]]
            -- upvalues: l_result_4 (copy)
            return l_result_4:GetAsync("FFlags");
        end);
        if not l_status_5 then
            warn((("Failed to load HashMap FFlags-%*/FFlags: %*"):format(v61, l_result_5)));
            return false;
        else
            if typeof(l_result_5) ~= "table" or typeof(l_result_5.Values) ~= "table" then
                warn((("Invalid data format in HashMap FFlags-%*/FFlags: %*"):format(v61, l_result_5)));
                l_result_5 = {
                    Values = {}, 
                    LastUpdate = 0
                };
            end;
            local l_UnixTimestamp_1 = DateTime.now().UnixTimestamp;
            if l_UnixTimestamp_1 - (if typeof(l_result_5.LastUpdate) == "number" then l_result_5.LastUpdate else l_UnixTimestamp_1) >= 2592000 then
                task.spawn(function() --[[ Line: 261 ]]
                    -- upvalues: v61 (copy), l_result_4 (copy)
                    print((("Reconciling data in HashMap FFlags-%*/FFlags"):format(v61)));
                    local l_status_6, l_result_6 = pcall(l_result_4.UpdateAsync, l_result_4, "FFlags", function(v67) --[[ Line: 264 ]]
                        local l_UnixTimestamp_2 = DateTime.now().UnixTimestamp;
                        if typeof(v67) ~= "table" or typeof(v67.Values) ~= "table" then
                            v67 = {
                                Values = {}, 
                                LastUpdate = 0
                            };
                        end;
                        if l_UnixTimestamp_2 - (if typeof(v67.LastUpdate) == "number" then v67.LastUpdate else 0) < 2592000 then
                            return nil;
                        else
                            v67.LastUpdate = l_UnixTimestamp_2;
                            return v67;
                        end;
                    end, 3888000);
                    if l_status_6 then
                        print((("Successfully reconciled data in HashMap FFlags-%*/FFlags"):format(v61)));
                        return;
                    else
                        warn((("Failed to reconcile data in HashMap FFlags-%*/FFlags: %*"):format(v61, l_result_6)));
                        return;
                    end;
                end);
            end;
            return true, l_result_5;
        end;
    end;
end;
v12._loadDataStore = function(_, v72) --[[ Line: 299 ]] --[[ Name: _loadDataStore ]]
    -- upvalues: v9 (copy), l_DataStoreService_0 (copy), v18 (copy)
    local v73 = v72 or v9:NextInteger(1, 3);
    local l_status_7, l_result_7 = pcall(function() --[[ Line: 301 ]]
        -- upvalues: l_DataStoreService_0 (ref), v73 (copy)
        return l_DataStoreService_0:GetDataStore((("FFlags-%*"):format(v73)));
    end);
    if not l_status_7 then
        warn((("DataStoreService:GetDataStore() failed on 'FFlags-%*': %*"):format(v73, l_result_7)));
        return false;
    else
        local l_DataStoreGetOptions_0 = Instance.new("DataStoreGetOptions");
        l_DataStoreGetOptions_0.UseCache = false;
        if not v18(Enum.DataStoreRequestType.GetAsync) then
            warn("No DataStore:GetAsync() request budget available");
            return false;
        else
            local l_status_8, l_result_8 = pcall(function() --[[ Line: 319 ]]
                -- upvalues: l_result_7 (copy), l_DataStoreGetOptions_0 (copy)
                return l_result_7:GetAsync("FFlags", l_DataStoreGetOptions_0);
            end);
            if not l_status_8 then
                warn((("Failed to load DataStore FFlags-%*/FFlags: %*"):format(v73, l_result_8)));
                return false;
            else
                if typeof(l_result_8) ~= "table" or typeof(l_result_8.Values) ~= "table" then
                    warn((("Invalid data format in DataStore FFlags-%*/FFlags: %*"):format(v73, l_result_8)));
                    l_result_8 = {
                        Values = {}, 
                        LastUpdate = 0
                    };
                end;
                return true, l_result_8;
            end;
        end;
    end;
end;
v12.Load = function(v79) --[[ Line: 341 ]] --[[ Name: Load ]]
    -- upvalues: l_RunService_0 (copy), v10 (ref), v11 (ref), v4 (copy), v8 (copy)
    local v80 = nil;
    local v81 = nil;
    if l_RunService_0:IsStudio() then
        local v82, v83 = v79:_loadDataStore();
        v80 = v82;
        v81 = v83;
    else
        local v84, v85 = v79:_loadMemoryStore();
        v80 = v84;
        v81 = v85;
    end;
    if not v80 then
        local v86 = 0;
        while v86 < 3 and not v80 do
            warn((("Failed to load FFlags %*, retrying..."):format(l_RunService_0:IsStudio() and "DataStore" or "MemoryStore HashMap")));
            v86 = v86 + 1;
            task.wait(v86 * 1);
            local v87, v88 = v79:_loadMemoryStore();
            v80 = v87;
            v81 = v88;
        end;
        if not v80 then
            warn("All attempts to load FFlags MemoryStore HashMaps failed, loading DataStore instead");
            local v89, v90 = v79:_loadDataStore();
            v80 = v89;
            v81 = v90;
        end;
    end;
    if not v80 or not v81 then
        warn("Failed to load FFlags: both MemoryStore and DataStore requests failed!");
        return false;
    else
        local v91 = {};
        for _, v93 in v81.Values do
            local v94 = v93[1];
            local v95 = v93[2];
            local v96 = v93[3] or "all";
            if v94 and (v96 ~= "all" or not v91[v94]) and (v96 == v10 or v96 == "all") then
                v91[v94] = v95;
            end;
        end;
        for v97, _ in v11.Data.Values do
            if v91[v97] == nil then
                v91[v97] = v4.None;
            end;
        end;
        if v8[v10] then
            for v99, v100 in v8[v10] do
                v91[v99] = v100;
            end;
        end;
        local l_workspace_ServerTimeNow_0 = workspace:GetServerTimeNow();
        v11:Update({
            Loaded = true, 
            LastUpdate = l_workspace_ServerTimeNow_0, 
            LastChange = l_workspace_ServerTimeNow_0, 
            Values = v91
        });
        print("Loaded FFlags:", v11.Data);
        if not v79._loaded then
            v79._loaded = true;
            v79._loadedSignal:Fire(v11.Data);
        end;
        v79._updatedSignal:Fire(v11.Data);
        return true;
    end;
end;
v12.Start = function(v102) --[[ Line: 423 ]] --[[ Name: Start ]]
    -- upvalues: v7 (copy), v10 (ref), l_RunService_0 (copy), v9 (copy)
    for v103, v104 in v7 do
        if v104.UniverseIds and table.find(v104.UniverseIds, game.GameId) then
            v10 = if l_RunService_0:IsStudio() and v104.StudioEnvironment then v104.StudioEnvironment else v103;
            break;
        elseif not v104.UniverseIds or #v104.UniverseIds == 0 and not v10 then
            v10 = v103;
        end;
    end;
    if v10 then
        local v105 = 0;
        while true do
            local l_workspace_ServerTimeNow_1 = workspace:GetServerTimeNow();
            if v105 < l_workspace_ServerTimeNow_1 then
                v105 = l_workspace_ServerTimeNow_1 + 300 * v9:NextNumber(0.7, 1.3);
                v102:Load();
            end;
            task.wait(1);
        end;
    end;
end;
v11 = v4.Server.new({
    Channel = "FFlags", 
    ReplicateTo = "All", 
    Data = {
        Values = {}, 
        Loaded = false, 
        LastUpdate = 0, 
        LastChange = 0
    }
});
task.spawn(v12.Start, v12);
return v12;