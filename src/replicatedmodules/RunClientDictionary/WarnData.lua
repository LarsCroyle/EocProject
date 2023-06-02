local Player = game:GetService("Players").LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

return function(Arguments)
    local Message = Arguments.Message
    local MainGui = PlayerGui:WaitForChild("MainOverlay"):WaitForChild("Main")

    local Message = Instance.new("TextLabel")
    Message.Name = "Message"
    Message.Text = Message
    Message.TextColor3 = Color3.fromRGB(255, 255, 255)
    Message.TextScaled = true
    Message.BackgroundTransparency = 1
    Message.Size = UDim2.new(0.2, 0, 0.08, 0)
    Message.Position = UDim2.new(0.5, 0, 0.1, 0)
    Message.AnchorPoint = Vector2.new(0.5, 0.5)
    Message.Parent = MainGui

    task.delay(2, function()
        Message:Destroy()
    end)
end