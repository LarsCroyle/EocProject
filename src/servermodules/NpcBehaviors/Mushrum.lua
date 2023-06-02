local Access = require(game.ReplicatedStorage.Modules.Recs.Access)
local Workshop = Access.GetWorkshop()
local ActionMethod = require(game.ServerStorage.Modules.Functions.ActionMethod)
local GetNearestHostile = require(game.ServerStorage.Modules.Functions.Npc.GetNearestHostile)
local GetCommon = require(game.ServerStorage.Modules.Functions.GetCommonMethod)
local GetUserEntityFromCharacter = require(game.ServerStorage.Modules.Functions.GetUserEntityFromCharacter)
local AddItem = require(game.ServerStorage.Modules.Functions.Items.AddItem)
local EquipItem = require(game.ServerStorage.Modules.Functions.Items.EquipItem)

local Behavior = {}
Behavior.__index = Behavior

function Behavior.new(NpcUserEntity)
    local self = setmetatable({}, Behavior)

    self.NpcUserEntity = NpcUserEntity
    self.Animated = true
    self.MovementAnimationSet = {
        Idle = "rbxassetid://13463906798",
        Walk = "rbxassetid://13463908433"
    }
    return self
end

function Behavior:GetHostileList()
    local NpcUserEntity = self.NpcUserEntity
    local Hostiles = NpcUserEntity:Get("DamagedBy")
    local HostileList = NpcUserEntity:Get("HostileList")

    if not Hostiles and not HostileList then
        return
    end

    if #Hostiles == 0 and not HostileList then
        return
    end

    if not HostileList then
        HostileList = {}
        NpcUserEntity:SetComponent("HostileList", HostileList)
    else
        if #HostileList == 0 then
            NpcUserEntity:RemoveComponent("HostileList")
            return
        end
    end

    for _, Hostile in pairs(Hostiles) do
        if not table.find(HostileList, Hostile) then
            table.insert(HostileList, Hostile)
        end
    end

    return true, HostileList
end

function Behavior:Update() -- dont mind this scuffed npc implementation
    local NpcUserEntity = self.NpcUserEntity
    if not NpcUserEntity then
        return
    end
    if not NpcUserEntity:Get("Character") then
        return
    end

    local Character = NpcUserEntity:Get("Character").Character
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    local RootPart = Character:FindFirstChild("HumanoidRootPart")

    RootPart:SetNetworkOwner(nil)

    if NpcUserEntity:Get("Knockdowned") then
        return
    end

    local Continue, HostileList = self:GetHostileList()
    if not Continue then
        return
    end

    local Hostile, Distance = GetNearestHostile(HostileList, Character)

    if not Hostile then
        return
    end

    if Humanoid.Health <= 0 then
        Workshop:RemoveEntity(NpcUserEntity)
        Character:Destroy()
        return
    end

    local HostileUserEntity = GetUserEntityFromCharacter(Hostile)

    if Distance > 20 and not NpcUserEntity:Get("Sprinting") then
        NpcUserEntity:SetComponent("Sprinting", true)

        GetCommon("RunClient")({
            UserEntity = NpcUserEntity
        }, self, "AddMovementControl", {
            MovementControlSet = {
                MinWalkSpeedEntries = {
                    22
                }
            },
            Name = "Sprint",
            Mode = true
        }, Character)
    elseif Distance < 20 and NpcUserEntity:Get("Sprinting") then
        NpcUserEntity:RemoveComponent("Sprinting")

        GetCommon("RunClient")({
            UserEntity = NpcUserEntity
        }, self, "AddMovementControl", {
            Name = "Sprint",
            Mode = false
        }, Character)
    end

    if Distance < 8.5 then
        local LookAt = CFrame.lookAt(RootPart.Position, Hostile.HumanoidRootPart.Position)
        local X, Y, Z = LookAt:ToOrientation()

        if not RootPart:FindFirstChild("TrackingBodyGyro") then
            local BodyGyro = Instance.new("BodyGyro")
            BodyGyro.Name = "TrackingBodyGyro"
            BodyGyro.MaxTorque = Vector3.new(0, 10000000, 0)
            BodyGyro.P = 100000
            BodyGyro.D = 1000
            BodyGyro.CFrame = CFrame.new(RootPart.Position) * CFrame.fromOrientation(0, Y, 0)
            BodyGyro.Parent = RootPart
        else
            RootPart.TrackingBodyGyro.MaxTorque = Vector3.new(0, 10000000, 0)
            RootPart.TrackingBodyGyro.CFrame = CFrame.new(RootPart.Position) * CFrame.fromOrientation(0, Y, 0)
        end

        --RootPart.CFrame = CFrame.new(RootPart.Position) * CFrame.fromOrientation(0, Y, 0)

        NpcUserEntity:RemoveComponent("NpcTracking")

        ActionMethod("MushrumAttacks", "MouseButton1", Character)
    else
        if RootPart:FindFirstChild("TrackingBodyGyro") then
            RootPart.TrackingBodyGyro.MaxTorque = Vector3.new(0, 0, 0)
        end
        NpcUserEntity:SetComponent("NpcTracking", {
            Target = Hostile
        })
    end
end

function Behavior:Boot()
    task.wait(1)

    AddItem({
        UserEntity = self.NpcUserEntity,
        Type = "Hotbar",
        ItemName = "MushrumAttacks"
    })

    EquipItem({
        UserEntity = self.NpcUserEntity,
        HotbarIndex = 1
    })
end

return Behavior