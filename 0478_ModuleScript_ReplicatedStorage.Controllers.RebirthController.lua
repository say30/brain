--[[
  Extracted from: ReplicatedStorage.Controllers.RebirthController
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
game:GetService("TweenService")
local v3 = v1:WaitForChild("Packages")
local v4 = v1:WaitForChild("Controllers")
local v5 = v1:WaitForChild("Classes")
local v6 = v1:WaitForChild("Utils")
local v7 = v1:WaitForChild("Datas")
local v8 = v1:WaitForChild("Shared")
local v9 = require(v3.Net)
local u10 = require(v4.InterfaceController)
require(v4.CameraController)
local u11 = require(v5.AnimatedButton)
local u12 = require(v3.Synchronizer)
local u13 = require(v6.NumberUtils)
local u14 = require(v7.Rebirth)
local u15 = require(v4.NotificationController)
local u16 = require(v4.AnimalController)
local u17 = require(v8.Animals)
local u18 = require(v7.Animals)
local u19 = require(v7.Rarities)
local u20 = require(v7.ShopItems)
local u21 = require(v8.Updates)
local u22 = v9:RemoteFunction("Rebirth/RequestRebirth")
local u23 = v2.LocalPlayer
local v24 = u23:WaitForChild("PlayerGui")
local u25 = v24:WaitForChild("Rebirth"):WaitForChild("Rebirth")
local u26 = u25.Header.Close
local v27 = u25.Content
local v28 = v27.Holder.HolderImage
local v29 = v28.Loader.Bar
local u30 = v29.Progress
local u31 = v29.ProgressText
local u32 = v27.Rebirth
local u33 = v28.RequiredCharacters
local u34 = u33.Template
local u35 = v27.Unlockable.Items
local u36 = u35.Template
local u37 = v24:WaitForChild("LeftCenter").LeftCenter.Buttons.Rebirth.Warning
local u38 = nil
local v39 = {}
local function u55(p40) --[[Anonymous function at line 68]]
    --[[
    Upvalues:
        [1] = u14
        [2] = u35
        [3] = u36
        [4] = u20
        [5] = u13
    --]]
	local v41 = #u14
	local v42 = p40 + 1
	if #u35:GetChildren() >= 1 then
		for _, v43 in ipairs(u35:GetChildren()) do
			if v43.Name ~= "Template" and v43:IsA("ImageLabel") then
				v43:Destroy()
			end
		end
	end
	if v41 < v42 then
		return 0
	end
	if u14[v42].IsEnabled and (not u14[v42].IsEnabled() and v41 - 1 < v42) then
		return 0
	end
	local v44 = u14[v42].Rewards
	for v45, v46 in pairs(v44) do
		if v45 == "Items" and typeof(v46) == "table" then
			for _, v47 in ipairs(v46) do
				local v48 = u36:Clone()
				local v49 = v48.ItemName
				local v50 = v48.ItemImage
				v49.Text = string.upper(v47)
				v48.Name = v47
				v50.Image = u20[v47] and u20[v47].Icon or ""
				v48.LayoutOrder = 10
				v48.Visible = true
				v48.Parent = u35
			end
		else
			local v51 = u36:Clone()
			local v52 = v51.ItemName
			local v53 = v51.ItemValue
			local v54 = v51.ItemImage
			v51.Name = v45
			v53.Visible = true
			if v45 == "Cash" then
				v52.Text = "CASH"
				v53.Text = "$" .. u13:ToString(v46, 2)
				v54.Image = "rbxassetid://70626497369321"
				v54.ImageTransparency = 0.2
				v51.LayoutOrder = 2
			elseif v45 == "Multiplier" then
				v52.Text = "MULTI"
				v53.Text = "x" .. v46
				v54.Image = "rbxassetid://70626497369321"
				v54.ImageTransparency = 0.2
				v51.LayoutOrder = 1
			elseif v45 == "AdditionalLockTime" then
				v52.Text = "LOCK BASE"
				v53.Text = "+10 Sec"
				v54.Image = "rbxassetid://123877736890165"
				v54.Position = UDim2.fromScale(0.5, 0.5)
				v54.ImageTransparency = 0.2
				v51.LayoutOrder = 3
			elseif v45 == "FriendController" then
				v52.Text = "Friend Controller"
				v53.Text = "Unlock"
				v54.Image = "rbxassetid://96730132757867"
				v54.ImageTransparency = 0.2
				v51.LayoutOrder = 4
			elseif v45 == "AnimalSlot" then
				v52.Text = "Slot"
				v53.Text = "+" .. v46
				v54.Image = "rbxassetid://85000857078190"
				v54.ImageTransparency = 0.2
				v51.LayoutOrder = 4
			end
			v51.Visible = true
			v51.Parent = u35
		end
	end
end
local function u66(p56) --[[Anonymous function at line 161]]
    --[[
    Upvalues:
        [1] = u14
        [2] = u33
        [3] = u34
        [4] = u19
        [5] = u18
        [6] = u16
        [7] = u17
    --]]
	local v57 = #u14
	local v58 = p56 + 1
	if #u33:GetChildren() >= 1 then
		for _, v59 in ipairs(u33:GetChildren()) do
			if v59.Name ~= "Template" and v59:IsA("ImageLabel") then
				v59:Destroy()
			end
		end
	end
	if v57 < v58 then
		return 0
	end
	if u14[v58].IsEnabled and (not u14[v58].IsEnabled() and v57 - 1 < v58) then
		return 0
	end
	local v60 = u14[v58].Requirements.RequiredCharacters
	local v61 = 0
	if #v60 >= 1 then
		for v62, v63 in ipairs(v60) do
			local v64 = u34:Clone()
			v64.Name = v63 .. v62
			v64.Visible = true
			local v65 = u19[u18[v63].Rarity].Color
			v64.CharacterName.Text = v63
			v64.UIGradient.Color = u16:HasAnimal(v63) and ColorSequence.new(v65) or ColorSequence.new(Color3.new(0.223529, 0.196078, 0.215686))
			v61 = v61 + (u16:HasAnimal(v63) and 1 or 0)
			v64.CheckImage.Visible = u16:HasAnimal(v63) and true or false
			v64.Parent = u33
			v64.ViewportFrame.ImageColor3 = u16:HasAnimal(v63) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
			u17:AttachOnViewport(v63, v64.ViewportFrame, true)
		end
	end
	return v61
end
local function u72(p67, p68) --[[Anonymous function at line 216]]
    --[[
    Upvalues:
        [1] = u12
        [2] = u23
        [3] = u14
        [4] = u32
        [5] = u37
    --]]
	local v69 = u12:Get(u23):Get("Coins")
	local v70 = #u14
	local v71 = p67 + 1
	if v70 < v71 then
		u32.ImageColor3 = Color3.fromRGB(138, 138, 138)
		return
	elseif u14[v71].IsEnabled and (not u14[v71].IsEnabled() and v70 - 1 < v71) then
		u32.ImageColor3 = Color3.fromRGB(138, 138, 138)
	elseif u14[v71].Requirements.Cash <= v69 and p68 == #u14[v71].Requirements.RequiredCharacters then
		u32.ImageColor3 = Color3.fromRGB(255, 255, 255)
		if v71 == 1 then
			u37.Visible = true
			return
		end
	else
		u32.ImageColor3 = Color3.fromRGB(138, 138, 138)
		if v71 == 1 then
			u37.Visible = false
		end
	end
end
function v39.Start(_) --[[Anonymous function at line 251]]
    --[[
    Upvalues:
        [1] = u38
        [2] = u10
        [3] = u25
        [4] = u26
        [5] = u37
        [6] = u11
        [7] = u32
        [8] = u22
        [9] = u15
        [10] = u12
        [11] = u23
        [12] = u55
        [13] = u66
        [14] = u72
        [15] = u14
        [16] = u30
        [17] = u31
        [18] = u13
        [19] = u21
    --]]
	local u73 = 0
	local u74 = 0
	local u75 = 0
	u38 = u10:Register("Rebirth", u25, "TopQuint")
	u38:AttachCloseButton(u26)
	u38:Close()
	u38.OnOpen:Connect(function() --[[Anonymous function at line 262]]
        --[[
        Upvalues:
            [1] = u37
        --]]
		if u37.Visible then
			u37.Visible = false
		end
	end)
	local v76 = u11.new(u32)
	v76:Animate()
	v76.OnActivated:Connect(function() --[[Anonymous function at line 270]]
        --[[
        Upvalues:
            [1] = u22
            [2] = u15
        --]]
		local v77, v78 = u22:InvokeServer()
		if v77 then
			u15:Success(v78)
		else
			u15:Error(v78)
		end
	end)
	u12:WaitAndCall(u23, function(p79) --[[Anonymous function at line 279]]
        --[[
        Upvalues:
            [1] = u73
            [2] = u55
            [3] = u66
            [4] = u74
            [5] = u72
            [6] = u14
            [7] = u30
            [8] = u31
            [9] = u75
            [10] = u13
            [11] = u21
        --]]
		p79:OnChanged("Rebirth", function(p80, _) --[[Anonymous function at line 281]]
            --[[
            Upvalues:
                [1] = u73
                [2] = u55
                [3] = u66
            --]]
			u73 = p80
			u55(u73)
			u66(u73)
		end, true)
		p79:OnChanged("AnimalAddedOrRemoved", function() --[[Anonymous function at line 287]]
            --[[
            Upvalues:
                [1] = u74
                [2] = u66
                [3] = u73
                [4] = u72
            --]]
			u74 = u66(u73)
			u72(u73, u74)
		end, true)
		local function u94() --[[Anonymous function at line 293]]
            --[[
            Upvalues:
                [1] = u14
                [2] = u73
                [3] = u72
                [4] = u74
                [5] = u30
                [6] = u31
                [7] = u75
                [8] = u13
            --]]
			local v81 = #u14
			local v82 = u73 + 1
			if v82 <= v81 and (u14[v82].IsEnabled and not u14[v82].IsEnabled()) then
				v81 = v81 - 1
			end
			u72(u73, u74)
			if v81 < v82 then
				u30.Size = UDim2.new(1, 0, 1, 0)
				u30.BackgroundColor3 = Color3.new(0.490196, 0.941176, 0.439216)
				u31.Text = "Completed!"
			else
				local v83 = u30
				local v84 = UDim2.new
				local v85 = u75 / u14[v82].Requirements.Cash
				v83.Size = v84(math.clamp(v85, 0, 1), 0, 1, 0)
				local v86 = u75 >= u14[v82].Requirements.Cash
				local v87 = u13:ToString(u14[v82].Requirements.Cash, 2)
				local v88 = u31
				local v89 = "$ "
				local v90
				if v86 then
					v90 = v87
				else
					local v91 = u13
					local v92 = u75
					local v93 = u14[v82].Requirements.Cash
					v90 = v91:ToString((math.clamp(v92, 0, v93)))
				end
				v88.Text = v89 .. v90 .. " / " .. "$ " .. v87
				u30.BackgroundColor3 = v86 and Color3.new(0.490196, 0.941176, 0.439216) or Color3.new(0.941176, 0.729412, 0.482353)
			end
		end
		p79:OnChanged("Coins", function(p95, _) --[[Anonymous function at line 320]]
            --[[
            Upvalues:
                [1] = u75
                [2] = u94
            --]]
			u75 = p95
			u94()
		end, true)
		local function v96() --[[Anonymous function at line 326]]
            --[[
            Upvalues:
                [1] = u55
                [2] = u73
                [3] = u66
                [4] = u94
            --]]
			u55(u73)
			u66(u73)
			u94()
		end
		u21.OnUpdateEnabled:Connect(v96)
		u21.OnUpdateDisabled:Connect(v96)
		task.spawn(v96)
	end)
end
return v39