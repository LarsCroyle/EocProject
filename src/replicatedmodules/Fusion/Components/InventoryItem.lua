local Fusion = require(game.ReplicatedStorage.Modules.Packages.Fusion)
local New = Fusion.New
local Computed = Fusion.Computed
local Children = Fusion.Children
local OnEvent = Fusion.OnEvent
local DraggingItem = require(script.Parent.Parent.Event.DraggingItem)
local ShowFlavorText = require(script.Parent.Parent.Event.ShowFlavorText)

return function(Props)
    if Props.Position < 10 then
        Props.Position = "0" .. Props.Position
    end
    local Rarity = Props.Rarity

    local RarityColor = Computed(function()
        local Colors = {
            ["Common"] = Color3.fromRGB(255, 255, 255),
            ["Uncommon"] = Color3.fromRGB(0, 255, 0),
            ["Rare"] = Color3.fromRGB(0, 0, 255),
            ["Epic"] = Color3.fromRGB(255, 0, 255),
            ["Legendary"] = Color3.fromRGB(255, 255, 0),
            ["Mythical"] = Color3.fromRGB(255, 0, 0),
        }

        return Colors[Rarity:get()]
    end)

    local InventoryItem;
    InventoryItem = New "Frame" {
        Name = "Item" .. Props.Position,
        BackgroundTransparency = 0.5,
        Size = UDim2.new(0.08, 0, 1, 0),
        BackgroundColor3 = RarityColor,
        Parent = Props.Parent,
        [Children] = {
            New "TextLabel" {
                Name = "Number",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0.1, 0),
                Text = Props.Position,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextScaled = true,
                Font = Enum.Font.Bodoni,
                Visible = false,
                [Children] = {
                    New "UIStroke" {
                        Color = Color3.fromRGB(0, 0, 0),
                        Thickness = 1
                    }
                }
            },
            New "TextLabel" {
                Name = "ItemName",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0.7, 0),
                Text = Props.ItemName,
                TextColor3 = RarityColor,
                Position = UDim2.new(0, 0, 0.3, 0),
                TextScaled = true,
                Font = Enum.Font.Bodoni,
                [Children] = {
                    New "UIStroke" {
                        Color = Color3.fromRGB(0, 0, 0),
                        Thickness = 1
                    }
                }
            },
            --New "UIStroke" {
            --    Name = "Equipped",
            --    Color = RarityColor,
            --    Thickness = 2,
            --    Enabled = Props.Equipped,
            --},
            New "UIGradient" {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(27, 27, 27)),
                    ColorSequenceKeypoint.new(0.4, Color3.fromRGB(94, 94, 94)),
                    ColorSequenceKeypoint.new(0.65, Color3.fromRGB(94, 94, 94)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(27, 27, 27))
                }),
                Transparency = NumberSequence.new(0.4)
            },
            New "UICorner" {
                CornerRadius = UDim.new(0.15, 0)
            },
            New "TextButton" {
                Name = "Dragger",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Text = "",
                [OnEvent "MouseButton1Down"] = function(X, Y)
                    DraggingItem(InventoryItem, X, Y)
                end,
                [OnEvent "MouseEnter"] = function()
                    ShowFlavorText(InventoryItem, Props.ItemName:get(), true, Props.MenuOpen)
                end,
                [OnEvent "MouseLeave"] = function()
                    ShowFlavorText(InventoryItem, Props.ItemName:get(), false)
                end,
            },
            New "ImageLabel" {
                Name = "BorderFrame",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Image = "rbxassetid://13568502985",
                ScaleType = Enum.ScaleType.Fit,
                ZIndex = -1
            }
        }
    }

    InventoryItem:SetAttribute("ItemContainer", true)

    return InventoryItem
end