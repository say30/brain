--[[
  Extracted from: ReplicatedStorage.Classes.Interface
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local v1 = game:GetService("ReplicatedStorage")
local u2 = game:GetService("TweenService")
local v3 = v1:WaitForChild("Controllers")
local u4 = require(v3.CameraController)
local v5 = v1:WaitForChild("Classes")
local u6 = require(v5.AnimatedButton)
local v7 = v1.Packages
local u8 = require(v7.Signal)
local u9 = require(v7.Trove)
local u10 = require(script.Styles)
local u11 = v3.InterfaceController.Toggle
local u12 = {}
u12.__index = u12
function u12.AttachCloseButton(u13, p14, p15) --[[Anonymous function at line 53]]
    --[[
    Upvalues:
        [1] = u6
        [2] = u11
    --]]
	local v16 = u6.new(p14, p15)
	u13.Collector:Add(v16, "Destroy")
	v16:Animate(nil, nil, 5)
	u13.Collector:Add(v16.OnActivated:Connect(function() --[[Anonymous function at line 57]]
        --[[
        Upvalues:
            [1] = u11
            [2] = u13
        --]]
		u11:Fire(u13.Name, false)
	end))
end
function u12.GetName(p17) --[[Anonymous function at line 62]]
	return p17.Name
end
function u12.GetStyleData(p18) --[[Anonymous function at line 66]]
    --[[
    Upvalues:
        [1] = u10
    --]]
	return u10[p18:GetStyle()]
end
function u12.GetStyle(p19) --[[Anonymous function at line 70]]
	return p19.Style
end
function u12.SetStyle(p20, p21) --[[Anonymous function at line 74]]
	p20.Style = p21
end
function u12.Open(p22, _) --[[Anonymous function at line 78]]
    --[[
    Upvalues:
        [1] = u10
        [2] = u2
        [3] = u4
    --]]
	if p22.ToggleConnection then
		p22.ToggleConnection:Disconnect()
		p22.ToggleConnection = nil
	end
	p22.State = true
	p22.Object.Visible = p22.State
	if p22.Style ~= "Custom" then
		local v23 = u10[p22.Style]
		local v24 = p22.Defaults.Position
		local v25 = p22.Defaults.Size
		local v26 = TweenInfo.new(v23.ToggleTime, v23.Style)
		u2:Create(p22.Object, v26, {
			["Position"] = v24,
			["Size"] = v25
		}):Play()
		u4:Blur(v23.BlurSize or 0, v23.ToggleTime)
		u4:Fov(v23.Fov or u4:GetDefaultFov(), v23.ToggleTime)
	end
	p22.OnOpen:Fire()
end
function u12.Close(u27, _) --[[Anonymous function at line 105]]
    --[[
    Upvalues:
        [1] = u10
        [2] = u2
    --]]
	if u27.ToggleConnection then
		u27.ToggleConnection:Disconnect()
		u27.ToggleConnection = nil
	end
	u27.State = false
	if u27.Style ~= "Custom" then
		local v28 = u10[u27.Style]
		local v29 = u27.Defaults.Position + v28.Position
		local v30 = u27.Defaults.Size + v28.Size
		local v31 = TweenInfo.new(v28.ToggleTime, v28.Style)
		local v32 = u2:Create(u27.Object, v31, {
			["Position"] = v29,
			["Size"] = v30
		})
		u27.ToggleConnection = v32.Completed:Connect(function() --[[Anonymous function at line 120]]
            --[[
            Upvalues:
                [1] = u27
            --]]
			u27.Object.Visible = false
		end)
		v32:Play()
	end
	u27.OnClose:Fire()
end
function u12.Toggle(p33, p34) --[[Anonymous function at line 129]]
	p33[(p34 or not p33.State) == true and "Open" or "Close"](p33)
end
function u12.IsOpened(p35) --[[Anonymous function at line 134]]
	return p35.State
end
function u12.new(p36, p37, p38) --[[Anonymous function at line 138]]
    --[[
    Upvalues:
        [1] = u12
        [2] = u8
        [3] = u9
    --]]
	local v39 = u12
	local v40 = setmetatable({}, v39)
	v40.Name = p36
	v40.Object = p37
	v40.Defaults = {}
	v40.Defaults.Position = v40.Object.Position
	v40.Defaults.Size = v40.Object.Size
	v40.State = true
	v40.Style = p38 or "TopQuint"
	v40.OnOpen = u8.new()
	v40.OnClose = u8.new()
	v40.Collector = u9.new()
	return v40
end
return u12