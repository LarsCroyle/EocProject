return {
    --Name = "Parry",
    Action = {
        {0, "PlayAnimation", "Default.ParryAttempt"},
        {0, "PlaySound", "ParryAttempt"},
        {0, "Component", "Add", "Parry", true},
        {15, "Component", "Remove", "Parry"},
        {15, "End"},
        {15, function(self)
            local UserEntity = self.UserEntity
            if not UserEntity:Get("ParrySuccess") then
                UserEntity:AddComponent("FCooldown", true)
                task.delay(1, function()
                    UserEntity:RemoveComponent("FCooldown")
                end)
            else
                UserEntity:RemoveComponent("ParrySuccess")
            end
        end}
    },
    ActionInformation = {
        Active = true,
        IgnoreStun = true,
        --Cooldown = 2,
    }
}