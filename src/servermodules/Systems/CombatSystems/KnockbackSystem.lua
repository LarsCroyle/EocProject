local KnockbackSystem = {
    Name = "KnockbackSystem",
    Priority = "Attack",
    Tag = {
        "Character",
        "TargetCharacter",
        "Knockback",
        "!KnockedBack",
        "!Parryable"
    }
}

function KnockbackSystem:Update(TaggedEntities)
    for _, TaggedEntity in pairs(TaggedEntities) do
        self:ProcessKnockback(TaggedEntity)
    end
end

function KnockbackSystem:ProcessKnockback(AttackEntity)
    local Attacker = AttackEntity:Get("Character").Character
    local Target = AttackEntity:Get("TargetCharacter").Character

    local Knockback = AttackEntity:Get("Knockback")
    local Humanoid = Attacker:FindFirstChild("Humanoid")
    local RootPart = Attacker:FindFirstChild("HumanoidRootPart")
    local TargetHumanoid = Target:FindFirstChild("Humanoid")
    local TargetRootPart = Target:FindFirstChild("HumanoidRootPart")

    if Humanoid and RootPart and TargetHumanoid and TargetRootPart then
        task.spawn(function()
            local Direction = Vector3.new()
            local RelativeTo = Knockback.RelativeTo or "Attacker"
            local Velocity = Knockback.Velocity or Vector3.zero()
            local Force = Knockback.Force or 20
            local Duration = Knockback.Duration or 0.1

            if RelativeTo == "Target" then
                Direction = (TargetRootPart.Position - RootPart.Position).Unit
            elseif RelativeTo == "Attacker" then
                Direction = (RootPart.Position - TargetRootPart.Position).Unit
            end

            local VelocityForce = (Direction * Force) + Velocity
            local BodyVelocity = Instance.new("BodyVelocity")
            BodyVelocity.Name = "Knockback"
            BodyVelocity.MaxForce = Vector3.one * 1e6
            BodyVelocity.Velocity = VelocityForce

            if Knockback.Delay then
                task.wait(Knockback.Delay)
            end

            BodyVelocity.Parent = TargetRootPart

            task.delay(Duration, function()
                BodyVelocity:Destroy()
            end)
        end)
    end

    AttackEntity:RemoveComponent("Knockback")
    AttackEntity:AddComponent("KnockedBack", true)
end

return KnockbackSystem