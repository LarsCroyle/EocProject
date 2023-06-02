local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

local SmoothMouseLockFollowSystem = {
    Name = "SmoothMouseLockFollowSystem",
    Priority = "Update",
    Tag = {
        "Character",
        "SmoothMouseLockFollow"
    }
}

function SmoothMouseLockFollowSystem:Update(TaggedEntities)
    for _, TaggedEntity in pairs(TaggedEntities) do
        self:ProcessEntity(TaggedEntity)
    end
end

function SmoothMouseLockFollowSystem:ProcessEntity(UserEntity)
    local Character = UserEntity:Get("Character")
    local RootPart = Character.RootPart
    local BodyGyro = UserEntity:Get("SmoothMouseLockFollow").BodyGyro
    if UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter then
        BodyGyro.MaxTorque = Vector3.one * 1e6
        local X, Y, Z = Camera.CFrame:ToEulerAnglesYXZ()
        BodyGyro.CFrame = CFrame.new(RootPart.Position) * CFrame.fromEulerAnglesYXZ(0, Y, 0)
    else
        BodyGyro.MaxTorque = Vector3.zero
    end
end

return SmoothMouseLockFollowSystem