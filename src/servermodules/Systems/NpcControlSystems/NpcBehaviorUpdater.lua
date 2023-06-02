local NpcBehaviorUpdater = {
    Name = "NpcBehaviorUpdater",
    Priority = "Update",
    Tag = {
        "NpcBehavior"
    }
}

function NpcBehaviorUpdater:Update(TaggedEntities)
    for _, TaggedEntity in pairs(TaggedEntities) do
        self:UpdateNpcBehavior(TaggedEntity)
    end
end

function NpcBehaviorUpdater:UpdateNpcBehavior(NpcUserEntity)
    local NpcBehavior = NpcUserEntity:Get("NpcBehavior")
    if NpcBehavior == "None" then
        return
    end
    if not NpcBehavior.Update then
        return
    end
    NpcBehavior:Update()
end

return NpcBehaviorUpdater