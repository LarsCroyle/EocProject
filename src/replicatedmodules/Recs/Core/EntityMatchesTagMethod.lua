local function Not(ComponentsList, ComponentName)
	return not table.find(ComponentsList, ComponentName)
end

local function Has(ComponentsList, ComponentName)
	return table.find(ComponentsList, ComponentName)
end

return function(Entity, Tag)
    local ComponentsList = Entity:GetComponentsList()

    local PassedEqualityTest = true
    for _, ComponentName in Tag do
		if typeof(_) == "string" then
			continue
		end
    	if string.sub(ComponentName, 1, 1) == "!" then
			local ComponentName = string.sub(ComponentName, 2)
    		if not Not(ComponentsList, ComponentName) then
    			PassedEqualityTest = false
    			return
    		end
    	else
    		if not Has(ComponentsList, ComponentName) then
    			PassedEqualityTest = false
    			return
    		end
    	end
    end

    return PassedEqualityTest
end