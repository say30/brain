--[[
  Location: ReplicatedStorage.BaseConfig
  Class: ModuleScript
]]

local BaseConfig = {}

BaseConfig.InitialUnlockedPods = 10
BaseConfig.MaxUnlockablePod = 22
BaseConfig.FuturePods = {23, 24}
BaseConfig.MaximumPods = BaseConfig.MaxUnlockablePod + #BaseConfig.FuturePods
BaseConfig.BaseFolderName = "PlayerBases"
BaseConfig.PodNameFormat = "Pod_%02d"

local podPositions = {}
local unlockableRadius = 28
for index = 1, BaseConfig.MaxUnlockablePod do
        local angle = (index - 1) * (math.pi * 2 / BaseConfig.MaxUnlockablePod)
        podPositions[index] = CFrame.new(
                math.cos(angle) * unlockableRadius,
                0,
                math.sin(angle) * unlockableRadius
        )
end

local futureRadius = unlockableRadius + 18
for offset = 1, #BaseConfig.FuturePods do
        local podIndex = BaseConfig.MaxUnlockablePod + offset
        local angle = (offset - 1) * (math.pi / math.max(1, #BaseConfig.FuturePods - 1))
        podPositions[podIndex] = CFrame.new(
                math.cos(angle) * futureRadius,
                0,
                math.sin(angle) * futureRadius
        )
end

BaseConfig.PodPositions = podPositions

BaseConfig.UpgradeBands = {
        {
                minimum = 11,
                maximum = 12,
                gelatinCost = 5000,
                essenceCost = 0,
        },
        {
                minimum = 13,
                maximum = 16,
                gelatinCost = 12500,
                essenceCost = 10,
        },
        {
                minimum = 17,
                maximum = 22,
                gelatinCost = 30000,
                essenceCost = 40,
        },
}

local function copyTable(original)
        local result = {}
        for key, value in pairs(original) do
                if typeof(value) == "table" then
                        result[key] = copyTable(value)
                else
                        result[key] = value
                end
        end
        return result
end

local function formatNumber(value)
        local str = tostring(math.floor(value or 0))
        local integer, fraction = str:match("^(%-?%d+)(%.%d+)?$")
        integer = integer or str
        fraction = fraction or ""
        local formatted = integer
        local separator = "\226\128\137"
        while true do
                local newFormatted, replacements = formatted:gsub("^(%-?%d+)(%d%d%d)", "%1" .. separator .. "%2")
                formatted = newFormatted
                if replacements == 0 then
                        break
                end
        end
        return formatted .. fraction
end

function BaseConfig.getUpgradeBand(podIndex: number)
        for _, band in ipairs(BaseConfig.UpgradeBands) do
                if podIndex >= band.minimum and podIndex <= band.maximum then
                        return band
                end
        end
        return nil
end

function BaseConfig.getUpgradeCost(podIndex: number)
        local band = BaseConfig.getUpgradeBand(podIndex)
        if not band then
                return nil, nil
        end
        return band.gelatinCost, band.essenceCost
end

function BaseConfig.isFuturePod(podIndex: number)
        for _, value in ipairs(BaseConfig.FuturePods) do
                if value == podIndex then
                        return true
                end
        end
        return false
end

function BaseConfig.getPodCFrame(podIndex: number)
        return BaseConfig.PodPositions[podIndex]
end

function BaseConfig.getPodPosition(podIndex: number)
        local cframe = BaseConfig.getPodCFrame(podIndex)
        if cframe then
                return cframe.Position
        end
        return nil
end

function BaseConfig.createDefaultState()
        return {
                UnlockedPods = BaseConfig.InitialUnlockedPods,
                AssignedPods = {},
                Upgrades = {},
        }
end

function BaseConfig.copyState(state)
        if typeof(state) ~= "table" then
                return BaseConfig.createDefaultState()
        end
        return copyTable(state)
end

function BaseConfig.getFormattedCost(podIndex: number)
        if BaseConfig.isFuturePod(podIndex) then
                return "Bientôt disponible"
        end
        local gelatinCost, essenceCost = BaseConfig.getUpgradeCost(podIndex)
        if not gelatinCost and not essenceCost then
                return "Indisponible"
        end

        local parts = {}
        if gelatinCost and gelatinCost > 0 then
                table.insert(parts, string.format("%s gélatine", formatNumber(gelatinCost)))
        end
        if essenceCost and essenceCost > 0 then
                table.insert(parts, string.format("%d essences", essenceCost))
        end
        if #parts == 0 then
                return "Gratuit"
        end
        return table.concat(parts, " + ")
end

function BaseConfig.getHighestUnlockablePod()
        return BaseConfig.MaxUnlockablePod
end

return BaseConfig
