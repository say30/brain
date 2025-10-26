--[[
  Extracted from: ServerScriptService.Services.RoadAnimalService.Configuration.RoadAnimalConfig
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

local RoadAnimalConfig = {
	SPAWN_SETTINGS = {
		MAX_ANIMALS_ON_ROAD = 50,
		SPAWN_COOLDOWN = require(game.ReplicatedStorage.Datas.Game).RoadSpawn.SpawnEvery,
		PITY_TIMERS = require(game.ReplicatedStorage.Datas.Game).RoadSpawn.PittyList,
		DESPAWN_DISTANCE = 100,
	},

	MOVEMENT_SETTINGS = {
		BASE_SPEED = require(game.ReplicatedStorage.Datas.Game).RoadSpawn.AnimalSpeed,
		SPEED_VARIANCE = 0.3,
		STUCK_TIMEOUT = 5,
		CLEANUP_DELAY = 2,
	},

	ROAD_SETTINGS = {
		WAYPOINT_SPACING = 8,
		AGENT_RADIUS = 2,
		AGENT_HEIGHT = 5,
	},

	INTERACTION_SETTINGS = {
		PROMPT_HOLD_DURATION = 0.5,
		PROMPT_DISTANCE = 10,
	},

	PURCHASE_SETTINGS = {
		NOTIFICATION_DURATION = 3,
	},

	PERFORMANCE = {
		UPDATE_FREQUENCY = 30,
		CLEANUP_INTERVAL = 30,
		MAX_PATH_RETRIES = 3,
		BATCH_SIZE = 5,
		MAX_CONCURRENT_SPAWNS = 3,
	},

	DEBUG = {
		ENABLED = false,
		VISUALIZE_PATHS = false,
		PRINT_SPAWN_INFO = false,
		PRINT_MOVEMENT_INFO = false,
		PRINT_INTERACTION_INFO = false,
		PRINT_PURCHASE_INFO = false,
		SHOW_PERFORMANCE_STATS = false,
	},
}

return RoadAnimalConfig 