local NpcTrackingSystem = {
    Name = "NpcTrackingSystem",
    Priority = "Update",
    Tag = {
        "Npc",
        "NpcTracking"
    }
}

function NpcTrackingSystem:Update(TaggedEntities)
    for _, TaggedEntity in pairs(TaggedEntities) do
        self:ProcessNpc(TaggedEntity)
    end
end

function NpcTrackingSystem:ProcessNpc(NpcUserEntity)
    local Character = NpcUserEntity:Get("Character").Character
    local NpcTracking = NpcUserEntity:Get("NpcTracking")

    local Target = NpcTracking.Target

    local TargetPosition = Target.PrimaryPart.Position

    local Humanoid = Character:FindFirstChild("Humanoid")

    Humanoid:MoveTo(TargetPosition)
end

return NpcTrackingSystem