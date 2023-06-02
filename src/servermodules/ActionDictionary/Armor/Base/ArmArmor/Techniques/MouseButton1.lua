return {
    Action = {
        {0, function(self)
            local UserEntity = self.UserEntity
            local Inventory = UserEntity:Get("Inventory")

            local Equipped = Inventory.Equipped
            local Hotbar = Inventory.Hotbar
            local ToolName = Hotbar[Equipped].Name

            local Armor = Inventory.Armor
            local ArmsArmor = Armor.Arms
            local Sequence
            if ArmsArmor and ArmsArmor == ToolName then
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

            if ArmsArmor and ArmsArmor == ToolName then
                Inventory.Armor.Arms = "None"
            else
                Inventory.Armor.Arms = ToolName
            end
        end}
    },
    ActionInformation = {
        Active = true,
        DonArmor = {
            {0, "PlayAnimation", "EquipArmsArmor"},
            {30, "Rig", "__ToolName"}
        },
        RemoveArmor = {
            {0, "PlayAnimation", "UnequipArmsArmor"},
            {30, "DestroyRig", "__ToolName"}
        },
    }
}