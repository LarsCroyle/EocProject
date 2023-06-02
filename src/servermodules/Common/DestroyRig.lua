return function(self, SequenceSystem, ...)
    local RigName = ...
    local UserEntity = self.UserEntity
    local Character = UserEntity:Get("Character").Character

    for _, BasePart in pairs(Character:GetDescendants()) do
        if BasePart:IsA("BasePart") or BasePart:IsA("Motor6D") or BasePart:IsA("Weld") or BasePart:IsA("WeldConstraint") then
            if BasePart.Name:find(RigName) then
                BasePart:Destroy()
            end
        end
    end
end