return {
    Action = {
        {0, function(self)
            local UserEntity = self.UserEntity
            local Inventory = UserEntity:Get("Inventory")

            local Equipped = Inventory.Equipped
            local Hotbar = Inventory.Hotbar
            local ToolName = Hotbar[Equipped].Name

            local Armor = Inventory.Armor
            local HeadArmor = Armor.Head
            local Sequence
            if HeadArmor and HeadArmor == ToolName then
                Sequence = self:PlaySequence("RemoveArmor")
            else
                Sequence = self:PlaySequence("DonArmor")
            end

            while Sequence:IsPlaying() do
                task.wait()
                if not self:IsPlaying() then
                    Sequence:Stop()
                end
            end

            if HeadArmor and HeadArmor == ToolName then
                Inventory.Armor.HeadArmor = "None"
            else
                Inventory.Armor.HeadArmor = ToolName
            end
        end}
    },
    ActionInformation = {
        Active = true,
        DonArmor = {
            {0, "PlayAnimation", "EquipHeadArmor"},
            {30, function(self)
                local UserEntity = self.UserEntity
                local Character = UserEntity:Get("Character").Character

                for _, Part in pairs(Character:GetChildren()) do
                    if Part:IsA("Accessory") then
                        for _, Child in pairs(Part:GetChildren()) do
                            if Child:IsA("BasePart") then
                                Child:SetAttribute("Transparency", Child.Transparency)
                                Child.Transparency = 1
                            end
                        end
                    end
                end
            end},
            {30, "Rig", "__ToolName"}
        },
        RemoveArmor = {
            {0, "PlayAnimation", "UnequipHeadArmor"},
            {30, function(self)
                local UserEntity = self.UserEntity
                local Character = UserEntity:Get("Character").Character

                for _, Part in pairs(Character:GetChildren()) do
                    if Part:IsA("Accessory") then
                        for _, Child in pairs(Part:GetChildren()) do
                            if Child:IsA("BasePart") then
                                Child.Transparency = Child:GetAttribute("Transparency") or 0
                            end
                        end
                    end
                end
            end},
            {30, "DestroyRig", "__ToolName"}
        },
    }
}