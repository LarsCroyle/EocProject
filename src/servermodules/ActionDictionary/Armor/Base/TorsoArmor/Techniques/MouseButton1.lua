return {
    Action = {
        {0, function(self)
            local UserEntity = self.UserEntity
            local Inventory = UserEntity:Get("Inventory")

            local Equipped = Inventory.Equipped
            local Hotbar = Inventory.Hotbar
            local ToolName = Hotbar[Equipped].Name

            local Armor = Inventory.Armor
            local TorsoArmor = Armor.Torso
            local Sequence
            if TorsoArmor and TorsoArmor == ToolName then
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

            if TorsoArmor and TorsoArmor == ToolName then
                Inventory.Armor.Torso = "None"
            else
                Inventory.Armor.Torso = ToolName
            end
        end}
    },
    ActionInformation = {
        Active = true,
        DonArmor = {
            {0, "PlayAnimation", "EquipTorsoArmor"},
            {30, "Rig", "__ToolName"}
        },
        RemoveArmor = {
            {0, "PlayAnimation", "UnequipTorsoArmor"},
            {30, "DestroyRig", "__ToolName"}
        },
    }
}