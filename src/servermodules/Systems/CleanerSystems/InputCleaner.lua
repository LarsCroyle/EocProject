local InputCleaner = {
    Name = "InputCleaner",
    Tag = {
        "Input",
        "InputActionProcessed"
    },
    Priority = "Last",
}

function InputCleaner:Update(TaggedEntities)
    for _, InputEntity in TaggedEntities do
        task.defer(function()
            InputEntity:RemoveComponent("Input")
            InputEntity:RemoveComponent("InputActionProcessed")
        end)
    end
end

return InputCleaner