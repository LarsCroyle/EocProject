return function(Arguments)
    local Parent = Arguments.Parent or game.Workspace
    local SoundId = Arguments.SoundId or 0

    SoundId = "rbxassetid://" .. SoundId

    for _, Sound in pairs(Parent:GetChildren()) do
        if Sound:IsA("Sound") and Sound.SoundId == SoundId then
            Sound:Stop()
        end
    end
end