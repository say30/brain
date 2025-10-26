--[[
  Extracted from: ReplicatedStorage.Items.Invisibility Cloak.InvisibilityController
  Class: Script
  Source file: rickdev.rbxlx
]]

local Tool = script.Parent
local TweenService = game:GetService("TweenService")

local IsInvisible = false
local FadeTime = 0.5
local CurrentCharacter = nil

local WooshStart = Tool:WaitForChild("Handle"):WaitForChild("WooshStart")
local WooshEnd = Tool:WaitForChild("Handle"):WaitForChild("WooshEnd")

local function FadeParts(Parent, Enabled)
	for _, Part in ipairs(Parent:GetDescendants()) do
		if Part:IsA("BasePart") and Part.Name ~= "HumanoidRootPart" then
			local GoalTransparency = Enabled and 1 or 0
			TweenService:Create(Part, TweenInfo.new(FadeTime), { Transparency = GoalTransparency }):Play()

			local Face = Part:FindFirstChild("face")
			if Face then
				TweenService:Create(Face, TweenInfo.new(FadeTime), { Transparency = GoalTransparency }):Play()
			end
		elseif Part:IsA("Decal") then
			local GoalTransparency = Enabled and 1 or 0
			TweenService:Create(Part, TweenInfo.new(FadeTime), { Transparency = GoalTransparency }):Play()
		end
	end
end

local function ApplyInvisibility(Character, Enabled, PlaySound)
	FadeParts(Character, Enabled)
	FadeParts(Tool, Enabled)

	local Humanoid = Character:FindFirstChildOfClass("Humanoid")
	if Humanoid then
		Humanoid.NameDisplayDistance = Enabled and 0 or 100
		if Enabled then
			Tool:SetAttribute("SpeedModifier", 1.75)
		else
			Tool:SetAttribute("SpeedModifier", 1)
		end
	end

	if PlaySound then
		if Enabled then
			WooshStart:Play()
		else
			WooshEnd:Play()
		end
	end
end

Tool.Equipped:Connect(function()
	CurrentCharacter = Tool.Parent

	if IsInvisible and CurrentCharacter then
		FadeParts(Tool, true)
	end
end)

Tool.Activated:Connect(function()
	if not CurrentCharacter then return end
	local Humanoid = CurrentCharacter:FindFirstChildOfClass("Humanoid")
	if not Humanoid then return end

	IsInvisible = not IsInvisible
	ApplyInvisibility(CurrentCharacter, IsInvisible, true)
end)

Tool.Unequipped:Connect(function()
	if IsInvisible and CurrentCharacter then
		IsInvisible = false
		ApplyInvisibility(CurrentCharacter, false, false)
	end
	CurrentCharacter = nil
end)