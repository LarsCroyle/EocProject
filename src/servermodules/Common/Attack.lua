-- 
--[[
    Common function for the shortest way to cast a simple attack.
    The AttackName refers to the index of the Attack table in the MoveInformation table, so these must match if you want to use this function.
    It will automatically draw from that table to create a hitbox and call the attack on each target.

    {0, "Attack", "AttackName"}
--]]
local Hitbox = require(game.ServerStorage.Modules.Functions.HitboxMethod)
local Attack = require(game.ServerStorage.Modules.Functions.AttackMethod)
local TableUtil = require(game.ReplicatedStorage.Modules.Packages.TableUtil)

return function(self, SequenceSystem, ...)
    local UserEntity = self.UserEntity
    local Character = UserEntity:Get("Character").Character
    local Action = self.Action
    local ActionTrove = Action.ActionMetaData.Trove
    local ActionInformation = Action.ActionMetaData.ActionInformation or {}

    local Name, TargetEntities = ...
    if not Name then
        Name = Action.Name
    end

    local AttackInformation = ActionInformation[Name] or {}
    AttackInformation = TableUtil.Copy(AttackInformation, true)

    if not TargetEntities and AttackInformation.Hitbox then
        local HitboxInformation = AttackInformation.Hitbox
        HitboxInformation.Ignore = {Character}
        HitboxInformation.UserEntity = UserEntity

        TargetEntities = Hitbox(HitboxInformation)
    end

    if Action.ActionMetaData.Target and typeof(TargetEntities[1]) == "string" then
        for Index, Value in pairs(TargetEntities) do
            if Value == "__Target" then
                TargetEntities[Index] = Action.ActionMetaData.Target
            end
        end
    end

    if not TargetEntities then
        return
    end

    if not self.AlreadyHit then
        self.AlreadyHit = {}
    end

    for _, Target in pairs(TargetEntities) do
        if self.AlreadyHit[Target] then
            continue
        end
        self.AlreadyHit[Target] = true
        local AttackResult = Attack({
            UserEntity = UserEntity,
            Character = Character,
            AttackInformation = AttackInformation,
            Target = Target
        })
        if AttackInformation.SingleTarget then
            return AttackResult
        end
    end
end