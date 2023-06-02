local AnimationStopSystem = {
    Name = "AnimationStopSystem",
    Priority = "PostUpdate",
    Tag = {
        "Character",
        "StopAnimationQueue"
    }
}

function AnimationStopSystem:Update(TaggedEntities)
    for _, TaggedEntity in pairs(TaggedEntities) do
        self:ProcessAnimationStop(TaggedEntity)
    end
end

function AnimationStopSystem:ProcessAnimationStop(UserEntity)
    local StopAnimationQueue = UserEntity:Get("StopAnimationQueue")
    local AnimationTrackCache = UserEntity:Get("_AnimationTrackCache")

    if not StopAnimationQueue then
        return
    end

    local AnimationData = StopAnimationQueue.Animations
    for _, AnimationName in pairs(AnimationData) do
        local Animation = AnimationTrackCache.AnimationTrackCache[AnimationName]
        if Animation then
            Animation:Stop()
        end
        UserEntity:Get("StopAnimationQueue").Animations[_] = nil
    end

    if not next(UserEntity:Get("StopAnimationQueue").Animations) then
        UserEntity:RemoveComponent(UserEntity:Get("StopAnimationQueue"))
    end
end

return AnimationStopSystem