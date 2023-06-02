--[[
    Used to automatically move the sequence to a specific frame if a specific input is no longer held.
    Generally intended as a shorthand for "held" moves that have a "release" condition.

    {0, "ConditionalInputSkip", "Input", 25}
--]]
return function(self, SequenceSystem, MoveData, ...)
    local UserEntity = self.UserEntity
    local Character = UserEntity:Get("Character").Character
    local Ability = UserEntity:Get("Ability").AbilityName
    local Trove = MoveData.Trove

    local Input, FrameToSkipTo = ...
    local HeldInputChanged = UserEntity:Get("InputHeld").HeldInputChanged
    local IsInputHeld = UserEntity:Get("InputHeld")[Input]
    if IsInputHeld then
        self:MoveTo(FrameToSkipTo)
    end

    local Connection; Connection = HeldInputChanged:Connect(function(InputName, IsHeld)
        if InputName == Input and IsHeld then
            self:MoveTo(FrameToSkipTo)
            Connection:Disconnect()
        end
    end)

    Trove:Add(Connection)
end