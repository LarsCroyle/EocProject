local UserInputService = game:GetService("UserInputService")

local AimingSystem = {
    Name = "AimingSystem",
    Priority = "Update",
    Tag = {
        "Input"
    }
}

function AimingSystem:Update(TaggedEntities)
    for _, TaggedEntity in TaggedEntities do
        self:ProcessInput(TaggedEntity)
    end
end

function AimingSystem:ProcessInput(InputEntity)
    local Player = InputEntity:Get("Player")
    local Input = InputEntity:Get("Input")
    local InputName = Input.Input
    local Type = Input.InputType

    local Character = Player.Character
    local Humanoid = Character:WaitForChild("Humanoid")
    local UserEntity = self.Workshop:GetEntity(Player.Name .. "UserEntity")

    local Inventory = UserEntity:Get("Inventory")
    local Equipped = Inventory.Equipped
    local Hotbar = Inventory.Hotbar
    local Item = Hotbar[Equipped]
    if not Item then
        return
    end
    local ItemIsAimable = Item.Aimable

    if not ItemIsAimable then
        return
    end

    if InputName == "MouseButton1" and Type == "Began" then
        UserEntity:SetComponent("IsAiming", true)
        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
    --    workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
    elseif InputName == "MouseButton1" and Type == "Ended" then
        UserEntity:SetComponent("IsAiming", false)
        --workspace.CurrentCamera.FieldOfView = 70
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        --workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
    end
end

return AimingSystem