local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Trove = require(ReplicatedStorage.Modules.Packages.Trove)
local Net = require(ReplicatedStorage.Modules.Packages.Net)
local Access = require(ReplicatedStorage.Modules.Recs.Access)
local Workshop = Access.GetWorkshop()

local Player = Players.LocalPlayer
local PlayerGui = Player.PlayerGui
local Mouse = Player:GetMouse()

local Camera = workspace.CurrentCamera

return function(self : Frame, X, Y)
    local UserEntity = Workshop:GetEntity(Player.Name .. "UserEntity")
    local Inventory = UserEntity:Get("Inventory")

    if not Inventory.MenuOpen then
        return
    end

    if self.ItemName.Text == "None" or self.ItemName.Text == "" then
        return
    end

    if UserEntity:Get("HeldInputs") and UserEntity:Get("HeldInputs").LeftControl then
        local From = self.Parent.Name
        local To

        if From == "Items" and not Inventory.ChestOpen then
            To = "Hotbar"
        elseif From == "Hotbar" then
            To = "Items"
        elseif From == "ChestItems" then
            To = "Inventory"
        end

        if From ~= "ChestItems" and Inventory.ChestOpen then
            To = "ChestItems"
        end

        Net:RemoteEvent("ClientUpdateInventory"):FireServer("TransferItem", {
            From = From,
            To = To,
            OldIndex = tonumber(self:FindFirstChild("Number").Text)
        })
        return
    end

    local DragTrove = Trove.new()

    RunService:UnbindFromRenderStep("DraggingItem")

    local Clone = DragTrove:Add(self:Clone())

    Clone.Size = UDim2.fromOffset(self.AbsoluteSize.X, self.AbsoluteSize.Y)
    Clone.AnchorPoint = Vector2.new(0.5, 0)
    Clone.Parent = Player.PlayerGui:WaitForChild("MainOverlay")

    local FlavorTextHoverElement = Clone:FindFirstChild("FlavorTextHoverElement")
    if FlavorTextHoverElement then
        FlavorTextHoverElement.Visible = false
    end

    local OldFlavorTextHoverElement = self:FindFirstChild("FlavorTextHoverElement")
    if OldFlavorTextHoverElement then
        OldFlavorTextHoverElement.Visible = false
    end

    self.ItemName.Visible = false
    if self:FindFirstChild("Equipped") then
        self.Equipped.Transparency = 1
    end

    RunService:BindToRenderStep("DraggingItem", Enum.RenderPriority.Input.Value, function()
        local MousePosition = Vector2.new(Mouse.X, Mouse.Y)
        local ViewExtents = Camera.ViewportSize

        local RelativeScale = MousePosition / ViewExtents
        Clone.Position = UDim2.fromScale(RelativeScale.X, RelativeScale.Y)
    end)

    DragTrove:Add(function()
        self.ItemName.Visible = true
        if self:FindFirstChild("Equipped") then
            self.Equipped.Transparency = 0
        end
        RunService:UnbindFromRenderStep("DraggingItem")
    end)

    DragTrove:Add(Clone.Dragger.MouseButton1Up:Connect(function()
        DragTrove:Destroy()

        local GuiObjects = PlayerGui:GetGuiObjectsAtPosition(Mouse.X, Mouse.Y)
        for _, Object in pairs(GuiObjects) do
            if Object:GetAttribute("ItemContainer") and Object.Parent then
                Net:RemoteEvent("ClientUpdateInventory"):FireServer("TransferItem", {
                    From = self.Parent.Name,
                    To = Object.Parent.Name,

                    OldIndex = tonumber(self:FindFirstChild("Number").Text),
                    NewIndex = tonumber(Object:FindFirstChild("Number").Text)
                })
                return
            end
        end
    end))
end