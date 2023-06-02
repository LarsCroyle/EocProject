local Trove = require(game.ReplicatedStorage.Modules.Packages.Trove)
return function(Data)
    local Trove = Trove.new()
    local Target = Data.Target
    local Origin = Data.Origin or Data.CFrame
    local Particle = Data.Particle or Data.Object
    local LookAt = Data.LookAt
    local AttachTo = Data.AttachTo
    local Enabled = Data.Enabled

    if typeof(Particle) == "string" then
        Particle = game.ReplicatedStorage.Assets.Particles:FindFirstChild(Particle)
    end

    if not Particle then
        return
    end

    Particle = Particle:Clone()
    Trove:Add(Particle)

    if Target and not Origin then
        local Torso = Target.Torso
        Origin = Torso.CFrame
    end

    if typeof(Origin) ~= "CFrame" and typeof(Origin) ~= "Vector3" and Origin:IsA("BasePart") then
        Origin = Origin.CFrame
    end

    if Data.Offset then
        Origin = Origin * Data.Offset
    end

    if Particle:IsA("BasePart") then
        Particle.CanCollide = false
        if not AttachTo then
            Particle.Anchored = true
        else
            Particle.Anchored = false
        end
        Particle.CanCollide = false
        Particle.Massless = true
        Particle.Transparency = 1
        Particle.Parent = workspace.Effects
    elseif Particle:IsA("Attachment") then
        Particle.Parent = workspace.Terrain
    end

    if AttachTo then
        if Particle:IsA("BasePart") then
            local Object = AttachTo.Object
            local Offset = AttachTo.Offset

            if Object:IsA("Model") then
                local Torso = Target.Torso
                Object = Torso
            end

            Particle.CFrame = Object.CFrame

            local Weld = Instance.new("Weld")
            Weld.Part0 = Object
            Weld.Part1 = Particle
            if Offset then
                Weld.C0 = Offset
            end
            Weld.Parent = Particle
        end
    end

    if LookAt then
        if LookAt:IsA("Model") then
            local Torso = LookAt.Torso
            LookAt = Torso.Position
        end

        if typeof(LookAt) == "CFrame" then
            LookAt = LookAt.Position
        end

        Particle.CFrame = CFrame.lookAt(Origin.Position, Vector3.new(LookAt.X, Origin.Position.Y, LookAt.Z))
    else
        Particle.CFrame = Origin
    end

    local MaxLifetime = 0

    for Index, Child in pairs(Particle:GetDescendants()) do
        if Child:IsA("ParticleEmitter") then
            local Lifetime = Child.Lifetime.Max / Child.TimeScale

            if MaxLifetime < Lifetime then
                MaxLifetime = Lifetime
            end

            if not Enabled then
                local EmitCount = Child:GetAttribute("EmitCount")
                if EmitCount and typeof(EmitCount) == "number" then
                    Child:Emit(EmitCount)
                end
            else
                local EnabledTime = Enabled
                Child.Enabled = true
                --Particle.Anchored = false
                task.delay(EnabledTime, function()
                    Child.Enabled = false
                    game.Debris:AddItem(Child, MaxLifetime)
                end)
            end
        end
    end

    local Clock = os.clock()
    local Now = os.clock()

    if Enabled then
        MaxLifetime = MaxLifetime + Enabled
    end

    while Now - Clock < MaxLifetime do
        task.wait()
        Now = os.clock()
    end

    Trove:Destroy()
end