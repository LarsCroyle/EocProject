local Debris = game:GetService("Debris")

local DoubleJumpSystem = {
    Name = "DoubleJumpSystem",
    Priority = "PreUpdate",
    Tag = {
        "Input"
    }
}

function DoubleJumpSystem:Update(TaggedEntities)
    if true then
        return
    end
    for _, TaggedEntity in pairs(TaggedEntities) do
        self:ProcessDoubleJump(TaggedEntity)
    end
end

function DoubleJumpSystem:PlayAnimation(UserEntity, AnimationId)
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

function DoubleJumpSystem:ProcessDoubleJump(InputEntity)
    local Player = InputEntity:Get("Player")
    local Input = InputEntity:Get("Input")
    local InputName = Input.Input
    local Type = Input.InputType

    local Character = Player.Character
    local Humanoid = Character:WaitForChild("Humanoid")
    local UserEntity = self.Workshop:GetEntity(Player.Name .. "UserEntity")

    if InputName == "Space" and Type == "Began" then
        if Humanoid.FloorMaterial ~= Enum.Material.Air then
            return
        end

        local JumpCount = Character:GetAttribute("JumpCount") or 0

        if JumpCount == 0 then
            self:PlayAnimation(UserEntity, "rbxassetid://13422261235")

            local JumpVelocity = Instance.new("BodyVelocity")
            JumpVelocity.MaxForce = Vector3.new(0, 500000, 0)
            JumpVelocity.P = 40000
            JumpVelocity.Velocity = Vector3.new(0, 50, 0)
            JumpVelocity.Parent = Character.HumanoidRootPart
            game.Debris:AddItem(JumpVelocity, 0.05)

            Character:SetAttribute("JumpCount", 1)

            local Connection; Connection = Character.Humanoid.FreeFalling:Connect(function(Active)
                if not Active then
                    Character:SetAttribute("JumpCount", 0)
                    Connection:Disconnect()
                end
            end)
        end
    end
end

return DoubleJumpSystem