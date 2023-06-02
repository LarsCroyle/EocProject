return function(Hotbar, Name)
    for _, Item in pairs(Hotbar) do
        if Item.Name == Name then
            return Item
        end
    end
end