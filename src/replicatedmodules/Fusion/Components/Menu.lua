local Fusion = require(game.ReplicatedStorage.Modules.Packages.Fusion)
local New = Fusion.New
local Children = Fusion.Children
local Computed = Fusion.Computed
local InventoryItem = require(script.Parent.InventoryItem)

return function(Values)
    local Items = Values.Items
    local ChestItems = Values.ChestItems

    local MenuOpen = Values.MenuOpen
    local ChestOpen = Values.ChestOpen

    local Menu = New("Frame") {
        Name = "Items",
        Size = UDim2.new(0.38, 0, 0.3, 0),
        Position = UDim2.fromScale(0.05, 0.05),
        BackgroundTransparency = 0.75,
        BackgroundColor3 = Color3.fromRGB(77, 60, 226),
        Visible = MenuOpen,
        Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("MainOverlay"),
        [Children] = {
            New("UIGridLayout") {
                CellSize = UDim2.fromScale(0.0754, 0.169),
                CellPadding = UDim2.new(0, 10, 0, 10),
                SortOrder = Enum.SortOrder.Name,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                VerticalAlignment = Enum.VerticalAlignment.Center
            },
            --New "UICorner" {
            --    CornerRadius = UDim.new(0, 10)
            --},
            New "UIStroke" {
                Color = Color3.fromRGB(199, 188, 123),
                Thickness = 1
            },
            New "UIGradient" {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(128, 128, 128)),
                    ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(0.65, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(128, 128, 128))
                }),
                Transparency = NumberSequence.new(0.4),
                Rotation = 90
            }
        }
    }

    local ChestMenu = New("Frame") {
        Name = "ChestItems",
        Size = UDim2.new(0.38, 0, 0.1, 0),
        Position = UDim2.fromScale(0.05, 0.38),
        BackgroundTransparency = 0.75,
        BackgroundColor3 = Color3.fromRGB(77, 60, 226),
        Visible = ChestOpen,
        Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("MainOverlay"),
        [Children] = {
            New("UIGridLayout") {
                CellSize = UDim2.fromScale(0.0754, 0.509),
                CellPadding = UDim2.new(0, 10, 0, 10),
                SortOrder = Enum.SortOrder.Name,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                VerticalAlignment = Enum.VerticalAlignment.Center
            },
            --New "UICorner" {
            --    CornerRadius = UDim.new(0, 10)
            --},
            New "UIStroke" {
                Color = Color3.fromRGB(199, 188, 123),
                Thickness = 1
            },
            New "UIGradient" {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(128, 128, 128)),
                    ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(0.65, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(128, 128, 128))
                }),
                Transparency = NumberSequence.new(0.4),
                Rotation = 90
            }
        }
    }

    for i = 1, 50 do
        local ComputedItemName = Computed(function()
            local Items = Items:get()
            local Item = Items[i]
            if not Item then
                return ""
            end
            if Item.Name == "None" then
                return ""
            end

            return Item.Name
        end)

        local ComputedRarity = Computed(function()
            local Items = Items:get()
            local Item = Items[i]
            if not Item then
                return "Common"
            end
            return Item.Rarity or "Common"
        end)

        InventoryItem {
            Position = i,
            ItemName = ComputedItemName,
            Rarity = ComputedRarity,
            MenuOpen = MenuOpen,
            Parent = Menu
        }
    end

    for i = 1, 10 do
        local ComputedItemName = Computed(function()
            local Items = ChestItems:get()
            local Item = Items[i]
            if not Item then
                return ""
            end
            if Item.Name == "None" then
                return ""
            end

            return Item.Name or ""
        end)

        local ComputedRarity = Computed(function()
            local Items = ChestItems:get()
            local Item = Items[i]
            if not Item then
                return "Common"
            end
            return Item.Rarity or "Common"
        end)

        InventoryItem {
            Position = i,
            ItemName = ComputedItemName,
            Rarity = ComputedRarity,
            MenuOpen = MenuOpen,
            Parent = ChestMenu
        }
    end

    return Menu
end