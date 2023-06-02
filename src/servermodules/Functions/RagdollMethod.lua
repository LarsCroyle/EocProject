local Access = require(game.ReplicatedStorage.Modules.Recs.Access)
local Workshop = Access.GetWorkshop()

return function(Data)
    local Target = Data.Target
    local TargetRagdoll = Data.TargetRagdoll
    local TargetUserEntity = Data.TargetUserEntity
    local TargetHumanoid = Target.Character:FindFirstChild("Humanoid")
    local Mode = Data.Mode

    if Mode then
        local RunClientEntity = Workshop:CreateEntity()
        RunClientEntity:AddComponent("RunClient", {
            Target = "All",
            Call = "RagdollState",
            Arguments = {
                Character = Target.Character,
                Mode = "Ragdolled"
            }
        })
        Workshop:SpawnEntity(RunClientEntity)

        TargetHumanoid.AutoRotate = false

        if TargetUserEntity:Get("Player").Player:IsA("Player") then
            TargetHumanoid:ChangeState(Enum.HumanoidStateType.Physics)
        end

        task.defer(function()
            TargetRagdoll:Enable()
        end)
    else
        task.defer(function()
            TargetRagdoll:Disable()
        end)

        local RunClientEntity = Workshop:CreateEntity()
        RunClientEntity:AddComponent("RunClient", {
            Target = "All",
            Call = "RagdollState",
            Arguments = {
                Character = Target.Character,
                Mode = "Normal"
            }
        })
        Workshop:SpawnEntity(RunClientEntity)

        TargetHumanoid:ChangeState(Enum.HumanoidStateType.Running)
        TargetHumanoid.AutoRotate = true

        local Player = TargetUserEntity:Get("Player").Player
        if Player and Player:IsA("Player") then
            local RunClientEntity = Workshop:CreateEntity()
            RunClientEntity:AddComponent("RunClient", {
                Target = TargetUserEntity:Get("Player").Player,
                Call = "RagdollState",
                Arguments = {
                    Character = Target.Character,
                    Mode = "Normal"
                }
            })
            Workshop:SpawnEntity(RunClientEntity)
        end
    end
end