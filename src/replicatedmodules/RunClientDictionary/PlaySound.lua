return function(Arguments)
    local Parent = Arguments.Parent or game.Workspace
    local SoundId = Arguments.SoundId or 0
    local Volume = Arguments.Volume or 1
    local Pitch = Arguments.Pitch or 1
    local Loop = Arguments.Loop or false
    local RemoveOnFinish = Arguments.RemoveOnFinish or true

    if SoundId == 0 then
        return
    end

    local Sound = Instance.new("Sound")
    Sound.SoundId = "rbxassetid://" .. SoundId
    Sound.Volume = Volume
    Sound.PlaybackSpeed = Pitch
    Sound.Looped = Loop

    Sound.Parent = Parent

    Sound:Play()

    if RemoveOnFinish then
        Sound.Ended:Wait()
        Sound:Destroy()
    end

end