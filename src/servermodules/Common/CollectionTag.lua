--[[
    Used to add or remove a CollectionService tag from the character.
    This is useful for adding or removing a tag from the character when a move is used.

    {0, "CollectionTag", "Add"/"Remove", "TagName"}
--]]
local CollectionService = game:GetService("CollectionService")

return function(self, SequenceSystem, MoveData, ...)
    local UserEntity = self.UserEntity
    local Character = UserEntity:Get("Character").Character
    local Trove = MoveData.Trove

    local CollectionTagState, CollectionTagName = ...

    if CollectionTagState == "Add" then
        CollectionService:AddTag(Character, CollectionTagName)
    elseif CollectionTagState == "Remove" then
        CollectionService:RemoveTag(Character, CollectionTagName)
    end
end