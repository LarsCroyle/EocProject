--[[
    Common function for playing an animation on a character or an AbilityModel such as a Stand.
    {0, "PlayAnimation", "AnimationId"/AnimationName, Data}
--]]
local ActionDictionary = require(game.ServerStorage.Modules.ActionDictionary)

return function(self, _, ...)
    local UserEntity = self.UserEntity

    local AnimationId, Data, CustomEntity = ...
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

    if CustomEntity then
        UserEntity = CustomEntity
    end

    local AnimationComponent = UserEntity:Get("AnimationQueue")
    if not AnimationComponent then
        UserEntity:AddComponent("AnimationQueue", {
            Animations = {},
        })
    end
    UserEntity:Get("AnimationQueue").Animations[AnimationId] = {
        AnimationId = AnimationId,
        Data = Data
    }
end