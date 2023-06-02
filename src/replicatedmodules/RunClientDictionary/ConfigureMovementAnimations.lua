local Access = require(game.ReplicatedStorage.Modules.Recs.Access)
local Workshop = Access.GetWorkshop()

return function(Arguments)
    local MovementAnimationSet = Arguments.MovementAnimationSet
    local Player = game.Players.LocalPlayer
    local UserEntity = Workshop:GetEntity(Player.Name .. "UserEntity")

    local MovementAnimationSetComponent = UserEntity:Get("MovementAnimationSet")

    for AnimationName, Animation in pairs(MovementAnimationSet) do
        MovementAnimationSetComponent[AnimationName] = Animation
    end
end