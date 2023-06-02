local ActionMethod = require(game.ServerStorage.Modules.Functions.ActionMethod)
local AddItem = require(game.ServerStorage.Modules.Functions.Items.AddItem)
local EquipItem = require(game.ServerStorage.Modules.Functions.Items.EquipItem)

local PunchingGuyBehavior = {}
PunchingGuyBehavior.__index = PunchingGuyBehavior

function PunchingGuyBehavior.new(NpcUserEntity)
    local self = setmetatable({}, PunchingGuyBehavior)

    self.NpcUserEntity = NpcUserEntity
    self.Animated = true

    return self
end

function PunchingGuyBehavior:Update()
    local NpcUserEntity = self.NpcUserEntity
    if not NpcUserEntity then
        return
    end
    if not NpcUserEntity:Get("Character") then
        return
    end

    if NpcUserEntity:Get("Inventory").Equipped ~= 1 then
        return
    end

    if not NpcUserEntity:Get("Character").Character then
        return
    end

    local Character = NpcUserEntity:Get("Character").Character

    ActionMethod("Shackle", "MouseButton1", Character)
end

function PunchingGuyBehavior:Boot()
    task.wait(1)

    AddItem({
        UserEntity = self.NpcUserEntity,
        Type = "Hotbar",
        ItemName = "Shackle"
    })

    EquipItem({
        UserEntity = self.NpcUserEntity,
        HotbarIndex = 1
    })
end

return PunchingGuyBehavior