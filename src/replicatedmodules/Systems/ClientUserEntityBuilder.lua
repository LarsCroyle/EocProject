local Fusion = require(game.ReplicatedStorage.Modules.Packages.Fusion)
local New = Fusion.New
local Children = Fusion.Children
local Computed = Fusion.Computed
local Value = Fusion.Value

local Trove = require(game.ReplicatedStorage.Modules.Packages.Trove)
local Healthbar = require(game.ReplicatedStorage.Modules.Fusion.Components.Healthbar)
local RunService = game:GetService("RunService")

local ClientUserEntityBuilder = {
    Name = "ClientUserEntityBuilder",
    Priority = "First",
    Tag = {
        "TAG_NO_TAG"
    }
}

local function CharacterAdded(Character, UserEntity, Player, FusionValues)
    local Humanoid = Character:WaitForChild("Humanoid")
    local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    local Head = Character:WaitForChild("Head")

    local CharacterTrove = Trove.new()
    CharacterTrove:AttachToInstance(Character)

    FusionValues.MaxHealth:set(Humanoid.MaxHealth)
    FusionValues.Health:set(Humanoid.Health)

    CharacterTrove:Add(Humanoid.HealthChanged:Connect(function()
        FusionValues.Health:set(math.clamp(Humanoid.Health, 0, Humanoid.MaxHealth))
    end))

    CharacterTrove:Add(Humanoid.Changed:Connect(function(Property)
        if Property == "MaxHealth" then
            FusionValues.MaxHealth:set(Humanoid.MaxHealth)
        end
    end))

    local SmoothMouseLockFollowGyro = Instance.new("BodyGyro")
    SmoothMouseLockFollowGyro.MaxTorque = Vector3.new(1e4, 1e4, 1e4)
    SmoothMouseLockFollowGyro.P = 17000
    SmoothMouseLockFollowGyro.D = 400
    SmoothMouseLockFollowGyro.Name = "SmoothMouseLockFollowGyro"
    SmoothMouseLockFollowGyro.Parent = HumanoidRootPart

    local _, Component = UserEntity:AddComponent("Character", {
        Character = Character,
        Humanoid = Humanoid,
        RootPart = HumanoidRootPart
    })
    CharacterTrove:Add(Component)

    local _, Component = UserEntity:AddComponent("SmoothMouseLockFollow", {
        BodyGyro = SmoothMouseLockFollowGyro
    })
    CharacterTrove:Add(Component)

    CharacterTrove:Add(RunService.RenderStepped:Connect(function(DeltaTime)
        Humanoid.CameraOffset = Humanoid.CameraOffset:Lerp(( HumanoidRootPart.CFrame + Vector3.new(0, 1.5, 0) ):PointToObjectSpace( Head.Position ), DeltaTime * 20)
    end))

    local Running = HumanoidRootPart:WaitForChild("Running")
    --Running.SoundId = "rbxassetid://13233516113"
    Running.Volume = 0
    --Running.PlaybackSpeed = 1.4

    local Animate = Character:WaitForChild("Animate")
    Animate.Disabled = true

    local _, Component = UserEntity:AddComponent("MovementAnimationSet", {
        Walk = "rbxassetid://13584085812",
        Sprint = "rbxassetid://13221735100",
        Jump = "rbxassetid://125750702",--"rbxassetid://", --13422261235
        Fall = "rbxassetid://180436148",
        Sit = "rbxassetid://178130996",
        Idle = "rbxassetid://13221448557",

        MovementSoundSet = {
            ["Concrete"] = {
                "rbxassetid://13584190276"
            },
            ["Grass"] = {
                "rbxassetid://13584043291"
            }
        }
    })
    CharacterTrove:Add(Component)

    local _, Component = UserEntity:AddComponent("MovementControls", {
        MaxWalkSpeedEntries = {},
        MinWalkSpeedEntries = {},
        MaxJumpPowerEntries = {},
        MinJumpPowerEntries = {}
    })
    CharacterTrove:Add(Component)

    CharacterTrove:Add(function()
        UserEntity:RemoveComponent("AnimationCache")
    end)

    CharacterTrove:Add(Player.CharacterRemoving:Connect(function()
        CharacterTrove:Destroy()
    end))
end

function ClientUserEntityBuilder:Boot()
    local Player = game.Players.LocalPlayer

    local UserEntity = self.Workshop:CreateEntity({
        EntityName = Player.Name .. "UserEntity",
    })
    :AddComponent("Camera", workspace.CurrentCamera)
    :AddComponent("Inventory", {
        Items = {},
        Hotbar = {},
        ChestItems = {},
        MenuOpen = false,
        ChestOpen = false,
        Equipped = -1,
        Armor = {
            Head = "None",
            Torso = "None",
            Legs = "None",
            Arms = "None"
        }
    })

    local FusionValues = {
        Health = Value(100),
        MaxHealth = Value(100),
    }

    Healthbar(FusionValues)

    if Player.Character then
        CharacterAdded(Player.Character, UserEntity, Player, FusionValues)
    end

    Player.CharacterAdded:Connect(function(Character)
        CharacterAdded(Character, UserEntity, Player, FusionValues)
    end)

    self.Workshop:SpawnEntity(UserEntity)
end

return ClientUserEntityBuilder