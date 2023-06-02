local Access = require(game.ReplicatedStorage.Modules.Recs.Access)
local Workshop = Access.GetWorkshop()
local HitboxMethod = require(game.ServerStorage.Modules.Functions.HitboxMethod)
return {
    Action = {
        {0, function(self)
            local UserEntity = self.UserEntity
            local Character = UserEntity:Get("Character").Character
            local RootPart = Character.PrimaryPart
            local Player = UserEntity:Get("Player").Player
            local ActionInformation = self.Action.ActionMetaData.ActionInformation
            local ActionTrove = self.Action.ActionMetaData.Trove
            local Inventory = UserEntity:Get("Inventory")
            local Equipped = Inventory.Equipped
            local EquippedItem = Inventory.Hotbar[Equipped]


            local HitboxInformation = ActionInformation.Hitbox
            HitboxInformation.Ignore = {Character}
            HitboxInformation.UserEntity = UserEntity

            local TargetEntities = HitboxMethod(HitboxInformation)

            for _, HitCharacter in TargetEntities do
                local HitUserEntity = Workshop:GetEntity(HitCharacter.Name .. "UserEntity")
                if not HitUserEntity then
                    continue
                end

                local IsKnockdowned = HitUserEntity:Get("Knockdowned")
                if not IsKnockdowned then
                    continue
                end

                self:Trigger("RunClient", "AddMovementControl", {
                    MovementControlSet = {
                        MaxWalkSpeedEntries = {
                            0
                        },
                        MaxJumpPowerEntries = {
                            0
                        }
                    },
                    Name = "Grip",
                    Mode = true
                }, Player)

                local Sequence = self:PlaySequence(ActionInformation.Grip, HitCharacter)

                ActionTrove:Add(function()
                    self:Trigger("RunClient", "AddMovementControl", {
                        Name = "Grip",
                        Mode = false
                    }, Player)

                    if self.Action.Interrupted then
                        self:Trigger("StopSound", "SwingSound")
                        self:Trigger("StopAnimation", "Default.Grip")
                    end
                end)

                while Sequence:IsPlaying() do
                    task.wait()
                    if not self:IsPlaying() then
                        Sequence:Stop()
                    end
                end

                return
            end
        end}
    },
    ActionInformation = {
        Grip = {
            {0, "PlayAnimation", "Default.Grip"},
            --{60, "PlaySound", "Gripped"},
            {60, function(self, Target)
                --Target:RemoveComponent("Knockdowned")
                local Character = Target--:Get("Character").Character
                local Humanoid = Character:FindFirstChildOfClass("Humanoid")

                Humanoid.Health = 0
            end}
        },
        Hitbox = {
            Type = "Box",
            Size = Vector3.new(8,9,7.7),
            Offset = Vector3.new(0, 0, 0),
            Origin = "__RootPart.CFrame"
        },
        Active = true
    }
}