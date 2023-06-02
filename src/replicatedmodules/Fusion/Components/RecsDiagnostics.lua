local Fusion = require(game.ReplicatedStorage.Modules.Packages.Fusion)
local New = Fusion.New
local Children = Fusion.Children

return New "Frame" {
    Name = "RecsDiagnostics",
    Size = UDim2.new(0.2, 0, 0.6, 0),
    Position = UDim2.new(0.8, 0, 0.2, 0),
    BackgroundTransparency = 0.5,
    BackgroundColor3 = Color3.fromRGB(0, 0, 0),
    Visible = false,
    [Children] = {
        New "ScrollingFrame" {
            Name = "EntityList",
            Size = UDim2.new(0.5, 0, 1, 0),
            Position = UDim2.new(0.5, 0, 0, 0),
            BackgroundTransparency = 0.5,
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            [Children] = {
                New "UIListLayout" {
                    SortOrder = Enum.SortOrder.Name
                },
                New "UIPadding" {
                    PaddingLeft = UDim.new(0, 5),
                    PaddingRight = UDim.new(0, 5),
                    PaddingTop = UDim.new(0, 5),
                    PaddingBottom = UDim.new(0, 5)
                }
            }
        },
        New "ScrollingFrame" {
            Name = "ServerEntityList",
            Size = UDim2.new(0.5, 0, 1, 0),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 0.5,
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            [Children] = {
                New "UIListLayout" {
                    SortOrder = Enum.SortOrder.Name
                },
                New "UIPadding" {
                    PaddingLeft = UDim.new(0, 5),
                    PaddingRight = UDim.new(0, 5),
                    PaddingTop = UDim.new(0, 5),
                    PaddingBottom = UDim.new(0, 5)
                }
            }
        }
    }
}