local Access = require(game.ReplicatedStorage.Modules.Recs.Access)
local Workshop = Access.GetWorkshop()

return function(self, SequenceSystem, ...)
    local Call, Arguments, Target = ...

    if not Target then
        Target = "All"
    end

    local RunClientEntity = Workshop:CreateEntity()

    --if typeof(Target) == "Instance" then
    --    if not Target:IsA("Player") then
    --        return
    --    end
    --end

    RunClientEntity:AddComponent("RunClient", {
        Call = Call,
        Arguments = Arguments,
        Target = Target
    })

    Workshop:SpawnEntity(RunClientEntity)

    return RunClientEntity
end