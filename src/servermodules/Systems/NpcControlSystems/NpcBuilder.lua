local Players = game:GetService("Players")

local NpcBuilderSystem = {
    Name = "NpcBuilderSystem",
    Priority = "Update",
    Tag = {
        "TAG_NO_TAG"
    }
}

function NpcBuilderSystem:Boot()
    local Characters = workspace.Characters:GetChildren()

    for _, Character in pairs(Characters) do
        if not game.Players:GetPlayerFromCharacter(Character) then
            self:ProcessNpc(Character)
        end
    end
end

function NpcBuilderSystem:ProcessNpc(Character)
    if not Character:FindFirstChild("Humanoid") then
        return
    end

    local NpcEntity = self.Workshop:CreateEntity({
        EntityName = Character.Name .. "UserEntity"
    })
    NpcEntity:AddComponent("Player", {
        Player = Character
    })
    :AddComponent("SaveData", {
        SaveData = {}
    })
    :AddComponent("Npc", {
        Name = Character.Name
    })
    :AddComponent("MovementControls", {
        MaxWalkSpeedEntries = {},
        MaxJumpPowerEntries = {},
        MinWalkSpeedEntries = {},
        MinJumpPowerEntries = {}
    })

    if Character.Name == "Deflecting Guy" then
        NpcEntity:AddComponent("Parry", true)
    end

    self.Workshop:SpawnEntity(NpcEntity)
end

return NpcBuilderSystem