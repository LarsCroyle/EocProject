local Access = require(game.ReplicatedStorage.Modules.Recs.Access)
local Workshop = Access.GetWorkshop()

return function(Call, Arguments, Target)
    local RunClientEntity = Workshop:CreateEntity()

    RunClientEntity:AddComponent("RunClient", {
        Call = Call,
        Arguments = Arguments,
        Target = Target
    })

    Workshop:SpawnEntity(RunClientEntity)

    return RunClientEntity
end