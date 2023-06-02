local Access = require(game.ReplicatedStorage.Modules.Recs.Access)
local Workshop = Access.GetWorkshop()

return function(Arguments)
    local Inventory = Arguments
    local Player = game.Players.LocalPlayer
    local UserEntity = Workshop:GetEntity(Player.Name .. "UserEntity")

    local ClientOwnedProperties = {
        ["MenuOpen"] = true
    }
    local ClientInventory = UserEntity:Get("Inventory")

    if Inventory.ChestOpen then
        ClientInventory.MenuOpen = true
    end

    if ClientInventory then
        for Property, _ in ClientOwnedProperties do
            Inventory[Property] = ClientInventory[Property]
        end
    end

    UserEntity:SetComponent("Inventory", Inventory)
end