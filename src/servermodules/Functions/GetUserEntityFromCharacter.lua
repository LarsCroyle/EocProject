local Access = require(game.ReplicatedStorage.Modules.Recs.Access)
local Workshop = Access.GetWorkshop()

return function(Character)
    local Entities = Workshop:GetEntities()

    for _, Entity in pairs(Entities) do
        local CharacterComponent = Entity:Get("Character")
        if typeof(CharacterComponent) ~= "table" then
            continue
        end
        if CharacterComponent then
            if CharacterComponent.Character == Character then
                if not Entity:Get("SaveData") then
                    continue
                end
                return Entity
            end
        end
    end
end