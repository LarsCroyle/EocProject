local StunCountdownBuildSystem = {
    Name = "StunCountdownBuildSystem",
    Priority = "PostAttack",
    Tag = {
        "SaveData",
        "Character",
        "Stun"
    }
}

function StunCountdownBuildSystem:Update(TaggedEntities)
    for _, TaggedEntity in pairs(TaggedEntities) do
        self:ProcessStunCountdownBuild(TaggedEntity)
    end
end

function StunCountdownBuildSystem:ProcessStunCountdownBuild(UserEntity)
    local Stun = UserEntity:Get("Stun")
    local StunCountdown = UserEntity:Get("StunCountdown")

    if StunCountdown == nil then
        UserEntity:AddComponent("StunCountdown", {
            Countdown = Stun.Duration
        })
    else
        UserEntity:Set("StunCountdown", "Countdown", Stun.Duration)
    end

    UserEntity:RemoveComponent("Stun")
end

return StunCountdownBuildSystem