--[[
    This is a common move function that adds or removes a component from the user entity of the person using the move.
    This is useful for adding or removing components that are used to track the state of a move.

    {0, "Component", "Add"/"Remove", "ComponentName", ComponentData}
--]]
return function(self, SequenceSystem, ...)
    local UserEntity = self.UserEntity
    local Character = UserEntity:Get("Character").Character

    local Adding, ComponentName, ComponentData, CustomEntity = ...

    if CustomEntity then
        UserEntity = CustomEntity
    end

    if Adding == "Add" then
        UserEntity:AddComponent(ComponentName, ComponentData)
        return {
            Destroy = function()
                UserEntity:RemoveComponent(UserEntity:GetComponent(ComponentName))
            end
        }
    else
        UserEntity:RemoveComponent(ComponentName)
    end
end