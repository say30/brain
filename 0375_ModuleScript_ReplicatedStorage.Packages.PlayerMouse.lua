--[[
  Extracted from: ReplicatedStorage.Packages.PlayerMouse
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local u1 = game:GetService("CollectionService")
local u2 = game:GetService("UserInputService")
local v3 = game:GetService("RunService")
local u4 = game:GetService("Players")
if not v3:IsClient() then
    return table.freeze({
        ["Hit"] = CFrame.identity,
        ["Target"] = nil
    })
end
local u5 = RaycastParams.new()
local v6 = table.clone(u1:GetTagged("ExcludeFromRaycast") or {})
local v7 = u4.LocalPlayer.Character
if v7 then
    table.insert(v6, v7)
end
u5.FilterDescendantsInstances = v6
u5.FilterType = Enum.RaycastFilterType.Exclude
u4.LocalPlayer.CharacterAdded:Connect(function(_) --[[Anonymous function at line 32]]
    --[[
    Upvalues:
        [1] = u5
        [2] = u1
        [3] = u4
    --]]
    local v8 = u5
    local v9 = table.clone(u1:GetTagged("ExcludeFromRaycast") or {})
    local v10 = u4.LocalPlayer.Character
    if v10 then
        table.insert(v9, v10)
    end
    v8.FilterDescendantsInstances = v9
end)
local u11 = {
    ["Hit"] = CFrame.identity,
    ["Target"] = nil
}
local function v21() --[[Anonymous function at line 41]]
    --[[
    Upvalues:
        [1] = u2
        [2] = u5
        [3] = u11
    --]]
    local v12 = u2:GetMouseLocation()
    local v13 = workspace.CurrentCamera:ViewportPointToRay(v12.X, v12.Y)
    local v14 = v13.Origin
    local v15 = v13.Direction
    local v16 = v15 * 1000
    local v17 = workspace:Raycast(v14, v16, u5)
    local v18
    if v17 then
        v18 = v17.Position
    else
        v18 = v14 + v16
    end
    u11.Hit = CFrame.lookAt(v18, v18 + v15)
    local v19 = u11
    local v20
    if v17 then
        v20 = v17.Instance
    else
        v20 = nil
    end
    v19.Target = v20
end
v3.PreRender:Connect(v21)
task.spawn(v21)
u1:GetInstanceAddedSignal("ExcludeFromRaycast"):Connect(function() --[[Anonymous function at line 59]]
    --[[
    Upvalues:
        [1] = u5
        [2] = u1
        [3] = u4
    --]]
    local v22 = u5
    local v23 = table.clone(u1:GetTagged("ExcludeFromRaycast") or {})
    local v24 = u4.LocalPlayer.Character
    if v24 then
        table.insert(v23, v24)
    end
    v22.FilterDescendantsInstances = v23
end)
u1:GetInstanceRemovedSignal("ExcludeFromRaycast"):Connect(function() --[[Anonymous function at line 63]]
    --[[
    Upvalues:
        [1] = u5
        [2] = u1
        [3] = u4
    --]]
    local v25 = u5
    local v26 = table.clone(u1:GetTagged("ExcludeFromRaycast") or {})
    local v27 = u4.LocalPlayer.Character
    if v27 then
        table.insert(v26, v27)
    end
    v25.FilterDescendantsInstances = v26
end)
return u11