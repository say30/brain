--[[
  Extracted from: ServerScriptService.Main.Server.ServicesManager
  Class: Script
  Source file: rickdev.rbxlx
]]

local Services = game:GetService("ServerScriptService").Services

local ServicesList = {
        Road = Services.RoadAnimalService,
        LikeService = Services.LikeService,
        BaseService = Services.BaseService,
        EventService = Services.EventService,
        SoftShutdownService = Services.SoftShutdownService,

        require(Services.AdminPanelService)
}

local Module = require(ServicesList.Road)
local RoadAnimalService = Module.new()
RoadAnimalService:Start()
_G.RoadAnimalService = RoadAnimalService

local LikeService = require(ServicesList.LikeService)
LikeService:Start()

local BaseServiceModule = require(ServicesList.BaseService)
local BaseService = BaseServiceModule.new()
BaseService:Start()
_G.BaseService = BaseService

local EventService = require(ServicesList.EventService)
_G.EventService = EventService.new()

local SoftShutdownServiceModule = require(ServicesList.SoftShutdownService)
local SoftShutdownService = SoftShutdownServiceModule.new()
SoftShutdownService:Start()