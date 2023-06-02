local UserInputService = game:GetService("UserInputService")

local AimCamera = {
    Name = "AimCamera",
    Priority = "PostUpdate",
    Tag = {
        "Camera",
        "IsAiming"
    }
}

local AIM_CAMERA_OFFSET = Vector3.new(2.5, 2, 4)
local AIM_CAMERA_OFFSET_LERP = 0.5

function AimCamera:Update(TaggedEntities)
    for _, TaggedEntity in pairs(TaggedEntities) do
        self:ProcessEntity(TaggedEntity)
    end
end

local function Lerp(a, b, t)
    return a + (b - a) * t
end

function AimCamera:ProcessEntity(UserEntity)
    local Camera = UserEntity:Get("Camera")
    local IsAiming = UserEntity:Get("IsAiming")
    local Character = UserEntity:Get("Character").Character
    local RootPart = Character.HumanoidRootPart

    Camera.FieldOfView = Lerp(Camera.FieldOfView, IsAiming and 40 or 70, IsAiming and 0.1 or 0.25)
    --Camera.CFrame = Camera.CFrame:Lerp(RootPart.CFrame * CFrame.new(AIM_CAMERA_OFFSET), AIM_CAMERA_OFFSET_LERP)

    --if MouseDelta.X ~= 0 or MouseDelta.Y ~= 0 then
    --    Camera.CFrame = Camera.CFrame * CFrame.Angles(0, math.rad(-MouseDelta.X * 0.2), 0)
    --end
end

return AimCamera