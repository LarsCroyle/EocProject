local GetCommon = require(game.ServerStorage.Modules.Functions.GetCommonMethod)

local KnockdownedSystem = {
    Name = "KnockdownedSystem",
    Priority = "Update",
    Tag = {
        "SaveData",
        "Character",
        "Knockdowned"
    }
}

function KnockdownedSystem:Update(TaggedEntities)
    for _, TaggedEntity in pairs(TaggedEntities) do
        self:ProcessEntity(TaggedEntity)
    end
end

function KnockdownedSystem:ProcessEntity(UserEntity)
    local Character = UserEntity:Get("Character").Character
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    if Humanoid.Health > 15 then
        if UserEntity:Get("KnockdownWalkspeed") then
            UserEntity:RemoveComponent("KnockdownWalkspeed")

            GetCommon("RunClient")({
                UserEntity = UserEntity
            }, self, "AddMovementControl", {
                Name = "KnockdownWalkspeed",
                Mode = false
            }, UserEntity:Get("Player").Player)
        end

        GetCommon("StopAnimation")({
            UserEntity = UserEntity
        }, KnockdownedSystem, "Default.Knockdowned")

        UserEntity:RemoveComponent("Knockdowned")
    else
        if Humanoid.Health <= 0 then
            UserEntity:RemoveComponent("Knockdowned")
            UserEntity:RemoveComponent("KnockdownWalkspeed")
        end
        if not UserEntity:Get("KnockdownWalkspeed") then
            UserEntity:AddComponent("KnockdownWalkspeed", true)

            GetCommon("RunClient")({
                UserEntity = UserEntity
            }, self, "AddMovementControl", {
                MovementControlSet = {
                    MaxWalkSpeedEntries = {
                        0
                    },
                    MaxJumpPowerEntries = {
                        0
                    }
                },
                Name = "KnockdownWalkspeed",
                Mode = true
            }, UserEntity:Get("Player").Player)

            GetCommon("PlayAnimation")({
                UserEntity = UserEntity
            }, KnockdownedSystem, "Default.Knockdowned")
        end
    end
end

return KnockdownedSystem