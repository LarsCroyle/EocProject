local GetCommon = require(game.ServerStorage.Modules.Functions.GetCommonMethod)

local DamageAnimationsSystem = {
    Name = "DamageAnimationsSystem",
    Priority = "Attack",
    Tag = {
        "Character",
        "TargetCharacter",
        "Damage"
    }
}

function DamageAnimationsSystem:Update(TaggedEntities)
    for _, TaggedEntity in pairs(TaggedEntities) do
        self:ProcessAttack(TaggedEntity)
    end
end

function DamageAnimationsSystem:ProcessAttack(AttackEntity)
    local TargetUserEntity = AttackEntity:Get("TargetUserEntity")
    local UserEntity = AttackEntity:Get("UserEntity").UserEntity

    if not TargetUserEntity then
        return
    end

    local AnimationTrackCache = UserEntity:Get("_AnimationTrackCache")
    local Knockback = AttackEntity:Get("Knockback")
    local HitStopAnimationSpeed = 2

    if Knockback and Knockback.Delay then
        HitStopAnimationSpeed -= Knockback.Delay * 2
    end
    local Damage = AttackEntity:Get("Damage")

    for _, AnimationTrack in pairs(AnimationTrackCache.AnimationTrackCache) do
        if typeof(AnimationTrack) == "table" then
            continue
        end
        if not AnimationTrack.IsPlaying then
            continue
        end
        task.delay(0.1, function()
            local OriginalSpeed = AnimationTrack.Speed
            local SlowedSpeed = Damage / 100

            if OriginalSpeed < SlowedSpeed + 0.1 then
                return
            end

            AnimationTrack:AdjustSpeed(SlowedSpeed)

            task.delay(SlowedSpeed, function()
                AnimationTrack:AdjustSpeed(OriginalSpeed)
            end)
        end)
    end

    local HitStopAnimationWeight = 0.5

    HitStopAnimationWeight += Damage * 0.02
    HitStopAnimationSpeed -= Damage * 0.01

    GetCommon("PlayAnimation")({
        UserEntity = UserEntity
    }, DamageAnimationsSystem, "Default.HitStopTorso", {
        Speed = HitStopAnimationSpeed + 0.4,
        Weight = HitStopAnimationWeight / 4
    })

    GetCommon("PlayAnimation")({
        UserEntity = TargetUserEntity
    }, DamageAnimationsSystem, "Default.HitStopTorso", {
        Speed = HitStopAnimationSpeed,
        Weight = HitStopAnimationWeight
    })

    GetCommon("PlayAnimation")({
        UserEntity = TargetUserEntity
    }, DamageAnimationsSystem, "Default.Hit" .. math.random(1, 4))
end

return DamageAnimationsSystem