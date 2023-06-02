local Fusion = require(game.ReplicatedStorage.Modules.Packages.Fusion)
local Value = Fusion.Value

local HydratedValues = {}

local InventoryReplicatorSystem = {
    Name = "InventoryReplicatorSystem",
    Priority = "Update",
    Tag = {
        "Character",
        "Inventory"
    }
}

-- system that performs hydration on UI elements and replicates inventory data from ECS onto UI

function InventoryReplicatorSystem:Update(TaggedEntities)
    for _, TaggedEntity in pairs(TaggedEntities) do
        self:ProcessUserEntity(TaggedEntity)
    end
end

function InventoryReplicatorSystem:ProcessUserEntity(UserEntity)
    local Inventory = UserEntity:Get("Inventory")
    for Key, Value in pairs(HydratedValues) do
        if Inventory[Key] ~= nil then
            Value:set(Inventory[Key])
        end
    end
end

function InventoryReplicatorSystem:Boot()
    local Hotbar = require(game.ReplicatedStorage.Modules.Fusion.Components.Hotbar)
    local Menu = require(game.ReplicatedStorage.Modules.Fusion.Components.Menu)

    HydratedValues = {
        ["Hotbar"] = Value(table.create(10, {Name = "None"})),
        ["Items"] = Value(table.create(30, {Name = "None"})),
        ["ChestItems"] = Value(table.create(10, {Name = "None"})),
        ["Equipped"] = Value(-1),
        ["MenuOpen"] = Value(false),
        ["ChestOpen"] = Value(false)
    }

    Hotbar(HydratedValues)
    Menu(HydratedValues)
end

return InventoryReplicatorSystem