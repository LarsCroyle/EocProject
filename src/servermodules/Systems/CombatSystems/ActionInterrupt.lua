local ActionInterruptSystem = {
    Name = "ActionInterruptSystem",
    Priority = "PostAttack",
    Tag = {
        "Character",
        "TargetCharacter",
        "Stun"
    }
}

function ActionInterruptSystem:Update(TaggedEntities)
    for _, TaggedEntity in pairs(TaggedEntities) do
        self:ProcessAction(TaggedEntity)
    end
end

function ActionInterruptSystem:ProcessAction(TaggedEntity)
    local TargetUserEntity = TaggedEntity:Get("TargetUserEntity")

    local TargetActionSequence = TargetUserEntity:Get("ActionSequence")

    if TargetActionSequence then
        if not TargetActionSequence.Action.ActionInformation.Interruptable then
            return
        end

        TargetUserEntity:Get("ActionSequence").Action.Interrupted = true

        local SubSequences = TargetActionSequence.SubSequences
        if SubSequences then
            for _, SubSequence in pairs(SubSequences) do
                SubSequence:Stop()
            end
        end

        TargetActionSequence:Stop()
    end
end

return ActionInterruptSystem