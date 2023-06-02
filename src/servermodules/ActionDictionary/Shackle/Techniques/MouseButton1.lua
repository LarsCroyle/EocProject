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
local HeavyHitSound = {
    Call = "PlaySound",
    Arguments = {
        SoundId = 9117969892,
        Parent = "__TargetRootPart"
    }
}
return {
    Speed = 1.5,
    Action = {
        {0, function(self)
            local UserEntity = self.UserEntity
            local Character = UserEntity:Get("Character").Character
            local Player = UserEntity:Get("Player").Player
            local ActionInformation = self.Action.ActionMetaData.ActionInformation
            local ActionTrove = self.Action.ActionMetaData.Trove
            local Inventory = UserEntity:Get("Inventory")
            local Equipped = Inventory.Equipped
            local EquippedItem = Inventory.Hotbar[Equipped]

            if not EquippedItem then
                EquippedItem = "Shackle"
            else
                EquippedItem = EquippedItem.Name
            end

            if EquippedItem == "None" then
                EquippedItem = "Shackle"
            end

            -- fetch the current basic attack state
            local BasicAttackState = UserEntity:Get("BasicAttackState")
            if not BasicAttackState then
                UserEntity:AddComponent("BasicAttackState", {
                    Count = 0,
                })
                BasicAttackState = UserEntity:Get("BasicAttackState")
            end

            -- incrementing and clamping the basic attack state
            local Count = BasicAttackState.Count
            local MaxBasicAttackCount = ActionInformation.MaxBasicAttackCount or 4
            Count = Count + 1
            if Count > MaxBasicAttackCount then
                Count = 1
            end

            -- playing the sub sequence
            local MoveSequence = ActionInformation["BasicAttack_" .. Count]
            if not MoveSequence then
                MoveSequence = ActionInformation["BasicAttack_1"]
            end
            -- updating the basic attack state and using the state to configure animations and sounds
            self:Trigger("PlayAnimation", EquippedItem .. ".BasicAttack" .. Count, {
                Speed = self:GetSpeed()
            })
            self:Trigger("PlaySound", "SwingSound")
            UserEntity:Set("BasicAttackState", "Count", Count)

            task.delay(1.4, function()
                if UserEntity:Get("BasicAttackState").Count == Count then
                    UserEntity:Set("BasicAttackState", "Count", 0)
                end
            end)

            self:Trigger("RunClient", "AddMovementControl", {
                MovementControlSet = {
                    MaxWalkSpeedEntries = {
                        12
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
                    self:Trigger("StopAnimation", EquippedItem .. ".BasicAttack" .. Count)
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
        MaxBasicAttackCount = 4,
        BasicAttack_1 = {
            {0, "Start"},
            {15, "Attack", "Basic_Attack"},
            {30, "End"}
        },
        BasicAttack_4 = {
            {0, "Start"},
            {15, "Attack", "Finisher_Basic_Attack"},
            {30, function(self)
                local UserEntity = self.UserEntity

                UserEntity:AddComponent("MouseButton1Cooldown", true)

                task.delay(1.5, function()
                    UserEntity:RemoveComponent("MouseButton1Cooldown")
                end)
            end},
            {30, "End"}
        },
        Basic_Attack = {
            Hitbox = {
                Type = "Box",
                Size = Vector3.new(8, 10, 7.7),
                Offset = Vector3.new(0, 0, -3.5),
                Origin = "__RootPart.CFrame"
            },
            Attack = {
                Stun = 0.67,
                Damage = 4,
                DamageEvents = {
                    LightHitEffect,
                    LightHitSound
                },
                Parryable = true
            }
        },
        Finisher_Basic_Attack = {
            Hitbox = {
                Type = "Box",
                Size = Vector3.new(8, 10, 8),
                Offset = Vector3.new(0, 0, -3.7),
                Origin = "__RootPart.CFrame"
            },
            Attack = {
                Damage = 10,
                Stun = 1,
                Knockback = {
                    Type = "Velocity",
                    RelativeTo = "Target",
                    Force = 30,
                    Velocity = Vector3.new(0, 15, 0),
                    Time = 0.25
                },
                DamageEvents = {
                    LightHitEffect,
                    HeavyHitSound
                },
                Ragdoll = {
                    Duration = 1
                },
                Parryable = true
            }
        }
    }
}