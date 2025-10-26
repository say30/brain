--[[
  Extracted from: ReplicatedStorage.Controllers.InterfaceController
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Controllers = ReplicatedStorage:WaitForChild("Controllers")
local InteractController = require(Controllers.InteractController)
local Classes = ReplicatedStorage:WaitForChild("Classes")
local Interface = require(Classes.Interface)
require(Classes.Interface.Styles)

local ToggleEvent = script.Toggle

local registeredInterfaces = {}

local InterfaceManager = {

	SetState = function(self, interfaceName, shouldOpen, exceptions)
		local interface = registeredInterfaces[interfaceName]
		if interface then
			if interface:IsOpened() ~= shouldOpen then
				self:Toggle(interfaceName, shouldOpen, exceptions)
			end
		end
	end,

	Toggle = function(self, interfaceName, forceState, exceptions)
		local targetInterface = registeredInterfaces[interfaceName]
		if not targetInterface then
			return
		end

		local shouldOpen = forceState
		if shouldOpen == nil then
			shouldOpen = not targetInterface:IsOpened()
		end

		local anyInterfaceOpen = true

		for name, interface in pairs(registeredInterfaces) do
			if name == interfaceName then
				interface:Toggle(shouldOpen)
				if not interface:IsOpened() then
					anyInterfaceOpen = false
				end
			elseif interface:IsOpened() then
				local shouldCloseThis = true
				if exceptions then
					shouldCloseThis = not table.find(exceptions, name)
				end

				if shouldCloseThis then
					interface:Close()
				end
			end
		end

		if not anyInterfaceOpen and registeredInterfaces.Hud then
			registeredInterfaces.Hud:Toggle(true)
		end
	end,

	Get = function(self, interfaceName)
		return registeredInterfaces[interfaceName]
	end,

	Register = function(self, interfaceName, param1, param2)
		if registeredInterfaces[interfaceName] then
			return warn(("Failed to create interface: %s, already exist!"):format(interfaceName))
		end
		registeredInterfaces[interfaceName] = Interface.new(interfaceName, param1, param2)
		return registeredInterfaces[interfaceName]
	end,

	Start = function(self)
		ToggleEvent.Event:Connect(function(...)
			self:Toggle(...)
		end)

		InteractController.OnInteractEnter:Connect(function(obj)
			if obj:GetAttribute("Interface") == true then
				if registeredInterfaces[obj.Name] and not registeredInterfaces[obj.Name]:IsOpened() then
					self:Toggle(obj.Name, true)
				end
			end
		end)

		InteractController.OnInteractLeave:Connect(function(obj)
			if obj:GetAttribute("Interface") == true then
				if registeredInterfaces[obj.Name] and registeredInterfaces[obj.Name]:IsOpened() then
					self:Toggle(obj.Name, false)
				end
			end
		end)
	end
}

return InterfaceManager