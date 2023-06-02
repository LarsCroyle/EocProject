local SprintSpeedController = {
    Name = "SprintSpeedController",
    Priority = "PostUpdate",
    Tag = {
        "Sprinting",
        "!SprintWalkSpeed"
    }
}

function SprintSpeedController:Update(TaggedEntities)
    for _, TaggedEntity in pairs(TaggedEntities) do
        self:ProcessEntity(TaggedEntity)
    end
end

function SprintSpeedController:ProcessEntity(UserEntity)
    local MovementControls = UserEntity:Get("MovementControls")
    local MinWalkSpeedEntries = MovementControls.MinWalkSpeedEntries

    local SprintWalkSpeed = Instance.new("NumberValue")
    SprintWalkSpeed.Name = "SprintWalkSpeed"
    SprintWalkSpeed.Value = 22
    SprintWalkSpeed.Parent = script

    table.insert(MinWalkSpeedEntries, SprintWalkSpeed)

    UserEntity:AddComponent("SprintWalkSpeed", SprintWalkSpeed)
end

return SprintSpeedController