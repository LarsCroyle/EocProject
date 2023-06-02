local Fusion = require(game.ReplicatedStorage.Modules.Packages.Fusion)
local New = Fusion.New
local Children = Fusion.Children
local Computed = Fusion.Computed

return function(Values)
    local Race = Values.Race

    local CharacterMenu = New "Frame" {
        Name = "CharacterMenu",
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0),
        ZIndex = 2,
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        Visible = true,
        [Children] = {
            New "ScrollingFrame" {
                Name = "FirstNames",
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Size = UDim2.new(0.5, 0, 1, 0),
            }
        }
    }

end