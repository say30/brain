--[[
  Extracted from: ReplicatedStorage.ChicleteiraBicicleteiraEvent.Chicleteira Bicicleteira.AnimationController.Animator.Animation
  Class: Script
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local animator = script.Parent -- Animator
local model = animator.Parent.Parent -- Sammyni Spyderini

-- Загрузка анимаций
local animations = {
	Idle = animator:LoadAnimation(script:WaitForChild("Idle") or error("Idle animation not found"))
}

-- Настройка анимаций
animations.Idle.Looped = true
animations.Walk.Looped = true
animations.Jump.Looped = false -- Jump не зациклен

-- Функция для воспроизведения анимации
local function playAnimation(animationName)
	for _, anim in pairs(animations) do
		if anim.IsPlaying then
			anim:Stop()
		end
	end
	if animations[animationName] then
		animations[animationName]:Play()
	end
end

-- Подключение к RemoteEvent
local remoteEvent = ReplicatedStorage:WaitForChild("AnimationControl")
remoteEvent.OnClientEvent:Connect(function(command, animationName)
	if command == "PlayAnimation" then
		playAnimation(animationName)
	end
end)

-- Начальная анимация
playAnimation("Idle")