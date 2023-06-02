local GetCommon = require(game.ServerStorage.Modules.Functions.GetCommonMethod)

local ParrySystem = {
    Name = "ParrySystem",
    Priority = "Update",
    Tag = {
        "Character",
        "TargetCharacter",
        "Parryable",
        "Damage"
    }
}

function ParrySystem:Update(TaggedEntities)
    for _, TaggedEntity in pairs(TaggedEntities) do
        self:ProcessAttack(TaggedEntity)
    end
end

function ParrySystem:ProcessAttack(AttackEntity)
    local TargetUserEntity = AttackEntity:Get("TargetUserEntity")
    local UserEntity = AttackEntity:Get("UserEntity").UserEntity

    if not TargetUserEntity then
        return
    end

    if TargetUserEntity:Get("Parry") then
        AttackEntity:RemoveComponent("Damage")
        AttackEntity:RemoveComponent("Stun")
        AttackEntity:RemoveComponent("Knockback")

        AttackEntity:AddComponent("Parried", true)

        self.Workshop:RemoveEntity(AttackEntity.Name)
        self:Parried(TargetUserEntity, UserEntity)
    end

    AttackEntity:RemoveComponent("Parryable")
end

function ParrySystem:Parried(TargetUserEntity, UserEntity)
    UserEntity:AddComponent("Stun", {
        Duration = 0.8
    })

    TargetUserEntity:AddComponent("ParrySuccess", true)

    GetCommon("PlayAnimation")({
        UserEntity = TargetUserEntity
    }, ParrySystem, "Default.Parry")

    GetCommon("PlayAnimation")({
        UserEntity = UserEntity
    }, ParrySystem, "Default.Parry")

    local ParrySounds = {
        [1] = 13534404699,
        [2] = 13534404639,
        [3] = 13534404581,
        [4] = 13534404519,
        [5] = 13534404436,
        [6] = 13534404343,
        [7] = 13534404237,
        [8] = 13534404117,
        [9] = 13534404000
    }

    GetCommon("PlaySound")({
        UserEntity = TargetUserEntity
    }, ParrySystem, {
        SoundId = ParrySounds[math.random(1, #ParrySounds)]
    })

    local RunClient = self.Workshop:CreateEntity()

    RunClient:AddComponent("RunClient", {
        Call = "EmitParticles",
        Arguments = {
            Particle = "ParryEffect",
            Target = TargetUserEntity:Get("Character").Character
        },
        Target = "All"
    })

    --GetCommon("RunClient")("CameraShake", {
    --    Magnitude = 2.5,
    --    Roughness = 5,
    --    FadeInTime = 0.05,
    --    FadeOutTime = 0.25,
    --}, self.Player)

    self.Workshop:SpawnEntity(RunClient)
end

return ParrySystem