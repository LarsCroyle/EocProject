local Action = require(game.ServerStorage.Modules.Functions.ActionMethod)

local InputActionSystem = {
    Name = "InputActionSystem",
    Priority = "Update",
    Tag = {
        "Character",
        "Input",
        "Inventory"
    }
}

function InputActionSystem:Update(TaggedEntities)
    for _, TaggedEntity in pairs(TaggedEntities) do
        self:ProcessInput(TaggedEntity)
        TaggedEntity:AddComponent("InputActionProcessed", true)
    end
end

function InputActionSystem:ProcessInput(UserEntity)
    local InputComponent = UserEntity:Get("Input")
    local Character = UserEntity:Get("Character").Character
    local Inventory = UserEntity:Get("Inventory")

    local Input = InputComponent.Input
    local Equipped = Inventory.Equipped

    local EquippedItem = Inventory.Hotbar[Equipped]

    if not EquippedItem then
        return
    end

    Action(EquippedItem.Name, Input, Character)
end

return InputActionSystem