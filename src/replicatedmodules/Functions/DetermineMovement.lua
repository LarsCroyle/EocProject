return function(MovementControls)
    local MaxWalkSpeedEntries = MovementControls.MaxWalkSpeedEntries
    local MaxJumpPowerEntries = MovementControls.MaxJumpPowerEntries

    local MinWalkSpeedEntries = MovementControls.MinWalkSpeedEntries
    local MinJumpPowerEntries = MovementControls.MinJumpPowerEntries

    local CalculatedWalkSpeed = 16
    local CalculatedJumpPower = 50

    for _, MinWalkSpeedEntry in pairs(MinWalkSpeedEntries) do
        if MinWalkSpeedEntry.Value > CalculatedWalkSpeed then
            CalculatedWalkSpeed = MinWalkSpeedEntry.Value
        end
    end

    for _, MaxWalkSpeedEntry in pairs(MaxWalkSpeedEntries) do
        if MaxWalkSpeedEntry.Value < CalculatedWalkSpeed then
            CalculatedWalkSpeed = MaxWalkSpeedEntry.Value
        end
    end

    for _, MinJumpPowerEntry in pairs(MinJumpPowerEntries) do
        if MinJumpPowerEntry.Value > CalculatedJumpPower then
            CalculatedJumpPower = MinJumpPowerEntry.Value
        end
    end

    for _, MaxJumpPowerEntry in pairs(MaxJumpPowerEntries) do
        if MaxJumpPowerEntry.Value < CalculatedJumpPower then
            CalculatedJumpPower = MaxJumpPowerEntry.Value
        end
    end

    return CalculatedWalkSpeed, CalculatedJumpPower
end