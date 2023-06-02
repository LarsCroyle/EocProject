local GetCommon = require(game.ServerStorage.Modules.Functions.GetCommonMethod)

local StunDecrementSystem = {
    Name = "StunDecrementSystem",
    Priority = "PostAttack",
    Tag = {
        "Character",
        "StunCountdown"
    }
}

function StunDecrementSystem:Update(TaggedEntities)
    for _, TaggedEntity in pairs(TaggedEntities) do
        self:ProcessStunCountdown(TaggedEntity)
    end
end

function StunDecrementSystem:ProcessStunCountdown(UserEntity)
    local StunCountdown = UserEntity:Get("StunCountdown")

    UserEntity:Get("StunCountdown").Countdown = StunCountdown.Countdown - 1/60

    if StunCountdown.Countdown <= 0 then
        UserEntity:RemoveComponent("StunCountdown")
        if UserEntity:Get("StunWalkspeed") then
            UserEntity:RemoveComponent("StunWalkspeed")

            GetCommon("RunClient")({
                UserEntity = UserEntity
            }, self, "AddMovementControl", {
                Name = "Stun",
                Mode = false
            }, UserEntity:Get("Player").Player)
        end
    else
        if not UserEntity:Get("StunWalkspeed") then
            UserEntity:AddComponent("StunWalkspeed", true)

            GetCommon("RunClient")({
                UserEntity = UserEntity
            }, self, "AddMovementControl", {
                MovementControlSet = {
                    MaxWalkSpeedEntries = {
                        6
                    },
                    MaxJumpPowerEntries = {
                        0
                    }
                },
                Name = "Stun",
                Mode = true
            }, UserEntity:Get("Player").Player)
        end
    end
end

return StunDecrementSystem