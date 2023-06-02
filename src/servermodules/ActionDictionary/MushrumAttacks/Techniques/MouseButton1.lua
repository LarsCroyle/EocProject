local LightHitEffect = {
    Call = "EmitParticles",
    Arguments = {
        Particle = "LightHitEffect",
        Target = "__Target"
    }
}
local LightHitSound = {
    Call = "PlaySound",
    Arguments = {
        SoundId = 9117969687,
        Parent = "__TargetRootPart"
    }
}
return {
    Speed = 1,
    Action = {
        {0, function(self)
            local UserEntity = self.UserEntity
            local Character = UserEntity:Get("Character").Character
            local Player = UserEntity:Get("Player").Player
            local ActionInformation = self.Action.ActionMetaData.ActionInformation
            local ActionTrove = self.Action.ActionMetaData.Trove
            local Inventory = UserEntity:Get("Inventory")
            local Equipped = Inventory.Equipped
            local EquippedItem = Inventory.Hotbar[Equipped].Name

            if EquippedItem == "None" then
                EquippedItem = "MushrumAttacks"
            end

            -- playing the sub sequence
            local MoveSequence = ActionInformation["BasicAttack"]
            -- updating the basic attack state and using the state to configure animations and sounds
            self:Trigger("PlayAnimation", EquippedItem .. ".BasicAttack", {
                Speed = self:GetSpeed()
            })
            self:Trigger("PlaySound", "SwingSound")

            self:Trigger("RunClient", "AddMovementControl", {
                MovementControlSet = {
                    MaxWalkSpeedEntries = {
                        4
                    },
                    MaxJumpPowerEntries = {
                        0
                    }
                },
                Name = "BasicAttack",
                Mode = true
            }, Player)

            local Sequence = self:PlaySequence(MoveSequence)

            ActionTrove:Add(function()
                self:Trigger("RunClient", "AddMovementControl", {
                    Name = "BasicAttack",
                    Mode = false
                }, Player)

                if self.Action.Interrupted then
                    self:Trigger("StopSound", "SwingSound")
                    self:Trigger("StopAnimation", EquippedItem .. ".BasicAttack")
                end
            end)

            while Sequence:IsPlaying() do
                task.wait()
                if not self:IsPlaying() then
                    Sequence:Stop()
                end
            end
        end}
    },
    ActionInformation = {
        Interruptable = true,
        MaxBasicAttackCount = 5,
        BasicAttack = {
            {0, "Start"},
            {15, "Attack", "Basic_Attack"},
            {30, "End"}
        },
        Basic_Attack = {
            Hitbox = {
                Type = "Box",
                Size = Vector3.new(8, 10, 9),
                Offset = Vector3.new(0, 0, -4.5),
                Origin = "__RootPart.CFrame"
            },
            Attack = {
                Stun = 0.67,
                Damage = 6,
                DamageEvents = {
                    LightHitEffect,
                    LightHitSound
                },
                Parryable = true
            }
        }
    }
}