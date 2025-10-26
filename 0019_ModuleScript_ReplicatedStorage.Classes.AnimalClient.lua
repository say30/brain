--[[
  Extracted from: ReplicatedStorage.Classes.AnimalClient
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("RunService")
game:GetService("TweenService")
local v_u_3 = game:GetService("HttpService")
local v4 = v1:WaitForChild("Packages")
local v_u_5 = require(v4.Trove)
local v_u_6 = require(v1.Packages.Gradients)
local v7 = v1:WaitForChild("Datas")
local v_u_8 = require(v7.Animals)
require(v7.Game)
local v_u_9 = require(v7.Rarities)
local v_u_10 = require(v7.Mutations)
local v_u_11 = require(v7.Traits)
local _ = v1:WaitForChild("Others").AnimalTemplate
local v12 = v1:WaitForChild("Shared")
local v_u_13 = require(v12.Animals)
local v_u_14 = v1:WaitForChild("Overheads").AnimalOverhead
local v_u_15 = v1:WaitForChild("Models").Animals
local v16 = v1:WaitForChild("Utils")
local v_u_17 = require(v16.NumberUtils)
local v_u_18 = require(v16.TimeUtils)
local v_u_19 = v1:WaitForChild("Animations").Animals
local v_u_20 = workspace:WaitForChild("RenderedMovingAnimals")
local v_u_21 = {}
v_u_21.__index = v_u_21
function v_u_21.GetUID(p22)
	return p22.UID
end
function v_u_21.new(p23)
	local v24 = v_u_21
	local v_u_25 = setmetatable({}, v24)
	v_u_25.UID = p23.Name
	v_u_25.Collector = v_u_5.new()
	v_u_25.Instance = p23
	v_u_25.Index = v_u_25.Instance:GetAttribute("Index")
	v_u_25.Mutation = v_u_25.Instance:GetAttribute("Mutation")
	local v_u_26 = v_u_8[v_u_25.Index]
	if not v_u_26 then
		warn("Failed to find animal data: " .. v_u_25.Index)
	end
	local v27 = v_u_9[v_u_26.Rarity]
	v_u_25.AnimalModel = v_u_15:FindFirstChild(v_u_25.Index):Clone()
	local v28 = v_u_25.AnimalModel:GetExtentsSize()
	for _, v29 in v_u_25.AnimalModel:GetDescendants() do
		if v29:IsA("BasePart") then
			v29.CanCollide = false
			v29.CanQuery = false
			v29.CanTouch = false
			v29.Massless = true
			v29.Anchored = false
		end
	end
	v_u_25.Collector:Add(v_u_25.AnimalModel)
	if v_u_25.AnimalModel.PrimaryPart then
		v_u_25.AnimalModel.PrimaryPart.Anchored = true
	end
	v_u_25.AnimalModel.Parent = v_u_20
	if v_u_25.Mutation then
		v_u_25.Collector:Add(v_u_13:ApplyMutation(v_u_25.AnimalModel, v_u_25.Index, v_u_25.Mutation))
	end
	local function v_u_31()
		local v30
		if v_u_26.LuckyBlock then
			v30 = v_u_26.LuckyBlock.Timer <= 0 and "READY!" or v_u_18:E(v_u_26.LuckyBlock.Timer)
		else
			v30 = ("$%*/s"):format((v_u_17:ToString(v_u_13:GetGeneration(v_u_25.Index, v_u_25.Mutation, v_u_25.Traits))))
		end
		v_u_25.Overhead.Generation.Text = v30
	end
	local v_u_32 = v_u_25.Collector:Extend()
	local function v40()
		v_u_32:Clean()
		local v33 = v_u_25.Instance:GetAttribute("Traits")
		local v34 = v_u_25
		local v35
		if v33 then
			v35 = v_u_3:JSONDecode(v33)
		else
			v35 = nil
		end
		v34.Traits = v35
		if v_u_25.Traits then
			local v36 = v_u_13:ApplyTraits(v_u_25.AnimalModel, v_u_25.Index, v_u_25.Traits)
			if v36 then
				v_u_32:Add(v36)
			end
			for _, v37 in v_u_25.Traits do
				local v38 = v_u_11[v37]
				if v38 then
					local v39 = v_u_32:Clone(v_u_25.Overhead.Traits.Template)
					v39.Image = v38.Icon
					v39.Visible = true
					v39.Parent = v_u_25.Overhead.Traits
				end
			end
			v_u_25.Overhead.Traits.Visible = true
		else
			v_u_25.Overhead.Traits.Visible = false
		end
		v_u_31()
	end
	local v41 = v_u_25.AnimalModel.AnimationController or Instance.new("AnimationController", v_u_25.AnimalModel)
	local v42 = v41.Animator or Instance.new("Animator", v41)
	local v43 = v_u_19:FindFirstChild(v_u_25.Index)
	local v44
	if v43 then
		v44 = v43:FindFirstChild("Walk")
	else
		v44 = v43
	end
	if v44 then
		v_u_25.WalkTrack = v42:LoadAnimation(v44)
		v_u_25.WalkTrack.Looped = true
		v_u_25.WalkTrack:Play()
		v_u_25.WalkTrack:AdjustSpeed(v44:GetAttribute("Speed") or 1)
	end
	if v43 then
		v43 = v43:FindFirstChild("Idle")
	end
	if v43 then
		v_u_25.IdleTrack = v42:LoadAnimation(v43)
		v_u_25.IdleTrack.Looped = true
		v_u_25.IdleTrack:AdjustSpeed(v43:GetAttribute("Speed") or 1)
	end
	local function v45()
		if v_u_25.Instance:GetAttribute("ForceIdle") then
			v_u_25.WalkTrack:Stop()
			v_u_25.IdleTrack:Play()
		else
			v_u_25.WalkTrack:Play()
			v_u_25.IdleTrack:Stop()
		end
	end
	v_u_25.Collector:Add(v_u_25.Instance:GetAttributeChangedSignal("ForceIdle"):Connect(v45))
	v_u_25.Collector:Add(task.spawn(v45))
	v_u_25.Overhead = v_u_14:Clone()
	v_u_25.Overhead.DisplayName.Text = v_u_26.DisplayName
	v_u_25.Overhead.Price.Text = ("$%*"):format((v_u_17:ToString(v_u_13:GetPrice(v_u_25.Index))))
	v_u_25.Overhead.Rarity.Text = v_u_26.Rarity
	v_u_25.Overhead.Rarity.TextColor3 = v_u_9[v_u_26.Rarity].Color
	v_u_31()
	v_u_25.Overhead.Mutation.Visible = v_u_25.Mutation ~= nil
	if v_u_25.Mutation then
		local v46 = v_u_10[v_u_25.Mutation]
		v_u_25.Overhead.Mutation.Text = v46.DisplayText
		if v46.GradientPreset then
			v_u_25.Overhead.Mutation.TextColor3 = Color3.fromRGB(255, 255, 255)
			v_u_25.Collector:Add(v_u_6.apply(v_u_25.Overhead.Mutation, v46.GradientPreset))
		else
			v_u_25.Overhead.Mutation.TextColor3 = v46.MainColor
		end
	end
	if v_u_9[v_u_26.Rarity].StrokeColor then
		v_u_25.Overhead.Rarity.UIStroke.Color = v_u_9[v_u_26.Rarity].StrokeColor
	end
	v_u_25.Overhead.MaxDistance = v_u_25.Overhead.MaxDistance + 60
	if v27.GradientPreset then
		v_u_25.Collector:Add(v_u_6.apply(v_u_25.Overhead.Rarity, v27.GradientPreset))
	end
	local v47 = v_u_25.AnimalModel:FindFirstChild("OVERHEAD_ATTACHMENT", true)
	if not v47 then
		v47 = Instance.new("Attachment")
		v47.Name = "Info"
		v47.CFrame = CFrame.new(0, v28.Y * 0.75 * (v_u_26.OverheadYOffsetModifier or 1), 0)
		v47.Parent = v_u_25.Instance.PrimaryPart
	end
	v_u_25.Overhead.Parent = v47
	v_u_25.Collector:Add(v_u_2.PostSimulation:Connect(function()
		if v_u_25.Instance and (v_u_25.Instance.Parent and (v_u_25.AnimalModel and v_u_25.AnimalModel.Parent)) then
			v_u_25.AnimalModel:PivotTo(v_u_25.Instance:GetPivot())
		end
	end))
	v_u_25.Collector:Add(v_u_25.Instance:GetAttributeChangedSignal("Traits"):Connect(v40))
	task.spawn(v40)
	return v_u_25
end
function v_u_21.Destroy(p48)
	p48.Collector:Destroy()
end
return v_u_21