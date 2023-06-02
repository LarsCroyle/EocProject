return function(self, SequenceSystem, MoveData, ...)
    local UserEntity = self.UserEntity
    local ControlTable, CustomTargetEntities = ...

    local TargetEntities = CustomTargetEntities or {UserEntity}

    for _, Target in pairs(TargetEntities) do
        self:Trigger("Event", "Movement_Controls", ControlTable)
    end
end