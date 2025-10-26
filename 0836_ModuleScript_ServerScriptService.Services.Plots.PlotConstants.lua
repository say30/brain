--[[
  Extracted from: ServerScriptService.Services.Plots.PlotConstants
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local PlotConstants = {}

PlotConstants.TIMING = {
	DEFAULT_LOCK_TIME = 60,
	DELAY_TIME = 1,
	DATA_WAIT_TIMEOUT = 30,
	DELIVERY_DEBOUNCE = 2,
	STEAL_NOTIFICATION_COOLDOWN = 3,
}

PlotConstants.REMOTES = {
	STEAL_ANIMAL = "280b459b-b3c8-424e-9b0b-821d4a4dec11",
	DELIVERY_HANDLER = "dfdd4236-1fac-4b9a-9f67-fec68d72c151", 
	ANIMAL_PROMPT = "d8766412-71ac-42fc-9bb2-00d0b4a9b85e",
}

PlotConstants.STATES = {
	EMPTY = "Empty",
	OWNER = "Owner",
	STEAL = "Steal",
	STEALING = "Stealing",
}

PlotConstants.TIERING = {
	MAX_REBIRTHS = 13,
}

PlotConstants.FLOOR_KEYS = {
	[1] = "BlockEndTimeFirstFloor",
	[2] = "BlockEndTimeSecondFloor", 
	[3] = "BlockEndTimeThirdFloor",
}

PlotConstants.SECURITY = {
	TIMESTAMP_TOLERANCE = 5,
	TIMESTAMP_OFFSET = 185,
}

PlotConstants.VISUAL = {
	TRANSPARENCY_STEALING = 0.5,
	SPAWN_WAIT_TIME = 0.1,
}

PlotConstants.ERRORS = {
	DATA_NOT_READY = "Player data not ready",
	PLOT_NOT_FOUND = "Plot not found", 
	NO_AVAILABLE_PLOTS = "No available plots",
	INVALID_ANIMAL_DATA = "Invalid animal data",
	BASE_FULL = "Your base is full! Cannot steal more animals.",
	ALREADY_STEALING = "You're already stealing an animal! Deliver it first",
	BEING_STOLEN = "is already being stolen by",
	BASE_LOCKED = "Your base is already locked!",
}

PlotConstants.SUCCESS = {
	ANIMAL_STOLEN = "You stole",
	FRIENDS_TOGGLED = "Friends access toggled",
	REBIRTH_SUCCESS = "Successfully rebirthed to level",
}

return PlotConstants