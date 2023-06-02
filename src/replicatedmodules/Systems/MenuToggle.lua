local Debris = game:GetService("Debris")

local MenuToggleSystem = {
    Name = "MenuToggleSystem",
    Priority = "PreUpdate",
    Tag = {
        "Input"
    }
}

function MenuToggleSystem:Update(TaggedEntities)
    for _, TaggedEntity in pairs(TaggedEntities) do
        self:ProcessInput(TaggedEntity)
    end
end

function MenuToggleSystem:ProcessInput(InputEntity)
    local Player = InputEntity:Get("Player")
    local Input = InputEntity:Get("Input")
    local InputName = Input.Input
    local Type = Input.InputType

    local Character = Player.Character
    local Humanoid = Character:WaitForChild("Humanoid")
    local UserEntity = self.Workshop:GetEntity(Player.Name .. "UserEntity")

    if InputName == "Tab" and Type == "Began" then
        local Inventory = UserEntity:Get("Inventory")
        if Inventory.MenuOpen == nil then
            Inventory.MenuOpen = false
        end
        Inventory.MenuOpen = not Inventory.MenuOpen

        if Inventory.MenuOpen then
            game.ReplicatedStorage.RunClient:Fire("PlaySound", {
                SoundId = 2217513097,
                Volume = 1
            })
        else
            game.ReplicatedStorage.RunClient:Fire("PlaySound", {
                SoundId = 9125654187,
                Volume = 1
            })
            if Inventory.ChestOpen then
                Inventory.ChestOpen = false
            end
        end
    end
end

return MenuToggleSystem