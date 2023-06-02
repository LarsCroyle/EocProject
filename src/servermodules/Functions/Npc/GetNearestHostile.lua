return function(HostileList, Npc)
    local NearestHostile = nil
    local NearestHostileDistance

    for _, HostileCharacter in pairs(HostileList) do
        local HostileHumanoid = HostileCharacter:FindFirstChild("Humanoid")

        if HostileHumanoid then
            if HostileHumanoid.Health <= 0 then
                table.remove(HostileList, _)
                continue
            end
            local HostileDistance = (HostileCharacter.PrimaryPart.Position - Npc.PrimaryPart.Position).Magnitude
            if not NearestHostile or HostileDistance < NearestHostileDistance then
                NearestHostile = HostileCharacter
                NearestHostileDistance = HostileDistance
            end
        else
            table.remove(HostileList, _)
        end
    end

    return NearestHostile, NearestHostileDistance
end