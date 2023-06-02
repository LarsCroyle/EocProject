local Action = require(game.ServerStorage.Modules.Functions.ActionMethod)
local Access = require(game.ReplicatedStorage.Modules.Recs.Access)
local Workshop = Access.GetWorkshop()

return function(Data)
    local UserEntity = Data.UserEntity
    local HotbarIndex = Data.HotbarIndex

    local Inventory = UserEntity:Get("Inventory")
    local Hotbar = Inventory.Hotbar

    local Item = Hotbar[HotbarIndex]

    if not Item then
        return
    end

    if Item.Name == "None" then
        return
    end

    local Character = UserEntity:Get("Character").Character
    Action(Item.Name, "Unequipped", Character)

    Inventory.Equipped = -1

    local ReplicationEntity = Workshop:CreateEntity()
    :AddComponent("RunClient", {
        Call = "UpdateInventory",
        Arguments = Inventory,
        Target = UserEntity:Get("Player").Player
    })
    Workshop:SpawnEntity(ReplicationEntity)

    --local RunClient = Workshop:CreateEntity()
    --:AddComponent("RunClient", {
    --    Call = "UpdateEquipped",
    --    Arguments = {
    --        Equipped = -1
    --    },
    --    Target = UserEntity:Get("Player").Player
    --})
    --Workshop:SpawnEntity(RunClient)
end