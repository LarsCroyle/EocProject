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
        SoundId = 6276679056,
        Parent = "__TargetRootPart"
    }
}
local HeavyHitSound = {
    Call = "PlaySound",
    Arguments = {
        SoundId = 3939948074,
        Parent = "__TargetRootPart"
    }
}

return {
    Speed = 1.25,
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
                EquippedItem = "Rat Sword"
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
            local MaxBasicAttackCount = ActionInformation.MaxBasicAttackCount or 5
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
            self:Trigger("PlayAnimation",  "SwordBase.BasicAttack" .. Count, {
                Speed = self:GetSpeed()
            })
            self:Trigger("PlaySound", "SwordBasee.SwingSound")
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
                    self:Trigger("StopSound", "SwordBase.SwingSound")
                    self:Trigger("StopAnimation", "SwordBase.BasicAttack" .. Count)
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
        BasicAttack_1 = {
            {0, "Start"},
            {20, 27, "Attack", "Basic_Attack"},
            {41, "End"}
        },
        BasicAttack_2 = {
            {0, "Start"},
            {20, 27, "Attack", "Basic_Attack"},
            {41, "End"}
        },
        BasicAttack_3 = {
            {0, "Start"},
            {17, 26, "Attack", "Basic_Attack"},
            {41, "End"}
        },
        BasicAttack_4 = {
            {0, "Start"},
            {20, 27, "Attack", "Basic_Attack"},
            {41, "End"}
        },
        BasicAttack_5 = {
            {0, "Start"},
            {27, 45, "Attack", "Finisher_Basic_Attack"},
            {62, function(self)
                local UserEntity = self.UserEntity

                UserEntity:AddComponent("MouseButton1Cooldown", true)

                task.delay(1.5, function()
                    UserEntity:RemoveComponent("MouseButton1Cooldown")
                end)
            end},
            {62, "End"}
        },
        Basic_Attack = {
            Hitbox = {
                Type = "Box",
                Size = "__Weapon.Size",
                Offset = Vector3.new(0, 0, 0),
                Origin = "__Weapon.CFrame"
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
                Size = "__Weapon.Size",
                Offset = Vector3.new(0, 0, 0),
                Origin = "__Weapon.CFrame"
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