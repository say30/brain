--[[
  Extracted from: ServerScriptService.Services.CmdrService.Hooks.BeforeRun
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

return function(registry)
	registry:RegisterHook("BeforeRun", function(context)
		local RunService = game:GetService("RunService")
		local player = context.Executor

		if context.Group == "DefaultUtil" or context.Group == "Help" then
			return nil
		end

		if RunService:IsServer() then
			local CmdrService = _G.CmdrService
			if CmdrService and not CmdrService:IsAuthorized(player) then
				return "You are not authorized to use commands."
			end
		end

		return nil
	end, 0)
end 