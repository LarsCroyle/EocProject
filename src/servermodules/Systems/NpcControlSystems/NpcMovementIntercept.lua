local GetUserEntityFromCharacter = require(game.ServerStorage.Modules.Functions.GetUserEntityFromCharacter)
local DetermineMovement = require(game.ReplicatedStorage.Modules.Functions.DetermineMovement)
local ReconcileMovementControls = require(game.ReplicatedStorage.Modules.Functions.ReconcileMovementControls)

local NpcMovementInterceptSystem = {
    Name = "NpcMovementControlsSystem",
    Priority = "PreUpdate",
    Tag = {
        "RunClient"
    }
}

function NpcMovementInterceptSystem:Update(TaggedEntities)
    for _, TaggedEntity in pairs(TaggedEntities) do
        self:ProcessRunClient(TaggedEntity)
    end
end

function NpcMovementInterceptSystem:ProcessRunClient(RunClientEntity)
    local RunClient = RunClientEntity:Get("RunClient")
    local Call = RunClient.Call
    local Arguments = RunClient.Arguments
    local Target = RunClient.Target

    if Call ~= "AddMovementControl" then
        return
    end

    if typeof(Target) ~= "Instance" then
        return
    end

    local UserEntity = GetUserEntityFromCharacter(Target)

    if not UserEntity then
        return
    end

    local Npc = UserEntity:Get("Npc")

    if not Npc then
        return
    end

    self.Workshop:RemoveEntity(RunClientEntity.Name)

    self:ProcessMovementControlAdditions(UserEntity, Arguments)
end

function NpcMovementInterceptSystem:ProcessMovementControlAdditions(UserEntity, Arguments)
    ReconcileMovementControls(UserEntity, Arguments)

    local Npc = UserEntity:Get("Npc")
    local NpcMovementControls = UserEntity:Get("MovementControls")

    local CalculatedWalkSpeed, CalculatedJumpPower = DetermineMovement(NpcMovementControls)

    local Character = UserEntity:Get("Character").Character
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")

    Humanoid.WalkSpeed = CalculatedWalkSpeed
    Humanoid.JumpPower = CalculatedJumpPower
end

return NpcMovementInterceptSystem