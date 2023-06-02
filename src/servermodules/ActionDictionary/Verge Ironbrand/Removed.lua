return {
    Action = {
        {0, "ConfigureMovementAnimations", "Default"},
        {0, "DestroyRig", "__ToolName"},
        {0, function(self)
            local UserEntity = self.UserEntity
            local Character = UserEntity:Get("Character").Character

            Character:WaitForChild("Right Arm").Transparency = 0
        end}
    },
    ActionInformation = {
        Active = false
    }
}