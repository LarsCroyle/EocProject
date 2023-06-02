return {
    Action = {
        {0, function(self)
            local UserEntity = self.UserEntity
            local Inventory = UserEntity:Get("Inventory")

            local Equipped = Inventory.Equipped
            local Hotbar = Inventory.Hotbar
            local ToolName = Hotbar[Equipped].Name

            local Armor = Inventory.Armor
            local LegsArmor = Armor.Legs
            local Sequence
            if LegsArmor and LegsArmor == ToolName then
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

            if LegsArmor and LegsArmor == ToolName then
                Inventory.Armor.Legs = "None"
            else
                Inventory.Armor.Legs = ToolName
            end
        end}
    },
    ActionInformation = {
        Active = true,
        DonArmor = {
            {0, "PlayAnimation", "EquipLegsArmor"},
            {30, "Rig", "__ToolName"}
        },
        RemoveArmor = {
            {0, "PlayAnimation", "UnequipLegsArmor"},
            {30, "DestroyRig", "__ToolName"}
        },
    }
}