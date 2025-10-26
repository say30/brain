--[[
  Extracted from: ReplicatedStorage.Classes.PlotClient
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local v1 = game:GetService("ReplicatedStorage")
local u2 = game:GetService("RunService")
local u3 = game:GetService("Players")
local v4 = v1:WaitForChild("Packages")
local u5 = require(v1.Packages.Gradients)
local u6 = require(v4.Synchronizer)
local u7 = require(v4.Trove)
local u8 = require(v4.Timer)
local v9 = require(v4.Net)
v1:WaitForChild("Classes")
local u10 = require(script.AnimalPrompt)
local v11 = v1:WaitForChild("Utils")
local u12 = require(v11.TimeUtils)
local u13 = require(v11.NumberUtils)
local u14 = v1:WaitForChild("Models").Animals
local v15 = v1:WaitForChild("Shared")
local u16 = require(v15.Animals)
local u17 = v1:WaitForChild("Overheads").AnimalOverhead
local u18 = v1:WaitForChild("Animations").Animals
local v19 = v1:WaitForChild("Datas")
require(v19.Game)
local u20 = require(v19.Animals)
local u21 = require(v19.Rarities)
local u22 = require(v19.Mutations)
local u23 = require(v19.Bases)
local u24 = require(v19.UnlockBase)
local u25 = require(v19.Traits)
local u26 = require(v1.Datas.FuseMachineData)
local v27 = v1:WaitForChild("Shared")
local u28 = require(v27.Friends)
local u29 = require(v1.Controllers.AnimationSyncController)
local u30 = require(v1.Controllers.NotificationController)
local u31 = require(v1.Controllers.ConfirmationController)
local u32 = v9:RemoteEvent("ShopService/Purchase")
local u33 = u3.LocalPlayer
local u34 = v9:RemoteEvent("PlotService/Sell")
local u35 = v9:RemoteEvent("StealService/Grab")
local u36 = v9:RemoteEvent("PlotService/Open")
local u37 = v9:RemoteEvent("PlotService/ClaimCoins")
local u38 = v9:RemoteEvent("280b459b-b3c8-424e-9b0b-821d4a4dec11")
local u39 = v9:RemoteEvent("dfdd4236-1fac-4b9a-9f67-fec68d72c151")
local u40 = v9:RemoteEvent("PlotService/ToggleFriends")
local u41 = u40.FireServer
local u42 = {}
u42.__index = u42
function u42.ClearIndex(p43, p44) --[[Anonymous function at line 102]]
	if p43.AnimalsModels[p44] then
		p43.AnimalsModels[p44]:Destroy()
		p43.AnimalsModels[p44] = nil
	end
	if p43.ModelsCollector[p44] then
		p43.ModelsCollector[p44]:Clean()
		p43.ModelsCollector[p44] = nil
	end
end
function u42.UpdateModel(u45, u46) --[[Anonymous function at line 114]]
    --[[
    Upvalues:
        [1] = u7
        [2] = u14
        [3] = u16
        [4] = u18
        [5] = u29
        [6] = u20
        [7] = u21
        [8] = u17
        [9] = u12
        [10] = u13
        [11] = u33
        [12] = u22
        [13] = u5
        [14] = u25
        [15] = u8
    --]]
	local u47 = u45.Channel:Get("AnimalList") or {}
	if u47[u46] and u45.AnimalsIndex[u46] ~= u47[u46].Index then
		u45:ClearIndex(u46)
		u45.AnimalsIndex[u46] = u47[u46].Index
	end
	local v48 = u45.AnimalsModels[u46]
	local v49 = not v48
	if v49 then
		local v50 = u47[u46]
		v49 = type(v50) == "table"
	end
	if not v49 and v48 then
		local v51 = v48:GetAttribute("Mutation") ~= u47[u46].Mutation and true or v49
		local v52 = u47[u46].Traits
		local v53 = type(v52) == "table" and v48:GetAttribute("Traits") ~= table.concat(u47[u46].Traits, ",") and true or v51
		local v54 = u47[u46].Traits
		v49 = type(v54) ~= "table" and v48:GetAttribute("Traits") ~= nil and true or v53
	end
	if v49 then
		u45:ClearIndex(u46)
		u45.AnimalsIndex[u46] = u47[u46].Index
	end
	if v49 then
		local v55 = u45.ModelsCollector[u46]
		if v55 then
			v55:Clean()
		else
			v55 = u7.new()
			u45.ModelsCollector[u46] = v55
		end
		local v56 = u14:FindFirstChild(u47[u46].Index)
		if not v56 then
			return
		end
		local u57 = v56:Clone()
		u45.AnimalsModels[u46] = u57
		for _, v58 in u57:GetDescendants() do
			if v58:IsA("BasePart") then
				v58.CanCollide = false
				v58.CanQuery = false
				v58.CanTouch = false
				v58.Massless = true
			end
		end
		u57.Parent = u45.PlotModel
		u57.PrimaryPart.Anchored = true
		local v59 = u47[u46].Mutation
		if v59 then
			u16:ApplyMutation(u57, u47[u46].Index, v59)
			u57:SetAttribute("Mutation", v59)
		end
		local v60 = u57:GetExtentsSize()
		local v61 = u47[u46].Traits
		if v61 then
			v55:Add(u16:ApplyTraits(u57, u47[u46].Index, v61))
			u57:SetAttribute("Traits", table.concat(v61, ","))
		end
		u57:PivotTo(u45.PlotModel.AnimalPodiums:FindFirstChild(u46).Base.Spawn:GetPivot())
		local v62 = u57:FindFirstChildOfClass("AnimationController") or Instance.new("AnimationController", u57)
		local v63 = v62:FindFirstChildOfClass("Animator") or Instance.new("Animator", v62)
		local v64 = u18:FindFirstChild(u47[u46].Index)
		if v64 then
			v64 = v64:FindFirstChild("Idle")
		end
		if v64 and v63 then
			local u65 = v63:LoadAnimation(v64)
			u65.Looped = true
			u65:Play()
			local u66 = u29:Add(u65)
			v55:Add(function() --[[Anonymous function at line 200]]
                --[[
                Upvalues:
                    [1] = u66
                    [2] = u65
                --]]
				u66()
				u65:Stop(0)
				u65:Destroy()
			end)
		end
		local v67 = u20[u47[u46].Index]
		local v68 = u57:FindFirstChild("OVERHEAD_ATTACHMENT", true)
		if not v68 then
			v68 = v55:Add(Instance.new("Attachment"))
			v68.CFrame = CFrame.new(0, v60.Y * 0.75 * (v67 and (v67.OverheadYOffsetModifier or 1) or 1), 0)
			v68.Parent = u45.PlotModel.AnimalPodiums:FindFirstChild(u46).Base.Spawn
		end
		local v69 = u21[v67.Rarity]
		local u70 = v55:Clone(u17)
		local u71 = u70.Generation
		local function u73() --[[Anonymous function at line 224]]
            --[[
            Upvalues:
                [1] = u45
                [2] = u46
                [3] = u71
                [4] = u12
                [5] = u13
                [6] = u16
                [7] = u47
            --]]
			local v72 = u45.Channel:Get((("AnimalList.%*"):format(u46)))
			if v72 and v72.Timer ~= nil then
				u71.Text = v72.Timer <= 0 and "READY!" or u12:E(v72.Timer)
				return
			elseif v72 and (v72.Steal == "FuseMachineActive" and v72.FuseFinishTime ~= nil) then
				u71.Text = v72.FuseFinishTime - workspace:GetServerTimeNow() <= 0 and "READY!" or u12:E(v72.FuseFinishTime - workspace:GetServerTimeNow())
			else
				u71.Text = ("$%*/s"):format((u13:ToString(u16:GetGeneration(u47[u46].Index, u47[u46].Mutation, u47[u46].Traits, nil))))
			end
		end
		u70.DisplayName.Text = v67.DisplayName
		u70.Price.Text = ("$%*"):format((u13:ToString(u16:GetPrice(u47[u46].Index, u33))))
		u70.Rarity.Text = v67.Rarity
		u70.Rarity.TextColor3 = u21[v67.Rarity].Color
		if v59 then
			local v74 = u22[v59]
			u70.Mutation.Text = v74.DisplayText
			if v74.GradientPreset then
				v55:Add(u5.apply(u70.Mutation, v74.GradientPreset))
			else
				u70.Mutation.TextColor3 = v74.MainColor
			end
		end
		if v61 then
			local v75 = u70.Traits.Template
			for _, v76 in v61 do
				local v77 = u25[v76]
				if v77 then
					local v78 = v75:Clone()
					v78.Parent = v75.Parent
					v78.Image = v77.Icon
					v78.Visible = true
				end
			end
			u70.Traits.Visible = true
		end
		task.spawn(u73)
		v55:Add(u45.Channel:OnChanged("AnimalList", u73))
		v55:Add(u8.Simple(1, u73))
		u70.Mutation.Visible = v59 ~= nil
		if u21[v67.Rarity].StrokeColor then
			u70.Rarity.UIStroke.Color = u21[v67.Rarity].StrokeColor
		end
		u70.Parent = v68
		if v69.GradientPreset then
			v55:Add(u5.apply(u70.Rarity, v69.GradientPreset))
		end
		local function u84(p79) --[[Anonymous function at line 278]]
            --[[
            Upvalues:
                [1] = u73
                [2] = u45
                [3] = u57
                [4] = u70
            --]]
			task.spawn(u73)
			local v80 = u45:GetOwner()
			if v80 then
				v80 = p79 == v80.UserId
			end
			for _, v81 in u57:GetDescendants() do
				if v81:IsA("BasePart") then
					local v82 = v81:GetAttribute("DefaultTransparency")
					if v82 == nil then
						v82 = v81.Transparency
						v81:SetAttribute("DefaultTransparency", v82)
					end
					if p79 and v81.Transparency < 1 then
						v81.Transparency = 0.5
					else
						v81.Transparency = v82
					end
				end
			end
			for _, v83 in u70:GetChildren() do
				if v83:IsA("TextLabel") then
					if not v83:GetAttribute("DefaultState") then
						v83:SetAttribute("DefaultState", v83.Visible)
					end
					if v83.Name == "Stolen" then
						if p79 == "FuseMachine" then
							v83.Text = "IN MACHINE"
							v83.TextColor3 = Color3.fromRGB(0, 140, 255)
						elseif p79 == "FuseMachineActive" then
							v83.Text = "FUSING"
							v83.TextColor3 = Color3.fromRGB(0, 140, 255)
						else
							v83.Text = "STOLEN"
							v83.TextColor3 = Color3.fromRGB(255, 0, 4)
						end
					end
					if p79 then
						if v83.Name == "Stolen" then
							v83.Visible = not v80
						elseif v83.Name == "Generation" then
							v83.Visible = p79 == "FuseMachineActive"
						else
							v83.Visible = false
						end
					elseif v83.Name == "Stolen" then
						v83.Visible = false
					else
						v83.Visible = v83:GetAttribute("DefaultState")
					end
				end
			end
		end
		v55:Add(u45.Channel:OnChanged(("AnimalList.%*.Steal"):format(u46), u84, true))
		v55:Add(u45.Channel:OnChanged("AnimalList", function(p85) --[[Anonymous function at line 341]]
            --[[
            Upvalues:
                [1] = u46
                [2] = u84
            --]]
			local v86
			if typeof(p85) == "table" then
				v86 = p85[u46]
			else
				v86 = nil
			end
			if type(v86) == "table" then
				u84(v86.Steal)
			end
		end))
	end
end
function u42.HideClaim(p87, p88) --[[Anonymous function at line 350]]
	local v89 = p87.PlotModel.AnimalPodiums:FindFirstChild(p88)
	if v89 then
		v89.Claim.Main.Collect.Enabled = false
	end
end
function u42.UpdateClaim(p90, p91) --[[Anonymous function at line 357]]
    --[[
    Upvalues:
        [1] = u20
        [2] = u16
        [3] = u33
        [4] = u13
    --]]
	local v92 = (p90.Channel:Get("AnimalList") or {})[p91]
	local v93 = u20[v92.Index]
	local v94 = workspace:GetServerTimeNow() - v92.LastCollect
	local v95 = math.floor(v94) * u16:GetGeneration(v92.Index, v92.Mutation, v92.Traits, u33)
	local v96 = p90.PlotModel.AnimalPodiums:FindFirstChild(p91).Claim.Main.Collect
	if v93 and v93.LuckyBlock then
		v96.Enabled = false
		return
	elseif v92.Steal == "FuseMachine" or v92.Steal == "FuseMachineActive" then
		v96.Enabled = false
	else
		v96.Collect.Text = ("Collect <br/><font color=\"#73ff00\">$%*</font>"):format((u13:ToString(v95)))
		if v92.OfflineGain then
			v96.Offline.Text = ("(Offline Cash: <font color=\"#73ff00\">$%*</font>)"):format((u13:ToString(v92.OfflineGain * u16:GetGeneration(v92.Index, v92.Mutation, v92.Traits, u33))))
		end
		v96.Offline.Visible = v92.OfflineGain ~= nil
		v96.Enabled = true
	end
end
function u42.UpdatePrompt(u97, u98) --[[Anonymous function at line 379]]
    --[[
    Upvalues:
        [1] = u10
        [2] = u33
        [3] = u35
        [4] = u26
        [5] = u30
        [6] = u36
        [7] = u20
        [8] = u31
        [9] = u34
        [10] = u41
        [11] = u38
    --]]
	local u99 = u97.PlotModel.AnimalPodiums:FindFirstChild(u98)
	local v100 = u97.Channel:Get("AnimalList") or {}
	local u101 = v100[u98]
	if u99:GetAttribute("DeferDisplay") then
		u101 = nil
	elseif u101 == "Empty" then
		u101 = nil
	end
	local v102
	if u101 then
		v102 = u101.Index
	else
		v102 = ("None_%*"):format((tostring(u98)))
	end
	local v103 = u99.Base.Spawn
	local u104 = u97.AnimalsPrompts[u98]
	if u104 and u104.AnimalIndex ~= v102 then
		for _, v105 in u104.Prompts do
			v105:Destroy()
		end
		u104 = nil
	end
	if not u104 then
		u104 = {
			["AnimalIndex"] = v102,
			["Prompts"] = { u10.new(u98, v102, v103.PromptAttachment), u10.new(u98, v102, v103.PromptAttachment, {
				["KeyboardKeyCode"] = Enum.KeyCode.F,
				["GamepadKeyCode"] = Enum.KeyCode.ButtonY,
				["UIOffset"] = Vector2.new(0, -72)
			}) }
		}
		local u106 = {}
		for _, u107 in pairs(u104.Prompts) do
			u107.Collector:Add(u107.ProximityPrompt.PromptShown:Connect(function() --[[Anonymous function at line 433]]
                --[[
                Upvalues:
                    [1] = u106
                    [2] = u107
                    [3] = u99
                --]]
				u106[u107.ProximityPrompt] = true
				local v108 = u99:FindFirstChild("AnimalOverhead", true)
				if v108 and v108:IsA("BillboardGui") then
					v108.AlwaysOnTop = next(u106) ~= nil
				end
			end))
			u107.Collector:Add(u107.ProximityPrompt.PromptHidden:Connect(function() --[[Anonymous function at line 438]]
                --[[
                Upvalues:
                    [1] = u106
                    [2] = u107
                    [3] = u99
                --]]
				u106[u107.ProximityPrompt] = nil
				local v109 = u99:FindFirstChild("AnimalOverhead", true)
				if v109 and v109:IsA("BillboardGui") then
					v109.AlwaysOnTop = next(u106) ~= nil
				end
			end))
			u107.Collector:Add(function() --[[Anonymous function at line 443]]
                --[[
                Upvalues:
                    [1] = u106
                    [2] = u107
                    [3] = u99
                --]]
				u106[u107.ProximityPrompt] = nil
				local v110 = u99:FindFirstChild("AnimalOverhead", true)
				if v110 and v110:IsA("BillboardGui") then
					v110.AlwaysOnTop = next(u106) ~= nil
				end
			end)
			u107.Collector:Add(u107.ProximityPrompt.PromptButtonHoldBegan:Connect(function() --[[Anonymous function at line 448]]
                --[[
                Upvalues:
                    [1] = u104
                    [2] = u107
                --]]
				for _, v111 in u104.Prompts do
					if v111 ~= u107 then
						v111.ProximityPrompt.Enabled = false
					end
				end
			end))
			u107.Collector:Add(u107.ProximityPrompt.PromptButtonHoldEnded:Connect(function() --[[Anonymous function at line 458]]
                --[[
                Upvalues:
                    [1] = u104
                    [2] = u107
                --]]
				for _, v112 in u104.Prompts do
					if v112 ~= u107 then
						v112.ProximityPrompt.Enabled = true
						v112:SetState(v112.State)
					end
				end
			end))
		end
		u97.AnimalsPrompts[u98] = u104
	end
	assert(u104)
	local v113 = u104.Prompts[1]
	local v114 = u104.Prompts[2]
	if u97:GetOwner() == u33 then
		local v115 = false
		if u33:GetAttribute("Stealing") then
			for _, v116 in v100 do
				if v116.Steal == u33.UserId then
					v115 = true
					break
				end
			end
		end
		if not (u101 or v115) or u101 and u101.Steal == "FuseMachineActive" then
			if v113.State ~= "None" then
				v113:SetState("None")
			end
			if v114.State ~= "None" then
				v114:SetState("None")
			end
			return
		end
		if v115 then
			if v113.State ~= "Place" then
				v113:SetState("Place", function() --[[Anonymous function at line 502]]
                    --[[
                    Upvalues:
                        [1] = u35
                        [2] = u98
                    --]]
					u35:FireServer("Place", u97.PlotModel.Name, u98);
				end)
			end
			if v114.State ~= "None" then
				v114:SetState("None")
			end
			return
		end
		if u101 and u101.Steal == "FuseMachine" then
			if v113.State ~= "FuseMachineReturn" then
				v113:SetState("FuseMachineReturn", function() --[[Anonymous function at line 516]]
                    --[[
                    Upvalues:
                        [1] = u101
                        [2] = u26
                        [3] = u30
                    --]]
					if u101.FuseSlot then
						local v117, v118, _ = u26.Remotes.RemoveBrainrot:InvokeServer(u101.FuseSlot, u101.FusePlot)
						if not v117 then
							u30:Error(v118 or "Something went wrong!")
						end
					else
						return
					end
				end)
			end
			if v114.State ~= "None" then
				v114:SetState("None")
			end
			return
		end
		local v119 = u101.Timer or 1
		if v113.State == "Grab" or v119 <= 0 then
			if v113.State ~= "Open" and v119 <= 0 then
				v113:SetState("Open", function() --[[Anonymous function at line 542]]
                    --[[
                    Upvalues:
                        [1] = u36
                        [2] = u98
                    --]]
					u36:FireServer(u98)
				end)
			end
		else
			v113:SetState("Grab", function() --[[Anonymous function at line 538]]
                --[[
                Upvalues:
                    [1] = u35
                    [2] = u98
                --]]
				u35:FireServer("Grab", u97.PlotModel.Name, u98);
			end)
		end
		if v114.State ~= "Sell" then
			v114:SetState("Sell", function() --[[Anonymous function at line 548]]
                --[[
                Upvalues:
                    [1] = u97
                    [2] = u98
                    [3] = u20
                    [4] = u31
                    [5] = u34
                --]]
				local v120 = u97.AnimalsPrompts[u98].AnimalIndex
				local v121 = u20[v120].Rarity
				if (v121 == "Admin" or v121 == "Secret") and true or v121 == "Brainrot God" then
					local v122 = ("Do you want to sell %*?"):format(v120)
					if u31:IsInPrompt() or not u31:Show(v122) then
						return
					end
				end
				u34:FireServer(u98)
			end)
		end
	elseif u101 and (u101.Steal and u101.Steal ~= "FuseMachine") then
		if v113.State ~= "None" then
			v113:SetState("None")
		end
		if v114.State ~= "None" then
			v114:SetState("None")
		end
	elseif u101 then
		if v113.State ~= "Steal" then
			v113:SetState("Steal", function() --[[Anonymous function at line 573]]
                --[[
                Upvalues:
                    [1] = u41
                    [2] = u38
                    [3] = u97
                    [4] = u98
                --]]
				u41(u38, workspace:GetServerTimeNow() + 46, "bf07cde8-2ec7-49bb-bac9-8e1df389d130", u97.PlotModel.Name, u98)
				u38:FireServer(workspace:GetServerTimeNow() + 46, "68469aac-3674-4bd1-a45a-ffd857def0cb", u97.PlotModel.Name, u98)
			end)
		end
		if v114.State ~= "None" then
			v114:SetState("None")
		end
	else
		if v113.State ~= "None" then
			v113:SetState("None")
		end
		if v114.State ~= "None" then
			v114:SetState("None")
		end
	end
end
function u42.UpdateAnimalPodiums(p123) --[[Anonymous function at line 614]]
    --[[
    Upvalues:
        [1] = u23
    --]]
	local v124 = p123.Channel:Get("AnimalList") or {}
	for v125 = 1, u23[p123.PlotModel:GetAttribute("Tier")].MaxAnimals do
		local v126 = p123.PlotModel.AnimalPodiums:FindFirstChild(v125)
		local v127 = v124[v125]
		if type(v127) == "table" and (v126 and not v126:GetAttribute("DeferDisplay")) then
			p123:UpdateModel(v125)
			p123:UpdateClaim(v125)
		else
			p123:ClearIndex(v125)
			p123:HideClaim(v125)
		end
		p123:UpdatePrompt(v125)
	end
end
local function u136(p128) --[[Anonymous function at line 633]]
    --[[
    Upvalues:
        [1] = u12
    --]]
	local v129 = false
	p128:GetOwner()
	local v130 = p128.PlotModel:WaitForChild("Purchases", 5)
	if v130 then
		if p128.Channel:Get("BlockEndTime") ~= nil then
			local v131 = p128.Channel:Get("BlockEndTime") - workspace:GetServerTimeNow()
			local v132 = math.round(v131)
			local v133 = math.clamp(v132, 0, (1 / 0))
			for _, v134 in v130:GetChildren() do
				v134.Main.BillboardGui.RemainingTime.Text = u12:C(v133)
			end
			v129 = true
		end
		for _, v135 in v130:GetChildren() do
			v135.Main.BillboardGui.LockStudio.Visible = not v129
			v135.Main.BillboardGui.RemainingTime.Visible = v129
			v135.Main.BillboardGui.Locked.Visible = v129
		end
	end
end
local function u145(p137) --[[Anonymous function at line 662]]
    --[[
    Upvalues:
        [1] = u12
    --]]
	if p137.Channel:Get("BlockEndTime") == nil then
		local v138 = false
		p137:GetOwner()
		local v139 = p137.PlotModel:WaitForChild("Purchases", 5)
		if not v139 then
			return
		end
		if p137.Channel:Get("BlockedDelayTime") ~= nil then
			local v140 = p137.Channel:Get("BlockedDelayTime") - workspace:GetServerTimeNow()
			local v141 = math.round(v140)
			local v142 = math.clamp(v141, 0, (1 / 0))
			for _, v143 in v139:GetChildren() do
				v143.Main.BillboardGui.RemainingTime.Text = u12:C(v142)
			end
			v138 = true
		end
		for _, v144 in v139:GetChildren() do
			v144.Main.BillboardGui.LockStudio.Visible = not v138
			v144.Main.BillboardGui.RemainingTime.Visible = v138
			v144.Main.BillboardGui.Delay.Visible = v138
		end
	end
end
local function u151(p146) --[[Anonymous function at line 691]]
    --[[
    Upvalues:
        [1] = u33
    --]]
	if p146:GetOwner() ~= u33 then
		for _, v147 in p146.PlotModel.Unlock:GetChildren() do
			local v148 = v147.UnlockBase:GetAttribute("Floor")
			if v148 then
				local v149 = v148 == 2 and "BlockEndTimeSecondFloor" or (v148 == 3 and "BlockEndTimeThirdFloor" or "BlockEndTimeFirstFloor")
				local v150 = p146.Channel:Get(v149) ~= nil
				v147.UnlockBase.Enabled = v150
			end
		end
	end
end
local function u162(p152) --[[Anonymous function at line 711]]
    --[[
    Upvalues:
        [1] = u33
        [2] = u28
    --]]
	if p152.Channel and p152.Channel.Get then
		local v153 = p152:GetOwner() == u33
		local v154 = p152:GetOwner()
		local v155 = u28:GetInGameFriends(u33)
		local v156 = p152.Channel:Get("FriendsAllowed") == true
		local v157 = p152.PlotModel:WaitForChild("LaserHitbox", 5)
		if v157 then
			for _, v158 in v157:GetChildren() do
				local v159 = v158:GetAttribute("Floor")
				if v159 then
					local v160 = v159 == 2 and "BlockEndTimeSecondFloor" or (v159 == 3 and "BlockEndTimeThirdFloor" or "BlockEndTimeFirstFloor")
					local v161
					if v153 or p152.Channel:Get(v160) == nil then
						v161 = false
					else
						v161 = not (table.find(v155, v154) and v156)
					end
					v158.CanCollide = v161
				end
			end
		end
	else
		return
	end
end
function u42.GetOwner(p163) --[[Anonymous function at line 761]]
	return p163.Channel:Get("Owner")
end
function u42.GetSpawn(p164) --[[Anonymous function at line 765]]
	return p164.PlotModel.Spawn
end
function u42.GetUID(p165) --[[Anonymous function at line 769]]
	return p165.UID
end
function u42.new(u166) --[[Anonymous function at line 773]]
    --[[
    Upvalues:
        [1] = u42
        [2] = u7
        [3] = u6
        [4] = u23
        [5] = u33
        [6] = u2
        [7] = u41
        [8] = u39
        [9] = u3
        [10] = u37
        [11] = u8
        [12] = u136
        [13] = u151
        [14] = u145
        [15] = u162
        [16] = u24
        [17] = u32
        [18] = u28
        [19] = u40
    --]]
	local v167 = u42
	local u168 = setmetatable({}, v167)
	u168.UID = u166.Name
	u168.PlotModel = u166
	u168.Collector = u7.new()
	u168.OwnerCollector = u7.new()
	u168.Collector:Add(u168.OwnerCollector, "Destroy")
	u168.AnimalsModels = {}
	u168.AnimalsIndex = {}
	u168.AnimalsPrompts = {}
	u168.ModelsCollector = {}
	u168.Channel = u6:Wait(u168.UID)
	local function u174() --[[Anonymous function at line 788]]
        --[[
        Upvalues:
            [1] = u168
        --]]
		for v169, v170 in u168.AnimalsPrompts do
			for _, v171 in v170.Prompts do
				v171:Destroy()
			end
			u168.AnimalsPrompts[v169] = nil
		end
		for v172, v173 in u168.AnimalsModels do
			v173:Destroy()
			u168.AnimalsModels[v172] = nil
		end
	end
	local function v198() --[[Anonymous function at line 802]]
        --[[
        Upvalues:
            [1] = u168
            [2] = u174
            [3] = u23
            [4] = u166
            [5] = u33
            [6] = u2
            [7] = u41
            [8] = u39
            [9] = u3
            [10] = u37
            [11] = u8
            [12] = u136
            [13] = u151
            [14] = u145
            [15] = u162
            [16] = u24
            [17] = u32
            [18] = u28
            [19] = u40
        --]]
		u168.OwnerCollector:Clean()
		u174()
		for u175 = 1, u23[u166:GetAttribute("Tier")].MaxAnimals do
			if u168:GetOwner() == u33 then
				local v176 = {}
				for _, v177 in u168.PlotModel:GetChildren() do
					if v177.Name == "DeliveryHitbox" then
						table.insert(v176, v177)
					end
				end
				local u178 = OverlapParams.new()
				u178.FilterDescendantsInstances = v176
				u178.FilterType = Enum.RaycastFilterType.Include
				u178.MaxParts = 1
				local u179 = 0
				u168.OwnerCollector:Add(u2.PostSimulation:Connect(function(p180) --[[Anonymous function at line 823]]
                    --[[
                    Upvalues:
                        [1] = u179
                        [2] = u33
                        [3] = u168
                        [4] = u178
                        [5] = u41
                        [6] = u39
                    --]]
					u179 = u179 + p180
					if u179 < 0.05 then
						return
					else
						u179 = 0
						if u33:GetAttribute("Stealing") then
							for _, v181 in u168.Channel:Get("AnimalList") or {} do
								if v181.Steal == u33.UserId then
									return
								end
							end
							local v182 = u33.Character
							if v182 then
								local v183 = v182:GetPivot().Position
								if #workspace:GetPartBoundsInBox(CFrame.new(v183), Vector3.new(4, 4, 2), u178) > 0 then
									u41(u39, "d8766412-71ac-42fc-9bb2-00d0b4a9b85e")
									u39:FireServer("d8766412-71ac-42fc-9bb2-00d0b4a9b85e")
								end
							else
								return
							end
						else
							return
						end
					end
				end))
				local v184 = u168.PlotModel.AnimalPodiums:FindFirstChild(u175)
				if v184 then
					v184 = v184.Claim.Hitbox
				end
				u168.OwnerCollector:Add(v184.Touched:Connect(function(p185) --[[Anonymous function at line 876]]
                    --[[
                    Upvalues:
                        [1] = u3
                        [2] = u168
                        [3] = u37
                        [4] = u175
                    --]]
					if p185.Name == "HumanoidRootPart" then
						local v186 = u3:GetPlayerFromCharacter(p185.Parent)
						if v186 and v186 == u168:GetOwner() then
							u37:FireServer(u175)
						end
					else
						return
					end
				end))
			end
		end
		u168.OneSecondTimer = u8.new(1)
		u168.OwnerCollector:Add(u168.OneSecondTimer, "Destroy")
		u168.OwnerCollector:Add(u168.OneSecondTimer.Tick:Connect(function() --[[Anonymous function at line 893]]
            --[[
            Upvalues:
                [1] = u136
                [2] = u168
                [3] = u151
                [4] = u145
            --]]
			u136(u168)
			u151(u168)
			u168:UpdateAnimalPodiums()
			u145(u168)
		end))
		u168.OneSecondTimer:StartNow()
		u168.OwnerCollector:Add(u168.Channel:OnChanged("BlockEndTime", function() --[[Anonymous function at line 901]]
            --[[
            Upvalues:
                [1] = u136
                [2] = u168
                [3] = u151
                [4] = u145
                [5] = u162
            --]]
			u136(u168)
			u151(u168)
			u145(u168)
			u162(u168)
		end, true))
		u168.OwnerCollector:Add(u168.Channel:OnChanged("BlockEndTimeFirstFloor", function() --[[Anonymous function at line 908]]
            --[[
            Upvalues:
                [1] = u136
                [2] = u168
                [3] = u151
                [4] = u145
                [5] = u162
            --]]
			u136(u168)
			u151(u168)
			u145(u168)
			u162(u168)
		end, true))
		u168.OwnerCollector:Add(u168.Channel:OnChanged("BlockEndTimeSecondFloor", function() --[[Anonymous function at line 915]]
            --[[
            Upvalues:
                [1] = u136
                [2] = u168
                [3] = u151
                [4] = u145
                [5] = u162
            --]]
			u136(u168)
			u151(u168)
			u145(u168)
			u162(u168)
		end, true))
		u168.OwnerCollector:Add(u168.Channel:OnChanged("BlockEndTimeThirdFloor", function() --[[Anonymous function at line 922]]
            --[[
            Upvalues:
                [1] = u136
                [2] = u168
                [3] = u151
                [4] = u145
                [5] = u162
            --]]
			u136(u168)
			u151(u168)
			u145(u168)
			u162(u168)
		end, true))
		u168.OwnerCollector:Add(u168.Channel:OnChanged("BlockedDelayTime", function() --[[Anonymous function at line 929]]
            --[[
            Upvalues:
                [1] = u136
                [2] = u168
                [3] = u151
                [4] = u145
                [5] = u162
            --]]
			u136(u168)
			u151(u168)
			u145(u168)
			u162(u168)
		end, true))
		u168.OwnerCollector:Add(u168.Channel:OnChanged("AnimalList", function(_) --[[Anonymous function at line 936]]
            --[[
            Upvalues:
                [1] = u168
            --]]
			u168:UpdateAnimalPodiums()
		end, true))
		local v187 = u168:GetOwner()
		if v187 then
			u168.OwnerCollector:Add(v187:GetAttributeChangedSignal("Stealing"):Connect(function(_) --[[Anonymous function at line 942]]
                --[[
                Upvalues:
                    [1] = u168
                --]]
				u168:UpdateAnimalPodiums()
			end))
		end
		for _, u188 in u168.PlotModel.Unlock:GetChildren() do
			u168.OwnerCollector:Add(u188.UnlockBase.Triggered:Connect(function(p189) --[[Anonymous function at line 949]]
                --[[
                Upvalues:
                    [1] = u168
                    [2] = u188
                    [3] = u24
                    [4] = u32
                --]]
				if p189 and p189:IsA("Player") then
					if u168:GetOwner() == p189 then
						return
					end
					local v190 = u24[u188.UnlockBase:GetAttribute("Floor")].ProductId
					local v191 = u168:GetOwner().UserId
					if u168.Channel:Get("BlockEndTimeFirstFloor") ~= nil or (u168.Channel:Get("BlockEndTimeSecondFloor") ~= nil or u168.Channel:Get("BlockEndTimeThirdFloor") ~= nil) then
						u32:FireServer(v190, v191)
					end
				end
			end))
			u168.OwnerCollector:Add(u168.PlotModel.Unlock.ChildAdded:Connect(function(u192) --[[Anonymous function at line 963]]
                --[[
                Upvalues:
                    [1] = u168
                    [2] = u24
                    [3] = u32
                    [4] = u162
                --]]
				u168.OwnerCollector:Add(u192.UnlockBase.Triggered:Connect(function(p193) --[[Anonymous function at line 964]]
                    --[[
                    Upvalues:
                        [1] = u168
                        [2] = u192
                        [3] = u24
                        [4] = u32
                    --]]
					if p193 and p193:IsA("Player") then
						if u168:GetOwner() == p193 then
							return
						end
						local v194 = u24[u192.UnlockBase:GetAttribute("Floor")].ProductId
						local v195 = u168:GetOwner().UserId
						if u168.Channel:Get("BlockEndTimeFirstFloor") ~= nil or (u168.Channel:Get("BlockEndTimeSecondFloor") ~= nil or u168.Channel:Get("BlockEndTimeThirdFloor") ~= nil) then
							u32:FireServer(v194, v195)
						end
					end
				end))
				u162(u168)
			end))
		end
		if u168.PlotModel:GetAttribute("Tier") == 0 and u168:GetOwner() then
			u168.PlotModel.FriendPanel:PivotTo(CFrame.new(Vector3.new(0, 1000000000, 0)))
		end
		local u196 = u168.PlotModel.FriendPanel.Main.ProximityPrompt
		u168.OwnerCollector:Add(u168.Channel:OnChanged("FriendsAllowed", function(p197) --[[Anonymous function at line 986]]
            --[[
            Upvalues:
                [1] = u196
                [2] = u168
                [3] = u162
            --]]
			u196.ObjectText = p197 == true and "Disallow Friends" or "Allow Friends"
			u168.PlotModel.FriendPanel.Main.SurfaceGui.ImageLabel.Image = p197 == true and "rbxassetid://110507824065923" or "rbxassetid://110783679426495"
			u162(u168)
		end, true))
		u168.OwnerCollector:Add(u28.OnFriendsUpdate:Connect(function() --[[Anonymous function at line 992]]
            --[[
            Upvalues:
                [1] = u162
                [2] = u168
            --]]
			u162(u168)
		end))
		u168.OwnerCollector:Add(u196.Triggered:Connect(function() --[[Anonymous function at line 996]]
            --[[
            Upvalues:
                [1] = u168
                [2] = u33
                [3] = u40
            --]]
			if u168:GetOwner() == u33 then
				u40:FireServer()
			end
		end))
		u168.PlotModel.PlotSign.YourBase.Enabled = u168:GetOwner() == u33
	end
	u168.Collector:Add(u168.Channel:OnChanged("Owner", v198, true))
	u168.Collector:Add(u168.PlotModel:GetAttributeChangedSignal("Tier"):Connect(v198))
	return u168
end
function u42.Destroy(p199) --[[Anonymous function at line 1014]]
	for v200, v201 in p199.AnimalsPrompts do
		for _, v202 in v201.Prompts do
			v202:Destroy()
		end
		p199.AnimalsPrompts[v200] = nil
	end
	for v203, v204 in p199.AnimalsModels do
		v204:Destroy()
		p199.AnimalsModels[v203] = nil
	end
	p199.Collector:Destroy()
end
return u42

-- there aint no backdoor bro why are u searching