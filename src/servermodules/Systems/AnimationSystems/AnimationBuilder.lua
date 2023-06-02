local AnimationBuildSystem = {
    Name = "AnimationBuildSystem",
    Priority = "PreUpdate",
    Tag = {
        "Character",
        "AnimationQueue"
    }
}

function AnimationBuildSystem:Update(TaggedEntities)
    for _, TaggedEntity in pairs(TaggedEntities) do
        self:ProcessAnimationBuild(TaggedEntity)
    end
end

function AnimationBuildSystem:ProcessAnimationBuild(UserEntity)
    local AnimationQueue = UserEntity:Get("AnimationQueue")
    local PlayingAnimations = UserEntity:Get("PlayingAnimations")
    if not PlayingAnimations then
        UserEntity:AddComponent("PlayingAnimations", {
            PlayingAnimations = {},
        })
        PlayingAnimations = UserEntity:Get("PlayingAnimations")
    end
    local AnimationData = AnimationQueue.Animations

    for AnimationName, Animation in pairs(AnimationData) do
        if not PlayingAnimations.PlayingAnimations[AnimationName] then
            -- remove the animation request from the queue
            UserEntity:Get("AnimationQueue").Animations[AnimationName] = nil

            -- check for cached animation or load it/
            -- play and store the animation
            self:PlayAnimation(UserEntity, AnimationName, Animation)
        else
            AnimationData[AnimationName] = nil
        end
    end

    if not next(AnimationData) then
        UserEntity:RemoveComponent("AnimationQueue")
    end
end

function AnimationBuildSystem:GetAnimationObject(AnimationId)
    local AnimationObject = script:FindFirstChild(AnimationId)
    if not AnimationObject then
        AnimationObject = Instance.new("Animation")
        AnimationObject.AnimationId = "rbxassetid://"..AnimationId
        AnimationObject.Name = AnimationId
        AnimationObject.Parent = script
    end
    return AnimationObject
end

function AnimationBuildSystem:PlayAnimation(UserEntity, AnimationName, AnimationData)
    local Character = UserEntity:Get("Character").Character
    local Humanoid = Character:FindFirstChild("Humanoid")
    local AnimationTrackCache = UserEntity:Get("_AnimationTrackCache")
    local CharacterTrove = UserEntity:Get("CharacterTrove")

    local AnimationId = AnimationData.AnimationId
    local Data = AnimationData.Data

    if not AnimationTrackCache then
        local _, ComponentDisconnecter = UserEntity:AddComponent("_AnimationTrackCache", {
            AnimationTrackCache = {},
        })

        CharacterTrove:Add(function()
            for _, AnimationTrack in pairs(AnimationTrackCache.AnimationTrackCache) do
                AnimationTrack:Stop()
                AnimationTrack:Destroy()
            end
        end)

        CharacterTrove:Add(ComponentDisconnecter)

        AnimationTrackCache = UserEntity:Get("_AnimationTrackCache")
    end

    local AnimationTrack = AnimationTrackCache.AnimationTrackCache[AnimationId]
    if not AnimationTrack then
        local AnimationObject = self:GetAnimationObject(AnimationId)
        AnimationTrack = Humanoid:LoadAnimation(AnimationObject)
        AnimationTrackCache.AnimationTrackCache[AnimationId] = AnimationTrack
    end

    if Data.AnimationPriority then
        AnimationTrack.Priority = Data.AnimationPriority
    end

    local EasingTime = Data.EasingTime or 0.1
    local Weight = Data.Weight or 1
    local Speed = Data.Speed or 1

    AnimationTrack:Play(EasingTime, Weight, Speed)

    if Data.Speed then
        AnimationTrack:AdjustSpeed(Data.Speed)
    end

    return AnimationTrack
end

return AnimationBuildSystem