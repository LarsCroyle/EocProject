local ServerStorage = game:GetService("ServerStorage")
local CharacterCreatorSystem = {
    Name = "CharacterCreator",
    Priority = "Update",
    Tag = {
        "SaveData",
        "Character",
        "CharacterCreationSettings",
        "!CharacterCreationApplied"
    }
}

function CharacterCreatorSystem:Update(TaggedEntities)
    for _, TaggedEntity in TaggedEntities do
        self:ProcessUserEntity(TaggedEntity)
    end
end

function CharacterCreatorSystem:ApplyRace(UserEntity, Race, VariantName)
    local Character = UserEntity:Get("Character").Character
    local RaceFolder = ServerStorage.Modules.Functions.Races:FindFirstChild(Race)
    if not RaceFolder then
        return
    end

    local RaceVariant = RaceFolder:FindFirstChild(VariantName)
    if not RaceVariant then
        return
    end

    local RaceApplicationFunction = require(RaceVariant)
    task.delay(0.2, function()
        RaceApplicationFunction(Character)
    end)

    UserEntity:AddComponent("Race", {
        RaceName = Race,
        VariantName = VariantName
    })
end

function CharacterCreatorSystem:ProcessUserEntity(UserEntity)
    local CharacterCreationSettings = UserEntity:Get("CharacterCreationSettings")
    local Character = UserEntity:Get("Character").Character
    local CharacterTrove = UserEntity:Get("CharacterTrove")

    local Race, Variant = CharacterCreationSettings.Race, CharacterCreationSettings.Variant
    if Race and Variant then
        self:ApplyRace(UserEntity, Race, Variant)
    end

    local _, Disconnector = UserEntity:AddComponent("CharacterCreationApplied", true)
    CharacterTrove:Add(Disconnector)
end

return CharacterCreatorSystem