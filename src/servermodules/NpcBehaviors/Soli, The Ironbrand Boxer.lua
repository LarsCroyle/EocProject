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

    -- hi enalysis
    --h hi ted :3

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

    if not NpcUserEntity:Get("BattleMusicPlaying") then
        NpcUserEntity:SetComponent("BattleMusicPlaying", true)

        RootPart["Epic Battle Simulator"]:Play()
    end

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

    if Distance < 10 then
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
        NpcUserEntity:RemoveComponent("NpcTracking")

        if not HostileUserEntity then
            return
        end

        local ActionSequence = HostileUserEntity:Get("ActionSequence")
        if ActionSequence and ActionSequence:GetFrame() > math.random(0, 10) and ActionSequence.Name ~= "Parry" then
            ActionMethod("Verge Ironbrand", "F", Character)
        else
            if not NpcUserEntity:Get("ECooldown") then
                ActionMethod("Verge Ironbrand", "E", Character)
            else
                if HostileUserEntity:Get("Knockdowned") then
                    ActionMethod("Verge Ironbrand", "B", Character)
                else
                    ActionMethod("Verge Ironbrand", "MouseButton1", Character)
                end
            end
        end
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
        ItemName = "Verge Ironbrand"
    })

    EquipItem({
        UserEntity = self.NpcUserEntity,
        HotbarIndex = 1
    })
end

return Behavior