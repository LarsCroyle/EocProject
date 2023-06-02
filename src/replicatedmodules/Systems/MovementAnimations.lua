local MovementAnimationSystem = {
    Name = "MovementAnimationSystem",
    Priority = "Update",
    Tag = {
        "Character",
        "MovementAnimationSet"
    }
}

function MovementAnimationSystem:Update(TaggedEntities)
    for _, TaggedEntity in pairs(TaggedEntities) do
        self:ProcessEntity(TaggedEntity)
    end
end

function MovementAnimationSystem:PlayAnimation(UserEntity, AnimationId)
    if not UserEntity:Get("AnimationCache") then
        UserEntity:AddComponent("AnimationCache", {})
    end
    local AnimationCache = UserEntity:Get("AnimationCache")
    if not script:FindFirstChild(AnimationId) then
        local Animation = Instance.new("Animation")
        Animation.AnimationId = AnimationId
        Animation.Name = AnimationId
        Animation.Parent = script
    end
    local Animation = script:FindFirstChild(AnimationId)
    if not AnimationCache[AnimationId] then
        AnimationCache[AnimationId] = UserEntity:Get("Character").Humanoid:LoadAnimation(Animation)
    end
    AnimationCache[AnimationId]:Play()

    return AnimationCache[AnimationId]
end

function MovementAnimationSystem:StopAnimation(UserEntity, AnimationId)
    if not UserEntity:Get("AnimationCache") then
        UserEntity:AddComponent("AnimationCache", {})
    end
    local AnimationCache = UserEntity:Get("AnimationCache")
    if not AnimationCache[AnimationId] then
        return
    end
    AnimationCache[AnimationId]:Stop()
end

function MovementAnimationSystem:StopAllAnimations(UserEntity)
    if not UserEntity:Get("AnimationCache") then
        UserEntity:AddComponent("AnimationCache", {})
    end
    local AnimationCache = UserEntity:Get("AnimationCache")
    for AnimationId, Animation in pairs(AnimationCache) do
        Animation:Stop()
    end
end

function MovementAnimationSystem:GetState(Humanoid)
    local State = "Idle"

    if Humanoid:GetState() == Enum.HumanoidStateType.Dead or Humanoid:GetState() == Enum.HumanoidStateType.Ragdoll or Humanoid:GetState() == Enum.HumanoidStateType.Physics then
        State = "None"
    elseif Humanoid:GetState() == Enum.HumanoidStateType.Climbing then
        State = "Climb"
    elseif Humanoid.Jump then
        State = "Jump"
    elseif Humanoid.FloorMaterial == Enum.Material.Air then
        State = "Fall"
    elseif Humanoid.MoveDirection ~= Vector3.new(0, 0, 0) then
        if Humanoid.WalkSpeed > 16 then
            State = "Sprint"
        else
            State = "Walk"
        end
    elseif Humanoid.Sit then
        State = "Sit"
    end

    return State
end

function MovementAnimationSystem:ProcessEntity(UserEntity)
    local Character = UserEntity:Get("Character")
    local MovementAnimationSet = UserEntity:Get("MovementAnimationSet")
    local Humanoid = Character.Humanoid

    local State = self:GetState(Humanoid)
    local CurrentState = UserEntity:Get("MovementAnimationSet").CurrentState
    local CurrentAnimationIdPlaying = UserEntity:Get("MovementAnimationSet").CurrentAnimationIdPlaying
    local AnimationId = MovementAnimationSet[State]

    UserEntity:Get("MovementAnimationSet").CurrentState = State

    if State ~= CurrentState then
        if CurrentState then
            self:StopAnimation(UserEntity, MovementAnimationSet[CurrentState])
        end
        UserEntity:Get("MovementAnimationSet").CurrentState = State
    else
        if CurrentAnimationIdPlaying == AnimationId then
            return
        else
            self:StopAnimation(UserEntity, CurrentAnimationIdPlaying)
        end
    end

    if AnimationId then
        local AnimationTrack = self:PlayAnimation(UserEntity, AnimationId)
        UserEntity:Get("MovementAnimationSet").CurrentAnimationIdPlaying = AnimationId
        UserEntity:Get("MovementAnimationSet").CurrentPlayingAnimation = AnimationTrack
    else
        self:StopAllAnimations(UserEntity)
    end
end

return MovementAnimationSystem