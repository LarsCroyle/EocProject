local MovementSoundSystem = {
    Name = "MovementSoundSystem",
    Priority = "Update",
    Tag = {
        "Character",
        "MovementAnimationSet",
        "AnimationCache"
    }
}

function MovementSoundSystem:Update(TaggedEntities)
    for _, TaggedEntity in TaggedEntities do
        self:ProcessUserEntity(TaggedEntity)
    end
end

local SpecialArmorSounds = {
    ["Rat Shinguards"] = {
        ["Left"] = {
            "rbxassetid://13584190427"
        },
        ["Right"] = {
            "rbxassetid://13584190357"
        }
    }
}

function MovementSoundSystem:ProcessUserEntity(UserEntity)
    local MovementAnimationSet = UserEntity:Get("MovementAnimationSet")
    local AnimationCache = UserEntity:Get("AnimationCache")
    local Inventory = UserEntity:Get("Inventory")
    local Armor = Inventory.Armor

    local Character = UserEntity:Get("Character").Character

    local MovementSoundSet = MovementAnimationSet.MovementSoundSet
    local State = MovementAnimationSet.CurrentState

    if State ~= "Walk" and State ~= "Sprint" then
        if MovementAnimationSet.SoundConnection then
            MovementAnimationSet.SoundConnection.Connection:Disconnect()
            MovementAnimationSet.SoundConnection = nil
        end
        return
    end

    if MovementAnimationSet.SoundConnection then
        if MovementAnimationSet.SoundConnection.Name == State then
            return
        end

        MovementAnimationSet.SoundConnection.Connection:Disconnect()
        MovementAnimationSet.SoundConnection = nil
    end

    if not MovementSoundSet then
        return
    end

    if not MovementAnimationSet.SoundConnection then
        local MovementSoundEventConnection = MovementAnimationSet.CurrentPlayingAnimation:GetMarkerReachedSignal("Step"):Connect(function(Side)
            local FloorMaterial = Character.Humanoid.FloorMaterial
            local MaterialSoundSet = MovementSoundSet[FloorMaterial.Name]
            if not MaterialSoundSet then
                return
            end

            local RandomId = MaterialSoundSet[math.random(1, #MaterialSoundSet)]
            local Sound = Instance.new("Sound")

            if MovementSoundSet.LastSoundId and MovementSoundSet.LastSoundId == RandomId then
                Sound.PlaybackSpeed = Random.new():NextNumber(0.9, 1.1)
            end

            MovementSoundSet.LastSoundId = RandomId

            Sound.Volume = 0.8
            Sound.SoundId = RandomId
            Sound.Parent = Character.PrimaryPart

            Sound:Play()

            local Connection; Connection = Sound.Ended:Connect(function()
                Sound:Destroy()
                Connection:Disconnect()
            end)

            if State == "Sprint" and SpecialArmorSounds[Armor.Legs] then
                local SpecialArmorSoundSet = SpecialArmorSounds[Armor.Legs]
                local SpecialArmorSound = SpecialArmorSoundSet[Side]
                if SpecialArmorSound then
                    local RandomId = SpecialArmorSound[math.random(1, #SpecialArmorSound)]
                    local SpecialSound = Instance.new("Sound")

                    SpecialSound.PlaybackSpeed = Random.new():NextNumber(0.9, 1.1)
                    SpecialSound.SoundId = RandomId
                    SpecialSound.Volume = 0.2
                    SpecialSound.Parent = Character.PrimaryPart
                    SpecialSound:Play()

                    local SpecialConnection; SpecialConnection = SpecialSound.Ended:Connect(function()
                        SpecialSound:Destroy()
                        SpecialConnection:Disconnect()
                    end)
                end
            end
        end)

        MovementAnimationSet.SoundConnection = {
            Name = State,
            Connection = MovementSoundEventConnection
        }
    end
end

return MovementSoundSystem