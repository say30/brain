--[[
  Extracted from: ReplicatedStorage.Packages.Synchronizer.Channel
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: Channel, time of decompilation: Sat Jun 28 18:35:14 2025 ]]
local l_RunService_0 = game:GetService("RunService");
local l_Debris_0 = game:GetService("Debris");
local l_HttpService_0 = game:GetService("HttpService");
local v3 = require(script.Parent.Parent.Signal);
local v4 = l_RunService_0:IsServer();
local l_RequestData_0 = script.Parent:WaitForChild("RequestData");
local v6 = {};
v6.__index = v6;
local function v16(v7, v8) --[[ Line: 77 ]] --[[ Name: ReadPath ]]
    local v9 = string.split(v7, ".");
    local l_v8_0 = v8;
    local v11 = nil;
    local v12 = nil;
    for v13 = 1, #v9 do
        local v14 = v9[v13];
        local v15 = nil;
        v15 = tonumber(v14) or v14;
        v11 = l_v8_0;
        l_v8_0 = l_v8_0[v15];
        v12 = v15;
        if l_v8_0 == nil then
            return nil, v11, v12;
        end;
    end;
    return l_v8_0, v11, v12;
end;
local function _(v17, v18) --[[ Line: 92 ]] --[[ Name: FireAction ]]
    local v19 = v18[1];
    local v20 = v18[2];
    if v19 ~= "" then
        local v21 = v17.Signals[v20][v19];
        if v21 then
            v21:Fire(v18[3], v18[4], v18[5]);
        end;
    end;
end;
local function v31(v23) --[[ Line: 106 ]] --[[ Name: DispatchQueuedActions ]]
    -- upvalues: v4 (copy)
    if #v23.Queue == 0 then
        return;
    else
        for v24 = 1, #v23.Queue do
            local v25 = v23.Queue[v24];
            local v26 = v25[1];
            local v27 = v25[2];
            if v26 ~= "" then
                local v28 = v23.Signals[v27][v26];
                if v28 then
                    v28:Fire(v25[3], v25[4], v25[5]);
                end;
            end;
        end;
        if v4 then
            for _, v30 in v23.Listeners do
                v23.CommunicationRoute:FireClient(v30, v23.Queue);
            end;
        end;
        table.clear(v23.Queue);
        return;
    end;
end;
local function v37(v32, v33) --[[ Line: 127 ]] --[[ Name: InsertOnQueue ]]
    local v34 = v33[1];
    local v35 = v33[2];
    if v35 ~= "ArrayInsert" and v35 ~= "ArrayRemoved" and v35 ~= "DictionaryInsert" and v35 ~= "DictionaryRemoved" then
        for v36 = #v32.Queue, 1, -1 do
            if v32.Queue[v36][1] == v34 and v32.Queue[v36][2] == v35 then
                table.remove(v32.Queue, v36);
                break;
            end;
        end;
    end;
    table.insert(v32.Queue, v33);
end;
v6.new = function(v38, v39, v40) --[[ Line: 144 ]] --[[ Name: new ]]
    -- upvalues: v6 (copy), v3 (copy), v4 (copy), l_RequestData_0 (copy), v16 (copy), l_RunService_0 (copy), v31 (copy)
    local v41 = setmetatable({}, v6);
    v41.Index = v38;
    v41.Queue = {};
    v41.Synchronizer = v40;
    v41.Connections = {};
    v41.SavedConnections = {};
    v41.OnDestroyed = v3.new();
    v41.Listeners = {};
    v41.Signals = {
        Changed = {}, 
        ArrayInsert = {}, 
        ArrayRemoved = {}, 
        DictionaryInsert = {}, 
        DictionaryRemoved = {}
    };
    if v4 then
        v41.ReferenceTable = v39;
    end;
    if v4 then
        local l_RemoteEvent_0 = Instance.new("RemoteEvent");
        l_RemoteEvent_0.Name = tostring(v38);
        l_RemoteEvent_0.Parent = script;
        v41.CommunicationRoute = l_RemoteEvent_0;
    else
        v41.CommunicationRoute = script:WaitForChild((tostring(v38)));
    end;
    if not v4 then
        v41.CacheTable = l_RequestData_0:InvokeServer(v41:GetIndex());
        table.insert(v41.Connections, v41.CommunicationRoute.OnClientEvent:Connect(function(v43) --[[ Line: 187 ]]
            -- upvalues: v16 (ref), v41 (copy)
            for v44 = 1, #v43 do
                local v45 = v43[v44];
                local v46 = v45[1];
                local v47, v48, v49 = v16(v46, v41:GetTable());
                if v45[2] == "Changed" then
                    local v50 = v45[3];
                    local _ = v45[4];
                    v45[4] = v47;
                    v48[v49] = v50;
                elseif v45[2] == "ArrayInsert" then
                    table.insert(v47, v45[4], v45[3]);
                elseif v45[2] == "ArrayRemoved" then
                    table.remove(v47, v45[4]);
                elseif v45[2] == "DictionaryInsert" then
                    v47[v45[4]] = v45[3];
                elseif v45[2] == "DictionaryRemoved" then
                    v47[v45[4]] = nil;
                end;
                local l_v41_0 = v41;
                local v53 = v45[1];
                local v54 = v45[2];
                if v53 ~= "" then
                    local v55 = l_v41_0.Signals[v54][v53];
                    if v55 then
                        v55:Fire(v45[3], v45[4], v45[5]);
                    end;
                end;
            end;
        end));
    end;
    if v4 then
        table.insert(v41.Connections, l_RunService_0.Stepped:Connect(function() --[[ Line: 219 ]]
            -- upvalues: v31 (ref), v41 (copy)
            v31(v41);
        end));
    end;
    return v41;
