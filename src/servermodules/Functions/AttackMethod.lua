local Access = require(game.ReplicatedStorage.Modules.Recs.Access)
local Workshop = Access.GetWorkshop()
local GetUserEntityFromCharacter = require(game.ServerStorage.Modules.Functions.GetUserEntityFromCharacter)

return function(Data)
    local UserEntity = Data.UserEntity
    local Character = Data.Character
    local AttackInformation = Data.AttackInformation
    local Target = Data.Target

    local TargetUserEntity = GetUserEntityFromCharacter(Target)

    local UserEntityNpc = UserEntity:Get("Npc")
    local TargetUserEntityNpc = TargetUserEntity:Get("Npc")

    if UserEntityNpc and TargetUserEntityNpc then
        if UserEntityNpc.Name == TargetUserEntityNpc.Name then
            return
        end
    end

    if TargetUserEntity:Get("Knockdowned") then
        return
    end

    local AttackEntity = Workshop:CreateEntity({
        EntityName = "Attack"
    })
    local Attack = AttackInformation.Attack

    AttackEntity:AddComponent("Attack", {})
    AttackEntity:AddComponent("Character", {
        Character = Character
    })
    AttackEntity:AddComponent("UserEntity", {
        UserEntity = UserEntity
    })

    for ComponentName, ComponentData in pairs(Attack) do
        AttackEntity:AddComponent(ComponentName, ComponentData)
    end

    AttackEntity:AddComponent("TargetCharacter", {
        Character = Target
    })

    AttackEntity:AddComponent("TargetUserEntity", TargetUserEntity)

    Workshop:SpawnEntity(AttackEntity)

    return {
        Target = Target,
        TargetEntity = TargetUserEntity
    }
end