local Access = require(game.ReplicatedStorage.Modules.Recs.Access)
local Action = require(game.ServerStorage.Modules.Functions.ActionMethod)
local YieldUntilActionFinished = require(game.ServerStorage.Modules.Functions.YieldUntilActionFinished)
local Workshop = Access.GetWorkshop()

return function(Data)
    -- equips an item from the hotbar
    local UserEntity = Data.UserEntity
    local HotbarIndex = Data.HotbarIndex

    local Inventory = UserEntity:Get("Inventory")
    local Hotbar = Inventory.Hotbar

    local Item = Hotbar[HotbarIndex]

    if not Item then
        return
    end

    Inventory.Equipped = HotbarIndex

    local Character = UserEntity:Get("Character").Character
    Action(Item.Name, "Equipped", Character)

    task.delay(0.15, function()
        --local RunClient = Workshop:CreateEntity()
        --:AddComponent("RunClient", {
        --    Call = "UpdateEquipped",
        --    Arguments = {
        --        Equipped = HotbarIndex
        --    },
        --    Target = UserEntity:Get("Player").Player
        --})
        --Workshop:SpawnEntity(RunClient)
        local ReplicationEntity = Workshop:CreateEntity()
        :AddComponent("RunClient", {
            Call = "UpdateInventory",
            Arguments = Inventory,
            Target = UserEntity:Get("Player").Player
        })
        Workshop:SpawnEntity(ReplicationEntity)
    end)
end