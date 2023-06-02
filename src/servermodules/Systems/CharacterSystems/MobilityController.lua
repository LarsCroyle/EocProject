local MovementControllerSystem = {
    Name = "MovementControllerSystem",
    Priority = "PostUpdate",
    Tag = {
        "Character",
        "MovementController"
    }
}

function MovementControllerSystem:Update(TaggedEntities)
    for _, TaggedEntity in pairs(TaggedEntities) do
        self:ProcessMovement(TaggedEntity)
    end
end

function MovementControllerSystem:ProcessMovement(UserEntity)
    local Humanoid = UserEntity:Get("Character").Humanoid
    local MovementController = UserEntity:Get("MovementController")
    local MaxWalkSpeed = MovementController.MaxWalkSpeed
    local MaxJumpPower = MovementController.MaxJumpPower
    local MinWalkSpeed = MovementController.MinWalkSpeed
    local MinJumpPower = MovementController.MinJumpPower

    local WalkSpeed = MovementController.BaseWalkSpeed

    for _, MaxWalkSpeedEntry in pairs(MaxWalkSpeed) do
        if WalkSpeed > MaxWalkSpeedEntry then
            WalkSpeed = MaxWalkSpeedEntry
        end
    end

    for _, MinWalkSpeedEntry in pairs(MinWalkSpeed) do
        if WalkSpeed < MinWalkSpeedEntry then
            WalkSpeed = MinWalkSpeedEntry
        end
    end

    local JumpPower = MovementController.BaseJumpPower

    for _, MaxJumpPowerEntry in pairs(MaxJumpPower) do
        if JumpPower > MaxJumpPowerEntry then
            JumpPower = MaxJumpPowerEntry
        end
    end

    for _, MinJumpPowerEntry in pairs(MinJumpPower) do
        if JumpPower < MinJumpPowerEntry then
            JumpPower = MinJumpPowerEntry
        end
    end

    Humanoid.WalkSpeed = WalkSpeed
    Humanoid.JumpPower = JumpPower
end

return MovementControllerSystem