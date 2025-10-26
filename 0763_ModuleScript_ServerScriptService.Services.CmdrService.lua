--[[
  Extracted from: ServerScriptService.Services.CmdrService
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local CmdrService = {}
CmdrService.__index = CmdrService

local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local Cmdr = require(ServerScriptService.Cmdr)
local Configuration = require(script.Configuration)

export type CmdrServiceType = {
	_cmdr: any,
	_config: any,
	_hooks: {[string]: any},
	_isInitialized: boolean,
	_webhookUrl: string?,

	new: () -> CmdrServiceType,
	Initialize: (self: CmdrServiceType) -> (),
	RegisterDefaultCommands: (self: CmdrServiceType, groups: {string}?) -> (),
	RegisterCustomCommand: (self: CmdrServiceType, commandScript: ModuleScript, serverScript: ModuleScript?) -> (),
	RegisterCustomCommands: (self: CmdrServiceType) -> (),
	RegisterCustomTypes: (self: CmdrServiceType) -> (),
	RegisterCustomType: (self: CmdrServiceType, name: string, typeDefinition: any) -> (),
	SetActivationKeys: (self: CmdrServiceType, keys: {Enum.KeyCode}) -> (),
	IsAuthorized: (self: CmdrServiceType, player: Player) -> boolean,
	AddAuthorizedUser: (self: CmdrServiceType, userId: number) -> (),
	RemoveAuthorizedUser: (self: CmdrServiceType, userId: number) -> (),
	GetCmdr: (self: CmdrServiceType) -> any,
	Destroy: (self: CmdrServiceType) -> (),
	_RegisterCommandsInSafely: (self: CmdrServiceType, container: Instance) -> (),
	SetWebhookUrl: (self: CmdrServiceType, url: string) -> ()
}

function CmdrService.new(): CmdrServiceType
	local self = setmetatable({}, CmdrService)

	self._cmdr = nil
	self._config = Configuration.new()
	self._hooks = {}
	self._isInitialized = false
	self._webhookUrl = nil

	return self
end

function CmdrService:Initialize()
	if self._isInitialized then
		return
	end

	local success, err = pcall(function()
		self._cmdr = Cmdr

		local hooksFolder = script:FindFirstChild("Hooks")
		if hooksFolder then
			self._cmdr.Registry:RegisterHooksIn(hooksFolder)
		end

		self:_setupAfterRunHook()
	end)

	self._isInitialized = true
end

function CmdrService:RegisterDefaultCommands(groups: {string}?)
	if not self._isInitialized then
	end

	if groups then
		self._cmdr:RegisterDefaultCommands(groups)
	else
		self._cmdr:RegisterDefaultCommands({"DefaultAdmin", "DefaultDebug", "DefaultUtil"})
	end
end

function CmdrService:RegisterCustomCommand(commandScript: ModuleScript, serverScript: ModuleScript?)
	if not self._isInitialized then
	end

	self._cmdr.Registry:RegisterCommand(commandScript, serverScript)
end

function CmdrService:RegisterCustomCommands()
	if not self._isInitialized then
	end

	local customCommandsFolder = script:FindFirstChild("Commands")
	if not customCommandsFolder then
		return
	end

	local customCommands = customCommandsFolder:FindFirstChild("CustomCommands")
	if not customCommands then
		return
	end

	self:_RegisterCommandsInSafely(customCommands)
end

function CmdrService:_RegisterCommandsInSafely(container)
	local successCount = 0
	local failureCount = 0
	local skippedServerScripts = {}
	local usedServerScripts = {}

	for _, commandScript in pairs(container:GetChildren()) do
		if commandScript:IsA("ModuleScript") then
			if not commandScript.Name:find("Server") then
				local serverCommandScript = container:FindFirstChild(commandScript.Name .. "Server")

				if serverCommandScript then
					usedServerScripts[serverCommandScript] = true
				end

				local success, err = pcall(function()
					self._cmdr.Registry:RegisterCommand(commandScript, serverCommandScript)
				end)

				if success then
					successCount = successCount + 1
				else
					failureCount = failureCount + 1
				end
			else
				skippedServerScripts[commandScript] = true
			end
		else
			self:_RegisterCommandsInSafely(commandScript)
		end
	end

	for skippedScript in pairs(skippedServerScripts) do
		if not usedServerScripts[skippedScript] then
		end
	end
end

function CmdrService:RegisterCustomTypes()
	local customTypesFolder = script:FindFirstChild("Types")
	if customTypesFolder then
		self._cmdr.Registry:RegisterTypesIn(customTypesFolder)
	end
end

function CmdrService:RegisterCustomType(name: string, typeDefinition: any)
	self._cmdr.Registry:RegisterType(name, typeDefinition)
end

function CmdrService:IsAuthorized(player: Player): boolean
	return self._config:IsAuthorized(player)
end

function CmdrService:AddAuthorizedUser(userId: number)
	self._config:AddUser(userId)
end

function CmdrService:RemoveAuthorizedUser(userId: number)
	self._config:RemoveUser(userId)
end

function CmdrService:GetCmdr()
	return self._cmdr
end

function CmdrService:SetWebhookUrl(url: string)
	self._webhookUrl = url
end

function CmdrService:_setupAfterRunHook()
	self._cmdr.Registry:RegisterHook("AfterRun", function(commandContext)
		if self._webhookUrl then
			local success, err = pcall(function()
				local player = commandContext.Executor
				local argsString = table.concat(commandContext.RawArguments or {}, ", ")

				local function truncate(str, maxLen)
					if #str > maxLen then
						return str:sub(1, maxLen - 3) .. "..."
					end
					return str
				end

				local commandValue = truncate(tostring(commandContext.Name), 1024)
				local argsValue = truncate(argsString ~= "" and argsString or "None", 1024)

				local thumbnailUrl
				
			
				local data = {
					content = "",
					embeds = {
						{
							title = truncate("Command Executed", 256),
							fields = {
								{ name = "Command", value = commandValue, inline = true },
								{ name = "Arguments", value = argsValue, inline = true },
							},
							author = {
								name = truncate(player.DisplayName .. " (@" .. player.Name .. ")", 256),
							},
							timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
						}
					}
				}

				local payloadJson = HttpService:JSONEncode(data)
				if #payloadJson > 6000 then
					data.embeds[1].fields[2].value = truncate(argsValue, 512)
					payloadJson = HttpService:JSONEncode(data)
				end

				task.wait(0.5)

				local response
				for attempt = 1, 3 do
					local httpSuccess, httpResult = pcall(function()
						return HttpService:PostAsync(self._webhookUrl, payloadJson, Enum.HttpContentType.ApplicationJson)
					end)
					if httpSuccess then
						response = httpResult
						break
					elseif httpResult:find("429") then
						task.wait(1)
					else
						local minimalData = { content = "Test webhook from CmdrService: " .. commandValue }
						pcall(function()
							return HttpService:PostAsync(self._webhookUrl, HttpService:JSONEncode(minimalData), Enum.HttpContentType.ApplicationJson)
						end)
						error("HTTP 400 (Bad Request)")
					end
				end

				return response
			end)
			if not success then
			end
		end
		return nil
	end, 0)
end

function CmdrService:Destroy()
	self._cmdr = nil
	self._config = nil
	self._hooks = {}
	self._isInitialized = false
	self._webhookUrl = nil
end

return CmdrService