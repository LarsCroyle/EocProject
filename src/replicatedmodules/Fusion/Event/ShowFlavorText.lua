local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Fusion = require(ReplicatedStorage.Modules.Packages.Fusion)
local Value = Fusion.Value
local Observer = Fusion.Observer

local FlavorTextHoverElement = require(script.Parent.Parent.Components.FlavorTextHoverElement)
local FlavorTextData = script.Parent.Parent.Data.FlavorText
local Access = require(ReplicatedStorage.Modules.Recs.Access)
local Workshop = Access.GetWorkshop()

local Player = Players.LocalPlayer
local FlavorTextCache = {}

local function GetFlavorText(Identifier)
    if FlavorTextCache[Identifier] then
        return FlavorTextCache[Identifier]
    end
    local FlavorTextDataModule = FlavorTextData:FindFirstChild(Identifier)
    if not FlavorTextDataModule then
        return
    end
    local FlavorText = require(FlavorTextDataModule)
    FlavorTextCache[Identifier] = FlavorText
    return FlavorText
end

return function(GuiObject, Identifier, Hovering, MenuOpenValue)
    local UserEntity = Workshop:GetEntity(Player.Name .. "UserEntity")
    local Inventory = UserEntity:Get("Inventory")
    if not Inventory.MenuOpen then
        return
    end
    if Identifier == "None" or Identifier == "" then
        return
    end
    if not GuiObject.Visible then
        return
    end

    local ItemName = GuiObject:FindFirstChild("ItemName")
    if ItemName and not ItemName.Visible and Hovering then
        return
    end
    local FlavorText = GetFlavorText(Identifier)

    if not FlavorText then
        return
    end

    if UserEntity:Get("HeldInputs") and UserEntity:Get("HeldInputs").LeftControl and Hovering == true then
        return
    end

    local HoverFlavorText = FlavorText.Hover

    if not HoverFlavorText then
        return
    end

    local FlavorTextObject = GuiObject:FindFirstChild("FlavorTextHoverElement")

    if not FlavorTextObject then
        local FlavorTextValue = Value(HoverFlavorText)

        FlavorTextObject = FlavorTextHoverElement {
            FlavorText = FlavorTextValue,
            ItemName = GuiObject:FindFirstChild("ItemName").Text,
            RarityColor = GuiObject:FindFirstChild("ItemName").TextColor3,
        }
        FlavorTextObject.Parent = GuiObject
    end

    FlavorTextObject.ItemName.Text = GuiObject:FindFirstChild("ItemName").Text

    FlavorTextObject.LargeBorderColor.UIStroke.Color = GuiObject:FindFirstChild("ItemName").TextColor3
    FlavorTextObject.SmallBorderColor.UIStroke.Color = GuiObject:FindFirstChild("ItemName").TextColor3

    local ParentOfParent = GuiObject.Parent

    if ParentOfParent.Name == "Hotbar" then
        FlavorTextObject.Position = UDim2.new(0.5, 0, -4.1, 0)
    end

    FlavorTextObject.Description.Text = HoverFlavorText

    if Hovering then
        GuiObject.ZIndex = 2
        FlavorTextObject.Visible = true
    else
        GuiObject.ZIndex = 1
        FlavorTextObject.Visible = false
    end

    if MenuOpenValue then
        local MenuOpenObserver = Observer(MenuOpenValue)
        local Disconnect; Disconnect = MenuOpenObserver:onChange(function()
            if not MenuOpenValue:get() then
                print("Menu closed, hiding flavor text")
                FlavorTextObject.Visible = false
                Disconnect()
            end
        end)
        local VisibilityChangedConnection; VisibilityChangedConnection = FlavorTextObject:GetPropertyChangedSignal("Visible"):Connect(function()
            if not GuiObject.Visible then
                Disconnect()
                VisibilityChangedConnection:Disconnect()
                print("Cleaning up FlavorTextHoverElement connections")
            end
        end)
    end
end