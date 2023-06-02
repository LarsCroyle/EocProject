local AddItem = require(game.ServerStorage.Modules.Functions.Items.AddItem)
local ActionDictionary = require(game.ServerStorage.Modules.ActionDictionary)

return function(UserEntity, ItemSlot, MasteryAmount)
    local Mastery = ItemSlot.Properties.Mastery
    local MaximumMastery = ItemSlot.Properties.MaximumMastery

    if Mastery == MaximumMastery then
        return
    end

    local Mastery = Mastery + MasteryAmount
    if Mastery > MaximumMastery then
        Mastery = MaximumMastery
    end
    ItemSlot.Properties.Mastery = Mastery

    if ItemSlot.Properties.Mastery == ItemSlot.Properties.MaximumMastery then
        warn(UserEntity:Get("Player").Player.Name, "has mastered", ItemSlot.Name)
        local Rarity = ItemSlot.Rarity
        local MasteryBadgeItemName = Rarity .." " .. ItemSlot.Name .. " Mastery Badge"
        print(MasteryBadgeItemName)

        if not ActionDictionary[MasteryBadgeItemName] then
            ActionDictionary[MasteryBadgeItemName] = {
                Actions = {
                    Added = {
                        Action = {
                            {0, function(self)
                                print(MasteryBadgeItemName, "Added")
                            end}
                        },
                        ActionInformation = {
                            Active = false
                        }
                    },
                    Removed = {
                        Action = {
                            {0, function(self)
                                print(MasteryBadgeItemName, "Removed")
                            end}
                        },
                        ActionInformation = {
                            Active = false
                        }
                    }
                },
                Config = {
                    Name = MasteryBadgeItemName,
                    Rarity = Rarity,
                    Form = "MasteryBadge",
                },
                Assets = {}
            }
        end

        AddItem({
            UserEntity = UserEntity,
            Type = "Inventory",
            ItemName = MasteryBadgeItemName,
            Quantity = 1
        })
    end
end