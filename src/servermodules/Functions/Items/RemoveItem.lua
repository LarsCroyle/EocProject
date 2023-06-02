local Access = require(game.ReplicatedStorage.Modules.Recs.Access)
local Workshop = Access.GetWorkshop()
local Action = require(game.ServerStorage.Modules.Functions.ActionMethod)

return function(Data)
    local UserEntity = Data.UserEntity
    local Type = Data.Type

    local Inventory = UserEntity:Get("Inventory")
    local Items = Inventory.Items
    local Hotbar = Inventory.Hotbar

    local function RemoveFromItems()
        local Item = Items[Data.ItemName]

        if not Item then
            return
        end

        if Item.Quantity > 1 then
            Item.Quantity = Item.Quantity - 1
        else
            Items[Data.ItemName] = nil
        end
    end

    local function RemoveFromHotbar()
        local Item = Hotbar[Data.HotbarIndex]

        if not Item then
            return
        end

        if Item.Quantity > 1 then
            Item.Quantity = Item.Quantity - 1
        else
            Hotbar[Data.HotbarIndex] = nil
        end

        local Character = UserEntity:Get("Character").Character
        Action(Item.Name, "Removed", Character)
    end

    if Type == nil or Type == "Items" then
        RemoveFromItems()

        local ReplicationEntity = Workshop:CreateEntity()
        :AddComponent("RunClient", {
            Call = "UpdateInventory",
            Arguments = Inventory,
            Target = UserEntity:Get("Player").Player
        })
        Workshop:SpawnEntity(ReplicationEntity)

        --local ReplicationEntity = Workshop:CreateEntity()
        --:AddComponent("RunClient", {
        --    Call = "UpdateItems",
        --    Arguments = {
        --        Items = Items
        --    },
        --    Target = UserEntity:Get("Player").Player
        --})
        --Workshop:SpawnEntity(ReplicationEntity)
    elseif Type == "Hotbar" then
        RemoveFromHotbar()

        local ReplicationEntity = Workshop:CreateEntity()
        :AddComponent("RunClient", {
            Call = "UpdateInventory",
            Arguments = Inventory,
            Target = UserEntity:Get("Player").Player
        })
        Workshop:SpawnEntity(ReplicationEntity)
        --local ReplicationEntity = Workshop:CreateEntity()
        --:AddComponent("RunClient", {
        --    Call = "UpdateHotbar",
        --    Arguments = {
        --        Hotbar = Hotbar
        --    },
        --    Target = UserEntity:Get("Player").Player
        --})
        --Workshop:SpawnEntity(ReplicationEntity)
    end
end