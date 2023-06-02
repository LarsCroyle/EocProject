local Ragdoll = require(game.ServerStorage.Modules.Classes.Ragdoll)

local RagdollBuilderSystem = {
    Name = "RagdollBuilderSystem",
    Priority = "Update",
    Tag = {
        "Player",
        "SaveData",
        "Character",
        "!RagdollInstance",
    }
}

function RagdollBuilderSystem:Update(TaggedEntities)
    for _, EntityObject in pairs(TaggedEntities) do
        self:ProcessUserEntity(EntityObject)
    end
end

function RagdollBuilderSystem:ProcessUserEntity(UserEntity)
    local RagdollExists = UserEntity:Get("RagdollInstance")
    if RagdollExists then
        return
    end
    local Character = UserEntity:Get("Character").Character

    local RagdollInstance = Ragdoll.new(Character)

    UserEntity:AddComponent("RagdollInstance", RagdollInstance)
end

return RagdollBuilderSystem