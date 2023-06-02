local AddItem = require(game.ServerStorage.Modules.Functions.Items.AddItem)

local DebugItemAdderSystem = {
    Name = "DebugItemAdderSystem",
    Priority = "First",
    Tag = {
        "Character",
        "Inventory",
        "!DebugItemsAdded"
    }
}

function DebugItemAdderSystem:Update(TaggedEntities)
    for _, TaggedEntity in pairs(TaggedEntities) do
        TaggedEntity:AddComponent("DebugItemsAdded", true)
        self:ProcessUserEntity(TaggedEntity)
    end
end

function DebugItemAdderSystem:ProcessUserEntity(UserEntity)
    --if true then return end
    task.wait(1)

    local Player = UserEntity:Get("Player").Player
    if not Player:IsA("Player") then
        if Player.Name:find("Soli") then
            AddItem({
                UserEntity = UserEntity,
                Type = "Hotbar",
                ItemName = "Verge Ironbrand"
            })
        end
        return
    end

    AddItem({
        UserEntity = UserEntity,
        Type = "Hotbar",
        ItemName = "Wooden Bow"
    })

    AddItem({
        UserEntity = UserEntity,
        Type = "Hotbar",
        ItemName = "Rat Sword"
    })
end

return DebugItemAdderSystem