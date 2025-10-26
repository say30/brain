--[[
  Extracted from: ServerScriptService.Services.EventService
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Packages = ReplicatedStorage.Packages
local Net = require(Packages.Net)
local Synchronizer = require(Packages.Synchronizer)

-- === Existing event requires ===
local RainingTacosEvent = require(script.Events.RainingTacosEvent)
local MatteoEvent = require(script.Events.MatteoEvent)
local NyanCatsEvent = require(script.Events.NyanCatsEvent)
local LaVaccaEvent = require(script.Events.LaVaccaEvent)
local FourthOfJulyEvent = require(script.Events.FourthOfJulyEvent)
local TungTungAttackEvent = require(script.Events.TungTungAttackEvent)
local CrabRaveEvent = require(script.Events.CrabRaveEvent)
local ConcertEvent = require(script.Events.Concert)
local SnowEvent = require(script.Events.Snow)
local TenBVisits = require(script.Events["10B Visits"])
local Glitch = require(script.Events.Glitch)
local Starfall = require(script.Events.Starfall)
local LosMatteos = require(script.Events.LosMatteos)
local Brazil = require(script.Events.Brazil)
local Water = require(script.Events.Water)
local Rainbow = require(script.Events.Rainbow)
local BombardiroCrocodilo = require(script.Events["Bombardiro Crocodilo"])
local SolarFlare = require(script.Events["SolarFlareEvent"])
local Galaxy = require(script.Events.Galaxy)
local Phase1 = require(script.Events["Phase 1: Sleepy"])
local Phase2 = require(script.Events["Phase 2: Galaxy Introduction"])
local Phase3 = require(script.Events["Phase 3: Sammy's Base"])
local Phase4 = require(script.Events["Phase 4: Mygame43"])
local Phase5 = require(script.Events["Phase 5: Sammy Snap"])
local UFO = require(script.Events.UFO)
local Rain = require(script.Events.Rain)
local RapConcert = require(script.Events["Rap Concert"])
local WitchingHour = require(script.Events["Witching Hour"])

-- Optional / potentially missing modules: require safely where appropriate
local MexicoEventModule
do
	local ok, mod = pcall(function() return require(script.Events.Mexico) end)
	if ok then
		MexicoEventModule = mod
	else
		MexicoEventModule = nil
	end
end

-- Try to require YinYang (module might be named YinYang or YinYangEvent in your tree).
local YinYang
do
	local ok, mod = pcall(function() return require(script.Events.YinYang) end)
	if ok then
		YinYang = mod
	else
		-- fallback to alternate name
		local ok2, mod2 = pcall(function() return require(script.Events.YinYangEvent) end)
		if ok2 then
			YinYang = mod2
		else
			YinYang = nil
		end
	end
end

-- Missing event modules (require but prefer not to crash if missing)
local FatSammyEvent
do
	local ok, mod = pcall(function() return require(script.Events.FatSammyEvent) end)
	if ok then FatSammyEvent = mod else FatSammyEvent = nil end
end

local ChicleteiraBicicleteira
do
	local ok, mod = pcall(function() return require(script.Events["Chicleteira Bicicleteira"]) end)
	if ok then ChicleteiraBicicleteira = mod else ChicleteiraBicicleteira = nil end
end

local ExtinctEventModule
do
	local ok, mod = pcall(function() return require(script.Events.Extinct) end)
	if ok then ExtinctEventModule = mod else ExtinctEventModule = nil end
end

local IndonesiaEventModule
do
	local ok, mod = pcall(function() return require(script.Events.Indonesia) end)
	if ok then IndonesiaEventModule = mod else IndonesiaEventModule = nil end
end

local MeowlEventModule
do
	local ok, mod = pcall(function() return require(script.Events.Meowl) end)
	if ok then MeowlEventModule = mod else MeowlEventModule = nil end
end

-- EventService table
local EventService = {}
EventService.__index = EventService

EventService.Events = {
	"Raining Tacos",
	"Matteo",
	"Nyan Cats",
	"La Vacca Saturno Saturnita",
	"4th of July",
	"Tung Tung Attack",
	"Crab Rave",
	"Molten",
	"Concert",
	"Snow",
	"10B Visits",
	"Glitch",
	"Starfall",
	"Los Matteos",
	"Brazil",
	"Water",
	"Rainbow",
	"Bombardiro Crocodilo",
	"Solar Flare",
	"Galaxy",
	"Phase 1: Sleepy",
	"Phase 2: Galaxy Introduction",
	"Phase 3: Sammy's Base",
	"Phase 4: Mygame43",
	"Phase 5: Sammy Snap",
	"Bubblegum",
	"UFO",
	"Rain",
	"Rap Concert",
	"Strawberry",
	"Sammyni Spyderini",
	"Mexico",
	"YinYang",
	"Witching Hour",

	-- added public names
	"Chicleteira Bicicleteira",
	"Extinct",
	"FatSammy",
	"Witching Hour",
	"Indonesia",
	"Meowl",
}

Net:Handle("EventService/ListEvents", function(player)
	return EventService.Events
end)

function EventService.new()
	local self = setmetatable({}, EventService)
	self._activeEvents = {}
	self._registeredEvents = {}
	self._eventTimers = {}
	self._eventStartTimes = {}
	self._eventDurations = {}

	-- create instances safely, preferring OnLoad -> new -> module table
	local function initModule(mod, name)
		if not mod then return nil end
		if mod.OnLoad and type(mod.OnLoad) == "function" then
			local ok, res = pcall(function() return mod.OnLoad(self) end)
			if ok then return res end
		end
		if mod.new and type(mod.new) == "function" then
			local ok, res = pcall(function() return mod.new(self) end)
			if ok then return res end
		end
		return mod
	end

	self._eventInstances = {
		["Raining Tacos"] = initModule(RainingTacosEvent, "Raining Tacos"),
		["Matteo"] = initModule(MatteoEvent, "Matteo"),
		["Nyan Cats"] = initModule(NyanCatsEvent, "Nyan Cats"),
		["La Vacca Saturno Saturnita"] = initModule(LaVaccaEvent, "La Vacca Saturno Saturnita"),
		["4th of July"] = initModule(FourthOfJulyEvent, "4th of July"),
		["Tung Tung Attack"] = initModule(TungTungAttackEvent, "Tung Tung Attack"),
		["Crab Rave"] = initModule(CrabRaveEvent, "Crab Rave"),
		Concert = initModule(ConcertEvent, "Concert"),
		Snow = initModule(SnowEvent, "Snow"),

		["10B Visits"] = initModule(TenBVisits, "10B Visits"),
		Glitch = initModule(Glitch, "Glitch"),
		Starfall = initModule(Starfall, "Starfall"),
		["Los Matteos"] = initModule(LosMatteos, "Los Matteos"),
		Brazil = initModule(Brazil, "Brazil"),
		Water = (function() -- this uses OnLoad in original code
			local mod = Water
			if not mod then return nil end
			if mod.OnLoad and type(mod.OnLoad) == "function" then
				local ok, res = pcall(function() return mod.OnLoad(self) end)
				if ok then return res end
			end
			if mod.new and type(mod.new) == "function" then
				local ok, res = pcall(function() return mod.new(self) end)
				if ok then return res end
			end
			return mod
		end)(),
		["Solar Flare"] = initModule(SolarFlare, "Solar Flare"),
		["Bombardiro Crocodilo"] = initModule(BombardiroCrocodilo, "Bombardiro Crocodilo"),
		["Phase 1: Sleepy"] = initModule(Phase1, "Phase 1: Sleepy"),
		["Phase 2: Galaxy Introduction"] = initModule(Phase2, "Phase 2: Galaxy Introduction"),
		Phase3 = initModule(Phase3, "Phase3"),
		["Phase 4: Mygame43"] = initModule(Phase4, "Phase 4: Mygame43"),
		Phase5 = initModule(Phase5, "Phase5"),
		UFO = initModule(UFO, "UFO"),
		Rain = initModule(Rain, "Rain"),
		["Rap Concert"] = initModule(RapConcert, "Rap Concert"),
		["Witching Hour"] = initModule(WitchingHour, "Witching Hour"),
		-- YinYang: handle module shape
		YinYang = (function()
			if not YinYang then return nil end
			if YinYang.OnLoad and type(YinYang.OnLoad) == "function" then
				local ok, res = pcall(function() return YinYang.OnLoad(self) end)
				if ok then return res end
			end
			if YinYang.new and type(YinYang.new) == "function" then
				local ok, res = pcall(function() return YinYang.new(self) end)
				if ok then return res end
			end
			return YinYang
		end)(),

		-- Mexico: only initialize if required successfully
		Mexico = (function()
			if not MexicoEventModule then return nil end
			if MexicoEventModule.OnLoad and type(MexicoEventModule.OnLoad) == "function" then
				local ok, res = pcall(function() return MexicoEventModule.OnLoad(self) end)
				if ok then return res end
			end
			if MexicoEventModule.new and type(MexicoEventModule.new) == "function" then
				local ok, res = pcall(function() return MexicoEventModule.new(self) end)
				if ok then return res end
			end
			return MexicoEventModule
		end)(),

		-- ADDED: FatSammy (if present)
		FatSammy = (function()
			if not FatSammyEvent then return nil end
			if FatSammyEvent.OnLoad and type(FatSammyEvent.OnLoad) == "function" then
				local ok, res = pcall(function() return FatSammyEvent.OnLoad(self) end)
				if ok then return res end
			end
			if FatSammyEvent.new and type(FatSammyEvent.new) == "function" then
				local ok, res = pcall(function() return FatSammyEvent.new(self) end)
				if ok then return res end
			end
			return FatSammyEvent
		end)(),

		-- ADDED: Chicleteira Bicicleteira (safe init)
		["Chicleteira Bicicleteira"] = (function()
			if not ChicleteiraBicicleteira then return nil end
			if ChicleteiraBicicleteira.OnLoad and type(ChicleteiraBicicleteira.OnLoad) == "function" then
				local ok, res = pcall(function() return ChicleteiraBicicleteira.OnLoad(self) end)
				if ok then return res end
			end
			if ChicleteiraBicicleteira.new and type(ChicleteiraBicicleteira.new) == "function" then
				local ok, res = pcall(function() return ChicleteiraBicicleteira.new(self) end)
				if ok then return res end
			end
			return ChicleteiraBicicleteira
		end)(),

		-- ADDED: Extinct (safe init)
		Extinct = (function()
			if not ExtinctEventModule then return nil end
			if ExtinctEventModule.OnLoad and type(ExtinctEventModule.OnLoad) == "function" then
				local ok, res = pcall(function() return ExtinctEventModule.OnLoad(self) end)
				if ok then return res end
			end
			if ExtinctEventModule.new and type(ExtinctEventModule.new) == "function" then
				local ok, res = pcall(function() return ExtinctEventModule.new(self) end)
				if ok then return res end
			end
			return ExtinctEventModule
		end)(),

		-- ADDED: Indonesia (safe init)
		Indonesia = (function()
			if not IndonesiaEventModule then return nil end
			if IndonesiaEventModule.OnLoad and type(IndonesiaEventModule.OnLoad) == "function" then
				local ok, res = pcall(function() return IndonesiaEventModule.OnLoad(self) end)
				if ok then return res end
			end
			if IndonesiaEventModule.new and type(IndonesiaEventModule.new) == "function" then
				local ok, res = pcall(function() return IndonesiaEventModule.new(self) end)
				if ok then return res end
			end
			return IndonesiaEventModule
		end)(),

		-- ADDED: Meowl (safe init)
		Meowl = (function()
			if not MeowlEventModule then return nil end
			if MeowlEventModule.OnLoad and type(MeowlEventModule.OnLoad) == "function" then
				local ok, res = pcall(function() return MeowlEventModule.OnLoad(self) end)
				if ok then return res end
			end
			if MeowlEventModule.new and type(MeowlEventModule.new) == "function" then
				local ok, res = pcall(function() return MeowlEventModule.new(self) end)
				if ok then return res end
			end
			return MeowlEventModule
		end)(),
	}

	self:_initialize()
	return self
end

function EventService:_initialize()
	self._synchronizer = Synchronizer:Create("Events", {
		ActiveEvents = {}
	})

	game.Players.PlayerAdded:Connect(function(player)
		task.wait(1)
		self._synchronizer:AddListener(player)
	end)

	for _, player in pairs(game.Players:GetPlayers()) do
		self._synchronizer:AddListener(player)
	end

	game.Players.PlayerRemoving:Connect(function(player)
		self._synchronizer:RemoveListener(player)
	end)

	task.wait(0.1)
	self:_setupRemoteEvents()
	self:_registerDefaultEvents()
	task.wait(0.1)
end

function EventService:_setupRemoteEvents()
	local triggerEventRemote = Net:RemoteEvent("EventService/TriggerEvent")
	local stopEventRemote = Net:RemoteEvent("EventService/StopEvent")
	local getActiveEventsRemote = Net:RemoteEvent("EventService/GetActiveEvents")

	triggerEventRemote.OnServerEvent:Connect(function(player, eventName, duration)
		self:StartEvent(eventName, duration)
	end)

	stopEventRemote.OnServerEvent:Connect(function(player, eventName)
		self:StopEvent(eventName)
	end)

	getActiveEventsRemote.OnServerEvent:Connect(function(player)
		getActiveEventsRemote:FireClient(player, self._activeEvents)
	end)
end

function EventService:_registerDefaultEvents()
	self:RegisterEvent("Bloodmoon", {
		defaultDuration = 300,
		canStack = false,
		cooldown = 600,
		description = "Blood moon event with atmospheric changes"
	})

	local function safeWrapper(eventName, funcName, eventEntry)
		local success, err = pcall(function()
			if self._eventInstances[eventName] and type(self._eventInstances[eventName][funcName]) == "function" then
				self._eventInstances[eventName][funcName](self._eventInstances[eventName], eventEntry)
			end
		end)
		if not success then
			-- warn(string.format("[EventService] Error in %s callback for '%s': %s", funcName, eventName, err))
		end
	end

	-- core registrations (kept the same patterns you used)
	self:RegisterEvent("Nyan Cats", {
		defaultDuration = 180,
		canStack = false,
		cooldown = 300,
		description = "Nyan cats flying around",
		onStart = function(eventEntry) safeWrapper("Nyan Cats", "Start", eventEntry) end,
		onStop = function(eventEntry) safeWrapper("Nyan Cats", "Stop", eventEntry) end,
	})

	self:RegisterEvent("Mexico", {
		defaultDuration = 240,
		canStack = false,
		cooldown = 480,
		description = "Mexico event with cultural-themed effects and traits",
		onStart = function(eventEntry)
			if self._eventInstances["Mexico"] and type(self._eventInstances["Mexico"].Start) == "function" then
				self._eventInstances["Mexico"]:Start(eventEntry)
			end
		end,
		onStop = function(eventEntry)
			if self._eventInstances["Mexico"] and type(self._eventInstances["Mexico"].Stop) == "function" then
				self._eventInstances["Mexico"]:Stop(eventEntry)
			end
		end
	})

	self:RegisterEvent("YinYang", {
		defaultDuration = 240,
		canStack = false,
		cooldown = 480,
		description = "Balanced effects (YinYang)",
		onStart = function(eventEntry)
			if self._eventInstances["YinYang"] and type(self._eventInstances["YinYang"].Start) == "function" then
				self._eventInstances["YinYang"]:Start(eventEntry)
			end
		end,
		onStop = function(eventEntry)
			if self._eventInstances["YinYang"] and type(self._eventInstances["YinYang"].Stop) == "function" then
				self._eventInstances["YinYang"]:Stop(eventEntry)
			end
		end
	})

	self:RegisterEvent("Raining Tacos", {
		defaultDuration = 240,
		canStack = false,
		cooldown = 480,
		description = "Tacos falling from the sky",
		onStart = function(eventEntry) safeWrapper("Raining Tacos", "Start", eventEntry) end,
		onStop = function(eventEntry) safeWrapper("Raining Tacos", "Stop", eventEntry) end,
	})

	self:RegisterEvent("La Vacca Saturno Saturnita", {
		defaultDuration = 200,
		canStack = false,
		cooldown = 400,
		description = "Special cow event",
		onStart = function(eventEntry) safeWrapper("La Vacca Saturno Saturnita", "Start", eventEntry) end,
		onStop = function(eventEntry) safeWrapper("La Vacca Saturno Saturnita", "Stop", eventEntry) end,
	})

	self:RegisterEvent("Matteo", {
		defaultDuration = 150,
		canStack = false,
		cooldown = 300,
		description = "Matteo special event",
		onStart = function(eventEntry) safeWrapper("Matteo", "Start", eventEntry) end,
		onStop = function(eventEntry) safeWrapper("Matteo", "Stop", eventEntry) end,
	})

	self:RegisterEvent("4th of July", {
		defaultDuration = 300,
		canStack = false,
		cooldown = 600,
		description = "Celebrate Independence Day with fireworks and special animal!",
		onStart = function(eventEntry) safeWrapper("4th of July", "Start", eventEntry) end,
		onStop = function(eventEntry) safeWrapper("4th of July", "Stop", eventEntry) end,
	})

	self:RegisterEvent("Tung Tung Attack", {
		defaultDuration = 180,
		canStack = false,
		cooldown = 360,
		description = "Baby Tung Tung wander the map infecting nearby animals with the Zombie trait.",
		onStart = function(eventEntry) safeWrapper("Tung Tung Attack", "Start", eventEntry) end,
		onStop = function(eventEntry) safeWrapper("Tung Tung Attack", "Stop", eventEntry) end,
	})

	self:RegisterEvent("Crab Rave", {
		defaultDuration = 240,
		canStack = false,
		cooldown = 480,
		description = "Crabs roam the map and hit animals, applying the Claws trait.",
		onStart = function(eventEntry) safeWrapper("Crab Rave", "Start", eventEntry) end,
		onStop = function(eventEntry) safeWrapper("Crab Rave", "Stop", eventEntry) end,
	})

	self:RegisterEvent("Molten", {
		defaultDuration = 900,
		canStack = false,
		cooldown = 480,
		description = "its lava time",
		onStart = function(eventEntry) safeWrapper("Molten", "Start", eventEntry) end,
		onStop = function(eventEntry) safeWrapper("Molten", "Stop", eventEntry) end,
	})

	self:RegisterEvent("Concert", {
		defaultDuration = 126,
		canStack = false,
		cooldown = 480,
		description = "its concert time",
		onStart = function(eventEntry) safeWrapper("Concert", "Start", eventEntry) end,
		onStop = function(eventEntry) safeWrapper("Concert", "Stop", eventEntry) end,
	})

	self:RegisterEvent("Snow", {
		defaultDuration = 240,
		canStack = false,
		cooldown = 480,
		description = "its snow time",
		onStart = function(eventEntry)
			if self._eventInstances["Snow"] and type(self._eventInstances["Snow"].Start) == "function" then
				self._eventInstances["Snow"]:Start(eventEntry)
			end
		end,
		onStop = function(eventEntry)
			if self._eventInstances["Snow"] and type(self._eventInstances["Snow"].Stop) == "function" then
				self._eventInstances["Snow"]:Stop(eventEntry)
			end
		end
	})

	self:RegisterEvent("10B Visits", {
		defaultDuration = 240,
		canStack = false,
		cooldown = 480,
		description = "Thank you for 10B Visits!",
		onStart = function(eventEntry)
			if self._eventInstances["10B Visits"] and type(self._eventInstances["10B Visits"].Start) == "function" then
				self._eventInstances["10B Visits"]:Start(eventEntry)
			end
		end,
		onStop = function(eventEntry)
			if self._eventInstances["10B Visits"] and type(self._eventInstances["10B Visits"].Stop) == "function" then
				self._eventInstances["10B Visits"]:Stop(eventEntry)
			end
		end
	})

	self:RegisterEvent("Glitch", {
		defaultDuration = 240,
		canStack = false,
		cooldown = 480,
		description = "itz so glitchy here :3",
		onStart = function(eventEntry)
			if self._eventInstances["Glitch"] and type(self._eventInstances["Glitch"].Start) == "function" then
				self._eventInstances["Glitch"]:Start(eventEntry)
			end
		end,
		onStop = function(eventEntry)
			if self._eventInstances["Glitch"] and type(self._eventInstances["Glitch"].Stop) == "function" then
				self._eventInstances["Glitch"]:Stop(eventEntry)
			end
		end
	})

	self:RegisterEvent("Starfall", {
		defaultDuration = 240,
		canStack = false,
		cooldown = 480,
		description = "starfall uwu",
		onStart = function(eventEntry) safeWrapper("Starfall", "Start", eventEntry) end,
		onStop = function(eventEntry) safeWrapper("Starfall", "Stop", eventEntry) end,
	})

	self:RegisterEvent("Witching Hour", {
		defaultDuration = 240,
		canStack = false,
		cooldown = 480,
		description = "starfall uwu",
		onStart = function(eventEntry) safeWrapper("Witching Hour", "Start", eventEntry) end,
		onStop = function(eventEntry) safeWrapper("Witching Hour", "Stop", eventEntry) end,
	})

	self:RegisterEvent("Los Matteos", {
		defaultDuration = 240,
		canStack = false,
		cooldown = 480,
		description = "LOSSS MATTEOOSSS",
		onStart = function(eventEntry)
			if self._eventInstances["Los Matteos"] and type(self._eventInstances["Los Matteos"].Start) == "function" then
				self._eventInstances["Los Matteos"]:Start(eventEntry)
			end
		end,
		onStop = function(eventEntry)
			if self._eventInstances["Los Matteos"] and type(self._eventInstances["Los Matteos"].Stop) == "function" then
				self._eventInstances["Los Matteos"]:Stop(eventEntry)
			end
		end
	})

	self:RegisterEvent("Brazil", {
		defaultDuration = 240,
		canStack = false,
		cooldown = 480,
		description = "bra-brazil",
		onStart = function(eventEntry)
			if self._eventInstances["Brazil"] and type(self._eventInstances["Brazil"].Start) == "function" then
				self._eventInstances["Brazil"]:Start(eventEntry)
			end
		end,
		onStop = function(eventEntry)
			if self._eventInstances["Brazil"] and type(self._eventInstances["Brazil"].Stop) == "function" then
				self._eventInstances["Brazil"]:Stop(eventEntry)
			end
		end
	})

	self:RegisterEvent("Water", {
		defaultDuration = 240,
		canStack = false,
		cooldown = 480,
		description = "bottle of wata",
		onStart = function(eventEntry)
			if self._eventInstances["Water"] and type(self._eventInstances["Water"].Start) == "function" then
				self._eventInstances["Water"]:Start(eventEntry)
			end
		end,
		onStop = function(eventEntry)
			if self._eventInstances["Water"] and type(self._eventInstances["Water"].Stop) == "function" then
				self._eventInstances["Water"]:Stop(eventEntry)
			end
		end
	})

	self:RegisterEvent("Rainbow", {
		defaultDuration = 240,
		canStack = false,
		cooldown = 480,
		description = "shine",
		onStart = function(eventEntry) safeWrapper("Rainbow", "Start", eventEntry) end,
		onStop = function(eventEntry) safeWrapper("Rainbow", "Stop", eventEntry) end,
	})

	self:RegisterEvent("Bombardiro Crocodilo", {
		defaultDuration = 240,
		canStack = false,
		cooldown = 480,
		description = "shine",
		onStart = function(eventEntry)
			if self._eventInstances["Bombardiro Crocodilo"] and type(self._eventInstances["Bombardiro Crocodilo"].Start) == "function" then
				self._eventInstances["Bombardiro Crocodilo"]:Start(eventEntry)
			end
		end,
		onStop = function(eventEntry)
			if self._eventInstances["Bombardiro Crocodilo"] and type(self._eventInstances["Bombardiro Crocodilo"].Stop) == "function" then
				self._eventInstances["Bombardiro Crocodilo"]:Stop(eventEntry)
			end
		end
	})

	self:RegisterEvent("Solar Flare", {
		defaultDuration = 240,
		canStack = false,
		cooldown = 480,
		description = "shine",
		onStart = function(eventEntry)
			if self._eventInstances["Solar Flare"] and type(self._eventInstances["Solar Flare"].Start) == "function" then
				self._eventInstances["Solar Flare"]:Start(eventEntry)
			end
		end,
		onStop = function(eventEntry)
			if self._eventInstances["Solar Flare"] and type(self._eventInstances["Solar Flare"].Stop) == "function" then
				self._eventInstances["Solar Flare"]:Stop(eventEntry)
			end
		end
	})

	self:RegisterEvent("Galaxy", {
		defaultDuration = 240,
		canStack = false,
		cooldown = 480,
		description = "shine",
		onStart = function(eventEntry) safeWrapper("Galaxy", "Start", eventEntry) end,
		onStop = function(eventEntry) safeWrapper("Galaxy", "Stop", eventEntry) end,
	})

	self:RegisterEvent("Phase 1: Sleepy", {
		defaultDuration = 240,
		canStack = false,
		cooldown = 480,
		description = "Phase 1: Sleepy",
		onStart = function(eventEntry)
			if self._eventInstances["Phase 1: Sleepy"] and type(self._eventInstances["Phase 1: Sleepy"].Start) == "function" then
				self._eventInstances["Phase 1: Sleepy"]:Start(eventEntry)
			end
		end,
		onStop = function(eventEntry)
			if self._eventInstances["Phase 1: Sleepy"] and type(self._eventInstances["Phase 1: Sleepy"].Stop) == "function" then
				self._eventInstances["Phase 1: Sleepy"]:Stop(eventEntry)
			end
		end
	})

	self:RegisterEvent("Phase 2: Galaxy Introduction", {
		defaultDuration = 240,
		canStack = false,
		cooldown = 480,
		description = "Phase 2: Galaxy Introduction",
		onStart = function(eventEntry)
			if self._eventInstances["Phase 2: Galaxy Introduction"] and type(self._eventInstances["Phase 2: Galaxy Introduction"].Start) == "function" then
				self._eventInstances["Phase 2: Galaxy Introduction"]:Start(eventEntry)
			end
		end,
		onStop = function(eventEntry)
			if self._eventInstances["Phase 2: Galaxy Introduction"] and type(self._eventInstances["Phase 2: Galaxy Introduction"].Stop) == "function" then
				self._eventInstances["Phase 2: Galaxy Introduction"]:Stop(eventEntry)
			end
		end
	})

	self:RegisterEvent("Phase 3: Sammy's Base", {
		defaultDuration = 240,
		canStack = false,
		cooldown = 480,
		description = "Phase 3: Sammy's Base",
		onStart = function(eventEntry)
			if self._eventInstances["Phase3"] and type(self._eventInstances["Phase3"].Start) == "function" then
				self._eventInstances["Phase3"]:Start(eventEntry)
			end
		end,
		onStop = function(eventEntry)
			if self._eventInstances["Phase3"] and type(self._eventInstances["Phase3"].Stop) == "function" then
				self._eventInstances["Phase3"]:Stop(eventEntry)
			end
		end
	})

	self:RegisterEvent("Phase 4: Mygame43", {
		defaultDuration = 240,
		canStack = false,
		cooldown = 480,
		description = "Phase 4: Mygame43",
		onStart = function(eventEntry)
			if self._eventInstances["Phase 4: Mygame43"] and type(self._eventInstances["Phase 4: Mygame43"].Start) == "function" then
				self._eventInstances["Phase 4: Mygame43"]:Start(eventEntry)
			end
		end,
		onStop = function(eventEntry)
			if self._eventInstances["Phase 4: Mygame43"] and type(self._eventInstances["Phase 4: Mygame43"].Stop) == "function" then
				self._eventInstances["Phase 4: Mygame43"]:Stop(eventEntry)
			end
		end
	})

	self:RegisterEvent("Phase 5: Sammy Snap", {
		defaultDuration = 240,
		canStack = false,
		cooldown = 480,
		description = "Phase 5: Sammy Snap",
		onStart = function(eventEntry)
			if self._eventInstances["Phase5"] and type(self._eventInstances["Phase5"].Start) == "function" then
				self._eventInstances["Phase5"]:Start(eventEntry)
			end
		end,
		onStop = function(eventEntry)
			if self._eventInstances["Phase5"] and type(self._eventInstances["Phase5"].Stop) == "function" then
				self._eventInstances["Phase5"]:Stop(eventEntry)
			end
		end
	})

	self:RegisterEvent("Bubblegum", {
		defaultDuration = 240,
		canStack = false,
		cooldown = 480,
		description = "Bubblegum",
		onStart = function(eventEntry) safeWrapper("Bubblegum", "Start", eventEntry) end,
		onStop = function(eventEntry) safeWrapper("Bubblegum", "Stop", eventEntry) end,
	})

	self:RegisterEvent("UFO", {
		defaultDuration = 240,
		canStack = false,
		cooldown = 480,
		description = "ufos",
		onStart = function(eventEntry)
			if self._eventInstances["UFO"] and type(self._eventInstances["UFO"].Start) == "function" then
				self._eventInstances["UFO"]:Start(eventEntry)
			end
		end,
		onStop = function(eventEntry)
			if self._eventInstances["UFO"] and type(self._eventInstances["UFO"].Stop) == "function" then
				self._eventInstances["UFO"]:Stop(eventEntry)
			end
		end
	})

	self:RegisterEvent("Rain", {
		defaultDuration = 240,
		canStack = false,
		cooldown = 480,
		description = "im wet",
		onStart = function(eventEntry)
			if self._eventInstances["Rain"] and type(self._eventInstances["Rain"].Start) == "function" then
				self._eventInstances["Rain"]:Start(eventEntry)
			end
		end,
		onStop = function(eventEntry)
			if self._eventInstances["Rain"] and type(self._eventInstances["Rain"].Stop) == "function" then
				self._eventInstances["Rain"]:Stop(eventEntry)
			end
		end
	})

	self:RegisterEvent("Rap Concert", {
		defaultDuration = 240,
		canStack = false,
		cooldown = 480,
		description = "Rap Concert",
		onStart = function(eventEntry)
			if self._eventInstances["Rap Concert"] and type(self._eventInstances["Rap Concert"].Start) == "function" then
				self._eventInstances["Rap Concert"]:Start(eventEntry)
			end
		end,
		onStop = function(eventEntry)
			if self._eventInstances["Rap Concert"] and type(self._eventInstances["Rap Concert"].Stop) == "function" then
				self._eventInstances["Rap Concert"]:Stop(eventEntry)
			end
		end
	})

	self:RegisterEvent("Strawberry", {
		defaultDuration = 240,
		canStack = false,
		cooldown = 480,
		description = "Strawberry",
		onStart = function(eventEntry) safeWrapper("Strawberry", "Start", eventEntry) end,
		onStop = function(eventEntry) safeWrapper("Strawberry", "Stop", eventEntry) end,
	})

	self:RegisterEvent("Sammyni Spyderini", {
		defaultDuration = 240,
		canStack = false,
		cooldown = 480,
		description = "Sammyni Spyderini",
		onStart = function(eventEntry) safeWrapper("Sammyni Spyderini", "Start", eventEntry) end,
		onStop = function(eventEntry) safeWrapper("Sammyni Spyderini", "Stop", eventEntry) end,
	})

	-- ADDED: Chicleteira Bicicleteira registration (safe)
	self:RegisterEvent("Chicleteira Bicicleteira", {
		defaultDuration = 240,
		canStack = false,
		cooldown = 480,
		description = "Street painter sprays animals; applies the Paint trait.",
		onStart = function(eventEntry) safeWrapper("Chicleteira Bicicleteira", "Start", eventEntry) end,
		onStop  = function(eventEntry) safeWrapper("Chicleteira Bicicleteira", "Stop",  eventEntry) end,
	})
	self:RegisterEvent("Witching Hour", {
		defaultDuration = 240,
		canStack = false,
		cooldown = 480,
		description = "Spooky.",
		onStart = function(eventEntry) safeWrapper("Witching Hour", "Start", eventEntry) end,
		onStop  = function(eventEntry) safeWrapper("Witching Hour", "Stop",  eventEntry) end,
	})
	-- ADDED: Extinct registration (safe)
	self:RegisterEvent("Extinct", {
		defaultDuration = 240,
		canStack = false,
		cooldown = 480,
		description = "Extinct event: strikes animals and applies the Skeleton trait.",
		onStart = function(eventEntry) safeWrapper("Extinct", "Start", eventEntry) end,
		onStop  = function(eventEntry) safeWrapper("Extinct", "Stop",  eventEntry) end,
	})

	-- ADDED: FatSammy registration (safe)
	self:RegisterEvent("FatSammy", {
		defaultDuration = 240,
		canStack = false,
		cooldown = 480,
		description = "FatSammy event with special traits and effects",
		onStart = function(eventEntry) safeWrapper("FatSammy", "Start", eventEntry) end,
		onStop  = function(eventEntry) safeWrapper("FatSammy", "Stop", eventEntry) end,
	})

	-- ADDED: Indonesia registration (safe)
	self:RegisterEvent("Indonesia", {
		defaultDuration = 240,
		canStack = false,
		cooldown = 480,
		description = "Indonesia event with cultural-themed effects and traits",
		onStart = function(eventEntry)
			if self._eventInstances["Indonesia"] and type(self._eventInstances["Indonesia"].Start) == "function" then
				self._eventInstances["Indonesia"]:Start(eventEntry)
			end
		end,
		onStop = function(eventEntry)
			if self._eventInstances["Indonesia"] and type(self._eventInstances["Indonesia"].Stop) == "function" then
				self._eventInstances["Indonesia"]:Stop(eventEntry)
			end
		end
	})

	-- ADDED: Meowl registration (safe)
	self:RegisterEvent("Meowl", {
		defaultDuration = 240,
		canStack = false,
		cooldown = 480,
		description = "Meowl event with cultural-themed effects and traits",
		onStart = function(eventEntry)
			if self._eventInstances["Meowl"] and type(self._eventInstances["Meowl"].Start) == "function" then
				self._eventInstances["Meowl"]:Start(eventEntry)
			end
		end,
		onStop = function(eventEntry)
			if self._eventInstances["Meowl"] and type(self._eventInstances["Meowl"].Stop) == "function" then
				self._eventInstances["Meowl"]:Stop(eventEntry)
			end
		end
	})
end

function EventService:RegisterEvent(eventName, config)
	if not eventName or type(eventName) ~= "string" then
		warn("[EventService] RegisterEvent failed: invalid eventName")
		return false
	end

	local defaultConfig = {
		defaultDuration = 180,
		canStack = false,
		cooldown = 300,
		description = "No description provided",
		onStart = nil,
		onStop = nil
	}

	config = config or {}
	for key, value in pairs(defaultConfig) do
		if config[key] == nil then
			config[key] = value
		end
	end

	self._registeredEvents[eventName] = config
	return true
end

function EventService:StartEvent(eventName, duration, eventData)
	if not self._registeredEvents[eventName] then
		warn("[EventService] StartEvent failed: event not registered:", eventName)
		return false
	end

	local eventConfig = self._registeredEvents[eventName]
	if self._activeEvents[eventName] and not eventConfig.canStack then
		return false
	end

	duration = duration or eventConfig.defaultDuration
	local currentTime = workspace:GetServerTimeNow()

	local eventEntry = {
		eventName = eventName,
		startTime = currentTime,
		startedAt = currentTime,
		duration = duration,
		endsAt = currentTime + duration,
		data = eventData or {}
	}

	self._activeEvents[eventName] = eventEntry
	self._eventStartTimes[eventName] = currentTime
	self._eventDurations[eventName] = duration

	self._synchronizer:InsertOnArray("ActiveEvents", eventEntry)
	self:_scheduleEventStop(eventName, duration)

	if eventConfig.onStart and type(eventConfig.onStart) == "function" then
		local success, errorMsg = pcall(eventConfig.onStart, eventEntry)
		if not success then
			warn(string.format("[EventService] Error in onStart callback for '%s': %s", eventName, errorMsg))
		end
	end

	local notificationEvent = Net:RemoteEvent("NotificationService/Notify")
	for _, player in pairs(Players:GetPlayers()) do
		-- preserved original loop location (no-op by default)
	end

	return true
end

function EventService:StopEvent(eventName)
	if not self._activeEvents[eventName] then
		return false
	end

	local eventEntry = self._activeEvents[eventName]
	local eventConfig = self._registeredEvents[eventName]

	self._activeEvents[eventName] = nil
	self._eventStartTimes[eventName] = nil
	self._eventDurations[eventName] = nil

	if self._eventTimers[eventName] then
		local success, errorMsg = pcall(task.cancel, self._eventTimers[eventName])
		if not success then
			if not string.find(errorMsg, "cannot cancel thread") then
				warn(string.format("[EventService] Failed to cancel timer for '%s': %s", eventName, errorMsg))
			end
		end
		self._eventTimers[eventName] = nil
	end

	local currentEvents = self._synchronizer:Get("ActiveEvents") or {}
	local indexToRemove = nil
	for i, event in ipairs(currentEvents) do
		if event.eventName == eventName then
			indexToRemove = i
			break
		end
	end
	if indexToRemove then
		self._synchronizer:RemoveFromArray("ActiveEvents", indexToRemove)
	end

	if eventConfig and eventConfig.onStop and type(eventConfig.onStop) == "function" then
		local success, errorMsg = pcall(eventConfig.onStop, eventEntry)
		if not success then
			warn(string.format("[EventService] Error in onStop callback for '%s': %s", eventName, errorMsg))
		end
	end

	local notificationEvent = Net:RemoteEvent("NotificationService/Notify")
	for _, player in pairs(Players:GetPlayers()) do
		-- preserved original loop location (no-op by default)
	end

	return true
end

function EventService:_scheduleEventStop(eventName, duration)
	if self._eventTimers[eventName] then
		local success, errorMsg = pcall(task.cancel, self._eventTimers[eventName])
		if not success then
			warn(string.format("[EventService] Failed to cancel timer for '%s': %s", eventName, errorMsg))
		end
		self._eventTimers[eventName] = nil
	end

	self._eventTimers[eventName] = task.delay(duration, function()
		self._eventTimers[eventName] = nil
		self:StopEvent(eventName)
	end)
end

function EventService:IsEventActive(eventName)
	return self._activeEvents[eventName] ~= nil
end

function EventService:GetActiveEvents()
	local events = {}
	for name, event in pairs(self._activeEvents) do
		events[name] = {
			eventName = event.eventName,
			startTime = event.startTime,
			duration = event.duration,
			endTime = event.endsAt,
			timeRemaining = math.max(0, event.endsAt - workspace:GetServerTimeNow()),
			data = event.data
		}
	end
	return events
end

function EventService:GetEventInfo(eventName)
	if not self._registeredEvents[eventName] then
		return nil
	end

	local config = self._registeredEvents[eventName]
	local active = self._activeEvents[eventName]

	return {
		name = eventName,
		description = config.description,
		defaultDuration = config.defaultDuration,
		canStack = config.canStack,
		cooldown = config.cooldown,
		isActive = active ~= nil,
		activeData = active
	}
end

function EventService:GetAllRegisteredEvents()
	local events = {}
	for name, _ in pairs(self._registeredEvents) do
		events[name] = self:GetEventInfo(name)
	end
	return events
end

function EventService:StartRandomEvent()
	local availableEvents = {}
	for name, _ in pairs(self._registeredEvents) do
		if not self._activeEvents[name] then
			table.insert(availableEvents, name)
		end
	end

	if #availableEvents == 0 then
		return false
	end

	local randomIndex = math.random(1, #availableEvents)
	local selectedEvent = availableEvents[randomIndex]

	return self:StartEvent(selectedEvent)
end

function EventService:ForceStopAllEvents()
	local stoppedEvents = {}
	for eventName, _ in pairs(self._activeEvents) do
		if self:StopEvent(eventName) then
			table.insert(stoppedEvents, eventName)
		end
	end
	return stoppedEvents
end

function EventService:GetEventStatus()
	local status = {
		activeCount = 0,
		registeredCount = 0,
		activeEvents = {},
		registeredEvents = {}
	}

	for name, _ in pairs(self._activeEvents) do
		status.activeCount = status.activeCount + 1
		table.insert(status.activeEvents, name)
	end

	for name, _ in pairs(self._registeredEvents) do
		status.registeredCount = status.registeredCount + 1
		table.insert(status.registeredEvents, name)
	end

	return status
end

return EventService