-- function to obtain sounds from the action dictionary
local ActionDictionary = require(game.ServerStorage.Modules.ActionDictionary)

return function(Data)
    local UserEntity = Data.UserEntity
    local SoundId = Data.SoundId

    local ToolName, AnimationName = table.unpack(string.split(SoundId, "."))
    if ToolName and AnimationName then
        local ActionDataSet = ActionDictionary.GetActionDataSet(ToolName)
        if ActionDataSet then
            SoundId = ActionDataSet.Assets.Sounds[AnimationName]
        end
    elseif not AnimationName then
        local Inventory = UserEntity:Get("Inventory")
        local Equipped = Inventory.Equipped
        local EquippedItem = Inventory.Hotbar[Equipped].Name

        local ActionDataSet = ActionDictionary.GetActionDataSet(EquippedItem)
        if ActionDataSet then
            SoundId = ActionDataSet.Assets.Sounds[ToolName]
        end
    end

    return SoundId
end