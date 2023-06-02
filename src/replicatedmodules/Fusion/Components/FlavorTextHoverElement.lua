local Fusion = require(game.ReplicatedStorage.Modules.Packages.Fusion)
local New = Fusion.New
local Children = Fusion.Children
local Computed = Fusion.Computed

return function(Props)

    local FlavorTextInQuotes = Computed(function()
        return "\"" .. Props.FlavorText:get() .. "\""
    end)
    local RarityColor = Props.RarityColor

    local FlavorTextHoverElement;
    FlavorTextHoverElement = New "ImageLabel" {
        Name = "FlavorTextHoverElement",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 189, 0, 230.5),
        Position = UDim2.new(0.5, 0, 1, 0),
        AnchorPoint = Vector2.new(0.5, 0),
        ScaleType = Enum.ScaleType.Fit,
        Image = "rbxassetid://13594229761",
        ZIndex = 5,
        [Children] = {
            New "Frame" {
                Name = "LargeBorderColor",
                Size = UDim2.fromScale(0.779, 0.978),
                Position = UDim2.fromScale(0.104, 0),
                BackgroundTransparency = 1,
                [Children] = {
                    New "UICorner" {
                        CornerRadius = UDim.new(0.08, 0)
                    },
                    New "UIStroke" {
                        Color = RarityColor,
                        Thickness = 4,
                        [Children] = {
                            New "UIGradient" {
                                Transparency = NumberSequence.new({
                                    NumberSequenceKeypoint.new(0, 1),
                                    NumberSequenceKeypoint.new(0.03, 1),
                                    NumberSequenceKeypoint.new(0.5, 0.869),
                                    NumberSequenceKeypoint.new(0.97, 1),
                                    NumberSequenceKeypoint.new(1, 1)
                                })
                            }
                        }
                    }
                }
            },
            New "Frame" {
                Name = "SmallBorderColor",
                Size = UDim2.fromScale(0.779, 0.978),
                Position = UDim2.fromScale(0.104, 0),
                BackgroundTransparency = 1,
                [Children] = {
                    New "UICorner" {
                        CornerRadius = UDim.new(0.08, 0)
                    },
                    New "UIStroke" {
                        Color = RarityColor,
                        Thickness = 1,
                        [Children] = {
                            New "UIGradient" {
                                Transparency = NumberSequence.new({
                                    NumberSequenceKeypoint.new(0, 1),
                                    NumberSequenceKeypoint.new(0.03, 0.2),
                                    NumberSequenceKeypoint.new(0.3, 0.25),
                                    NumberSequenceKeypoint.new(0.5, 1),
                                    NumberSequenceKeypoint.new(0.7, 0.25),
                                    NumberSequenceKeypoint.new(0.97, 0.2),
                                    NumberSequenceKeypoint.new(1, 1)
                                })
                            }
                        }
                    }
                }
            },
            New "ImageLabel" {
                Name = "MasteryProgress",
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(0, 0.065),
                Position = UDim2.fromScale(0.184, 0.772),
                Image = "rbxassetid://13594279201",
            },
            New "TextLabel" {
                Name = "Description",
                BackgroundTransparency = 1,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.489, 0.46),
                Size = UDim2.fromScale(0.68, 0.557),
                FontFace = Font.fromId(12187368843),
                Text = Props.FlavorText,
                TextColor3 = Color3.fromRGB(184, 168, 154),
                TextScaled = false,
                TextSize = 12,
                TextYAlignment = Enum.TextYAlignment.Top,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true,
                [Children] = {
                    New "UIGradient" {
                        Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                            ColorSequenceKeypoint.new(0.0536, Color3.fromRGB(255, 255, 255)),
                            ColorSequenceKeypoint.new(0.765, Color3.fromRGB(130, 130, 130)),
                            ColorSequenceKeypoint.new(0.794, Color3.fromRGB(255, 255, 255)),
                            ColorSequenceKeypoint.new(0.888, Color3.fromRGB(255, 255, 255)),
                            ColorSequenceKeypoint.new(0.92, Color3.fromRGB(130, 130, 130)),
                            ColorSequenceKeypoint.new(1, Color3.fromRGB(130, 130, 130)),
                        }),
                        Rotation = 90
                    },
                    New "UIStroke" {
                        Color = Color3.fromRGB(86, 79, 72),
                        Thickness = 1
                    }
                }
            },
            New "TextLabel" {
                Name = "MasteryPercentage",
                BackgroundTransparency = 1,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.486, 0.886),
                Size = UDim2.fromScale(0.5, 0.067),
                FontFace = Font.fromId(12187368843),
                Text = "0% Mastery",
                TextColor3 = Color3.fromRGB(184, 168, 154),
                TextScaled = true,
                [Children] = {
                    New "UIGradient" {
                        Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                            ColorSequenceKeypoint.new(0.0536, Color3.fromRGB(255, 255, 255)),
                            ColorSequenceKeypoint.new(0.765, Color3.fromRGB(130, 130, 130)),
                            ColorSequenceKeypoint.new(0.794, Color3.fromRGB(255, 255, 255)),
                            ColorSequenceKeypoint.new(0.888, Color3.fromRGB(255, 255, 255)),
                            ColorSequenceKeypoint.new(0.92, Color3.fromRGB(130, 130, 130)),
                            ColorSequenceKeypoint.new(1, Color3.fromRGB(130, 130, 130)),
                        }),
                        Rotation = 90
                    },
                    New "UIStroke" {
                        Color = Color3.fromRGB(86, 79, 72),
                        Thickness = 1
                    }
                }
            },
            New "TextLabel" {
                Name = "ItemName",
                BackgroundTransparency = 1,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.486, 0.09),
                Size = UDim2.fromScale(0.5, 0.094),
                FontFace = Font.fromId(12187368843),
                Text = "Item Name",
                TextColor3 = Color3.fromRGB(184, 168, 154),
                TextScaled = true,
                [Children] = {
                    New "UIGradient" {
                        Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                            ColorSequenceKeypoint.new(0.0536, Color3.fromRGB(255, 255, 255)),
                            ColorSequenceKeypoint.new(0.765, Color3.fromRGB(130, 130, 130)),
                            ColorSequenceKeypoint.new(0.794, Color3.fromRGB(255, 255, 255)),
                            ColorSequenceKeypoint.new(0.888, Color3.fromRGB(255, 255, 255)),
                            ColorSequenceKeypoint.new(0.92, Color3.fromRGB(130, 130, 130)),
                            ColorSequenceKeypoint.new(1, Color3.fromRGB(130, 130, 130)),
                        }),
                        Rotation = 90
                    },
                    New "UIStroke" {
                        Color = Color3.fromRGB(86, 79, 72),
                        Thickness = 1
                    }
                }
            }
        }
    }

    return FlavorTextHoverElement
end