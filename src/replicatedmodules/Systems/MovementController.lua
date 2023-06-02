local DetermineMovement = require(game.ReplicatedStorage.Modules.Functions.DetermineMovement)

local MovementControllerSystem = {
    Name = "MovementControllerSystem",
    Priority = "PostUpdate",
    Tag = {
        "MovementControls"
    }
}
-- movement controls dictate walkspeed and jump power of the character through a lowest first priority system

function MovementControllerSystem:Update(TaggedEntities)
    for _, TaggedEntity in pairs(TaggedEntities) do
        self:ProcessEntity(TaggedEntity)
    end
end

function MovementControllerSystem:ProcessEntity(UserEntity)
    local MovementControls = UserEntity:Get("MovementControls")
    local Character = UserEntity:Get("Character").Character
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")

    local CalculatedWalkSpeed, CalculatedJumpPower = DetermineMovement(MovementControls)

    Humanoid.WalkSpeed = CalculatedWalkSpeed
    Humanoid.JumpPower = CalculatedJumpPower
end

return MovementControllerSystem