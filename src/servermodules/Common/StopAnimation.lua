--[[
    Common function for stopping an animation on a character or an AbilityModel such as a Stand.
    {0, "StopAnimation", "AnimationId"/AnimationName}
--]]
local ActionDictionary = require(game.ServerStorage.Modules.ActionDictionary)

return function(self, SequenceSystem, ...)
    local UserEntity = self.UserEntity
    local Character = UserEntity:Get("Character").Character

    local AnimationId, Data = ...
    if not AnimationId then
        return
    end
    if not Data then
        Data = {}
    end

    if typeof(AnimationId) == "string" then
        local ToolName, AnimationName = table.unpack(string.split(AnimationId, "."))
        if ToolName and AnimationName then
            local ActionDataSet = ActionDictionary.GetActionDataSet(ToolName)
            if ActionDataSet then
                AnimationId = ActionDataSet.Assets.Animations[AnimationName]
            end
        end
    end

    if typeof(AnimationId) == "number" then
        AnimationId = tostring(AnimationId)
    end

    local AnimationComponent = UserEntity:Get("StopAnimationQueue")
    if not AnimationComponent then
        UserEntity:AddComponent("StopAnimationQueue", {
            Animations = {},
        })
    end

    UserEntity:Get("StopAnimationQueue").Animations[AnimationId] = AnimationId
end