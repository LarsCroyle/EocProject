local Fusion = require(game.ReplicatedStorage.Modules.Packages.Fusion)
local New = Fusion.New
local Children = Fusion.Children
local Computed = Fusion.Computed
local Tween = Fusion.Tween

return function(Values)
    local ComputedHealthbarAmountSize = Computed(function()
        local Health = Values.Health:get()
        local MaxHealth = Values.MaxHealth:get()
        return UDim2.new(Health / MaxHealth, 0, 1, 0)
    end)

    local TweenedHealthbarAmountSize = Tween(ComputedHealthbarAmountSize, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out))
    local TweenedDelayedHealthbarAmountSize = Tween(ComputedHealthbarAmountSize, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0.3))

    local Healthbar = New "Frame" {
        Name = "Healthbar",
        BackgroundTransparency = 1,
        Size = UDim2.new(0.2, 0, 0.02, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.85, 0),
        Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("MainOverlay"):WaitForChild("Main"),

        [Children] = {
            New "Frame" {
                Name = "HealthbarBackground",
                BackgroundTransparency = 0.5,
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundColor3 = Color3.fromRGB(65, 65, 65),
                BorderSizePixel = 0,
                [Children] = {
                    New "Frame" {
                        Name = "HealthbarAmount",
                        BackgroundTransparency = 0,
                        Size = TweenedHealthbarAmountSize,
                        BackgroundColor3 = Color3.fromRGB(255, 134, 21),
                        [Children] = {
                            New "UIGradient" {
                                Color = ColorSequence.new {
                                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 0))
                                },
                                Rotation = 90
                            },
                            New "UICorner" {
                                CornerRadius = UDim.new(0.1, 0)
                            }
                        }
                    },
                    New "Frame" {
                        Name = "GhostHealthbarAmount",
                        BackgroundTransparency = 0.5,
                        Size = TweenedDelayedHealthbarAmountSize,
                        BackgroundColor3 = Color3.fromRGB(126, 74, 26),
                        ZIndex = -1,
                        [Children] = {
                            New "UIGradient" {
                                Color = ColorSequence.new {
                                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 0))
                                },
                                Rotation = 90
                            },
                            New "UICorner" {
                                CornerRadius = UDim.new(0.1, 0)
                            }
                        }
                    },
                    New "UIStroke" {
                        Color = Color3.fromRGB(0, 0, 0),
                        Thickness = 1
                    },
                    New "UICorner" {
                        CornerRadius = UDim.new(0.1, 0)
                    },
                    New "ImageLabel" {
                        Name = "BorderFrame",
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 1, 0),
                        Image = "rbxassetid://13569133231",
                        ScaleType = Enum.ScaleType.Stretch,
                        ZIndex = 2
                    }
                }
            }
        }
    }

    return Healthbar
end