end;
v6.InsertOnDictionary = function(v56, v57, v58, v59) --[[ Line: 229 ]] --[[ Name: InsertOnDictionary ]]
    -- upvalues: v16 (copy), v37 (copy)
    assert(v57 and typeof(v57) == "string", "Invalid path string required!");
    assert(v59, "Value is nil!");
    assert(v58, "Index is nil!");
    local v60, _, _ = v16(v57, v56:GetTable());
    if not v60 then
        return;
    else
        v60[v58] = v59;
        v37(v56, {
            v57, 
            "DictionaryInsert", 
            v59, 
            v58
        });
        return;
    end;
end;
v6.RemoveFromDictionary = function(v63, v64, v65) --[[ Line: 245 ]] --[[ Name: RemoveFromDictionary ]]
    -- upvalues: v16 (copy), v37 (copy)
    assert(v64 and typeof(v64) == "string", "Invalid path string required!");
    assert(v65, "Index is nil!");
    local v66, _, _ = v16(v64, v63:GetTable());
    if not v66 then
        return;
    else
        local v69 = v66[v65];
        v66[v65] = nil;
        v37(v63, {
            v64, 
            "DictionaryRemoved", 
            v69, 
            v65
        });
        return v69;
    end;
end;
v6.InsertOnArray = function(v70, v71, v72, v73) --[[ Line: 261 ]] --[[ Name: InsertOnArray ]]
    -- upvalues: v16 (copy), v37 (copy)
    assert(v71 and typeof(v71) == "string", "Invalid path string required!");
    assert(v72, "Value is nil!");
    if v73 then
        assert(v73 and typeof(v73) == "number", "Invalid target index!");
    end;
    local v74, _, _ = v16(v71, v70:GetTable());
    if not v74 then
        return;
    else
        local v77 = nil;
        if v73 then
            table.insert(v74, v73, v72);
            v77 = v73;
        else
            table.insert(v74, v72);
            v77 = #v74;
        end;
        v37(v70, {
            v71, 
            "ArrayInsert", 
            v72, 
            v77
        });
        return v77;
    end;
end;
v6.RemoveFromArray = function(v78, v79, v80) --[[ Line: 287 ]] --[[ Name: RemoveFromArray ]]
    -- upvalues: v16 (copy), v37 (copy)
    assert(v79 and typeof(v79) == "string", "Invalid path string required!");
    assert(v80, "Target index is invalid!");
    local v81, _, _ = v16(v79, v78:GetTable());
    if not v81 then
        return;
    else
        local v84 = table.remove(v81, v80);
        v37(v78, {
            v79, 
            "ArrayRemoved", 
            v84, 
            v80
        });
        return v84;
    end;
end;
v6.Set = function(v85, v86, v87) --[[ Line: 302 ]] --[[ Name: Set ]]
    -- upvalues: v16 (copy), v37 (copy)
    assert(v86 and typeof(v86) == "string", "Invalid path string required!");
    local v88, v89, v90 = v16(v86, v85:GetTable());
    if not v89 then
        return v85;
    else
        v89[v90] = v87;
        v37(v85, {
            v86, 
            "Changed", 
            v87, 
            v88
        });
        return v85;
    end;
end;
v6.Increase = function(v91, v92, v93) --[[ Line: 314 ]] --[[ Name: Increase ]]
    -- upvalues: v16 (copy), v37 (copy)
    assert(v92 and typeof(v92) == "string", "Invalid path string required!");
    assert(v93 and typeof(v93) == "number", "Invalid value number required!");
    local v94, v95, v96 = v16(v92, v91:GetTable());
    if not v95 or not v96 then
        return v91;
    else
        v95[v96] = v94 + v93;
        v37(v91, {
            v92, 
            "Changed", 
            v94 + v93, 
            v94
        });
        return v91;
    end;
