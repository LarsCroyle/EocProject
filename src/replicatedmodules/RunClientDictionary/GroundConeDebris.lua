local TweenService = game:GetService("TweenService")
local Params = RaycastParams.new()
Params.FilterType = Enum.RaycastFilterType.Include
Params.FilterDescendantsInstances = {workspace.Map}
Params.IgnoreWater = true

return function(Arguments)
    local Character = Arguments.Character
    local Amount = Arguments.Amount
    local Range = Arguments.Range
    local Lifetime = Arguments.Lifetime
    local SpreadAngle = Arguments.SpreadAngle

    local RootPart = Character:FindFirstChild("HumanoidRootPart")
    local Origin = RootPart.CFrame * CFrame.Angles(0, math.rad(SpreadAngle), 0)

    local function Rocks()
        for i = 1, Amount do
            local RockOrigin = Origin * CFrame.new(0, 0, -i * Range / Amount)

            local Rock = Instance.new("Part")
            Rock.Name = "Rock"
            Rock.Size = Vector3.zero
            Rock.Anchored = true

            TweenService:Create(Rock, TweenInfo.new(0.3, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out, 0, false, i * 0.01), {Size = Vector3.new(0.5, 0.5, 0.5) * Random.new():NextNumber(0.5, 3)}):Play()

            local Ray = workspace:Raycast(RockOrigin.Position, Vector3.new(0, -1, 0) * 100, Params)

            if Ray and Ray.Instance then
                Rock.CFrame = CFrame.new(Ray.Position) * CFrame.Angles(math.rad(math.random(0, 360)), math.rad(math.random(0, 360)), math.rad(math.random(0, 360)))
                Rock.Material = Ray.Material
                Rock.Color = Ray.Instance.Color
            else
                Rock.CFrame = RockOrigin
            end

            Rock.Parent = workspace.Effects

            task.delay(Lifetime + i * 0.05, function()
                TweenService:Create(Rock, TweenInfo.new(0.5), {Size = Vector3.zero}):Play()
                game.Debris:AddItem(Rock, 0.5)
            end)
        end
    end

    Rocks()

    SpreadAngle = -SpreadAngle
    Origin = RootPart.CFrame * CFrame.Angles(0, math.rad(SpreadAngle), 0)

    Rocks()
end