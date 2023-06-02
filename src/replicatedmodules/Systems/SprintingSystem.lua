local SprintingSystem = {
    Name = "SprintingSystem",
    Priority = "Update",
    Tag = {
        "Input"
    }
}

function SprintingSystem:Update(TaggedEntities)
    for _, TaggedEntity in pairs(TaggedEntities) do
        self:ProcessInput(TaggedEntity)
    end
end

function SprintingSystem:ProcessInput(InputEntity)
    local Player = InputEntity:Get("Player")
    local Input = InputEntity:Get("Input")
    local InputName = Input.Input
    local Type = Input.InputType

    local UserEntity = self.Workshop:GetEntity(Player.Name .. "UserEntity")

    if InputName == "W" then
        if Type == "Began" then
            if not UserEntity:Get("TimeOfLastWKeyPress") then
                UserEntity:AddComponent("TimeOfLastWKeyPress", 0)
            end
            local TimeSinceLastInput = os.clock() - UserEntity:Get("TimeOfLastWKeyPress")
            UserEntity:SetComponent("TimeOfLastWKeyPress", os.clock())
            if TimeSinceLastInput < 0.2 then
                if not UserEntity:Get("Sprinting") then
                    UserEntity:AddComponent("Sprinting", true)
                end
            end
        else
            if UserEntity:Get("Sprinting") then
                UserEntity:RemoveComponent("Sprinting")

                local SprintWalkSpeed = UserEntity:Get("SprintWalkSpeed")
                local MovementControls = UserEntity:Get("MovementControls")

                for Index, MinWalkSpeedEntry in pairs(MovementControls.MinWalkSpeedEntries) do
                    if MinWalkSpeedEntry == SprintWalkSpeed then
                        table.remove(MovementControls.MinWalkSpeedEntries, Index)
                    end
                end

                SprintWalkSpeed:Destroy()
                UserEntity:RemoveComponent("SprintWalkSpeed")
            end
        end
    end
end

return SprintingSystem