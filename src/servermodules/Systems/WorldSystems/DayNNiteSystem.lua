local Lighting = game:GetService("Lighting")

local DayNNiteSystem = {
    Name = "DayNNiteSystem",
    Priority = "Update",
    Tag = {
        "World_No_Tag"
    }
}

function DayNNiteSystem:Update(_, DeltaTime)
    Lighting.ClockTime = Lighting.ClockTime + DeltaTime / 16
end

return DayNNiteSystem