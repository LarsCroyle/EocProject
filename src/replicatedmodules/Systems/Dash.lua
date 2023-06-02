local Debris = game:GetService("Debris")

local DashSystem = {
    Name = "DashSystem",
    Priority = "PreUpdate",
    Tag = {
        "Input"
    }
}

function DashSystem:Update(TaggedEntities)
    if true then
        return
    end
    for _, TaggedEntity in pairs(TaggedEntities) do
        self:ProcessDoubleJump(TaggedEntity)
    end
end

function DashSystem:PlayAnimation(UserEntity, AnimationId)
    if not UserEntity:Get("AnimationCache") then
        UserEntity:AddComponent("AnimationCache", {})
    end
    local AnimationCache = UserEntity:Get("AnimationCache")
    if not script:FindFirstChild(AnimationId) then
        local Animation = Instance.new("Animation")
        Animation.AnimationId = AnimationId
        Animation.Name = AnimationId
        Animation.Parent = script
    end
    local Animation = script:FindFirstChild(AnimationId)
    if not AnimationCache[AnimationId] then
        AnimationCache[AnimationId] = UserEntity:Get("Character").Humanoid:LoadAnimation(Animation)
    end
    AnimationCache[AnimationId]:Play()
end

function DashSystem:ProcessDoubleJump(InputEntity)
    local Player = InputEntity:Get("Player")
    local Input = InputEntity:Get("Input")
    local InputName = Input.Input
    local Type = Input.InputType

    local Character = Player.Character
    local Humanoid = Character:WaitForChild("Humanoid")
    local UserEntity = self.Workshop:GetEntity(Player.Name .. "UserEntity")

    if InputName == "Q" and Type == "Began" then
        if Humanoid:GetAttribute("DashCooldown") then
            return
        end
        Humanoid:SetAttribute("DashCooldown", true)
        task.delay(1.5, function()
            Humanoid:SetAttribute("DashCooldown", false)
        end)
        if Humanoid.FloorMaterial == Enum.Material.Air then
            self:PlayAnimation(UserEntity, "rbxassetid://13432530882")

            local JumpVelocity = Instance.new("BodyVelocity")
            JumpVelocity.MaxForce = Vector3.one * 100000
            JumpVelocity.P = 40000
            JumpVelocity.Velocity = workspace.CurrentCamera.CFrame.LookVector * 50
            JumpVelocity.Parent = Character.HumanoidRootPart
            game.Debris:AddItem(JumpVelocity, 0.3)
        else
            self:PlayAnimation(UserEntity, "rbxassetid://13432538929")

            local JumpVelocity = Instance.new("BodyVelocity")
            JumpVelocity.MaxForce = Vector3.one * 100000
            JumpVelocity.P = 40000
            JumpVelocity.Velocity = Character.HumanoidRootPart.CFrame.LookVector * 50
            JumpVelocity.Parent = Character.HumanoidRootPart
            game.Debris:AddItem(JumpVelocity, 0.3)
        end
    end
end

return DashSystem