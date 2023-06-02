local StunSystem = {
    Name = "StunSystem",
    Priority = "Attack",
    Tag = {
        "Character",
        "TargetCharacter",
        "Stun",
        "!StunProcessed",
        "!Parryable"
    }
}

function StunSystem:Update(TaggedEntities)
    for _, TaggedEntity in pairs(TaggedEntities) do
        self:ProcessStun(TaggedEntity)
    end
end

function StunSystem:ProcessStun(AttackEntity)
    local Attacker = AttackEntity:Get("Character")
    local Target = AttackEntity:Get("TargetCharacter")

    local Stun = AttackEntity:Get("Stun")

    if AttackEntity:Get("Parried") then
        return
    end

    local TargetUserEntity = AttackEntity:Get("TargetUserEntity")

    self:SetTargetStunned(TargetUserEntity, Stun)
    self:MarkAttackEntity(AttackEntity, Target, Stun)

    AttackEntity:AddComponent("StunProcessed", true)
end

function StunSystem:SetTargetStunned(TargetEntity, Duration)
    TargetEntity:AddComponent("Stun", {
        Duration = Duration
    })
end

function StunSystem:MarkAttackEntity(AttackEntity, Target, Amount)
    if not AttackEntity:Get("Stunned") then
        AttackEntity:AddComponent("Stunned", Target.Character)
    end
end

return StunSystem