return function(UserEntity, Arguments)
    local Mode = Arguments.Mode
    local MovementControlSet = Arguments.MovementControlSet
    local MovementControlSetIdentifier = Arguments.Name

    local MovementControls = UserEntity:Get("MovementControls")

    if not MovementControls then
        return
    end

    if Mode == true then
        for EntrySet, EntrySetTable in pairs(MovementControls) do
            local EntrySetEquivalent = MovementControlSet[EntrySet]

            if not EntrySetEquivalent then
                continue
            end

            for _, Addition in pairs(EntrySetEquivalent) do
                local Value = Instance.new("NumberValue")
                Value.Name = MovementControlSetIdentifier
                Value.Value = Addition
                Value.Parent = script

                table.insert(EntrySetTable, Value)
            end
        end
    else
        for i, v in pairs(script:GetChildren()) do
            if v.Name == MovementControlSetIdentifier then
                v:Destroy()
                for EntrySet, EntrySetTable in pairs(MovementControls) do
                    for i, Entry in pairs(EntrySetTable) do
                        if Entry == v then
                            table.remove(EntrySetTable, i)
                        end
                    end
                end
            end
        end
    end
end