local ActionDictionary = require(game.ServerStorage.Modules.ActionDictionary)

return function(self, SequenceSystem, ...)
    local UserEntity = self.UserEntity
    local Character = UserEntity:Get("Character").Character
    local Humanoid = Character:WaitForChild("Humanoid")

    local RigName = ...
    local Rig = ActionDictionary.GetActionDataSet(RigName).Assets.Rig
    for _, RigPart in pairs(Rig:GetChildren()) do
        if RigPart:IsA("BasePart") then
            local CharacterPart = Character:FindFirstChild(RigPart.Name)
            local Joint = Rig:FindFirstChild(RigPart.Name .. "Joint")

            if CharacterPart and Joint then
                RigPart = RigPart:Clone()
                RigPart.Anchored = false
                RigPart.Parent = CharacterPart

                Joint = Joint:Clone()
                Joint.Name = RigName .. Joint.Name
                Joint.Part0 = CharacterPart
                Joint.Part1 = RigPart
                Joint.Parent = CharacterPart

                RigPart.Name = RigName .. RigPart.Name
            end
        elseif RigPart:IsA("Folder") then
            local CharacterPart = Character:FindFirstChild(RigPart.Name)
            for _, Part in pairs(RigPart:GetChildren()) do
                local Joint = Part:FindFirstChildOfClass("Motor6D")

                if not Joint then
                    continue
                end

                local RigPart = Part:Clone()
                local RigJoint = Joint:Clone()

                --RigPart.Name = RigName .. RigPart.Name
                RigPart.Parent = CharacterPart

                --RigJoint.Name = RigName .. RigJoint.Name
                RigJoint.Part0 = CharacterPart
                RigJoint.Part1 = RigPart
                RigJoint.Parent = CharacterPart
            end
        end
    end
end