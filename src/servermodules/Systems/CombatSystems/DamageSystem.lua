local DamageSystem = {
    Name = "DamageSystem",
    Priority = "Attack",
    Tag = {
        "Character",
        "TargetCharacter",
        "Damage",
        "!Damaged"
    }
}

function DamageSystem:Update(TaggedEntities)
    for _, TaggedEntity in pairs(TaggedEntities) do
        self:ProcessDamage(TaggedEntity)
        --TaggedEntity:RemoveComponent("Damage")
    end
end

function DamageSystem:ProcessDamage(AttackEntity)
    local Attacker = AttackEntity:Get("Character")
    local Damage = AttackEntity:Get("Damage")

    local Target = AttackEntity:Get("TargetCharacter")
    local TargetHumanoid = Target.Character:FindFirstChild("Humanoid")
    local TargetUserEntity = AttackEntity:Get("TargetUserEntity")

    local Damage = self:CalculateDamage(Attacker, Target, Damage)

    local CalculatedHealth = TargetHumanoid.Health - Damage
    if CalculatedHealth > 0 then
        TargetHumanoid:TakeDamage(Damage)
    elseif not TargetUserEntity:Get("Knockdowned") then
        --TargetHumanoid.Health = 1
        TargetUserEntity:AddComponent("Knockdowned", true)
    end

    self:MarkAttackEntity(AttackEntity, Target, Damage)
end

function DamageSystem:CalculateDamage(Attacker, Target, Damage)
    local AttackerDamageMultiplier = Attacker.DamageMultipliers
    local TargetDamageMultiplier = Target.DamageMultipliers

    if AttackerDamageMultiplier then
        for _, Multiplier in pairs(AttackerDamageMultiplier) do
            Damage = Damage * Multiplier
        end
    end

    if TargetDamageMultiplier then
        for _, Multiplier in pairs(TargetDamageMultiplier) do
            Damage = Damage * Multiplier
        end
    end

    return Damage
end

function DamageSystem:MarkAttackEntity(AttackEntity, Target, Amount)
    if not AttackEntity:Get("Damaged") then
        AttackEntity:AddComponent("Damaged", {})
    end

    local Damaged = AttackEntity:Get("Damaged")
    Damaged[Target.Character] = Amount

    self:InjectBaseDamageEvents(AttackEntity, Amount)
end

function DamageSystem:InjectBaseDamageEvents(AttackEntity, Amount)
    local DamageEvents = AttackEntity:Get("DamageEvents") or {}
    table.insert(DamageEvents, {
        Name = "Damage_Indicator",
        Data = {
            Target = "__Target",
            Damage = Amount
        }
    })
    AttackEntity:AddComponent("DamageEvents", DamageEvents)
end

return DamageSystem