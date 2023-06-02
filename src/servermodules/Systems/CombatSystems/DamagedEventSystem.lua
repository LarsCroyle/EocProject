local ParseActionFrameArguments = require(game.ServerStorage.Modules.Functions.ParseActionFrameArgumentsMethod)
local GetSound = require(game.ServerStorage.Modules.Functions.GetSound)

local DamageEventSystem = {
    Name = "DamageEventSystem",
    Priority = "PostAttack",
    Tag = {
        "Character",
        "TargetCharacter",
        "DamageEvents",
        "Damaged"
    }
}

function DamageEventSystem:Update(TaggedEntities)
    for _, TaggedEntity in pairs(TaggedEntities) do
        self:ProcessDamageEvents(TaggedEntity)
    end
end

function DamageEventSystem:ProcessDamageEvents(AttackEntity)
    local Attacker = AttackEntity:Get("Character")
    local Target = AttackEntity:Get("TargetCharacter")

    local UserEntity = self.Workshop:GetEntity(Attacker.Character.Name .. "UserEntity")
    local TargetEntity = self.Workshop:GetEntity(Target.Character.Name .. "UserEntity")

    local AttackEvents = AttackEntity:Get("DamageEvents")
    for _, AttackEvent in pairs(AttackEvents) do
        local Call = AttackEvent.Call
        local Arguments = AttackEvent.Arguments

        Arguments = ParseActionFrameArguments({
            Attacker = Attacker.Character,
            Target = Target.Character
        }, Arguments)

        local RunClient = self.Workshop:CreateEntity()
        :AddComponent("RunClient", {
            Target = AttackEvent.Target or "All",
            Call = Call,
            Arguments = Arguments
        })
        self.Workshop:SpawnEntity(RunClient)
    end

    AttackEntity:RemoveComponent("DamageEvents")
end

return DamageEventSystem