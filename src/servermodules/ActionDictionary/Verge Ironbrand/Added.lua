return {
    Action = {
        {0, "Rig", "__ToolName"},
        {0, function(self)
            local UserEntity = self.UserEntity
            local Character = UserEntity:Get("Character").Character

            Character:WaitForChild("Right Arm").Transparency = 1
        end}
    },
    ActionInformation = {
        Active = false
    }
}