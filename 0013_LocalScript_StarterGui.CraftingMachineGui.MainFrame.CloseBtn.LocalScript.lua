--[[
  Extracted from: StarterGui.CraftingMachineGui.MainFrame.CloseBtn.LocalScript
  Class: LocalScript
  Source file: rickdev.rbxlx
]]

--// Variables
local exitButton = script.Parent -- exit button
local frame = exitButton.Parent -- frame
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

-- Ensure a BlurEffect exists
local blur = Lighting:FindFirstChildOfClass("BlurEffect")
if not blur then
	blur = Instance.new("BlurEffect")
	blur.Size = 0
	blur.Enabled = true
	blur.Parent = Lighting
end

-- Tween settings
local tweenTime = 0.3
local tweenInfo = TweenInfo.new(tweenTime, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

exitButton.MouseButton1Click:Connect(function()
	-- Slide frame back up (offscreen)
	local slideTween = TweenService:Create(frame, tweenInfo, {
		Position = UDim2.new(0.5, 0, -0.5, 0)
	})
	slideTween:Play()

	-- Fade out blur smoothly
	local blurTween = TweenService:Create(blur, tweenInfo, {Size = 0})
	blurTween:Play()

	-- After the tween completes, hide frame and disable blur
	slideTween.Completed:Connect(function()
		frame.Visible = false
		blur.Enabled = false
	end)
end)