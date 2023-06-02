local NpcBehaviorDictionary = require(game.ServerStorage.Modules.NpcBehaviors)
local TableUtil = require(game.ReplicatedStorage.Modules.Packages.TableUtil)

local NpcBehaviorAssignmentSystem = {
    Name = "NpcBehaviorAssignmentSystem",
    Priority = "Update",
    Tag = {
        "SaveData",
        "Npc",
        "Character",
        "!NpcBehavior"
    }
}

function NpcBehaviorAssignmentSystem:Update(TaggedEntities)
    for _, TaggedEntity in pairs(TaggedEntities) do
        self:HandleNpc(TaggedEntity)
    end
end

function NpcBehaviorAssignmentSystem:HandleNpc(NpcUserEntity)
    local NpcComponent = NpcUserEntity:Get("Npc")
    local NpcName = NpcComponent.Name

    local NpcBehaviorDataSet = NpcBehaviorDictionary.GetNpcBehaviorDataSet(NpcName)

    if NpcBehaviorDataSet then
        local NpcBehavior = NpcBehaviorDataSet.Behavior.new(NpcUserEntity)

        if NpcBehavior.Boot then
            NpcBehavior:Boot()
        end

        if NpcBehavior.Animated then
            local NpcMovementAnimationSet = NpcBehavior.MovementAnimationSet
            if NpcMovementAnimationSet then
                NpcUserEntity:AddComponent("MovementAnimationSet", TableUtil.Reconcile(NpcMovementAnimationSet, {
                    Walk = "rbxassetid://13221454168",
                    Sprint = "rbxassetid://13221735100",
                    Jump = "rbxassetid://125750702",
                    Fall = "rbxassetid://180436148",
                    Sit = "rbxassetid://178130996",
                    Idle = "rbxassetid://13221448557"
                }))
            else
                NpcUserEntity:AddComponent("MovementAnimationSet", {
                    Walk = "rbxassetid://13221454168",
                    Sprint = "rbxassetid://13221735100",
                    Jump = "rbxassetid://125750702",
                    Fall = "rbxassetid://180436148",
                    Sit = "rbxassetid://178130996",
                    Idle = "rbxassetid://13221448557"
                })
            end
        end

        NpcUserEntity:AddComponent("NpcBehavior", NpcBehavior)
    else
        NpcUserEntity:AddComponent("NpcBehavior", "None")
    end
end

return NpcBehaviorAssignmentSystem