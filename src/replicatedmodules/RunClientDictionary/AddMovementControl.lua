local Access = require(game.ReplicatedStorage.Modules.Recs.Access)
local Workshop = Access.GetWorkshop()

local ReconcileMovementControls = require(game.ReplicatedStorage.Modules.Functions.ReconcileMovementControls)

return function(Arguments)
    local Mode = Arguments.Mode
    local MovementControlSet = Arguments.MovementControlSet
    local MovementControlSetIdentifier = Arguments.Name

    local Player = game.Players.LocalPlayer
    local UserEntity = Workshop:GetEntity(Player.Name .. "UserEntity")

    ReconcileMovementControls(UserEntity, Arguments)
end