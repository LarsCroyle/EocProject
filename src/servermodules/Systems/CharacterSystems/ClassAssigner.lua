local ClassAssignerSystem = {
    Name = "ClassAssigner",
    Priority = "Update",
    Tag = {
        "SaveData",
        "!Classes"
    }
}

function ClassAssignerSystem:Update(TaggedEntities)
    for _, TaggedEntity in pairs(TaggedEntities) do
        self:ProcessUserEntity(TaggedEntity)
    end
end

function ClassAssignerSystem:ProcessUserEntity(UserEntity)
    local SaveData = UserEntity:Get("SaveData").SaveData
    local Classes = SaveData.Classes

    UserEntity:AddComponent("Classes", Classes)
end

return ClassAssignerSystem