local RunService = game:GetService("RunService")
local ServerAssets = game:GetService("ServerStorage").Assets
local CinderiteAssetFolder = ServerAssets.Races.Infernus.Cinderite

return function(Character)
    RunService.Heartbeat:Wait()

    local HeadParticles = CinderiteAssetFolder.HeadParticles:Clone()
    for _, Particle in pairs(HeadParticles:GetChildren()) do
        Particle.Parent = Character.Head
    end
    HeadParticles:Destroy()

    if Character:FindFirstChild("BodyColors") then
        Character.BodyColors:Destroy()
    end

    if Character.Head:FindFirstChild("Mesh") then
        Character.Head:FindFirstChild("Mesh"):Destroy()
        Character.Head.Size = Vector3.new(1, 1, 1)
    end

    local PointLight = CinderiteAssetFolder.PointLight:Clone()
    PointLight.Parent = Character.Head

    local Highlight = CinderiteAssetFolder.Highlight:Clone()
    Highlight.Parent = Character

    local RightEye = CinderiteAssetFolder.Eyes.RightEye:Clone()
    RightEye.Parent = Character.Head

    local LeftEye = CinderiteAssetFolder.Eyes.LeftEye:Clone()
    LeftEye.Parent = Character.Head

    if Character.Head:FindFirstChild("face") then
        Character.Head.face:Destroy()
    end

    for i, v in pairs(Character:GetChildren()) do
        if v:IsA("Accessory") then
            v:Destroy()
        end
        if v:IsA("Shirt") then
            v:Destroy()
        end
        if v:IsA("Pants") then
            v:Destroy()
        end
    end

    local ChildAddedConnection; ChildAddedConnection = Character.ChildAdded:Connect(function(Child)
        game:GetService("RunService").Heartbeat:Wait()
        if Child:IsA("Accessory") then
            Child:Destroy()
        end
        if Child:IsA("BodyColors") then
            Child:Destroy()
        end
        if Child:IsA("Shirt") then
            Child:Destroy()
        end
        if Child:IsA("Pants") then
            Child:Destroy()
        end
    end)

    local CharacterRemovingConnection; CharacterRemovingConnection = Character.AncestryChanged:Connect(function(_, Parent)
        if not Parent then
            ChildAddedConnection:Disconnect()
            CharacterRemovingConnection:Disconnect()
        end
    end)

    task.wait(0.2)

    for _, Part in pairs(Character:GetChildren()) do
        if Part:IsA("BasePart") then
            Part.Color = Color3.fromRGB(255, 86, 8)
            Part.Material = Enum.Material.Neon

            local Fire = CinderiteAssetFolder.Fire:Clone()
            Fire.Parent = Part
        end
    end
end