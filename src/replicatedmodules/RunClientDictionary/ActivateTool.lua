local TweenService = game:GetService("TweenService")
local Player = game:GetService("Players").LocalPlayer

return function(Arguments)
    local Index = Arguments.Index

    local PlayerGui = Player:WaitForChild("PlayerGui")
    local MainOverlay = PlayerGui:WaitForChild("MainOverlay")
    local Main = MainOverlay:WaitForChild("Main")
    local Hotbar = Main:WaitForChild("Hotbar")

    if Index < 1 or Index > 10 then
        return
    end

    if Index < 10 then
        Index = "0" .. Index
    end

    local Item = Hotbar:WaitForChild("Item" .. Index)
    if not Item then
        return
    end
    local ItemName = Item:WaitForChild("ItemName")
    if not ItemName then
        return
    end

    if ItemName.Text == "None" then
        return
    end

    local Highlight = Instance.new("Frame")
    Highlight.Name = "Highlight"
    Highlight.Size = UDim2.new(1, 0, 1, 0)
    Highlight.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Highlight.BackgroundTransparency = 0.5
    Highlight.BorderSizePixel = 0
    Highlight.Parent = Item

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0.1, 0)
    UICorner.Parent = Highlight

    local Tween = TweenService:Create(Highlight, TweenInfo.new(0.35, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
        BackgroundTransparency = 1,
        Size = UDim2.new(1.1, 0, 1.1, 0)
    })

    Tween:Play()

    local Connection; Connection = Tween.Completed:Connect(function()
        Highlight:Destroy()
        Connection:Disconnect()
    end)
end