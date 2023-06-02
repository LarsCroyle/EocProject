local ActionDictionary = require(game.ServerStorage.Modules.ActionDictionary)

return function(self, SequenceSystem, ...)
    local MovementAnimationSet = ...
    if typeof(MovementAnimationSet) == "string" then
        local Assets = ActionDictionary.GetActionDataSet(MovementAnimationSet).Assets
        MovementAnimationSet = Assets.Animations.MovementAnimationSet

        for AnimationName, Animation in pairs(MovementAnimationSet) do
            if typeof(Animation) == "number" then
                MovementAnimationSet[AnimationName] = "rbxassetid://" .. Animation
            end
        end
    end

    local RunClient = SequenceSystem.Workshop:CreateEntity()
    :AddComponent("RunClient", {
        Target = self.UserEntity:Get("Player").Player,
        Call = "ConfigureMovementAnimations",
        Arguments = {
            MovementAnimationSet = MovementAnimationSet
        }
    })
    SequenceSystem.Workshop:SpawnEntity(RunClient)
end