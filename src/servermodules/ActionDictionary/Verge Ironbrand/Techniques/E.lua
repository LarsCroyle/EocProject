local TweenService = game:GetService("TweenService")
local LightHitEffect = {
    Call = "EmitParticles",
    Arguments = {
        Particle = "LightHitEffect",
        Target = "__Target"
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
    Name = "Edge Collision",
    Action = {
        {0, "PlayAnimation", "Verge Ironbrand.Edge Collision"},
        {0, "PlaySound", "EdgeCollisionWindup"},
        {0, function(self)
            local UserEntity = self.UserEntity
            local Player = UserEntity:Get("Player").Player
            local Character = UserEntity:Get("Character").Character
            local ActionTrove = self.Action.ActionMetaData.Trove

            self.Player = Player
            self.Character = Character

            local RightArm = Character:FindFirstChild("Right Arm")
            local VergeIronbrand = RightArm:FindFirstChild("Gun")

            local PointLight = VergeIronbrand:FindFirstChild("PointLight")
            PointLight.Brightness = 0
            PointLight.Range = 0

            local Flicker = VergeIronbrand:FindFirstChild("Charge")
            --for i, v in pairs(Flicker:GetChildren()) do
            --    v.Enabled = true
            --end

            self.Gun = VergeIronbrand
            self.PointLight = PointLight
            self.Flicker = Flicker
            self.Arm = RightArm:FindFirstChild("Arm")

            TweenService:Create(PointLight, TweenInfo.new(1.5), {Range = 2, Brightness = 9}):Play()

            self:Trigger("RunClient", "AddMovementControl", {
                MovementControlSet = {
                    MaxWalkSpeedEntries = {
                        8
                    },
                    MaxJumpPowerEntries = {
                        0
                    }
                },
                Name = "EdgeCollision",
                Mode = true
            }, Player)

            ActionTrove:Add(function()
                self:Trigger("RunClient", "AddMovementControl", {
                    Name = "EdgeCollision",
                    Mode = false
                }, Player)
            end)

            --self.Gun.Flash.Flash:Emit(4)
        end},
        {25, function(self)
            for i, v in pairs(self.Flicker:GetChildren()) do
                v.Enabled = true
            end
            --self.Gun.Attachment.Swirls.Enabled = true
        end},
        {54, function(self)
            self.Gun.Flash.Flash:Emit(4)
        end},
        {83, "PlaySound", "EdgeCollisionSfx"},
        {83, function(self)
            for i, v in pairs(self.Flicker:GetChildren()) do
                v.Enabled = false
            end
            self.PointLight.Brightness = 35
            self.PointLight.Range = 12

            TweenService:Create(self.PointLight, TweenInfo.new(0.15), {Range = 0, Brightness = 0}):Play()

            --self.Gun.Attachment.Swirls.Enabled = false

            for _, v in pairs(self.Gun:GetDescendants()) do
                if v:IsA("ParticleEmitter") and v.Name ~= "Flash" then
                    v:Emit(v:GetAttribute("EmitCount"))
                end
            end

            self.Gun.Lightnign2.Enabled = true

            self:Trigger("Attack", "EdgeCollision")

            self:Trigger("RunClient", "CameraShake", {
                Magnitude = 9,
                Roughness = 10,
                FadeInTime = 0.05,
                FadeOutTime = 0.65,
                PositionInfluence = Vector3.new(0.5, 0.5, 1),
                RotationInfluence = Vector3.new(3, 1, 2)
            }, self.Player)

            task.delay(1, function()
                self.Gun.Lightnign2.Enabled = false
            end)

            self:Trigger("RunClient", "GroundConeDebris", {
                Amount = 15,
                SpreadAngle = 30,
                Lifetime = 3,
                Range = 17,
                Character = self.Character
            }, self.Player)

            self.Gun.SpotLight.Brightness = 15

            TweenService:Create(self.Gun.SpotLight, TweenInfo.new(0.5), {Brightness = 0}):Play()

            local MapCastParams = RaycastParams.new()
            MapCastParams.FilterType = Enum.RaycastFilterType.Include
            MapCastParams.FilterDescendantsInstances = {workspace.Map}

            local HumanoidRootPart = self.Character.HumanoidRootPart
            local BoxCast = workspace:Blockcast(HumanoidRootPart.CFrame, Vector3.new(2, 2, 2), HumanoidRootPart.CFrame.LookVector * 10, MapCastParams)
            if BoxCast and BoxCast.Instance then
                local InstanceSizeScore = BoxCast.Instance.Size.Magnitude

                if InstanceSizeScore > 10 then
                    local Distance = BoxCast.Distance

                    local ZForce = 250 * (1 - (Distance / 10))

                    local Backforce = Instance.new("BodyVelocity")
                    Backforce.MaxForce = Vector3.one * 1e6
                    Backforce.P = 20000
                    Backforce.Velocity = -HumanoidRootPart.CFrame.LookVector * ZForce
                    Backforce.Parent = self.Character.HumanoidRootPart

                    task.delay(0.1, function()
                        Backforce:Destroy()
                    end)
                end
            end
        end},
        {95, function(self)
            for _, v in pairs(self.Arm:GetDescendants()) do
                if v:IsA("ParticleEmitter") and v.Name ~= "Flash" then
                    v:Emit(v:GetAttribute("EmitCount"))
                end
            end
        end}
    },
    ActionInformation = {
        Active = true,
        Interruptable = false,
        Cooldown = 10,
        EdgeCollision = {
            Hitbox = {
                Type = "Box",
                Size = Vector3.new(12, 10, 14),
                Offset = Vector3.new(0, 0, -6.5),
                Origin = "__RootPart.CFrame"
            },
            Attack = {
                Damage = 30,
                Stun = 1,
                Knockback = {
                    Type = "Velocity",
                    RelativeTo = "Target",
                    Force = 50,
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
                Parryable = false
            }
        }
    }
}