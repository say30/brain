--[[
  Extracted from: ReplicatedStorage.Packages.Net
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local RunService = game:GetService("RunService")

return {
	UnreliableRemoteEvent = function(_, name)
		name = "URE/" .. name
		if RunService:IsServer() then
			local event = script:FindFirstChild(name)
			if not event then
				event = Instance.new("UnreliableRemoteEvent")
				event.Name = name
				event.Parent = script
			end
			return event
		else
			local event = script:WaitForChild(name, 10)
			if not event then
				error("Failed to find UnreliableRemoteEvent: " .. name, 2)
			end
			return event
		end
	end,

	RemoteEvent = function(_, name)
		name = "RE/" .. name
		if RunService:IsServer() then
			local event = script:FindFirstChild(name)
			if not event then
				event = Instance.new("RemoteEvent")
				event.Name = name
				event.Parent = script
			end
			return event
		else
			local event = script:WaitForChild(name, 10)
			if not event then
				error("Failed to find RemoteEvent: " .. name, 2)
			end
			return event
		end
	end,

	ConnectUnreliable = function(self, name, callback)
		if RunService:IsServer() then
			return self:UnreliableRemoteEvent(name).OnServerEvent:Connect(callback)
		else
			return self:UnreliableRemoteEvent(name).OnClientEvent:Connect(callback)
		end
	end,

	Connect = function(self, name, callback)
		if RunService:IsServer() then
			return self:RemoteEvent(name).OnServerEvent:Connect(callback)
		else
			return self:RemoteEvent(name).OnClientEvent:Connect(callback)
		end
	end,

	RemoteFunction = function(_, name)
		name = "RF/" .. name
		if RunService:IsServer() then
			local func = script:FindFirstChild(name)
			if not func then
				func = Instance.new("RemoteFunction")
				func.Name = name
				func.Parent = script
			end
			return func
		else
			local func = script:WaitForChild(name, 10)
			if not func then
				error("Failed to find RemoteFunction: " .. name, 2)
			end
			return func
		end
	end,

	Handle = function(self, name, callback)
		self:RemoteFunction(name).OnServerInvoke = callback
	end,

	Invoke = function(self, name, ...)
		return self:RemoteFunction(name):InvokeServer(...)
	end,

	Clean = function(_)
		script:ClearAllChildren()
	end
}