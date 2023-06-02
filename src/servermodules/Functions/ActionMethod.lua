local ActionDictionary = require(game.ServerStorage.Modules.ActionDictionary)
local Access = require(game.ReplicatedStorage.Modules.Recs.Access)
local TableUtil = require(game.ReplicatedStorage.Modules.Packages.TableUtil)

return function(ActionSet: string, ActionName: string, Character: Model)
    local Workshop = Access.GetWorkshop()
    local ActionData = ActionDictionary.GetActionDataSet(ActionSet)

    if not ActionData then
        return
    end

    local Action = ActionData.Actions[ActionName]
    local UserEntity = Workshop:GetEntity(Character.Name .. "UserEntity")

    if not Action then
        return
    end

    if Action.From then
        local From = Action.From
        local FromActionSet, FromActionName = string.split(From, ".")[1], string.split(From, ".")[2]

        local FromActionData = ActionDictionary.GetActionDataSet(FromActionSet)
        local FromAction = FromActionData.Actions[FromActionName]

        --ActionSet = TableUtil.Reconcile(ActionSet, FromActionSet)
        Action = TableUtil.Reconcile(Action, FromAction)
    end

    if not UserEntity then
        return
    end

    if Action then
        if not UserEntity:Get(ActionName .. "Cooldown") and not UserEntity:Get("ActionInProgress") and not UserEntity:Get("ActionSequence") then
            local ActionEntity = Workshop:CreateEntity()
            :AddComponent("Action", {
                UserEntity = UserEntity,
                Name = ActionName,
                Action = Action.Action,
                ActionDataSetName = ActionSet,
                Speed = Action.Speed,
                ActionInformation = Action.ActionInformation
            })
            :AddComponent("Character", Character)

            Workshop:SpawnEntity(ActionEntity)
        end
    end
end