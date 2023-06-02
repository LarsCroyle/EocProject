local GetUserEntityFromCharacter = require(game.ServerStorage.Modules.Functions.GetUserEntityFromCharacter)
local Net = require(game.ReplicatedStorage.Modules.Packages.Net)
local EquipItem = require(game.ServerStorage.Modules.Functions.Items.EquipItem)
local UnequipItem = require(game.ServerStorage.Modules.Functions.Items.UnequipItem)

local Action = require(game.ServerStorage.Modules.Functions.ActionMethod)

local ItemEquipperSystem = {
    Name = "ItemEquipperSystem",
    Priority = "Update",
    Tag = {
        "Character",
        "Input",
        "Inventory"
    }
}

function ItemEquipperSystem:Update(TaggedEntities)
    for _, TaggedEntity in pairs(TaggedEntities) do
        self:ProcessInput(TaggedEntity)
    end
end

local InventoryKeybinds = {
    ["One"] = 1,
    ["Two"] = 2,
    ["Three"] = 3,
    ["Four"] = 4,
    ["Five"] = 5,
    ["Six"] = 6,
    ["Seven"] = 7,
    ["Eight"] = 8,
    ["Nine"] = 9,
    ["Zero"] = 10
}

function ItemEquipperSystem:ProcessInput(UserEntity)
    local InputComponent = UserEntity:Get("Input").Input
    local InventoryComponent = UserEntity:Get("Inventory")
    local Humanoid = UserEntity:Get("Character").Humanoid

    local Hotbar = InventoryComponent.Hotbar
    local Equipped = InventoryComponent.Equipped
    local EquippedItem = Hotbar[Equipped]

    local InputIndex = InventoryKeybinds[InputComponent]
    local HotbarItem = Hotbar[InputIndex]

    if not InputIndex or Humanoid:GetState() == Enum.HumanoidStateType.Dead then
        return
    end

    if UserEntity:Get("ActionInProgress") then
        return
    end

    if EquippedItem then
        UnequipItem({
            UserEntity = UserEntity,
            HotbarIndex = Equipped
        })

        if HotbarItem and EquippedItem.Name == HotbarItem.Name then
            return
        end
    end

    repeat
        task.wait()
    until not UserEntity:Get("ActionInProgress")

    if HotbarItem then
        EquipItem({
            UserEntity = UserEntity,
            HotbarIndex = InputIndex
        })
    end
end

ItemEquipperSystem.ClientUpdateInventoryCalls = {
    ["TransferItem"] = function(Player, Data)
        local From = Data.From
        local To = Data.To

        local OldIndex = Data.OldIndex
        local NewIndex = Data.NewIndex

        local UserEntity = Data.UserEntity

        if UserEntity:Get("ActionInProgress") then
            return
        end

        local Inventory = UserEntity:Get("Inventory")
        local FromSource = Inventory[From]
        local ToSource = Inventory[To]

        local FromItem = FromSource[OldIndex]

        local function GetIndex()
            local Group = ToSource
            for Index, Item in pairs(Group) do
                if Item.Name == FromItem.Name and Item.Name ~= "None" then
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

        if To == "Inventory" then
            To = "Hotbar"
            ToSource = Inventory[To]
            NewIndex = GetIndex()

            if not NewIndex then
                To = "Items"
                ToSource = Inventory[To]
                NewIndex = GetIndex()

                if not NewIndex then
                    return
                end
            end
        end

        local ToItem = ToSource[NewIndex]

        if not NewIndex then
            NewIndex = GetIndex()
        end

        if not NewIndex then
            return
        end

        if From == "Hotbar" and Inventory.Equipped == OldIndex then
            UnequipItem({
                UserEntity = UserEntity,
                HotbarIndex = OldIndex
            })
        elseif To == "Hotbar" and Inventory.Equipped == NewIndex then
            UnequipItem({
                UserEntity = UserEntity,
                HotbarIndex = NewIndex
            })
        end

        if From == "ChestItems" then
            local Character = UserEntity:Get("Character").Character

            Action(FromItem.Name, "Added", Character)
        end

        if not ToItem then
            ToItem = {
                Name = "None",
                Quantity = 1,
                Rarity = "Common",
            }
        end
        if not FromItem then
            FromItem = {
                Name = "None",
                Quantity = 1,
                Rarity = "Common",
            }
        end

        FromSource[OldIndex] = ToItem
        ToSource[NewIndex] = FromItem

        local ReplicationEntity = ItemEquipperSystem.Workshop:CreateEntity()
        :AddComponent("RunClient", {
            Call = "UpdateInventory",
            Arguments = Inventory,
            Target = UserEntity:Get("Player").Player
        })
        ItemEquipperSystem.Workshop:SpawnEntity(ReplicationEntity)
    end
}

function ItemEquipperSystem:Boot()
    Net:RemoteEvent("ClientUpdateInventory").OnServerEvent:Connect(function(Player, Call, Data)
        local CallFunction = ItemEquipperSystem.ClientUpdateInventoryCalls[Call]
        local UserEntity = GetUserEntityFromCharacter(Player.Character)
        if not UserEntity then
            return
        end

        Data.UserEntity = UserEntity

        if CallFunction then
            CallFunction(Player, Data)
        end
    end)
end

return ItemEquipperSystem