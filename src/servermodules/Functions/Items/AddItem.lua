local Access = require(game.ReplicatedStorage.Modules.Recs.Access)
local Workshop = Access.GetWorkshop()
local Action = require(game.ServerStorage.Modules.Functions.ActionMethod)
local ActionDictionary = require(game.ServerStorage.Modules.ActionDictionary)
local RunClient = require(game.ServerStorage.Modules.Functions.RunClient)
local TableUtil = require(game.ReplicatedStorage.Modules.Packages.TableUtil)

return function(Data)
    local UserEntity = Data.UserEntity
    local Type = Data.Type
    local ItemName = Data.ItemName
    local Index = Data.Index

    local Quantity = Data.Quantity or 1
    local Properties = Data.Properties or {
        Mastery = 0,
        MaximumMastery = 10
    }

    local Inventory = UserEntity:Get("Inventory")

    if not Quantity then
        Quantity = 1
    end

    local function GetIndex()
        local Group = Inventory[Type]
        for Index, Item in pairs(Group) do
            if Item.Name == ItemName and Item.Name ~= "None" then
                if Item.Quantity == Item.MaxQuantity then
                    continue
                end

                return Index
            end
            if Item.Name == "None" then
                return Index
            end
        end
        return
    end

    local function MakeItem()
        local ActionData = ActionDictionary.GetActionDataSet(ItemName)
        local Config = ActionData.Config

        local Item = TableUtil.Copy(Config)
        Item.Name = ItemName
        Item.Quantity = Quantity
        Item.Properties = Properties

        return Item
    end

    if Type == "Inventory" then -- first attempt to add to hotbar, then attempt to add to items
        Type = "Hotbar"
        Index = GetIndex()

        if not Index then
            Type = "Items"
            Index = GetIndex()

            if not Index then
                return
            end
        end
    end

    if not Index then
        Index = GetIndex()
    end

    if not Index then
        return
    end

    local Item = Inventory[Type][Index]

    if not Item or Item.Name == "None" then
        Inventory[Type][Index] = MakeItem()

        if Type ~= "ChestItems" then
            local Character = UserEntity:Get("Character").Character
            Action(ItemName, "Added", Character)
        end
    else
        if Item.MaxQuantity then
            if Item.Quantity == Item.MaxQuantity then
                return
            end
            if Item.Quantity + Quantity > Item.MaxQuantity then
                local DroppedQuantity = Item.Quantity + Quantity - Item.MaxQuantity
                Item.Quantity = Item.MaxQuantity

                return DroppedQuantity -- will be how much was not able to stack, if any, and will be dropped
            end
        end
        Item.Quantity = Item.Quantity + Quantity
    end

    local ReplicationEntity = Workshop:CreateEntity()
    :AddComponent("RunClient", {
        Call = "UpdateInventory",
        Arguments = Inventory,
        Target = UserEntity:Get("Player").Player
    })
    Workshop:SpawnEntity(ReplicationEntity)
end