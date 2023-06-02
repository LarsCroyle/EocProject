local AddItem = require(game.ServerStorage.Modules.Functions.Items.AddItem)

local InventoryBuilderSystem = {
    Name = "InventoryBuilderSystem",
    Priority = "Update",
    Tag = {
        "SaveData",
        --"Character",
        "!Inventory"
    }
}

function InventoryBuilderSystem:Update(TaggedEntities)
    for _, EntityObject in pairs(TaggedEntities) do
        self:ProcessUserEntity(EntityObject)
    end
end

function InventoryBuilderSystem:ProcessUserEntity(UserEntity)
    local SaveData = UserEntity:Get("SaveData").SaveData
    local Inventory = SaveData.Inventory

    --if Inventory and (#Inventory.Items > 0 or #Inventory.Hotbar > 0 or Inventory.Equipped) then
    --    UserEntity:AddComponent("Inventory", Inventory)
--
    --    local Items = UserEntity:Get("Inventory").Items
--
    --    for _, Item in pairs(Items) do
    --        AddItem({
    --            UserEntity = UserEntity,
    --            Type = "Items",
    --            ItemName = Item
    --        })
    --    end
--
    --    local Hotbar = UserEntity:Get("Inventory").Hotbar
--
    --    for _, Item in pairs(Hotbar) do
    --        AddItem({
    --            UserEntity = UserEntity,
    --            Type = "Hotbar",
    --            ItemName = Item
    --        })
    --    end
--
    --    return
    --end
    UserEntity:AddComponent("Inventory", {
        Items = table.create(50, {Name = "None", Quantity = 0}),
        Hotbar = table.create(10, {Name = "None", Quantity = 0}),
        ChestItems = table.create(10, {Name = "None", Quantity = 0}),
        Equipped = -1,
        Armor = {
            Head = "None",
            Torso = "None",
            Legs = "None",
            Arms = "None"
        }
    })
end

return InventoryBuilderSystem