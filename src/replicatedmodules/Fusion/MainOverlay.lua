local Access = require(game.ReplicatedStorage.Modules.Recs.Access)
local Workshop = Access.GetWorkshop()

return function(Fusion)
    local Player = game:GetService("Players").LocalPlayer
    local PlayerGui = Player:WaitForChild("PlayerGui")

    local New = Fusion.New
    local Children = Fusion.Children

    local MainOverlay = New "ScreenGui" {
        Name = "MainOverlay",
        IgnoreGuiInset = true,
        ResetOnSpawn = false,
        Parent = PlayerGui,
        [Children] = {
            New "Frame" {
                Name = "Main",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
            }
        }
    }
end