--[[
  Location: ServerScriptService.Services.BaseService
  Class: ModuleScript
]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local HttpService = game:GetService("HttpService")

local Net = require(ReplicatedStorage.Packages.Net)
local BaseConfig = require(ReplicatedStorage:WaitForChild("BaseConfig"))
local DataManagment = require(ServerScriptService.Services.DataManagment)
local PlayersService = require(ServerScriptService.Services.Players)

local BaseService = {}
BaseService.__index = BaseService

function BaseService.new()
        local self = setmetatable({}, BaseService)

        self._bases = {}
        self._requestUpgrade = Net:RemoteFunction("BaseService/RequestBaseUpgrade")
        self._requestPodAssignment = Net:RemoteEvent("BaseService/RequestPodAssignment")
        self._podAssignmentResult = Net:RemoteEvent("BaseService/PodAssignmentResult")
        self._baseStateUpdate = Net:RemoteEvent("BaseService/BaseStateUpdate")
        self._requestBaseState = Net:RemoteFunction("BaseService/RequestBaseState")

        self:_setupRemotes()

        return self
end

function BaseService:Start()
        for _, player in ipairs(Players:GetPlayers()) do
                task.spawn(function()
                        self:_initializePlayer(player)
                end)
        end

        Players.PlayerAdded:Connect(function(player)
                self:_initializePlayer(player)
        end)

        Players.PlayerRemoving:Connect(function(player)
                local baseContainer = self._bases[player]
                if baseContainer and baseContainer.Parent then
                        baseContainer:Destroy()
                end
                self._bases[player] = nil
        end)
end

function BaseService:_setupRemotes()
        self._requestBaseState.OnServerInvoke = function(player)
                local state = self:_ensureBaseState(player)
                return self:_copyState(state)
        end

        self._requestUpgrade.OnServerInvoke = function(player, targetPod)
                return self:_handleUpgradeRequest(player, targetPod)
        end

        self._requestPodAssignment.OnServerEvent:Connect(function(player, podIndex, assignmentData)
                self:_handlePodAssignment(player, podIndex, assignmentData)
        end)
end

function BaseService:_initializePlayer(player)
        if not DataManagment.isDataReady(player) then
                local success = DataManagment.waitForData(player, 30)
                if not success then
                        return
                end
        end

        local synchronizer = PlayersService.waitForSynchronizer(player, 30)
        if not synchronizer then
                return
        end

        local baseState = self:_ensureBaseState(player)
        self:_prepareBaseModel(player, baseState)
        self:_syncBaseState(player, baseState)
end

function BaseService:_ensureBaseState(player)
        local state = DataManagment.GetBaseState(player)
        state.UnlockedPods = math.clamp(state.UnlockedPods or BaseConfig.InitialUnlockedPods, BaseConfig.InitialUnlockedPods, BaseConfig.MaxUnlockablePod)
        state.AssignedPods = state.AssignedPods or {}
        state.Upgrades = state.Upgrades or {}
        return state
end

function BaseService:_copyState(state)
        if typeof(state) ~= "table" then
                return BaseConfig.createDefaultState()
        end

        local cloned = {}
        for key, value in pairs(state) do
                if typeof(value) == "table" then
                        cloned[key] = self:_copyState(value)
                else
                        cloned[key] = value
                end
        end
        return cloned
end

function BaseService:_syncBaseState(player, state)
        local synchronizer = PlayersService.getSynchronizer(player) or PlayersService.waitForSynchronizer(player, 5)
        if synchronizer then
                synchronizer:Set("BaseState", self:_copyState(state))
                synchronizer:Set("Gelatin", DataManagment.GetGelatin(player))
                synchronizer:Set("Essences", DataManagment.GetEssences(player))
        end

        self._baseStateUpdate:FireClient(player, self:_copyState(state))
end

function BaseService:_getBasesFolder()
        local folder = Workspace:FindFirstChild(BaseConfig.BaseFolderName)
        if not folder then
                folder = Instance.new("Folder")
                folder.Name = BaseConfig.BaseFolderName
                folder.Parent = Workspace
        end
        return folder
end

function BaseService:_prepareBaseModel(player, baseState)
        local basesFolder = self:_getBasesFolder()
        local baseContainer = basesFolder:FindFirstChild(player.Name)
        if not baseContainer then
                baseContainer = Instance.new("Folder")
                baseContainer.Name = player.Name
                baseContainer.Parent = basesFolder
        end

        baseContainer:SetAttribute("UnlockedPods", baseState.UnlockedPods or BaseConfig.InitialUnlockedPods)

        for podIndex = 1, BaseConfig.MaximumPods do
                local podName = string.format(BaseConfig.PodNameFormat, podIndex)
                local podFolder = baseContainer:FindFirstChild(podName)
                if not podFolder then
                        podFolder = Instance.new("Folder")
                        podFolder.Name = podName
                        podFolder.Parent = baseContainer
                end

                local position = BaseConfig.getPodPosition(podIndex)
                if position then
                        podFolder:SetAttribute("Position", position)
                end

                local isFuture = BaseConfig.isFuturePod(podIndex)
                local isUnlocked = not isFuture and podIndex <= (baseState.UnlockedPods or BaseConfig.InitialUnlockedPods)

                podFolder:SetAttribute("Unlocked", isUnlocked)
                podFolder:SetAttribute("Locked", not isUnlocked)
                podFolder:SetAttribute("IsFuture", isFuture)

                local gelatinCost, essenceCost = BaseConfig.getUpgradeCost(podIndex)
                podFolder:SetAttribute("GelatinCost", gelatinCost or 0)
                podFolder:SetAttribute("EssenceCost", essenceCost or 0)

                local assignment = baseState.AssignedPods and baseState.AssignedPods[podIndex] or nil
                self:_applyAssignmentAttributes(podFolder, assignment)
        end

        self._bases[player] = baseContainer
end

function BaseService:_applyAssignmentAttributes(podFolder, assignment)
        local hasAssignment = assignment ~= nil
        podFolder:SetAttribute("Assigned", hasAssignment)

        if typeof(assignment) == "table" then
                local success, encoded = pcall(HttpService.JSONEncode, HttpService, assignment)
                if success then
                        podFolder:SetAttribute("AssignmentData", encoded)
                else
                        podFolder:SetAttribute("AssignmentData", nil)
                end
        elseif assignment ~= nil then
                podFolder:SetAttribute("AssignmentData", tostring(assignment))
        else
                podFolder:SetAttribute("AssignmentData", nil)
        end
end

function BaseService:_handleUpgradeRequest(player, targetPod)
        if typeof(targetPod) ~= "number" then
                return {
                        success = false,
                        message = "Pod invalide",
                        baseState = self:_copyState(self:_ensureBaseState(player)),
                }
        end

        targetPod = math.floor(targetPod)
        local state = self:_ensureBaseState(player)
        local currentUnlocked = state.UnlockedPods or BaseConfig.InitialUnlockedPods

        if targetPod <= currentUnlocked then
                return {
                        success = false,
                        message = "Pod déjà débloqué",
                        baseState = self:_copyState(state),
                }
        end

        if BaseConfig.isFuturePod(targetPod) or targetPod > BaseConfig.MaxUnlockablePod then
                return {
                        success = false,
                        message = "Ce pod est verrouillé pour une mise à jour future",
                        baseState = self:_copyState(state),
                }
        end

        if targetPod > currentUnlocked + 1 then
                return {
                        success = false,
                        message = "Veuillez débloquer les pods dans l'ordre",
                        baseState = self:_copyState(state),
                }
        end

        local gelatinCost, essenceCost = BaseConfig.getUpgradeCost(targetPod)
        gelatinCost = gelatinCost or 0
        essenceCost = essenceCost or 0

        if DataManagment.GetGelatin(player) < gelatinCost then
                return {
                        success = false,
                        message = "Pas assez de gélatine",
                        baseState = self:_copyState(state),
                }
        end

        if DataManagment.GetEssences(player) < essenceCost then
                return {
                        success = false,
                        message = "Pas assez d'essences",
                        baseState = self:_copyState(state),
                }
        end

        local gelatinDeducted = DataManagment.deductGelatin(player, gelatinCost)
        if not gelatinDeducted then
                return {
                        success = false,
                        message = "Impossible de débiter la gélatine",
                        baseState = self:_copyState(state),
                }
        end

        local essencesDeducted = true
        if essenceCost > 0 then
                essencesDeducted = DataManagment.deductEssences(player, essenceCost)
        end

        if not essencesDeducted then
                DataManagment.addGelatin(player, gelatinCost)
                return {
                        success = false,
                        message = "Impossible de débiter les essences",
                        baseState = self:_copyState(state),
                }
        end

        local updateSuccess = DataManagment.UpdateBaseState(player, function(baseState)
                baseState.UnlockedPods = math.max(baseState.UnlockedPods or BaseConfig.InitialUnlockedPods, targetPod)
        end)

        if not updateSuccess then
                DataManagment.addGelatin(player, gelatinCost)
                if essenceCost > 0 then
                        DataManagment.addEssences(player, essenceCost)
                end
                return {
                        success = false,
                        message = "La mise à jour de la base a échoué",
                        baseState = self:_copyState(state),
                }
        end

        local updatedState = self:_ensureBaseState(player)
        self:_prepareBaseModel(player, updatedState)
        self:_syncBaseState(player, updatedState)

        return {
                success = true,
                unlockedPod = targetPod,
                baseState = self:_copyState(updatedState),
                gelatin = DataManagment.GetGelatin(player),
                essences = DataManagment.GetEssences(player),
        }
end

local function isPrimitive(value)
        local valueType = typeof(value)
        return valueType == "string" or valueType == "number" or valueType == "boolean"
end

function BaseService:_sanitizeAssignment(assignment)
        if assignment == nil then
                return nil
        end

        local assignmentType = typeof(assignment)
        if assignmentType == "string" or assignmentType == "number" then
                return assignment
        end

        if assignmentType == "boolean" then
                return assignment
        end

        if assignmentType == "table" then
                local cleaned = {}
                local count = 0
                for key, value in pairs(assignment) do
                        if count >= 16 then
                                break
                        end
                        if typeof(key) == "string" and #key <= 32 and isPrimitive(value) then
                                cleaned[key] = value
                                count = count + 1
                        end
                end
                return cleaned
        end

        return nil
end

function BaseService:_handlePodAssignment(player, podIndex, assignmentData)
        if typeof(podIndex) ~= "number" then
                self:_sendPodAssignmentResult(player, false, "Pod invalide")
                return
        end

        podIndex = math.floor(podIndex)
        local state = self:_ensureBaseState(player)

        if podIndex < 1 or podIndex > BaseConfig.MaximumPods then
                self:_sendPodAssignmentResult(player, false, "Index de pod invalide")
                return
        end

        if BaseConfig.isFuturePod(podIndex) then
                self:_sendPodAssignmentResult(player, false, "Ce pod est verrouillé")
                return
        end

        if podIndex > (state.UnlockedPods or BaseConfig.InitialUnlockedPods) then
                self:_sendPodAssignmentResult(player, false, "Ce pod n'est pas encore débloqué")
                return
        end

        local sanitizedAssignment = self:_sanitizeAssignment(assignmentData)
        if assignmentData ~= nil and sanitizedAssignment == nil then
                self:_sendPodAssignmentResult(player, false, "Données d'assignation invalides")
                return
        end

        local updateSuccess = DataManagment.UpdateBaseState(player, function(baseState)
                baseState.AssignedPods[podIndex] = sanitizedAssignment
        end)

        if not updateSuccess then
                self:_sendPodAssignmentResult(player, false, "Impossible d'appliquer la modification")
                return
        end

        local updatedState = self:_ensureBaseState(player)
        self:_prepareBaseModel(player, updatedState)
        self:_syncBaseState(player, updatedState)

        local basesFolder = self._bases[player]
        if basesFolder then
                local podName = string.format(BaseConfig.PodNameFormat, podIndex)
                local podFolder = basesFolder:FindFirstChild(podName)
                if podFolder then
                        self:_applyAssignmentAttributes(podFolder, sanitizedAssignment)
                end
        end

        self:_sendPodAssignmentResult(player, true, nil, podIndex, sanitizedAssignment)
end

function BaseService:_sendPodAssignmentResult(player, success, message, podIndex, assignment)
        self._podAssignmentResult:FireClient(player, {
                success = success,
                message = message,
                podIndex = podIndex,
                assignment = assignment,
        })
end

return BaseService
