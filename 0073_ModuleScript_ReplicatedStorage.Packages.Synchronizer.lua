--[[
  Extracted from: ReplicatedStorage.Packages.Synchronizer
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- [[ Script name: Synchronizer, time of decompilation: Sat Jun 28 18:35:14 2025 ]]
local v0 = game:GetService("RunService"):IsServer();
local v1 = nil;
if v0 then
    v1 = Instance.new("RemoteEvent");
    v1.Name = "CommunicationRoute";
    v1.Parent = script;
else
    v1 = script:WaitForChild("CommunicationRoute");
end;
local v2 = nil;
if v0 then
    v2 = Instance.new("RemoteFunction");
    v2.Name = "RequestData";
    v2.Parent = script;
end;
local v3 = require(script.Channel);
local v4 = require(script.Parent.Signal);
local v5 = {};
local v6 = {
    OnChannelCreated = v4.new(), 
    OnChannelDestroyed = v4.new(), 
    OnChannelListenerAdded = v4.new(), 
    OnChannelListenerRemoved = v4.new()
};
v6.Create = function(v7, v8, v9) --[[ Line: 72 ]] --[[ Name: Create ]]
    -- upvalues: v5 (copy), v3 (copy), v6 (copy)
    assert(v8, "Invalid  Channel Index");
    local v10 = v5[v8];
    if not v10 then
        local v11 = v3.new(v8, v9, v7);
        v5[v8] = v11;
        v10 = v11;
        v6.OnChannelCreated:Fire(v11);
    end;
    return v10;
end;
v6.Destroy = function(_, v13) --[[ Line: 84 ]] --[[ Name: Destroy ]]
    -- upvalues: v5 (copy), v6 (copy)
    assert(v13, "Invalid Channel Index");
    local v14 = v5[v13];
    if v14 then
        v6.OnChannelDestroyed:Fire(v14);
        v14:Destroy(true);
        v5[v13] = nil;
    end;
    return nil;
end;
v6.Get = function(_, v16) --[[ Line: 95 ]] --[[ Name: Get ]]
    -- upvalues: v5 (copy)
    assert(v16, "Invalid Channel Index");
    return v5[v16];
end;
v6.GetTableFromChannel = function(_, v18) --[[ Line: 100 ]] --[[ Name: GetTableFromChannel ]]
    -- upvalues: v5 (copy)
    local v19 = v5[v18];
    if v19 then
        return v19:GetTable();
    else
        return nil;
    end;
end;
v6.GetAllChannels = function(_) --[[ Line: 108 ]] --[[ Name: GetAllChannels ]]
    -- upvalues: v5 (copy)
    return v5;
end;
v6.Wait = function(_, v22) --[[ Line: 112 ]] --[[ Name: Wait ]]
    -- upvalues: v5 (copy), v6 (copy)
    assert(v22, "Invalid Channel Index");
    local v23 = v5[v22];
    if v23 then
        return v23;
    else
        local v24 = coroutine.running();
        local v25 = nil;
        v25 = v6.OnChannelCreated:Connect(function(v26) --[[ Line: 122 ]]
            -- upvalues: v22 (copy), v25 (ref), v24 (copy)
            if v26:GetIndex() == v22 then
                v25:Disconnect();
                coroutine.resume(v24, v26);
            end;
        end);
        return coroutine.yield();
    end;
end;
v6.WaitAndCall = function(v27, v28, v29) --[[ Line: 133 ]] --[[ Name: WaitAndCall ]]
    -- upvalues: v5 (copy), v6 (copy)
    assert(v28, "Invalid Channel Index");
    local v30 = v5[v28];
    if v30 then
        return v29(v30);
    else
        if not v6.WaitingList then
            v6.WaitingList = {};
            v6.OnChannelCreated:Connect(function(v31) --[[ Line: 145 ]]
                -- upvalues: v6 (ref)
                for v32 = #v6.WaitingList, 1, -1 do
                    local v33 = v6.WaitingList[v32];
                    if v31:GetIndex() == v33[1] then
                        task.spawn(v33[2], v31);
                        table.remove(v6.WaitingList, v32);
                    end;
                end;
            end);
        end;
        table.insert(v27.WaitingList, {
            v28, 
            v29
        });
        return nil;
    end;
end;
if v0 then
    v2.OnServerInvoke = function(_, v35) --[[ Line: 166 ]]
        -- upvalues: v5 (copy)
        if not v35 then
            return;
        else
            local v36 = v5[v35];
            if not v36 then
                return;
            else
                return v36:GetTable();
            end;
        end;
    end;
    v6.OnChannelListenerAdded:Connect(function(v37, v38) --[[ Line: 173 ]]
        -- upvalues: v1 (ref)
        local v39 = {
            {
                "ListenerAdded", 
                v37:GetIndex()
            }
        };
        v1:FireClient(v38, v39);
    end);
    v6.OnChannelListenerRemoved:Connect(function(v40, v41) --[[ Line: 178 ]]
        -- upvalues: v1 (ref)
        local v42 = {
            {
                "ListenerRemoved", 
                v40:GetIndex()
            }
        };
        v1:FireClient(v41, v42);
    end);
else
    v1.OnClientEvent:Connect(function(v43) --[[ Line: 185 ]]
        -- upvalues: v6 (copy)
        for _, v45 in v43 do
            local v46 = v45[1];
            if v46 == "ListenerAdded" then
                v6:Create(v45[2]);
            elseif v46 == "ListenerRemoved" then
                v6:Destroy(v45[2]);
            end;
        end;
    end);
    v1:FireServer();
end;
return v6;