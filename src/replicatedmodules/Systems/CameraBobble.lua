local CameraBobbleSystem = {
    Name = "CameraBobbleSystem",
    Priority = "Update",
    Tag = {
        "Character",
        "Camera"
    }
}

local BOBBLE_SPEED = 8

function CameraBobbleSystem:Update(TaggedEntities)
    for _, TaggedEntity in pairs(TaggedEntities) do
        self:ProcessEntity(TaggedEntity)
    end
end

function CameraBobbleSystem:ProcessEntity(UserEntity)
    local Character = UserEntity:Get("Character")
    local Camera = UserEntity:Get("Camera")
    local RootPart = Character.RootPart

    local CurrentTime = tick()
    local Velocity = RootPart.Velocity

    Camera.CFrame = Camera.CFrame:Lerp(Camera.CFrame * CFrame.Angles(0, 0, math.rad(0.3 * math.sin(CurrentTime * BOBBLE_SPEED) * Velocity.Magnitude)), 0.1)
end

return CameraBobbleSystem