local Fusion = require(game.ReplicatedStorage.Modules.Packages.Fusion)
local New = Fusion.New
local Children = Fusion.Children
local Computed = Fusion.Computed
local HotbarItem = require(script.Parent.HotbarItem)

return function(Values)
    local HotbarValue = Values.Hotbar
    local ItemsValue = Values.Items
    local EquippedValue = Values.Equipped

    local Hotbar = New "Frame" {
        Name = "Hotbar",
        BackgroundTransparency = 1,
        Size = UDim2.new(0.45, 0, 0.05, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.9, 0),
        BackgroundColor3 = Color3.fromRGB(65, 65, 65),
        Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("MainOverlay"):WaitForChild("Main"),
        [Children] = {
            New "UIListLayout" {
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                SortOrder = Enum.SortOrder.Name,
                Padding = UDim.new(0.01, 0)
            }
        }
    }

    for i = 1, 10 do
        local ComputedItemName = Computed(function()
            local Hotbar = HotbarValue:get()
            local Item = Hotbar[i]
            if not Item then
                return "None"
            end
            return Item.Name
        end)
        local ComputedEquipped = Computed(function()
            if ComputedItemName:get() == "None" then
                return false
            end
            return EquippedValue:get() == i
        end)
        local ComputedRarity = Computed(function()
            local Hotbar = HotbarValue:get()
            local Item = Hotbar[i]
            if not Item then
                return "Common"
            end
            return Item.Rarity or "Common"
        end)
        HotbarItem {
            Position = i,
            ItemName = ComputedItemName,
            Equipped = ComputedEquipped,
            Rarity = ComputedRarity,
            MenuOpen = Values.MenuOpen,
            Parent = Hotbar
        }
    end

    return Hotbar
end