local AttackEntityCleanerSystem = {
    Name = "AttackEntityCleanerSystem",
    Priority = "AttackCleanup",
    Tag = {
        "Attack",
        "!AttackCleanup"
    }
}

function AttackEntityCleanerSystem:Update(TaggedEntities)
    for _, AttackEntity in pairs(TaggedEntities) do
        AttackEntity:AddComponent("AttackCleanup", true)
        task.defer(function()
            for i = 1, 2 do
                game:GetService("RunService").Heartbeat:Wait()
            end
            self.Workshop:RemoveEntity(AttackEntity.Name)
        end)
    end
end

return AttackEntityCleanerSystem