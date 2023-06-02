local RagdollMethod = require(game.ServerStorage.Modules.Functions.RagdollMethod)

local RagdollSystem = {
    Name = "RagdollSystem",
    Priority = "Attack",
    Tag = {
        "Character",
        "TargetCharacter",
        "Ragdoll",
        "!RagdollProcessed",
        "!Parryable"
    }
}

function RagdollSystem:Update(TaggedEntities)
    for _, TaggedEntity in pairs(TaggedEntities) do
        self:ProcessRagdoll(TaggedEntity)
        TaggedEntity:AddComponent("RagdollProcessed", true)
    end
end

function RagdollSystem:ProcessRagdoll(AttackEntity)
    local Attacker = AttackEntity:Get("Character")
    local Target = AttackEntity:Get("TargetCharacter")

    local Ragdoll = AttackEntity:Get("Ragdoll")
    local Duration = Ragdoll.Duration

    local TargetUserEntity = AttackEntity:Get("TargetUserEntity")
    local TargetRagdoll = TargetUserEntity:Get("RagdollInstance")

    if not TargetRagdoll then
        return
    end

    RagdollMethod({
        Target = Target,
        TargetRagdoll = TargetRagdoll,
        TargetUserEntity = TargetUserEntity,
        Mode = true
    })

    task.delay(Duration, function()
        RagdollMethod({
            Target = Target,
            TargetRagdoll = TargetRagdoll,
            TargetUserEntity = TargetUserEntity,
            Mode = false
        })
    end)
end

return RagdollSystem