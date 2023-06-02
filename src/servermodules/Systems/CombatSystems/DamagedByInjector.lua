local DamagedByInjector = {
    Name = "DamagedByInjector",
    Priority = "PostAttack",
    Tag = {
        "Character",
        "TargetCharacter",
        "Damaged"
    }
}

function DamagedByInjector:Update(TaggedEntities)
    for _, TaggedEntity in pairs(TaggedEntities) do
        self:ProcessDamaged(TaggedEntity)
    end
end

function DamagedByInjector:ProcessDamaged(DamagedEntity)
    local Character = DamagedEntity:Get("Character").Character
    local TargetUserEntity = DamagedEntity:Get("TargetUserEntity")

    if TargetUserEntity then
        local TargetDamagedBy = TargetUserEntity:Get("DamagedBy")

        if not TargetDamagedBy then
            TargetUserEntity:AddComponent("DamagedBy", {})
            TargetDamagedBy = TargetUserEntity:Get("DamagedBy")
        end

        if table.find(TargetDamagedBy, Character) then
            return
        end

        table.insert(TargetDamagedBy, Character)

        task.defer(function()
            for i = 1, 3 do
                game:GetService("RunService").Heartbeat:Wait()
            end
            table.remove(TargetDamagedBy, table.find(TargetDamagedBy, Character))
        end)
    end
end

return DamagedByInjector