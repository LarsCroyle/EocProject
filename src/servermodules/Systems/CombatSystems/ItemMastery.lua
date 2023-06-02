local AwardMastery = require(game.ServerStorage.Modules.Functions.Items.AwardMastery)

local ItemMasterySytem = {
    Name = "ItemMastery",
    Priority = "PostAttack",
    Tag = {
        "Character",
        "TargetCharacter",
        "Damaged"
    }
}

function ItemMasterySytem:Update(TaggedEntities)
    for _, TaggedEntity in pairs(TaggedEntities) do
        self:ProcessAttack(TaggedEntity)
    end
end

function ItemMasterySytem:ProcessAttack(AttackEntity)
    local Damage = AttackEntity:Get("Damage")
    local UserEntity = AttackEntity:Get("UserEntity").UserEntity
    local Inventory = UserEntity:Get("Inventory")

    local Hotbar = Inventory.Hotbar
    local Equipped = Inventory.Equipped

    local EquippedItem = Hotbar[Equipped]

    if not EquippedItem then
        return
    end
    if not EquippedItem.Form or EquippedItem.Form and EquippedItem.Form ~= "Weapon" then
        return
    end

    print(UserEntity:Get("Player").Player.Name, "'s Mastery of :", EquippedItem.Name, " is ", EquippedItem.Properties.Mastery)

    if not EquippedItem.Properties.Mastery then
        return
    end

    if EquippedItem.Properties.Mastery == EquippedItem.Properties.MaximumMastery then
        return
    end

    local MasteryAmount = Damage * 1/10
    AwardMastery(UserEntity, EquippedItem, MasteryAmount)
end

return ItemMasterySytem