end;
v6.OnChanged = function(v97, v98, v99, v100) --[[ Line: 329 ]] --[[ Name: OnChanged ]]
    -- upvalues: v3 (copy)
    assert(v98 and typeof(v98) == "string", "Invalid path string required!");
    local v101 = v97.Signals.Changed[v98];
    if not v101 then
        v101 = v3.new();
        v97.Signals.Changed[v98] = v101;
    end;
    if v100 == true then
        v99(v97:Get(v98), nil);
    end;
    return (v101:Connect(v99));
end;
v6.OnDictionaryInserted = function(v102, v103, v104) --[[ Line: 346 ]] --[[ Name: OnDictionaryInserted ]]
    -- upvalues: v3 (copy)
    assert(v103 and typeof(v103) == "string", "Invalid path string required!");
    local v105 = v102.Signals.DictionaryInsert[v103];
    if not v105 then
        v105 = v3.new();
        v102.Signals.DictionaryInsert[v103] = v105;
    end;
    return (v105:Connect(v104));
end;
v6.OnDictionaryRemoved = function(v106, v107, v108) --[[ Line: 360 ]] --[[ Name: OnDictionaryRemoved ]]
    -- upvalues: v3 (copy)
    assert(v107 and typeof(v107) == "string", "Invalid path string required!");
    local v109 = v106.Signals.DictionaryRemoved[v107];
    if not v109 then
        v109 = v3.new();
        v106.Signals.DictionaryRemoved[v107] = v109;
    end;
    return (v109:Connect(v108));
end;
v6.OnArrayInserted = function(v110, v111, v112) --[[ Line: 374 ]] --[[ Name: OnArrayInserted ]]
    -- upvalues: v3 (copy)
    assert(v111 and typeof(v111) == "string", "Invalid path string required!");
    local v113 = v110.Signals.ArrayInsert[v111];
    if not v113 then
        v113 = v3.new();
        v110.Signals.ArrayInsert[v111] = v113;
    end;
    return (v113:Connect(v112));
end;
v6.OnArrayRemoved = function(v114, v115, v116) --[[ Line: 388 ]] --[[ Name: OnArrayRemoved ]]
    -- upvalues: v3 (copy)
    assert(v115 and typeof(v115) == "string", "Invalid path string required!");
    local v117 = v114.Signals.ArrayRemoved[v115];
    if not v117 then
        v117 = v3.new();
        v114.Signals.ArrayRemoved[v115] = v117;
    end;
    return (v117:Connect(v116));
end;
v6.AddListener = function(v118, v119) --[[ Line: 404 ]] --[[ Name: AddListener ]]
    if table.find(v118.Listeners, v119) then
        return v118;
    else
        table.insert(v118.Listeners, v119);
        v118.Synchronizer.OnChannelListenerAdded:Fire(v118, v119);
        return v118;
    end;
end;
v6.RemoveListener = function(v120, v121) --[[ Line: 415 ]] --[[ Name: RemoveListener ]]
    local v122 = table.find(v120.Listeners, v121);
    if not v122 then
        return v120;
    else
        table.remove(v120.Listeners, v122);
        v120.Synchronizer.OnChannelListenerRemoved:Fire(v120, v121);
        return v120;
    end;
end;
v6.Get = function(v123, v124) --[[ Line: 428 ]] --[[ Name: Get ]]
    -- upvalues: v16 (copy)
    if not v124 then
        return v123:GetTable();
    else
        return v16(v124, v123:GetTable());
    end;
end;
v6.GetIndex = function(v125) --[[ Line: 435 ]] --[[ Name: GetIndex ]]
    return v125.Index;
end;
v6.GetTable = function(v126) --[[ Line: 439 ]] --[[ Name: GetTable ]]
    -- upvalues: v4 (copy)
    return v4 and v126.ReferenceTable or v126.CacheTable;
end;
v6.Destroy = function(v127, v128) --[[ Line: 443 ]] --[[ Name: Destroy ]]
    -- upvalues: v4 (copy), l_HttpService_0 (copy), l_Debris_0 (copy)
    if v128 ~= true then
        return v127.Synchronizer:Destroy(v127:GetIndex());
    else
        if v4 then
            for _, v130 in v127.Listeners do
                v127:RemoveListener(v130);
            end;
            v127.CommunicationRoute.Name = l_HttpService_0:GenerateGUID(false);
            l_Debris_0:AddItem(v127.CommunicationRoute, 5);
        end;
        v127.OnDestroyed:Fire(v127);
        v127.OnDestroyed:DisconnectAll();
        for _, v132 in v127.Connections do
            v132:Disconnect();
        end;
        for _, v134 in v127.SavedConnections do
            v134:Disconnect();
        end;
        v127.OnDestroyed:Destroy();
        for _, v136 in v127.Signals do
            for _, v138 in v136 do
                v138:DisconnectAll();
                v138:Destroy();
            end;
        end;
        setmetatable(v127, nil);
        return nil;
    end;
end;
return v6;