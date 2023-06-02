local Fusion = require(game.ReplicatedStorage.Modules.Packages.Fusion)
local New = Fusion.New
local Children = Fusion.Children
local Computed = Fusion.Computed

return function(Values)
    local EntityName = Values.EntityName
    local EntityComponents = Values.EntityComponents
    local TextColor = Values.TextColor

    return New "Frame" {
        Name = EntityName,
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 0.9,
        BackgroundColor3 = Color3.fromRGB(189, 189, 189),
        [Children] =  {
            New "TextLabel" {
                Name = "EntityName",
                Size = UDim2.new(0.9, 0, 0.9, 0),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(0.5, 0, 0.5, 0),
                BackgroundTransparency = 1,
                Text = EntityName,
                TextColor3 = TextColor or Color3.fromRGB(255, 255, 255),
                Font = Enum.Font.SourceSans,
                TextScaled = true,
                TextXAlignment = Enum.TextXAlignment.Left,
                [Children] = {
                    New "UIStroke" {
                        Color = Color3.fromRGB(0, 0, 0),
                        Thickness = 1
                    }
                }
            }
        }
    }
end