--[[
  Extracted from: ReplicatedStorage.Controllers.EffectController
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
require(script.Types)

local EffectsManager = {
	Effects = {},
	ActiveEffects = {}
}

function EffectsManager:Activate(effectName)
	local effect = self.Effects[effectName]
	if not effect then
		return false
	end

	if type(effect.Activate) == "function" then
		effect:Activate()
	end

	return true
end

function EffectsManager:Run(playerId, effectName)
	local effect = self.Effects[effectName]
	if not effect then
		return false, false
	end

	if not self.ActiveEffects[effectName] then
		self.ActiveEffects[effectName] = {}
	end

	local previousActiveEffects = table.clone(self.ActiveEffects[effectName])
	self.ActiveEffects[effectName][playerId] = true

	if next(previousActiveEffects) then
		if type(effect.OnUpdate) == "function" then
			effect:OnUpdate()
		end
		return false, true
	else
		if type(effect.OnStart) == "function" then
			effect:OnStart()
		end
		return true, true
	end
end

function EffectsManager:Stop(playerId, effectName)
	local effect = self.Effects[effectName]
	if not effect then
		return false
	end

	if not self.ActiveEffects[effectName] then
		return false
	end

	if not next(self.ActiveEffects[effectName]) then
		return false
	end

	self.ActiveEffects[effectName][playerId] = nil

	if type(effect.OnUpdate) == "function" then
		effect:OnUpdate()
	end

	if next(self.ActiveEffects[effectName]) then
		return false
	end

	self.ActiveEffects[effectName] = nil
	if type(effect.OnStop) == "function" then
		effect:OnStop()
	end

	return true
end

function EffectsManager:Load()
	for _, effectModule in script.Effects:GetChildren() do
		if effectModule:IsA("ModuleScript") then
			local success, effectTable = pcall(require, effectModule)

			if success and type(effectTable) == "table" then
				if type(effectTable.OnLoad) == "function" then
					local loadSuccess, loadError = pcall(effectTable.OnLoad, effectTable)
					if not loadSuccess then
						warn(string.format(
							"Effect %s failed to call Load function:\n%s",
							effectModule:GetFullName(),
							loadError or "yielded (possibly)"
							))
						continue
					end
				end

				self.Effects[effectModule.Name] = effectTable
			else
				warn(string.format(
					"Effect %s failed to load:\n%s",
					effectModule:GetFullName(),
					effectTable or "yielded (possibly)"
					))
			end
		end
	end
end

function EffectsManager:Start()
end

return EffectsManager